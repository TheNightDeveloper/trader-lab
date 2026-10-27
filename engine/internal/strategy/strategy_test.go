package strategy

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

func closeBar(sym string, i int, c float64) data.Bar {
	return data.Bar{Instrument: sym, OpenTime: t0.Add(time.Duration(i) * time.Minute), C: money.Price{V: int64(c * 1e8), Scale: 8}}
}

// feed runs closes through s and returns the bar index and target of every intent.
func feed(t *testing.T, s Strategy, closes []float64) [][2]int64 {
	var out [][2]int64
	for i, c := range closes {
		ins, err := s.OnBar(nil, closeBar("BTCUSDT", i, c))
		require.NoError(t, err)
		for _, in := range ins {
			out = append(out, [2]int64{int64(i), int64(in.Target)})
		}
	}
	return out
}

func TestRegistryAndParams(t *testing.T) {
	require.Equal(t, []string{"buy-and-hold", "hold-cash", "mean-rev-bands", "trend-ema"}, Names())
	_, err := New("nope", nil)
	require.ErrorIs(t, err, ErrUnknown)
	for _, bad := range []struct {
		name string
		p    Params
	}{
		{"trend-ema", Params{"fast": 26, "slow": 12}},
		{"trend-ema", Params{"fast": 2.5}},
		{"trend-ema", Params{"fsat": 5}}, // typo must not fall back to a default
		{"mean-rev-bands", Params{"k": 0}},
		{"mean-rev-bands", Params{"period": 1}},
		{"buy-and-hold", Params{"exposure": 1.5}},
		{"hold-cash", Params{"x": 1}},
	} {
		_, err := New(bad.name, bad.p)
		require.Error(t, err, "%s %v", bad.name, bad.p)
	}
}

func TestTrendEMACrosses(t *testing.T) {
	s, err := New("trend-ema", Params{"fast": 2, "slow": 4})
	require.NoError(t, err)
	closes := []float64{10, 10, 10, 10, 9, 8, 7, 8, 10, 12, 14, 12, 9, 6}
	got := feed(t, s, closes)
	require.NotEmpty(t, got)
	// Alternating, starting with whichever cross comes first after warm-up.
	for i := 1; i < len(got); i++ {
		require.NotEqual(t, got[i-1][1], got[i][1], "signals alternate")
	}
	last := got[len(got)-1]
	require.Equal(t, int64(0), last[1], "ends flat after the final fall")
}

func TestMeanRevBandsReentry(t *testing.T) {
	s, err := New("mean-rev-bands", Params{"period": 5, "k": 1})
	require.NoError(t, err)
	closes := []float64{100, 101, 100, 101, 100, 90, 99, 100.5, 101}
	got := feed(t, s, closes)
	require.Equal(t, [][2]int64{{6, int64(money.RatioOne)}, {7, 0}}, got, "buy on re-entry at 99, exit at the mean")
}

func TestBuyAndHoldOncePerSymbol(t *testing.T) {
	s, err := New("buy-and-hold", Params{"exposure": 0.5})
	require.NoError(t, err)
	var n int
	for i := range 3 {
		for _, sym := range []string{"BTCUSDT", "ETHUSDT"} {
			ins, err := s.OnBar(nil, closeBar(sym, i, 1))
			require.NoError(t, err)
			for _, in := range ins {
				n++
				require.Equal(t, money.RatioOne/2, in.Target)
			}
		}
	}
	require.Equal(t, 2, n)
}
