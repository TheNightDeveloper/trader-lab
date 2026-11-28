package feature

import (
	"context"
	"math"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

func TestRowValues(t *testing.T) {
	var bars []data.Bar
	for i := range 30 {
		c := int64(100+i) * 1e8 // a steady climb: 100, 101, …
		bars = append(bars, data.Bar{OpenTime: time.Unix(int64(i)*3600, 0), C: money.Price{V: c}, H: money.Price{V: c + 1e8}, L: money.Price{V: c - 1e8}})
	}
	x, ok := Row([]string{"ret_1", "ret_4", "rsi_14", "range_24"}, bars)
	require.True(t, ok)
	require.InDelta(t, 129.0/128-1, x[0], 1e-12)
	require.InDelta(t, 129.0/125-1, x[1], 1e-12)
	require.Equal(t, 1.0, x[2], "only gains")
	require.InDelta(t, (130.0-105)/129, x[3], 1e-12)

	_, ok = Row([]string{"ret_72"}, bars)
	require.False(t, ok, "not enough history: no row")
	require.ErrorIs(t, Check([]string{"ret_1", "nope"}), ErrUnknown)
}

// A late dependency must not be disguised by the last bar's earlier timestamp.
func TestSamplesWaitForEveryFeatureDependency(t *testing.T) {
	start := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	bars := make([]data.Bar, 12)
	for i := range bars {
		at := start.Add(time.Duration(i) * time.Hour)
		p := money.Price{V: int64(100+i) * 1e8}
		bars[i] = data.Bar{OpenTime: at, CloseTime: at.Add(time.Hour), AvailableAt: at.Add(time.Hour), O: p, C: p}
	}
	late := start.Add(20 * time.Hour)
	bars[3].AvailableAt = late
	from, to := bars[4].OpenTime, bars[5].OpenTime
	rows, err := Samples([]string{"ret_1", "ret_4"}, 1, bars, from, to, start.Add(12*time.Hour))
	require.NoError(t, err)
	require.Empty(t, rows, "an unavailable member of the feature window cannot enter a fit")
	rows, err = Samples([]string{"ret_1", "ret_4"}, 1, bars, from, to, late)
	require.NoError(t, err)
	require.Empty(t, rows, "the old feature window never existed at the decision")

	rows, err = Samples([]string{"ret_1"}, 1, bars, bars[8].OpenTime, bars[9].OpenTime, start.Add(12*time.Hour))
	require.NoError(t, err)
	require.Len(t, rows, 1, "late bars outside the feature window do not block unrelated rows")

	bars[4].AvailableAt = late
	rows, err = Samples([]string{"ret_1"}, 1, bars, from, to, start.Add(12*time.Hour))
	require.NoError(t, err)
	require.Empty(t, rows, "the label's starting price must also exist")
}

func TestScalerRejectsMalformedRows(t *testing.T) {
	for name, rows := range map[string][]Sample{
		"empty":    {{X: nil}},
		"width":    {{X: []float64{1}}, {X: []float64{1, 2}}},
		"nan":      {{X: []float64{math.NaN()}}},
		"infinity": {{X: []float64{math.Inf(1)}}},
		"overflow": {{X: []float64{math.MaxFloat64}}, {X: []float64{-math.MaxFloat64}}},
	} {
		t.Run(name, func(t *testing.T) {
			require.NotPanics(t, func() {
				_, err := FitScaler(rows, time.Now())
				require.Error(t, err)
			})
		})
	}
}

func TestLabelStartsAtCausalFillAndWaitsForExitPrice(t *testing.T) {
	start := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	bars := make([]data.Bar, 8)
	for i := range bars {
		at := start.Add(time.Duration(i) * time.Hour)
		bars[i] = data.Bar{OpenTime: at, CloseTime: at.Add(time.Hour), AvailableAt: at.Add(time.Hour + time.Second),
			O: money.Price{V: int64(100+i*10) * 1e8}, C: money.Price{V: int64(101+i*10) * 1e8}}
	}
	from, to := bars[1].OpenTime, bars[2].OpenTime
	// Bar 2 opened before the decision. Bar 4 opened before the entry at bar 3 was observed.
	exit := bars[5]
	rows, err := Samples([]string{"ret_1"}, 1, bars, from, to, exit.AvailableAt.Add(-time.Nanosecond))
	require.NoError(t, err)
	require.Empty(t, rows)
	rows, err = Samples([]string{"ret_1"}, 1, bars, from, to, exit.AvailableAt)
	require.NoError(t, err)
	require.Len(t, rows, 1)
	require.Equal(t, exit.AvailableAt, rows[0].ReadyAt)
	require.InDelta(t, 150.0/130.0-1, rows[0].Y, 1e-12)

	costs := LabelCosts{Fee: 10_000, Slippage: 20_000}
	rows, err = SamplesContext(context.Background(), []string{"ret_1"}, 1, bars, from, to, exit.AvailableAt, costs)
	require.NoError(t, err)
	require.Len(t, rows, 1)
	require.InDelta(t, (150*.98*.99)/(130*1.02*1.01)-1, rows[0].Y, 1e-12)

	bars[4].Flags = data.FlagFilled
	rows, err = Samples([]string{"ret_1"}, 1, bars, from, to, exit.AvailableAt)
	require.NoError(t, err)
	require.Empty(t, rows, "a synthetic holding path is not an observed round trip")

	bars[4].Flags = 0
	bars[4].AvailableAt = bars[7].AvailableAt
	rows, err = Samples([]string{"ret_1"}, 1, bars, from, to, exit.AvailableAt)
	require.NoError(t, err)
	require.Empty(t, rows, "the exit cannot attest an unobserved holding path")
}
