package sim

import (
	"fmt"

	"tradinglab/engine/internal/money"
)

// LegView is one side of a calculated trade (quote asset).
type LegView struct {
	RefPrice money.Price  `json:"ref_price"`
	Price    money.Price  `json:"price"`
	RefValue money.Amount `json:"ref_value"`
	Value    money.Amount `json:"value"`
	Slippage money.Amount `json:"slippage"`
	Fee      money.Amount `json:"fee"`
}

// TradeCalc is the single-trade calculator: the simulator's own leg math, so the
// calculator and reports can never disagree.
type TradeCalc struct {
	Buy           LegView      `json:"buy"`
	Sell          LegView      `json:"sell"`
	Gross         money.Amount `json:"gross"`
	Slippage      money.Amount `json:"slippage"`
	Fees          money.Amount `json:"fees"`
	Net           money.Amount `json:"net"`
	Cost          money.Amount `json:"cost"`            // buy value + buy fee
	Return        money.Ratio  `json:"return"`          // net / cost
	BreakEvenExit money.Price  `json:"break_even_exit"` // exit reference price where net ≈ 0
}

// CalcTrade buys qty at entry and sells it at exit (reference prices, quote asset
// at scale 8, quantity at scale 8).
func CalcTrade(entry, exit money.Price, qty money.Qty, fee, slip money.Ratio, quote money.Asset) (TradeCalc, error) {
	if entry.Scale != sc || exit.Scale != sc || qty.Scale != sc || quote.Scale != sc {
		return TradeCalc{}, fmt.Errorf("%w: prices, quantity and quote must be at scale 8", ErrInput)
	}
	if entry.V <= 0 || exit.V <= 0 || qty.V <= 0 {
		return TradeCalc{}, fmt.Errorf("%w: prices and quantity must be positive", ErrInput)
	}
	b, err := newLeg(true, entry.V, qty.V, slip, fee)
	if err != nil {
		return TradeCalc{}, err
	}
	s, err := newLeg(false, exit.V, qty.V, slip, fee)
	if err != nil {
		return TradeCalc{}, err
	}
	a := func(v int64) money.Amount { return money.Amount{V: v, Asset: quote} }
	view := func(l leg) LegView {
		return LegView{
			RefPrice: money.Price{V: l.ref, Scale: sc}, Price: money.Price{V: l.price, Scale: sc},
			RefValue: a(l.refValue), Value: a(l.value), Slippage: a(l.slippage), Fee: a(l.fee),
		}
	}
	c := TradeCalc{Buy: view(b), Sell: view(s)}
	c.Gross = a(s.refValue - b.refValue)
	c.Slippage = a(b.slippage + s.slippage)
	c.Fees = a(b.fee + s.fee)
	c.Net = a(s.cash() + b.cash())
	c.Cost = a(b.value + b.fee)
	if c.Net.V != c.Gross.V-c.Slippage.V-c.Fees.V {
		return TradeCalc{}, fmt.Errorf("%w: calculator identity", ErrInvariant)
	}
	r, err := money.MulDiv(c.Net.V, int64(money.RatioOne), c.Cost.V, money.HalfEven)
	if err != nil {
		return TradeCalc{}, err
	}
	c.Return = money.Ratio(r)
	c.BreakEvenExit, err = BreakEvenExit(entry, fee, slip)
	return c, err
}

// BreakEvenExit is the exit reference price at which a round trip nets zero:
// entry × (1 + s)(1 + f) / ((1 − s)(1 − f)), rounded up. (The buy fee is charged
// on top in the quote asset, the sell fee out of proceeds; per-leg rounding can
// leave the net a few units from zero.)
func BreakEvenExit(entry money.Price, fee, slip money.Ratio) (money.Price, error) {
	one := int64(money.RatioOne)
	x, err := money.MulDiv(entry.V, one+int64(slip), one-int64(slip), money.Ceil)
	if err != nil {
		return money.Price{}, err
	}
	x, err = money.MulDiv(x, one+int64(fee), one-int64(fee), money.Ceil)
	return money.Price{V: x, Scale: entry.Scale}, err
}

// BreakEvenFee is the per-side fee rate at which the run's net P&L would be zero,
// holding its trades and slippage fixed: (gross − slippage) / Σ leg values (USDT).
// ok=false when no fee level makes it profitable (gross − slippage ≤ 0) or there
// were no fills.
func BreakEvenFee(r *Result) (money.Ratio, bool) {
	var gross, slip, values int64
	for _, t := range r.Trades {
		gross += t.Gross.V
		slip += t.Slippage.V
	}
	for _, f := range r.Fills {
		v := f.RefValueUSDT.V + f.SlippageUSDT.V // buy value
		if f.Side == Sell {
			v = f.RefValueUSDT.V - f.SlippageUSDT.V
		}
		values += v
	}
	if values <= 0 || gross-slip <= 0 {
		return 0, false
	}
	x, err := money.MulDiv(gross-slip, int64(money.RatioOne), values, money.Floor)
	if err != nil {
		return 0, false
	}
	return money.Ratio(x), true
}
