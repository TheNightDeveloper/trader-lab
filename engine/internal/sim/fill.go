package sim

import (
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
)

const sc = instrument.Scale // every price, qty and amount here is at scale 8

// leg is one fill's arithmetic in the quote asset. All integers, so the cost
// identities below hold exactly.
//
//	buy:  value = ceil(qty × price), price = ceil(ref × (1 + slip))
//	      slippage = value − refValue (refValue = ceil(qty × ref))
//	      fee = ceil(fee_rate × value);  cash out = value + fee
//	sell: value = floor(qty × price), price = floor(ref × (1 − slip))
//	      slippage = refValue − value (refValue = floor(qty × ref))
//	      fee = ceil(fee_rate × value);  cash in = value − fee
//
// Rounding is always against the trader: costs and fees up, proceeds down.
type leg struct {
	buy                       bool
	qty, ref, price           int64
	refValue, value, slippage int64
	fee                       int64
}

func newLeg(buy bool, ref, qty int64, slip, fee money.Ratio) (leg, error) {
	l := leg{buy: buy, qty: qty, ref: ref}
	var err error
	mode := money.Floor
	if buy {
		mode = money.Ceil
		l.price, err = slip.Plus(ref, money.Ceil)
	} else {
		l.price, err = slip.Minus(ref, money.Floor)
	}
	if err != nil {
		return leg{}, err
	}
	if l.refValue, err = money.MulScaled(qty, sc, ref, sc, sc, mode); err != nil {
		return leg{}, err
	}
	if l.value, err = money.MulScaled(qty, sc, l.price, sc, sc, mode); err != nil {
		return leg{}, err
	}
	l.slippage = l.value - l.refValue
	if !buy {
		l.slippage = -l.slippage
	}
	l.fee, err = fee.Apply(l.value, money.Ceil)
	return l, err
}

// cash is the signed change of the quote balance.
func (l leg) cash() int64 {
	if l.buy {
		return -(l.value + l.fee)
	}
	return l.value - l.fee
}

// affordableQty is the largest lot-rounded quantity whose buy leg (value + fee)
// fits in cash, capped at want.
func affordableQty(spec instrument.Spec, ref, want, cash int64, slip, fee money.Ratio) (int64, leg, error) {
	price, err := slip.Plus(ref, money.Ceil)
	if err != nil {
		return 0, leg{}, err
	}
	perUnit, err := fee.Plus(price, money.Ceil)
	if err != nil {
		return 0, leg{}, err
	}
	maxQty, err := money.MulDiv(cash, pow10sc, perUnit, money.Floor)
	if err != nil {
		return 0, leg{}, err
	}
	q := lotFloor(spec, min(want, maxQty))
	for q > 0 {
		l, err := newLeg(true, ref, q, slip, fee)
		if err != nil {
			return 0, leg{}, err
		}
		if l.value+l.fee <= cash {
			return q, l, nil
		}
		q -= spec.Lot.V // per-unit ceilings can overshoot by a few units
	}
	return 0, leg{}, nil
}

const pow10sc = 100_000_000

func lotFloor(spec instrument.Spec, q int64) int64 {
	if q <= 0 {
		return 0
	}
	return q / spec.Lot.V * spec.Lot.V
}
