package eval

import (
	"context"
	"math"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/strategy"
)

func TestPeriodMetricsDoNotChangeWhenFutureExitsArrive(t *testing.T) {
	bs := walk("BTCUSDT", 4000, 11)
	cfg := testSpec().Sim
	w := Window{From: bs[100].OpenTime, To: bs[2000].OpenTime}
	run := func(bars []data.Bar) *sim.Result {
		s := strategy.NewScripted([]strategy.Step{
			{At: bs[110].OpenTime, Intent: strategy.Intent{Instrument: "BTCUSDT", Target: 1_000_000}},
			{At: bs[2500].OpenTime, Intent: strategy.Intent{Instrument: "BTCUSDT", Target: 0}},
		})
		r, err := sim.Run(context.Background(), cfg, specs(), map[string][]data.Bar{"BTCUSDT": bars}, s)
		require.NoError(t, err)
		return r
	}
	prefix, full := run(bs[:2000]), run(bs)
	a, b := window(prefix, w, cfg.Capital.V), window(full, w, cfg.Capital.V)
	for _, key := range []string{"net_pnl", "period_pnl", "gross_pnl", "fees", "slippage", "unrealized_pnl", "total_return", "max_drawdown", "trades", "closed_trades", "win_rate"} {
		require.Equal(t, get(t, a, key), get(t, b, key), key)
	}
	require.NotEqual(t, get(t, a, "cohort_lifetime_pnl").V, get(t, b, "cohort_lifetime_pnl").V, "lifetime cohort is explicitly separate")
	require.Equal(t, get(t, b, "final_equity").V-cfg.Capital.V, get(t, b, "period_pnl").V)
	require.Equal(t, get(t, b, "gross_pnl").V-get(t, b, "fees").V-get(t, b, "slippage").V, get(t, b, "period_pnl").V)
	// A position carried into the next fold contributes mark-to-market PnL there,
	// even though it is not a newly opened trade of that fold.
	next := window(full, Window{From: w.To, To: bs[3900].OpenTime}, cfg.Capital.V)
	require.Zero(t, get(t, next, "trades").V)
	require.NotZero(t, get(t, next, "period_pnl").V)
	require.Positive(t, get(t, next, "exposure").V, "carried positions remain part of period exposure")
}

func TestPeriodAggregatesRejectOverflow(t *testing.T) {
	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	to := from.Add(time.Hour)
	r := &sim.Result{
		Equity: []sim.EquityPoint{{Time: to, Equity: money.Amount{V: 100}}},
		Fills:  []sim.Fill{{ObservedAt: to, FeeUSDT: money.Amount{V: math.MaxInt64}}, {ObservedAt: to, FeeUSDT: money.Amount{V: math.MaxInt64}}},
		Trades: []sim.Trade{{OpenedAt: from, Net: money.Amount{V: math.MaxInt64}}, {OpenedAt: from, Net: money.Amount{V: math.MaxInt64}}},
	}
	ms := window(r, Window{From: from, To: to}, 100)
	for _, key := range []string{"fees", "gross_pnl", "cohort_lifetime_pnl"} {
		require.False(t, get(t, ms, key).Valid, key)
		require.NotEmpty(t, get(t, ms, key).Invalid, key)
	}
	require.True(t, get(t, ms, "period_pnl").Valid)
	require.Zero(t, get(t, ms, "period_pnl").V)
}

func TestPeriodCostsUseObservedEventsAtSharedBoundary(t *testing.T) {
	bs := walk("BTCUSDT", 100, 7)
	// A delayed execution must not charge an earlier period, even if its
	// reference fill time is in that period.
	for i := 30; i <= 45; i++ {
		bs[i].AvailableAt = bs[45].AvailableAt
	}
	s := strategy.NewScripted([]strategy.Step{{At: bs[28].OpenTime, Intent: strategy.Intent{Instrument: "BTCUSDT", Target: 1_000_000}}})
	cfg := testSpec().Sim
	cfg.IntentTTL = 100 * time.Minute
	r, err := sim.Run(context.Background(), cfg, specs(), map[string][]data.Bar{"BTCUSDT": bs}, s)
	require.NoError(t, err)
	require.NotEmpty(t, r.Fills)
	boundary := bs[35].OpenTime
	a := window(r, Window{From: bs[0].OpenTime, To: boundary}, testSpec().Sim.Capital.V)
	b := window(r, Window{From: boundary, To: bs[99].AvailableAt.Add(time.Second)}, testSpec().Sim.Capital.V)
	all := window(r, Window{From: bs[0].OpenTime, To: bs[99].AvailableAt.Add(time.Second)}, testSpec().Sim.Capital.V)
	require.True(t, r.Fills[0].Time.Before(boundary), "reference fill belongs to earlier calendar period")
	require.Zero(t, get(t, a, "fees").V, "its observation was later, so earlier evidence has no fees")
	require.Positive(t, get(t, b, "fees").V)
	for _, key := range []string{"period_pnl", "fees", "slippage"} {
		x, _ := metrics.Get(a, key)
		y, _ := metrics.Get(b, key)
		z, _ := metrics.Get(all, key)
		require.Equal(t, z.V, x.V+y.V, key)
	}
}
