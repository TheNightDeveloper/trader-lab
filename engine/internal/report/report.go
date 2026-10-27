// Package report creates, stores and reads evaluated reports: dataset loading →
// eval → one transaction. Stored reports are immutable; the holdout is only read
// through ViewHoldout, which logs every look (invariant 8).
package report

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"maps"
	"slices"
	"strings"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

var (
	ErrNotFound = errors.New("report: not found")
	ErrInput    = errors.New("report: invalid input")
)

const (
	RunMain    = "main"
	RunHoldout = "holdout"
)

type Service struct {
	Store *store.Store
}

// Stored is a report as read back.
type Stored struct {
	Row        db.Report
	Spec       eval.Spec
	Split      eval.Split
	Evaluation eval.Evaluation // public part: OOS, folds, stress, grid, summary
	Views      int64
}

func Specs() map[string]instrument.Spec {
	m := map[string]instrument.Spec{}
	for _, s := range instrument.Defaults() {
		m[s.Symbol] = s
	}
	return m
}

// Bars loads and verifies every dataset of spec (content hash checked) and
// returns bars per symbol at the datasets' common timeframe.
func (s Service) Bars(ctx context.Context, ids []string) (map[string][]data.Bar, data.Timeframe, error) {
	if len(ids) == 0 {
		return nil, "", fmt.Errorf("%w: choose at least one dataset", ErrInput)
	}
	bars := map[string][]data.Bar{}
	var tf data.Timeframe
	for _, id := range ids {
		ds, bs, err := data.LoadDataset(ctx, s.Store, id)
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, "", fmt.Errorf("%w: dataset %s not found", ErrInput, id)
		}
		if err != nil {
			return nil, "", err
		}
		if tf != "" && ds.Spec.Timeframe != tf {
			return nil, "", fmt.Errorf("%w: datasets must share one timeframe (%s vs %s)", ErrInput, tf, ds.Spec.Timeframe)
		}
		tf = ds.Spec.Timeframe
		if _, dup := bars[ds.Spec.Symbol]; dup {
			return nil, "", fmt.Errorf("%w: two datasets for %s", ErrInput, ds.Spec.Symbol)
		}
		bars[ds.Spec.Symbol] = bs
	}
	return bars, tf, nil
}

// Create evaluates spec over its datasets and stores the report.
func (s Service) Create(ctx context.Context, spec eval.Spec) (string, error) {
	bars, tf, err := s.Bars(ctx, spec.DatasetIDs)
	if err != nil {
		return "", err
	}
	spec.Timeframe = tf
	ev, err := eval.Evaluate(ctx, spec, bars, Specs())
	if err != nil {
		return "", err
	}
	id, err := newID()
	if err != nil {
		return "", err
	}
	return id, s.persist(ctx, id, bars, ev)
}

func newID() (string, error) {
	b := make([]byte, 8)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return "rp_" + hex.EncodeToString(b), nil
}

func (s Service) persist(ctx context.Context, id string, bars map[string][]data.Bar, ev *eval.Evaluation) error {
	specJ, err := json.Marshal(ev.Spec)
	if err != nil {
		return err
	}
	splitJ, err := json.Marshal(ev.Split)
	if err != nil {
		return err
	}
	evJ, err := json.Marshal(ev)
	if err != nil {
		return err
	}
	holdJ, err := json.Marshal(ev.Holdout)
	if err != nil {
		return err
	}
	net, _ := metrics.Get(ev.OOS.Metrics, "net_pnl")
	ret, _ := metrics.Get(ev.OOS.Metrics, "total_return")
	closed, _ := metrics.Get(ev.OOS.Metrics, "closed_trades")
	symbols := slices.Sorted(maps.Keys(bars))
	title := fmt.Sprintf("%s · %s · %s", ev.Spec.Strategy, strings.Join(symbols, "+"), ev.Spec.Timeframe)
	return s.Store.InTx(ctx, func(q *db.Queries) error {
		err := q.InsertReport(ctx, db.InsertReportParams{
			ID: id, Title: title, Spec: specJ, Split: splitJ, Evaluation: evJ, Holdout: holdJ,
			OosNet: net.V, OosReturn: ret.V, ClosedTrades: int32(closed.V),
			Verdict: ev.Summary.Verdict, Tone: string(ev.Summary.Tone),
		})
		if err != nil {
			return fmt.Errorf("insert report: %w", err)
		}
		for run, r := range map[string]*sim.Result{RunMain: ev.Main, RunHoldout: ev.HoldoutRun} {
			if err := copyRun(ctx, q, id, run, r); err != nil {
				return err
			}
		}
		return nil
	})
}

func copyRun(ctx context.Context, q *db.Queries, id, run string, r *sim.Result) error {
	trades := make([]db.CopyTradesParams, len(r.Trades))
	for i, t := range r.Trades {
		var mark *int64
		if t.MarkValue != nil {
			mark = &t.MarkValue.V
		}
		trades[i] = db.CopyTradesParams{
			ReportID: id, Run: run, Seq: int32(i + 1), Instrument: t.Instrument, OpenedAt: t.OpenedAt, ClosedAt: t.ClosedAt,
			Qty: t.Qty.V, EntryRef: t.EntryRef.V, ExitRef: t.ExitRef.V, Gross: t.Gross.V, Slippage: t.Slippage.V,
			Fees: t.Fees.V, Net: t.Net.V, ExitReason: t.ExitReason, AmbiguousBars: int32(t.AmbiguousBars),
			OpenQty: t.OpenQty.V, MarkValue: mark,
		}
	}
	fills := make([]db.CopyFillsParams, len(r.Fills))
	for i, f := range r.Fills {
		fills[i] = db.CopyFillsParams{
			ReportID: id, Run: run, Seq: int32(i + 1), DecisionID: int32(f.DecisionID), At: f.Time, Instrument: f.Instrument,
			Side: string(f.Side), Kind: f.Kind, Qty: f.Qty.V, RefPrice: f.RefPrice.V, Price: f.Price.V, Quote: f.Value.Asset.Code,
			RefValue: f.RefValue.V, Value: f.Value.V, Slippage: f.Slippage.V, Fee: f.Fee.V,
			RefValueUsdt: f.RefValueUSDT.V, SlippageUsdt: f.SlippageUSDT.V, FeeUsdt: f.FeeUSDT.V, Ambiguous: f.Ambiguous,
		}
	}
	decisions := make([]db.CopyDecisionsParams, len(r.Decisions))
	for i, d := range r.Decisions {
		decisions[i] = db.CopyDecisionsParams{
			ReportID: id, Run: run, ID: int32(d.ID), At: d.At, InputSymbol: d.InputSymbol, InputBarOpen: d.InputBarOpen,
			Instrument: d.Instrument, Target: int64(d.Target), StopLoss: int64(d.StopLoss), TakeProfit: int64(d.TakeProfit),
			Reason: d.Reason, ModelID: d.ModelID, RecipeVersion: d.RecipeVersion, Outcome: string(d.Outcome), Detail: d.Detail,
		}
	}
	if _, err := q.CopyTrades(ctx, trades); err != nil {
		return fmt.Errorf("copy %s trades: %w", run, err)
	}
	if _, err := q.CopyFills(ctx, fills); err != nil {
		return fmt.Errorf("copy %s fills: %w", run, err)
	}
	if _, err := q.CopyDecisions(ctx, decisions); err != nil {
		return fmt.Errorf("copy %s decisions: %w", run, err)
	}
	return nil
}

// Load reads a report's public part. The holdout is not included.
func (s Service) Load(ctx context.Context, id string) (Stored, error) {
	row, err := s.Store.GetReport(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return Stored{}, fmt.Errorf("%w: %s", ErrNotFound, id)
	}
	if err != nil {
		return Stored{}, err
	}
	st := Stored{Row: row}
	if err := json.Unmarshal(row.Spec, &st.Spec); err != nil {
		return Stored{}, fmt.Errorf("report %s spec: %w", id, err)
	}
	if err := json.Unmarshal(row.Split, &st.Split); err != nil {
		return Stored{}, fmt.Errorf("report %s split: %w", id, err)
	}
	if err := json.Unmarshal(row.Evaluation, &st.Evaluation); err != nil {
		return Stored{}, fmt.Errorf("report %s evaluation: %w", id, err)
	}
	st.Views, err = s.Store.CountHoldoutViews(ctx, id)
	return st, err
}

// ViewHoldout logs the look, then returns the hidden holdout result.
func (s Service) ViewHoldout(ctx context.Context, id string) (eval.RunView, int64, error) {
	var hv eval.RunView
	var views int64
	err := s.Store.InTx(ctx, func(q *db.Queries) error {
		row, err := q.GetReport(ctx, id)
		if errors.Is(err, pgx.ErrNoRows) {
			return fmt.Errorf("%w: %s", ErrNotFound, id)
		}
		if err != nil {
			return err
		}
		if err := q.InsertHoldoutView(ctx, id); err != nil {
			return err
		}
		if views, err = q.CountHoldoutViews(ctx, id); err != nil {
			return err
		}
		return json.Unmarshal(row.Holdout, &hv)
	})
	return hv, views, err
}

// Decisions reads a run's recorded decisions, in order.
func (s Service) Decisions(ctx context.Context, id, run string) ([]sim.Decision, error) {
	rows, err := s.Store.AllDecisions(ctx, db.AllDecisionsParams{ReportID: id, Run: run})
	if err != nil {
		return nil, err
	}
	out := make([]sim.Decision, len(rows))
	for i, r := range rows {
		out[i] = sim.Decision{
			ID: int(r.ID), At: r.At.UTC(), InputSymbol: r.InputSymbol, InputBarOpen: r.InputBarOpen.UTC(),
			Instrument: r.Instrument, Target: money.Ratio(r.Target), StopLoss: money.Ratio(r.StopLoss), TakeProfit: money.Ratio(r.TakeProfit),
			Reason: r.Reason, ModelID: r.ModelID, RecipeVersion: r.RecipeVersion, Outcome: sim.Outcome(r.Outcome), Detail: r.Detail,
		}
	}
	return out, nil
}

// Recalculate replays a report's recorded out-of-sample intents with cfg.
func (s Service) Recalculate(ctx context.Context, id string, cfg sim.Config) (eval.RunView, *sim.Result, error) {
	st, err := s.Load(ctx, id)
	if err != nil {
		return eval.RunView{}, nil, err
	}
	ds, err := s.Decisions(ctx, id, RunMain)
	if err != nil {
		return eval.RunView{}, nil, err
	}
	bars, _, err := s.Bars(ctx, st.Spec.DatasetIDs)
	if err != nil {
		return eval.RunView{}, nil, err
	}
	return eval.Replay(ctx, st.Split, ds, cfg, bars, Specs())
}
