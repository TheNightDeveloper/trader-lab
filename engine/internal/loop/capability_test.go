package loop

import (
	"context"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestLearningRejectsNonUSDTAndUnknownPairs(t *testing.T) {
	for _, symbol := range []string{"ETHBTC", "UNKNOWNUSDT"} {
		cfg := Default()
		cfg.Symbols = []string{symbol}
		require.Error(t, cfg.Validate(), symbol)
	}
	cfg := Default()
	cfg.Symbols = []string{"BTCUSDT", "ETHUSDT"}
	require.NoError(t, cfg.Validate())
}

func TestStoredCrossCycleFailsWithoutChangingActiveModel(t *testing.T) {
	_, l, _ := setup(t)
	ctx := context.Background()
	version, modelID := active(t, l)
	for _, state := range []string{Collect, ForwardTest} {
		id, err := l.Begin(ctx, "manual")
		require.NoError(t, err)
		c := get(t, l, id)
		c.doc.Config.Symbols, c.row.State = []string{"ETHBTC"}, state
		require.NoError(t, l.save(ctx, l.Store.Queries, &c))
		if state == Collect {
			require.Error(t, l.RunCycle(ctx, id))
		} else {
			require.NoError(t, l.Advance(ctx))
		}
		got := get(t, l, id)
		require.Equal(t, Failed, got.row.Outcome)
		require.Contains(t, got.row.Reason, "USDT")
		v, m := active(t, l)
		require.Equal(t, [2]string{version, modelID}, [2]string{v, m})
	}
}
