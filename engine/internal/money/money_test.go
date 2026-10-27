package money

import (
	"encoding/json"
	"errors"
	"flag"
	"math"
	"math/big"
	"os"
	"testing"

	"github.com/stretchr/testify/require"
	"pgregory.net/rapid"
)

func TestMain(m *testing.M) {
	flag.Parse()
	// Plan M0 acceptance: money properties hold for 10k cases. -rapid.checks overrides.
	if f := flag.Lookup("rapid.checks"); f != nil && f.Value.String() == "100" {
		_ = flag.Set("rapid.checks", "10000")
	}
	os.Exit(m.Run())
}

var usdt = Asset{"USDT", 8}

// oracle computes v×num/den with exact big-int rounding; ok=false if outside int64.
func oracle(v, num, den int64, mode Rounding) (int64, bool) {
	n := new(big.Int).Mul(big.NewInt(v), big.NewInt(num))
	d := big.NewInt(den)
	if d.Sign() < 0 {
		n.Neg(n)
		d.Neg(d)
	}
	q, r := new(big.Int), new(big.Int)
	q.DivMod(n, d, r) // Euclidean: r >= 0, so q is floor
	if r.Sign() != 0 {
		switch mode {
		case Ceil:
			q.Add(q, big.NewInt(1))
		case HalfEven:
			c := new(big.Int).Lsh(r, 1).Cmp(d)
			if c > 0 || c == 0 && q.Bit(0) == 1 {
				q.Add(q, big.NewInt(1))
			}
		}
	}
	if !q.IsInt64() {
		return 0, false
	}
	return q.Int64(), true
}

var modes = rapid.SampledFrom([]Rounding{Floor, Ceil, HalfEven})

func TestMulDivMatchesBigInt(t *testing.T) {
	rapid.Check(t, func(t *rapid.T) {
		v, num := rapid.Int64().Draw(t, "v"), rapid.Int64().Draw(t, "num")
		den := rapid.Int64().Filter(func(d int64) bool { return d != 0 }).Draw(t, "den")
		mode := modes.Draw(t, "mode")
		got, err := MulDiv(v, num, den, mode)
		want, ok := oracle(v, num, den, mode)
		if !ok {
			require.ErrorIs(t, err, ErrOverflow)
			return
		}
		require.NoError(t, err)
		require.Equal(t, want, got)
	})
}

func TestMulDivRealisticRanges(t *testing.T) {
	// Same oracle, but magnitudes where results rarely overflow, so rounding is exercised.
	rapid.Check(t, func(t *rapid.T) {
		v := rapid.Int64Range(-1e12, 1e12).Draw(t, "v")
		num := rapid.Int64Range(-1e6, 1e6).Draw(t, "num")
		den := rapid.Int64Range(1, 1e9).Draw(t, "den")
		mode := modes.Draw(t, "mode")
		got, err := MulDiv(v, num, den, mode)
		want, ok := oracle(v, num, den, mode)
		require.True(t, ok)
		require.NoError(t, err)
		require.Equal(t, want, got)
	})
}

func TestAddSub(t *testing.T) {
	rapid.Check(t, func(t *rapid.T) {
		a := Amount{rapid.Int64().Draw(t, "a"), usdt}
		b := Amount{rapid.Int64().Draw(t, "b"), usdt}
		s, err := a.Add(b)
		exact := new(big.Int).Add(big.NewInt(a.V), big.NewInt(b.V))
		if !exact.IsInt64() {
			require.ErrorIs(t, err, ErrOverflow)
			return
		}
		require.NoError(t, err)
		require.Equal(t, exact.Int64(), s.V)
		ba, err := b.Add(a)
		require.NoError(t, err)
		require.Equal(t, s, ba, "commutative")
		back, err := s.Sub(b)
		require.NoError(t, err)
		require.Equal(t, a, back, "sub undoes add")
	})
}

func TestAssetMismatch(t *testing.T) {
	_, err := Amount{1, usdt}.Add(Amount{1, Asset{"BTC", 8}})
	require.ErrorIs(t, err, ErrAssetMismatch)
	_, err = Amount{1, usdt}.Add(Amount{1, Asset{"USDT", 2}})
	require.ErrorIs(t, err, ErrAssetMismatch, "same code, different scale")
}

func TestRescaleRoundTrip(t *testing.T) {
	rapid.Check(t, func(t *rapid.T) {
		from := int32(rapid.IntRange(0, 10).Draw(t, "from"))
		up := int32(rapid.IntRange(0, 8).Draw(t, "up"))
		v := rapid.Int64Range(-1e10, 1e10).Draw(t, "v")
		mode := modes.Draw(t, "mode")
		hi, err := Rescale(v, from, from+up, mode)
		require.NoError(t, err)
		lo, err := Rescale(hi, from+up, from, mode)
		require.NoError(t, err)
		require.Equal(t, v, lo)
	})
}

func TestRescaleDownBrackets(t *testing.T) {
	rapid.Check(t, func(t *rapid.T) {
		v := rapid.Int64().Draw(t, "v")
		down := int32(rapid.IntRange(1, 18).Draw(t, "down"))
		f, err := Rescale(v, 18, 18-down, Floor)
		require.NoError(t, err)
		c, err := Rescale(v, 18, 18-down, Ceil)
		require.NoError(t, err)
		h, err := Rescale(v, 18, 18-down, HalfEven)
		require.NoError(t, err)
		require.LessOrEqual(t, c-f, int64(1))
		require.True(t, h == f || h == c)
	})
}

func TestHalfEvenTies(t *testing.T) {
	for _, tc := range []struct{ v, want int64 }{
		{25, 2}, {35, 4}, {-25, -2}, {-35, -4}, {26, 3}, {-26, -3}, {24, 2},
	} {
		got, err := Rescale(tc.v, 1, 0, HalfEven)
		require.NoError(t, err)
		require.Equal(t, tc.want, got, "v=%d", tc.v)
	}
}

func TestFormatParseRoundTrip(t *testing.T) {
	rapid.Check(t, func(t *rapid.T) {
		v := rapid.Int64().Draw(t, "v")
		scale := int32(rapid.IntRange(0, MaxScale).Draw(t, "scale"))
		got, err := Parse(Format(v, scale), scale)
		require.NoError(t, err)
		require.Equal(t, v, got)
	})
}

func TestParse(t *testing.T) {
	for _, tc := range []struct {
		in    string
		scale int32
		want  int64
		err   error
	}{
		{"1.5", 2, 150, nil},
		{"-0.05", 2, -5, nil},
		{"+.5", 1, 5, nil},
		{"0", 8, 0, nil},
		{"000.00", 2, 0, nil},
		{"9223372036854775807", 0, math.MaxInt64, nil},
		{"-9223372036854775808", 0, math.MinInt64, nil},
		{"9223372036854775808", 0, 0, ErrOverflow},
		{"1.005", 2, 0, ErrParse},
		{"1.", 2, 0, ErrParse},
		{"", 2, 0, ErrParse},
		{"-", 2, 0, ErrParse},
		{"1e3", 2, 0, ErrParse},
		{"1,000", 2, 0, ErrParse},
	} {
		got, err := Parse(tc.in, tc.scale)
		if tc.err != nil {
			require.True(t, errors.Is(err, tc.err), "%q: got %v", tc.in, err)
			continue
		}
		require.NoError(t, err, tc.in)
		require.Equal(t, tc.want, got, tc.in)
	}
}

func TestFormat(t *testing.T) {
	require.Equal(t, "0.05", Format(5, 2))
	require.Equal(t, "-0.05", Format(-5, 2))
	require.Equal(t, "120", Format(120, 0))
	require.Equal(t, "-92233720368.54775808", Format(math.MinInt64, 8))
	require.Equal(t, "-12.50000000 USDT", Amount{-1_250_000_000, usdt}.String())
}

// Realistic magnitudes from the plan: no overflow at plausible extremes.
func TestRealisticMagnitudes(t *testing.T) {
	toman := Asset{"TOMAN", 0}

	// 1e9 USDT (8 decimals) at 200,000.00 TOMAN/USDT → 2e14 TOMAN.
	usdtV := int64(1e9) * 1e8
	rate := Price{20_000_000, 2}
	tv, err := MulScaled(usdtV, usdt.Scale, rate.V, rate.Scale, toman.Scale, HalfEven)
	require.NoError(t, err)
	require.Equal(t, int64(2e14), tv)

	// USDT at scale 8 caps near 92e9 USDT. 10k BTC at 1,000,000.00 = 1e10 USDT fits;
	// 100k BTC (1e11 USDT) must fail loudly, not wrap.
	n, err := Notional(Price{1e8, 2}, Qty{1e4 * 1e8, 8}, usdt, Floor)
	require.NoError(t, err)
	require.Equal(t, int64(1e18), n.V)
	_, err = Notional(Price{1e8, 2}, Qty{1e5 * 1e8, 8}, usdt, Floor)
	require.ErrorIs(t, err, ErrOverflow)

	// 100 BTC at 65,432.10 USDT = 6,543,210 USDT exactly.
	n, err = Notional(Price{6_543_210, 2}, Qty{100e8, 8}, usdt, Floor)
	require.NoError(t, err)
	require.Equal(t, "6543210.00000000 USDT", n.String())
}

func TestNotionalRounding(t *testing.T) {
	// 0.00012345 BTC × 65,432.17 = 8.0776013865 USDT → floor 8.07760138, ceil 8.07760139.
	p, q := Price{6_543_217, 2}, Qty{12_345, 8}
	f, err := Notional(p, q, usdt, Floor)
	require.NoError(t, err)
	c, err := Notional(p, q, usdt, Ceil)
	require.NoError(t, err)
	require.Equal(t, int64(807_760_138), f.V)
	require.Equal(t, int64(807_760_139), c.V)

	// Output scale above input scale multiplies.
	v, err := MulScaled(3, 0, 2, 0, 4, Floor)
	require.NoError(t, err)
	require.Equal(t, int64(60_000), v)
}

func TestJSONRoundTrip(t *testing.T) {
	rapid.Check(t, func(t *rapid.T) {
		scale := int32(rapid.IntRange(0, 12).Draw(t, "scale"))
		a := Amount{V: rapid.Int64().Draw(t, "v"), Asset: Asset{"USDT", scale}}
		r := Ratio(rapid.Int64Range(-2_000_000, 2_000_000).Draw(t, "r"))
		in := struct {
			A Amount
			P Price
			R Ratio
		}{a, Price{a.V, scale}, r}
		b, err := json.Marshal(in)
		require.NoError(t, err)
		var out struct {
			A Amount
			P Price
			R Ratio
		}
		require.NoError(t, json.Unmarshal(b, &out))
		require.Equal(t, in.A, out.A)
		require.Equal(t, in.P, out.P)
		require.Equal(t, in.R, out.R)
	})
	var a Amount
	require.Error(t, json.Unmarshal([]byte(`"12.5"`), &a), "asset required")
}
