package train

import (
	"context"
	"errors"
	"math"
	"math/rand/v2"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/money"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

// Bars returns hourly bars whose returns are autocorrelated (r = 0.4·r₋₁ + noise),
// so last-bar momentum carries real information about the next bars.
func Bars(n int, seed uint64) []data.Bar {
	rng := rand.New(rand.NewPCG(seed, 7))
	out := make([]data.Bar, n)
	price, r := 100.0, 0.0
	for i := range out {
		r = 0.4*r + rng.NormFloat64()*0.004
		open := price
		price *= 1 + r
		hi, lo := math.Max(open, price)*1.001, math.Min(open, price)*0.999
		p := func(v float64) money.Price { return money.Price{V: int64(v * 1e8), Scale: instrument.Scale} }
		ot := t0.Add(time.Duration(i) * time.Hour)
		out[i] = data.Bar{
			Instrument: "BTCUSDT", OpenTime: ot, CloseTime: ot.Add(time.Hour), AvailableAt: ot.Add(time.Hour + 2*time.Second),
			O: p(open), H: p(hi), L: p(lo), C: p(price), Volume: money.Qty{V: 1e8, Scale: instrument.Scale},
		}
	}
	return out
}

func Ridge() model.Recipe {
	return model.Recipe{Format: 1, Features: []string{"ret_1", "ret_4", "vol_24"}, Transform: "zscore", Model: "ridge",
		Alpha: 0.01, Horizon: 1, Entry: 0.001, Exposure: 1}
}

func TestFeaturesAndLabelsOnlySeeThePast(t *testing.T) {
	bars := Bars(500, 1)
	r := Ridge()
	asOf := bars[300].OpenTime
	s, err := feature.Samples(r.Features, 4, bars, t0, asOf, asOf)
	require.NoError(t, err)
	require.NotEmpty(t, s)
	for _, x := range s {
		require.False(t, x.ReadyAt.After(asOf), "nothing unready enters training")
	}
	require.Less(t, s[len(s)-1].At, bars[300-4].OpenTime, "the last 4 bars before asOf have no ready label yet")

	// Appending future rows to the source changes nothing about the past.
	more, err := feature.Samples(r.Features, 4, append(bars[:300:300], Bars(800, 2)[300:]...), t0, asOf, asOf)
	require.NoError(t, err)
	require.Equal(t, s, more)
	a1, err := Fit(r, s, t0, asOf, asOf, Meta{})
	require.NoError(t, err)
	a2, err := Fit(r, more, t0, asOf, asOf, Meta{})
	require.NoError(t, err)
	require.Equal(t, a1.ID, a2.ID, "same past, same model")
}

func TestFittingOnAllHistoryIsCaught(t *testing.T) {
	bars := Bars(500, 1)
	r := Ridge()
	all, err := feature.Samples(r.Features, 1, bars, t0, bars[len(bars)-1].OpenTime, bars[len(bars)-1].CloseTime.Add(time.Hour))
	require.NoError(t, err)
	trainEnd := bars[250].OpenTime
	_, err = feature.FitScaler(all, trainEnd)
	require.ErrorIs(t, err, feature.ErrLookAhead, "a scaler fit on all history is rejected")
	_, err = Fit(r, all, t0, trainEnd, trainEnd, Meta{})
	require.ErrorIs(t, err, feature.ErrLookAhead)
	_, err = WalkForward(context.Background(), r, map[string][]data.Bar{"BTCUSDT": bars}, []Step{{From: t0, To: bars[400].OpenTime, AsOf: trainEnd}}, Meta{})
	require.ErrorIs(t, err, feature.ErrLookAhead, "a step cannot train past the time it serves from")
}

func TestSavedModelReproducesPredictions(t *testing.T) {
	bars := Bars(600, 3)
	for _, r := range []model.Recipe{Ridge(), {Format: 1, Features: []string{"ret_1", "rsi_14", "sma_gap_24"}, Transform: "zscore",
		Model: "logistic", Alpha: 0.001, Horizon: 2, Entry: 0.55, Exposure: 1}} {
		asOf := bars[400].OpenTime
		s, err := feature.Samples(r.Features, r.Horizon, bars, t0, asOf, asOf)
		require.NoError(t, err)
		a, err := Fit(r, s, t0, asOf, asOf, Meta{Algorithm: "x", Seed: 42})
		require.NoError(t, err)
		b, err := a.Save()
		require.NoError(t, err)
		back, err := model.Load(b)
		require.NoError(t, err)
		// Reference input: every row after the training window.
		for i := 400; i < len(bars); i++ {
			x, ok := feature.Row(r.Features, bars[:i+1])
			require.True(t, ok)
			require.InDelta(t, a.Predict(x), back.Predict(x), 1e-12, "stated tolerance 1e-12")
			require.Equal(t, a.Predict(x), back.Predict(x), "in practice bit-identical: JSON float64 round-trips")
		}
		back.Weights[0] += 1e-9
		b2, _ := back.Save()
		_, err = model.Load(b2)
		require.ErrorIs(t, err, model.ErrArtifact, "a changed weight no longer matches the id")
	}
}

func TestModelsLearnTheSignal(t *testing.T) {
	bars := Bars(3000, 4)
	asOf := bars[2000].OpenTime
	r := Ridge()
	s, err := feature.Samples(r.Features, 1, bars, t0, asOf, asOf)
	require.NoError(t, err)
	a, err := Fit(r, s, t0, asOf, asOf, Meta{})
	require.NoError(t, err)
	require.Greater(t, a.Weights[0], 0.0, "momentum weight is positive")

	lg := r
	lg.Model, lg.Entry = "logistic", 0.5
	l, err := Fit(lg, s, t0, asOf, asOf, Meta{})
	require.NoError(t, err)
	hit, n := 0, 0
	for i := 2000; i < len(bars)-1; i++ {
		x, _ := feature.Row(r.Features, bars[:i+1])
		up := bars[i+1].C.V > bars[i].C.V
		if (l.Predict(x) > 0.5) == up {
			hit++
		}
		n++
	}
	require.Greater(t, float64(hit)/float64(n), 0.55, "out-of-sample direction better than a coin")
}

func TestWalkForwardTrainsEachStepOnItsPast(t *testing.T) {
	bars := Bars(1000, 5)
	r := Ridge()
	steps := []Step{
		{From: t0, To: bars[400].OpenTime, AsOf: bars[400].OpenTime},
		{From: t0, To: bars[700].OpenTime, AsOf: bars[700].OpenTime},
	}
	ms, err := WalkForward(context.Background(), r, map[string][]data.Bar{"BTCUSDT": bars}, steps, Meta{Algorithm: "ridge"})
	require.NoError(t, err)
	require.Len(t, ms, 2)
	require.Less(t, ms[0].Samples, ms[1].Samples, "expanding window")
	require.Equal(t, steps[1].AsOf, ms[1].AsOf)

	_, err = Fit(r, nil, t0, t0, t0, Meta{})
	require.ErrorIs(t, err, ErrTooFew)

	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	_, err = WalkForward(ctx, r, map[string][]data.Bar{"BTCUSDT": bars}, steps, Meta{})
	require.True(t, errors.Is(err, context.Canceled))
}
