package loop

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/model"
)

var parent = model.Recipe{Format: 1, Features: []string{"ret_1", "ret_4", "ret_24", "vol_24", "rsi_14"}, Transform: "zscore",
	Model: "ridge", Alpha: 0.1, Horizon: 4, Entry: 0.0015, Filter: &model.Filter{Feature: "vol_24", Max: 1}, Exposure: 1}

func TestVariantsAreBoundedUniqueAndDeterministic(t *testing.T) {
	vs := Variants(parent, 100)
	require.Equal(t, vs, Variants(parent, 100))
	seen := map[string]bool{parent.Hash(): true}
	for _, v := range vs {
		require.NoError(t, v.Recipe.Validate(), v.Change)
		require.False(t, seen[v.Recipe.Hash()], "unique and never the parent: %s", v.Change)
		seen[v.Recipe.Hash()] = true
	}
	require.Equal(t, "+range_24", vs[0].Change)
	require.Len(t, Variants(parent, 5), 5, "capped by the candidate budget")
	require.Equal(t, []string{"ret_1", "ret_4", "ret_24", "vol_24", "rsi_14"}, parent.Features, "the parent is not mutated")
	require.Equal(t, 1.0, parent.Filter.Max)
}

func TestCycleSplitKeepsUsedForwardDataTrainingOnly(t *testing.T) {
	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	to := from.Add(60 * 24 * time.Hour)
	s, err := cycleSplit(from, to, time.Time{}, 4, time.Hour, 4*time.Hour)
	require.NoError(t, err)
	require.Equal(t, from.Add(12*24*time.Hour), s.OOS.From, "first fifth trains only")
	for _, f := range s.Folds {
		require.Equal(t, from, f.Train.From, "expanding")
		require.Equal(t, f.Test.From.Add(-4*time.Hour), f.Train.To, "embargo = label horizon")
	}
	require.Equal(t, to, s.Folds[3].Test.To)

	consumed := from.Add(50*24*time.Hour + 30*time.Minute)
	s, err = cycleSplit(from, to, consumed, 2, time.Hour, 4*time.Hour)
	require.NoError(t, err)
	require.Equal(t, consumed.Truncate(time.Hour).Add(time.Hour), s.OOS.From, "tests start after the forward data a decision used")
	require.Equal(t, from, s.Folds[0].Train.From, "that data may still be trained on")

	_, err = cycleSplit(from, to, to.Add(-10*time.Hour), 2, time.Hour, time.Hour)
	require.Error(t, err, "too little fresh data")
}

func m(key string, v int64) metrics.Metric {
	return metrics.Metric{Key: key, V: v, Scale: 6, Valid: true}
}

func TestGateAndDecision(t *testing.T) {
	g := Default().Gate
	g.MinForwardTrades = 60
	d := &Doc{Challenger: &Contender{Walk: []metrics.Metric{m("max_drawdown", 100_000)}}, Walk: &Walk{Wins: 3, Folds: make([]eval.Fold, 4)}}
	d.Forward = &Forward{Days: 9,
		Challenger: []metrics.Metric{m("total_return", 30_000), m("max_drawdown", 46_000), {Key: "trades", V: 41, Valid: true}},
		Champion:   []metrics.Metric{m("total_return", 19_000), m("max_drawdown", 40_000), {Key: "trades", V: 37, Valid: true}}}
	items := gate(g, d, false)
	status := map[string]string{}
	for _, it := range items {
		status[it.Key] = it.Status
	}
	require.Equal(t, map[string]string{"constraints": "pass", "improvement": "pass", "drawdown": "pass", "trades": "pending", "days": "pending", "walk": "pass"}, status)
	require.Contains(t, items[1].Text, "\u2066+1.10\u2069", "plain text with the current margin")

	out, _ := decide(gate(g, d, true))
	require.Equal(t, GateFailed, out, "at the decision, pending conditions fail")

	d.Forward.Days = 14
	d.Forward.Challenger[2].V = 60
	out, _ = decide(gate(g, d, true))
	require.Equal(t, Recommended, out)

	d.Forward.Challenger[0].V = 25_000 // +0.6 points: under the 1.0 threshold
	out, why := decide(gate(g, d, true))
	require.Equal(t, NotBetter, out)
	require.Contains(t, why, "نامزد بهتر نیست")

	require.Equal(t, "−1.23%", pct(-12_345, true))
	require.Equal(t, "+0.10", points(1_000, true))
}
