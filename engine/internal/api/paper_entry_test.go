package api

import (
	"testing"

	"github.com/stretchr/testify/require"
)

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
