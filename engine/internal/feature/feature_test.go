package feature

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

func TestRowValues(t *testing.T) {
	var bars []data.Bar
	for i := range 30 {
		c := int64(100+i) * 1e8 // a steady climb: 100, 101, …
		bars = append(bars, data.Bar{OpenTime: time.Unix(int64(i)*3600, 0), C: money.Price{V: c}, H: money.Price{V: c + 1e8}, L: money.Price{V: c - 1e8}})
	}
	x, ok := Row([]string{"ret_1", "ret_4", "rsi_14", "range_24"}, bars)
	require.True(t, ok)
	require.InDelta(t, 129.0/128-1, x[0], 1e-12)
	require.InDelta(t, 129.0/125-1, x[1], 1e-12)
	require.Equal(t, 1.0, x[2], "only gains")
	require.InDelta(t, (130.0-105)/129, x[3], 1e-12)

	_, ok = Row([]string{"ret_72"}, bars)
	require.False(t, ok, "not enough history: no row")
	require.ErrorIs(t, Check([]string{"ret_1", "nope"}), ErrUnknown)
}
