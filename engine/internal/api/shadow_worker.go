package api

import (
	"context"
	"crypto/sha256"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"time"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/assistant"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

// RunShadow captures new evidence and shares the existing assistant admission budget.
func (s *Shadow) RunShadow(ctx context.Context) {
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()
	for ctx.Err() == nil {
		cycle, cancel := context.WithTimeout(ctx, 25*time.Second)
		err := s.advanceShadow(cycle)
		cancel()
		if err != nil && ctx.Err() == nil {
			slog.WarnContext(ctx, "shadow observation deferred", "error", err)
		}
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
		}
	}
}

func (s *Shadow) advanceShadow(ctx context.Context) error {
	active, err := s.Market.Store.ActiveShadowDeployment(ctx)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil
	}
	if err != nil {
		return err
	}
	var observed db.ShadowHour
	err = s.Market.Store.InTx(ctx, func(q *db.Queries) error {
		d, err := q.LockShadowDeployment(ctx, active.ID)
		if err != nil || d.State != "active" {
			return err
		}
		observed, err = s.captureShadow(ctx, q, d)
		return err
	})
	if err != nil || observed.Gate != "running" {
		return err
	}
	// The claim is committed before inference. After a crash, its cutoff expires
	// instead of repeating a paid call or applying a late decision.
	return s.filterShadow(ctx, active.Symbol, observed)
}

func (s *Shadow) captureShadow(ctx context.Context, q *db.Queries, d db.ShadowDeployment) (db.ShadowHour, error) {
	var none db.ShadowHour
	now := s.Market.Clock.Now().UTC()
	settle := func(state string) (db.ShadowHour, error) {
		return none, q.SettleShadowDeployment(ctx, db.SettleShadowDeploymentParams{ID: d.ID, State: state, SettledAt: &now})
	}
	if d.RuntimePolicy != shadowPolicy || d.EngineBuild != s.Market.Build || d.AiModel != assistant.Model || d.AiPromptVersion != assistant.ShadowPromptVersion {
		if err := resolveUnfinishedShadow(ctx, q, d.ID, now); err != nil {
			return none, err
		}
		return settle("build_changed")
	}
	last, err := q.LatestShadowHour(ctx, d.ID)
	if err != nil && !errors.Is(err, pgx.ErrNoRows) {
		return none, err
	}
	closed := d.StartAt.Add(time.Hour)
	if last.ID != 0 {
		if now.Before(last.DecisionAt) {
			return none, nil
		}
		if last.Gate == "running" {
			if err := q.ResolveShadowGate(ctx, db.ResolveShadowGateParams{ID: last.ID, Gate: "unavailable", GateResolvedAt: &now}); err != nil {
				return none, err
			}
		}
		closed = last.ClosedAt.Add(time.Hour)
	}
	if closed.After(d.EndAt) {
		return settle("complete")
	}
	decision := closed.Add(shadowDecisionDelay)
	if !now.Before(decision) {
		// A missing hour ends the observed common prefix. Never replay it from a later backfill.
		return settle("gap")
	}
	if now.Before(closed) {
		return none, nil
	}
	if err := s.Market.requireMarketFeed(ctx, q, d.Symbol, now, closed, decision); err != nil {
		if errors.Is(err, errMarketFeed) {
			return none, nil
		}
		return none, err
	}
	def, err := shadowRule(ctx, q, d)
	if err != nil {
		return none, err
	}
	lookback, probe, err := def.CompileEntryProbe()
	if err != nil {
		return none, err
	}
	width := time.Hour
	if last.ID == 0 {
		width *= time.Duration(lookback)
	}
	knownAt, err := q.DBNow(ctx)
	if err != nil {
		return none, err
	}
	read, err := (data.Reader{Q: q}).Bars(ctx, data.Query{
		Symbol: d.Symbol, Timeframe: opportunityTF, From: closed.Add(-width), To: closed, AsOf: now, KnownAt: knownAt,
	})
	if err != nil {
		return none, err
	}
	read = completeMarketSuffix(read, closed, time.Hour)
	if len(read) != int(width/time.Hour) {
		return none, nil
	}
	bar := read[len(read)-1]
	// Both simulated decisions use the preregistered cutoff, including when AI returns early.
	bar.AvailableAt = decision
	history := read[:len(read)-1]
	var warmup []byte
	if last.ID == 0 {
		warmup, err = json.Marshal(history)
	} else {
		history, _, err = readShadowBars(ctx, q, d.ID)
	}
	if err != nil {
		return none, err
	}
	history = append(history, bar)
	intent, ready := probe(history)
	if !ready {
		return none, nil
	}
	gate := "no_signal"
	if intent.Target > 0 {
		gate = "running"
	}
	encoded, err := json.Marshal(bar)
	if err != nil {
		return none, err
	}
	if !s.Market.Clock.Now().Before(decision) {
		now = s.Market.Clock.Now().UTC()
		return settle("gap")
	}
	return q.InsertShadowHour(ctx, db.InsertShadowHourParams{DeploymentID: d.ID, ClosedAt: closed, ObservedAt: now,
		DecisionAt: decision, Bar: encoded, Warmup: warmup, Reason: intent.Reason, Gate: gate})
}

func (s *Shadow) filterShadow(ctx context.Context, symbol string, h db.ShadowHour) error {
	var b data.Bar
	if err := json.Unmarshal(h.Bar, &b); err != nil {
		return err
	}
	gate := "unavailable"
	remaining := h.DecisionAt.Sub(s.Market.Clock.Now())
	if s.assistantEnabled() && remaining > 0 {
		infer, cancel := context.WithTimeout(ctx, remaining)
		key := fmt.Sprintf("%x", sha256.Sum256(fmt.Appendf(nil, "%d\n%s", h.ID, h.Bar)))
		request := assistant.Shadow(assistant.Evidence{Symbol: symbol, Match: h.Reason, Open: b.O.V, High: b.H.V, Low: b.L.V, Close: b.C.V})
		result, err := s.Assistant.explain(infer, db.ReserveAssistantRunParams{EvidenceSha256: key, ShadowHourID: h.ID}, request)
		cancel()
		if err == nil && s.Market.Clock.Now().Before(h.DecisionAt) {
			gate = result.Focus
		}
	}
	now := s.Market.Clock.Now().UTC()
	if !now.Before(h.DecisionAt) {
		gate = "unavailable"
	}
	audit, cancel := context.WithTimeout(context.WithoutCancel(ctx), 3*time.Second)
	defer cancel()
	return s.Market.Store.ResolveShadowGate(audit, db.ResolveShadowGateParams{ID: h.ID, Gate: gate, GateResolvedAt: &now})
}

func shadowRule(ctx context.Context, q *db.Queries, d db.ShadowDeployment) (strategy.RuleDefinition, error) {
	row, err := q.GetRuleVersion(ctx, d.RuleVersionID)
	if err != nil {
		return strategy.RuleDefinition{}, err
	}
	if row.ContentHash != d.RuleContentHash {
		return strategy.RuleDefinition{}, fmt.Errorf("shadow %d rule evidence changed", d.ID)
	}
	return decodeSavedRule(row)
}

func readShadowBars(ctx context.Context, q *db.Queries, id int64) ([]data.Bar, []db.ShadowHour, error) {
	hours, err := q.ShadowHours(ctx, id)
	if err != nil || len(hours) == 0 {
		return nil, hours, err
	}
	var bars []data.Bar
	if err := json.Unmarshal(hours[0].Warmup, &bars); err != nil {
		return nil, nil, fmt.Errorf("shadow %d warmup: %w", id, err)
	}
	for _, hour := range hours {
		var bar data.Bar
		if err := json.Unmarshal(hour.Bar, &bar); err != nil {
			return nil, nil, fmt.Errorf("shadow %d observed candle: %w", id, err)
		}
		bars = append(bars, bar)
	}
	return bars, hours, nil
}
