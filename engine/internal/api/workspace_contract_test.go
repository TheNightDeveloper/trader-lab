package api

import (
	"os"
	"testing"

	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
)

func TestSignalV1Contract(t *testing.T) {
	// Flutter reads the same fixture to verify enum, int64 and explicit zero semantics.
	fixture, err := os.ReadFile("../../../testdata/contracts/signal-v1.json")
	require.NoError(t, err)
	var signal labv1.Signal
	require.NoError(t, protojson.Unmarshal(fixture, &signal))
	require.EqualValues(t, 1, signal.GetSchemaVersion())
	require.Equal(t, "trend-ema@v1", signal.GetStrategyVersionId())
	require.Equal(t, labv1.MarketProduct_MARKET_PRODUCT_SPOT, signal.GetInstrument().GetProduct())
	require.Equal(t, "BTCUSDT", signal.GetInstrument().GetSymbol())
	require.EqualValues(t, 1795046400123, signal.GetObservedAtUnixMs())
	require.Nil(t, signal.ValidUntilUnixMs)
	require.Equal(t, "0", signal.GetTargetExposure().GetUnits())
	require.EqualValues(t, 6, signal.GetTargetExposure().GetScale())
	wire, err := proto.Marshal(&signal)
	require.NoError(t, err)
	var decoded labv1.Signal
	require.NoError(t, proto.Unmarshal(wire, &decoded))
	require.True(t, proto.Equal(&signal, &decoded))
}

func TestSpotKeyPinsInstrumentRules(t *testing.T) {
	spec := instrument.Defaults()[0]
	key := spotKey(spec)
	require.True(t, proto.Equal(key, spotKey(spec)))
	spec.MinNotional.V++
	require.NotEqual(t, key.GetSpecRevision(), spotKey(spec).GetSpecRevision())
}
