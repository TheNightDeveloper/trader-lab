package sim

import (
	"context"
	"encoding/json"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"pgregory.net/rapid"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/strategy"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

const delay = 2 * time.Second

func specs() map[string]instrument.Spec {
	m := map[string]instrument.Spec{}
	for _, s := range instrument.Defaults() {
		m[s.Symbol] = s
	}
	return m
}

func usdt(units int64) money.Amount { return money.Amount{V: units * 1e8, Asset: instrument.USDT} }

func px(v int64) money.Price { return money.Price{V: v, Scale: 8} }

// bar at minute i with OHLC in whole quote units.
func bar(sym string, i int, o, h, l, c int64) data.Bar {
	open := t0.Add(time.Duration(i) * time.Minute)
	return data.Bar{
		Instrument: sym, OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute + delay),
		O: px(o * 1e8), H: px(h * 1e8), L: px(l * 1e8), C: px(c * 1e8), Volume: money.Qty{V: 1e8, Scale: 8},
	}
}

func flat(sym string, n int, p int64) []data.Bar {
	bs := make([]data.Bar, n)
	for i := range bs {
		bs[i] = bar(sym, i, p, p, p, p)
	}
	return bs
}

func cfg() Config {
	return Config{Capital: usdt(1000), FeeRate: 1000, SlipRate: 500} // 10 bps fee, 5 bps slippage
}

func step(i int, sym string, target money.Ratio) strategy.Step {
	return strategy.Step{At: t0.Add(time.Duration(i) * time.Minute), Intent: strategy.Intent{Instrument: sym, Target: target, Reason: "test"}}
}

func run(t testing.TB, c Config, bars map[string][]data.Bar, steps ...strategy.Step) *Result {
	t.Helper()
	res, err := Run(context.Background(), c, specs(), bars, strategy.NewScripted(steps))
	require.NoError(t, err)
	return res
}

func TestRoundTripFillsAtNextOpen(t *testing.T) {
	bars := []data.Bar{
		bar("BTCUSDT", 0, 100, 100, 100, 100),
		bar("BTCUSDT", 1, 101, 112, 100, 110), // buy fills at this open
		bar("BTCUSDT", 2, 110, 115, 109, 114),
		bar("BTCUSDT", 3, 120, 121, 119, 120), // sell fills at this open
	}
	res := run(t, cfg(), map[string][]data.Bar{"BTCUSDT": bars}, step(0, "BTCUSDT", money.RatioOne), step(2, "BTCUSDT", 0))

	require.Len(t, res.Fills, 2)
	buy, sell := res.Fills[0], res.Fills[1]
	require.Equal(t, Buy, buy.Side)
	require.Equal(t, t0.Add(time.Minute), buy.Time)
	require.Equal(t, "101.00000000", buy.RefPrice.String())
	require.Equal(t, "101.05050000", buy.Price.String(), "ref × 1.0005")
	require.Equal(t, "119.94000000", sell.Price.String(), "ref × 0.9995")

	require.Len(t, res.Trades, 1)
	tr := res.Trades[0]
	require.NotNil(t, tr.ClosedAt)
	require.Equal(t, tr.Gross.V-tr.Slippage.V-tr.Fees.V, tr.Net.V)
	require.Equal(t, tr.Fees.V, buy.FeeUSDT.V+sell.FeeUSDT.V)
	require.Equal(t, balanceOf(res, "USDT"), usdt(1000).V+tr.Net.V, "cash = capital + net")
	require.Zero(t, balanceOf(res, "BTC"))
	require.Equal(t, OutcomeFilled, res.Decisions[0].Outcome)
	require.Equal(t, OutcomeFilled, res.Decisions[1].Outcome)
	require.Len(t, res.Equity, 4)
}

func TestSpotOnlyAndValidation(t *testing.T) {
	bars := map[string][]data.Bar{"BTCUSDT": flat("BTCUSDT", 3, 100)}
	res := run(t, cfg(), bars,
		step(0, "BTCUSDT", -1),
		step(0, "BTCUSDT", money.RatioOne+1),
		step(0, "DOGEUSDT", money.RatioOne),
	)
	require.Empty(t, res.Fills)
	for _, d := range res.Decisions {
		require.Equal(t, OutcomeRejected, d.Outcome, d.Detail)
	}
	require.Contains(t, res.Decisions[0].Detail, "spot only")
	require.Contains(t, res.Decisions[1].Detail, "leverage")
}

func TestLatencyExpiryAndSupersede(t *testing.T) {
	bars := map[string][]data.Bar{"BTCUSDT": flat("BTCUSDT", 6, 100)}
	c := cfg()
	c.LatencyBars = 2
	res := run(t, c, bars, step(0, "BTCUSDT", money.RatioOne))
	require.Equal(t, t0.Add(2*time.Minute), res.Fills[0].Time, "two-bar latency")

	// Gap: the next bar comes 30 minutes later; the 10-minute TTL expires the intent.
	gapped := []data.Bar{bar("BTCUSDT", 0, 100, 100, 100, 100), bar("BTCUSDT", 30, 100, 100, 100, 100)}
	res = run(t, cfg(), map[string][]data.Bar{"BTCUSDT": gapped}, step(0, "BTCUSDT", money.RatioOne))
	require.Empty(t, res.Fills)
	require.Equal(t, OutcomeExpired, res.Decisions[0].Outcome)

	// A newer intent replaces a pending one.
	two := []strategy.Step{step(0, "BTCUSDT", money.RatioOne), {At: t0, Intent: strategy.Intent{Instrument: "BTCUSDT", Target: money.RatioOne / 2}}}
	res = run(t, cfg(), bars, two...)
	require.Equal(t, OutcomeSuperseded, res.Decisions[0].Outcome)
	require.Equal(t, OutcomeFilled, res.Decisions[1].Outcome)
}

func TestLateBarNeverFillsInThePast(t *testing.T) {
	// Bars 1..3 were backfilled and all became available at 00:05:00.
	bs := flat("BTCUSDT", 6, 100)
	for i := 1; i <= 3; i++ {
		bs[i].AvailableAt = t0.Add(5 * time.Minute)
	}
	bs[5].O = px(150e8)
	res := run(t, cfg(), map[string][]data.Bar{"BTCUSDT": bs}, step(1, "BTCUSDT", money.RatioOne))
	// Decided at 00:05:00. Bars 2-4 had closed by then (bar 4 exactly at 00:05:00),
	// so the first possible fill is bar 5's open.
	require.Equal(t, t0.Add(5*time.Minute), res.Fills[0].Time)
	require.Equal(t, "150.00000000", res.Fills[0].RefPrice.String())
}

type leaky struct{ calls int }

func (l *leaky) OnBar(ctx strategy.RunContext, b data.Bar) ([]strategy.Intent, error) {
	l.calls++
	h := ctx.History(b.Instrument)
	if h[len(h)-1].OpenTime != b.OpenTime {
		panic("history must end at the current bar")
	}
	if l.calls == 3 {
		_ = h[:len(h)+1] // try to peek at the next bar
	}
	return nil, nil
}

func TestStrategyCannotReadFutureBar(t *testing.T) {
	_, err := Run(context.Background(), cfg(), specs(), map[string][]data.Bar{"BTCUSDT": flat("BTCUSDT", 10, 100)}, &leaky{})
	require.ErrorIs(t, err, ErrStrategy)
	require.Contains(t, err.Error(), "out of range")
}

func TestDeterministic(t *testing.T) {
	bars := randomWalk("BTCUSDT", 500, 7)
	s1, err := strategy.New("trend-ema", strategy.Params{"fast": 5, "slow": 20})
	require.NoError(t, err)
	s2, err := strategy.New("trend-ema", strategy.Params{"fast": 5, "slow": 20})
	require.NoError(t, err)
	r1, err := Run(context.Background(), cfg(), specs(), map[string][]data.Bar{"BTCUSDT": bars}, s1)
	require.NoError(t, err)
	r2, err := Run(context.Background(), cfg(), specs(), map[string][]data.Bar{"BTCUSDT": bars}, s2)
	require.NoError(t, err)
	j1, _ := json.Marshal(r1)
	j2, _ := json.Marshal(r2)
	require.Equal(t, string(j1), string(j2))
	require.NotEmpty(t, r1.Trades, "the walk should produce crossings")
}

// randomWalk makes n valid bars from a seeded LCG (no math/rand: stable forever).
func randomWalk(sym string, n int, seed uint64) []data.Bar {
	x := seed
	next := func(m int64) int64 {
		x = x*6364136223846793005 + 1442695040888963407
		return int64(x>>33) % m
	}
	bs := make([]data.Bar, n)
	p := int64(100_00000000)
	for i := range bs {
		o := p
		c := max(1e6, o+next(2_00000000)-1_00000000)
		h := max(o, c) + next(50000000)
		l := max(1, min(o, c)-next(50000000))
		open := t0.Add(time.Duration(i) * time.Minute)
		bs[i] = data.Bar{Instrument: sym, OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute + delay),
			O: px(o), H: px(h), L: px(l), C: px(c), Volume: money.Qty{V: 1e8, Scale: 8}}
		p = c
	}
	return bs
}

// Plan M2 acceptance: for random intent sequences the ledger always reconciles
// and gross − fees − slippage = net exactly.
func TestLedgerReconcilesProperty(t *testing.T) {
	rapid.Check(t, func(rt *rapid.T) {
		n := rapid.IntRange(5, 80).Draw(rt, "bars")
		syms := []string{"BTCUSDT", "ETHUSDT"}
		bars := map[string][]data.Bar{}
		for k, s := range syms {
			bars[s] = randomWalk(s, n, rapid.Uint64().Draw(rt, "seed")+uint64(k))
		}
		var steps []strategy.Step
		for range rapid.IntRange(0, 30).Draw(rt, "steps") {
			steps = append(steps, strategy.Step{
				At: t0.Add(time.Duration(rapid.IntRange(0, n-1).Draw(rt, "at")) * time.Minute),
				Intent: strategy.Intent{
					Instrument: rapid.SampledFrom(syms).Draw(rt, "sym"),
					Target:     money.Ratio(rapid.Int64Range(-100_000, 1_100_000).Draw(rt, "target")),
					StopLoss:   money.Ratio(rapid.SampledFrom([]int64{0, 0, 5_000, 20_000}).Draw(rt, "stop")),
					TakeProfit: money.Ratio(rapid.SampledFrom([]int64{0, 0, 5_000, 20_000}).Draw(rt, "take")),
				},
			})
		}
		c := Config{
			Capital:  money.Amount{V: rapid.Int64Range(100e8, 1_000_000e8).Draw(rt, "capital"), Asset: instrument.USDT},
			FeeRate:  money.Ratio(rapid.Int64Range(0, 5_000).Draw(rt, "fee")),
			SlipRate: money.Ratio(rapid.Int64Range(0, 5_000).Draw(rt, "slip")),
		}
		res, err := Run(context.Background(), c, specs(), bars, strategy.NewScripted(steps))
		require.NoError(rt, err)

		// Replay every fill into fresh balances: must equal the final ledger.
		bal := map[string]int64{"USDT": c.Capital.V}
		for _, f := range res.Fills {
			sp := specs()[f.Instrument]
			require.GreaterOrEqual(rt, f.Slippage.V, int64(0))
			require.GreaterOrEqual(rt, f.Fee.V, int64(0))
			if f.Side == Buy {
				require.Equal(rt, f.Value.V-f.RefValue.V, f.Slippage.V)
				bal[sp.Quote.Code] -= f.Value.V + f.Fee.V
				bal[sp.Base.Code] += f.Qty.V
			} else {
				require.Equal(rt, f.RefValue.V-f.Value.V, f.Slippage.V)
				bal[sp.Quote.Code] += f.Value.V - f.Fee.V
				bal[sp.Base.Code] -= f.Qty.V
			}
			// USDT-quoted: the USDT columns equal the quote columns.
			require.Equal(rt, f.RefValue.V, f.RefValueUSDT.V)
			require.Equal(rt, f.Fee.V, f.FeeUSDT.V)
		}
		for _, b := range res.Balances {
			require.Equal(rt, bal[b.Asset], b.Amount.V, "replayed %s", b.Asset)
			require.GreaterOrEqual(rt, b.Amount.V, int64(0))
		}

		var cashFromTrades int64
		for _, tr := range res.Trades {
			require.Equal(rt, tr.Gross.V-tr.Slippage.V-tr.Fees.V, tr.Net.V, "trade identity")
			if tr.ClosedAt != nil {
				cashFromTrades += tr.Net.V
			}
		}

		// Final equity = cash + positions at last close, computed independently.
		want := bal["USDT"]
		for _, s := range syms {
			if q := bal[specs()[s].Base.Code]; q > 0 {
				last := bars[s][len(bars[s])-1].C.V
				v, err := money.MulScaled(q, 8, last, 8, 8, money.Floor)
				require.NoError(rt, err)
				want += v
			}
		}
		require.Equal(rt, want, res.FinalEquity.V)

		if len(res.Trades) > 0 && res.Trades[len(res.Trades)-1].ClosedAt != nil && allClosed(res) {
			require.Equal(rt, c.Capital.V+cashFromTrades, bal["USDT"], "all flat: cash = capital + Σ net")
		}
	})
}

func balanceOf(res *Result, asset string) int64 {
	for _, b := range res.Balances {
		if b.Asset == asset {
			return b.Amount.V
		}
	}
	return 0
}

func allClosed(res *Result) bool {
	for _, t := range res.Trades {
		if t.ClosedAt == nil {
			return false
		}
	}
	return true
}

func TestPositionCoinsAreNotFreeCash(t *testing.T) {
	bars := map[string][]data.Bar{
		"BTCUSDT": flat("BTCUSDT", 4, 50_000),
		"ETHBTC":  flat("ETHBTC", 4, 0), // replaced below: 0.05 BTC per ETH
	}
	for i := range bars["ETHBTC"] {
		b := &bars["ETHBTC"][i]
		b.O, b.H, b.L, b.C = px(5_000_000), px(5_000_000), px(5_000_000), px(5_000_000)
	}
	res := run(t, cfg(), bars, step(0, "BTCUSDT", money.RatioOne), step(1, "ETHBTC", money.RatioOne/2))
	require.Equal(t, OutcomeFilled, res.Decisions[0].Outcome)
	require.Equal(t, OutcomeRejected, res.Decisions[1].Outcome)
	require.Contains(t, res.Decisions[1].Detail, "insufficient free BTC")

	c := cfg()
	c.Holdings = []money.Amount{{V: 2_000_000, Asset: instrument.Asset("BTC")}} // 0.02 BTC
	res = run(t, c, bars, step(1, "ETHBTC", money.RatioOne/2))
	require.Equal(t, OutcomeFilled, res.Decisions[0].Outcome, res.Decisions[0].Detail)
	require.Positive(t, balanceOf(res, "ETH"))
}

// Plan M2.8 baseline: one strategy over 1M 1m bars.
// go test ./internal/sim -run '^$' -bench MillionBars -benchtime 1x -benchmem
func BenchmarkMillionBars(b *testing.B) {
	bars := map[string][]data.Bar{"BTCUSDT": randomWalk("BTCUSDT", 1_000_000, 42)}
	b.ReportAllocs()
	b.ResetTimer()
	for range b.N {
		s, err := strategy.New("trend-ema", strategy.Params{"fast": 12, "slow": 26})
		if err != nil {
			b.Fatal(err)
		}
		res, err := Run(context.Background(), cfg(), specs(), bars, s)
		if err != nil {
			b.Fatal(err)
		}
		b.ReportMetric(float64(len(res.Fills)), "fills")
	}
}

func TestCalcTradeMatchesRunAndBreakEven(t *testing.T) {
	c, err := CalcTrade(px(101e8), px(109e8), money.Qty{V: 988_615_000, Scale: 8}, 1000, 500, instrument.USDT)
	require.NoError(t, err)
	// Same numbers as the golden round-trip-fees scenario.
	require.Equal(t, "75.97510227 USDT", c.Net.String())
	require.Equal(t, "79.08920000 USDT", c.Gross.String())
	require.Equal(t, c.Gross.V-c.Slippage.V-c.Fees.V, c.Net.V)

	be, err := BreakEvenExit(px(100e8), 1000, 500)
	require.NoError(t, err)
	at, err := CalcTrade(px(100e8), be, money.Qty{V: 1e8, Scale: 8}, 1000, 500, instrument.USDT)
	require.NoError(t, err)
	require.InDelta(t, 0, at.Net.V, 3, "break-even exit nets ~0 (per-leg rounding)")
	below, err := CalcTrade(px(100e8), money.Price{V: be.V - 1e6, Scale: 8}, money.Qty{V: 1e8, Scale: 8}, 1000, 500, instrument.USDT)
	require.NoError(t, err)
	require.Negative(t, below.Net.V)

	_, err = CalcTrade(px(0), px(1), money.Qty{V: 1, Scale: 8}, 0, 0, instrument.USDT)
	require.ErrorIs(t, err, ErrInput)
}

func TestBreakEvenFee(t *testing.T) {
	bars := []data.Bar{
		bar("BTCUSDT", 0, 100, 100, 100, 100), bar("BTCUSDT", 1, 100, 100, 100, 100),
		bar("BTCUSDT", 2, 110, 110, 110, 110), bar("BTCUSDT", 3, 110, 110, 110, 110),
	}
	res := run(t, cfg(), map[string][]data.Bar{"BTCUSDT": bars}, step(0, "BTCUSDT", money.RatioOne), step(1, "BTCUSDT", 0))
	f, ok := BreakEvenFee(res)
	require.True(t, ok)
	c := cfg()
	c.FeeRate = f
	at := run(t, c, map[string][]data.Bar{"BTCUSDT": bars}, step(0, "BTCUSDT", money.RatioOne), step(1, "BTCUSDT", 0))
	require.InDelta(t, 0, at.Trades[0].Net.V, 1e6, "within 0.01 USDT of zero at the break-even fee")
	require.Greater(t, int64(f), int64(40_000), "~+10% gross covers ~4.7% per side")
}
