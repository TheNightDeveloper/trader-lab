// Package instrument describes spot pairs and the exchange's rounding rules for them.
package instrument

import (
	"errors"
	"fmt"

	"tradinglab/engine/internal/money"
)

var (
	ErrBelowMinNotional = errors.New("instrument: below min notional")
	ErrZeroQty          = errors.New("instrument: quantity rounds to zero")
	ErrScaleMismatch    = errors.New("instrument: value scale differs from spec")
)

// Spec is one spot pair. Tick and Lot are expressed at PriceScale and QtyScale.
type Spec struct {
	Symbol      string // e.g. "BTCUSDT"
	Base, Quote money.Asset
	Tick        money.Price // smallest price step
	Lot         money.Qty   // smallest quantity step
	MinNotional money.Amount
}

func (s Spec) Validate() error {
	switch {
	case s.Symbol == "" || s.Base.Code == "" || s.Quote.Code == "":
		return fmt.Errorf("instrument %q: missing symbol or asset", s.Symbol)
	case s.Tick.V <= 0 || s.Lot.V <= 0:
		return fmt.Errorf("instrument %q: tick and lot must be positive", s.Symbol)
	case s.Lot.Scale > s.Base.Scale:
		return fmt.Errorf("instrument %q: lot scale %d exceeds %s scale %d", s.Symbol, s.Lot.Scale, s.Base.Code, s.Base.Scale)
	case s.MinNotional.Asset != s.Quote:
		return fmt.Errorf("instrument %q: min notional must be in %s", s.Symbol, s.Quote.Code)
	}
	return nil
}

// RoundPrice snaps p to a multiple of Tick with mode.
func (s Spec) RoundPrice(p money.Price, mode money.Rounding) (money.Price, error) {
	if p.Scale != s.Tick.Scale {
		return money.Price{}, fmt.Errorf("%w: price scale %d, tick scale %d", ErrScaleMismatch, p.Scale, s.Tick.Scale)
	}
	n, err := money.MulDiv(p.V, 1, s.Tick.V, mode)
	if err != nil {
		return money.Price{}, err
	}
	v, err := money.MulDiv(n, s.Tick.V, 1, mode)
	return money.Price{V: v, Scale: p.Scale}, err
}

// RoundQty snaps q down to a multiple of Lot; spot orders never round size up.
func (s Spec) RoundQty(q money.Qty) (money.Qty, error) {
	if q.Scale != s.Lot.Scale {
		return money.Qty{}, fmt.Errorf("%w: qty scale %d, lot scale %d", ErrScaleMismatch, q.Scale, s.Lot.Scale)
	}
	v := q.V / s.Lot.V * s.Lot.V // truncation toward zero; quantities are non-negative
	if v == 0 {
		return money.Qty{}, ErrZeroQty
	}
	return money.Qty{V: v, Scale: q.Scale}, nil
}

// CheckNotional rejects orders whose price × qty is below MinNotional.
func (s Spec) CheckNotional(p money.Price, q money.Qty) error {
	n, err := money.Notional(p, q, s.Quote, money.Floor)
	if err != nil {
		return err
	}
	if n.V < s.MinNotional.V {
		return fmt.Errorf("%w: %s < %s", ErrBelowMinNotional, n, s.MinNotional)
	}
	return nil
}
