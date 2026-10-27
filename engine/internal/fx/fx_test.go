package fx

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
)

type closeAt struct {
	availableAt time.Time
	close       money.Price
}

// memSource is an as-of rate source over in-memory closes, sorted by availability.
type memSource map[string][]closeAt

func (m memSource) LastClose(_ context.Context, symbol string, asOf time.Time) (money.Price, error) {
	var p *money.Price
	for _, c := range m[symbol] {
		if c.availableAt.After(asOf) {
			break
		}
		p = &c.close
	}
	if p == nil {
		return money.Price{}, ErrNoRate
	}
	return *p, nil
}

func px(units int64) money.Price { return money.Price{V: units, Scale: 8} }

func spec(symbol string) instrument.Spec {
	for _, s := range instrument.Defaults() {
		if s.Symbol == symbol {
			return s
		}
	}
	panic(symbol)
}

func TestETHBTCValuedWithRatesAvailableAtTheTime(t *testing.T) {
	t0 := time.Date(2024, 1, 1, 0, 1, 2, 0, time.UTC) // available time of the 00:00 bars
	src := memSource{
		"ETHBTC": {
			{t0, px(5_000_000)},                  // 0.05 BTC per ETH
			{t0.Add(time.Minute), px(6_000_000)}, // 0.06
		},
		"BTCUSDT": {
			{t0, px(4_000_000_000_000)},                  // 40,000
			{t0.Add(time.Minute), px(5_000_000_000_000)}, // 50,000
		},
	}
	ctx := context.Background()
	qty := money.Qty{V: 2e8, Scale: 8} // 2 ETH

	// Just before the second bars become available: 2 × 0.05 × 40,000 = 4,000 USDT.
	v, err := PositionUSDT(ctx, src, spec("ETHBTC"), qty, t0.Add(time.Minute-time.Nanosecond), money.Floor)
	require.NoError(t, err)
	require.Equal(t, "4000.00000000 USDT", v.String())

	// Exactly when they are available: 2 × 0.06 × 50,000 = 6,000 USDT.
	v, err = PositionUSDT(ctx, src, spec("ETHBTC"), qty, t0.Add(time.Minute), money.Floor)
	require.NoError(t, err)
	require.Equal(t, "6000.00000000 USDT", v.String())

	// Before any rate exists there is no value, not a zero.
	_, err = PositionUSDT(ctx, src, spec("ETHBTC"), qty, t0.Add(-time.Second), money.Floor)
	require.ErrorIs(t, err, ErrNoRate)
}

func TestToUSDTIdentityAndMissingPair(t *testing.T) {
	ctx := context.Background()
	a := money.Amount{V: 123, Asset: instrument.USDT}
	got, err := ToUSDT(ctx, memSource{}, a, time.Now(), money.Floor)
	require.NoError(t, err)
	require.Equal(t, a, got)
	_, err = ToUSDT(ctx, memSource{}, money.Amount{V: 1, Asset: instrument.Asset("DOGE")}, time.Now(), money.Floor)
	require.ErrorIs(t, err, ErrNoRate)
}

func TestToToman(t *testing.T) {
	r := Rate{ID: 7, TomanPerUSDT: money.Price{V: 6_543_210, Scale: 2}}          // 65,432.10
	got, err := ToToman(money.Amount{V: 150_000_000, Asset: instrument.USDT}, r) // 1.5 USDT
	require.NoError(t, err)
	require.Equal(t, "98148 TOMAN", got.String()) // 98,148.15 → 98,148
	neg, err := ToToman(money.Amount{V: -150_000_000, Asset: instrument.USDT}, r)
	require.NoError(t, err)
	require.Equal(t, int64(-98148), neg.V)
	_, err = ToToman(money.Amount{V: 1, Asset: instrument.Asset("BTC")}, r)
	require.ErrorIs(t, err, money.ErrAssetMismatch)
}
