package jobs

import (
	"context"
	"math"
	"sync"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestMemoryAtomicAdmissionAndRelease(t *testing.T) {
	ctx := context.Background()
	m := NewMemory(100)
	release, err := m.Reserve(ctx, 60)
	require.NoError(t, err)
	_, err = m.Reserve(ctx, 41)
	require.ErrorIs(t, err, ErrMemory)
	require.EqualValues(t, 60, m.InUse(), "failure cannot leave a partial reservation")
	last, err := m.Reserve(ctx, 40)
	require.NoError(t, err)
	require.EqualValues(t, 100, m.InUse())
	release()
	release() // deferred and explicit cleanup must not underflow another owner's usage
	require.EqualValues(t, 40, m.InUse())
	last()
	require.Zero(t, m.InUse())
	for _, n := range []int64{0, -1, 101, math.MaxInt64} {
		_, err := m.Reserve(ctx, n)
		require.ErrorIs(t, err, ErrMemory)
	}
	cancelled, cancel := context.WithCancel(ctx)
	cancel()
	_, err = m.Reserve(cancelled, 1)
	require.ErrorIs(t, err, context.Canceled)
	require.Zero(t, m.InUse())
}

func TestMemoryConcurrentOwnersNeverExceedBudget(t *testing.T) {
	m := NewMemory(80)
	var wg sync.WaitGroup
	var admitted sync.WaitGroup
	admitted.Add(80)
	finish := make(chan struct{})
	for range 80 {
		wg.Go(func() {
			release, err := m.Reserve(context.Background(), 2)
			admitted.Done()
			if err == nil {
				<-finish
				release()
			}
		})
	}
	admitted.Wait()
	require.EqualValues(t, 80, m.InUse(), "exactly forty owners fit; others reject without waiting")
	close(finish)
	wg.Wait()
	require.Zero(t, m.InUse())
}

func TestWorkBytesChecksOverflowAndRetainedResults(t *testing.T) {
	n, err := WorkBytes(100, 2, 3)
	require.NoError(t, err)
	require.EqualValues(t, 1<<20+100*1024+2*8192*5, n)
	for _, v := range [][3]int64{{-1, 1, 1}, {1, -1, 1}, {1, 1, 0}, {math.MaxInt64, 1, 1}, {1, math.MaxInt64, 1}, {1, 1, math.MaxInt64}} {
		_, err := WorkBytes(v[0], v[1], v[2])
		require.ErrorIs(t, err, ErrMemory, v)
	}
}
