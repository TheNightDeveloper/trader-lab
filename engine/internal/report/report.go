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
	"runtime"
	"slices"
	"strings"
	"sync"

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
	Store    *store.Store
	Version  string // engine version recorded in every report
	Parallel int    // simulator runs at once per report; 0 = all CPUs
	// Cache holds recently used dataset versions (nil: load every time).
	Cache *DatasetCache
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
	bars, tf, _, err := s.bars(ctx, ids)
	return bars, tf, err
}

// bars also returns the datasets' total gap count (data-quality badge).
func (s Service) bars(ctx context.Context, ids []string) (map[string][]data.Bar, data.Timeframe, int, error) {
	if len(ids) == 0 {
		return nil, "", 0, fmt.Errorf("%w: choose at least one dataset", ErrInput)
	}
	gaps := 0
	bars := map[string][]data.Bar{}
	var tf data.Timeframe
	for _, id := range ids {
		ds, bs, err := s.Cache.load(ctx, s, id)
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, "", 0, fmt.Errorf("%w: dataset %s not found", ErrInput, id)
		}
		if err != nil {
			return nil, "", 0, err
		}
		if tf != "" && ds.Spec.Timeframe != tf {
			return nil, "", 0, fmt.Errorf("%w: datasets must share one timeframe (%s vs %s)", ErrInput, tf, ds.Spec.Timeframe)
		}
		tf = ds.Spec.Timeframe
		if _, dup := bars[ds.Spec.Symbol]; dup {
			return nil, "", 0, fmt.Errorf("%w: two datasets for %s", ErrInput, ds.Spec.Symbol)
		}
		bars[ds.Spec.Symbol] = bs
		gaps += ds.Gaps
	}
	return bars, tf, gaps, nil
}

// Create evaluates spec over its datasets and stores the report.
func (s Service) Create(ctx context.Context, spec eval.Spec) (string, error) {
	spec.EngineVersion = s.Version
	ev, bars, err := s.evaluate(ctx, spec)
	if err != nil {
		return "", err
	}
	id, err := newID()
	if err != nil {
		return "", err
	}
	return id, s.persist(ctx, id, bars, ev)
}

// CreateWithID is Create under a caller-chosen id, idempotent: if the report
// already exists it is left as is (a finalization re-run after a crash must not
// create a second report).
func (s Service) CreateWithID(ctx context.Context, id string, spec eval.Spec) error {
	if ok, err := s.Store.ReportExists(ctx, id); err != nil || ok {
		return err
	}
	spec.EngineVersion = s.Version
	ev, bars, err := s.evaluate(ctx, spec)
	if err != nil {
		return err
	}
	return s.persist(ctx, id, bars, ev)
}

// evaluate loads the datasets, evaluates spec and adds the data-quality badge.
func (s Service) evaluate(ctx context.Context, spec eval.Spec) (*eval.Evaluation, map[string][]data.Bar, error) {
	bars, tf, gaps, err := s.bars(ctx, spec.DatasetIDs)
	if err != nil {
		return nil, nil, err
	}
	spec.Timeframe = tf
	parallel := s.Parallel
	if parallel <= 0 {
		parallel = runtime.NumCPU()
	}
	ev, err := eval.EvaluateWith(ctx, spec, bars, Specs(), parallel)
	if err != nil {
		return nil, nil, err
	}
	if gaps > 0 {
		ev.Summary.Badges = append(ev.Summary.Badges, eval.Badge{Kind: "data_gaps", Text: fmt.Sprintf("هشدار کیفیت داده: %d شکاف", gaps), Tone: eval.Warning})
	}
	return ev, bars, nil
}

// Reproduce re-evaluates a stored report from its recorded inputs and reports
// whether every number came out identical (invariant 1).
func (s Service) Reproduce(ctx context.Context, id string) (bool, error) {
	row, err := s.Store.GetReport(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return false, fmt.Errorf("%w: %s", ErrNotFound, id)
	}
	if err != nil {
		return false, err
	}
	var spec eval.Spec
	if err := json.Unmarshal(row.Spec, &spec); err != nil {
		return false, err
	}
	ev, _, err := s.evaluate(ctx, spec)
	if err != nil {
		return false, err
	}
	evJ, err := json.Marshal(ev)
	if err != nil {
		return false, err
	}
	holdJ, err := json.Marshal(ev.Holdout)
	if err != nil {
		return false, err
	}
	return jsonEqual(evJ, row.Evaluation) && jsonEqual(holdJ, row.Holdout), nil
}

// jsonEqual compares JSON by value: PostgreSQL jsonb normalizes key order and
// whitespace, so stored bytes differ from freshly marshalled ones.
func jsonEqual(a, b []byte) bool {
	var x, y any
	if json.Unmarshal(a, &x) != nil || json.Unmarshal(b, &y) != nil {
		return false
	}
	ja, _ := json.Marshal(x)
	jb, _ := json.Marshal(y)
	return string(ja) == string(jb)
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
func (s Service) Recalculate(ctx context.Context, id string, cfg sim.Config, scale money.Ratio) (eval.RunView, *sim.Result, error) {
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
	return eval.Replay(ctx, st.Split, ds, cfg, scale, bars, Specs())
}

// DatasetCache keeps the most recently loaded dataset versions in memory. A
// version is content-addressed and never changes, so a cached copy is always
// current. Callers share the bars and must not modify them.
type DatasetCache struct {
	mu    sync.Mutex
	size  int
	order []string // oldest first
	m     map[string]cachedDataset
}

type cachedDataset struct {
	ds   data.Dataset
	bars []data.Bar
}

func NewDatasetCache(size int) *DatasetCache {
	return &DatasetCache{size: max(1, size), m: map[string]cachedDataset{}}
}

// load returns the version from the cache, or loads and verifies it (content
// hash checked) and keeps it. A nil cache always loads.
func (c *DatasetCache) load(ctx context.Context, s Service, id string) (data.Dataset, []data.Bar, error) {
	if c == nil {
		return data.LoadDataset(ctx, s.Store, id)
	}
	c.mu.Lock()
	hit, ok := c.m[id]
	if ok {
		c.order = append(slices.DeleteFunc(c.order, func(x string) bool { return x == id }), id)
	}
	c.mu.Unlock()
	if ok {
		return hit.ds, hit.bars, nil
	}
	ds, bars, err := data.LoadDataset(ctx, s.Store, id)
	if err != nil {
		return ds, nil, err
	}
	c.mu.Lock()
	defer c.mu.Unlock()
	if _, ok := c.m[id]; !ok {
		c.m[id] = cachedDataset{ds, bars}
		c.order = append(c.order, id)
		for len(c.order) > c.size {
			delete(c.m, c.order[0])
			c.order = c.order[1:]
		}
	}
	return ds, bars, nil
}
