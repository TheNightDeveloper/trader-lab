package search

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

// errCancelled marks an attempt stopped by the user (recorded as cancelled), as
// opposed to an engine shutdown (left running, re-queued on the next start).
var errCancelled = errors.New("cancelled by user")

// Scheduler runs queued attempts within the research CPU share. State lives in the
// database: killing the engine at any point loses nothing — attempts left
// running are re-queued on start and run again with the same inputs.
type Scheduler struct {
	Store   *store.Store
	Reports report.Service
	Limiter *jobs.Limiter
	Build   string        // engine build hash: part of every cache key
	Poll    time.Duration // idle wait between queue checks (default 500 ms)

	mu      sync.Mutex
	running map[string]map[int32]context.CancelCauseFunc
	defs    map[string]experiment.Definition
	bars    map[string]datasetBars
	wake    chan struct{}
}

type datasetBars struct {
	tf   data.Timeframe
	bars []data.Bar
	used time.Time
}

// maxCachedDatasets: datasets kept in memory between attempts.
// ponytail: tiny LRU by last use; a byte budget if datasets get large.
const maxCachedDatasets = 4

func (s *Scheduler) init() {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.running == nil {
		s.running = map[string]map[int32]context.CancelCauseFunc{}
		s.defs = map[string]experiment.Definition{}
		s.bars = map[string]datasetBars{}
		s.wake = make(chan struct{}, 1)
	}
	if s.Poll == 0 {
		s.Poll = 500 * time.Millisecond
	}
}

// Wake makes the loop look at the queue now (after a new experiment or resume).
func (s *Scheduler) Wake() {
	s.init()
	select {
	case s.wake <- struct{}{}:
	default:
	}
}

// Run processes the queue until ctx ends, then waits for running attempts.
func (s *Scheduler) Run(ctx context.Context) error {
	s.init()
	if n, err := s.Store.RequeueRunning(ctx); err != nil {
		return fmt.Errorf("requeue: %w", err)
	} else if n > 0 {
		slog.Info("re-queued attempts interrupted by the last shutdown", "attempts", n)
	}
	var wg sync.WaitGroup
	defer wg.Wait()
	lastHouse := time.Time{}
	for ctx.Err() == nil {
		if time.Since(lastHouse) >= s.Poll {
			s.housekeep(ctx)
			lastHouse = time.Now()
		}
		if err := s.Limiter.Acquire(ctx); err != nil {
			return nil
		}
		a, err := s.Store.ClaimAttempt(ctx)
		if err != nil {
			s.Limiter.Release()
			if !errors.Is(err, pgx.ErrNoRows) && ctx.Err() == nil {
				slog.Warn("claim attempt", "err", err)
			}
			select {
			case <-ctx.Done():
			case <-s.wake:
			case <-time.After(s.Poll):
			}
			continue
		}
		wg.Add(1)
		go func() {
			defer wg.Done()
			defer s.Limiter.Release()
			s.run(ctx, a)
			s.Wake()
		}()
	}
	return nil
}

// Cancel stops an experiment's running attempts (they are recorded as cancelled).
func (s *Scheduler) Cancel(id string) {
	s.init()
	s.mu.Lock()
	defer s.mu.Unlock()
	for _, cancel := range s.running[id] {
		cancel(errCancelled)
	}
}

func (s *Scheduler) definition(ctx context.Context, id string) (experiment.Definition, error) {
	s.mu.Lock()
	def, ok := s.defs[id]
	s.mu.Unlock()
	if ok {
		return def, nil
	}
	e, err := experiment.Load(ctx, s.Store.Queries, id)
	if err != nil {
		return def, err
	}
	s.mu.Lock()
	s.defs[id] = e.Def
	s.mu.Unlock()
	return e.Def, nil
}

func (s *Scheduler) dataset(ctx context.Context, id string) (datasetBars, error) {
	s.mu.Lock()
	d, ok := s.bars[id]
	if ok {
		d.used = time.Now()
		s.bars[id] = d
	}
	s.mu.Unlock()
	if ok {
		return d, nil
	}
	ds, bars, err := data.LoadDataset(ctx, s.Store, id)
	if err != nil {
		return d, err
	}
	if len(bars) == 0 {
		return d, fmt.Errorf("dataset %s has no bars", id)
	}
	d = datasetBars{tf: ds.Spec.Timeframe, bars: bars, used: time.Now()}
	s.mu.Lock()
	defer s.mu.Unlock()
	if len(s.bars) >= maxCachedDatasets {
		var oldest string
		for k, v := range s.bars {
			if oldest == "" || v.used.Before(s.bars[oldest].used) {
				oldest = k
			}
		}
		delete(s.bars, oldest)
	}
	s.bars[id] = d
	return d, nil
}

// run executes one claimed attempt and records the outcome.
func (s *Scheduler) run(ctx context.Context, a db.Attempt) {
	actx, cancel := context.WithCancelCause(ctx)
	s.mu.Lock()
	if s.running[a.ExperimentID] == nil {
		s.running[a.ExperimentID] = map[int32]context.CancelCauseFunc{}
	}
	s.running[a.ExperimentID][a.Seq] = cancel
	s.mu.Unlock()
	defer func() {
		cancel(nil)
		s.mu.Lock()
		delete(s.running[a.ExperimentID], a.Seq)
		s.mu.Unlock()
	}()

	// Outcomes are written with their own short context: a result computed just
	// before shutdown is still recorded.
	write := func(f func(context.Context) error) {
		wctx, done := context.WithTimeout(context.Background(), 10*time.Second)
		defer done()
		if err := f(wctx); err != nil {
			slog.Error("record attempt", "experiment", a.ExperimentID, "seq", a.Seq, "err", err)
		}
	}
	end := func(status, why string) {
		write(func(c context.Context) error {
			return s.Store.EndAttempt(c, db.EndAttemptParams{ExperimentID: a.ExperimentID, Seq: a.Seq, Status: status, Failure: why})
		})
	}

	ms, cacheState, key, err := s.evaluate(actx, a)
	switch {
	case errors.Is(context.Cause(actx), errCancelled):
		end("cancelled", "لغو به درخواست کاربر")
		return
	case ctx.Err() != nil:
		return // shutdown: stays running, re-queued on the next start
	case err != nil:
		end("failed", failure(err))
		return
	}
	def, err := s.definition(ctx, a.ExperimentID)
	if err != nil {
		end("failed", failure(err))
		return
	}
	ok, violations := Check(def.Constraints, ms)
	msJ, _ := json.Marshal(ms)
	vJ, _ := json.Marshal(violations)
	write(func(c context.Context) error {
		return s.Store.CompleteAttempt(c, db.CompleteAttemptParams{
			ExperimentID: a.ExperimentID, Seq: a.Seq, Metrics: msJ, Eligible: &ok, Violations: vJ, Cache: cacheState, CacheKey: key,
		})
	})
}

// evaluate returns the attempt's OOS metrics, from the run cache when every input matches.
func (s *Scheduler) evaluate(ctx context.Context, a db.Attempt) ([]metrics.Metric, string, string, error) {
	def, err := s.definition(ctx, a.ExperimentID)
	if err != nil {
		return nil, "", "", err
	}
	_, vdef, err := experiment.Version(ctx, s.Store.Queries, def.AlgorithmVersion)
	if err != nil {
		return nil, "", "", err
	}
	var params strategy.Params
	if err := json.Unmarshal(a.Params, &params); err != nil {
		return nil, "", "", err
	}
	d, err := s.dataset(ctx, a.DatasetID)
	if err != nil {
		return nil, "", "", err
	}
	spec := eval.Spec{DatasetIDs: []string{a.DatasetID}, Timeframe: d.tf, Strategy: vdef.Strategy, Params: params, Sim: def.Sim, Split: def.Split}
	key, err := CacheKey(s.Build, spec)
	if err != nil {
		return nil, "", "", err
	}
	if b, err := s.Store.GetRunCache(ctx, key); err == nil {
		var ms []metrics.Metric
		if json.Unmarshal(b, &ms) == nil {
			return ms, "hit", key, nil
		}
	}
	ms, err := eval.EvaluateOOS(ctx, spec, map[string][]data.Bar{d.bars[0].Instrument: d.bars}, report.Specs())
	if err != nil {
		return nil, "", key, err
	}
	if b, err := json.Marshal(ms); err == nil {
		_ = s.Store.PutRunCache(ctx, db.PutRunCacheParams{Key: key, Metrics: b})
	}
	return ms, "miss", key, nil
}

func failure(err error) string {
	switch {
	case errors.Is(err, strategy.ErrUnknown), errors.Is(err, eval.ErrSpec):
		return "پیکربندی نامعتبر: " + err.Error()
	case errors.Is(err, eval.ErrPlan):
		return "تقسیم داده ممکن نیست: " + err.Error()
	}
	return err.Error()
}

// housekeep enforces time budgets and finalizes experiments with nothing left to run.
func (s *Scheduler) housekeep(ctx context.Context) {
	exps, err := s.Store.ListStartedExperiments(ctx)
	if err != nil {
		return
	}
	for _, e := range exps {
		var def experiment.Definition
		if json.Unmarshal(e.Definition, &def) != nil || def.Search.MaxWallSeconds <= 0 {
			continue
		}
		if time.Since(e.CreatedAt) > time.Duration(def.Search.MaxWallSeconds)*time.Second {
			if n, _ := s.Store.CancelQueued(ctx, db.CancelQueuedParams{ExperimentID: e.ID, Failure: "بودجه زمان تمام شد"}); n > 0 {
				slog.Info("time budget reached", "experiment", e.ID, "cancelled_attempts", n)
			}
		}
	}
	if _, err := s.Store.BeginFinalize(ctx); err != nil {
		return
	}
	ids, err := s.Store.ListFinalizing(ctx)
	if err != nil {
		return
	}
	for _, id := range ids {
		s.finalize(ctx, id)
	}
}

// finalize selects the winner and writes its full reports. Idempotent: report ids
// are derived from the experiment and dataset, so a re-run after a crash does not
// duplicate them.
func (s *Scheduler) finalize(ctx context.Context, id string) {
	def, err := s.definition(ctx, id)
	if err != nil {
		return
	}
	rows, err := s.Store.AllAttempts(ctx, id)
	if err != nil {
		return
	}
	var results []AttemptResult
	for _, r := range rows {
		ar := AttemptResult{Candidate: int(r.Candidate), DatasetID: r.DatasetID, Status: r.Status, Eligible: r.Eligible != nil && *r.Eligible}
		_ = json.Unmarshal(r.Params, &ar.Params)
		if r.Metrics != nil {
			_ = json.Unmarshal(r.Metrics, &ar.Metrics)
		}
		results = append(results, ar)
	}
	res := Select(def, results)
	status, errText := "done", ""
	if res.Chosen > 0 {
		if err := s.Limiter.AcquireAll(ctx); err != nil {
			return // shutdown: finalizing again on the next start
		}
		_, vdef, verr := experiment.Version(ctx, s.Store.Queries, def.AlgorithmVersion)
		err = verr
		for _, ds := range def.DatasetIDs {
			if err != nil {
				break
			}
			rid := winnerReportID(id, ds)
			err = s.Reports.CreateWithID(ctx, rid, eval.Spec{
				DatasetIDs: []string{ds}, Strategy: vdef.Strategy, Params: res.Params, Sim: def.Sim, Split: def.Split,
				Origin: &eval.Origin{ExperimentID: id, Attempts: res.Attempts, Candidates: res.Candidates},
			})
			if err == nil {
				res.ReportIDs = append(res.ReportIDs, rid)
			}
		}
		s.Limiter.ReleaseN(s.Limiter.Size())
		if ctx.Err() != nil {
			return
		}
		if err != nil {
			status, errText = "failed", "ساخت گزارش نامزد برگزیده: "+err.Error()
		}
	}
	resJ, _ := json.Marshal(res)
	if err := s.Store.FinishExperiment(ctx, db.FinishExperimentParams{ID: id, Status: status, Result: resJ, Error: errText}); err != nil {
		slog.Error("finish experiment", "experiment", id, "err", err)
		return
	}
	slog.Info("experiment finished", "experiment", id, "chosen", res.Chosen, "eligible", res.EligibleCandidates, "attempts", res.Attempts)
}

func winnerReportID(exp, dataset string) string {
	h := sha256.Sum256([]byte(exp + "/" + dataset))
	return "rp_" + hex.EncodeToString(h[:8])
}
