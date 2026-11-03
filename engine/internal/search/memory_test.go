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
