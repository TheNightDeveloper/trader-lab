// Package fx values amounts in USDT using only rates available at the as-of time,
// and converts USDT to TOMAN for display. TOMAN never flows back into research.
package fx

import (
	"context"
	"errors"
	"fmt"
	"time"

	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
)

var ErrNoRate = errors.New("fx: no rate available")

// Toman is display-only. 1 TOMAN = 10 IRR; shown in whole units.
var Toman = money.Asset{Code: "TOMAN", Scale: 0}

// RateSource returns the close of the last bar of symbol with AvailableAt <= asOf.
// Returns ErrNoRate if there is none.
type RateSource interface {
	LastClose(ctx context.Context, symbol string, asOf time.Time) (money.Price, error)
}

// ToUSDT values a in USDT through the <ASSET>USDT pair at asOf.
func ToUSDT(ctx context.Context, src RateSource, a money.Amount, asOf time.Time, mode money.Rounding) (money.Amount, error) {
	if a.Asset == instrument.USDT {
		return a, nil
	}
	symbol := a.Asset.Code + "USDT"
	p, err := src.LastClose(ctx, symbol, asOf)
	if err != nil {
		return money.Amount{}, fmt.Errorf("value %s at %s: %w", a.Asset.Code, asOf.Format(time.RFC3339), err)
	}
	v, err := money.MulScaled(a.V, a.Asset.Scale, p.V, p.Scale, instrument.USDT.Scale, mode)
	return money.Amount{V: v, Asset: instrument.USDT}, err
}

// PositionUSDT values qty of spec's base asset in USDT: first in the quote asset at
// the pair's own last close, then quote → USDT. ETHBTC goes ETH → BTC → USDT, using
// ETHBTC and BTCUSDT closes that were both available at asOf.
func PositionUSDT(ctx context.Context, src RateSource, spec instrument.Spec, qty money.Qty, asOf time.Time, mode money.Rounding) (money.Amount, error) {
	p, err := src.LastClose(ctx, spec.Symbol, asOf)
	if err != nil {
		return money.Amount{}, fmt.Errorf("value %s at %s: %w", spec.Symbol, asOf.Format(time.RFC3339), err)
	}
	inQuote, err := money.Notional(p, qty, spec.Quote, mode)
	if err != nil {
		return money.Amount{}, err
	}
	return ToUSDT(ctx, src, inQuote, asOf, mode)
}

// Rate is one stored USDT/TOMAN display rate.
type Rate struct {
	ID           int64
	Date         time.Time
	TomanPerUSDT money.Price
	Source       string
}

// ToToman converts a USDT amount for display, rounded half-even to whole TOMAN.
func ToToman(usdt money.Amount, r Rate) (money.Amount, error) {
	if usdt.Asset != instrument.USDT {
		return money.Amount{}, fmt.Errorf("%w: toman display needs USDT, got %s", money.ErrAssetMismatch, usdt.Asset.Code)
	}
	v, err := money.MulScaled(usdt.V, usdt.Asset.Scale, r.TomanPerUSDT.V, r.TomanPerUSDT.Scale, Toman.Scale, money.HalfEven)
	return money.Amount{V: v, Asset: Toman}, err
}
