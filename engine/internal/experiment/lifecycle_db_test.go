package experiment

import (
	"context"
	"errors"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/stretchr/testify/require"
	"sync/atomic"
	"testing"
	"time"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
)

func TestLibraryStopClearsActiveModel(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, SeedLibrary(ctx, st))
	// Isolate a historical inconsistency without fitting a model or changing real records.
	require.NoError(t, st.InsertArtifact(ctx, db.InsertArtifactParams{ID: "fixture", AlgorithmID: "ridge-h4", Body: []byte(`{}`), AsOf: time.Now()}))
	require.NoError(t, st.SetVersionState(ctx, db.SetVersionStateParams{ID: "ridge-h4@v1", State: Active}))
	require.NoError(t, st.SetActiveModel(ctx, db.SetActiveModelParams{ID: "ridge-h4", ActiveModel: pgtype.Text{String: "fixture", Valid: true}}))
	require.NoError(t, SetState(ctx, st, "ridge-h4@v1", Stopped, "stop", 0))
	a, err := st.GetAlgorithm(ctx, "ridge-h4")
	require.NoError(t, err)
	require.False(t, a.ActiveModel.Valid, "a stopped version must not keep a serving model")
}

func TestLibraryMutationWaitsForAlgorithmLock(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, SeedLibrary(ctx, st))
	require.NoError(t, SetState(ctx, st, "trend-ema@v1", Validation, "prepare", 0))
	require.NoError(t, SetState(ctx, st, "trend-ema@v1", ForwardTest, "prepare", 1))
	tx, err := st.Pool.Begin(ctx)
	require.NoError(t, err)
	t.Cleanup(func() { _ = tx.Rollback(ctx) })
	_, err = tx.Exec(ctx, "SELECT id FROM algorithms WHERE id='trend-ema' FOR UPDATE")
	require.NoError(t, err)
	waiting, cancel := context.WithTimeout(ctx, 150*time.Millisecond)
	defer cancel()
	require.Error(t, SetState(waiting, st, "trend-ema@v1", Active, "must wait", 2), "every mutation must honor the shared algorithm lock")
}

func TestConcurrentActivationAndStaleABA(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, SeedLibrary(ctx, st))
	_, def, err := Version(ctx, st.Queries, "trend-ema@v1")
	require.NoError(t, err)
	def.Params[0].Default++
	var other string
	require.NoError(t, st.InTx(ctx, func(q *db.Queries) error {
		var err error
		other, _, err = AddVersion(ctx, q, "trend-ema", def, ForwardTest, "fixture", "system")
		return err
	}))
	require.NoError(t, SetState(ctx, st, "trend-ema@v1", Validation, "prepare", 0))
	require.NoError(t, SetState(ctx, st, "trend-ema@v1", ForwardTest, "prepare", 1))
	start := make(chan struct{})
	results := make(chan error, 2)
	for _, id := range []string{"trend-ema@v1", other} {
		go func() { <-start; results <- SetState(ctx, st, id, Active, "activate", 2) }()
	}
	close(start)
	var successes int
	for range 2 {
		err := <-results
		if err == nil {
			successes++
		} else {
			require.ErrorIs(t, err, ErrConflict)
		}
	}
	require.Equal(t, 1, successes)
	snap, err := Snapshot(ctx, st, "trend-ema")
	require.NoError(t, err)
	require.EqualValues(t, 3, snap.Algorithm.LifecycleRevision)
	serving := ""
	for _, v := range snap.Versions {
		if v.State == Active {
			require.Empty(t, serving)
			serving = v.ID
		}
	}
	require.NotEmpty(t, serving)
	// Return to the same serving version; an old request still must not pass (ABA).
	require.NoError(t, SetState(ctx, st, serving, Stopped, "stop", 3))
	for i, to := range []string{Research, Validation, ForwardTest, Active} {
		require.NoError(t, SetState(ctx, st, serving, to, "restart", int64(4+i)))
	}
	require.ErrorIs(t, SetState(ctx, st, serving, Stopped, "old tab", 3), ErrConflict)
	// The database independently rejects two active versions.
	target := "trend-ema@v1"
	if serving == target {
		target = other
	}
	require.Error(t, st.SetVersionState(ctx, db.SetVersionStateParams{ID: target, State: Active}))
	a, err := st.GetAlgorithm(ctx, "trend-ema")
	require.NoError(t, err)
	require.EqualValues(t, 8, a.LifecycleRevision)
}

func TestLifecycleRollbackAndVersionAllocation(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, SeedLibrary(ctx, st))
	before, err := st.ListLifecycleEvents(ctx, "trend-ema@v1")
	require.NoError(t, err)
	failure := errors.New("injected failure")
	require.ErrorIs(t, ChangeLifecycle(ctx, st, "trend-ema", 0, func(l *Lifecycle) error {
		if err := l.Activate(ctx, "trend-ema@v1", "", "fixture"); err != nil {
			return err
		}
		return failure
	}), failure)
	after, err := st.ListLifecycleEvents(ctx, "trend-ema@v1")
	require.NoError(t, err)
	require.Equal(t, before, after)
	snap, err := Snapshot(ctx, st, "trend-ema")
	require.NoError(t, err)
	require.Zero(t, snap.Algorithm.LifecycleRevision)
	require.Nil(t, snap.Model)
	_, def, err := Version(ctx, st.Queries, "trend-ema@v1")
	require.NoError(t, err)
	def.Params[0].Default++
	start := make(chan struct{})
	results := make(chan error, 6)
	var created atomic.Int32
	for range 6 {
		go func() {
			<-start
			results <- st.InTx(ctx, func(q *db.Queries) error {
				_, fresh, err := AddVersion(ctx, q, "trend-ema", def, Research, "fixture", "system")
				if fresh {
					created.Add(1)
				}
				return err
			})
		}()
	}
	close(start)
	for range 6 {
		require.NoError(t, <-results)
	}
	require.EqualValues(t, 1, created.Load())
}
