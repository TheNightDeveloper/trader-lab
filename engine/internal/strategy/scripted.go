package strategy

import (
	"time"

	"tradinglab/engine/internal/data"
)

// Step fires Intent at the bar of Intent.Instrument whose open time is At.
type Step struct {
	At     time.Time
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
		k := scriptKey{st.Intent.Instrument, st.At.UnixNano()}
		s.steps[k] = append(s.steps[k], st.Intent)
	}
	return s
}

func (s *Scripted) OnBar(_ RunContext, b data.Bar) ([]Intent, error) {
	return s.steps[scriptKey{b.Instrument, b.OpenTime.UnixNano()}], nil
}
