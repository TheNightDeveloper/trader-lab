package eval

import (
	"math"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/metrics"
)

func TestSummaryDoesNotPublishInvalidReturnAsZero(t *testing.T) {
	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	w := Window{From: from, To: from.Add(time.Hour)}
	e := Evaluation{Split: Split{OOS: w}, OOS: RunView{Metrics: []metrics.Metric{
		{Key: "net_pnl", V: 1e8, Valid: true},
		{Key: "total_return", Invalid: "خارج از محدوده عددی"},
		{Key: "max_drawdown", V: 20000, Valid: true},
		{Key: "closed_trades", V: 30, Valid: true},
	}}}
	s := summarize(&e)
	require.Equal(t, Warning, s.Tone)
	require.Contains(t, s.Sentence, "خارج از محدوده عددی")
	require.NotContains(t, s.Sentence, "0.00%")
}

func TestRecalcSummaryCannotWrapCombinedCosts(t *testing.T) {
	s := RecalcSummary(1e8, 1e6, []metrics.Metric{
		{Key: "net_pnl", V: -1e8, Valid: true},
		{Key: "fees", V: math.MaxInt64, Valid: true},
		{Key: "slippage", V: 1, Valid: true},
		{Key: "trades", V: 1, Valid: true},
	})
	require.Contains(t, s.Sentence, "خارج از محدوده عددی")
}
