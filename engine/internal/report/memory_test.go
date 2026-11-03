package report

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

// A shared budget must protect cached and uncached work, without changing saved evidence.
func TestReportMemoryAdmissionCoversEveryExecutionPath(t *testing.T) {
	st, ds := setup(t)
	ctx := context.Background()
	n, err := jobs.WorkBytes(10_000, 10_000, 1)
	require.NoError(t, err)
	memory := jobs.NewMemory(n)
	svc := Service{Store: st, Parallel: 1, Memory: memory, Cache: NewDatasetCache(1)}
	id, err := svc.Create(ctx, spec(ds))
	require.NoError(t, err)
	require.Zero(t, memory.InUse())
	before, err := svc.Load(ctx, id)
	require.NoError(t, err)
	release, err := svc.ReserveWork(ctx, []string{ds}, 1)
	require.NoError(t, err)
	other := svc // separate handler, same process-wide pool
	_, err = other.Create(ctx, spec(ds))
	require.ErrorIs(t, err, jobs.ErrMemory)
	require.ErrorIs(t, other.CreateWithID(ctx, "another", spec(ds)), jobs.ErrMemory)
	_, err = other.Reproduce(ctx, id)
	require.ErrorIs(t, err, jobs.ErrMemory)
	_, _, err = other.Recalculate(ctx, id, before.Spec.Sim, money.RatioOne)
	require.ErrorIs(t, err, jobs.ErrMemory)
	require.Equal(t, n, memory.InUse(), "no rejected call releases the admitted owner's reservation")
	// Idempotent completion and historical reads do not require a new simulation.
	require.NoError(t, other.CreateWithID(ctx, id, spec(ds)))
	after, err := other.Load(ctx, id)
	require.NoError(t, err)
	require.Equal(t, before.Row.Evaluation, after.Row.Evaluation)
	release()
	bad := spec(ds)
	bad.Strategy = "missing"
	_, err = svc.Create(ctx, bad)
	require.ErrorIs(t, err, strategy.ErrUnknown)
	require.Zero(t, memory.InUse(), "admitted evaluation errors release capacity")
	same, err := svc.Reproduce(ctx, id)
	require.NoError(t, err)
	require.True(t, same)
	require.Zero(t, memory.InUse())
	// Incomplete metadata is enough for admission; a rejected job must never parse its manifest.
	require.NoError(t, st.InsertDataset(ctx, db.InsertDatasetParams{ID: "invalid-manifest", Symbol: "BTCUSDT", Timeframe: "1m", RangeFrom: t0, RangeTo: t0.Add(10_000 * time.Minute), GapPolicy: string(data.GapFlag), KnownAt: t0, Manifest: []byte(`{}`)}))
	blocked := svc
	blocked.Memory = jobs.NewMemory(1)
	_, err = blocked.Create(ctx, spec("invalid-manifest"))
	require.ErrorIs(t, err, jobs.ErrMemory)
}
