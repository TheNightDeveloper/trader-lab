package search

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
)

func claimedFixture(t *testing.T, s *store.Store) db.Attempt {
	ctx := context.Background()
	require.NoError(t, s.InsertExperiment(ctx, db.InsertExperimentParams{ID: "ownership-test", Name: "test", Definition: []byte(`{}`)}))
	_, err := s.CopyAttempts(ctx, []db.CopyAttemptsParams{{ExperimentID: "ownership-test", Seq: 1, Candidate: 1, Params: []byte(`{}`), DatasetID: "unused", Symbol: "BTCUSDT", Status: "queued"}})
	require.NoError(t, err)
	a, err := s.ClaimAttempt(ctx, "original-claim")
	require.NoError(t, err)
	return a
}

func TestCancellationBeforeWorkerRegistrationIsDurable(t *testing.T) {
	s := storetest.Open(t)
	ctx := context.Background()
	a := claimedFixture(t, s)
	sch := &Scheduler{Store: s}
	sch.init()
	require.NoError(t, experiment.Cancel(ctx, s, a.ExperimentID))
	sch.Cancel(a.ExperimentID) // notification arrives before handler registration
	sch.run(ctx, a)
	rows, err := s.AllAttempts(ctx, a.ExperimentID)
	require.NoError(t, err)
	require.Equal(t, "cancelled", rows[0].Status)
	require.NotNil(t, rows[0].FinishedAt)
	require.Empty(t, rows[0].ClaimToken)
	e, err := s.GetExperiment(ctx, a.ExperimentID)
	require.NoError(t, err)
	require.NotNil(t, e.FinishedAt)
	require.Nil(t, rows[0].Metrics, "stale work never starts evaluation or writes a result")
	require.EqualValues(t, 1, rows[0].Runs)
}

func TestOldClaimCannotCompleteOrCancelNewExecution(t *testing.T) {
	s := storetest.Open(t)
	ctx := context.Background()
	a := claimedFixture(t, s)
	_, err := s.RequeueRunning(ctx)
	require.NoError(t, err)
	next, err := s.ClaimAttempt(ctx, "retry-claim")
	require.NoError(t, err)
	require.EqualValues(t, 2, next.Runs)
	complete := db.CompleteAttemptParams{ExperimentID: a.ExperimentID, Seq: a.Seq, ClaimToken: a.ClaimToken, Metrics: []byte(`[]`), Violations: []byte(`[]`)}
	require.NoError(t, s.CompleteAttempt(ctx, complete))
	require.NoError(t, s.EndAttempt(ctx, db.EndAttemptParams{ExperimentID: a.ExperimentID, Seq: a.Seq, ClaimToken: a.ClaimToken, Status: "cancelled", Failure: "stale"}))
	owned, err := s.GetClaimedAttempt(ctx, db.GetClaimedAttemptParams{ExperimentID: next.ExperimentID, Seq: next.Seq, ClaimToken: next.ClaimToken})
	require.NoError(t, err)
	require.Nil(t, owned.Metrics)
	complete.ClaimToken = next.ClaimToken
	require.NoError(t, s.CompleteAttempt(ctx, complete))
	rows, err := s.AllAttempts(ctx, a.ExperimentID)
	require.NoError(t, err)
	require.Len(t, rows, 1)
	require.Equal(t, "done", rows[0].Status)
	require.EqualValues(t, 2, rows[0].Runs)
}

func TestRecoveryRespectsExperimentTerminalState(t *testing.T) {
	for _, status := range []string{"running", "paused", "cancelled", "failed", "done", "finalizing"} {
		t.Run(status, func(t *testing.T) {
			s := storetest.Open(t)
			ctx := context.Background()
			a := claimedFixture(t, s)
			_, err := s.Pool.Exec(ctx, "UPDATE experiments SET status=$2 WHERE id=$1", a.ExperimentID, status)
			require.NoError(t, err)
			_, err = s.RequeueRunning(ctx)
			require.NoError(t, err)
			rows, err := s.AllAttempts(ctx, a.ExperimentID)
			require.NoError(t, err)
			if status == "running" || status == "paused" {
				require.Equal(t, "queued", rows[0].Status)
				require.Nil(t, rows[0].FinishedAt)
			} else {
				require.Equal(t, "cancelled", rows[0].Status)
				require.NotNil(t, rows[0].FinishedAt)
			}
			require.Empty(t, rows[0].ClaimToken)
			require.EqualValues(t, 1, rows[0].Runs)
		})
	}
}

func TestSecondSchedulerCannotRecoverLiveClaims(t *testing.T) {
	s := storetest.Open(t)
	ctx := context.Background()
	a := claimedFixture(t, s)
	first := &Scheduler{Store: s}
	lease, err := first.acquireLease(ctx)
	require.NoError(t, err)
	defer func() { _ = lease.Close(ctx) }()
	require.ErrorContains(t, (&Scheduler{Store: s}).Run(ctx), "scheduler already running")
	_, err = s.GetClaimedAttempt(ctx, db.GetClaimedAttemptParams{ExperimentID: a.ExperimentID, Seq: a.Seq, ClaimToken: a.ClaimToken})
	require.NoError(t, err, "second startup cannot invalidate a live process's token")
}
