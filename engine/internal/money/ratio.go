package money

import "fmt"

// Ratio is a fixed-point fraction in parts per million: RatioOne = 1.0,
// 1 bps = 100. Used for fee and slippage rates and target exposure.
type Ratio int64

const RatioOne Ratio = 1_000_000

// ParseRatio reads a decimal fraction like "0.001" or "1" (at most 6 decimals).
func ParseRatio(s string) (Ratio, error) {
	v, err := Parse(s, 6)
	return Ratio(v), err
}

func (r Ratio) String() string { return Format(int64(r), 6) }

// Apply returns v × r, rounded with mode.
func (r Ratio) Apply(v int64, mode Rounding) (int64, error) {
	return MulDiv(v, int64(r), int64(RatioOne), mode)
}

// Plus returns v × (1 + r), rounded with mode (e.g. a buy price with slippage).
func (r Ratio) Plus(v int64, mode Rounding) (int64, error) {
	x, err := AddInt64(int64(RatioOne), int64(r))
	if err != nil {
		return 0, err
	}
	return MulDiv(v, x, int64(RatioOne), mode)
}

// Minus returns v × (1 − r), rounded with mode (e.g. a sell price with slippage).
func (r Ratio) Minus(v int64, mode Rounding) (int64, error) {
	if r > RatioOne {
		return 0, fmt.Errorf("money: ratio %s above 1", r)
	}
	x, err := SubInt64(int64(RatioOne), int64(r))
	if err != nil {
		return 0, err
	}
	return MulDiv(v, x, int64(RatioOne), mode)
}
