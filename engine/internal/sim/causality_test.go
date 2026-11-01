package sim

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/strategy"
)

// Index latency alone cannot authorize an opening price from before the decision.
func TestSignalFillsRespectDecisionTime(t *testing.T) {
	for _, tc := range []struct {
		name                string
		delay               time.Duration
		latency, fillMinute int
	}{
		{"zero delay", 0, 1, 1}, {"two second delay", 2 * time.Second, 1, 2},
		{"multi bar delay", 3 * time.Minute, 1, 4}, {"configured latency", 2 * time.Second, 3, 3},
	} {
		t.Run(tc.name, func(t *testing.T) {
			bs := flat("BTCUSDT", 10, 100)
			for i := range bs {
				bs[i].AvailableAt = bs[i].CloseTime.Add(tc.delay)
			}
			c := cfg()
			c.LatencyBars = tc.latency
			res := run(t, c, map[string][]data.Bar{"BTCUSDT": bs}, step(0, "BTCUSDT", money.RatioOne))
			require.Len(t, res.Fills, 1)
			require.Equal(t, t0.Add(time.Duration(tc.fillMinute)*time.Minute), res.Fills[0].Time)
			require.False(t, res.Fills[0].Time.Before(res.Decisions[0].At))
		})
	}
}

// A missing old candle must not leak through a prefix when a newer one arrives.
type historyAudit struct {
	checks int
	bars   []data.Bar
}

func (s *historyAudit) OnBar(ctx strategy.RunContext, b data.Bar) ([]strategy.Intent, error) {
	s.checks++
	history := ctx.History(b.Instrument)
	want := 0
	for _, source := range s.bars {
		if !source.AvailableAt.After(b.AvailableAt) {
			want++
		}
	}
	if len(history) != want {
		return nil, fmt.Errorf("history has %d bars, want %d available bars", len(history), want)
	}
	for i, h := range history {
		if h.AvailableAt.After(b.AvailableAt) {
			return nil, fmt.Errorf("unavailable bar %s leaked at %s", h.OpenTime, b.AvailableAt)
		}
		if i > 0 && !h.OpenTime.After(history[i-1].OpenTime) {
			return nil, fmt.Errorf("history not chronological")
		}
	}
	if cap(history) != len(history) {
		return nil, fmt.Errorf("history can be resliced into future data")
	}
	return nil, nil
}
func TestHistoryWithOutOfOrderAvailability(t *testing.T) {
	bs := flat("BTCUSDT", 10, 100)
	bs[0].AvailableAt = t0.Add(8 * time.Minute)
	bs[3].AvailableAt = t0.Add(10 * time.Minute)
	audit := &historyAudit{bars: bs}
	_, err := Run(context.Background(), cfg(), specs(), map[string][]data.Bar{"BTCUSDT": bs}, audit)
	require.NoError(t, err)
	require.Equal(t, len(bs), audit.checks)
}
func TestBackfillDoesNotReplaceLatestValuation(t *testing.T) {
	bs := flat("BTCUSDT", 6, 100)
	bs[0].AvailableAt = t0.Add(8 * time.Minute)
	bs[5].C = px(200e8)
	res := run(t, cfg(), map[string][]data.Bar{"BTCUSDT": bs}, step(1, "BTCUSDT", money.RatioOne))
	require.NotEmpty(t, res.Trades)
	require.Equal(t, res.Equity[len(res.Equity)-2].Equity, res.FinalEquity, "late old close must not rewind a known newer mark")
	for i, point := range res.Equity {
		if i > 0 {
			require.False(t, point.Time.Before(res.Equity[i-1].Time), "equity timestamps cannot rewind")
		}
	}
}

func TestCausalFillExpiresWithoutAnEligibleOpen(t *testing.T) {
	c := cfg()
	c.IntentTTL = time.Second
	res := run(t, c, map[string][]data.Bar{"BTCUSDT": flat("BTCUSDT", 4, 100)}, step(0, "BTCUSDT", money.RatioOne))
	require.Empty(t, res.Fills)
	require.Equal(t, OutcomeExpired, res.Decisions[0].Outcome)
}

func TestBackfillCannotTriggerProtectionBeforeEntry(t *testing.T) {
	bs := flat("BTCUSDT", 7, 100)
	bs[1].AvailableAt = t0.Add(8 * time.Minute)
	bs[1].L = px(1e8)
	in := step(0, "BTCUSDT", money.RatioOne)
	in.Intent.StopLoss = 20_000
	res := run(t, cfg(), map[string][]data.Bar{"BTCUSDT": bs}, in)
	require.Len(t, res.Fills, 1, "the low of a candle predating entry cannot sell an existing position")
	require.Nil(t, res.Trades[0].ClosedAt)
}

func TestBackfillCannotApplyProtectionToEarlierPositionState(t *testing.T) {
	bs := flat("BTCUSDT", 8, 100)
	bs[3].AvailableAt = t0.Add(10 * time.Minute)
	bs[3].L = px(1e8)
	enter := step(0, "BTCUSDT", money.RatioOne/2)
	increase := step(2, "BTCUSDT", money.RatioOne)
	increase.Intent.StopLoss = 20_000
	res := run(t, cfg(), map[string][]data.Bar{"BTCUSDT": bs}, enter, increase)
	require.Len(t, res.Fills, 2, "a late earlier range cannot apply protection set by a later increase")
	require.Nil(t, res.Trades[0].ClosedAt)
}
