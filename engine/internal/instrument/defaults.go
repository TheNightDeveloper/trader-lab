package instrument

import "tradinglab/engine/internal/money"

// Scale is used for every coin amount, price and quantity: Binance spot reports
// all of them with 8 decimals, so storing at 8 keeps archive values exact.
const Scale = 8

func Asset(code string) money.Asset { return money.Asset{Code: code, Scale: Scale} }

var USDT = Asset("USDT")

func newSpec(symbol, base, quote string, tick, lot, minNotional int64) Spec {
	return Spec{
		Symbol: symbol, Base: Asset(base), Quote: Asset(quote),
		Tick:        money.Price{V: tick, Scale: Scale},
		Lot:         money.Qty{V: lot, Scale: Scale},
		MinNotional: money.Amount{V: minNotional, Asset: Asset(quote)},
	}
}

// Defaults is the v1 registry, from Binance exchangeInfo filters (PRICE_FILTER
// tickSize, LOT_SIZE stepSize, NOTIONAL minNotional) on 2026-10-27.
// Values are at Scale 8: 0.01 = 1_000_000.
func Defaults() []Spec {
	return []Spec{
		newSpec("BTCUSDT", "BTC", "USDT", 1_000_000, 1_000, 5e8),
		newSpec("ETHUSDT", "ETH", "USDT", 1_000_000, 10_000, 5e8),
		newSpec("SOLUSDT", "SOL", "USDT", 1_000_000, 100_000, 5e8),
		newSpec("BNBUSDT", "BNB", "USDT", 1_000_000, 100_000, 5e8),
		newSpec("XRPUSDT", "XRP", "USDT", 10_000, 10_000_000, 5e8),
		newSpec("ETHBTC", "ETH", "BTC", 1_000, 10_000, 10_000),
	}
}
