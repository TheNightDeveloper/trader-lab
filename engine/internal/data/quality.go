package data

import (
	"cmp"
	"errors"
	"fmt"
	"slices"
	"time"

	"tradinglab/engine/internal/money"
)

var ErrGap = errors.New("data: gap in data")

type IssueKind string

const (
	IssueGap        IssueKind = "gap"
	IssueOutOfOrder IssueKind = "out_of_order"
	IssueDuplicate  IssueKind = "duplicate"
	IssueBadPrice   IssueKind = "bad_price"
	IssueZeroVolume IssueKind = "zero_volume"
	IssueCorrection IssueKind = "correction"
	IssueOutage     IssueKind = "outage"
)

// Issue covers bars with open time in [At, Until).
type Issue struct {
	Kind   IssueKind
	At     time.Time
	Until  time.Time
	Detail string
}

// Clean returns the usable bars sorted by open time, plus every problem found.
// Out-of-order rows are sorted, duplicates keep the first row, and bars with an
// impossible price are dropped (the hole then also shows up as a gap).
// Consecutive zero-volume bars are reported as one issue and kept.
func Clean(in []Bar, tf Timeframe) ([]Bar, []Issue) {
	var issues []Issue
	for i := 1; i < len(in); i++ {
		if in[i].OpenTime.Before(in[i-1].OpenTime) {
			issues = append(issues, Issue{IssueOutOfOrder, in[i].OpenTime, in[i].CloseTime,
				fmt.Sprintf("row %d is earlier than the row before it", i+1)})
		}
	}
	bars := slices.Clone(in)
	slices.SortStableFunc(bars, func(a, b Bar) int { return a.OpenTime.Compare(b.OpenTime) })

	out := bars[:0]
	for _, b := range bars {
		if n := len(out); n > 0 && out[n-1].OpenTime.Equal(b.OpenTime) {
			issues = append(issues, Issue{IssueDuplicate, b.OpenTime, b.CloseTime, "same open time twice; kept the first"})
			continue
		}
		if why := badPrice(b); why != "" {
			issues = append(issues, Issue{IssueBadPrice, b.OpenTime, b.CloseTime, why})
			continue
		}
		out = append(out, b)
	}
	issues = append(issues, Gaps(out, tf, time.Time{}, time.Time{})...)
	issues = append(issues, zeroVolumeRuns(out)...)
	sortIssues(issues)
	return out, issues
}

func badPrice(b Bar) string {
	switch {
	case b.O.V <= 0 || b.H.V <= 0 || b.L.V <= 0 || b.C.V <= 0:
		return fmt.Sprintf("non-positive price O=%s H=%s L=%s C=%s", b.O, b.H, b.L, b.C)
	case b.H.V < max(b.O.V, b.C.V) || b.L.V > min(b.O.V, b.C.V):
		return fmt.Sprintf("high/low do not contain open/close: O=%s H=%s L=%s C=%s", b.O, b.H, b.L, b.C)
	case b.Volume.V < 0:
		return "negative volume"
	}
	return ""
}

// Gaps reports missing bars in sorted bars. Non-zero from/to also checks the
// edges: data must start at from and reach to.
func Gaps(bars []Bar, tf Timeframe, from, to time.Time) []Issue {
	d := tf.Duration()
	var issues []Issue
	gap := func(a, b time.Time) {
		if b.After(a) {
			issues = append(issues, Issue{IssueGap, a, b, fmt.Sprintf("%d missing %s bars", b.Sub(a)/d, tf)})
		}
	}
	if len(bars) == 0 {
		if !from.IsZero() {
			gap(from, to)
		}
		return issues
	}
	if !from.IsZero() {
		gap(from, bars[0].OpenTime)
	}
	for i := 1; i < len(bars); i++ {
		gap(bars[i-1].OpenTime.Add(d), bars[i].OpenTime)
	}
	if !to.IsZero() {
		gap(bars[len(bars)-1].OpenTime.Add(d), to)
	}
	return issues
}

func zeroVolumeRuns(bars []Bar) []Issue {
	var issues []Issue
	for i := 0; i < len(bars); {
		if bars[i].Volume.V != 0 {
			i++
			continue
		}
		j := i
		for j+1 < len(bars) && bars[j+1].Volume.V == 0 && bars[j+1].OpenTime.Equal(bars[j].CloseTime) {
			j++
		}
		issues = append(issues, Issue{IssueZeroVolume, bars[i].OpenTime, bars[j].CloseTime,
			fmt.Sprintf("%d bars with zero volume", j-i+1)})
		i = j + 1
	}
	return issues
}

func sortIssues(is []Issue) {
	slices.SortStableFunc(is, func(a, b Issue) int {
		return cmp.Or(a.At.Compare(b.At), cmp.Compare(a.Kind, b.Kind))
	})
}

// GapPolicy decides what a dataset does with missing bars.
type GapPolicy string

const (
	GapFlag  GapPolicy = "flag"  // keep the hole, report it
	GapStop  GapPolicy = "stop"  // refuse the dataset
	GapFFill GapPolicy = "ffill" // fill with flat bars at the previous close (never uses later data)
)

func ParseGapPolicy(s string) (GapPolicy, error) {
	switch p := GapPolicy(s); p {
	case GapFlag, GapStop, GapFFill:
		return p, nil
	}
	return "", fmt.Errorf("data: unknown gap policy %q", s)
}

// ApplyGapPolicy checks [from, to) for gaps and applies p. Filled bars copy the
// previous close only, have zero volume, FlagFilled, and become available exactly
// like a real bar: close + delay. A gap before the first bar cannot be filled.
func ApplyGapPolicy(bars []Bar, tf Timeframe, from, to time.Time, p GapPolicy, delay time.Duration) ([]Bar, []Issue, error) {
	gaps := Gaps(bars, tf, from, to)
	switch {
	case len(gaps) == 0 || p == GapFlag:
		return bars, gaps, nil
	case p == GapStop:
		g := gaps[0]
		return nil, gaps, fmt.Errorf("%w: %s from %s to %s (policy stop)", ErrGap, g.Detail, g.At.Format(time.RFC3339), g.Until.Format(time.RFC3339))
	}
	d := tf.Duration()
	out := make([]Bar, 0, len(bars)+len(gaps))
	for i, b := range bars {
		if i > 0 {
			prev := out[len(out)-1]
			for t := prev.OpenTime.Add(d); t.Before(b.OpenTime); t = t.Add(d) {
				out = append(out, filled(prev, t, d, delay))
			}
		}
		out = append(out, b)
	}
	if len(out) > 0 {
		for t := out[len(out)-1].OpenTime.Add(d); t.Before(to); t = t.Add(d) {
			out = append(out, filled(out[len(out)-1], t, d, delay))
		}
	}
	return out, gaps, nil // every gap is still reported, filled or not
}

func filled(prev Bar, open time.Time, d, delay time.Duration) Bar {
	c := prev.C
	return Bar{
		Instrument: prev.Instrument, OpenTime: open, CloseTime: open.Add(d), AvailableAt: open.Add(d + delay),
		O: c, H: c, L: c, C: c, Volume: money.Qty{Scale: prev.Volume.Scale}, Flags: FlagFilled,
	}
}
