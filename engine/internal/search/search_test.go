package search

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/strategy"
)

var trendVersion = experiment.VersionDefinition{Strategy: "trend-ema", Params: strategy.ParamSpecs["trend-ema"]}

func TestGridCandidates(t *testing.T) {
	def := experiment.Definition{
		DatasetIDs: []string{"a"},
		Space: map[string]experiment.ParamRange{
			"slow": {Values: []float64{30, 20, 30}}, // unsorted, duplicate
			"fast": {Min: 5, Max: 15, Step: 5},
		},
		Search: experiment.SearchPlan{Mode: "grid", MaxAttempts: 100},
	}
	cs, err := candidates(trendVersion, def)
	require.NoError(t, err)
	require.Len(t, cs, 6, "3 fast × 2 slow")
	require.Equal(t, strategy.Params{"fast": 5, "slow": 20, "exposure": 1}, cs[0], "declared order: fast outer, slow inner; defaults kept")
	require.Equal(t, strategy.Params{"fast": 15, "slow": 30, "exposure": 1}, cs[5])

	def.Space["nope"] = experiment.ParamRange{Values: []float64{1}}
	_, err = candidates(trendVersion, def)
	require.ErrorIs(t, err, experiment.ErrInvalid)
	delete(def.Space, "nope")
	def.Space["fast"] = experiment.ParamRange{Values: []float64{5.5}}
	_, err = candidates(trendVersion, def)
	require.ErrorIs(t, err, experiment.ErrInvalid, "integer parameter")
}

func TestRandomCandidatesSeededAndUnique(t *testing.T) {
	def := experiment.Definition{
		DatasetIDs: []string{"a", "b"},
		Space: map[string]experiment.ParamRange{
			"fast": {Min: 2, Max: 30, Step: 1},
			"slow": {Min: 31, Max: 120, Step: 1},
		},
		Search: experiment.SearchPlan{Mode: "random", Seed: 7, MaxAttempts: 40},
	}
	a, err := candidates(trendVersion, def)
	require.NoError(t, err)
	b, err := candidates(trendVersion, def)
	require.NoError(t, err)
	require.Len(t, a, 20, "budget 40 over 2 pairs")
	require.Equal(t, a, b, "same seed, same candidates")
	seen := map[[2]float64]bool{}
	for _, p := range a {
		k := [2]float64{p["fast"], p["slow"]}
		require.False(t, seen[k], "no repeats")
		seen[k] = true
	}
	def.Search.Seed = 8
	c, err := candidates(trendVersion, def)
	require.NoError(t, err)
	require.NotEqual(t, a, c)
}

// Plan M4 acceptance: a cached result can never be reused when any input differs.
func TestCacheKeyCoversEveryInput(t *testing.T) {
	base := eval.Spec{
		DatasetIDs: []string{"ds1"}, Timeframe: data.TF1h, Strategy: "trend-ema",
		Params: strategy.WithDefaults("trend-ema", nil),
		Sim:    sim.Config{Capital: money.Amount{V: 1000e8, Asset: instrument.USDT}, FeeRate: 1000, SlipRate: 500},
		Split:  eval.SplitPlan{Folds: 4, Holdout: 200_000},
	}
	k0, err := CacheKey("build-a", base)
	require.NoError(t, err)
	same, _ := CacheKey("build-a", base)
	require.Equal(t, k0, same)

	variants := map[string]func(s *eval.Spec) string{
		"build":     func(s *eval.Spec) string { return "build-b" },
		"dataset":   func(s *eval.Spec) string { s.DatasetIDs = []string{"ds2"}; return "build-a" },
		"timeframe": func(s *eval.Spec) string { s.Timeframe = data.TF4h; return "build-a" },
		"strategy":  func(s *eval.Spec) string { s.Strategy = "mean-rev-bands"; return "build-a" },
		"param": func(s *eval.Spec) string {
			s.Params = strategy.WithDefaults("trend-ema", strategy.Params{"fast": 13})
			return "build-a"
		},
		"exposure": func(s *eval.Spec) string {
			s.Params = strategy.WithDefaults("trend-ema", strategy.Params{"exposure": 0.5})
			return "build-a"
		},
		"capital":  func(s *eval.Spec) string { s.Sim.Capital.V++; return "build-a" },
		"fee":      func(s *eval.Spec) string { s.Sim.FeeRate++; return "build-a" },
		"slippage": func(s *eval.Spec) string { s.Sim.SlipRate++; return "build-a" },
		"latency":  func(s *eval.Spec) string { s.Sim.LatencyBars = 2; return "build-a" },
		"sizing": func(s *eval.Spec) string {
			s.Sim.Sizing, s.Sim.FixedUSDT = sim.SizeFixed, money.Amount{V: 100e8, Asset: instrument.USDT}
			return "build-a"
		},
		"ttl": func(s *eval.Spec) string { s.Sim.IntentTTL = time.Hour; return "build-a" },
		"holdings": func(s *eval.Spec) string {
			s.Sim.Holdings = []money.Amount{{V: 1, Asset: instrument.Asset("BTC")}}
			return "build-a"
		},
		"folds":   func(s *eval.Spec) string { s.Split.Folds = 5; return "build-a" },
		"rolling": func(s *eval.Spec) string { s.Split.Rolling = true; return "build-a" },
		"holdout": func(s *eval.Spec) string { s.Split.Holdout = 250_000; return "build-a" },
		"embargo": func(s *eval.Spec) string { s.Split.Embargo = time.Hour; return "build-a" },
	}
	seen := map[string]string{k0: "base"}
	for name, change := range variants {
		s := base
		s.Params = strategy.WithDefaults("trend-ema", nil)
		s.DatasetIDs = []string{"ds1"}
		build := change(&s)
		k, err := CacheKey(build, s)
		require.NoError(t, err, name)
		prev, dup := seen[k]
		require.False(t, dup, "%s produced the same key as %s", name, prev)
		seen[k] = name
	}
}

func m(key string, v int64, scale int32) metrics.Metric {
	return metrics.Metric{Key: key, V: v, Scale: scale, Valid: true}
}

func TestCheckConstraints(t *testing.T) {
	cs := []experiment.Constraint{{Metric: "max_drawdown", Op: "<=", Value: "0.2"}, {Metric: "closed_trades", Op: ">=", Value: "30"}}
	ok, v := Check(cs, []metrics.Metric{m("max_drawdown", 150_000, 6), m("closed_trades", 40, 0)})
	require.True(t, ok)
	require.Empty(t, v)
	ok, v = Check(cs, []metrics.Metric{m("max_drawdown", 250_000, 6), m("closed_trades", 40, 0)})
	require.False(t, ok)
	require.Equal(t, []string{"بیشترین افت سرمایه \u2066<= 0.2\u2069 نیست"}, v, "operator and limit isolated LTR")
	ok, _ = Check(cs, []metrics.Metric{{Key: "max_drawdown", Scale: 6, Valid: false}, m("closed_trades", 40, 0)})
	require.False(t, ok, "an invalid metric can never satisfy a hard limit")
}

func TestSelectConstraintsFirstThenObjective(t *testing.T) {
	def := experiment.Definition{Objective: experiment.Objective{Metric: "total_return", Maximize: true}}
	ret := func(v int64) []metrics.Metric { return []metrics.Metric{m("total_return", v, 6)} }
	attempts := []AttemptResult{
		{Candidate: 1, Status: "done", Eligible: true, Metrics: ret(50_000)},
		{Candidate: 1, Status: "done", Eligible: true, Metrics: ret(70_000)},   // mean 60k
		{Candidate: 2, Status: "done", Eligible: false, Metrics: ret(900_000)}, // best return, violates a constraint
		{Candidate: 2, Status: "done", Eligible: true, Metrics: ret(900_000)},
		{Candidate: 3, Status: "done", Eligible: true, Metrics: ret(80_000)},
		{Candidate: 3, Status: "failed"}, // one pair failed
		{Candidate: 4, Status: "done", Eligible: true, Metrics: ret(60_000)},
		{Candidate: 4, Status: "done", Eligible: true, Metrics: ret(60_000)}, // ties with 1: earlier wins
	}
	r := Select(def, attempts)
	require.Equal(t, 1, r.Chosen)
	require.Equal(t, 4, r.Candidates)
	require.Equal(t, 2, r.EligibleCandidates)
	require.Equal(t, 8, r.Attempts, "every attempt counts, failed ones too")
	require.Equal(t, int64(60_000), r.Objective.V)

	def.Objective.Maximize = false
	require.Equal(t, 1, Select(def, attempts).Chosen, "minimize: 60k ties, earlier wins")

	none := Select(def, attempts[2:4])
	require.Zero(t, none.Chosen, "no eligible candidate is a valid result")
	require.NotEmpty(t, none.Reason)
}
