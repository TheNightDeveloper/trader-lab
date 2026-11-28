package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"slices"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

func (s *Shadow) GetShadowSnapshot(ctx context.Context, req *connect.Request[labv1.GetShadowSnapshotRequest]) (*connect.Response[labv1.GetShadowSnapshotResponse], error) {
	id := req.Msg.GetDeploymentId()
	if id < 0 {
		return nil, invalid("شناسهٔ اجرای شَدو معتبر نیست")
	}
	res := &labv1.GetShadowSnapshotResponse{AssistantEnabled: s.assistantEnabled() && s.Market.Live != nil}
	for _, symbol := range s.Market.Symbols {
		if instrument.ResearchError(symbol) == nil {
			res.Symbols = append(res.Symbols, symbol)
		}
	}
	var selected db.ShadowDeployment
	var def strategy.RuleDefinition
	var hours []db.ShadowHour
	var bars []data.Bar
	var decisions []db.ShadowUserDecision
	asOf := s.Market.Clock.Now()
	err := s.Market.Store.InTxOptions(ctx, pgx.TxOptions{IsoLevel: pgx.RepeatableRead, AccessMode: pgx.ReadOnly}, func(q *db.Queries) error {
		list, err := q.ListShadowDeployments(ctx)
		if err != nil {
			return err
		}
		for _, d := range list {
			view, err := shadowDeploymentP(d)
			if err != nil {
				return err
			}
			res.Deployments = append(res.Deployments, view)
		}
		if id == 0 {
			if len(list) == 0 {
				return nil
			}
			selected = list[0]
		} else {
			selected, err = q.GetShadowDeployment(ctx, id)
			if errors.Is(err, pgx.ErrNoRows) {
				return connect.NewError(connect.CodeNotFound, errors.New("اجرای شَدو پیدا نشد"))
			}
			if err != nil {
				return err
			}
		}
		res.Selected, err = shadowDeploymentP(selected)
		if err != nil {
			return err
		}
		bars, hours, err = readShadowBars(ctx, q, selected.ID)
		if err != nil {
			return err
		}
		if len(hours) == 0 {
			res.EstimatedModelCost = shadowModelCost(selected, db.ShadowUsageRow{})
			return nil
		}
		usage, err := q.ShadowUsage(ctx, selected.ID)
		if err != nil {
			return err
		}
		res.InputTokens, res.OutputTokens = usage.InputTokens, usage.OutputTokens
		res.ModelAttempts, res.MissingModelUsage = usage.Attempts, usage.MissingUsage
		res.EstimatedModelCost = shadowModelCost(selected, usage)
		if selected.UserTrack {
			decisions, err = q.ShadowUserDecisions(ctx, selected.ID)
			if err != nil {
				return err
			}
		}
		def, err = shadowRule(ctx, q, selected)
		return err
	})
	if err != nil {
		return nil, err
	}
	if len(hours) == 0 {
		return connect.NewResponse(res), nil
	}
	if selected.SettledAt != nil && selected.SettledAt.Before(asOf) {
		asOf = *selected.SettledAt
	}
	if err := projectShadow(ctx, res, selected, def, hours, bars, decisions, asOf); err != nil {
		return nil, err
	}
	return connect.NewResponse(res), nil
}

func projectShadow(ctx context.Context, res *labv1.GetShadowSnapshotResponse, selected db.ShadowDeployment, def strategy.RuleDefinition, hours []db.ShadowHour, bars []data.Bar, decisions []db.ShadowUserDecision, through time.Time) error {
	warmup := len(bars) - len(hours)
	aiAllowed, userAllowed := make(map[time.Time]bool), make(map[time.Time]bool)
	byHour := make(map[int64]db.ShadowUserDecision, len(decisions))
	for _, decision := range decisions {
		byHour[decision.HourID] = decision
	}
	for i, row := range hours {
		if row.ObservedAt.After(through) {
			break // A row committed while the snapshot opened belongs to the next read.
		}
		bar := bars[warmup+i]
		obs := &labv1.ShadowObservation{Id: row.ID, CandleClosedAtUnixMs: ms(row.ClosedAt), ObservedAtUnixMs: ms(row.ObservedAt),
			DecisionAtUnixMs: ms(row.DecisionAt), Gate: shadowGateP[row.Gate], ReferenceClose: usdtP(bar.C.V)}
		if row.GateResolvedAt != nil && !row.GateResolvedAt.After(through) {
			obs.GateResolvedAtUnixMs = ms(*row.GateResolvedAt)
		} else if row.Gate != "no_signal" {
			obs.Gate = labv1.ShadowGate_SHADOW_GATE_PENDING
			if !through.Before(row.DecisionAt) || selected.State != "active" {
				obs.Gate = labv1.ShadowGate_SHADOW_GATE_UNAVAILABLE
			}
		}
		user := byHour[row.ID]
		if selected.UserTrack && row.Gate != "no_signal" {
			switch {
			case user.HourID != 0 && !user.DecidedAt.After(through):
				obs.UserDecidedAtUnixMs = ms(user.DecidedAt)
				obs.UserDecision = labv1.ShadowUserDecision_SHADOW_USER_DECISION_SKIP
				if user.Allow {
					obs.UserDecision = labv1.ShadowUserDecision_SHADOW_USER_DECISION_ALLOW
				}
			case shadowUserOpen(selected, row, through):
				obs.UserDecision = labv1.ShadowUserDecision_SHADOW_USER_DECISION_OPEN
			default:
				obs.UserDecision = labv1.ShadowUserDecision_SHADOW_USER_DECISION_UNANSWERED
			}
		}
		res.Observations = append(res.Observations, obs)
		if !row.DecisionAt.After(through) {
			res.SampledHours++
			aiAllowed[bar.OpenTime.UTC()] = row.Gate == "allow" && row.GateResolvedAt != nil && row.GateResolvedAt.Before(row.DecisionAt)
			userAllowed[bar.OpenTime.UTC()] = user.HourID != 0 && user.Allow && user.DecidedAt.Before(row.DecisionAt)
		}
	}
	if res.SampledHours == 0 {
		slices.Reverse(res.Observations)
		return nil
	}
	if selected.RuntimePolicy != shadowPolicy || selected.FillModel != sim.FillModel {
		return fmt.Errorf("shadow %d uses an unavailable simulation policy", selected.ID)
	}
	var config sim.Config
	if err := json.Unmarshal(selected.SimConfig, &config); err != nil {
		return err
	}
	spec, err := shadowInstrument(selected)
	if err != nil {
		return err
	}
	common := bars[warmup : warmup+int(res.SampledHours)]
	sample := bars[:warmup+len(common)]
	run := func(allow func(data.Bar) bool) (shadowReplay, error) {
		return replayShadow(ctx, config, spec, def, sample, common, allow)
	}
	baseline, err := run(nil)
	if err != nil {
		return err
	}
	ai, err := run(func(b data.Bar) bool { return aiAllowed[b.OpenTime.UTC()] })
	if err != nil {
		return err
	}
	ai.track.Attribution = shadowAttribution(baseline, ai)
	res.Baseline, res.Ai = baseline.track, ai.track
	var user shadowReplay
	if selected.UserTrack {
		user, err = run(func(b data.Bar) bool { return userAllowed[b.OpenTime.UTC()] })
		if err != nil {
			return err
		}
		user.track.Attribution = shadowAttribution(baseline, user)
		res.User = user.track
	}
	res.MinimumClosedTrades = shadowMinimumTrades(baseline, ai, user)
	for i, b := range common {
		obs := res.Observations[i]
		key := b.OpenTime.UTC()
		obs.BaselineEntry, obs.AiEntry, obs.UserEntry = baseline.entries[key], ai.entries[key], user.entries[key]
	}
	slices.Reverse(res.Observations)
	return nil
}

func shadowDeploymentP(d db.ShadowDeployment) (*labv1.ShadowDeployment, error) {
	var cfg sim.Config
	if err := json.Unmarshal(d.SimConfig, &cfg); err != nil {
		return nil, err
	}
	res := &labv1.ShadowDeployment{Id: d.ID, Symbol: d.Symbol, RuleVersionId: d.RuleVersionID, ReportId: d.ReportID,
		RegisteredAtUnixMs: ms(d.RegisteredAt), StartAtUnixMs: ms(d.StartAt), EndAtUnixMs: ms(d.EndAt), State: shadowStateP[d.State],
		Capital: moneyP(cfg.Capital), FeeRate: ratioP(cfg.FeeRate), SlippageRate: ratioP(cfg.SlipRate), FillModel: d.FillModel,
		AiModel: d.AiModel, AiPromptVersion: d.AiPromptVersion, RuleContentHash: d.RuleContentHash, EngineBuild: d.EngineBuild, UserTrack: d.UserTrack}
	if d.ModelInputPerMillion != nil && d.ModelOutputPerMillion != nil {
		res.ModelInputPerMillion = usdtP(*d.ModelInputPerMillion)
		res.ModelOutputPerMillion = usdtP(*d.ModelOutputPerMillion)
	}
	return res, nil
}

var shadowStateP = map[string]labv1.ShadowState{
	"active": labv1.ShadowState_SHADOW_STATE_ACTIVE, "complete": labv1.ShadowState_SHADOW_STATE_COMPLETE,
	"stopped": labv1.ShadowState_SHADOW_STATE_STOPPED, "gap": labv1.ShadowState_SHADOW_STATE_GAP,
	"build_changed": labv1.ShadowState_SHADOW_STATE_BUILD_CHANGED,
}

var shadowGateP = map[string]labv1.ShadowGate{
	"no_signal": labv1.ShadowGate_SHADOW_GATE_NO_SIGNAL, "running": labv1.ShadowGate_SHADOW_GATE_PENDING,
	"allow": labv1.ShadowGate_SHADOW_GATE_ALLOW, "block": labv1.ShadowGate_SHADOW_GATE_BLOCK,
	"unavailable": labv1.ShadowGate_SHADOW_GATE_UNAVAILABLE,
}
