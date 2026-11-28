package strategy

import (
	"encoding/json"
	"math"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestNativeDefinitionMatchesNativeSignals(t *testing.T) {
	closes := []float64{100, 101, 100, 101, 100, 90, 99, 100.5, 101, 115, 110, 95, 87}
	for _, tt := range []struct {
		name   string
		params Params
	}{
		{name: "hold-cash"},
		{name: "buy-and-hold", params: Params{"exposure": 0.5}},
		{name: "trend-ema", params: Params{"fast": 2, "slow": 4, "exposure": 0.6}},
		{name: "mean-rev-bands", params: Params{"period": 5, "k": 1}},
	} {
		t.Run(tt.name, func(t *testing.T) {
			// Decode the versioned format before comparing complete intents with the native factory.
			wire, err := json.Marshal(NativeDefinition{Format: NativeFormatV1, Name: tt.name, Params: tt.params})
			require.NoError(t, err)
			var definition NativeDefinition
			require.NoError(t, json.Unmarshal(wire, &definition))
			got, err := definition.Build()
			require.NoError(t, err)
			want, err := registry[tt.name](tt.params)
			require.NoError(t, err)
			for i, close := range closes {
				for _, symbol := range []string{"BTCUSDT", "ETHUSDT"} {
					bar := closeBar(symbol, i, close)
					intents, err := got.OnBar(nil, bar)
					require.NoError(t, err)
					expected, err := want.OnBar(nil, bar)
					require.NoError(t, err)
					require.Equal(t, expected, intents, "%s at bar %d", symbol, i)
				}
			}
		})
	}
}

func TestNativeDefinitionContentHash(t *testing.T) {
	base := NativeDefinition{Format: NativeFormatV1, Name: "trend-ema"}
	first, err := base.ContentHash()
	require.NoError(t, err)
	require.Regexp(t, `^sha256:[0-9a-f]{64}$`, first)
	base.Params = Params{"slow": 26, "fast": 12, "exposure": 1}
	defaults, err := base.ContentHash()
	require.NoError(t, err)
	require.Equal(t, first, defaults)
	base.Params["exposure"] = 0.5
	changed, err := base.ContentHash()
	require.NoError(t, err)
	require.NotEqual(t, first, changed)

	for _, invalid := range []NativeDefinition{
		{Format: "native/v2", Name: "trend-ema"},
		{Format: NativeFormatV1, Name: "missing"},
		{Format: NativeFormatV1, Name: "trend-ema", Params: Params{"fastt": 4}},
		{Format: NativeFormatV1, Name: "trend-ema", Params: Params{"fast": math.NaN()}},
		{Format: NativeFormatV1, Name: "trend-ema", Params: Params{"fast": 26}},
	} {
		hash, err := invalid.ContentHash()
		require.Error(t, err)
		require.Empty(t, hash)
	}
}
