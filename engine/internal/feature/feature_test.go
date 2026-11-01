package feature

import (
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
		bars[i] = data.Bar{OpenTime: at, CloseTime: at.Add(time.Hour), AvailableAt: at.Add(time.Hour), C: money.Price{V: int64(100+i) * 1e8}}
	}
	late := start.Add(20 * time.Hour)
	bars[3].AvailableAt = late
	from, to := bars[4].OpenTime, bars[5].OpenTime
	rows, err := Samples([]string{"ret_1", "ret_4"}, 1, bars, from, to, start.Add(12*time.Hour))
	require.NoError(t, err)
	require.Empty(t, rows, "an unavailable member of the feature window cannot enter a fit")
	rows, err = Samples([]string{"ret_1", "ret_4"}, 1, bars, from, to, late)
	require.NoError(t, err)
	require.Len(t, rows, 1, "equality is available")
	require.Equal(t, late, rows[0].AvailableAt)
	require.Equal(t, bars[5].AvailableAt, rows[0].ReadyAt, "label uses its two price endpoints")
	_, err = FitScaler(rows, late.Add(-time.Nanosecond))
	require.ErrorIs(t, err, ErrLookAhead)

	rows, err = Samples([]string{"ret_1"}, 1, bars, bars[9].OpenTime, bars[10].OpenTime, start.Add(12*time.Hour))
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
