// Package strategy defines what a strategy may see (only the past) and say
// (intents, never exchange orders), plus the baseline strategies.
package strategy

import (
	"errors"
	"fmt"
	"slices"
	"strings"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

var ErrUnknown = errors.New("strategy: unknown")

// Intent is a strategy's wish for one instrument; the simulator decides whether
// and how it becomes a fill.
type Intent struct {
	Instrument string
	// Target exposure as a fraction of equity: 0 = flat, RatioOne = all in.
	// Negative (short) or above one (leverage) is rejected: spot only.
	Target money.Ratio
	// Optional exits relative to the fill price; 0 = none.
	StopLoss, TakeProfit money.Ratio
	Reason               string
	ModelID              string
	RecipeVersion        string
}

// RunContext is everything a strategy may read. Every bar it returns was
// available at Now; nothing later exists in it.
type RunContext interface {
	// History returns the bars of symbol seen so far, oldest first. The slice's
	// capacity equals its length: reslicing past the end panics.
	History(symbol string) []data.Bar
	// Position is the current holding of symbol's base asset.
	Position(symbol string) money.Qty
}

// Strategy is called once per bar, in availability order, on one goroutine.
type Strategy interface {
	OnBar(ctx RunContext, b data.Bar) ([]Intent, error)
}

// Params are numeric strategy parameters (searchable in M4).
type Params map[string]float64

// Names lists the registered strategies.
func Names() []string {
	names := make([]string, 0, len(registry))
	for n := range registry {
		names = append(names, n)
	}
	slices.Sort(names)
	return names
}

// New builds a registered strategy. Unknown parameters are an error, so a typo
// never silently falls back to a default.
func New(name string, p Params) (Strategy, error) {
	f, ok := registry[name]
	if !ok {
		return nil, fmt.Errorf("%w %q (have %s)", ErrUnknown, name, strings.Join(Names(), ", "))
	}
	return f(p)
}

var registry = map[string]func(Params) (Strategy, error){
	"hold-cash":      func(p Params) (Strategy, error) { return holdCash{}, p.only() },
	"buy-and-hold":   newBuyAndHold,
	"trend-ema":      newTrendEMA,
	"mean-rev-bands": newMeanRevBands,
}

// ParamSpec describes one tunable parameter: defaults for the UI and the
// neighbourhood stability check (M3) and search space bounds (M4).
type ParamSpec struct {
	Name    string  `json:"name"`
	Default float64 `json:"default"`
	Integer bool    `json:"integer"`
}

// ParamSpecs lists a strategy's parameters in their natural order.
var ParamSpecs = map[string][]ParamSpec{
	"hold-cash":      nil,
	"buy-and-hold":   {{"exposure", 1, false}},
	"trend-ema":      {{"fast", 12, true}, {"slow", 26, true}, {"exposure", 1, false}},
	"mean-rev-bands": {{"period", 20, true}, {"k", 2, false}, {"exposure", 1, false}},
}

// WithDefaults fills in every parameter of name that p does not set.
func WithDefaults(name string, p Params) Params {
	out := Params{}
	for _, s := range ParamSpecs[name] {
		out[s.Name] = s.Default
	}
	for k, v := range p {
		out[k] = v
	}
	return out
}

// get returns p[key] or def; only() later rejects anything not read.
func (p Params) only(keys ...string) error {
	for k := range p {
		if !slices.Contains(keys, k) {
			return fmt.Errorf("strategy: unknown parameter %q", k)
		}
	}
	return nil
}

func (p Params) get(key string, def float64) float64 {
	if v, ok := p[key]; ok {
		return v
	}
	return def
}

// exposure reads the "exposure" parameter (fraction of equity, default 1).
func (p Params) exposure() (money.Ratio, error) {
	e := p.get("exposure", 1)
	if e <= 0 || e > 1 {
		return 0, fmt.Errorf("strategy: exposure %v must be in (0, 1]", e)
	}
	return money.Ratio(e*float64(money.RatioOne) + 0.5), nil
}

func (p Params) period(key string, def float64) (int, error) {
	v := p.get(key, def)
	if v < 1 || v != float64(int(v)) {
		return 0, fmt.Errorf("strategy: %s %v must be a positive whole number", key, v)
	}
	return int(v), nil
}

// closeF converts a fixed-point close to float64 for indicator math only.
// The explicit conversion keeps results identical across platforms (no fused
// multiply-add across this boundary).
func closeF(b data.Bar) float64 { return float64(b.C.V) / 1e8 }
