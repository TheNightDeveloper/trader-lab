// Package money is fixed-point arithmetic for accounting. Every value is an int64
// count of 10^-scale units; every operation is checked for overflow; every lossy
// step takes an explicit rounding mode. No float64 anywhere.
package money

import (
	"errors"
	"fmt"
	"math"
	"math/bits"
	"strconv"
	"strings"
)

var (
	ErrOverflow      = errors.New("money: overflow")
	ErrAssetMismatch = errors.New("money: asset mismatch")
	ErrScale         = errors.New("money: scale out of range")
	ErrDivZero       = errors.New("money: division by zero")
	ErrParse         = errors.New("money: parse error")
)

// MaxScale bounds every scale so that 10^scale fits in int64.
const MaxScale = 18

// Rounding selects how a lossy step resolves the remainder.
type Rounding int

const (
	Floor    Rounding = iota // toward −∞
	Ceil                     // toward +∞
	HalfEven                 // nearest, ties to even (banker's)
)

// Asset identifies a currency or coin and the number of decimals its amounts carry.
// Asset is comparable; two amounts may be combined only when their Assets are equal.
type Asset struct {
	Code  string
	Scale int32
}

// Amount is a quantity of one asset: V × 10^-Asset.Scale.
type Amount struct {
	V     int64
	Asset Asset
}

func (a Amount) Add(b Amount) (Amount, error) {
	if a.Asset != b.Asset {
		return Amount{}, fmt.Errorf("%w: %s + %s", ErrAssetMismatch, a.Asset.Code, b.Asset.Code)
	}
	s, err := add(a.V, b.V)
	return Amount{s, a.Asset}, err
}

func (a Amount) Sub(b Amount) (Amount, error) {
	if a.Asset != b.Asset {
		return Amount{}, fmt.Errorf("%w: %s - %s", ErrAssetMismatch, a.Asset.Code, b.Asset.Code)
	}
	d := a.V - b.V
	if (b.V > 0 && d > a.V) || (b.V < 0 && d < a.V) {
		return Amount{}, ErrOverflow
	}
	return Amount{d, a.Asset}, nil
}

func (a Amount) Neg() (Amount, error) {
	if a.V == math.MinInt64 {
		return Amount{}, ErrOverflow
	}
	return Amount{-a.V, a.Asset}, nil
}

func (a Amount) Sign() int {
	switch {
	case a.V > 0:
		return 1
	case a.V < 0:
		return -1
	}
	return 0
}

// String renders "<decimal> <code>", e.g. "-12.50000000 USDT". For logs and golden files.
func (a Amount) String() string { return Format(a.V, a.Asset.Scale) + " " + a.Asset.Code }

// Rescale converts v from one scale to another. Increasing the scale is exact (or
// overflows); decreasing it rounds with mode.
func Rescale(v int64, from, to int32, mode Rounding) (int64, error) {
	if from < 0 || from > MaxScale || to < 0 || to > MaxScale {
		return 0, ErrScale
	}
	if to >= from {
		return MulDiv(v, pow10[to-from], 1, mode)
	}
	return MulDiv(v, 1, pow10[from-to], mode)
}

// MulDiv returns v×num/den rounded with mode. The product is computed in 128 bits,
// so only a final result outside int64 overflows. This is the single primitive for
// price×qty, fee rates, and FX conversion.
func MulDiv(v, num, den int64, mode Rounding) (int64, error) {
	if den == 0 {
		return 0, ErrDivZero
	}
	neg := (v < 0) != (num < 0) != (den < 0)
	hi, lo := bits.Mul64(abs(v), abs(num))
	d := abs(den)
	if hi >= d {
		return 0, ErrOverflow
	}
	q, r := bits.Div64(hi, lo, d)
	if r != 0 {
		// Round the magnitude; direction depends on the sign of the true result.
		up := false
		switch mode {
		case Floor:
			up = neg
		case Ceil:
			up = !neg
		case HalfEven:
			// Compare 2r with d without overflowing: r >= d-r.
			switch {
			case r > d-r:
				up = true
			case r == d-r:
				up = q&1 == 1
			}
		}
		if up {
			q++
			if q == 0 {
				return 0, ErrOverflow
			}
		}
	}
	if neg {
		if q > 1<<63 {
			return 0, ErrOverflow
		}
		return int64(-q), nil // -q wraps correctly for q == 1<<63
	}
	if q > math.MaxInt64 {
		return 0, ErrOverflow
	}
	return int64(q), nil
}

// Format renders v at scale as a plain decimal string ("-0.05", "120").
func Format(v int64, scale int32) string {
	s := strconv.FormatUint(abs(v), 10)
	sign := ""
	if v < 0 {
		sign = "-"
	}
	if scale <= 0 {
		return sign + s
	}
	if n := int(scale) + 1 - len(s); n > 0 {
		s = strings.Repeat("0", n) + s
	}
	cut := len(s) - int(scale)
	return sign + s[:cut] + "." + s[cut:]
}

// Parse reads a plain decimal string at the given scale. More fractional digits than
// the scale is an error, never a silent rounding.
func Parse(s string, scale int32) (int64, error) {
	if scale < 0 || scale > MaxScale {
		return 0, ErrScale
	}
	in := s
	neg := false
	if s != "" && (s[0] == '-' || s[0] == '+') {
		neg = s[0] == '-'
		s = s[1:]
	}
	intPart, frac, hasDot := strings.Cut(s, ".")
	if intPart == "" && frac == "" || hasDot && frac == "" || len(frac) > int(scale) || !digits(intPart) || !digits(frac) {
		return 0, fmt.Errorf("%w: %q at scale %d", ErrParse, in, scale)
	}
	frac += strings.Repeat("0", int(scale)-len(frac))
	var u uint64
	if t := strings.TrimLeft(intPart+frac, "0"); t != "" {
		var err error
		if u, err = strconv.ParseUint(t, 10, 64); err != nil {
			return 0, fmt.Errorf("%w: %q", ErrOverflow, in)
		}
	}
	if neg {
		if u > 1<<63 {
			return 0, fmt.Errorf("%w: %q", ErrOverflow, in)
		}
		return int64(-u), nil
	}
	if u > math.MaxInt64 {
		return 0, fmt.Errorf("%w: %q", ErrOverflow, in)
	}
	return int64(u), nil
}

func digits(s string) bool {
	for i := 0; i < len(s); i++ {
		if s[i] < '0' || s[i] > '9' {
			return false
		}
	}
	return true
}

func add(a, b int64) (int64, error) {
	s := a + b
	if (s > a) != (b > 0) {
		return 0, ErrOverflow
	}
	return s, nil
}

func abs(v int64) uint64 {
	if v < 0 {
		return uint64(-(v + 1)) + 1
	}
	return uint64(v)
}

var pow10 = func() (p [MaxScale + 1]int64) {
	p[0] = 1
	for i := 1; i <= MaxScale; i++ {
		p[i] = p[i-1] * 10
	}
	return
}()
