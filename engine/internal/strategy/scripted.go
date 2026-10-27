package strategy

import (
	"time"

	"tradinglab/engine/internal/data"
)

// Step fires Intent when the bar of Symbol (default Intent.Instrument) with open
// time At is processed — the same moment the original strategy decided.
type Step struct {
	At     time.Time
	Symbol string
	Intent Intent
}

// Scripted replays fixed intents. Golden scenarios use it to pin the fill model,
// and the P&L calculator (M3) re-runs recorded intents through it.
type Scripted struct {
	steps map[scriptKey][]Intent
}

type scriptKey struct {
	symbol string
	at     int64 // UnixNano; time.Time is not a safe map key across locations
}

func NewScripted(steps []Step) *Scripted {
	s := &Scripted{steps: map[scriptKey][]Intent{}}
	for _, st := range steps {
		sym := st.Symbol
		if sym == "" {
			sym = st.Intent.Instrument
		}
		k := scriptKey{sym, st.At.UnixNano()}
		s.steps[k] = append(s.steps[k], st.Intent)
	}
	return s
}

func (s *Scripted) OnBar(_ RunContext, b data.Bar) ([]Intent, error) {
	return s.steps[scriptKey{b.Instrument, b.OpenTime.UnixNano()}], nil
}
