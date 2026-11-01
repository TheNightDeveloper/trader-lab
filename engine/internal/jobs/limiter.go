// Package jobs limits research work. Control work (API, health, live ingestion)
// runs outside the limiter, so it is never starved: research can occupy at most
// its share of the CPUs.
package jobs

import (
	"context"
	"sync/atomic"

	"golang.org/x/sync/semaphore"
)

// Limiter admits weighted requests atomically in arrival order.
type Limiter struct {
	slots int
	sem   *semaphore.Weighted
	inUse atomic.Int32
}

// ResearchSlots is the research share of cpus (percent, 1..100), at least 1 and,
// with more than one CPU, at most cpus-1 so control work always has a core.
func ResearchSlots(cpus, percent int) int {
	n := cpus * percent / 100
	if cpus > 1 {
		n = min(n, cpus-1)
	}
	return max(1, n)
}

func NewLimiter(slots int) *Limiter {
	slots = max(1, slots)
	return &Limiter{slots: slots, sem: semaphore.NewWeighted(int64(slots))}
}

// Acquire waits for one research slot or cancellation.
func (l *Limiter) Acquire(ctx context.Context) error { return l.acquire(ctx, 1) }

// AcquireAll waits for every slot without holding a partial reservation.
// The weighted semaphore queues smaller requests behind it to prevent starvation.
func (l *Limiter) AcquireAll(ctx context.Context) error { return l.acquire(ctx, l.Size()) }

func (l *Limiter) acquire(ctx context.Context, n int) error {
	if err := l.sem.Acquire(ctx, int64(n)); err != nil {
		return err
	}
	l.inUse.Add(int32(n))
	return nil
}

func (l *Limiter) Release() { l.ReleaseN(1) }

func (l *Limiter) ReleaseN(n int) {
	l.inUse.Add(-int32(n))
	l.sem.Release(int64(n))
}

func (l *Limiter) Size() int  { return l.slots }
func (l *Limiter) InUse() int { return int(l.inUse.Load()) }
