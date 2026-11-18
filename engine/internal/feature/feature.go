// Package feature computes model inputs and labels from bars. A feature of bar i
// is a function of its trailing window, available only when all members exist;
// a round-trip label needs both execution endpoint prices to be available.
// Floats are allowed here: this is model math, never accounting.
package feature

import (
	"context"
	"errors"
	"fmt"
	"math"
	"slices"
	"time"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/fillpolicy"
	"tradinglab/engine/internal/money"
)

var (
	ErrUnknown = errors.New("feature: unknown")
	// ErrLookAhead: a row or label that was not available at the as-of time was
	// passed to a fit. Fits only ever see the past of their window.
	ErrLookAhead = errors.New("feature: look-ahead")
)

type def struct {
	lookback int // bars needed, including the current one
	f        func(b []data.Bar) float64
}

func closeF(b data.Bar) float64 { return float64(b.C.V) / 1e8 }

func ret(k int) def {
	return def{k + 1, func(b []data.Bar) float64 {
		return closeF(b[len(b)-1])/closeF(b[len(b)-1-k]) - 1
	}}
}

var defs = map[string]def{
	"ret_1":  ret(1),
	"ret_4":  ret(4),
	"ret_24": ret(24),
	"ret_72": ret(72),
	// Standard deviation of the last 24 one-bar returns.
	"vol_24": {25, func(b []data.Bar) float64 {
		t := b[len(b)-25:]
		var sum, sq float64
		for i := 1; i < len(t); i++ {
			r := closeF(t[i])/closeF(t[i-1]) - 1
			sum += r
			sq += r * r
		}
		n := float64(len(t) - 1)
		m := sum / n
		return math.Sqrt(math.Max(0, sq/n-m*m))
	}},
	// RSI over 14 changes (simple averages), as a fraction 0..1; 0.5 when flat.
	"rsi_14": {15, func(b []data.Bar) float64 {
		t := b[len(b)-15:]
		var up, down float64
		for i := 1; i < len(t); i++ {
			d := closeF(t[i]) - closeF(t[i-1])
			if d > 0 {
				up += d
			} else {
				down -= d
			}
		}
		if up+down == 0 {
			return 0.5
		}
		return up / (up + down)
	}},
	// Close relative to its 24-bar simple average.
	"sma_gap_24": {24, func(b []data.Bar) float64 {
		t := b[len(b)-24:]
		var s float64
		for _, x := range t {
			s += closeF(x)
		}
		return closeF(t[len(t)-1])/(s/24) - 1
	}},
	// High-low range of the last 24 bars relative to the close.
	"range_24": {24, func(b []data.Bar) float64 {
		t := b[len(b)-24:]
		hi, lo := t[0].H.V, t[0].L.V
		for _, x := range t[1:] {
			hi, lo = max(hi, x.H.V), min(lo, x.L.V)
		}
		return float64(hi-lo) / 1e8 / closeF(t[len(t)-1])
	}},
}

// Names lists every known feature, sorted.
func Names() []string {
	out := make([]string, 0, len(defs))
	for n := range defs {
		out = append(out, n)
	}
	slices.Sort(out)
	return out
}

// Check reports an unknown or repeated feature name.
func Check(names []string) error {
	seen := map[string]bool{}
	for _, n := range names {
		if _, ok := defs[n]; !ok {
			return fmt.Errorf("%w %q", ErrUnknown, n)
		}
		if seen[n] {
			return fmt.Errorf("feature: %q listed twice", n)
		}
		seen[n] = true
	}
	return nil
}

// Lookback is the number of bars names need for the first row.
func Lookback(names []string) int {
	n := 1
	for _, k := range names {
		n = max(n, defs[k].lookback)
	}
	return n
}

// Row computes names for the last bar of hist. False when hist is too short.
// Names must have passed Check.
func Row(names []string, hist []data.Bar) ([]float64, bool) {
	if len(hist) < Lookback(names) {
		return nil, false
	}
	x := make([]float64, len(names))
	for i, n := range names {
		x[i] = defs[n].f(hist)
	}
	return x, true
}

// Sample is one training row: features of the bar opened at At and the net
// return of a hypothetical round trip as the label.
type Sample struct {
	At          time.Time // open time of the feature bar
	AvailableAt time.Time // when the features existed
	ReadyAt     time.Time // when both label endpoint prices were available
	X           []float64
	Y           float64
}

// Samples builds rows for bars opened in [from, to) whose label is ready at asOf.
// Rows with an unready label are left out: nothing unready enters training.
func Samples(names []string, h int, bars []data.Bar, from, to, asOf time.Time) ([]Sample, error) {
	return SamplesContext(context.Background(), names, h, bars, from, to, asOf, LabelCosts{})
}

// LabelCosts are the simulator's per-side rates, in millionths.
type LabelCosts struct {
	Fee      money.Ratio `json:"fee_ppm"`
	Slippage money.Ratio `json:"slippage_ppm"`
}

// Valid checks the same rate bounds as simulated fills.
func (c LabelCosts) Valid() bool {
	return c.Fee >= 0 && c.Fee < money.RatioOne && c.Slippage >= 0 && c.Slippage < money.RatioOne
}

// SamplesContext labels verifiable same-symbol round trips using observed prices.
func SamplesContext(ctx context.Context, names []string, h int, bars []data.Bar, from, to, asOf time.Time, costs LabelCosts) ([]Sample, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if err := Check(names); err != nil {
		return nil, err
	}
	if h < 1 || !costs.Valid() {
		return nil, errors.New("feature: invalid label horizon or costs")
	}
	if len(bars) == 0 {
		return nil, nil
	}
	frame := bars[0].CloseTime.Sub(bars[0].OpenTime)
	if frame <= 0 || frame > 24*time.Hour {
		return nil, errors.New("feature: invalid candle duration")
	}
	fee := float64(costs.Fee) / float64(money.RatioOne)
	slip := float64(costs.Slippage) / float64(money.RatioOne)
	factor := (1 - slip) * (1 - fee) / ((1 + slip) * (1 + fee))
	var out []Sample
	lookback := Lookback(names)
	runEnd := len(bars)
	for i := len(bars) - 1; i >= lookback-1; i-- {
		if i%256 == 0 {
			if err := ctx.Err(); err != nil {
				return nil, err
			}
		}
		b := bars[i]
		if !realBar(b, frame) {
			runEnd = i
			continue
		}
		if i+1 < runEnd && !b.CloseTime.Equal(bars[i+1].OpenTime) {
			runEnd = i + 1
		}
		if b.OpenTime.Before(from) {
			break
		}
		if !b.OpenTime.Before(to) || b.AvailableAt.After(asOf) ||
			!b.AvailableAt.Before(b.CloseTime.Add(frame)) || !observedWindow(bars[i-lookback+1:i+1], frame) {
			continue
		}
		entry := i + fillpolicy.DefaultLatencyBars
		entry += causalOpen(bars[entry:runEnd], b.AvailableAt, frame)
		if h >= runEnd-entry {
			continue
		}
		// The exit is activated at the holding target or once entry is observed,
		// whichever comes later. The earlier open cannot fill an unseen position.
		exit := entry + h
		exitAt := bars[exit].OpenTime
		if observed := bars[entry].AvailableAt; observed.After(exitAt) {
			exitAt = observed
		}
		exit += causalOpen(bars[exit:runEnd], exitAt, frame)
		if exit >= runEnd || bars[exit].AvailableAt.After(asOf) {
			continue
		}
		x, _ := Row(names, bars[:i+1])
		out = append(out, Sample{At: b.OpenTime, AvailableAt: b.AvailableAt, ReadyAt: bars[exit].AvailableAt, X: x,
			Y: float64(bars[exit].O.V)/float64(bars[entry].O.V)*factor - 1})
	}
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	slices.Reverse(out)
	return out, nil
}

func realBar(b data.Bar, frame time.Duration) bool {
	// A later open can execute first if this bar arrives after the next close.
	return b.Flags&(data.FlagFilled|data.FlagPartial) == 0 && b.O.V > 0 && b.C.V > 0 &&
		b.CloseTime.Equal(b.OpenTime.Add(frame)) && !b.AvailableAt.Before(b.CloseTime) &&
		!b.AvailableAt.After(b.CloseTime.Add(frame))
}

func observedWindow(bars []data.Bar, frame time.Duration) bool {
	decision := bars[len(bars)-1].AvailableAt
	for i, b := range bars[:len(bars)-1] {
		if !realBar(b, frame) || b.AvailableAt.After(decision) || !b.CloseTime.Equal(bars[i+1].OpenTime) {
			return false
		}
	}
	return true
}

func causalOpen(bars []data.Bar, at time.Time, frame time.Duration) int {
	until := at.Add(fillpolicy.DefaultTTL(fillpolicy.DefaultLatencyBars, frame))
	// Contiguity and the publication bound mean at most one open is already past.
	for j, b := range bars {
		if !b.OpenTime.Before(at) {
			if fillpolicy.AllowsOpen(b.OpenTime, at, until) {
				return j
			}
			break
		}
	}
	return len(bars)
}

// CheckAsOf fails when any sample (features or label) was not available at asOf.
func CheckAsOf(samples []Sample, asOf time.Time) error {
	return CheckAsOfContext(context.Background(), samples, asOf)
}

// CheckAsOfContext cooperatively stops long training passes without changing arithmetic.
func CheckAsOfContext(ctx context.Context, samples []Sample, asOf time.Time) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	for i, s := range samples {
		if i%256 == 0 {
			if err := ctx.Err(); err != nil {
				return err
			}
		}
		if s.AvailableAt.After(asOf) || s.ReadyAt.After(asOf) {
			return fmt.Errorf("%w: row at %s has features available at %s and label ready at %s (as-of %s)", ErrLookAhead,
				s.At.Format(time.RFC3339), s.AvailableAt.Format(time.RFC3339), s.ReadyAt.Format(time.RFC3339), asOf.Format(time.RFC3339))
		}
	}
	return nil
}

// Scaler standardizes each feature with a mean and spread fit inside a training
// window only.
type Scaler struct {
	Mean []float64 `json:"mean"`
	Std  []float64 `json:"std"`
}

// FitScaler fits on samples, all of which must have been available at asOf.
// Fitting on rows from after the window (e.g. all history) is an error.
func FitScaler(samples []Sample, asOf time.Time) (Scaler, error) {
	return FitScalerContext(context.Background(), samples, asOf)
}

// FitScalerContext cooperatively stops long training passes without changing arithmetic.
func FitScalerContext(ctx context.Context, samples []Sample, asOf time.Time) (Scaler, error) {
	if err := CheckAsOfContext(ctx, samples, asOf); err != nil {
		return Scaler{}, err
	}
	if len(samples) == 0 {
		return Scaler{}, errors.New("feature: no samples to fit")
	}
	k := len(samples[0].X)
	if k == 0 {
		return Scaler{}, errors.New("feature: no columns to fit")
	}
	s := Scaler{Mean: make([]float64, k), Std: make([]float64, k)}
	n := float64(len(samples))
	for i, r := range samples {
		if i%256 == 0 {
			if err := ctx.Err(); err != nil {
				return Scaler{}, err
			}
		}
		if len(r.X) != k {
			return Scaler{}, fmt.Errorf("feature: row %d has %d columns, want %d", i, len(r.X), k)
		}
		for j, v := range r.X {
			if math.IsNaN(v) || math.IsInf(v, 0) {
				return Scaler{}, fmt.Errorf("feature: row %d column %d is not finite", i, j)
			}
			s.Mean[j] += v / n
		}
	}
	for i, r := range samples {
		if i%256 == 0 {
			if err := ctx.Err(); err != nil {
				return Scaler{}, err
			}
		}
		for j, v := range r.X {
			d := v - s.Mean[j]
			s.Std[j] += d * d / n
		}
	}
	for j := range s.Std {
		s.Std[j] = math.Sqrt(s.Std[j])
		if math.IsNaN(s.Mean[j]) || math.IsInf(s.Mean[j], 0) || math.IsNaN(s.Std[j]) || math.IsInf(s.Std[j], 0) {
			return Scaler{}, fmt.Errorf("feature: scaler column %d overflowed", j)
		}
		if s.Std[j] == 0 {
			s.Std[j] = 1 // a constant feature carries no information; keep it at 0
		}
	}
	if err := ctx.Err(); err != nil {
		return Scaler{}, err
	}
	return s, nil
}

// Apply returns the standardized copy of x.
func (s Scaler) Apply(x []float64) []float64 {
	z := make([]float64, len(x))
	for j, v := range x {
		z[j] = (v - s.Mean[j]) / s.Std[j]
	}
	return z
}
