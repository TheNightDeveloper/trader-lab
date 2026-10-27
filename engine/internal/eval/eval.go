package eval

import (
	"context"
	"errors"
	"fmt"
	"math"
	"runtime"
	"slices"
	"sync"
	"time"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/strategy"
)

var ErrSpec = errors.New("eval: invalid spec")

// Spec is everything a report depends on besides the bars themselves.
type Spec struct {
	DatasetIDs []string        `json:"dataset_ids"`
	Timeframe  data.Timeframe  `json:"timeframe"`
	Strategy   string          `json:"strategy"`
	Params     strategy.Params `json:"params"` // complete: defaults filled in
	Sim        sim.Config      `json:"sim"`
	Split      SplitPlan       `json:"split"`
	// EngineVersion of the code that produced the report (reproducibility badge).
	EngineVersion string `json:"engine_version"`
	// Origin is set when the report is the chosen candidate of an experiment: the
	// attempt count travels with it so every reader can discount for search.
	Origin *Origin `json:"origin,omitempty"`
}

// Origin links a report to the search that produced it.
type Origin struct {
	ExperimentID string `json:"experiment_id"`
	Attempts     int    `json:"attempts"` // every attempt of the experiment, failed and cancelled included
	Candidates   int    `json:"candidates"`
}

// EquityPoint for charts (downsampled).
type EquityPoint struct {
	T      time.Time    `json:"t"`
	Equity money.Amount `json:"equity"`
}

// RunView is one evaluated window of a run.
type RunView struct {
	Window        Window           `json:"window"`
	Metrics       []metrics.Metric `json:"metrics"`
	Equity        []EquityPoint    `json:"equity"`
	AmbiguousBars int              `json:"ambiguous_bars"`
}

type FoldView struct {
	Fold    Fold             `json:"fold"`
	Metrics []metrics.Metric `json:"metrics"` // net_pnl, total_return, max_drawdown, trades, win_rate
}

type StressView struct {
	Key     string           `json:"key"` // fee_x2 | slippage_x3 | latency_plus_1
	Metrics []metrics.Metric `json:"metrics"`
	Error   string           `json:"error,omitempty"`
}

// Grid is the parameter neighbourhood: total return for each combination of the
// first two signal parameters at −10%, 0, +10% (integers: at least ±1).
type Grid struct {
	X     string       `json:"x"`
	Y     string       `json:"y,omitempty"` // empty: one-parameter strategy (one row)
	Xs    []float64    `json:"xs"`          // model parameters, not money: floats are fine
	Ys    []float64    `json:"ys"`
	Cells [][]GridCell `json:"cells"` // [y][x]
}

type GridCell struct {
	Return  metrics.Metric `json:"return"`
	Center  bool           `json:"center,omitempty"`
	Invalid string         `json:"invalid,omitempty"`
}

// Benchmark is a reference curve over the same out-of-sample window and costs.
type Benchmark struct {
	Key    string         `json:"key"` // buy_and_hold | hold_cash
	Equity []EquityPoint  `json:"equity"`
	Return metrics.Metric `json:"return"`
}

// Evaluation is a complete report's numbers. Main and HoldoutRun carry the full
// simulator records for persistence; the holdout view is hidden by the API.
type Evaluation struct {
	Spec  Spec    `json:"spec"`
	Range Window  `json:"range"` // all bars, for chart regions: in-sample | OOS | holdout
	Split Split   `json:"split"`
	OOS   RunView `json:"oos"`
	// BreakEvenFee: per-side fee at which the OOS net would be zero, holding its
	// trades and slippage fixed. Nil when no fee makes it profitable.
	BreakEvenFee *money.Ratio `json:"break_even_fee,omitempty"`
	Benchmarks   []Benchmark  `json:"benchmarks"`
	Folds        []FoldView   `json:"folds"`
	Stress       []StressView `json:"stress"`
	Grid         *Grid        `json:"grid,omitempty"`
	Summary      Summary      `json:"summary"`
	Holdout      RunView      `json:"-"`

	Main       *sim.Result `json:"-"`
	HoldoutRun *sim.Result `json:"-"`
}

// gated hides a strategy's intents before From: the warm-up primes indicators on
// earlier bars without trading on them.
type gated struct {
	s    strategy.Strategy
	from time.Time
}

func (g gated) OnBar(ctx strategy.RunContext, b data.Bar) ([]strategy.Intent, error) {
	ins, err := g.s.OnBar(ctx, b)
	if b.OpenTime.Before(g.from) {
		return nil, err
	}
	return ins, err
}

// Evaluate runs the walk-forward evaluation of spec over bars (per symbol, at
// spec.Timeframe). All simulator runs are independent and run in parallel; each
// one is single-threaded and deterministic, so the result does not depend on
// scheduling.
func Evaluate(ctx context.Context, spec Spec, bars map[string][]data.Bar, specs map[string]instrument.Spec) (*Evaluation, error) {
	return EvaluateWith(ctx, spec, bars, specs, runtime.NumCPU())
}

// EvaluateOOS is the light evaluation used by search attempts: only the gated
// out-of-sample run, no holdout, stress, neighbourhood or benchmarks. The
// holdout is never looked at while choosing a candidate.
func EvaluateOOS(ctx context.Context, spec Spec, bars map[string][]data.Bar, specs map[string]instrument.Spec) ([]metrics.Metric, error) {
	s, err := strategy.New(spec.Strategy, spec.Params)
	if err != nil {
		return nil, fmt.Errorf("%w: %w", ErrSpec, err)
	}
	cfg, err := spec.Sim.Normalized()
	if err != nil {
		return nil, fmt.Errorf("%w: %w", ErrSpec, err)
	}
	tfDur, err := tfDuration(spec.Timeframe)
	if err != nil {
		return nil, err
	}
	from, to, err := span(bars)
	if err != nil {
		return nil, err
	}
	split, err := spec.Split.withDefaults().Make(from, to, tfDur)
	if err != nil {
		return nil, err
	}
	oos := map[string][]data.Bar{}
	for sym, bs := range bars {
		i, _ := slices.BinarySearchFunc(bs, split.OOS.To, func(b data.Bar, t time.Time) int { return b.OpenTime.Compare(t) })
		if i > 0 {
			oos[sym] = bs[:i:i]
		}
	}
	res, err := sim.Run(ctx, cfg, specs, oos, gated{s, split.OOS.From})
	if err != nil {
		return nil, err
	}
	return window(res, split.OOS, cfg.Capital.V), nil
}

// EvaluateWith is Evaluate with at most parallel simulator runs at once (the
// research CPU share when called from the job queue).
func EvaluateWith(ctx context.Context, spec Spec, bars map[string][]data.Bar, specs map[string]instrument.Spec, parallel int) (*Evaluation, error) {
	if _, err := strategy.New(spec.Strategy, spec.Params); err != nil {
		return nil, fmt.Errorf("%w: %w", ErrSpec, err)
	}
	cfg, err := spec.Sim.Normalized()
	if err != nil {
		return nil, fmt.Errorf("%w: %w", ErrSpec, err)
	}
	spec.Sim = cfg
	tfDur, err := tfDuration(spec.Timeframe)
	if err != nil {
		return nil, err
	}
	from, to, err := span(bars)
	if err != nil {
		return nil, err
	}
	spec.Split = spec.Split.withDefaults() // the stored spec shows the plan actually used
	split, err := spec.Split.Make(from, to, tfDur)
	if err != nil {
		return nil, err
	}
	ev := &Evaluation{Spec: spec, Range: Window{from, to}, Split: split}

	upTo := func(end time.Time) map[string][]data.Bar {
		out := map[string][]data.Bar{}
		for s, bs := range bars {
			i, _ := slices.BinarySearchFunc(bs, end, func(b data.Bar, t time.Time) int { return b.OpenTime.Compare(t) })
			if i > 0 {
				out[s] = bs[:i:i]
			}
		}
		return out
	}
	oosBars, allBars := upTo(split.OOS.To), bars
	// Benchmarks start at the OOS window: buy-and-hold buys on its first bar, which
	// must not fall in the (gated) warm-up.
	benchBars := map[string][]data.Bar{}
	for s, bs := range oosBars {
		i, _ := slices.BinarySearchFunc(bs, split.OOS.From, func(b data.Bar, t time.Time) int { return b.OpenTime.Compare(t) })
		if i < len(bs) {
			benchBars[s] = bs[i:]
		}
	}

	type job struct {
		cfg      sim.Config
		params   strategy.Params
		bars     map[string][]data.Bar
		from     time.Time
		strategy string // empty: spec.Strategy
	}
	jobs := []job{
		{cfg, spec.Params, oosBars, split.OOS.From, ""},                  // 0: main (out of sample)
		{cfg, spec.Params, allBars, split.Holdout.From, ""},              // 1: holdout
		{stress(cfg, 2, 1, 0), spec.Params, oosBars, split.OOS.From, ""}, // 2..4: stress
		{stress(cfg, 1, 3, 0), spec.Params, oosBars, split.OOS.From, ""},
		{stress(cfg, 1, 1, 1), spec.Params, oosBars, split.OOS.From, ""},
	}
	// 5, 6: benchmarks — buy and hold (equal split across symbols) and cash.
	bhParams := strategy.Params{"exposure": float64(int64(money.RatioOne)/int64(len(oosBars))) / float64(money.RatioOne)}
	jobs = append(jobs,
		job{cfg, bhParams, benchBars, split.OOS.From, "buy-and-hold"},
		job{cfg, strategy.Params{}, benchBars, split.OOS.From, "hold-cash"},
	)
	grid, gridParams := neighbourhood(spec.Strategy, spec.Params)
	for _, p := range gridParams {
		jobs = append(jobs, job{cfg, p, oosBars, split.OOS.From, ""})
	}

	results := make([]*sim.Result, len(jobs))
	errs := make([]error, len(jobs))
	var wg sync.WaitGroup
	sem := make(chan struct{}, max(1, parallel))
	for i, j := range jobs {
		if j.params == nil {
			errs[i] = errInvalidCell
			continue
		}
		wg.Add(1)
		go func() {
			defer wg.Done()
			sem <- struct{}{}
			defer func() { <-sem }()
			name := spec.Strategy
			if j.strategy != "" {
				name = j.strategy
			}
			s, err := strategy.New(name, j.params)
			if err != nil {
				errs[i] = err
				return
			}
			results[i], errs[i] = sim.Run(ctx, j.cfg, specs, j.bars, gated{s, j.from})
		}()
	}
	wg.Wait()
	for i := range 2 { // main and holdout must succeed
		if errs[i] != nil {
			return nil, errs[i]
		}
	}
	if err := ctx.Err(); err != nil {
		return nil, err
	}

	ev.Main, ev.HoldoutRun = results[0], results[1]
	ev.OOS = view(results[0], split.OOS, cfg.Capital.V)
	ev.Holdout = view(results[1], split.Holdout, cfg.Capital.V)
	for _, f := range split.Folds {
		full := window(results[0], f.Test, cfg.Capital.V)
		ev.Folds = append(ev.Folds, FoldView{Fold: f, Metrics: pick(full, "net_pnl", "total_return", "max_drawdown", "trades", "win_rate")})
	}
	for k, key := range []string{"fee_x2", "slippage_x3", "latency_plus_1"} {
		sv := StressView{Key: key}
		if errs[2+k] != nil {
			sv.Error = errs[2+k].Error()
		} else {
			sv.Metrics = pick(window(results[2+k], split.OOS, cfg.Capital.V), "net_pnl", "total_return", "max_drawdown", "trades")
		}
		ev.Stress = append(ev.Stress, sv)
	}
	if grid != nil {
		for y := range grid.Cells {
			for x := range grid.Cells[y] {
				i := 7 + y*len(grid.Xs) + x
				c := &grid.Cells[y][x]
				switch {
				case errors.Is(errs[i], errInvalidCell):
					c.Invalid = "ترکیب پارامتر مجاز نیست"
				case errs[i] != nil:
					c.Invalid = errs[i].Error()
				default:
					c.Return, _ = metrics.Get(window(results[i], split.OOS, cfg.Capital.V), "total_return")
				}
			}
		}
		ev.Grid = grid
	}
	for k, key := range []string{"buy_and_hold", "hold_cash"} {
		if errs[5+k] != nil {
			continue // a benchmark that cannot run (e.g. no rate yet) is simply not drawn
		}
		bv := view(results[5+k], split.OOS, cfg.Capital.V)
		ret, _ := metrics.Get(bv.Metrics, "total_return")
		ev.Benchmarks = append(ev.Benchmarks, Benchmark{Key: key, Equity: bv.Equity, Return: ret})
	}
	if f, ok := sim.BreakEvenFee(results[0]); ok {
		ev.BreakEvenFee = &f
	}
	ev.Summary = summarize(ev)
	return ev, nil
}

var errInvalidCell = errors.New("eval: invalid parameter combination")

func tfDuration(tf data.Timeframe) (time.Duration, error) {
	if _, err := data.ParseTimeframe(string(tf)); err != nil {
		return 0, fmt.Errorf("%w: %w", ErrSpec, err)
	}
	return tf.Duration(), nil
}

func span(bars map[string][]data.Bar) (time.Time, time.Time, error) {
	var from, to time.Time
	for _, bs := range bars {
		if len(bs) == 0 {
			continue
		}
		if from.IsZero() || bs[0].OpenTime.Before(from) {
			from = bs[0].OpenTime
		}
		if end := bs[len(bs)-1].CloseTime; end.After(to) {
			to = end
		}
	}
	if from.IsZero() {
		return from, to, fmt.Errorf("%w: no bars", ErrSpec)
	}
	return from, to, nil
}

func stress(c sim.Config, feeX, slipX int64, latency int) sim.Config {
	c.FeeRate *= money.Ratio(feeX)
	c.SlipRate *= money.Ratio(slipX)
	c.LatencyBars += latency
	return c
}

// window computes metrics of a run over w only: equity at closes inside w, trades
// opened inside w, starting from the equity at w's start.
func window(r *sim.Result, w Window, capital int64) []metrics.Metric {
	in := metrics.Input{Start: w.From, End: w.To, Initial: capital}
	for _, p := range r.Equity {
		switch {
		case !p.Time.After(w.From):
			in.Initial = p.Equity.V // last mark at or before the window start
		case !p.Time.After(w.To):
			in.Equity = append(in.Equity, metrics.Point{T: p.Time, Equity: p.Equity.V})
		}
	}
	for _, t := range r.Trades {
		if !w.Contains(t.OpenedAt) {
			continue
		}
		mt := metrics.Trade{Opened: t.OpenedAt, Gross: t.Gross.V, Fees: t.Fees.V, Slippage: t.Slippage.V, Net: t.Net.V}
		if t.ClosedAt != nil && !t.ClosedAt.After(w.To) {
			c := *t.ClosedAt
			mt.Closed = &c
		}
		in.Trades = append(in.Trades, mt)
	}
	return metrics.Compute(in)
}

func view(r *sim.Result, w Window, capital int64) RunView {
	v := RunView{Window: w, Metrics: window(r, w, capital), AmbiguousBars: r.AmbiguousBars}
	var pts []EquityPoint
	for _, p := range r.Equity {
		if p.Time.After(w.From) && !p.Time.After(w.To) {
			pts = append(pts, EquityPoint{p.Time, p.Equity})
		}
	}
	v.Equity = downsample(pts, 1000)
	return v
}

// downsample keeps at most n points: evenly strided, always the first and last.
func downsample(pts []EquityPoint, n int) []EquityPoint {
	if len(pts) <= n {
		return pts
	}
	out := make([]EquityPoint, 0, n)
	for i := 0; i < n-1; i++ {
		out = append(out, pts[i*(len(pts)-1)/(n-1)])
	}
	return append(out, pts[len(pts)-1])
}

func pick(ms []metrics.Metric, keys ...string) []metrics.Metric {
	out := make([]metrics.Metric, 0, len(keys))
	for _, k := range keys {
		if m, ok := metrics.Get(ms, k); ok {
			out = append(out, m)
		}
	}
	return out
}

// neighbourhood varies the first two signal parameters (not "exposure") around
// their values. Returns the grid shape and one params set per cell (row-major);
// nil params mark combinations the strategy rejects.
func neighbourhood(name string, p strategy.Params) (*Grid, []strategy.Params) {
	var dims []strategy.ParamSpec
	for _, s := range strategy.ParamSpecs[name] {
		if s.Name != "exposure" && len(dims) < 2 {
			dims = append(dims, s)
		}
	}
	if len(dims) == 0 {
		return nil, nil
	}
	steps := func(s strategy.ParamSpec) []float64 {
		v := p[s.Name]
		d := v * 0.1
		if s.Integer {
			d = math.Max(1, math.Round(d))
		}
		return []float64{v - d, v, v + d}
	}
	g := &Grid{X: dims[0].Name, Xs: steps(dims[0]), Ys: []float64{0}}
	if len(dims) == 2 {
		g.Y, g.Ys = dims[1].Name, steps(dims[1])
	}
	var all []strategy.Params
	g.Cells = make([][]GridCell, len(g.Ys))
	for yi, y := range g.Ys {
		g.Cells[yi] = make([]GridCell, len(g.Xs))
		for xi, x := range g.Xs {
			q := strategy.Params{}
			for k, v := range p {
				q[k] = v
			}
			q[g.X] = x
			if g.Y != "" {
				q[g.Y] = y
			}
			g.Cells[yi][xi].Center = xi == 1 && (g.Y == "" || yi == 1)
			if _, err := strategy.New(name, q); err != nil {
				q = nil
			}
			all = append(all, q)
		}
	}
	return g, all
}

// StepsFrom turns recorded decisions back into a script: each intent fires at the
// same input bar it was decided on.
func StepsFrom(ds []sim.Decision) []strategy.Step {
	steps := make([]strategy.Step, 0, len(ds))
	for _, d := range ds {
		steps = append(steps, strategy.Step{At: d.InputBarOpen, Symbol: d.InputSymbol, Intent: strategy.Intent{
			Instrument: d.Instrument, Target: d.Target, StopLoss: d.StopLoss, TakeProfit: d.TakeProfit,
			Reason: d.Reason, ModelID: d.ModelID, RecipeVersion: d.RecipeVersion,
		}})
	}
	return steps
}

// Replay re-runs a report's recorded out-of-sample intents with cfg (capital,
// sizing, costs may differ). With the report's own config it reproduces the
// original run exactly; it is what the P&L calculator recomputes.
//
// scale multiplies every non-zero target exposure (RatioOne = as recorded), capped
// at 100%: "enter with X% of equity" in the calculator.
func Replay(ctx context.Context, split Split, ds []sim.Decision, cfg sim.Config, scale money.Ratio, bars map[string][]data.Bar, specs map[string]instrument.Spec) (RunView, *sim.Result, error) {
	cfg, err := cfg.Normalized()
	if err != nil {
		return RunView{}, nil, fmt.Errorf("%w: %w", ErrSpec, err)
	}
	oos := map[string][]data.Bar{}
	for s, bs := range bars {
		i, _ := slices.BinarySearchFunc(bs, split.OOS.To, func(b data.Bar, t time.Time) int { return b.OpenTime.Compare(t) })
		if i > 0 {
			oos[s] = bs[:i:i]
		}
	}
	if scale <= 0 || scale > money.RatioOne {
		return RunView{}, nil, fmt.Errorf("%w: position size must be in (0%%, 100%%]", ErrSpec)
	}
	steps := StepsFrom(ds)
	for i := range steps {
		t := &steps[i].Intent.Target
		if *t > 0 {
			v, _ := scale.Apply(int64(*t), money.Floor)
			*t = money.Ratio(min(v, int64(money.RatioOne)))
		}
	}
	res, err := sim.Run(ctx, cfg, specs, oos, strategy.NewScripted(steps))
	if err != nil {
		return RunView{}, nil, err
	}
	return view(res, split.OOS, cfg.Capital.V), res, nil
}
