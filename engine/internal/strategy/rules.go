package strategy

import (
	"fmt"
	"math"
	"time"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/money"
)

type rulePredicate struct {
	// Compute the full lookback during validation so runtime tests can index safely.
	bars   int
	test   func([]data.Bar) (matches, ready bool)
	reason func([]data.Bar) string
}

type ruleCompiler struct {
	remaining int
	base      time.Duration
}

func (c *ruleCompiler) compile(r Rule, depth int) (rulePredicate, error) {
	if depth > maxRuleDepth {
		return rulePredicate{}, fmt.Errorf("depth limit is %d", maxRuleDepth)
	}
	if c.remaining <= len(r.Args) {
		return rulePredicate{}, fmt.Errorf("node limit is %d", maxRuleNodes)
	}
	c.remaining--
	if r.Op == "and" || r.Op == "or" || r.Op == "route" {
		if r.Op == "route" && len(r.Args) != 3 {
			return rulePredicate{}, fmt.Errorf("route requires a condition, true rule and false rule")
		}
		if len(r.Args) < 2 || r.Left != nil || r.Right != nil {
			return rulePredicate{}, fmt.Errorf("%s requires at least two child rules", r.Op)
		}
		children := make([]rulePredicate, len(r.Args))
		bars := 0
		for i, arg := range r.Args {
			child, err := c.compile(arg, depth+1)
			if err != nil {
				return rulePredicate{}, fmt.Errorf("%s child %d: %w", r.Op, i+1, err)
			}
			children[i] = child
			bars = max(bars, child.bars)
		}
		if r.Op == "route" {
			return rulePredicate{bars: bars, test: func(history []data.Bar) (bool, bool) {
				// An unavailable classifier does not select either entry branch.
				above, ok := children[0].test(history)
				if !ok {
					return false, false
				}
				if above {
					return children[1].test(history)
				}
				return children[2].test(history)
			}, reason: func(history []data.Bar) string {
				if above, _ := children[0].test(history); above {
					return "rule regime entry: A"
				}
				return "rule regime entry: B"
			}}, nil
		}
		all := r.Op == "and"
		return rulePredicate{bars: bars, test: func(history []data.Bar) (bool, bool) {
			ready := true
			for _, child := range children {
				value, ok := child.test(history)
				if ok && value != all {
					return !all, true
				}
				ready = ready && ok
			}
			return all, ready
		}}, nil
	}

	var compare func(float64, float64) bool
	switch r.Op {
	case "gt", "cross_above":
		compare = func(a, b float64) bool { return a > b }
	case "lt", "cross_below":
		compare = func(a, b float64) bool { return a < b }
	case "gte":
		compare = func(a, b float64) bool { return a >= b }
	case "lte":
		compare = func(a, b float64) bool { return a <= b }
	default:
		return rulePredicate{}, fmt.Errorf("unknown operator %q", r.Op)
	}
	if len(r.Args) != 0 || r.Left == nil || r.Right == nil {
		return rulePredicate{}, fmt.Errorf("%s requires two numeric operands", r.Op)
	}
	left, leftBars, err := c.compileValue(*r.Left)
	if err != nil {
		return rulePredicate{}, fmt.Errorf("left operand: %w", err)
	}
	right, rightBars, err := c.compileValue(*r.Right)
	if err != nil {
		return rulePredicate{}, fmt.Errorf("right operand: %w", err)
	}
	bars := max(leftBars, rightBars)
	matches := func(history []data.Bar) (bool, bool) {
		a, aOK := left(history)
		b, bOK := right(history)
		return compare(a, b), aOK && bOK
	}
	if r.Op == "cross_above" || r.Op == "cross_below" {
		return rulePredicate{bars: bars + 1, test: func(history []data.Bar) (bool, bool) {
			current, currentOK := matches(history)
			previous, previousOK := matches(history[:len(history)-1])
			return current && !previous, currentOK && previousOK
		}}, nil
	}
	return rulePredicate{bars: bars, test: matches}, nil
}

func (c *ruleCompiler) compileValue(v RuleValue) (func([]data.Bar) (float64, bool), int, error) {
	if v.Kind == "bucket_close" && v.Number == nil && v.Period == 0 {
		tf, err := data.ParseTimeframe(string(v.Timeframe))
		if err != nil {
			return nil, 0, err
		}
		width := tf.Duration()
		if c.base == 0 || width <= c.base || width%c.base != 0 {
			return nil, 0, fmt.Errorf("bucket_close requires a larger timeframe divisible by base_timeframe")
		}
		base := c.base
		return func(history []data.Bar) (float64, bool) { return bucketClose(history, base, width) }, 1, nil
	}
	if v.Timeframe != "" {
		return nil, 0, fmt.Errorf("timeframe is only valid on bucket_close")
	}
	switch v.Kind {
	case "constant":
		if v.Number != nil && v.Period == 0 {
			n := *v.Number
			// Reject negative zero as well so zero has a single hashed representation.
			if !math.Signbit(n) && !math.IsNaN(n) && !math.IsInf(n, 0) {
				return func([]data.Bar) (float64, bool) { return n, true }, 1, nil
			}
		}
	case "close":
		if v.Number == nil && v.Period == 0 {
			return func(history []data.Bar) (float64, bool) { return closeF(history[len(history)-1]), true }, 1, nil
		}
	case "sma":
		if validPeriod(v) {
			return func(history []data.Bar) (float64, bool) {
				var sum float64
				for _, b := range history[len(history)-v.Period:] {
					sum += closeF(b)
				}
				return sum / float64(v.Period), true
			}, v.Period, nil
		}
	case "prior_high", "prior_low":
		if validPeriod(v) {
			return func(history []data.Bar) (float64, bool) {
				// Exclude the signal candle so its extremes cannot move the channel it tests.
				prior := history[len(history)-v.Period-1 : len(history)-1]
				if v.Kind == "prior_high" {
					level := prior[0].H.V
					for _, b := range prior[1:] {
						level = max(level, b.H.V)
					}
					return float64(level) / 1e8, true
				}
				level := prior[0].L.V
				for _, b := range prior[1:] {
					level = min(level, b.L.V)
				}
				return float64(level) / 1e8, true
			}, v.Period + 1, nil
		}
	case "rsi":
		if validPeriod(v) {
			return func(history []data.Bar) (float64, bool) {
				return 100 * feature.SimpleRSI(history[len(history)-v.Period-1:]), true
			}, v.Period + 1, nil
		}
	}
	return nil, 0, fmt.Errorf("invalid %q operand (rolling period must be in 2..%d)", v.Kind, maxRuleBars)
}

func validPeriod(v RuleValue) bool {
	return v.Number == nil && v.Period >= 2 && v.Period <= maxRuleBars
}

type ruleStrategy struct {
	entry, exit func([]data.Bar) (bool, bool)
	reason      func([]data.Bar) string
	bars        int
	base        time.Duration
	exposure    money.Ratio
	long        map[string]bool
}

func (s *ruleStrategy) OnBar(ctx RunContext, b data.Bar) ([]Intent, error) {
	if s.base != 0 && (b.CloseTime.Sub(b.OpenTime) != s.base || !b.OpenTime.Truncate(s.base).Equal(b.OpenTime)) {
		return nil, fmt.Errorf("strategy: input bar does not match base_timeframe %s", s.base)
	}
	history := ctx.History(b.Instrument)
	// Late backfill enriches later evaluations without creating a new decision on an old bar.
	if len(history) < s.bars || !history[len(history)-1].OpenTime.Equal(b.OpenTime) {
		return nil, nil
	}
	wasLong := s.long[b.Instrument]
	// Emit target transitions only so a persistent rule cannot postpone a pending fill.
	exit, ready := s.exit(history)
	if !ready {
		return nil, nil
	}
	if exit {
		if wasLong {
			delete(s.long, b.Instrument)
			return []Intent{{Instrument: b.Instrument, Reason: "rule exit"}}, nil
		}
	} else if !wasLong {
		if entry, ready := s.entry(history); ready && entry {
			s.long[b.Instrument] = true
			return []Intent{s.entryIntent(b.Instrument, history)}, nil
		}
	}
	return nil, nil
}

func (s *ruleStrategy) entryIntent(symbol string, history []data.Bar) Intent {
	reason := "rule entry"
	if s.reason != nil {
		reason = s.reason(history)
	}
	return Intent{Instrument: symbol, Target: s.exposure, Reason: reason}
}

// bucketClose reads the last aligned bucket only after its entire sequence is visible.
func bucketClose(history []data.Bar, base, width time.Duration) (float64, bool) {
	end := history[len(history)-1].CloseTime.Truncate(width)
	i := len(history) - 1
	for ; i >= 0 && history[i].OpenTime.Compare(end) >= 0; i-- {
	}
	last := i
	start := end.Add(-width)
	for at := end; at.After(start); at = at.Add(-base) {
		if i < 0 || !history[i].CloseTime.Equal(at) || !history[i].OpenTime.Equal(at.Add(-base)) ||
			history[i].Flags&(data.FlagFilled|data.FlagPartial) != 0 {
			return 0, false
		}
		i--
	}
	return closeF(history[last]), true
}

// History is already observed during warm-up and must not consume the first target change.
func (*ruleStrategy) Warmup(RunContext, data.Bar) error { return nil }
