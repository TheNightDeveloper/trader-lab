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
	"tradinglab/engine/internal/eval"
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
		if err != nil || len(hours) == 0 {
			return err
		}
		usage, err := q.ShadowUsage(ctx, selected.ID)
		if err != nil {
			return err
		}
		res.InputTokens, res.OutputTokens = usage.InputTokens, usage.OutputTokens
		def, err = shadowRule(ctx, q, selected)
		return err
	})
	if err != nil {
		return nil, err
	}
	if len(hours) == 0 {
		return connect.NewResponse(res), nil
	}
	through := s.Market.Clock.Now()
	if selected.SettledAt != nil && selected.SettledAt.Before(through) {
		through = *selected.SettledAt
	}
	if err := projectShadow(ctx, res, selected, def, hours, bars, through); err != nil {
		return nil, err
	}
	return connect.NewResponse(res), nil
}

func projectShadow(ctx context.Context, res *labv1.GetShadowSnapshotResponse, selected db.ShadowDeployment, def strategy.RuleDefinition, hours []db.ShadowHour, bars []data.Bar, through time.Time) error {
	warmup := len(bars) - len(hours)
	allowed := make(map[time.Time]bool)
	for i, row := range hours {
		bar := bars[warmup+i]
		obs := &labv1.ShadowObservation{CandleClosedAtUnixMs: ms(row.ClosedAt), ObservedAtUnixMs: ms(row.ObservedAt),
			DecisionAtUnixMs: ms(row.DecisionAt), Gate: shadowGateP[row.Gate], ReferenceClose: usdtP(bar.C.V)}
		if row.GateResolvedAt != nil {
			obs.GateResolvedAtUnixMs = ms(*row.GateResolvedAt)
		}
		res.Observations = append(res.Observations, obs)
		if !row.DecisionAt.After(through) {
			res.SampledHours++
			allowed[bar.OpenTime.UTC()] = row.Gate == "allow" && row.GateResolvedAt != nil && row.GateResolvedAt.Before(row.DecisionAt)
		}
	}
	slices.Reverse(res.Observations)
	if res.SampledHours == 0 {
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
	sample := bars[:warmup+int(res.SampledHours)]
	window := eval.Window{From: selected.StartAt, To: sample[len(sample)-1].AvailableAt}
	run := func(gate func(data.Bar) bool) (*labv1.ShadowTrack, error) {
		strat, err := def.BuildWithEntryGate(gate)
		if err != nil {
			return nil, err
		}
		view, _, result, err := eval.RunSplit(ctx, strat, config, map[string]instrument.Spec{spec.Symbol: spec},
			map[string][]data.Bar{spec.Symbol: sample}, eval.Split{OOS: window})
		if err != nil {
			return nil, err
		}
		track := &labv1.ShadowTrack{}
		for _, metric := range view.Metrics {
			switch metric.Key {
			case "net_pnl", "total_return", "max_drawdown", "closed_trades", "fees", "slippage", "final_equity":
				track.Metrics = append(track.Metrics, metricP(metric))
			}
		}
		for _, fill := range result.Fills {
			if fill.Side == sim.Buy {
				track.Entries++
			}
		}
		return track, nil
	}
	res.Baseline, err = run(nil)
	if err != nil {
		return err
	}
	res.Ai, err = run(func(b data.Bar) bool { return allowed[b.OpenTime.UTC()] })
	return err
}

func shadowDeploymentP(d db.ShadowDeployment) (*labv1.ShadowDeployment, error) {
	var cfg sim.Config
	if err := json.Unmarshal(d.SimConfig, &cfg); err != nil {
		return nil, err
	}
	return &labv1.ShadowDeployment{Id: d.ID, Symbol: d.Symbol, RuleVersionId: d.RuleVersionID, ReportId: d.ReportID,
		RegisteredAtUnixMs: ms(d.RegisteredAt), StartAtUnixMs: ms(d.StartAt), EndAtUnixMs: ms(d.EndAt), State: shadowStateP[d.State],
		Capital: moneyP(cfg.Capital), FeeRate: ratioP(cfg.FeeRate), SlippageRate: ratioP(cfg.SlipRate), FillModel: d.FillModel,
		AiModel: d.AiModel, AiPromptVersion: d.AiPromptVersion, RuleContentHash: d.RuleContentHash, EngineBuild: d.EngineBuild}, nil
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
