package loop

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/model/train"
)

func TestTrainingDeadlineBoundsAllSlotsAndPreservesCancellation(t *testing.T) {
	before := time.Now()
	ctx, cancel := trainingDeadline(context.Background(), time.Second, 4)
	defer cancel()
	deadline, ok := ctx.Deadline()
	require.True(t, ok)
	require.WithinDuration(t, before.Add(250*time.Millisecond), deadline, 50*time.Millisecond)
	expired, stop := trainingDeadline(context.Background(), 0, 2)
	defer stop()
	<-expired.Done()
	require.ErrorIs(t, context.Cause(expired), errBudget)
	l := &Loop{Limiter: jobs.NewLimiter(2)}
	l.parallel(expired, 5, func(int) { t.Error("expired budget started work") })
	require.Zero(t, l.Limiter.InUse())
	// Cancellation after admission must release the acquired slot as well.
	admitted, cancelFit := context.WithCancel(context.Background())
	defer cancelFit()
	l.parallel(admitted, 1, func(int) {
		if l.Limiter.InUse() != 1 {
			t.Error("fit did not hold its research slot")
		}
		cancelFit()
		_, err := train.Fit(admitted, model.Recipe{}, nil, time.Time{}, time.Time{}, time.Time{}, train.Meta{})
		if !errors.Is(err, context.Canceled) {
			t.Errorf("cancelled fit: %v", err)
		}
	})
	require.Zero(t, l.Limiter.InUse())
	parent, end := context.WithCancel(context.Background())
	child, closeChild := trainingDeadline(parent, time.Hour, 1)
	defer closeChild()
	end()
	require.ErrorIs(t, context.Cause(child), context.Canceled)
}
