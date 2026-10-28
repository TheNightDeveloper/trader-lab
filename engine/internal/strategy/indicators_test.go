package strategy

import (
	"math"
	"math/rand/v2"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

func walkBars(n int) []data.Bar {
	rng := rand.New(rand.NewPCG(3, 3))
	out := make([]data.Bar, n)
	p := 100.0
	for i := range out {
		p *= 1 + rng.NormFloat64()*0.01
		v := int64(p * 1e8)
		out[i] = data.Bar{Instrument: "BTCUSDT", OpenTime: time.Unix(int64(i)*3600, 0), C: money.Price{V: v}, H: money.Price{V: v}, L: money.Price{V: v}}
	}
	return out
}

func valid(v float64) bool { return !math.IsNaN(v) }

// The chart's lines are the strategies' lines: trend-ema trades exactly where the
// chart's EMA lines cross, mean-rev-bands enters exactly where the close comes
// back above the chart's lower band.
func TestIndicatorParityWithStrategies(t *testing.T) {
	bars := walkBars(1500)
	fast, err := ComputeIndicator("ema:5", bars)
	require.NoError(t, err)
	slow, err := ComputeIndicator("ema:20", bars)
	require.NoError(t, err)
	s, err := New("trend-ema", Params{"fast": 5, "slow": 20})
	require.NoError(t, err)
	f, sl := fast.Lines[0].Values, slow.Lines[0].Values
	crosses := 0
	for i, b := range bars {
		in, err := s.OnBar(nil, b)
		require.NoError(t, err)
		cross := i > 0 && valid(f[i-1]) && valid(sl[i-1]) && (f[i] > sl[i]) != (f[i-1] > sl[i-1])
		require.Equal(t, cross, len(in) == 1, "bar %d", i)
		if cross {
			crosses++
			require.Equal(t, f[i] > sl[i], in[0].Target > 0)
		}
	}
	require.Greater(t, crosses, 20)

	bb, err := ComputeIndicator("bb:20:2", bars)
	require.NoError(t, err)
	lower, mid := bb.Lines[2].Values, bb.Lines[0].Values
	m, err := New("mean-rev-bands", Params{"period": 20, "k": 2})
	require.NoError(t, err)
	long, entries := false, 0
	for i, b := range bars {
		in, err := m.OnBar(nil, b)
		require.NoError(t, err)
		c := closeF(b)
		if i == 0 || !valid(lower[i-1]) {
			require.Empty(t, in)
			continue
		}
		enter := !long && closeF(bars[i-1]) < lower[i-1] && c >= lower[i]
		exit := long && c >= mid[i]
		require.Equal(t, enter || exit, len(in) == 1, "bar %d", i)
		if enter {
			long = true
			entries++
		} else if exit {
			long = false
		}
	}
	require.Greater(t, entries, 5)
}

func TestIndicatorKeys(t *testing.T) {
	bars := walkBars(100)
	for _, k := range []string{"ma:20", "ema:12", "bb:20:2", "rsi:14", "macd:12:26:9"} {
		ind, err := ComputeIndicator(k, bars)
		require.NoError(t, err, k)
		for _, l := range ind.Lines {
			require.Len(t, l.Values, len(bars))
			require.True(t, math.IsNaN(l.Values[0]), "%s %s: warm-up is undefined, not zero", k, l.Name)
			require.False(t, math.IsNaN(l.Values[len(bars)-1]), k)
		}
	}
	r, _ := ComputeIndicator("rsi:14", bars)
	for _, v := range r.Lines[0].Values[14:] {
		require.True(t, v >= 0 && v <= 100)
	}
	for _, bad := range []string{"ema", "ema:0", "ema:2.5", "bb:20", "macd:26:12:9", "vwap:10"} {
		_, err := ComputeIndicator(bad, bars)
		require.Error(t, err, bad)
	}
}
