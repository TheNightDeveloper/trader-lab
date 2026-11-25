// Package paper defines fixed-point spot simulation and account risk rules.
package paper

import (
	"errors"

	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
)

const scale = instrument.Scale

var (
	ErrLevels = errors.New("paper: entry, stop and target are incompatible")
	ErrBudget = errors.New("paper: minimum lot or notional exceeds risk or available funds")
	ErrCost   = errors.New("paper: estimated cost exceeds policy or absorbs target proceeds")
)

type Costs struct {
	Fee, Slippage money.Ratio
}

type Leg struct {
	Price, Notional, Fee, Cash int64 // Cash is positive, paid for a buy or received for a sell.
}

// Fill applies adverse price, tick, notional and fee rounding for simulated fills.
func (c Costs) Fill(spec instrument.Spec, buy bool, ref, qty int64) (Leg, error) {
	if ref <= 0 || qty < 0 || c.Fee < 0 || c.Fee >= money.RatioOne || c.Slippage < 0 || c.Slippage >= money.RatioOne {
		return Leg{}, ErrLevels
	}
	mode := money.Floor
	price, err := c.Slippage.Minus(ref, mode)
	if buy {
		mode = money.Ceil
		price, err = c.Slippage.Plus(ref, mode)
	}
	if err != nil {
		return Leg{}, err
	}
	priceTick, err := spec.RoundPrice(money.Price{V: price, Scale: scale}, mode)
	if err != nil || priceTick.V <= 0 {
		return Leg{}, errors.Join(ErrLevels, err)
	}
	return c.atPrice(buy, priceTick.V, qty)
}

func (c Costs) atPrice(buy bool, price, qty int64) (Leg, error) {
	mode := money.Floor
	if buy {
		mode = money.Ceil
	}
	notional, err := money.MulScaled(price, scale, qty, scale, scale, mode)
	if err != nil {
		return Leg{}, err
	}
	fee, err := c.Fee.Apply(notional, money.Ceil)
	if err != nil {
		return Leg{}, err
	}
	change := -fee
	if buy {
		change = fee
	}
	cash, err := money.AddInt64(notional, change)
	return Leg{Price: price, Notional: notional, Fee: fee, Cash: cash}, err
}

type PlanInput struct {
	Reference, EntryLimit, Stop, TakeProfit int64
	Cash, NotionalBudget, LossBudget        int64
	MaxCost                                 money.Ratio
}

type PlanSize struct {
	Quantity, EntryPrice, Notional, ReservedCash, PlannedLoss, EstimatedCost int64
}

// SizePlan caps quantity against cash, exposure and net loss at the adverse entry limit.
func SizePlan(spec instrument.Spec, costs Costs, in PlanInput) (PlanSize, error) {
	if err := spec.Validate(); err != nil {
		return PlanSize{}, err
	}
	if in.Stop <= 0 || in.Stop >= in.Reference || in.EntryLimit < in.Reference || in.TakeProfit <= in.EntryLimit ||
		in.Stop%spec.Tick.V != 0 || in.TakeProfit%spec.Tick.V != 0 || in.EntryLimit%spec.Tick.V != 0 {
		return PlanSize{}, ErrLevels
	}
	if in.Cash <= 0 || in.NotionalBudget <= 0 || in.LossBudget <= 0 {
		return PlanSize{}, ErrBudget
	}
	estimate, err := costs.Fill(spec, true, in.Reference, 0)
	if err != nil {
		return PlanSize{}, err
	}
	if estimate.Price > in.EntryLimit {
		return PlanSize{}, ErrLevels
	}
	high, err := money.MulDiv(min(in.Cash, in.NotionalBudget), 100_000_000, in.EntryLimit, money.Floor)
	if err != nil {
		return PlanSize{}, err
	}
	var out PlanSize
	low := int64(1)
	for high /= spec.Lot.V; low <= high; {
		mid := low + (high-low)/2
		qty := mid * spec.Lot.V
		maxEntry, err := costs.atPrice(true, in.EntryLimit, qty)
		if err != nil {
			return PlanSize{}, err
		}
		stop, err := costs.Fill(spec, false, in.Stop, qty)
		if err != nil {
			return PlanSize{}, err
		}
		loss := maxEntry.Cash - stop.Cash
		if maxEntry.Cash > in.Cash || maxEntry.Notional > in.NotionalBudget || loss > in.LossBudget {
			high = mid - 1
			continue
		}
		out = PlanSize{Quantity: qty, EntryPrice: estimate.Price, ReservedCash: maxEntry.Cash, PlannedLoss: loss}
		if mid == high {
			break
		}
		low = mid + 1
	}
	if out.Quantity == 0 {
		return PlanSize{}, ErrBudget
	}
	entry, err := costs.atPrice(true, out.EntryPrice, out.Quantity)
	if err != nil {
		return PlanSize{}, err
	}
	if entry.Notional < spec.MinNotional.V {
		return PlanSize{}, ErrBudget
	}
	target, err := costs.Fill(spec, false, in.TakeProfit, out.Quantity)
	if err != nil {
		return PlanSize{}, err
	}
	if target.Cash <= out.ReservedCash {
		return PlanSize{}, ErrCost
	}
	// Compare simulated target proceeds to the same quantity at raw reference prices.
	rawEntry, err := (Costs{}).atPrice(true, in.Reference, out.Quantity)
	if err != nil {
		return PlanSize{}, err
	}
	rawTarget, err := (Costs{}).atPrice(false, in.TakeProfit, out.Quantity)
	if err != nil {
		return PlanSize{}, err
	}
	out.EstimatedCost, err = money.AddInt64(entry.Cash-rawEntry.Cash, rawTarget.Cash-target.Cash)
	if err != nil {
		return PlanSize{}, err
	}
	cap, err := in.MaxCost.Apply(rawEntry.Notional, money.Floor)
	if err != nil {
		return PlanSize{}, err
	}
	if out.EstimatedCost > cap {
		return PlanSize{}, ErrCost
	}
	out.Notional = entry.Notional
	return out, nil
}
