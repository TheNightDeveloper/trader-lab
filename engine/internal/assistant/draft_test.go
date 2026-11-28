package assistant

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

const draftDefinition = `{"format":"rules/v1","base_timeframe":"1h","exposure":"0.125","entry":{"op":"cross_above","left":{"kind":"close"},"right":{"kind":"sma","period":20}},"exit":{"op":"lt","left":{"kind":"close"},"right":{"kind":"sma","period":10}}}`

func TestStrategyDraftChecksRuleTreeAndGrounding(t *testing.T) {
	prompt := Draft("کندل ۱ ساعته. عبور قیمت از میانگین ۲۰ برای ورود، زیر میانگین ١٠ برای خروج. سهم ۱۲٫۵٪.")
	wrap := func(definition string) string {
		t.Helper()
		raw, err := json.Marshal(map[string]any{"definition_json": definition, "questions": []string{}})
		require.NoError(t, err)
		return string(raw)
	}
	result, err := prompt.Parse(wrap(draftDefinition))
	require.NoError(t, err)
	require.Equal(t, "draft", result.Focus)
	require.JSONEq(t, strings.Replace(draftDefinition, `"0.125"`, `"0.125000"`, 1), result.Draft.Definition)
	require.Equal(t, 21, result.Draft.Lookback)

	invented := strings.ReplaceAll(draftDefinition, `"period":20`, `"period":21`)
	result, err = prompt.Parse(wrap(invented))
	require.NoError(t, err)
	require.Equal(t, "needs_definition", result.Focus)
	require.Equal(t, []string{"parameters"}, result.Draft.Questions)
	require.Empty(t, result.Draft.Definition)

	invented = strings.NewReplacer(`"exposure":"0.125"`, `"exposure":"0.25"`, `"1h"`, `"1d"`).Replace(draftDefinition)
	result, err = prompt.Parse(wrap(invented))
	require.NoError(t, err)
	require.Equal(t, []string{"exposure", "timeframe"}, result.Draft.Questions)

	for _, raw := range []string{
		wrap(strings.Replace(draftDefinition, `"period":20`, `"period":1`, 1)),
		wrap(strings.Replace(draftDefinition, `"op":"lt"`, `"op":"market_sell"`, 1)),
		`{"definition_json":"","questions":["entry"],"questions":["exit"]}`,
		`{"definition_json":"","questions":["place_order"]}`,
		`{"definition_json":"{}","questions":["entry"]}`,
	} {
		_, err := prompt.Parse(raw)
		require.ErrorIs(t, err, ErrInvalidOutput, raw)
	}
	result, err = prompt.Parse(`{"questions":["entry","exit"],"definition_json":""}`)
	require.NoError(t, err)
	require.Equal(t, []string{"entry", "exit"}, result.Draft.Questions)
}
