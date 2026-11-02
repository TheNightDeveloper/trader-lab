package api

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/store/storetest"
)

// Admission must precede even the database read, including a cancelled free slot.
func TestReproduceRespectsAdmission(t *testing.T) {
	lim := jobs.NewLimiter(2)
	require.NoError(t, lim.Acquire(context.Background()))
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	h := Report{Limiter: lim}
	require.NotPanics(t, func() {
		_, err := h.Reproduce(ctx, connect.NewRequest(&labv1.ReproduceRequest{ReportId: "unused"}))
		require.ErrorIs(t, err, context.Canceled)
	})
	require.Equal(t, 1, lim.InUse(), "a failed waiter cannot release another job's slot")
	lim.Release()
}

func TestReproduceWaitsForWholeResearchShareAndReleasesOnError(t *testing.T) {
	lim := jobs.NewLimiter(2)
	require.NoError(t, lim.Acquire(context.Background()))
	ctx, cancel := context.WithTimeout(context.Background(), 100*time.Millisecond)
	defer cancel()
	h := Report{Limiter: lim}
	require.NotPanics(t, func() {
		_, err := h.Reproduce(ctx, connect.NewRequest(&labv1.ReproduceRequest{}))
		require.ErrorIs(t, err, context.DeadlineExceeded, "one free slot cannot admit a parallel evaluation")
	})
	require.Equal(t, 1, lim.InUse())
	lim.Release()
	h.Svc = report.Service{Store: storetest.Open(t)}
	_, err := h.Reproduce(context.Background(), connect.NewRequest(&labv1.ReproduceRequest{ReportId: "missing"}))
	require.Equal(t, connect.CodeNotFound, connect.CodeOf(err))
	require.Zero(t, lim.InUse(), "an admitted database error releases every acquired slot")
}
