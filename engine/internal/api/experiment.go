package api

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/experiment"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/search"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

type Experiment struct {
	Store     *store.Store
	Scheduler *search.Scheduler
	Limiter   *jobs.Limiter
	Every     time.Duration // progress interval (default 1 s)
}

// nsPerBar: rough simulator speed for estimates (1M bars ≈ 0.65 s, see PROGRESS.md).
const nsPerBar = 700

func expErr(err error) error {
	switch {
	case err == nil:
		return nil
	case errors.Is(err, experiment.ErrNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, experiment.ErrState):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, experiment.ErrInvalid):
		return connect.NewError(connect.CodeInvalidArgument, err)
	}
	return err
}

// defIn converts and normalizes: defaults are filled in before hashing, so the
// same experiment always gets the same content id.
func defIn(p *labv1.ExperimentDefinition) (experiment.Definition, error) {
	if p == nil {
		return experiment.Definition{}, errors.New("definition is required")
	}
	capital, ok, err := usdtIn(p.GetCapital(), "capital")
	if err != nil {
		return experiment.Definition{}, err
	}
	if !ok {
		return experiment.Definition{}, errors.New("capital is required")
	}
	fee, _, err := ratioIn(p.GetFee(), "fee")
	if err != nil {
		return experiment.Definition{}, err
	}
	slip, _, err := ratioIn(p.GetSlippage(), "slippage")
	if err != nil {
		return experiment.Definition{}, err
	}
	holdout, _, err := ratioIn(p.GetHoldout(), "holdout")
	if err != nil {
		return experiment.Definition{}, err
	}
	cfg, err := sim.Config{Capital: capital, FeeRate: fee, SlipRate: slip, LatencyBars: int(p.GetLatencyBars())}.Normalized()
	if err != nil {
		return experiment.Definition{}, err
	}
	def := experiment.Definition{
		Name: p.GetName(), Hypothesis: p.GetHypothesis(), Falsifier: p.GetFalsifier(),
		Objective:        experiment.Objective{Metric: p.GetObjective().GetMetric(), Maximize: p.GetObjective().GetMaximize()},
		DatasetIDs:       p.GetDatasetIds(),
		AlgorithmVersion: p.GetAlgorithmVersion(),
		Space:            map[string]experiment.ParamRange{},
		Search: experiment.SearchPlan{
			Mode: p.GetSearch().GetMode(), Seed: p.GetSearch().GetSeed(),
			MaxAttempts: int(p.GetSearch().GetMaxAttempts()), MaxWallSeconds: int(p.GetSearch().GetMaxWallSeconds()),
		},
		Sim:   cfg,
		Split: eval.SplitPlan{Folds: int(p.GetFolds()), Rolling: p.GetRolling(), Holdout: holdout}.WithDefaults(),
	}
	if def.Search.Mode == "" {
		def.Search.Mode = "grid"
	}
	for _, c := range p.GetConstraints() {
		def.Constraints = append(def.Constraints, experiment.Constraint{Metric: c.GetMetric(), Op: c.GetOp(), Value: c.GetValue()})
	}
	for k, r := range p.GetSpace() {
		def.Space[k] = experiment.ParamRange{Values: r.GetValues(), Min: r.GetMin(), Max: r.GetMax(), Step: r.GetStep()}
	}
	return def, nil
}

func defP(d experiment.Definition) *labv1.ExperimentDefinition {
	p := &labv1.ExperimentDefinition{
		Name: d.Name, Hypothesis: d.Hypothesis, Falsifier: d.Falsifier,
		Objective:        &labv1.Objective{Metric: d.Objective.Metric, Maximize: d.Objective.Maximize},
		DatasetIds:       d.DatasetIDs,
		AlgorithmVersion: d.AlgorithmVersion,
		Space:            map[string]*labv1.ParamRange{},
		Search:           &labv1.SearchPlan{Mode: d.Search.Mode, Seed: d.Search.Seed, MaxAttempts: int32(d.Search.MaxAttempts), MaxWallSeconds: int32(d.Search.MaxWallSeconds)},
		Capital:          moneyP(d.Sim.Capital), Fee: ratioP(d.Sim.FeeRate), Slippage: ratioP(d.Sim.SlipRate),
		LatencyBars: int32(d.Sim.LatencyBars), Folds: int32(d.Split.Folds), Rolling: d.Split.Rolling, Holdout: ratioP(d.Split.Holdout),
	}
	for _, c := range d.Constraints {
		p.Constraints = append(p.Constraints, &labv1.Constraint{Metric: c.Metric, Op: c.Op, Value: c.Value})
	}
	for k, r := range d.Space {
		p.Space[k] = &labv1.ParamRange{Values: r.Values, Min: r.Min, Max: r.Max, Step: r.Step}
	}
	return p
}

func (h *Experiment) Estimate(ctx context.Context, req *connect.Request[labv1.EstimateRequest]) (*connect.Response[labv1.EstimateResponse], error) {
	def, err := defIn(req.Msg.GetDefinition())
	if err != nil {
		return connect.NewResponse(&labv1.EstimateResponse{Error: err.Error()}), nil
	}
	atts, err := search.Plan(ctx, h.Store, def)
	if errors.Is(err, experiment.ErrInvalid) || errors.Is(err, experiment.ErrNotFound) {
		return connect.NewResponse(&labv1.EstimateResponse{Error: err.Error()}), nil
	}
	if err != nil {
		return nil, err
	}
	var bars int64
	for _, id := range def.DatasetIDs {
		row, err := h.Store.GetDataset(ctx, id)
		if err == nil {
			bars = max(bars, int64(row.BarCount))
		}
	}
	slots := int64(h.Limiter.Size())
	secs := max(1, bars*int64(len(atts))*nsPerBar/int64(time.Second)/slots)
	cands := 0
	for _, a := range atts {
		cands = max(cands, a.Candidate)
	}
	return connect.NewResponse(&labv1.EstimateResponse{Candidates: int32(cands), Attempts: int32(len(atts)), EstimatedSeconds: secs}), nil
}

func (h *Experiment) CreateExperiment(ctx context.Context, req *connect.Request[labv1.CreateExperimentRequest]) (*connect.Response[labv1.CreateExperimentResponse], error) {
	def, err := defIn(req.Msg.GetDefinition())
	if err != nil {
		return nil, invalid(err.Error())
	}
	atts, err := search.Plan(ctx, h.Store, def)
	if err != nil {
		return nil, expErr(err)
	}
	id, err := experiment.Create(ctx, h.Store, def, atts)
	if errors.Is(err, experiment.ErrExists) {
		return connect.NewResponse(&labv1.CreateExperimentResponse{ExperimentId: id, AlreadyExisted: true}), nil
	}
	if err != nil {
		return nil, err
	}
	h.Scheduler.Wake()
	return connect.NewResponse(&labv1.CreateExperimentResponse{ExperimentId: id}), nil
}

func (h *Experiment) counts(ctx context.Context, id string) (*labv1.AttemptCounts, error) {
	rows, err := h.Store.AttemptCounts(ctx, id)
	if err != nil {
		return nil, err
	}
	c := &labv1.AttemptCounts{}
	for _, r := range rows {
		switch r.Status {
		case "queued":
			c.Queued = r.N
		case "running":
			c.Running = r.N
		case "done":
			c.Done = r.N
		case "failed":
			c.Failed = r.N
		case "cancelled":
			c.Cancelled = r.N
		}
		c.Total += r.N
	}
	return c, nil
}

func (h *Experiment) summary(ctx context.Context, row db.Experiment) (*labv1.ExperimentSummary, error) {
	var def experiment.Definition
	if err := json.Unmarshal(row.Definition, &def); err != nil {
		return nil, err
	}
	c, err := h.counts(ctx, row.ID)
	if err != nil {
		return nil, err
	}
	s := &labv1.ExperimentSummary{Id: row.ID, Name: row.Name, Status: row.Status, CreatedUnixMs: ms(row.CreatedAt), AlgorithmVersion: def.AlgorithmVersion, Counts: c}
	if row.FinishedAt != nil {
		s.FinishedUnixMs = ms(*row.FinishedAt)
	}
	return s, nil
}

func (h *Experiment) ListExperiments(ctx context.Context, req *connect.Request[labv1.ListExperimentsRequest]) (*connect.Response[labv1.ListExperimentsResponse], error) {
	rows, err := h.Store.ListExperiments(ctx, db.ListExperimentsParams{Limit: pageSize(req.Msg.GetPageSize()), Offset: max(0, req.Msg.GetOffset())})
	if err != nil {
		return nil, err
	}
	total, err := h.Store.CountExperiments(ctx)
	if err != nil {
		return nil, err
	}
	res := &labv1.ListExperimentsResponse{Total: total}
	for _, r := range rows {
		s, err := h.summary(ctx, r)
		if err != nil {
			return nil, err
		}
		res.Experiments = append(res.Experiments, s)
	}
	return connect.NewResponse(res), nil
}

func (h *Experiment) GetExperiment(ctx context.Context, req *connect.Request[labv1.GetExperimentRequest]) (*connect.Response[labv1.GetExperimentResponse], error) {
	e, err := experiment.Load(ctx, h.Store.Queries, req.Msg.GetExperimentId())
	if err != nil {
		return nil, expErr(err)
	}
	s, err := h.summary(ctx, e.Row)
	if err != nil {
		return nil, err
	}
	res := &labv1.GetExperimentResponse{Summary: s, Definition: defP(e.Def), Error: e.Row.Error}
	if e.Row.Result != nil {
		var r search.Result
		if err := json.Unmarshal(e.Row.Result, &r); err != nil {
			return nil, err
		}
		pr := &labv1.ExperimentResult{
			Chosen: int32(r.Chosen), Params: r.Params, Candidates: int32(r.Candidates), EligibleCandidates: int32(r.EligibleCandidates),
			Attempts: int32(r.Attempts), ReportIds: r.ReportIDs, Reason: r.Reason,
		}
		if r.Objective != nil {
			pr.Objective = metricP(*r.Objective)
		}
		res.Result = pr
	}
	return connect.NewResponse(res), nil
}

var terminal = map[string]bool{"done": true, "cancelled": true, "failed": true}

func (h *Experiment) WatchExperiment(ctx context.Context, req *connect.Request[labv1.WatchExperimentRequest], s *connect.ServerStream[labv1.WatchExperimentResponse]) error {
	id := req.Msg.GetExperimentId()
	every := h.Every
	if every == 0 {
		every = time.Second
	}
	t := time.NewTicker(every)
	defer t.Stop()
	for {
		p, err := h.progress(ctx, id)
		if err != nil {
			return expErr(err)
		}
		if err := s.Send(p); err != nil {
			return err
		}
		if terminal[p.GetStatus()] {
			return nil
		}
		select {
		case <-ctx.Done():
			return nil
		case <-t.C:
		}
	}
}

func (h *Experiment) progress(ctx context.Context, id string) (*labv1.WatchExperimentResponse, error) {
	e, err := experiment.Load(ctx, h.Store.Queries, id)
	if err != nil {
		return nil, err
	}
	c, err := h.counts(ctx, id)
	if err != nil {
		return nil, err
	}
	hits, err := h.Store.CacheHits(ctx, id)
	if err != nil {
		return nil, err
	}
	end := time.Now()
	if e.Row.FinishedAt != nil {
		end = *e.Row.FinishedAt
	}
	p := &labv1.WatchExperimentResponse{
		Status: e.Row.Status, Counts: c, ElapsedSeconds: int64(end.Sub(e.Row.CreatedAt) / time.Second),
		WallBudgetSeconds: int64(e.Def.Search.MaxWallSeconds), AttemptBudget: int32(e.Def.Search.MaxAttempts),
		CacheHits: hits.Hits, CacheLooked: hits.Looked,
		ResearchSlotsInUse: int32(h.Limiter.InUse()), ResearchSlots: int32(h.Limiter.Size()),
	}
	// Best eligible attempt so far (a single pair; the final choice averages pairs).
	rows, err := h.Store.AllAttempts(ctx, id)
	if err != nil {
		return nil, err
	}
	var best *metrics.Metric
	for _, r := range rows {
		if r.Status != "done" || r.Eligible == nil || !*r.Eligible || r.Metrics == nil {
			continue
		}
		var ms []metrics.Metric
		if json.Unmarshal(r.Metrics, &ms) != nil {
			continue
		}
		m, ok := metrics.Get(ms, e.Def.Objective.Metric)
		if !ok || !m.Valid {
			continue
		}
		if best == nil || (e.Def.Objective.Maximize && m.V > best.V) || (!e.Def.Objective.Maximize && m.V < best.V) {
			best = &m
		}
	}
	if best != nil {
		p.BestObjective = metricP(*best)
	}
	return p, nil
}

func (h *Experiment) ListAttempts(ctx context.Context, req *connect.Request[labv1.ListAttemptsRequest]) (*connect.Response[labv1.ListAttemptsResponse], error) {
	m := req.Msg
	p := db.ListAttemptsParams{ExperimentID: m.GetExperimentId(), Lim: pageSize(m.GetPageSize()), Off: max(0, m.GetOffset())}
	cp := db.CountAttemptsParams{ExperimentID: m.GetExperimentId()}
	if st := m.GetStatus(); st != "" {
		p.Status.String, p.Status.Valid = st, true
		cp.Status = p.Status
	}
	rows, err := h.Store.ListAttempts(ctx, p)
	if err != nil {
		return nil, err
	}
	total, err := h.Store.CountAttempts(ctx, cp)
	if err != nil {
		return nil, err
	}
	res := &labv1.ListAttemptsResponse{Total: total}
	for _, r := range rows {
		row := &labv1.AttemptRow{Seq: r.Seq, Candidate: r.Candidate, Symbol: r.Symbol, Status: r.Status, Failure: r.Failure, Cache: r.Cache, Runs: r.Runs}
		var params strategy.Params
		_ = json.Unmarshal(r.Params, &params)
		row.Params = params
		if r.Metrics != nil {
			var ms []metrics.Metric
			if json.Unmarshal(r.Metrics, &ms) == nil {
				for key, dst := range map[string]**labv1.Metric{"total_return": &row.TotalReturn, "max_drawdown": &row.MaxDrawdown, "trades": &row.Trades} {
					if x, ok := metrics.Get(ms, key); ok {
						*dst = metricP(x)
					}
				}
			}
		}
		if r.Eligible != nil {
			row.HasEligibility, row.Eligible = true, *r.Eligible
			_ = json.Unmarshal(r.Violations, &row.Violations)
		}
		res.Attempts = append(res.Attempts, row)
	}
	return connect.NewResponse(res), nil
}

func (h *Experiment) PauseExperiment(ctx context.Context, req *connect.Request[labv1.PauseExperimentRequest]) (*connect.Response[labv1.PauseExperimentResponse], error) {
	if err := experiment.Pause(ctx, h.Store.Queries, req.Msg.GetExperimentId()); err != nil {
		return nil, expErr(err)
	}
	return connect.NewResponse(&labv1.PauseExperimentResponse{}), nil
}

func (h *Experiment) ResumeExperiment(ctx context.Context, req *connect.Request[labv1.ResumeExperimentRequest]) (*connect.Response[labv1.ResumeExperimentResponse], error) {
	if err := experiment.Resume(ctx, h.Store.Queries, req.Msg.GetExperimentId()); err != nil {
		return nil, expErr(err)
	}
	h.Scheduler.Wake()
	return connect.NewResponse(&labv1.ResumeExperimentResponse{}), nil
}

func (h *Experiment) CancelExperiment(ctx context.Context, req *connect.Request[labv1.CancelExperimentRequest]) (*connect.Response[labv1.CancelExperimentResponse], error) {
	id := req.Msg.GetExperimentId()
	if err := experiment.Cancel(ctx, h.Store, id); err != nil {
		return nil, expErr(err)
	}
	h.Scheduler.Cancel(id)
	return connect.NewResponse(&labv1.CancelExperimentResponse{}), nil
}
