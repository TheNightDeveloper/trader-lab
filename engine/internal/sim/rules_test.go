package sim

import (
	"encoding/json"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/strategy"
)

func TestRuleDefinitionTradesThroughSimulator(t *testing.T) {
	var d strategy.RuleDefinition
	require.NoError(t, json.Unmarshal([]byte(`{
		"format":"rules/v1", "exposure":"0.5",
		"entry":{"op":"and","args":[
			{"op":"gt","left":{"kind":"close"},"right":{"kind":"constant","number":102}},
			{"op":"gt","left":{"kind":"sma","period":2},"right":{"kind":"constant","number":101}}
		]},
		"exit":{"op":"or","args":[
			{"op":"lt","left":{"kind":"close"},"right":{"kind":"constant","number":100}},
			{"op":"cross_below","left":{"kind":"close"},"right":{"kind":"sma","period":2}}
		]}
	}`), &d))
	c := cfg()
	c.LatencyBars = 2
	const sym = "BTCUSDT"
	var bars []data.Bar
	for i, price := range []int64{100, 104, 108, 112, 108, 99, 98, 98} {
		bars = append(bars, bar(sym, i, price, price, price, price))
	}
	s, err := d.Build()
	require.NoError(t, err)
	res, err := Run(t.Context(), c, specs(), map[string][]data.Bar{sym: bars}, s)
	require.NoError(t, err)
	require.Len(t, res.Decisions, 2)
	require.Equal(t, bars[2].AvailableAt, res.Decisions[0].At)
	require.Equal(t, bars[4].AvailableAt, res.Decisions[1].At, "the exit wins while entry still matches")
	require.Len(t, res.Fills, 2)
	require.Equal(t, Buy, res.Fills[0].Side)
	require.Equal(t, bars[4].OpenTime, res.Fills[0].Time, "a persistent entry does not supersede its pending order")
	require.Equal(t, Sell, res.Fills[1].Side)
	require.Equal(t, bars[6].OpenTime, res.Fills[1].Time)

	// Definitions can be rebuilt for isolated simulations with identical results.
	again, err := d.Build()
	require.NoError(t, err)
	replayed, err := Run(t.Context(), c, specs(), map[string][]data.Bar{sym: bars}, again)
	require.NoError(t, err)
	require.Equal(t, res, replayed)
}

func TestRulesWaitForAvailableHistory(t *testing.T) {
	var d strategy.RuleDefinition
	require.NoError(t, json.Unmarshal([]byte(`{
		"format":"rules/v1", "exposure":"0.5",
		"entry":{"op":"gt","left":{"kind":"sma","period":3},"right":{"kind":"constant","number":102}},
		"exit":{"op":"lt","left":{"kind":"close"},"right":{"kind":"constant","number":90}}
	}`), &d))
	const sym = "BTCUSDT"
	var bars []data.Bar
	for i, price := range []int64{100, 101, 110, 109, 109, 109} {
		bars = append(bars, bar(sym, i, price, price, price, price))
	}
	// The old bar completes the lookback after bar 2. Only bar 3 may use it.
	bars[0].AvailableAt = bars[2].AvailableAt.Add(20 * time.Second)
	s, err := d.Build()
	require.NoError(t, err)
	res, err := Run(t.Context(), cfg(), specs(), map[string][]data.Bar{sym: bars}, s)
	require.NoError(t, err)
	require.Len(t, res.Decisions, 1)
	require.Equal(t, bars[3].AvailableAt, res.Decisions[0].At)
	require.Equal(t, bars[3].OpenTime, res.Decisions[0].InputBarOpen)
}
