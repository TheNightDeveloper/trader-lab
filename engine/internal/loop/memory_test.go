package loop

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/jobs"
)

// Rejected collection is terminal; a forward poll can retry once capacity returns.
func TestLearningMemoryAdmissionPreservesServingPairAndForward(t *testing.T) {
	_, l, clk := setup(t)
	ctx := context.Background()
	version, modelID := active(t, l)
	l.Memory = jobs.NewMemory(1)
	id, err := l.Begin(ctx, "manual")
	require.NoError(t, err)
	require.ErrorIs(t, l.RunCycle(ctx, id), jobs.ErrMemory)
	c := get(t, l, id)
	require.Equal(t, Failed, c.row.Outcome)
	require.Empty(t, c.doc.Datasets, "reject before reconstructing raw input")
	require.Zero(t, l.Limiter.InUse())
	require.Zero(t, l.Memory.InUse())
	v, m := active(t, l)
	require.Equal(t, [2]string{version, modelID}, [2]string{v, m})

	l.Memory = jobs.NewMemory(512 << 20)
	id, err = l.Begin(ctx, "manual")
	require.NoError(t, err)
	require.NoError(t, l.RunCycle(ctx, id))
	require.Equal(t, ForwardTest, get(t, l, id).row.State)
	require.Zero(t, l.Memory.InUse(), "frozen models do not retain the training workspace")
	require.NoError(t, clk.Set(clk.Now().Add(25*time.Hour)))
	l.Memory = jobs.NewMemory(1)
	require.ErrorIs(t, l.Advance(ctx), jobs.ErrMemory)
	require.Equal(t, ForwardTest, get(t, l, id).row.State)
	require.Zero(t, l.Limiter.InUse())
	require.Zero(t, l.Memory.InUse())
	l.Memory = jobs.NewMemory(512 << 20)
	require.NoError(t, l.Advance(ctx))
	require.Equal(t, 1, get(t, l, id).doc.Forward.Days)
	require.Zero(t, l.Memory.InUse())
	v, m = active(t, l)
	require.Equal(t, [2]string{version, modelID}, [2]string{v, m})
}
