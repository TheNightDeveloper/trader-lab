package train

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/model"
)

// A deterministic cancellation checkpoint avoids timing-dependent solver tests.
type checkpointContext struct {
	context.Context
	remaining int
}

func (c *checkpointContext) Err() error {
	c.remaining--
	if c.remaining <= 0 {
		return context.Canceled
	}
	return nil
}

func TestCancellationInsideWalkForwardStep(t *testing.T) {
	bs := Bars(600, 3)
	ctx := &checkpointContext{Context: context.Background(), remaining: 4}
	models, err := WalkForward(ctx, Ridge(), map[string][]data.Bar{"BTCUSDT": bs}, []Step{{From: t0, To: bs[400].OpenTime, AsOf: bs[400].OpenTime}}, Meta{})
	require.ErrorIs(t, err, context.Canceled)
	require.Empty(t, models, "never expose a partial fit after cancellation")
}

func TestUnchangedFitReference(t *testing.T) {
	bs := Bars(600, 3)
	for _, kind := range []string{"ridge", "logistic"} {
		r := Ridge()
		r.Model = kind
		if kind == "logistic" {
			r.Entry = .55
		}
		end := t0.Add(400 * time.Hour)
		rows, err := feature.Samples(r.Features, r.Horizon, bs, t0, end, end)
		require.NoError(t, err)
		a, err := Fit(context.Background(), r, rows, t0, end, end, Meta{Algorithm: "reference", Seed: 42})
		require.NoError(t, err)
		want := map[string]string{"ridge": "m_e28fe1113ecceecd", "logistic": "m_58589b6c51d65f83"}
		require.Equal(t, want[kind], a.ID, "cancellation checks must not change a completed fit")
	}
}

func TestCancellationDuringFittingPasses(t *testing.T) {
	rows := []feature.Sample{{X: []float64{1, 2, 3}, Y: .1}}
	z := [][]float64{{1, 2, 3}}
	for _, kind := range []string{"ridge", "logistic", "error"} {
		t.Run(kind, func(t *testing.T) {
			ctx := &checkpointContext{Context: context.Background(), remaining: 2}
			var err error
			switch kind {
			case "ridge":
				_, _, err = ridge(ctx, z, rows, .1)
			case "logistic":
				_, _, err = logistic(ctx, z, rows, .1)
			case "error":
				rows = append(rows, make([]feature.Sample, 256)...)
				// Cancel before the next chunk without needing valid later rows.
				ctx.remaining = 1
				_, err = trainError(ctx, model.Artifact{}, rows)
			}
			require.ErrorIs(t, err, context.Canceled)
		})
	}
}

func TestFitLimitsAndCancelledInputs(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	a, err := Fit(ctx, Ridge(), nil, t0, t0, t0, Meta{})
	require.ErrorIs(t, err, context.Canceled)
	require.Empty(t, a.ID)
	_, err = WalkForward(context.Background(), Ridge(), nil, make([]Step, MaxSteps+1), Meta{})
	require.ErrorIs(t, err, ErrLimit)
	// Oversized input must be rejected before validation/scaling creates another matrix.
	a, err = Fit(context.Background(), Ridge(), make([]feature.Sample, MaxSamples+1), t0, t0, t0, Meta{})
	require.ErrorIs(t, err, ErrLimit)
	require.Empty(t, a.ID)
}

func TestFeaturePreparationCancellationReturnsNoPartialData(t *testing.T) {
	ctx := &checkpointContext{Context: context.Background(), remaining: 2}
	bs := Bars(600, 3)
	rows, err := feature.SamplesContext(ctx, Ridge().Features, 1, bs, t0, bs[500].OpenTime, bs[500].OpenTime)
	require.ErrorIs(t, err, context.Canceled)
	require.Nil(t, rows)
	input := make([]feature.Sample, 300)
	for i := range input {
		input[i].X = []float64{float64(i)}
	}
	ctx = &checkpointContext{Context: context.Background(), remaining: 5}
	scaler, err := feature.FitScalerContext(ctx, input, bs[500].OpenTime)
	require.ErrorIs(t, err, context.Canceled)
	require.Empty(t, scaler.Mean)
}
