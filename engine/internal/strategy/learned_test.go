package strategy_test

import (
	"context"
	"math"
	"math/rand/v2"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/model/train"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/strategy"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

func bars(n int, seed uint64) []data.Bar {
	rng := rand.New(rand.NewPCG(seed, 7))
	out := make([]data.Bar, n)
	price, r := 100.0, 0.0
	for i := range out {
		r = 0.4*r + rng.NormFloat64()*0.004
		open := price
		price *= 1 + r
		p := func(v float64) money.Price { return money.Price{V: int64(v * 1e8), Scale: instrument.Scale} }
		ot := t0.Add(time.Duration(i) * time.Hour)
		out[i] = data.Bar{Instrument: "BTCUSDT", OpenTime: ot, CloseTime: ot.Add(time.Hour), AvailableAt: ot.Add(time.Hour + 2*time.Second),
			O: p(open), H: p(math.Max(open, price) * 1.001), L: p(math.Min(open, price) * 0.999), C: p(price), Volume: money.Qty{V: 1e8, Scale: instrument.Scale}}
	}
	return out
}

var recipe = model.Recipe{Format: 1, Features: []string{"ret_1", "ret_4", "vol_24"}, Transform: "zscore", Model: "ridge",
	Alpha: 0.01, Horizon: 1, Entry: 0.0005, Filter: &model.Filter{Feature: "vol_24", Max: 2}, Exposure: 1}

func specs() map[string]instrument.Spec {
	m := map[string]instrument.Spec{}
	for _, s := range instrument.Defaults() {
		m[s.Symbol] = s
	}
	return m
}

func cfg() sim.Config {
	return sim.Config{Capital: money.Amount{V: 10_000 * 1e8, Asset: instrument.USDT}, FeeRate: 1000, SlipRate: 500, LatencyBars: 1}
}

// Models are trained per fold before the run; the strategy only predicts.
func schedule(t *testing.T, bs []data.Bar, split eval.Split) []model.Artifact {
	var steps []train.Step
	for _, f := range split.Folds {
		steps = append(steps, train.Step{From: f.Train.From, To: f.Train.To, AsOf: f.Test.From})
	}
	ms, err := train.WalkForward(context.Background(), recipe, map[string][]data.Bar{"BTCUSDT": bs}, steps, train.Meta{Algorithm: "t"})
	require.NoError(t, err)
	return ms
}

func TestFutureRowsDoNotChangePastDecisions(t *testing.T) {
	all := bars(2000, 11)
	past := all[:1500]
	split, err := eval.SplitPlan{Folds: 3, Holdout: 100_000, Embargo: time.Hour}.Make(t0, past[len(past)-1].CloseTime, time.Hour)
	require.NoError(t, err)
	ms := schedule(t, past, split)

	// The second run sees 500 more bars (its window reaches them); decisions made
	// before the cut must be identical, outcome included.
	cut := split.OOS.To.Add(-2 * time.Hour) // the short run trades until its OOS end
	longer := split
	longer.OOS.To = all[len(all)-1].CloseTime
	run := func(bs []data.Bar, sp eval.Split) []sim.Decision {
		s, err := strategy.NewLearned(ms)
		require.NoError(t, err)
		_, folds, res, err := eval.RunSplit(context.Background(), s, cfg(), specs(), map[string][]data.Bar{"BTCUSDT": bs}, sp)
		require.NoError(t, err)
		require.Len(t, folds, 3)
		var out []sim.Decision
		for _, d := range res.Decisions {
			if d.InputBarOpen.Before(cut) {
				out = append(out, d)
			}
		}
		return out
	}
	a, b := run(past, split), run(all, longer)
	require.NotEmpty(t, a, "the model trades")
	require.Equal(t, a, b, "appending future rows does not change past predictions or decisions")
	for _, d := range a {
		require.NotEmpty(t, d.ModelID)
		require.False(t, d.InputBarOpen.Before(split.OOS.From), "no trading in warm-up")
	}
}

func TestModelServesOnlyFromItsAsOf(t *testing.T) {
	bs := bars(1200, 12)
	split, err := eval.SplitPlan{Folds: 2, Holdout: 100_000, Embargo: time.Hour}.Make(t0, bs[len(bs)-1].CloseTime, time.Hour)
	require.NoError(t, err)
	ms := schedule(t, bs, split)
	s, err := strategy.NewLearned(ms)
	require.NoError(t, err)
	_, _, res, err := eval.RunSplit(context.Background(), s, cfg(), specs(), map[string][]data.Bar{"BTCUSDT": bs}, split)
	require.NoError(t, err)
	byID := map[string]model.Artifact{}
	for _, m := range ms {
		byID[m.ID] = m
	}
	for _, d := range res.Decisions {
		m := byID[d.ModelID]
		require.False(t, d.InputBarOpen.Before(m.AsOf), "a decision never uses a model trained after it")
	}

	other := recipe
	other.Alpha = 1
	om, err := train.WalkForward(context.Background(), other, map[string][]data.Bar{"BTCUSDT": bs}, []train.Step{{From: t0, To: split.Folds[0].Train.To, AsOf: split.Folds[0].Test.From}}, train.Meta{})
	require.NoError(t, err)
	_, err = strategy.NewLearned(append(ms, om...))
	require.Error(t, err, "one strategy, one recipe")
}
