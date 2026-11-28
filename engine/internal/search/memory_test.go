package search

import (
	"context"
	"testing"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
)

// Malformed manifests/definitions prove rejection precedes both materialization and cache use.
func TestSearchMemoryRejectionIsRecordedBeforeLoading(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	a := claimedFixture(t, st)
	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	require.NoError(t, st.InsertDataset(ctx, db.InsertDatasetParams{ID: a.DatasetID, Symbol: "BTCUSDT", Timeframe: "1h", RangeFrom: from, RangeTo: from.Add(time.Hour), GapPolicy: "flag", KnownAt: from, Manifest: []byte(`{}`)}))
	memory := jobs.NewMemory(1)
	sch := &Scheduler{Store: st, Reports: report.Service{Store: st, Memory: memory}}
	sch.init()
	sch.run(ctx, a)
	rows, err := st.AllAttempts(ctx, a.ExperimentID)
	require.NoError(t, err)
	require.Equal(t, "failed", rows[0].Status)
	require.Contains(t, rows[0].Failure, jobs.ErrMemory.Error())
	require.NotNil(t, rows[0].FinishedAt)
	_, err = st.GetClaimedAttempt(ctx, db.GetClaimedAttemptParams{ExperimentID: a.ExperimentID, Seq: a.Seq, ClaimToken: a.ClaimToken})
	require.ErrorIs(t, err, pgx.ErrNoRows, "a retained audit token cannot authorize terminal work")
	require.Nil(t, rows[0].Metrics)
	require.Zero(t, memory.InUse())
}

func TestSearchDefersMemoryContentionWithoutSpendingClaim(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	a := claimedFixture(t, st)
	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	require.NoError(t, st.InsertDataset(ctx, db.InsertDatasetParams{
		ID: a.DatasetID, Symbol: "BTCUSDT", Timeframe: "1m", RangeFrom: from,
		RangeTo: from.Add(time.Minute), GapPolicy: "flag", KnownAt: from, Manifest: []byte(`{}`),
	}))
	n, err := jobs.WorkBytes(1, 1, 1)
	require.NoError(t, err)
	memory := jobs.NewMemory(n)
	release, err := memory.Reserve(ctx, n)
	require.NoError(t, err)
	defer release()
	sch := &Scheduler{Store: st, Reports: report.Service{Store: st, Memory: memory}}
	sch.init()
	require.True(t, sch.run(ctx, a), "the scheduler backs off after a temporary deferral")
	rows, err := st.AllAttempts(ctx, a.ExperimentID)
	require.NoError(t, err)
	require.Equal(t, "queued", rows[0].Status)
	require.Empty(t, rows[0].ClaimToken)
	require.Nil(t, rows[0].StartedAt)
	require.Nil(t, rows[0].FinishedAt)
	require.Empty(t, rows[0].Failure)
	require.Equal(t, n, memory.InUse())

	release()
	next, err := st.ClaimAttempt(ctx, "fresh-after-memory")
	require.NoError(t, err)
	require.Equal(t, a.Seq, next.Seq)
	require.Equal(t, a.Runs, next.Runs, "the deferred claim ran no evaluation")
	require.False(t, sch.run(ctx, a), "the old claim cannot affect the resumed attempt")
	_, err = st.GetClaimedAttempt(ctx, db.GetClaimedAttemptParams{ExperimentID: next.ExperimentID, Seq: next.Seq, ClaimToken: next.ClaimToken})
	require.NoError(t, err)
}
