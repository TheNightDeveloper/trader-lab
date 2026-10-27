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
