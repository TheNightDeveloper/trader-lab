package money

import (
	"fmt"
	"strconv"
	"strings"
)

// JSON forms are exact decimal strings, for golden files, stored specs and exports:
// Amount "-12.50000000 USDT", Price/Qty "65432.10000000", Ratio "0.001000".
// Decoding infers the scale from the number of decimals, so it is the exact
// inverse of encoding.

func (a Amount) MarshalJSON() ([]byte, error) { return []byte(strconv.Quote(a.String())), nil }
func (p Price) MarshalJSON() ([]byte, error)  { return []byte(strconv.Quote(p.String())), nil }
func (q Qty) MarshalJSON() ([]byte, error)    { return []byte(strconv.Quote(q.String())), nil }
func (r Ratio) MarshalJSON() ([]byte, error)  { return []byte(strconv.Quote(r.String())), nil }

func (a *Amount) UnmarshalJSON(b []byte) error {
	s, err := strconv.Unquote(string(b))
	if err != nil {
		return fmt.Errorf("%w: amount %s", ErrParse, b)
	}
	num, code, ok := strings.Cut(s, " ")
	if !ok || code == "" {
		return fmt.Errorf("%w: amount %q needs \"<decimal> <ASSET>\"", ErrParse, s)
	}
	v, scale, err := parseInferred(num)
	*a = Amount{V: v, Asset: Asset{Code: code, Scale: scale}}
	return err
}

func (p *Price) UnmarshalJSON(b []byte) error {
	v, scale, err := unquoteInferred(b)
	*p = Price{V: v, Scale: scale}
	return err
}

func (q *Qty) UnmarshalJSON(b []byte) error {
	v, scale, err := unquoteInferred(b)
	*q = Qty{V: v, Scale: scale}
	return err
}

func (r *Ratio) UnmarshalJSON(b []byte) error {
	s, err := strconv.Unquote(string(b))
	if err != nil {
		return fmt.Errorf("%w: ratio %s", ErrParse, b)
	}
	v, err := ParseRatio(s)
	*r = v
	return err
}

func unquoteInferred(b []byte) (int64, int32, error) {
	s, err := strconv.Unquote(string(b))
	if err != nil {
		return 0, 0, fmt.Errorf("%w: %s", ErrParse, b)
	}
	return parseInferred(s)
}

func parseInferred(s string) (int64, int32, error) {
	scale := int32(0)
	if _, frac, ok := strings.Cut(s, "."); ok {
		scale = int32(len(frac))
	}
	v, err := Parse(s, scale)
	return v, scale, err
}
