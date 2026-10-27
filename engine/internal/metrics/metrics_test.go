package metrics

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

func at(d time.Duration) *time.Time { t := t0.Add(d); return &t }

func get(t *testing.T, ms []Metric, key string) Metric {
	m, ok := Get(ms, key)
	require.True(t, ok, key)
	return m
}

func TestPnLIsExactSumOfTrades(t *testing.T) {
	trades := []Trade{
		{Opened: t0, Closed: at(time.Hour), Gross: 1000, Fees: 30, Slippage: 20, Net: 950},
		{Opened: t0.Add(2 * time.Hour), Closed: at(3 * time.Hour), Gross: -500, Fees: 30, Slippage: 20, Net: -550},
		{Opened: t0.Add(4 * time.Hour), Gross: 300, Fees: 15, Slippage: 5, Net: 280}, // open
	}
	ms := Compute(Input{Start: t0, End: t0.Add(5 * time.Hour), Initial: 1e11, Trades: trades,
		Equity: []Point{{t0.Add(5 * time.Hour), 1e11 + 680}}})
	require.Equal(t, int64(680), get(t, ms, "net_pnl").V)
	require.Equal(t, int64(800), get(t, ms, "gross_pnl").V)
	require.Equal(t, int64(75), get(t, ms, "fees").V)
	require.Equal(t, int64(45), get(t, ms, "slippage").V)
	require.Equal(t, int64(280), get(t, ms, "unrealized_pnl").V)
	require.Equal(t, int64(3), get(t, ms, "trades").V)
	require.Equal(t, int64(2), get(t, ms, "closed_trades").V)
	for _, m := range ms {
		_, ok := Definitions[m.Key]
		require.True(t, ok, "every metric has a definition: %s", m.Key)
	}
}

func TestDrawdownAndDuration(t *testing.T) {
	eq := []Point{
		{t0.Add(1 * time.Hour), 110e8}, // peak
		{t0.Add(2 * time.Hour), 88e8},  // −20%
		{t0.Add(3 * time.Hour), 99e8},
		{t0.Add(5 * time.Hour), 111e8}, // recovered after 4h
		{t0.Add(6 * time.Hour), 105e8},
	}
	ms := Compute(Input{Start: t0, End: t0.Add(8 * time.Hour), Initial: 100e8, Equity: eq})
	require.Equal(t, int64(200_000), get(t, ms, "max_drawdown").V, "20%")
	require.Equal(t, int64(4*3600), get(t, ms, "max_drawdown_duration").V)
	require.Equal(t, int64(50_000), get(t, ms, "total_return").V, "100 → 105 = +5%")
}

func TestExposureMergesOverlaps(t *testing.T) {
	trades := []Trade{
		{Opened: t0, Closed: at(2 * time.Hour)},
		{Opened: t0.Add(time.Hour), Closed: at(3 * time.Hour)}, // overlaps
		{Opened: t0.Add(9 * time.Hour)},                        // open to End
	}
	ms := Compute(Input{Start: t0, End: t0.Add(10 * time.Hour), Initial: 1, Trades: trades})
	require.Equal(t, int64(400_000), get(t, ms, "exposure").V, "3h + 1h of 10h")
}

func TestFewSamplesAreInvalidNotNumbers(t *testing.T) {
	trades := []Trade{{Opened: t0, Closed: at(time.Hour), Net: 10}}
	ms := Compute(Input{Start: t0, End: t0.Add(10 * 24 * time.Hour), Initial: 100e8, Trades: trades})
	for _, key := range []string{"sharpe", "win_rate", "profit_factor", "avg_win", "avg_loss"} {
		m := get(t, ms, key)
		require.False(t, m.Valid, key)
		require.Zero(t, m.V, "%s: an invalid metric carries no number", key)
		require.NotEmpty(t, m.Invalid, key)
	}
	require.Contains(t, get(t, ms, "sharpe").Invalid, "کمتر از 30")
}

func TestTradeStats(t *testing.T) {
	nets := []int64{100, -50, 200, -30, 80, 0}
	var trades []Trade
	for i, n := range nets {
		trades = append(trades, Trade{Opened: t0.Add(time.Duration(i) * time.Hour), Closed: at(time.Duration(i)*time.Hour + 30*time.Minute), Net: n})
	}
	ms := Compute(Input{Start: t0, End: t0.Add(24 * time.Hour), Initial: 1e10, Trades: trades})
	require.Equal(t, int64(500_000), get(t, ms, "win_rate").V, "3 of 6 (0 is not a win)")
	require.Equal(t, int64(4_750_000), get(t, ms, "profit_factor").V, "380 / 80")
	require.Equal(t, int64(127), get(t, ms, "avg_win").V, "380/3 half-even")
	require.Equal(t, int64(-27), get(t, ms, "avg_loss").V, "−80/3")
	require.Equal(t, int64(200), get(t, ms, "best_trade").V)
	require.Equal(t, int64(-50), get(t, ms, "worst_trade").V)
	require.Equal(t, int64(1800), get(t, ms, "avg_holding").V)

	noLoss := Compute(Input{Start: t0, End: t0.Add(time.Hour), Initial: 1, Trades: trades[:1:1]})
	require.False(t, get(t, noLoss, "profit_factor").Valid)
}

func TestSharpeMatchesReference(t *testing.T) {
	// 40 days alternating +1% and −0.5%. Reference (float, outside the engine): 6.288…
	e := int64(1000e8)
	var eq []Point
	for i := 0; i < 40; i++ {
		if i%2 == 0 {
			e = e * 101 / 100
		} else {
			e = e * 995 / 1000
		}
		eq = append(eq, Point{t0.Add(time.Duration(i+1) * 24 * time.Hour), e})
	}
	ms := Compute(Input{Start: t0, End: t0.Add(40 * 24 * time.Hour), Initial: 1000e8, Equity: eq})
	s := get(t, ms, "sharpe")
	require.True(t, s.Valid, s.Invalid)
	require.Equal(t, int64(628), s.V, "6.28 (scale 2, truncated)")

	flat := Compute(Input{Start: t0, End: t0.Add(40 * 24 * time.Hour), Initial: 1000e8})
	require.Contains(t, get(t, flat, "sharpe").Invalid, "نوسان")
}
