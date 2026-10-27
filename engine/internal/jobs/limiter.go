// Package jobs limits research work. Control work (API, health, live ingestion)
// runs outside the limiter, so it is never starved: research can occupy at most
// its share of the CPUs.
package jobs

import (
	"context"
	"sync/atomic"
)

// Limiter is a counting semaphore of research slots (one slot ≈ one busy core).
type Limiter struct {
	slots chan struct{}
	inUse atomic.Int32
}

// ResearchSlots is the research share of cpus (percent, 1..100), at least 1 and,
// with more than one CPU, at most cpus−1 so control work always has a core.
func ResearchSlots(cpus, percent int) int {
	n := cpus * percent / 100
	if cpus > 1 {
		n = min(n, cpus-1)
	}
	return max(1, n)
}

func NewLimiter(slots int) *Limiter {
	return &Limiter{slots: make(chan struct{}, max(1, slots))}
}

// Acquire waits for a slot or ctx.
func (l *Limiter) Acquire(ctx context.Context) error {
	select {
	case l.slots <- struct{}{}:
		l.inUse.Add(1)
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

// AcquireAll takes every slot (exclusive research work, e.g. a full evaluation
// that runs its own parallel simulations). Release with ReleaseN(Size()).
func (l *Limiter) AcquireAll(ctx context.Context) error {
	for i := range l.Size() {
		if err := l.Acquire(ctx); err != nil {
			l.ReleaseN(i)
			return err
		}
	}
	return nil
}

func (l *Limiter) Release() { l.ReleaseN(1) }

func (l *Limiter) ReleaseN(n int) {
	for range n {
		l.inUse.Add(-1)
		<-l.slots
	}
}

func (l *Limiter) Size() int  { return cap(l.slots) }
func (l *Limiter) InUse() int { return int(l.inUse.Load()) }
