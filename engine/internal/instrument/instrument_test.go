package instrument

import (
	"testing"

	"github.com/stretchr/testify/require"
	"pgregory.net/rapid"

	"tradinglab/engine/internal/money"
)

var (
	btc  = money.Asset{Code: "BTC", Scale: 8}
	usdt = money.Asset{Code: "USDT", Scale: 8}
	spec = Spec{
		Symbol: "BTCUSDT", Base: btc, Quote: usdt,
		Tick:        money.Price{V: 1, Scale: 2},       // 0.01
		Lot:         money.Qty{V: 1, Scale: 5},         // 0.00001
		MinNotional: money.Amount{V: 5e8, Asset: usdt}, // 5 USDT
	}
)

func TestValidate(t *testing.T) {
	require.NoError(t, spec.Validate())
	bad := spec
	bad.Lot = money.Qty{V: 1, Scale: 9}
	require.Error(t, bad.Validate())
	bad = spec
	bad.MinNotional.Asset = btc
	require.Error(t, bad.Validate())
}

func TestRoundPrice(t *testing.T) {
	s := spec
	s.Tick = money.Price{V: 50, Scale: 2} // 0.50 tick
	for _, tc := range []struct {
		in, floor, ceil int64
	}{
		{10_025, 10_000, 10_050},
		{10_050, 10_050, 10_050},
		{10_001, 10_000, 10_050},
	} {
		f, err := s.RoundPrice(money.Price{V: tc.in, Scale: 2}, money.Floor)
		require.NoError(t, err)
		c, err := s.RoundPrice(money.Price{V: tc.in, Scale: 2}, money.Ceil)
		require.NoError(t, err)
		require.Equal(t, tc.floor, f.V, "floor %d", tc.in)
		require.Equal(t, tc.ceil, c.V, "ceil %d", tc.in)
	}
	_, err := s.RoundPrice(money.Price{V: 1, Scale: 3}, money.Floor)
	require.ErrorIs(t, err, ErrScaleMismatch)
}

func TestRoundQtyNeverRoundsUp(t *testing.T) {
	rapid.Check(t, func(t *rapid.T) {
		s := spec
		s.Lot = money.Qty{V: rapid.Int64Range(1, 1000).Draw(t, "lot"), Scale: 5}
		q := money.Qty{V: rapid.Int64Range(0, 1e12).Draw(t, "q"), Scale: 5}
		r, err := s.RoundQty(q)
		if q.V < s.Lot.V {
			require.ErrorIs(t, err, ErrZeroQty)
			return
		}
		require.NoError(t, err)
		require.LessOrEqual(t, r.V, q.V)
		require.Less(t, q.V-r.V, s.Lot.V)
		require.Zero(t, r.V%s.Lot.V)
	})
}

func TestCheckNotional(t *testing.T) {
	p := money.Price{V: 5_000_000, Scale: 2}                                                  // 50,000.00
	require.NoError(t, spec.CheckNotional(p, money.Qty{V: 10, Scale: 5}))                     // 5.00 USDT
	require.ErrorIs(t, spec.CheckNotional(p, money.Qty{V: 9, Scale: 5}), ErrBelowMinNotional) // 4.50
}

func TestDefaultsValid(t *testing.T) {
	seen := map[string]bool{}
	for _, s := range Defaults() {
		require.NoError(t, s.Validate(), s.Symbol)
		require.False(t, seen[s.Symbol], "duplicate %s", s.Symbol)
		seen[s.Symbol] = true
		// Tick must be representable at the shared price scale.
		_, err := s.RoundPrice(money.Price{V: 6_543_210_000_000, Scale: Scale}, money.Floor)
		require.NoError(t, err, s.Symbol)
	}
	require.Len(t, seen, 6)
}
