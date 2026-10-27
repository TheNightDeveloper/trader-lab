package api

import (
	"fmt"
	"strconv"
	"time"

	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
)

// Domain ↔ proto. Money always crosses as exact strings; parsing never rounds.

func moneyP(a money.Amount) *labv1.Money {
	return &labv1.Money{Units: strconv.FormatInt(a.V, 10), Scale: a.Asset.Scale, Asset: a.Asset.Code}
}

func usdtP(v int64) *labv1.Money { return moneyP(money.Amount{V: v, Asset: instrument.USDT}) }

func decP(v int64, scale int32) *labv1.Decimal {
	return &labv1.Decimal{Units: strconv.FormatInt(v, 10), Scale: scale}
}

func ratioP(r money.Ratio) *labv1.Decimal { return decP(int64(r), 6) }

func ms(t time.Time) int64 { return t.UnixMilli() }

func windowP(w eval.Window) *labv1.Window {
	return &labv1.Window{FromUnixMs: ms(w.From), ToUnixMs: ms(w.To)}
}

func metricP(m metrics.Metric) *labv1.Metric {
	d := metrics.Definitions[m.Key]
	return &labv1.Metric{
		Key: m.Key, Group: m.Group, Value: decP(m.V, m.Scale), Unit: string(m.Unit),
		Valid: m.Valid, Invalid: m.Invalid, Label: d.Label, Definition: d.Definition,
	}
}

func metricsP(ms []metrics.Metric) []*labv1.Metric {
	out := make([]*labv1.Metric, len(ms))
	for i, m := range ms {
		out[i] = metricP(m)
	}
	return out
}

func equityP(pts []eval.EquityPoint) []*labv1.EquityPoint {
	out := make([]*labv1.EquityPoint, len(pts))
	for i, p := range pts {
		out[i] = &labv1.EquityPoint{TUnixMs: ms(p.T), Equity: moneyP(p.Equity)}
	}
	return out
}

func runViewP(v eval.RunView) *labv1.RunView {
	return &labv1.RunView{Window: windowP(v.Window), Metrics: metricsP(v.Metrics), Equity: equityP(v.Equity), AmbiguousBars: int32(v.AmbiguousBars)}
}

// scaled reads a proto fixed-point value at exactly scale `to` (fewer decimals are
// widened; more is an error, never a rounding).
func scaled(units string, scale, to int32) (int64, error) {
	v, err := strconv.ParseInt(units, 10, 64)
	if err != nil {
		return 0, fmt.Errorf("number %q: %w", units, err)
	}
	if scale > to {
		return 0, fmt.Errorf("at most %d decimals", to)
	}
	return money.Rescale(v, scale, to, money.Floor)
}

// usdtIn reads a USDT amount; unset → ok=false.
func usdtIn(m *labv1.Money, field string) (money.Amount, bool, error) {
	if m == nil || m.GetUnits() == "" {
		return money.Amount{}, false, nil
	}
	if m.GetAsset() != "" && m.GetAsset() != "USDT" {
		return money.Amount{}, false, fmt.Errorf("%s: must be USDT", field)
	}
	v, err := scaled(m.GetUnits(), m.GetScale(), instrument.Scale)
	if err != nil {
		return money.Amount{}, false, fmt.Errorf("%s: %w", field, err)
	}
	return money.Amount{V: v, Asset: instrument.USDT}, true, nil
}

// ratioIn reads a fraction (scale ≤ 6); unset → ok=false.
func ratioIn(d *labv1.Decimal, field string) (money.Ratio, bool, error) {
	if d == nil || d.GetUnits() == "" {
		return 0, false, nil
	}
	v, err := scaled(d.GetUnits(), d.GetScale(), 6)
	if err != nil {
		return 0, false, fmt.Errorf("%s: %w", field, err)
	}
	return money.Ratio(v), true, nil
}
