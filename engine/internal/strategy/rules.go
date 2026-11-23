package strategy

import (
	"fmt"
	"math"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

type rulePredicate struct {
	// Compute the full lookback during validation so runtime tests can index safely.
	bars int
	test func([]data.Bar) bool
}

func compileRule(r Rule, depth int, remaining *int) (rulePredicate, error) {
	if depth > maxRuleDepth {
		return rulePredicate{}, fmt.Errorf("depth limit is %d", maxRuleDepth)
	}
	if *remaining <= len(r.Args) {
		return rulePredicate{}, fmt.Errorf("node limit is %d", maxRuleNodes)
	}
	*remaining -= 1
	if r.Op == "and" || r.Op == "or" {
		if len(r.Args) < 2 || r.Left != nil || r.Right != nil {
			return rulePredicate{}, fmt.Errorf("%s requires at least two child rules", r.Op)
		}
		children := make([]rulePredicate, len(r.Args))
		bars := 0
		for i, arg := range r.Args {
			child, err := compileRule(arg, depth+1, remaining)
			if err != nil {
				return rulePredicate{}, fmt.Errorf("%s child %d: %w", r.Op, i+1, err)
			}
			children[i] = child
			bars = max(bars, child.bars)
		}
		all := r.Op == "and"
		return rulePredicate{bars: bars, test: func(history []data.Bar) bool {
			for _, child := range children {
				if child.test(history) != all {
					return !all
				}
			}
			return all
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
	left, leftBars, err := compileRuleValue(*r.Left)
	if err != nil {
		return rulePredicate{}, fmt.Errorf("left operand: %w", err)
	}
	right, rightBars, err := compileRuleValue(*r.Right)
	if err != nil {
		return rulePredicate{}, fmt.Errorf("right operand: %w", err)
	}
	bars := max(leftBars, rightBars)
	matches := func(history []data.Bar) bool { return compare(left(history), right(history)) }
	if r.Op == "cross_above" || r.Op == "cross_below" {
		return rulePredicate{bars: bars + 1, test: func(history []data.Bar) bool {
			return matches(history) && !matches(history[:len(history)-1])
		}}, nil
	}
	return rulePredicate{bars: bars, test: matches}, nil
}

func compileRuleValue(v RuleValue) (func([]data.Bar) float64, int, error) {
	switch v.Kind {
	case "constant":
		if v.Number != nil && v.Period == 0 {
			n := *v.Number
			// Reject negative zero as well so zero has a single hashed representation.
			if !math.Signbit(n) && !math.IsNaN(n) && !math.IsInf(n, 0) {
				return func([]data.Bar) float64 { return n }, 1, nil
			}
		}
	case "close":
		if v.Number == nil && v.Period == 0 {
			return func(history []data.Bar) float64 { return closeF(history[len(history)-1]) }, 1, nil
		}
	case "sma":
		if v.Number == nil && v.Period >= 2 && v.Period <= maxRuleBars {
			return func(history []data.Bar) float64 {
				var sum float64
				for _, b := range history[len(history)-v.Period:] {
					sum += closeF(b)
				}
				return sum / float64(v.Period)
			}, v.Period, nil
		}
	}
	return nil, 0, fmt.Errorf("invalid %q operand (sma period must be in 2..%d)", v.Kind, maxRuleBars)
}

type ruleStrategy struct {
	entry, exit func([]data.Bar) bool
	bars        int
	exposure    money.Ratio
	long        map[string]bool
}

func (s *ruleStrategy) OnBar(ctx RunContext, b data.Bar) ([]Intent, error) {
	history := ctx.History(b.Instrument)
	// Late backfill enriches later evaluations without creating a new decision on an old bar.
	if len(history) < s.bars || !history[len(history)-1].OpenTime.Equal(b.OpenTime) {
		return nil, nil
	}
	wasLong := s.long[b.Instrument]
	// Emit target transitions only so a persistent rule cannot postpone a pending fill.
	if s.exit(history) {
		if wasLong {
			delete(s.long, b.Instrument)
			return []Intent{{Instrument: b.Instrument, Reason: "rule exit"}}, nil
		}
	} else if !wasLong && s.entry(history) {
		s.long[b.Instrument] = true
		return []Intent{{Instrument: b.Instrument, Target: s.exposure, Reason: "rule entry"}}, nil
	}
	return nil, nil
}

// History is already observed during warm-up and must not consume the first target change.
func (*ruleStrategy) Warmup(RunContext, data.Bar) error { return nil }
