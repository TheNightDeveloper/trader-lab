package loop

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"slices"
	"sync"
	"sync/atomic"
	"time"

	"github.com/jackc/pgx/v5/pgconn"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/model/train"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

// Cycle states, in order. "decision" = a recommendation waits for the user.
const (
	Collect     = "collect"
	Labels      = "labels"
	Generate    = "generate"
	Train       = "train"
	WalkForward = "walk_forward"
	ForwardTest = "forward_test"
	Decision    = "decision"
	Done        = "done"
)

// Outcomes.
const (
	Skipped     = "skipped"
	Failed      = "failed"
	NotBetter   = "not_better"
	GateFailed  = "gate_failed"
	Recommended = "recommended"
	Approved    = "approved"
	Rejected    = "rejected"
)

// Doc is a cycle's record: its pre-registered config and everything it found.
type Doc struct {
	EvaluationVersion string            `json:"evaluation_version,omitempty"`
	Config            Config            `json:"config"`
	Champion          Contender         `json:"champion"`
	Datasets          []string          `json:"datasets,omitempty"`
	DataFrom          time.Time         `json:"data_from"`
	DataTo            time.Time         `json:"data_to"`
	FreshBars         int               `json:"fresh_bars"`
	Steps             map[string]string `json:"steps"` // short progress note per state
	Candidates        int               `json:"candidates"`
	Eligible          int               `json:"eligible"`
	Walk              *Walk             `json:"walk,omitempty"`
	Challenger        *Contender        `json:"challenger,omitempty"`
	FreezeAt          *time.Time        `json:"freeze_at,omitempty"`
	TrainingCutoff    *time.Time        `json:"training_cutoff,omitempty"`
	ModelCreatedAt    *time.Time        `json:"model_created_at,omitempty"`
	TradeStart        *time.Time        `json:"trade_start,omitempty"`
	Forward           *Forward          `json:"forward,omitempty"`
	// Datasets of the forward window, recorded at the decision.
	ForwardDatasets []string   `json:"forward_datasets,omitempty"`
	Gate            []GateItem `json:"gate,omitempty"`
	Usage           Usage      `json:"usage"`
}

// Contender is the champion (active version) or the challenger (best candidate).
type Contender struct {
	// Revision pins the champion before training; nil identifies legacy evidence.
	Revision  *int64       `json:"lifecycle_revision,omitempty"`
	VersionID string       `json:"version_id,omitempty"` // champion
	Seq       int          `json:"seq,omitempty"`        // challenger: candidate number
	Change    string       `json:"change,omitempty"`
	Recipe    model.Recipe `json:"recipe"`
	// ModelID: the frozen model forward-tested. For the champion it is the active
	// model when there is one (Active), else a baseline trained at the freeze.
	ModelID string           `json:"model_id,omitempty"`
	Active  bool             `json:"active,omitempty"`
	Walk    []metrics.Metric `json:"walk,omitempty"` // walk-forward out-of-sample metrics
}

type Walk struct {
	Folds      []eval.Fold     `json:"folds"`
	Champion   []eval.FoldView `json:"champion"`
	Challenger []eval.FoldView `json:"challenger"`
	Wins       int             `json:"wins"`
}

type Forward struct {
	Through        time.Time        `json:"through"`
	Days           int              `json:"days"`
	Champion       []metrics.Metric `json:"champion"`
	Challenger     []metrics.Metric `json:"challenger"`
	MissingSymbols []string         `json:"missing_symbols,omitempty"`
}

// GateItem: Status is pass | fail | pending; Text is the plain-language condition.
type GateItem struct {
	Key    string `json:"key"`
	Status string `json:"status"`
	Text   string `json:"text"`
}

type Usage struct {
	CPUMillis  int64 `json:"cpu_ms"`
	Candidates int   `json:"candidates"`
	Bars       int   `json:"bars"`
}

// CandidateResult is stored with each candidate.
type CandidateResult struct {
	Metrics  []metrics.Metric `json:"metrics"`
	Folds    []eval.FoldView  `json:"folds"`
	Wins     int              `json:"wins"`
	Eligible bool             `json:"eligible"`
	Why      string           `json:"why,omitempty"` // why not eligible
}

// Loop owns learning cycles: scheduling, running, forward tests and decisions.
type Loop struct {
	Store   *store.Store
	Clock   clock.Clock
	Limiter *jobs.Limiter
	Poll    time.Duration // scheduler tick; default 1 minute

	base    context.Context
	mu      sync.Mutex
	cancels map[int64]context.CancelFunc
}

// Begin opens a cycle with the current config. One open cycle per algorithm.
func (l *Loop) Begin(ctx context.Context, trigger string) (int64, error) {
	cfg, err := LoadConfig(ctx, l.Store.Queries)
	if err != nil {
		return 0, err
	}
	if err := cfg.Validate(); err != nil {
		return 0, err
	}
	doc, err := json.Marshal(Doc{EvaluationVersion: eval.Version, Config: cfg, Steps: map[string]string{}})
	if err != nil {
		return 0, err
	}
	id, err := l.Store.InsertCycle(ctx, db.InsertCycleParams{AlgorithmID: cfg.Algorithm, Trigger: trigger, Doc: doc, StartedAt: l.Clock.Now().UTC()})
	var pe *pgconn.PgError
	if errors.As(err, &pe) && pe.Code == "23505" {
		return 0, ErrBusy
	}
	return id, err
}

// Start opens a cycle and runs it in the background (until it freezes a
// challenger, skips, or ends).
func (l *Loop) Start(ctx context.Context, trigger string) (int64, error) {
	id, err := l.Begin(ctx, trigger)
	if err != nil {
		return 0, err
	}
	base := l.base
	if base == nil {
		base = context.Background()
	}
	runCtx, cancel := context.WithCancel(base)
	l.mu.Lock()
	if l.cancels == nil {
		l.cancels = map[int64]context.CancelFunc{}
	}
	l.cancels[id] = cancel
	l.mu.Unlock()
	go func() {
		defer func() {
			cancel()
			l.mu.Lock()
			delete(l.cancels, id)
			l.mu.Unlock()
		}()
		_ = l.RunCycle(runCtx, id)
	}()
	return id, nil
}

type cycle struct {
	row db.LearningCycle
	doc Doc
}

func (l *Loop) load(ctx context.Context, q *db.Queries, id int64) (cycle, error) {
	row, err := q.GetCycle(ctx, id)
	if err != nil {
		return cycle{}, fmt.Errorf("%w: cycle %d", ErrNotFound, id)
	}
	var d Doc
	if err := json.Unmarshal(row.Doc, &d); err != nil {
		return cycle{}, fmt.Errorf("cycle %d: %w", id, err)
	}
	if d.Steps == nil {
		d.Steps = map[string]string{}
	}
	return cycle{row, d}, nil
}

func (l *Loop) save(ctx context.Context, q *db.Queries, c *cycle) error {
	b, err := json.Marshal(c.doc)
	if err != nil {
		return err
	}
	c.row.Doc = b
	return q.UpdateCycle(ctx, db.UpdateCycleParams{
		ID: c.row.ID, State: c.row.State, Outcome: c.row.Outcome, Reason: c.row.Reason, Doc: b,
		ConsumedUntil: c.row.ConsumedUntil, FinishedAt: c.row.FinishedAt,
	})
}

func (l *Loop) step(ctx context.Context, c *cycle, state string) error {
	c.row.State = state
	return l.save(ctx, l.Store.Queries, c)
}

// finish ends a cycle. It never touches the active version or model.
func (l *Loop) finish(c *cycle, outcome, reason string) error {
	now := l.Clock.Now().UTC()
	c.row.State, c.row.Outcome, c.row.Reason, c.row.FinishedAt = Done, outcome, reason, &now
	// A cancelled run still has to be recorded: write with a fresh context.
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	return l.Store.InTx(ctx, func(q *db.Queries) error {
		row, err := q.GetCycleForUpdate(ctx, c.row.ID)
		if err != nil {
			return err
		}
		if row.State == Done {
			return nil
		}
		if _, err := q.CancelCycleCandidates(ctx, db.CancelCycleCandidatesParams{CycleID: c.row.ID, Failure: reason}); err != nil {
			return err
		}
		rows, err := q.ListCandidates(ctx, c.row.ID)
		if err != nil {
			return err
		}
		// Generation can be interrupted before its summary checkpoint was saved.
		// The durable registry, including cancelled rows, is the source of truth.
		c.doc.Candidates = len(rows)
		c.doc.Usage.Candidates = max(c.doc.Usage.Candidates, len(rows))
		c.doc.Eligible = 0
		for _, row := range rows {
			var result CandidateResult
			if row.Status == "done" && json.Unmarshal(row.Result, &result) == nil && result.Eligible {
				c.doc.Eligible++
			}
		}
		return l.save(ctx, q, c)
	})
}

const interrupted = "قطع شد پیش از پایان؛ نسخه و مدل فعال دست‌نخورده ماندند."

// RunCycle runs a cycle from collect until it freezes a challenger for the
// forward test, or ends (skipped, not better, failed). Any error or cancellation
// ends it as failed; the active version and model are never changed here.
func (l *Loop) RunCycle(ctx context.Context, id int64) (err error) {
	c, err := l.load(ctx, l.Store.Queries, id)
	if err != nil {
		return err
	}
	if c.row.State != Collect {
		return fmt.Errorf("%w: cycle %d is in %s", ErrState, id, c.row.State)
	}
	if err := l.run(ctx, &c); err != nil {
		reason := "شکست: " + err.Error() + " — نسخه و مدل فعال دست‌نخورده ماندند."
		if ctx.Err() != nil {
			reason = interrupted
		}
		if ferr := l.finish(&c, Failed, reason); ferr != nil {
			return errors.Join(err, ferr)
		}
		return err
	}
	return nil
}

// champion is the active version of the algorithm (else its newest usable
// version) and, when it matches that version's recipe, the active model.
func (l *Loop) champion(ctx context.Context, alg string) (Contender, error) {
	snapshot, err := experiment.Snapshot(ctx, l.Store, alg)
	if err != nil {
		return Contender{}, err
	}
	a := snapshot.Algorithm
	vs := snapshot.Versions
	var pick *db.AlgorithmVersion
	for i, v := range vs {
		if v.State == experiment.Active {
			pick = &vs[i]
			break
		}
		if pick == nil && v.State != experiment.Retired {
			pick = &vs[i]
		}
	}
	if pick == nil {
		return Contender{}, fmt.Errorf("%w: %s has no usable version", ErrConfig, alg)
	}
	_, def, err := experiment.Version(ctx, l.Store.Queries, pick.ID)
	if err != nil {
		return Contender{}, err
	}
	if def.Recipe == nil {
		return Contender{}, fmt.Errorf("%w: %s is not a learning algorithm", ErrConfig, alg)
	}
	ch := Contender{VersionID: pick.ID, Recipe: *def.Recipe, Revision: &a.LifecycleRevision}
	if a.ActiveModel.Valid && pick.State == experiment.Active {
		m := *snapshot.Model
		if m.RecipeHash == ch.Recipe.Hash() {
			ch.ModelID, ch.Active = m.ID, true
		}
	}
	return ch, nil
}

func (l *Loop) artifact(ctx context.Context, id string) (model.Artifact, error) {
	row, err := l.Store.GetArtifact(ctx, id)
	if err != nil {
		return model.Artifact{}, fmt.Errorf("%w: model %s", ErrNotFound, id)
	}
	return model.Load(row.Body)
}

func (l *Loop) storeArtifact(ctx context.Context, cycleID int64, a model.Artifact) error {
	b, err := a.Save()
	if err != nil {
		return err
	}
	return l.Store.InsertArtifact(ctx, db.InsertArtifactParams{ID: a.ID, AlgorithmID: a.Algorithm, RecipeHash: a.RecipeHash, AsOf: a.AsOf, CycleID: &cycleID, Body: b})
}

func (c Config) sim() sim.Config {
	return sim.Config{Capital: c.Capital, FeeRate: c.Fee, SlipRate: c.Slippage, LatencyBars: 1}
}

// dataEnd: the last bar used closes at least one bar before now, so every bar
// in range was available when the cycle read it.
func dataEnd(now time.Time, tf time.Duration) time.Time { return now.Add(-tf).Truncate(tf) }

func (l *Loop) run(ctx context.Context, c *cycle) (err error) {
	cfg := c.doc.Config
	if err := cfg.researchError(); err != nil {
		return err
	}
	tf := cfg.Timeframe.Duration()
	champ, err := l.champion(ctx, cfg.Algorithm)
	if err != nil {
		return err
	}
	c.doc.Champion = champ

	// collect
	to := dataEnd(l.Clock.Now().UTC(), tf)
	from := to.Add(-time.Duration(cfg.LookbackDays) * 24 * time.Hour)
	c.doc.DataFrom, c.doc.DataTo = from, to
	rawCount, err := data.RawBarCount(cfg.Timeframe, from, to)
	if err != nil {
		return err
	}
	if rawCount > data.MaxRawBars/len(cfg.Symbols) || int64(rawCount)*int64(time.Minute)*int64(len(cfg.Symbols))/int64(tf) > int64(cfg.MaxBars) {
		return l.finish(c, Skipped, "پرش: بازهٔ داده بیش از بودجهٔ کندل خام یا آموزش است؛ بازه را کوتاه‌تر کنید.")
	}
	consumed, err := l.Store.ConsumedUntil(ctx, cfg.Algorithm)
	if err != nil {
		return err
	}
	bars := map[string][]data.Bar{}
	fresh := -1
	err = func() error {
		// Release collection admission before parallel training takes its own slots.
		if err := l.Limiter.Acquire(ctx); err != nil {
			return err
		}
		defer l.Limiter.Release()
		for _, sym := range cfg.Symbols {
			ds, bs, err := data.CreateDataset(ctx, l.Store, data.DatasetSpec{Symbol: sym, Timeframe: cfg.Timeframe, From: from, To: to, GapPolicy: data.GapFlag})
			if err != nil {
				return err
			}
			c.doc.Datasets = append(c.doc.Datasets, ds.ID)
			bars[sym] = bs
			c.doc.Usage.Bars += len(bs)
			n := len(bs) - firstAtOrAfter(bs, consumed)
			if fresh < 0 || n < fresh {
				fresh = n
			}
		}
		return nil
	}()
	if err != nil {
		return err
	}
	c.doc.FreshBars = fresh
	c.doc.Steps[Collect] = fmt.Sprintf("+%d bars", fresh)
	if c.doc.Usage.Bars > cfg.MaxBars {
		return l.finish(c, Skipped, fmt.Sprintf("پرش: بودجه حافظه — %d کندل بیش از سقف %d", c.doc.Usage.Bars, cfg.MaxBars))
	}
	if fresh < cfg.MinFreshBars {
		return l.finish(c, Skipped, fmt.Sprintf("پرش: داده تازه ناکافی — %d از %d کندل لازم", fresh, cfg.MinFreshBars))
	}

	// labels: training uses only labels ready by each step's as-of time.
	c.doc.Steps[Labels] = fmt.Sprintf("h=%d", champ.Recipe.Horizon)
	if err := l.step(ctx, c, Labels); err != nil {
		return err
	}

	// generate
	vars := Variants(champ.Recipe, cfg.MaxCandidates)
	for i, v := range vars {
		rj, err := json.Marshal(v.Recipe)
		if err != nil {
			return err
		}
		if err := l.Store.InsertCandidate(ctx, db.InsertCandidateParams{CycleID: c.row.ID, Seq: int32(i + 1), Change: v.Change, Recipe: rj, RecipeHash: v.Recipe.Hash()}); err != nil {
			return err
		}
	}
	c.doc.Candidates, c.doc.Usage.Candidates = len(vars), len(vars)
	c.doc.Steps[Generate] = fmt.Sprintf("%d candidates", len(vars))
	split, err := cycleSplit(from, to, consumed, cfg.Folds, tf, time.Duration(champ.Recipe.Horizon)*tf)
	if err != nil {
		return l.finish(c, Skipped, "پرش: "+err.Error())
	}
	if err := l.step(ctx, c, Generate); err != nil {
		return err
	}

	// Reserve the worst-case slot time through walk-forward and both final fits.
	ctx, cancelTraining := trainingDeadline(ctx, time.Duration(cfg.CPUMinutes)*time.Minute, l.Limiter.Size())
	defer cancelTraining()
	defer func() {
		if err != nil && errors.Is(context.Cause(ctx), errBudget) {
			err = errors.Join(errBudget, err)
		}
	}()
	// train: every contender retrained per fold on its own past.
	if err := l.step(ctx, c, Train); err != nil {
		return err
	}
	recipes := []model.Recipe{champ.Recipe}
	for _, v := range vars {
		recipes = append(recipes, v.Recipe)
	}
	meta := train.Meta{Algorithm: cfg.Algorithm, DatasetIDs: c.doc.Datasets, Seed: cfg.Seed}
	var steps []train.Step
	for _, f := range split.Folds {
		steps = append(steps, train.Step{From: f.Train.From, To: f.Train.To, AsOf: f.Test.From})
	}
	budget := int64(cfg.CPUMinutes) * 60_000
	var used atomic.Int64
	var finalStarted time.Time
	defer func() {
		c.doc.Usage.CPUMillis = used.Load()
		if !finalStarted.IsZero() {
			c.doc.Usage.CPUMillis += time.Since(finalStarted).Milliseconds()
		}
	}()
	models := make([][]model.Artifact, len(recipes))
	errs := make([]error, len(recipes))
	l.parallel(ctx, len(recipes), func(i int) {
		if used.Load() >= budget {
			errs[i] = errBudget
			return
		}
		t := time.Now() // wall clock: CPU accounting only, never in results
		models[i], errs[i] = train.WalkForward(ctx, recipes[i], bars, steps, meta)
		used.Add(time.Since(t).Milliseconds())
	})
	if err := ctx.Err(); err != nil {
		return err
	}
	if errs[0] != nil {
		return fmt.Errorf("champion recipe: %w", errs[0])
	}
	c.doc.Steps[Train] = fmt.Sprintf("CPU %s", (time.Duration(used.Load()) * time.Millisecond).Round(time.Second))

	// walk-forward
	if err := l.step(ctx, c, WalkForward); err != nil {
		return err
	}
	type res struct {
		view  eval.RunView
		folds []eval.FoldView
	}
	results := make([]res, len(recipes))
	l.parallel(ctx, len(recipes), func(i int) {
		if errs[i] != nil {
			return
		}
		t := time.Now()
		defer func() { used.Add(time.Since(t).Milliseconds()) }()
		s, err := strategy.NewLearned(models[i])
		if err != nil {
			errs[i] = err
			return
		}
		v, f, _, err := eval.RunSplit(ctx, s, cfg.sim(), report.Specs(), bars, split)
		results[i], errs[i] = res{v, f}, err
	})
	if err := ctx.Err(); err != nil {
		return err
	}
	if errs[0] != nil {
		return fmt.Errorf("champion walk-forward: %w", errs[0])
	}
	c.doc.Usage.CPUMillis = used.Load()
	c.doc.Champion.Walk = results[0].view.Metrics
	champRet := metricV(results[0].view.Metrics, "total_return")
	best, bestRet := 0, int64(0)
	for i := 1; i < len(recipes); i++ {
		status, failure := "done", ""
		var r CandidateResult
		switch {
		case errors.Is(errs[i], errBudget):
			status, failure = "cancelled", "بودجه CPU چرخه تمام شد"
		case errs[i] != nil:
			status, failure = "failed", errs[i].Error()
		default:
			r = judge(cfg.Gate, results[i].view.Metrics, results[i].folds, results[0].folds, champRet)
			if r.Eligible {
				c.doc.Eligible++
				if v := metricV(r.Metrics, "total_return"); best == 0 || v > bestRet {
					best, bestRet = i, v
				}
			}
		}
		rj, err := json.Marshal(r)
		if err != nil {
			return err
		}
		if err := l.Store.EndCandidate(ctx, db.EndCandidateParams{CycleID: c.row.ID, Seq: int32(i), Status: status, Failure: failure, Result: rj}); err != nil {
			return err
		}
	}
	c.doc.Steps[WalkForward] = fmt.Sprintf("%d eligible", c.doc.Eligible)
	if best == 0 {
		return l.finish(c, NotBetter, "نامزد بهتر نیست: هیچ نامزدی در ارزیابی گام‌به‌گام هم از قهرمان بهتر بود و هم محدودیت‌های سخت را رعایت کرد.")
	}
	wins := countWins(results[best].folds, results[0].folds)
	c.doc.Walk = &Walk{Folds: split.Folds, Champion: results[0].folds, Challenger: results[best].folds, Wins: wins}
	c.doc.Challenger = &Contender{Seq: best, Change: vars[best-1].Change, Recipe: recipes[best], Walk: results[best].view.Metrics}
	if wins < cfg.Gate.MinWalkWins {
		c.doc.Gate = gate(cfg.Gate, &c.doc, false)
		return l.finish(c, GateFailed, fmt.Sprintf("رد: برتری در گام‌به‌گام ناکافی — %d از %d گام (لازم: %d)", wins, len(split.Folds), cfg.Gate.MinWalkWins))
	}

	// freeze: the challenger is trained once on everything ready at the freeze and
	// never changes during its forward test. The champion keeps its active model;
	// without one, its recipe gets a baseline trained the same way.
	c.doc.TrainingCutoff = &to
	if err := l.Limiter.Acquire(ctx); err != nil {
		return err
	}
	defer l.Limiter.Release()
	finalStarted = time.Now()
	one := []train.Step{{From: from, To: to, AsOf: to}}
	if !champ.Active {
		ms, err := train.WalkForward(ctx, champ.Recipe, bars, one, meta)
		if err != nil {
			return fmt.Errorf("champion baseline: %w", err)
		}
		ms[0].AsOf = l.Clock.Now().UTC()
		ms[0].Seal()
		if err := l.storeArtifact(ctx, c.row.ID, ms[0]); err != nil {
			return err
		}
		c.doc.Champion.ModelID = ms[0].ID
	}
	meta.Parent = c.doc.Champion.ModelID
	ms, err := train.WalkForward(ctx, recipes[best], bars, one, meta)
	if err != nil {
		return fmt.Errorf("challenger: %w", err)
	}
	created := l.Clock.Now().UTC()
	if created.Before(to) {
		return fmt.Errorf("%w: model creation precedes training cutoff", ErrState)
	}
	ms[0].AsOf = created
	ms[0].Seal()
	if err := l.storeArtifact(ctx, c.row.ID, ms[0]); err != nil {
		return err
	}
	c.doc.Challenger.ModelID = ms[0].ID
	freeze := l.Clock.Now().UTC()
	if freeze.Before(created) {
		return fmt.Errorf("%w: clock moved backwards during freeze", ErrState)
	}
	tradeStart := freeze.Truncate(tf)
	if tradeStart.Before(freeze) {
		tradeStart = tradeStart.Add(tf)
	}
	c.doc.ModelCreatedAt = &created
	c.doc.FreezeAt = &freeze
	c.doc.TradeStart = &tradeStart
	c.doc.Steps[ForwardTest] = fmt.Sprintf("0 / %d d", cfg.Gate.ForwardDays)
	c.doc.Gate = gate(cfg.Gate, &c.doc, false)
	c.doc.Usage.CPUMillis = used.Load() + time.Since(finalStarted).Milliseconds()
	return l.step(ctx, c, ForwardTest)
}

var errBudget = errors.New("loop: CPU budget exhausted")

// Count waiting/IO conservatively too: wall time times maximum slots bounds slot work.
// This is not measured OS CPU time or a process-wide memory guarantee.
func trainingDeadline(ctx context.Context, budget time.Duration, slots int) (context.Context, context.CancelFunc) {
	return context.WithTimeoutCause(ctx, budget/time.Duration(max(1, slots)), errBudget)
}

func (l *Loop) logErr(err error) { slog.Error("learning loop", "err", err) }

// parallel runs f(0..n-1), each holding one research slot.
func (l *Loop) parallel(ctx context.Context, n int, f func(i int)) {
	var wg sync.WaitGroup
	for i := range n {
		if err := l.Limiter.Acquire(ctx); err != nil {
			break
		}
		wg.Add(1)
		go func() {
			defer wg.Done()
			defer l.Limiter.Release()
			f(i)
		}()
	}
	wg.Wait()
}

func firstAtOrAfter(bs []data.Bar, t time.Time) int {
	i, _ := slices.BinarySearchFunc(bs, t, func(b data.Bar, t time.Time) int { return b.OpenTime.Compare(t) })
	return i
}

func metricV(ms []metrics.Metric, key string) int64 {
	m, _ := metrics.Get(ms, key)
	return m.V
}

func metricOK(ms []metrics.Metric, key string) (int64, bool) {
	m, ok := metrics.Get(ms, key)
	return m.V, ok && m.Valid
}

func countWins(a, b []eval.FoldView) int {
	n := 0
	for i := range a {
		if i >= len(b) || !a[i].Fold.Test.From.Before(a[i].Fold.Test.To) || !a[i].Fold.Test.From.Equal(b[i].Fold.Test.From) || !a[i].Fold.Test.To.Equal(b[i].Fold.Test.To) {
			continue
		}
		av, aok := metricOK(a[i].Metrics, "period_pnl")
		bv, bok := metricOK(b[i].Metrics, "period_pnl")
		if aok && bok && av > bv {
			n++
		}
	}
	return n
}

// judge: a candidate is eligible when its walk-forward drawdown is within the hard
// cap and its return beats the champion's on the same folds.
func judge(g Gate, ms []metrics.Metric, folds, champFolds []eval.FoldView, champRet int64) CandidateResult {
	r := CandidateResult{Metrics: ms, Folds: folds, Wins: countWins(folds, champFolds)}
	dd, okDD := metricOK(ms, "max_drawdown")
	ret, okRet := metricOK(ms, "total_return")
	switch {
	case !okDD || !okRet:
		r.Why = "معیار نامعتبر (نمونه کم)"
	case dd > int64(g.MaxDrawdown):
		r.Why = "افت سرمایه بیش از سقف"
	case ret <= champRet:
		r.Why = "بازده نه بیشتر از قهرمان"
	default:
		r.Eligible = true
	}
	return r
}

// cycleSplit: training always starts at from (expanding); test windows cover the
// part of [from, to) not used by an earlier decision's forward test, and leave at
// least one fold's length for the first training window.
func cycleSplit(from, to, consumed time.Time, folds int, tf, embargo time.Duration) (eval.Split, error) {
	testFrom := from.Add((to.Sub(from) / time.Duration(folds+1)).Truncate(tf))
	if consumed.After(testFrom) {
		testFrom = consumed.Truncate(tf)
		if testFrom.Before(consumed) {
			testFrom = testFrom.Add(tf)
		}
	}
	chunk := (to.Sub(testFrom) / time.Duration(folds)).Truncate(tf)
	if chunk < 24*tf || chunk <= embargo {
		return eval.Split{}, fmt.Errorf("داده تازه برای %d گام ارزیابی کافی نیست", folds)
	}
	var s eval.Split
	for i := range folds {
		f := testFrom.Add(chunk * time.Duration(i))
		t := f.Add(chunk)
		if i == folds-1 {
			t = to
		}
		s.Folds = append(s.Folds, eval.Fold{Index: i + 1, Train: eval.Window{From: from, To: f.Add(-embargo)}, Test: eval.Window{From: f, To: t}})
	}
	s.OOS = eval.Window{From: testFrom, To: to}
	s.Holdout = eval.Window{From: to, To: to}
	return s, nil
}
