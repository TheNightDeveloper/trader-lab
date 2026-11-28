package sim

import (
	"context"
	"math"
	"testing"

	"github.com/stretchr/testify/require"
	"tradinglab/engine/internal/clock"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/strategy"
)

func TestBuyLegRejectsCostBeyondInt64(t *testing.T) {
	// Notional and fee fit individually. Together they cannot be debited.
	_, err := newLeg(true, math.MaxInt64-1, pow10sc, 0, 1000)
	require.ErrorIs(t, err, money.ErrOverflow)
	l, err := newLeg(true, math.MaxInt64, pow10sc, 0, 0)
	require.NoError(t, err, "the exact representable boundary still works")
	require.EqualValues(t, -math.MaxInt64, l.cash)
}

func TestTradeCalculatorRejectsOverflowingCombinedFees(t *testing.T) {
	// The entry cost fits, but the sum of both fees exceeds int64.
	entry := px(5_650_000_000_000_000_000)
	exit := px(9_220_000_000_000_000_000)
	c, err := CalcTrade(entry, exit, money.Qty{V: pow10sc, Scale: sc}, 625_000, 0, instrument.USDT)
	require.ErrorIs(t, err, money.ErrOverflow)
	require.Zero(t, c)
}

func TestSimulationDiscardsOverflowingLedger(t *testing.T) {
	capital := money.Amount{V: math.MaxInt64 - pow10sc, Asset: instrument.USDT}
	t.Run("marked equity", func(t *testing.T) {
		c := Config{Capital: capital, Holdings: []money.Amount{{V: pow10sc, Asset: instrument.Asset("BTC")}}}
		res, err := Run(context.Background(), c, specs(), map[string][]data.Bar{"BTCUSDT": flat("BTCUSDT", 2, 5)}, strategy.NewScripted(nil))
		require.ErrorIs(t, err, money.ErrOverflow)
		require.Nil(t, res)
	})
	t.Run("lifetime turnover", func(t *testing.T) {
		// Two buys and a partial sale keep equity in range, but lifetime
		// acquisition cost and quantity no longer fit the trade record.
		steps := []strategy.Step{step(0, "BTCUSDT", 500_000), step(2, "BTCUSDT", 250_000), step(4, "BTCUSDT", money.RatioOne)}
		res, err := Run(context.Background(), Config{Capital: capital}, specs(), map[string][]data.Bar{"BTCUSDT": flat("BTCUSDT", 8, 1)}, strategy.NewScripted(steps))
		require.ErrorIs(t, err, money.ErrOverflow)
		require.Nil(t, res)
	})
	t.Run("take-profit price", func(t *testing.T) {
		enter := step(0, "BTCUSDT", money.RatioOne)
		enter.Intent.TakeProfit = 200_000
		bs := flat("BTCUSDT", 4, 80_000_000_000)
		res, err := Run(context.Background(), Config{Capital: capital}, specs(), map[string][]data.Bar{"BTCUSDT": bs}, strategy.NewScripted([]strategy.Step{enter}))
		require.ErrorIs(t, err, money.ErrOverflow)
		require.Nil(t, res)
	})
}

func TestAccumulatedFillOverflowLeavesLedgerUntouched(t *testing.T) {
	p := &position{qty: pow10sc, trade: 0}
	trade := Trade{Instrument: "BTCUSDT", Qty: money.Qty{V: math.MaxInt64 - pow10sc + 1, Scale: sc}}
	r := runner{specs: specs(), clk: clock.NewVirtual(t0), pos: map[string]*position{"BTCUSDT": p},
		bal: map[string]int64{"BTC": pow10sc, "USDT": pow10sc}, res: &Result{Trades: []Trade{trade}}}
	l, err := newLeg(true, pow10sc, pow10sc, 0, 0)
	require.NoError(t, err)
	err = r.apply("BTCUSDT", l, pow10sc, t0, "signal", 1, false)
	require.ErrorIs(t, err, money.ErrOverflow)
	require.EqualValues(t, pow10sc, p.qty)
	require.Equal(t, map[string]int64{"BTC": pow10sc, "USDT": pow10sc}, r.bal)
	require.Equal(t, trade, r.res.Trades[0])
	require.Empty(t, r.res.Fills)
}

func TestBreakEvenFeeDoesNotUseWrappedTurnover(t *testing.T) {
	fill := Fill{Side: Buy, RefValueUSDT: money.Amount{V: 6_000_000_000_000_000_000, Asset: instrument.USDT}}
	r := &Result{Trades: []Trade{{Gross: money.Amount{V: 1_000_000_000_000_000_000, Asset: instrument.USDT}}},
		Fills: []Fill{fill, fill, fill, fill}}
	fee, ok := BreakEvenFee(r)
	require.False(t, ok)
	require.Zero(t, fee)
}
