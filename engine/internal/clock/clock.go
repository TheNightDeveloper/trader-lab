// Package clock is the only source of "now". Runs use Virtual; live code uses Wall.
// sim and eval must never call time.Now directly.
package clock

import (
	"fmt"
	"time"
)

type Clock interface {
	Now() time.Time
}

// Wall is real time, UTC.
type Wall struct{}

func (Wall) Now() time.Time { return time.Now().UTC() }

// Virtual is a run's clock. It only moves forward and is driven by the event loop.
// Not safe for concurrent use: one run, one goroutine.
type Virtual struct{ t time.Time }

func NewVirtual(start time.Time) *Virtual { return &Virtual{t: start.UTC()} }

func (v *Virtual) Now() time.Time { return v.t }

// Set moves the clock to t. Moving backwards is a bug in the caller.
func (v *Virtual) Set(t time.Time) error {
	if t.Before(v.t) {
		return fmt.Errorf("clock: cannot move back from %s to %s", v.t.Format(time.RFC3339Nano), t.Format(time.RFC3339Nano))
	}
	v.t = t.UTC()
	return nil
}
