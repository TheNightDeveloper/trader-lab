package jobs

import (
	"context"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func TestResearchSlots(t *testing.T) {
	require.Equal(t, 6, ResearchSlots(8, 75))
	require.Equal(t, 7, ResearchSlots(8, 100), "always leave one core to control work")
	require.Equal(t, 1, ResearchSlots(1, 100))
	require.Equal(t, 1, ResearchSlots(8, 1))
}

func TestLimiterNeverExceedsSlots(t *testing.T) {
	l := NewLimiter(3)
	var peak, cur atomic.Int32
	var wg sync.WaitGroup
	for range 50 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			require.NoError(t, l.Acquire(context.Background()))
			n := cur.Add(1)
			for p := peak.Load(); n > p && !peak.CompareAndSwap(p, n); p = peak.Load() {
			}
			time.Sleep(time.Millisecond)
			cur.Add(-1)
			l.Release()
		}()
	}
	wg.Wait()
	require.LessOrEqual(t, peak.Load(), int32(3))
	require.Zero(t, l.InUse())

	require.NoError(t, l.AcquireAll(context.Background()))
	require.Equal(t, 3, l.InUse())
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Millisecond)
	defer cancel()
	require.Error(t, l.Acquire(ctx), "full: waits until ctx ends")
	l.ReleaseN(l.Size())
	require.Zero(t, l.InUse())
}

// Exclusive waiters must not reserve partial capacity while another job runs.
func TestExclusiveAdmissionIsAtomic(t *testing.T) {
	l := NewLimiter(3)
	require.NoError(t, l.Acquire(context.Background()))
	ctx, cancel := context.WithTimeout(context.Background(), 100*time.Millisecond)
	defer cancel()
	done := make(chan error, 1)
	go func() { done <- l.AcquireAll(ctx) }()
	require.ErrorIs(t, <-done, context.DeadlineExceeded)
	require.Equal(t, 1, l.InUse(), "cancellation releases all reserved capacity")
	l.Release()
	require.NoError(t, l.AcquireAll(context.Background()))
	l.ReleaseN(l.Size())
}

// Two full evaluations and small jobs must all make progress under contention.
func TestConcurrentExclusiveJobsFinish(t *testing.T) {
	l := NewLimiter(3)
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	require.NoError(t, l.Acquire(ctx))
	errs := make(chan error, 2)
	for range 2 {
		go func() {
			err := l.AcquireAll(ctx)
			if err == nil {
				l.ReleaseN(l.Size())
			}
			errs <- err
		}()
	}
	// Blocked exclusive requests must leave the single held slot as the only usage.
	time.Sleep(20 * time.Millisecond)
	require.Equal(t, 1, l.InUse())
	l.Release()
	for range 2 {
		require.NoError(t, <-errs)
	}
	require.Zero(t, l.InUse())
}

func TestCancelledAdmissionNeverTakesCapacity(t *testing.T) {
	l := NewLimiter(3)
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	require.ErrorIs(t, l.Acquire(ctx), context.Canceled)
	require.ErrorIs(t, l.AcquireAll(ctx), context.Canceled)
	require.Zero(t, l.InUse())
}
