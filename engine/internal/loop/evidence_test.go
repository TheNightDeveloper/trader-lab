package loop

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/metrics"
)

func TestForwardCoverageNeedsEveryBarOfEverySymbol(t *testing.T) {
	start := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	end := start.Add(48 * time.Hour)
	makeBars := func(sym string) []data.Bar {
		var bs []data.Bar
		for at := start; at.Before(end); at = at.Add(time.Hour) {
			bs = append(bs, data.Bar{Instrument: sym, OpenTime: at, CloseTime: at.Add(time.Hour), AvailableAt: at.Add(time.Hour + 2*time.Second)})
		}
		return bs
	}
	for _, scenario := range []string{"complete", "missing_symbol", "hole", "partial", "synthetic", "unavailable", "bad_close"} {
		t.Run(scenario, func(t *testing.T) {
			bars := map[string][]data.Bar{"BTCUSDT": makeBars("BTCUSDT"), "ETHUSDT": makeBars("ETHUSDT")}
			switch scenario {
			case "missing_symbol":
				delete(bars, "ETHUSDT")
			case "hole":
				bars["ETHUSDT"] = append(bars["ETHUSDT"][:12], bars["ETHUSDT"][13:]...)
			case "partial":
				bars["ETHUSDT"][12].Flags = data.FlagPartial
			case "synthetic":
				bars["ETHUSDT"][12].Flags = data.FlagFilled
			case "unavailable":
				bars["ETHUSDT"][12].AvailableAt = end.Add(24 * time.Hour)
			case "bad_close":
				bars["ETHUSDT"][12].CloseTime = end
			}
			through, missing := coveredThrough(bars, []string{"BTCUSDT", "ETHUSDT"}, start, end, end.Add(time.Hour), time.Hour)
			switch scenario {
			case "complete":
				require.Equal(t, end, through)
				require.Empty(t, missing)
			case "missing_symbol":
				require.Equal(t, start, through)
				require.Equal(t, []string{"ETHUSDT"}, missing)
			default:
				require.Equal(t, start.Add(12*time.Hour), through)
				require.Equal(t, []string{"ETHUSDT"}, missing)
			}
		})
	}
}

func TestWalkWinsRequireSamePeriodAndValidPeriodPnL(t *testing.T) {
	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	fold := eval.Fold{Index: 1, Test: eval.Window{From: from, To: from.Add(24 * time.Hour)}}
	a := []eval.FoldView{{Fold: fold, Metrics: []metrics.Metric{m("period_pnl", 10), m("net_pnl", -100)}}}
	b := []eval.FoldView{{Fold: fold, Metrics: []metrics.Metric{m("period_pnl", 5), m("net_pnl", 100)}}}
	require.Equal(t, 1, countWins(a, b))
	b[0].Fold.Test.To = b[0].Fold.Test.To.Add(time.Hour)
	require.Zero(t, countWins(a, b), "different periods are incomparable")
	b[0].Fold = fold
	b[0].Metrics[0].Valid = false
	require.Zero(t, countWins(a, b), "missing or invalid evidence is not a zero loss")
	b[0].Metrics = b[0].Metrics[1:]
	require.Zero(t, countWins(a, b), "legacy lifetime score cannot substitute for period PnL")
}

func TestEvidenceRequiresRealFreezeAndCurrentContract(t *testing.T) {
	t0 := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	created, freeze, start := t0.Add(time.Hour), t0.Add(65*time.Minute), t0.Add(2*time.Hour)
	d := Doc{Config: Default(), EvaluationVersion: eval.Version, TrainingCutoff: &t0, ModelCreatedAt: &created, FreezeAt: &freeze, TradeStart: &start}
	require.True(t, CurrentEvidence(d))
	d.Config.Symbols = []string{"ETHBTC"}
	require.False(t, CurrentEvidence(d), "unsupported stored evidence cannot authorize promotion")
	d.Config = Default()
	d.EvaluationVersion = "p0.2"
	require.False(t, CurrentEvidence(d))
	d.EvaluationVersion = eval.Version
	d.FreezeAt = &t0
	require.False(t, CurrentEvidence(d))
	d.FreezeAt = &freeze
	d.TradeStart = &created
	require.False(t, CurrentEvidence(d))
}
