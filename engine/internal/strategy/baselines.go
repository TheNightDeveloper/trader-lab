package strategy

import (
	"fmt"
	"math"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

// holdCash never trades: the zero benchmark.
type holdCash struct{}

func (holdCash) OnBar(RunContext, data.Bar) ([]Intent, error) { return nil, nil }

// buyAndHold buys each symbol on its first bar and never sells.
type buyAndHold struct {
	exposure money.Ratio
	bought   map[string]bool
}

func newBuyAndHold(p Params) (Strategy, error) {
	e, err := p.exposure()
	if err != nil {
		return nil, err
	}
	return &buyAndHold{exposure: e, bought: map[string]bool{}}, p.only("exposure")
}

func (s *buyAndHold) OnBar(_ RunContext, b data.Bar) ([]Intent, error) {
	if s.bought[b.Instrument] {
		return nil, nil
	}
	s.bought[b.Instrument] = true
	return []Intent{{Instrument: b.Instrument, Target: s.exposure, Reason: "buy and hold: first bar"}}, nil
}

// trendEMA goes long when the fast EMA crosses above the slow EMA and flat when
// it crosses below. No signal until the slow EMA has warmed up.
type trendEMA struct {
	fast, slow int
	exposure   money.Ratio
	st         map[string]*emaState
}

type emaState struct {
	fast, slow ema
	above      bool
	primed     bool
}

func newTrendEMA(p Params) (Strategy, error) {
	fast, err := p.period("fast", 12)
	if err != nil {
		return nil, err
	}
	slow, err := p.period("slow", 26)
	if err != nil {
		return nil, err
	}
	if fast >= slow {
		return nil, fmt.Errorf("strategy: trend-ema fast (%d) must be below slow (%d)", fast, slow)
	}
	e, err := p.exposure()
	if err != nil {
		return nil, err
	}
	return &trendEMA{fast: fast, slow: slow, exposure: e, st: map[string]*emaState{}}, p.only("fast", "slow", "exposure")
}

func (s *trendEMA) OnBar(_ RunContext, b data.Bar) ([]Intent, error) {
	st := s.st[b.Instrument]
	if st == nil {
		st = &emaState{fast: newEMA(s.fast), slow: newEMA(s.slow)}
		s.st[b.Instrument] = st
	}
	c := closeF(b)
	f, fok := st.fast.add(c)
	sl, sok := st.slow.add(c)
	if !fok || !sok {
		return nil, nil
	}
	above := f > sl
	if !st.primed { // first comparable bar sets the state; only crosses trade
		st.primed, st.above = true, above
		return nil, nil
	}
	if above == st.above {
		return nil, nil
	}
	st.above = above
	if above {
		return []Intent{{Instrument: b.Instrument, Target: s.exposure, Reason: fmt.Sprintf("EMA%d crossed above EMA%d", s.fast, s.slow)}}, nil
	}
	return []Intent{{Instrument: b.Instrument, Target: 0, Reason: fmt.Sprintf("EMA%d crossed below EMA%d", s.fast, s.slow)}}, nil
}

// ema is seeded with the simple mean of its first n values.
type ema struct {
	n     int
	alpha float64
	seen  int
	sum   float64
	v     float64
}

func newEMA(n int) ema { return ema{n: n, alpha: 2 / float64(n+1)} }

func (e *ema) add(x float64) (float64, bool) {
	e.seen++
	if e.seen <= e.n {
		e.sum += x
		if e.seen < e.n {
			return 0, false
		}
		e.v = float64(e.sum / float64(e.n))
		return e.v, true
	}
	e.v = float64(e.alpha*(x-e.v)) + e.v
	return e.v, true
}

// meanRevBands buys when the close re-enters the Bollinger band from below and
// exits when the close reaches the middle band.
type meanRevBands struct {
	period   int
	k        float64
	exposure money.Ratio
	st       map[string]*bandState
}

type bandState struct {
	win      []float64 // ring buffer of the last period closes
	next     int
	full     bool
	wasBelow bool
	long     bool
}

func newMeanRevBands(p Params) (Strategy, error) {
	n, err := p.period("period", 20)
	if err != nil {
		return nil, err
	}
	if n < 2 {
		return nil, fmt.Errorf("strategy: mean-rev-bands period must be >= 2")
	}
	k := p.get("k", 2)
	if k <= 0 {
		return nil, fmt.Errorf("strategy: mean-rev-bands k %v must be > 0", k)
	}
	e, err := p.exposure()
	if err != nil {
		return nil, err
	}
	return &meanRevBands{period: n, k: k, exposure: e, st: map[string]*bandState{}}, p.only("period", "k", "exposure")
}

func (s *meanRevBands) OnBar(_ RunContext, b data.Bar) ([]Intent, error) {
	st := s.st[b.Instrument]
	if st == nil {
		st = &bandState{win: make([]float64, s.period)}
		s.st[b.Instrument] = st
	}
	c := closeF(b)
	st.win[st.next] = c
	st.next = (st.next + 1) % s.period
	if st.next == 0 {
		st.full = true
	}
	if !st.full {
		return nil, nil
	}
	mean, sd := meanStd(st.win)
	lower := float64(mean - float64(s.k*sd))
	below := c < lower
	defer func() { st.wasBelow = below }()
	switch {
	case !st.long && st.wasBelow && !below:
		st.long = true
		return []Intent{{Instrument: b.Instrument, Target: s.exposure, Reason: "close re-entered the lower band"}}, nil
	case st.long && c >= mean:
		st.long = false
		return []Intent{{Instrument: b.Instrument, Target: 0, Reason: "close reached the middle band"}}, nil
	}
	return nil, nil
}

// meanStd is the population mean and standard deviation, summed in index order
// so the result is the same on every run.
func meanStd(xs []float64) (float64, float64) {
	var sum float64
	for _, x := range xs {
		sum += x
	}
	mean := float64(sum / float64(len(xs)))
	var ss float64
	for _, x := range xs {
		d := float64(x - mean)
		ss += float64(d * d)
	}
	return mean, math.Sqrt(float64(ss / float64(len(xs))))
}
