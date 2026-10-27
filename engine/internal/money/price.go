package money

// Price is quote units per one base unit: V × 10^-Scale.
type Price struct {
	V     int64
	Scale int32
}

// Qty is a base-asset quantity: V × 10^-Scale.
type Qty struct {
	V     int64
	Scale int32
}

func (p Price) String() string { return Format(p.V, p.Scale) }
func (q Qty) String() string   { return Format(q.V, q.Scale) }

// MulScaled returns (a×10^-sa)×(b×10^-sb) expressed at scale out, rounded with mode.
func MulScaled(a int64, sa int32, b int64, sb int32, out int32, mode Rounding) (int64, error) {
	if sa < 0 || sb < 0 || out < 0 || out > MaxScale {
		return 0, ErrScale
	}
	e := sa + sb - out
	switch {
	case e > MaxScale:
		return 0, ErrScale
	case e >= 0:
		return MulDiv(a, b, pow10[e], mode)
	default:
		p, err := MulDiv(a, b, 1, mode)
		if err != nil {
			return 0, err
		}
		return MulDiv(p, pow10[-e], 1, mode)
	}
}

// Notional is price × qty in the quote asset.
func Notional(p Price, q Qty, quote Asset, mode Rounding) (Amount, error) {
	v, err := MulScaled(p.V, p.Scale, q.V, q.Scale, quote.Scale, mode)
	return Amount{v, quote}, err
}
