package eval

import (
	"context"
	"encoding/json"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/strategy"
)

func specs() map[string]instrument.Spec {
	m := map[string]instrument.Spec{}
	for _, s := range instrument.Defaults() {
		m[s.Symbol] = s
	}
	return m
}

// walk: n 1m bars of a seeded random walk with a slow wave, so trend-ema trades.
func walk(sym string, n int, seed uint64) []data.Bar {
	x := seed
	next := func(m int64) int64 {
		x = x*6364136223846793005 + 1442695040888963407
		return int64(x>>33) % m
	}
	bs := make([]data.Bar, n)
	p := int64(100_00000000)
	for i := range bs {
		o := p
		drift := int64(3_000_000) // ±0.03 per minute: a ±21% wave around 100
		if (i/700)%2 == 1 {
			drift = -drift
		}
		c := max(50e8, o+drift+next(20_000_000)-10_000_000)
		h, l := max(o, c)+next(20_000_000), max(1, min(o, c)-next(20_000_000))
		open := t0.Add(time.Duration(i) * time.Minute)
		bs[i] = data.Bar{Instrument: sym, OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute + 2*time.Second),
			O: money.Price{V: o, Scale: 8}, H: money.Price{V: h, Scale: 8}, L: money.Price{V: l, Scale: 8}, C: money.Price{V: c, Scale: 8},
			Volume: money.Qty{V: 1e8, Scale: 8}}
		p = c
	}
	return bs
}

func testSpec() Spec {
	return Spec{
		DatasetIDs: []string{"ds-test"}, Timeframe: data.TF1m,
		Strategy: "trend-ema", Params: strategy.WithDefaults("trend-ema", strategy.Params{"fast": 10, "slow": 30}),
		Sim:   sim.Config{Capital: money.Amount{V: 1000e8, Asset: instrument.USDT}, FeeRate: 1000, SlipRate: 500},
		Split: SplitPlan{Folds: 4, Holdout: 200_000},
	}
}

func get(t *testing.T, ms []metrics.Metric, key string) metrics.Metric {
	x, ok := metrics.Get(ms, key)
	require.True(t, ok, key)
	return x
}

func TestEvaluateIdentitiesAndIsolation(t *testing.T) {
	bars := map[string][]data.Bar{"BTCUSDT": walk("BTCUSDT", 20_000, 3)}
	ev, err := Evaluate(context.Background(), testSpec(), bars, specs())
	require.NoError(t, err)

	// Report numbers are exact sums of trade-level numbers.
	var net, n int64
	for _, tr := range ev.Main.Trades {
		if ev.Split.OOS.Contains(tr.OpenedAt) {
			net += tr.Net.V
			n++
		}
	}
	require.Positive(t, n, "the wave should produce trades")
	require.Equal(t, net, get(t, ev.OOS.Metrics, "net_pnl").V)
	require.Equal(t, n, get(t, ev.OOS.Metrics, "trades").V)

	// Folds partition the out-of-sample trades.
	var foldNet, foldTrades int64
	for _, f := range ev.Folds {
		foldNet += get(t, f.Metrics, "net_pnl").V
		foldTrades += get(t, f.Metrics, "trades").V
	}
	require.Equal(t, net, foldNet)
	require.Equal(t, n, foldTrades)

	// The main run never trades before OOS or into the holdout; the holdout run
	// never trades before the holdout.
	for _, tr := range ev.Main.Trades {
		require.True(t, ev.Split.OOS.Contains(tr.OpenedAt), "main trade at %s", tr.OpenedAt)
	}
	for _, tr := range ev.HoldoutRun.Trades {
		require.True(t, ev.Split.Holdout.Contains(tr.OpenedAt), "holdout trade at %s", tr.OpenedAt)
	}

	// Grid centre is the main configuration.
	require.NotNil(t, ev.Grid)
	require.Equal(t, "fast", ev.Grid.X)
	require.Equal(t, "slow", ev.Grid.Y)
	require.True(t, ev.Grid.Cells[1][1].Center)
	require.Equal(t, get(t, ev.OOS.Metrics, "total_return"), ev.Grid.Cells[1][1].Return)

	require.Len(t, ev.Benchmarks, 2)
	require.Equal(t, "hold_cash", ev.Benchmarks[1].Key)
	require.Zero(t, ev.Benchmarks[1].Return.V, "cash earns nothing")
	require.NotZero(t, ev.Benchmarks[0].Return.V, "buy and hold is invested from the OOS start")
	require.EqualValues(t, 200_000, ev.Spec.Split.Holdout, "defaults are recorded in the spec")
	for _, s := range ev.Stress {
		tr, _ := metrics.Get(s.Metrics, "trades")
		require.Positive(t, tr.V, "%s still trades (TTL scales with the timeframe)", s.Key)
	}
	require.Equal(t, Window{t0, t0.Add(20_000 * time.Minute)}, ev.Range)
	require.Len(t, ev.Stress, 3)
	for _, s := range ev.Stress {
		require.Empty(t, s.Error, s.Key)
	}
	require.Contains(t, ev.Summary.Sentence, ev.Split.OOS.From.Format("2006-01-02"))
	require.NotEmpty(t, ev.Summary.Verdict)
}

func TestEvaluateDeterministicDespiteParallelRuns(t *testing.T) {
	bars := map[string][]data.Bar{"BTCUSDT": walk("BTCUSDT", 8_000, 9)}
	a, err := Evaluate(context.Background(), testSpec(), bars, specs())
	require.NoError(t, err)
	b, err := Evaluate(context.Background(), testSpec(), bars, specs())
	require.NoError(t, err)
	ja, _ := json.Marshal(a)
	jb, _ := json.Marshal(b)
	require.Equal(t, string(ja), string(jb))
	ha, _ := json.Marshal(a.Holdout)
	hb, _ := json.Marshal(b.Holdout)
	require.Equal(t, string(ha), string(hb))
}

func TestEvaluateOOSMatchesFullEvaluation(t *testing.T) {
	bars := map[string][]data.Bar{"BTCUSDT": walk("BTCUSDT", 8_000, 4)}
	ev, err := Evaluate(context.Background(), testSpec(), bars, specs())
	require.NoError(t, err)
	light, err := EvaluateOOS(context.Background(), testSpec(), bars, specs())
	require.NoError(t, err)
	require.Equal(t, ev.OOS.Metrics, light, "the light run is the same OOS run")
}

func TestEvaluateRejectsBadSpecs(t *testing.T) {
	bars := map[string][]data.Bar{"BTCUSDT": walk("BTCUSDT", 2_000, 1)}
	s := testSpec()
	s.Strategy = "nope"
	_, err := Evaluate(context.Background(), s, bars, specs())
	require.ErrorIs(t, err, ErrSpec)
	s = testSpec()
	s.Sim.FeeRate = -1
	_, err = Evaluate(context.Background(), s, bars, specs())
	require.ErrorIs(t, err, ErrSpec)
}

func TestCompareEligibility(t *testing.T) {
	base := Comparable{ID: "a", Spec: testSpec()}
	params := base
	params.ID, params.Spec.Params = "b", strategy.WithDefaults("trend-ema", strategy.Params{"fast": 5, "slow": 30})
	costs := base
	costs.ID = "c"
	costs.Spec.Sim.FeeRate = 2000
	c := Compare([]Comparable{base, params, costs})
	require.Equal(t, []bool{true, true, false}, c.Eligible)
	require.Empty(t, c.Reasons[1], "different parameters are what we compare")
	require.Equal(t, []string{"کارمزد هر سمت متفاوت است"}, c.Reasons[2])
	var fee Assumption
	for _, a := range c.Assumptions {
		if a.Key == "fee" {
			fee = a
		}
	}
	require.True(t, fee.Differs)
	require.Contains(t, c.Conclusion, "رتبه‌بندی قطعی ممکن نیست", "no trades: no ranking")
	require.Equal(t, []string{"+0.10%", "+0.10%", "+0.20%"}, fee.Values)
}

func TestPct(t *testing.T) {
	require.Equal(t, "+3.21%", Pct(32_100))
	require.Equal(t, "−0.50%", Pct(-5_000))
	require.Equal(t, "0.00%", Pct(0))
	require.Equal(t, "+1234.57", USDTText(123_456_789_000))
}

func TestReplayReproducesNetExactly(t *testing.T) {
	bars := map[string][]data.Bar{"BTCUSDT": walk("BTCUSDT", 12_000, 5)}
	ev, err := Evaluate(context.Background(), testSpec(), bars, specs())
	require.NoError(t, err)
	v, res, err := Replay(context.Background(), ev.Split, ev.Main.Decisions, ev.Spec.Sim, money.RatioOne, bars, specs())
	require.NoError(t, err)
	require.Equal(t, get(t, ev.OOS.Metrics, "net_pnl").V, get(t, v.Metrics, "net_pnl").V)
	require.Equal(t, ev.Main.Fills, res.Fills, "identical fills, not just the same total")

	// Overrides change the numbers: double capital roughly doubles the sizes.
	c := ev.Spec.Sim
	c.Capital.V *= 2
	v2, _, err := Replay(context.Background(), ev.Split, ev.Main.Decisions, c, money.RatioOne, bars, specs())
	require.NoError(t, err)
	require.NotEqual(t, get(t, v.Metrics, "net_pnl").V, get(t, v2.Metrics, "net_pnl").V)

	// Half the position size: smaller, different fills.
	_, half, err := Replay(context.Background(), ev.Split, ev.Main.Decisions, ev.Spec.Sim, money.RatioOne/2, bars, specs())
	require.NoError(t, err)
	require.Less(t, half.Fills[0].Qty.V, res.Fills[0].Qty.V)
	_, _, err = Replay(context.Background(), ev.Split, ev.Main.Decisions, ev.Spec.Sim, 0, bars, specs())
	require.ErrorIs(t, err, ErrSpec)
}
