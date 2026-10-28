// Package feature computes model inputs and labels from bars. A feature of bar i
// is a function of bars[:i+1] only, so it is available exactly when bar i is;
// a label needs h later bars and is ready only when the last of them is.
// Floats are allowed here: this is model math, never accounting.
package feature

import (
	"errors"
	"fmt"
	"math"
	"slices"
	"time"

	"tradinglab/engine/internal/data"
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

// Sample is one training row: features of the bar opened at At, and the forward
// return over the next h bars as the label.
type Sample struct {
	At          time.Time // open time of the feature bar
	AvailableAt time.Time // when the features existed
	ReadyAt     time.Time // when the label's last bar was available
	X           []float64
	Y           float64
}

// Samples builds rows for bars opened in [from, to) whose label is ready at asOf.
// Rows with an unready label are left out: nothing unready enters training.
func Samples(names []string, h int, bars []data.Bar, from, to, asOf time.Time) ([]Sample, error) {
	if err := Check(names); err != nil {
		return nil, err
	}
	if h < 1 {
		return nil, fmt.Errorf("feature: label horizon %d must be at least one bar", h)
	}
	var out []Sample
	for i := Lookback(names) - 1; i+h < len(bars); i++ {
		b := bars[i]
		if b.OpenTime.Before(from) || !b.OpenTime.Before(to) {
			continue
		}
		end := bars[i+h]
		if end.AvailableAt.After(asOf) {
			continue
		}
		x, _ := Row(names, bars[:i+1])
		out = append(out, Sample{At: b.OpenTime, AvailableAt: b.AvailableAt, ReadyAt: end.AvailableAt, X: x, Y: closeF(end)/closeF(b) - 1})
	}
	return out, nil
}

// CheckAsOf fails when any sample (features or label) was not available at asOf.
func CheckAsOf(samples []Sample, asOf time.Time) error {
	for _, s := range samples {
		if s.AvailableAt.After(asOf) || s.ReadyAt.After(asOf) {
			return fmt.Errorf("%w: row at %s has a label ready at %s, after %s", ErrLookAhead,
				s.At.Format(time.RFC3339), s.ReadyAt.Format(time.RFC3339), asOf.Format(time.RFC3339))
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
	if err := CheckAsOf(samples, asOf); err != nil {
		return Scaler{}, err
	}
	if len(samples) == 0 {
		return Scaler{}, errors.New("feature: no samples to fit")
	}
	k := len(samples[0].X)
	s := Scaler{Mean: make([]float64, k), Std: make([]float64, k)}
	n := float64(len(samples))
	for _, r := range samples {
		for j, v := range r.X {
			s.Mean[j] += v / n
		}
	}
	for _, r := range samples {
		for j, v := range r.X {
			d := v - s.Mean[j]
			s.Std[j] += d * d / n
		}
	}
	for j := range s.Std {
		s.Std[j] = math.Sqrt(s.Std[j])
		if s.Std[j] == 0 {
			s.Std[j] = 1 // a constant feature carries no information; keep it at 0
		}
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
