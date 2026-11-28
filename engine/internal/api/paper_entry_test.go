package api

import (
	"testing"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/store/db"
)

func TestPaperEntryPriceUsesOnlyTheOpenInV2(t *testing.T) {
	terms := paperEntryTerms{stop: 90, model: paperFillModelV2}
	rising := db.NextPaperCandleRow{O: 100, C: 101}
	falling := db.NextPaperCandleRow{O: 100, C: 89}
	require.True(t, paperEntryPriceAllowed(terms, rising))
	require.True(t, paperEntryPriceAllowed(terms, falling))
	require.False(t, paperEntryPriceAllowed(terms, db.NextPaperCandleRow{O: 90, C: 101}))
	terms.model = paperFillModelV1
	require.False(t, paperEntryPriceAllowed(terms, falling))
}

func TestPaperExecutionSpecSurvivesSpotFilterChange(t *testing.T) {
	original, ok := paperSpotSpec("BTCUSDT")
	require.True(t, ok)
	current := original
	current.Tick.V *= 2
	current.Lot.V *= 2

	old, ok := paperExecutionSpecAt(spotKey(original), current)
	require.True(t, ok)
	require.Equal(t, original, old)
	newer, ok := paperExecutionSpecAt(spotKey(current), current)
	require.True(t, ok)
	require.Equal(t, current, newer)
}
