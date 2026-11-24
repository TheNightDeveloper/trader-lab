package strategy

import (
	"encoding/json"
	"strings"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

const ruleFixture = `{
  "format": "rules/v1", "exposure": "0.5",
  "entry": {"op":"gt", "left":{"kind":"close"}, "right":{"kind":"constant","number":0}},
  "exit": {"op":"lt", "left":{"kind":"close"}, "right":{"kind":"sma","period":3}}
}`

func TestRuleDefinitionContentHash(t *testing.T) {
	var d RuleDefinition
	require.NoError(t, json.Unmarshal([]byte(ruleFixture), &d))
	first, err := d.ContentHash()
	require.NoError(t, err)
	require.Regexp(t, `^sha256:[0-9a-f]{64}$`, first)

	// Formatting and alternate JSON spellings of the same number have no identity.
	b, err := json.Marshal(d)
	require.NoError(t, err)
	require.NoError(t, json.Unmarshal([]byte(strings.Replace(string(b), `"number":0`, `"number":0e0`, 1)), &d))
	same, err := d.ContentHash()
	require.NoError(t, err)
	require.Equal(t, first, same)

	d.Exit.Right.Period++
	changed, err := d.ContentHash()
	require.NoError(t, err)
	require.NotEqual(t, first, changed)
}

func TestRuleDefinitionRejectsUnsupportedInput(t *testing.T) {
	for _, tt := range []struct{ name, from, to string }{
		{"version", "rules/v1", "rules/v2"},
		{"operator", `"gt"`, `"eval"`},
		{"operand", `"close"`, `"future"`},
		{"invalid shape", `"kind":"close"`, `"kind":"close","period":2`},
		{"unknown field", `"kind":"close"`, `"kind":"close","timeframe":"1h"`},
		{"bucket requires base", `"kind":"close"`, `"kind":"bucket_close","timeframe":"1h"`},
		{"oversized lookback", `"period":3`, `"period":1001`},
		{"missing constant", `,"number":0`, ``},
		{"overflowing constant", `"number":0`, `"number":1e999`},
		{"oversized payload", "\n", strings.Repeat(" ", 1<<16)},
		{"leverage", `"0.5"`, `"1.000001"`},
	} {
		t.Run(tt.name, func(t *testing.T) {
			var d RuleDefinition
			require.Error(t, json.Unmarshal([]byte(strings.Replace(ruleFixture, tt.from, tt.to, 1)), &d))
		})
	}

	var d RuleDefinition
	require.NoError(t, json.Unmarshal([]byte(ruleFixture), &d))
	leaf := d.Entry
	d.Entry = Rule{Op: "and", Args: make([]Rule, 64)}
	for i := range d.Entry.Args {
		d.Entry.Args[i] = leaf
	}
	_, err := d.Build()
	require.ErrorContains(t, err, "node limit")

	// A malformed Go caller can share slices recursively even though JSON cannot.
	children := make([]Rule, 2)
	d.Entry = Rule{Op: "or", Args: children}
	children[0], children[1] = d.Entry, leaf
	_, err = d.ContentHash()
	require.ErrorContains(t, err, "depth limit")
}

// Simulated history grows by one candle for each decision, just as in the evaluator.
type ruleHistory []data.Bar

func (h ruleHistory) History(string) []data.Bar { return h }
func (h ruleHistory) Position(string) money.Qty { return money.Qty{} }

func TestRuleRegimeRoutesClosedBarsAndKeepsExitOwner(t *testing.T) {
	comparison := func(op string, value float64) Rule {
		return Rule{Op: op, Left: &RuleValue{Kind: "close"}, Right: &RuleValue{Kind: "constant", Number: &value}}
	}
	a := RuleDefinition{Format: RuleFormatV1, Exposure: money.RatioOne / 2, Entry: comparison("gt", 11), Exit: comparison("lt", 8)}
	b := RuleDefinition{Format: RuleFormatV1, Exposure: money.RatioOne / 4, Entry: comparison("gt", 8), Exit: comparison("lt", 11.5)}
	_, err := ComposeRegimeRules(a, b, 1, "a")
	require.Error(t, err)
	combined, err := ComposeRegimeRules(a, b, 2, "a")
	require.NoError(t, err)
	encoded, err := json.Marshal(combined)
	require.NoError(t, err)
	var stored RuleDefinition
	require.NoError(t, json.Unmarshal(encoded, &stored))
	s, err := stored.Build()
	require.NoError(t, err)
	var history ruleHistory
	for i, price := range []int64{10, 12, 11, 7, 6, 10, 9} {
		at := time.Unix(int64(i)*60, 0)
		bar := data.Bar{Instrument: "BTCUSDT", OpenTime: at, CloseTime: at.Add(time.Minute), C: money.Price{V: price * 1e8, Scale: 8}}
		history = append(history, bar)
		intents, err := s.OnBar(history, bar)
		require.NoError(t, err)
		switch i {
		case 1:
			require.Equal(t, []Intent{{Instrument: bar.Instrument, Target: a.Exposure, Reason: "rule regime entry: A"}}, intents)
		case 3:
			require.Equal(t, []Intent{{Instrument: bar.Instrument, Reason: "rule exit"}}, intents)
		case 6:
			require.Equal(t, []Intent{{Instrument: bar.Instrument, Target: a.Exposure, Reason: "rule regime entry: B"}}, intents)
		default:
			require.Empty(t, intents, "bar %d must keep its target", i)
		}
	}
}
