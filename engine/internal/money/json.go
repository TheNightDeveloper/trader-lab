package money

import "strconv"

// JSON forms are exact decimal strings, for golden files and exports:
// Amount "-12.50000000 USDT", Price/Qty "65432.10000000", Ratio "0.001000".

func (a Amount) MarshalJSON() ([]byte, error) { return []byte(strconv.Quote(a.String())), nil }
func (p Price) MarshalJSON() ([]byte, error)  { return []byte(strconv.Quote(p.String())), nil }
func (q Qty) MarshalJSON() ([]byte, error)    { return []byte(strconv.Quote(q.String())), nil }
func (r Ratio) MarshalJSON() ([]byte, error)  { return []byte(strconv.Quote(r.String())), nil }
