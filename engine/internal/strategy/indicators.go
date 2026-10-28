package strategy

import (
	"fmt"
	"math"
	"strconv"
	"strings"

	"tradinglab/engine/internal/data"
)

// Line is one indicator line aligned with the bars; NaN = not defined yet (warm-up).
type Line struct {
	Name   string
	Values []float64
}

// Indicator is a chart overlay computed by the engine with the same code the
// strategies trade on, so a line on the chart crosses exactly where a rule fired.
type Indicator struct {
	Key   string // as requested, e.g. "ema:48"
	Label string // e.g. "EMA 48"
	Pane  string // main (over the candles) | sub (own pane)
	Lines []Line
}

// Indicators lists the supported kinds and their default parameters.
var Indicators = map[string]string{"ma": "ma:20", "ema": "ema:12", "bb": "bb:20:2", "rsi": "rsi:14", "macd": "macd:12:26:9"}

// ComputeIndicator parses key ("ema:48", "bb:20:2", …) and computes it over bars.
func ComputeIndicator(key string, bars []data.Bar) (Indicator, error) {
	parts := strings.Split(key, ":")
	nums := make([]float64, 0, len(parts)-1)
	for _, p := range parts[1:] {
		v, err := strconv.ParseFloat(p, 64)
		if err != nil || v <= 0 || v > 1000 {
			return Indicator{}, fmt.Errorf("indicator %q: parameters must be positive numbers ≤ 1000", key)
		}
		nums = append(nums, v)
	}
	period := func(i int) (int, error) {
		if i >= len(nums) || nums[i] != math.Trunc(nums[i]) || nums[i] < 1 {
			return 0, fmt.Errorf("indicator %q: needs a whole period", key)
		}
		return int(nums[i]), nil
	}
	closes := make([]float64, len(bars))
	for i, b := range bars {
		closes[i] = closeF(b)
	}
	ind := Indicator{Key: key, Pane: "main"}
	switch parts[0] {
	case "ma":
		n, err := period(0)
		if err != nil || len(nums) != 1 {
			return Indicator{}, fmt.Errorf("indicator %q: use ma:<period>", key)
		}
		ind.Label = fmt.Sprintf("MA %d", n)
		ind.Lines = []Line{{"ma", sma(closes, n)}}
	case "ema":
		n, err := period(0)
		if err != nil || len(nums) != 1 {
			return Indicator{}, fmt.Errorf("indicator %q: use ema:<period>", key)
		}
		ind.Label = fmt.Sprintf("EMA %d", n)
		ind.Lines = []Line{{"ema", emaSeries(closes, n)}}
	case "bb":
		n, err := period(0)
		if err != nil || len(nums) != 2 || n < 2 {
			return Indicator{}, fmt.Errorf("indicator %q: use bb:<period ≥ 2>:<k>", key)
		}
		ind.Label = fmt.Sprintf("BB %d %g", n, nums[1])
		ind.Lines = bollinger(closes, n, nums[1])
	case "rsi":
		n, err := period(0)
		if err != nil || len(nums) != 1 {
			return Indicator{}, fmt.Errorf("indicator %q: use rsi:<period>", key)
		}
		ind.Label, ind.Pane = fmt.Sprintf("RSI %d", n), "sub"
		ind.Lines = []Line{{"rsi", rsi(closes, n)}}
	case "macd":
		f, e1 := period(0)
		s, e2 := period(1)
		g, e3 := period(2)
		if e1 != nil || e2 != nil || e3 != nil || len(nums) != 3 || f >= s {
			return Indicator{}, fmt.Errorf("indicator %q: use macd:<fast>:<slow>:<signal>, fast < slow", key)
		}
		ind.Label, ind.Pane = fmt.Sprintf("MACD %d %d %d", f, s, g), "sub"
		ind.Lines = macd(closes, f, s, g)
	default:
		return Indicator{}, fmt.Errorf("indicator %q: unknown (have ma, ema, bb, rsi, macd)", key)
	}
	return ind, nil
}

func nans(n int) []float64 {
	out := make([]float64, n)
	for i := range out {
		out[i] = math.NaN()
	}
	return out
}

// emaSeries uses trend-ema's ema type: the chart line is the strategy's line.
func emaSeries(xs []float64, n int) []float64 {
	out, e := nans(len(xs)), newEMA(n)
	for i, x := range xs {
		if v, ok := e.add(x); ok {
			out[i] = v
		}
	}
	return out
}

func sma(xs []float64, n int) []float64 {
	out := nans(len(xs))
	for i := n - 1; i < len(xs); i++ {
		var s float64
		for _, x := range xs[i-n+1 : i+1] {
			s += x
		}
		out[i] = s / float64(n)
	}
	return out
}

// bollinger uses mean-rev-bands' ring buffer and meanStd, in the same order, so
// the lower band on the chart is the one the strategy compares against.
func bollinger(xs []float64, n int, k float64) []Line {
	mid, up, lo := nans(len(xs)), nans(len(xs)), nans(len(xs))
	st := bandState{win: make([]float64, n)}
	for i, c := range xs {
		st.win[st.next] = c
		st.next = (st.next + 1) % n
		if st.next == 0 {
			st.full = true
		}
		if !st.full {
			continue
		}
		mean, sd := meanStd(st.win)
		mid[i], up[i], lo[i] = mean, float64(mean+float64(k*sd)), float64(mean-float64(k*sd))
	}
	return []Line{{"mid", mid}, {"upper", up}, {"lower", lo}}
}

// rsi: Wilder's smoothing, 0..100; 50 when there was no movement.
func rsi(xs []float64, n int) []float64 {
	out := nans(len(xs))
	var gain, loss float64
	for i := 1; i < len(xs); i++ {
		d := xs[i] - xs[i-1]
		g, l := math.Max(d, 0), math.Max(-d, 0)
		switch {
		case i < n:
			gain, loss = gain+g, loss+l
			continue
		case i == n:
			gain, loss = (gain+g)/float64(n), (loss+l)/float64(n)
		default:
			gain, loss = (gain*float64(n-1)+g)/float64(n), (loss*float64(n-1)+l)/float64(n)
		}
		if gain+loss == 0 {
			out[i] = 50
		} else {
			out[i] = 100 * gain / (gain + loss)
		}
	}
	return out
}

func macd(xs []float64, f, s, g int) []Line {
	fast, slow := emaSeries(xs, f), emaSeries(xs, s)
	line, sig, hist := nans(len(xs)), nans(len(xs)), nans(len(xs))
	e := newEMA(g)
	for i := range xs {
		if math.IsNaN(slow[i]) {
			continue
		}
		line[i] = fast[i] - slow[i]
		if v, ok := e.add(line[i]); ok {
			sig[i], hist[i] = v, line[i]-v
		}
	}
	return []Line{{"macd", line}, {"signal", sig}, {"hist", hist}}
}
