// Package search turns an experiment definition into candidates, runs them as
// attempts on the research queue, and chooses a winner under pre-declared rules.
package search

import (
	"context"
	"fmt"
	"math"
	"math/rand/v2"
	"slices"
	"strings"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/strategy"
)

// MaxCandidates bounds one search, whatever the budget says.
const MaxCandidates = 5000

func invalid(f string, a ...any) error {
	return fmt.Errorf("%w: "+f, append([]any{experiment.ErrInvalid}, a...)...)
}

// Plan validates def and returns its attempts: every candidate on every pair, in a
// fixed order (candidate-major), deterministic for a given seed.
func Plan(ctx context.Context, s *store.Store, def experiment.Definition) ([]experiment.NewAttempt, error) {
	if err := validateText(def); err != nil {
		return nil, err
	}
	ver, vdef, err := experiment.Version(ctx, s.Queries, def.AlgorithmVersion)
	if err != nil {
		return nil, err
	}
	if ver.State == experiment.Retired {
		return nil, invalid("algorithm version %s is retired", def.AlgorithmVersion)
	}
	if _, err := def.Sim.Normalized(); err != nil {
		return nil, invalid("%v", err)
	}
	if def.Search.MaxAttempts < 1 || def.Search.MaxAttempts > MaxCandidates {
		return nil, invalid("attempt budget must be 1..%d", MaxCandidates)
	}
	if def.Search.MaxWallSeconds < 60 {
		return nil, invalid("time budget must be at least 60 seconds")
	}

	// Pairs: datasets with one symbol each and a common timeframe.
	type pair struct{ id, symbol string }
	var pairs []pair
	var tf data.Timeframe
	for _, id := range def.DatasetIDs {
		row, err := s.GetDataset(ctx, id)
		if err != nil {
			return nil, invalid("dataset %s not found", id)
		}
		if tf != "" && data.Timeframe(row.Timeframe) != tf {
			return nil, invalid("datasets must share one timeframe")
		}
		tf = data.Timeframe(row.Timeframe)
		if slices.ContainsFunc(pairs, func(p pair) bool { return p.symbol == row.Symbol }) {
			return nil, invalid("two datasets for %s", row.Symbol)
		}
		pairs = append(pairs, pair{id, row.Symbol})
	}
	if len(pairs) == 0 {
		return nil, invalid("choose at least one dataset")
	}

	cands, err := candidates(vdef, def)
	if err != nil {
		return nil, err
	}
	if n := len(cands) * len(pairs); n > def.Search.MaxAttempts {
		return nil, invalid("%d candidates × %d pairs = %d attempts, over the budget of %d", len(cands), len(pairs), n, def.Search.MaxAttempts)
	}
	var out []experiment.NewAttempt
	for ci, p := range cands {
		for _, pr := range pairs {
			out = append(out, experiment.NewAttempt{Candidate: ci + 1, Params: p, DatasetID: pr.id, Symbol: pr.symbol})
		}
	}
	return out, nil
}

func validateText(def experiment.Definition) error {
	switch {
	case strings.TrimSpace(def.Name) == "":
		return invalid("name is required")
	case strings.TrimSpace(def.Hypothesis) == "":
		return invalid("hypothesis is required (write it before seeing results)")
	case strings.TrimSpace(def.Falsifier) == "":
		return invalid("the falsifying result is required (write it before seeing results)")
	}
	if _, _, ok := metrics.UnitOf(def.Objective.Metric); !ok {
		return invalid("unknown objective metric %q", def.Objective.Metric)
	}
	for _, c := range def.Constraints {
		_, scale, ok := metrics.UnitOf(c.Metric)
		if !ok {
			return invalid("unknown constraint metric %q", c.Metric)
		}
		if c.Op != ">=" && c.Op != "<=" {
			return invalid("constraint operator must be >= or <=")
		}
		if _, err := money.Parse(c.Value, scale); err != nil {
			return invalid("constraint %s value %q: at most %d decimals", c.Metric, c.Value, scale)
		}
	}
	return nil
}

// candidates expands the parameter space. Grid: every combination, parameters in
// declared order. Random: seeded draws without repeats. Parameters not in the
// space keep the version defaults.
func candidates(vdef experiment.VersionDefinition, def experiment.Definition) ([]strategy.Params, error) {
	specs := map[string]strategy.ParamSpec{}
	for _, p := range vdef.Params {
		specs[p.Name] = p
	}
	var names []string
	axes := map[string][]float64{}
	for _, p := range vdef.Params { // declared order, not map order
		r, ok := def.Space[p.Name]
		if !ok {
			continue
		}
		vals, err := values(p, r)
		if err != nil {
			return nil, err
		}
		names = append(names, p.Name)
		axes[p.Name] = vals
	}
	for name := range def.Space {
		if _, ok := specs[name]; !ok {
			return nil, invalid("%s has no parameter %q", vdef.Strategy, name)
		}
	}
	base := strategy.WithDefaults(vdef.Strategy, nil)
	with := func(choice map[string]float64) strategy.Params {
		p := strategy.Params{}
		for k, v := range base {
			p[k] = v
		}
		for k, v := range choice {
			p[k] = v
		}
		return p
	}

	total := 1
	for _, n := range names {
		total *= len(axes[n])
		if total > MaxCandidates*10 {
			break
		}
	}
	switch def.Search.Mode {
	case "grid", "":
		if total > MaxCandidates {
			return nil, invalid("the grid has more than %d combinations", MaxCandidates)
		}
		out := []strategy.Params{with(nil)}
		for _, n := range names {
			var next []strategy.Params
			for _, p := range out {
				for _, v := range axes[n] {
					q := with(nil)
					for k, x := range p {
						q[k] = x
					}
					q[n] = v
					next = append(next, q)
				}
			}
			out = next
		}
		return out, nil
	case "random":
		pairs := max(1, len(def.DatasetIDs))
		want := min(def.Search.MaxAttempts/pairs, total)
		rng := rand.New(rand.NewPCG(def.Search.Seed, def.Search.Seed^0x9e3779b97f4a7c15))
		seen := map[string]bool{}
		var out []strategy.Params
		for tries := 0; len(out) < want && tries < want*50; tries++ {
			choice := map[string]float64{}
			key := ""
			for _, n := range names {
				v := axes[n][rng.IntN(len(axes[n]))]
				choice[n] = v
				key += fmt.Sprintf("%s=%v;", n, v)
			}
			if !seen[key] {
				seen[key] = true
				out = append(out, with(choice))
			}
		}
		return out, nil
	}
	return nil, invalid("search mode must be grid or random")
}

func values(p strategy.ParamSpec, r experiment.ParamRange) ([]float64, error) {
	var vals []float64
	if len(r.Values) > 0 {
		vals = slices.Clone(r.Values)
	} else {
		if r.Step <= 0 || r.Max < r.Min {
			return nil, invalid("%s: give values, or min ≤ max with a positive step", p.Name)
		}
		n := int(math.Floor((r.Max-r.Min)/r.Step+1e-9)) + 1
		if n > MaxCandidates {
			return nil, invalid("%s: too many values", p.Name)
		}
		for i := range n {
			vals = append(vals, r.Min+float64(i)*r.Step)
		}
	}
	for i, v := range vals {
		if p.Integer {
			if v != math.Round(v) {
				return nil, invalid("%s takes whole numbers", p.Name)
			}
		} else {
			vals[i] = math.Round(v*1e6) / 1e6 // 0.1+0.2 noise must not create new candidates
		}
	}
	slices.Sort(vals)
	return slices.Compact(vals), nil
}
