package eval

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"pgregory.net/rapid"

	"tradinglab/engine/internal/money"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

const day = 24 * time.Hour

func TestSplitExpandingAndRolling(t *testing.T) {
	s, err := SplitPlan{Folds: 4, Holdout: 200_000, Embargo: time.Hour}.Make(t0, t0.Add(100*day), time.Hour)
	require.NoError(t, err)
	require.Equal(t, Window{t0.Add(80 * day), t0.Add(100 * day)}, s.Holdout)
	require.Len(t, s.Folds, 4)
	f1 := s.Folds[0]
	require.Equal(t, t0, f1.Train.From)
	require.Equal(t, t0.Add(16*day-time.Hour), f1.Train.To, "embargo cut from train end")
	require.Equal(t, Window{t0.Add(16 * day), t0.Add(32 * day)}, f1.Test)
	require.Equal(t, t0, s.Folds[3].Train.From, "expanding")
	require.Equal(t, t0.Add(80*day), s.Folds[3].Test.To, "last fold ends at the holdout")
	require.Equal(t, Window{t0.Add(16 * day), t0.Add(80 * day)}, s.OOS)

	r, err := SplitPlan{Folds: 4, Rolling: true}.Make(t0, t0.Add(100*day), time.Hour)
	require.NoError(t, err)
	require.Equal(t, t0.Add(48*day), r.Folds[3].Train.From, "rolling: test starts day 64, train one chunk (16d) back")
}

func TestSplitRejectsBadPlans(t *testing.T) {
	for _, p := range []SplitPlan{{Folds: 51}, {Holdout: 600_000}, {Embargo: 30 * day}} {
		_, err := p.Make(t0, t0.Add(100*day), time.Hour)
		require.ErrorIs(t, err, ErrPlan, "%+v", p)
	}
	_, err := SplitPlan{Folds: 10}.Make(t0, t0.Add(5*time.Hour), time.Hour)
	require.ErrorIs(t, err, ErrPlan, "too short")
}

// Folds never touch the holdout, test windows tile the OOS range in order, and
// every train window ends (embargo included) before its test window starts.
func TestSplitProperty(t *testing.T) {
	rapid.Check(t, func(rt *rapid.T) {
		days := rapid.IntRange(30, 2000).Draw(rt, "days")
		p := SplitPlan{
			Folds:   rapid.IntRange(1, 12).Draw(rt, "folds"),
			Rolling: rapid.Bool().Draw(rt, "rolling"),
			Holdout: money.Ratio(rapid.Int64Range(10_000, 490_000).Draw(rt, "holdout")),
			Embargo: time.Duration(rapid.IntRange(0, 24).Draw(rt, "emb")) * time.Hour,
		}
		s, err := p.Make(t0, t0.Add(time.Duration(days)*day), time.Minute)
		if err != nil {
			return // too short for this plan: rejected, fine
		}
		prev := s.OOS.From
		for _, f := range s.Folds {
			require.Equal(rt, prev, f.Test.From, "contiguous")
			require.True(rt, f.Test.To.After(f.Test.From))
			require.False(rt, f.Train.To.After(f.Test.From.Add(-p.Embargo)))
			require.False(rt, f.Test.To.After(s.Holdout.From), "never in holdout")
			prev = f.Test.To
		}
		require.Equal(rt, s.Holdout.From, prev)
	})
}
