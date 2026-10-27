package data

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/store/storetest"
)

func TestSeedInstrumentsIdempotent(t *testing.T) {
	s := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, SeedInstruments(ctx, s.Queries))
	require.NoError(t, SeedInstruments(ctx, s.Queries))
	got, err := s.ListInstruments(ctx)
	require.NoError(t, err)
	require.Len(t, got, 6)
	require.Equal(t, "BNBUSDT", got[0].Symbol)
	require.Equal(t, "ETHBTC", got[2].Symbol)
	require.Equal(t, "BTC", got[2].Quote)
}
