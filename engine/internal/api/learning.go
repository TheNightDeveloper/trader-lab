package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"slices"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/experiment"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/loop"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

type Learning struct {
	Store *store.Store
	Loop  *loop.Loop
}

func learnErr(err error) error {
	switch {
	case errors.Is(err, loop.ErrConfig):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, loop.ErrNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, loop.ErrBusy), errors.Is(err, loop.ErrState):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	}
	return err
}

func configP(c loop.Config) *labv1.LearningConfig {
	g := c.Gate
	return &labv1.LearningConfig{
		AlgorithmId: c.Algorithm, Symbols: c.Symbols, Timeframe: string(c.Timeframe), LookbackDays: int32(c.LookbackDays),
		Enabled: c.Enabled, HourUtc: int32(c.HourUTC), MinFreshBars: int32(c.MinFreshBars), Folds: int32(c.Folds),
		MaxCandidates: int32(c.MaxCandidates), CpuMinutes: int32(c.CPUMinutes), MaxBars: int64(c.MaxBars), Seed: c.Seed,
		Capital: moneyP(c.Capital), Fee: ratioP(c.Fee), Slippage: ratioP(c.Slippage),
		Gate: &labv1.LearningGate{
			MaxDrawdown: ratioP(g.MaxDrawdown), MinForwardTrades: int32(g.MinForwardTrades), ForwardDays: int32(g.ForwardDays),
			MinImprovement: ratioP(g.MinImprovement), MaxDdDegradation: ratioP(g.MaxDDDegradation), MinWalkWins: int32(g.MinWalkWins),
		},
	}
}

func configIn(p *labv1.LearningConfig) (loop.Config, error) {
	if p == nil || p.GetGate() == nil {
		return loop.Config{}, fmt.Errorf("%w: config and gate are required", loop.ErrConfig)
	}
	c := loop.Config{
		Algorithm: p.GetAlgorithmId(), Symbols: p.GetSymbols(), Timeframe: data.Timeframe(p.GetTimeframe()), LookbackDays: int(p.GetLookbackDays()),
		Enabled: p.GetEnabled(), HourUTC: int(p.GetHourUtc()), MinFreshBars: int(p.GetMinFreshBars()), Folds: int(p.GetFolds()),
		MaxCandidates: int(p.GetMaxCandidates()), CPUMinutes: int(p.GetCpuMinutes()), MaxBars: int(p.GetMaxBars()), Seed: p.GetSeed(),
	}
	g := p.GetGate()
	c.Gate = loop.Gate{MinForwardTrades: int(g.GetMinForwardTrades()), ForwardDays: int(g.GetForwardDays()), MinWalkWins: int(g.GetMinWalkWins())}
	var err error
	if c.Capital, _, err = usdtIn(p.GetCapital(), "capital"); err != nil {
		return c, fmt.Errorf("%w: %w", loop.ErrConfig, err)
	}
	for _, r := range []struct {
		d   *labv1.Decimal
		dst *int64
		f   string
	}{
		{p.GetFee(), (*int64)(&c.Fee), "fee"}, {p.GetSlippage(), (*int64)(&c.Slippage), "slippage"},
		{g.GetMaxDrawdown(), (*int64)(&c.Gate.MaxDrawdown), "max_drawdown"}, {g.GetMinImprovement(), (*int64)(&c.Gate.MinImprovement), "min_improvement"},
		{g.GetMaxDdDegradation(), (*int64)(&c.Gate.MaxDDDegradation), "max_dd_degradation"},
	} {
		v, _, err := ratioIn(r.d, r.f)
		if err != nil {
			return c, fmt.Errorf("%w: %w", loop.ErrConfig, err)
		}
		*r.dst = int64(v)
	}
	return c, nil
}

var stepOrder = []string{loop.Collect, loop.Labels, loop.Generate, loop.Train, loop.WalkForward, loop.ForwardTest, loop.Decision}

// stepsP: steps before the current state are done; the current one runs (or
// waits, for the forward test and the user's decision). In a finished cycle,
// steps it reached are done and the rest skipped.
func stepsP(row db.LearningCycle, d loop.Doc) []*labv1.CycleStep {
	cur := slices.Index(stepOrder, row.State)
	var out []*labv1.CycleStep
	for i, k := range stepOrder {
		st := "pending"
		switch {
		case row.State == loop.Done:
			st = "skipped"
			if _, ok := d.Steps[k]; ok {
				st = "done"
			}
		case i < cur:
			st = "done"
		case i == cur && (k == loop.ForwardTest || k == loop.Decision):
			st = "waiting"
		case i == cur:
			st = "running"
		}
		out = append(out, &labv1.CycleStep{Key: k, Status: st, Meta: d.Steps[k]})
	}
	return out
}

func cycleP(row db.LearningCycle) (*labv1.Cycle, error) {
	d, err := loop.DocOf(row)
	if err != nil {
		return nil, err
	}
	c := &labv1.Cycle{
		Id: row.ID, AlgorithmId: row.AlgorithmID, Trigger: row.Trigger, State: row.State, Outcome: row.Outcome, Reason: row.Reason,
		StartedUnixMs: ms(row.StartedAt), Steps: stepsP(row, d), Candidates: int32(d.Candidates), Eligible: int32(d.Eligible),
		ForwardDaysTarget: int32(d.Config.Gate.ForwardDays),
		CanApprove:        row.State == loop.Decision && row.Outcome == loop.Recommended,
		Usage: &labv1.CycleUsage{
			CpuSeconds: d.Usage.CPUMillis / 1000, CpuBudgetSeconds: int64(d.Config.CPUMinutes) * 60,
			Candidates: int32(d.Usage.Candidates), MaxCandidates: int32(d.Config.MaxCandidates),
			Bars: int64(d.Usage.Bars), MaxBars: int64(d.Config.MaxBars),
		},
	}
	if row.FinishedAt != nil {
		c.FinishedUnixMs = ms(*row.FinishedAt)
	}
	if d.FreezeAt != nil {
		c.FreezeUnixMs = ms(*d.FreezeAt)
	}
	var fc, fp []metrics.Metric
	if d.Forward != nil {
		c.ForwardDays = int32(d.Forward.Days)
		fc, fp = d.Forward.Challenger, d.Forward.Champion
	}
	if d.Walk != nil {
		c.WalkWins, c.WalkFolds = int32(d.Walk.Wins), int32(len(d.Walk.Folds))
	}
	for _, g := range d.Gate {
		c.Gate = append(c.Gate, &labv1.GateItem{Key: g.Key, Status: g.Status, Text: g.Text})
	}
	ch := d.Champion
	c.Champion = &labv1.Contender{VersionId: ch.VersionID, ModelId: ch.ModelID, Active: ch.Active, Walk: metricsP(ch.Walk), Forward: metricsP(fp)}
	if x := d.Challenger; x != nil {
		c.Challenger = &labv1.Contender{ModelId: x.ModelID, Change: x.Change, Seq: int32(x.Seq), Walk: metricsP(x.Walk), Forward: metricsP(fc)}
	}
	return c, nil
}

func (h *Learning) GetLearning(ctx context.Context, _ *connect.Request[labv1.GetLearningRequest]) (*connect.Response[labv1.GetLearningResponse], error) {
	cfg, err := loop.LoadConfig(ctx, h.Store.Queries)
	if err != nil {
		return nil, err
	}
	res := &labv1.GetLearningResponse{Config: configP(cfg), Active: &labv1.ActiveModel{AlgorithmId: cfg.Algorithm}}
	algs, err := h.Store.ListAlgorithms(ctx)
	if err != nil {
		return nil, err
	}
	for _, a := range algs {
		if a.Family == "learning" {
			res.LearningAlgorithms = append(res.LearningAlgorithms, a.ID)
		}
	}
	rows, err := h.Store.ListCycles(ctx, db.ListCyclesParams{AlgorithmID: cfg.Algorithm, Limit: 1})
	if err != nil {
		return nil, err
	}
	if len(rows) > 0 {
		if res.Current, err = cycleP(rows[0]); err != nil {
			return nil, err
		}
	}
	act, err := h.Loop.Active(ctx, cfg.Algorithm)
	if err != nil && !errors.Is(err, loop.ErrNotFound) {
		return nil, err
	}
	res.Active.VersionId = act.VersionID
	if act.Model != nil {
		res.Active.ModelId, res.Active.ModelAsOfUnixMs = act.Model.ID, ms(act.Model.AsOf)
	}
	if res.CanRollback, err = h.Loop.CanRollback(ctx, cfg.Algorithm); err != nil && !errors.Is(err, loop.ErrNotFound) {
		return nil, err
	}
	return connect.NewResponse(res), nil
}

func (h *Learning) SaveConfig(ctx context.Context, req *connect.Request[labv1.SaveConfigRequest]) (*connect.Response[labv1.SaveConfigResponse], error) {
	c, err := configIn(req.Msg.GetConfig())
	if err != nil {
		return nil, learnErr(err)
	}
	if _, def, err := latestDef(ctx, h.Store.Queries, c.Algorithm); err != nil || def.Recipe == nil {
		return nil, learnErr(fmt.Errorf("%w: %s is not a learning algorithm", loop.ErrConfig, c.Algorithm))
	}
	if err := loop.SaveConfig(ctx, h.Store.Queries, c); err != nil {
		return nil, learnErr(err)
	}
	return connect.NewResponse(&labv1.SaveConfigResponse{}), nil
}

func latestDef(ctx context.Context, q *db.Queries, alg string) (db.AlgorithmVersion, experiment.VersionDefinition, error) {
	v, err := q.LatestAlgorithmVersion(ctx, alg)
	if err != nil {
		return v, experiment.VersionDefinition{}, err
	}
	return experiment.Version(ctx, q, v.ID)
}

func (h *Learning) StartCycle(ctx context.Context, _ *connect.Request[labv1.StartCycleRequest]) (*connect.Response[labv1.StartCycleResponse], error) {
	id, err := h.Loop.Start(ctx, "manual")
	if err != nil {
		return nil, learnErr(err)
	}
	return connect.NewResponse(&labv1.StartCycleResponse{CycleId: id}), nil
}

func (h *Learning) ListCycles(ctx context.Context, req *connect.Request[labv1.ListCyclesRequest]) (*connect.Response[labv1.ListCyclesResponse], error) {
	cfg, err := loop.LoadConfig(ctx, h.Store.Queries)
	if err != nil {
		return nil, err
	}
	size := req.Msg.GetPageSize()
	if size <= 0 || size > 100 {
		size = 20
	}
	rows, err := h.Store.ListCycles(ctx, db.ListCyclesParams{AlgorithmID: cfg.Algorithm, Limit: size, Offset: max(0, req.Msg.GetOffset())})
	if err != nil {
		return nil, err
	}
	total, err := h.Store.CountCycles(ctx, cfg.Algorithm)
	if err != nil {
		return nil, err
	}
	res := &labv1.ListCyclesResponse{Total: total}
	for _, r := range rows {
		c, err := cycleP(r)
		if err != nil {
			return nil, err
		}
		res.Cycles = append(res.Cycles, c)
	}
	return connect.NewResponse(res), nil
}

func (h *Learning) ListCandidates(ctx context.Context, req *connect.Request[labv1.ListCandidatesRequest]) (*connect.Response[labv1.ListCandidatesResponse], error) {
	rows, err := h.Store.ListCandidates(ctx, req.Msg.GetCycleId())
	if err != nil {
		return nil, err
	}
	res := &labv1.ListCandidatesResponse{}
	for _, r := range rows {
		pc := &labv1.CycleCandidate{Seq: r.Seq, Change: r.Change, Status: r.Status, Failure: r.Failure}
		var cr loop.CandidateResult
		if len(r.Result) > 0 {
			if err := json.Unmarshal(r.Result, &cr); err != nil {
				return nil, err
			}
		}
		if m, ok := metrics.Get(cr.Metrics, "total_return"); ok {
			pc.TotalReturn = metricP(m)
		}
		if m, ok := metrics.Get(cr.Metrics, "max_drawdown"); ok {
			pc.MaxDrawdown = metricP(m)
		}
		pc.Wins, pc.Eligible, pc.Why = int32(cr.Wins), cr.Eligible, cr.Why
		res.Candidates = append(res.Candidates, pc)
	}
	return connect.NewResponse(res), nil
}

// ListModels is the registry of frozen models of the configured algorithm.
func (h *Learning) ListModels(ctx context.Context, _ *connect.Request[labv1.ListModelsRequest]) (*connect.Response[labv1.ListModelsResponse], error) {
	cfg, err := loop.LoadConfig(ctx, h.Store.Queries)
	if err != nil {
		return nil, err
	}
	rows, err := h.Store.ListArtifacts(ctx, db.ListArtifactsParams{AlgorithmID: cfg.Algorithm, Limit: 100})
	if err != nil {
		return nil, err
	}
	act, err := h.Loop.Active(ctx, cfg.Algorithm)
	if err != nil && !errors.Is(err, loop.ErrNotFound) {
		return nil, err
	}
	// Open cycle's contenders.
	roles := map[string]string{}
	open, err := h.Store.OpenCycles(ctx)
	if err != nil {
		return nil, err
	}
	for _, o := range open {
		if d, err := loop.DocOf(o); err == nil && o.AlgorithmID == cfg.Algorithm {
			if d.Challenger != nil {
				roles[d.Challenger.ModelID] = "challenger"
			}
			if !d.Champion.Active {
				roles[d.Champion.ModelID] = "baseline"
			}
		}
	}
	// Version of each recipe.
	byRecipe := map[string]string{}
	vs, err := h.Store.ListAlgorithmVersions(ctx, cfg.Algorithm)
	if err != nil {
		return nil, err
	}
	for _, v := range vs {
		var def experiment.VersionDefinition
		if json.Unmarshal(v.Definition, &def) == nil && def.Recipe != nil {
			if _, ok := byRecipe[def.Recipe.Hash()]; !ok {
				byRecipe[def.Recipe.Hash()] = v.ID
			}
		}
	}
	res := &labv1.ListModelsResponse{}
	for _, r := range rows {
		a, err := model.Load(r.Body)
		if err != nil {
			return nil, err
		}
		status := roles[a.ID]
		if act.Model != nil && act.Model.ID == a.ID {
			status = "active"
		}
		if status == "" {
			status = "archived"
		}
		mi := &labv1.ModelInfo{
			Id: a.ID, VersionId: byRecipe[a.RecipeHash], Status: status, AsOfUnixMs: ms(a.AsOf),
			TrainFromUnixMs: ms(a.TrainFrom), TrainToUnixMs: ms(a.TrainTo), Seed: a.Seed, RecipeHash: a.RecipeHash,
			Samples: int32(a.Samples), Parent: a.Parent, TrainError: a.TrainError,
		}
		if r.CycleID != nil {
			mi.CycleId = *r.CycleID
		}
		res.Models = append(res.Models, mi)
	}
	return connect.NewResponse(res), nil
}

func (h *Learning) ApproveCycle(ctx context.Context, req *connect.Request[labv1.ApproveCycleRequest]) (*connect.Response[labv1.ApproveCycleResponse], error) {
	if err := h.Loop.Approve(ctx, req.Msg.GetCycleId(), req.Msg.GetNote()); err != nil {
		return nil, learnErr(err)
	}
	return connect.NewResponse(&labv1.ApproveCycleResponse{}), nil
}

func (h *Learning) RejectCycle(ctx context.Context, req *connect.Request[labv1.RejectCycleRequest]) (*connect.Response[labv1.RejectCycleResponse], error) {
	if err := h.Loop.Reject(ctx, req.Msg.GetCycleId(), req.Msg.GetNote()); err != nil {
		return nil, learnErr(err)
	}
	return connect.NewResponse(&labv1.RejectCycleResponse{}), nil
}

func (h *Learning) Rollback(ctx context.Context, req *connect.Request[labv1.RollbackRequest]) (*connect.Response[labv1.RollbackResponse], error) {
	cfg, err := loop.LoadConfig(ctx, h.Store.Queries)
	if err != nil {
		return nil, err
	}
	if err := h.Loop.Rollback(ctx, cfg.Algorithm, req.Msg.GetNote()); err != nil {
		return nil, learnErr(err)
	}
	return connect.NewResponse(&labv1.RollbackResponse{}), nil
}
