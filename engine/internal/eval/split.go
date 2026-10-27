// Package eval turns one strategy configuration into an honest evaluation:
// walk-forward folds, a hidden holdout, cost stress and parameter stability.
// It never imports the optimizer (search, loop, model/train).
package eval

import (
	"errors"
	"fmt"
	"time"

	"tradinglab/engine/internal/money"
)

var ErrPlan = errors.New("eval: invalid split plan")

// SplitPlan cuts [From, To) into walk-forward folds and a final holdout.
type SplitPlan struct {
	Folds   int         `json:"folds"`   // test windows (default 4)
	Rolling bool        `json:"rolling"` // rolling train window; default expanding
	Holdout money.Ratio `json:"holdout"` // share of the range kept for the holdout (default 0.2)
	// Embargo is cut from the end of every train window: the label horizon, so no
	// training label overlaps the test window (M5). Rule strategies use 0.
	Embargo time.Duration `json:"embargo"`
}

type Window struct {
	From time.Time `json:"from"`
	To   time.Time `json:"to"` // exclusive
}

func (w Window) Contains(t time.Time) bool { return !t.Before(w.From) && t.Before(w.To) }

type Fold struct {
	Index int    `json:"index"`
	Train Window `json:"train"`
	Test  Window `json:"test"`
}

type Split struct {
	Folds   []Fold `json:"folds"`
	OOS     Window `json:"oos"`     // first test start → holdout start
	Holdout Window `json:"holdout"` // never used by folds
}

func (p SplitPlan) withDefaults() SplitPlan {
	if p.Folds == 0 {
		p.Folds = 4
	}
	if p.Holdout == 0 {
		p.Holdout = 200_000
	}
	return p
}

// Make splits [from, to) at multiples of step (the bar timeframe). The usable part
// before the holdout is cut into Folds+1 equal chunks: chunk 0 is the first train
// window, chunks 1..Folds are test windows. Train is everything before the test
// (expanding) or the previous chunk (rolling), minus the embargo.
func (p SplitPlan) Make(from, to time.Time, step time.Duration) (Split, error) {
	p = p.withDefaults()
	bad := func(f string, a ...any) (Split, error) {
		return Split{}, fmt.Errorf("%w: "+f, append([]any{ErrPlan}, a...)...)
	}
	switch {
	case p.Folds < 1 || p.Folds > 50:
		return bad("folds must be 1..50")
	case p.Holdout <= 0 || p.Holdout >= 500_000:
		return bad("holdout share must be in (0, 0.5)")
	case p.Embargo < 0:
		return bad("embargo must be >= 0")
	case !to.After(from):
		return bad("empty range")
	}
	span := to.Sub(from)
	holdStart := to.Add(-time.Duration(int64(span) / int64(money.RatioOne) * int64(p.Holdout))).Truncate(step)
	usable := holdStart.Sub(from)
	chunk := (usable / time.Duration(p.Folds+1)).Truncate(step)
	if chunk < step || to.Sub(holdStart) < step {
		return bad("range too short for %d folds and a holdout at %s bars", p.Folds, step)
	}
	if p.Embargo >= chunk {
		return bad("embargo %s must be shorter than a fold (%s)", p.Embargo, chunk)
	}
	var s Split
	for i := 1; i <= p.Folds; i++ {
		testFrom := from.Add(chunk * time.Duration(i))
		testTo := testFrom.Add(chunk)
		if i == p.Folds {
			testTo = holdStart // last fold absorbs the rounding remainder
		}
		trainFrom := from
		if p.Rolling {
			trainFrom = testFrom.Add(-chunk)
		}
		s.Folds = append(s.Folds, Fold{
			Index: i,
			Train: Window{trainFrom, testFrom.Add(-p.Embargo)},
			Test:  Window{testFrom, testTo},
		})
	}
	s.OOS = Window{s.Folds[0].Test.From, holdStart}
	s.Holdout = Window{holdStart, to}
	return s, nil
}
