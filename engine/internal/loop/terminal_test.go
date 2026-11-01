package loop

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/store/db"
)

func TestTerminalCycleAndCandidatesCommitTogether(t *testing.T) {
	st, l, _ := setup(t)
	ctx := context.Background()
	id, err := l.Begin(ctx, "manual")
	require.NoError(t, err)
	for i := 1; i <= 3; i++ {
		require.NoError(t, st.InsertCandidate(ctx, db.InsertCandidateParams{CycleID: id, Seq: int32(i), Change: "test", Recipe: []byte(`{}`), RecipeHash: "test"}))
	}
	require.NoError(t, st.EndCandidate(ctx, db.EndCandidateParams{CycleID: id, Seq: 1, Status: "done", Result: []byte(`{"eligible":true}`)}))
	// A failed final row update must roll back candidate cancellation as well.
	_, err = st.Pool.Exec(ctx, `CREATE FUNCTION reject_finish() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN RAISE EXCEPTION 'test rollback'; END $$;
CREATE TRIGGER reject_finish BEFORE UPDATE ON learning_cycles FOR EACH ROW EXECUTE FUNCTION reject_finish();`)
	require.NoError(t, err)
	c := get(t, l, id)
	require.Error(t, l.finish(&c, Failed, "interrupted"))
	rows, err := st.ListCandidates(ctx, id)
	require.NoError(t, err)
	require.Equal(t, "queued", rows[1].Status)
	require.Equal(t, Collect, get(t, l, id).row.State)
	_, err = st.Pool.Exec(ctx, `DROP TRIGGER reject_finish ON learning_cycles`)
	require.NoError(t, err)
	require.NoError(t, l.finish(&c, Failed, "interrupted"))
	rows, err = st.ListCandidates(ctx, id)
	require.NoError(t, err)
	require.Equal(t, Done, get(t, l, id).row.State)
	require.Equal(t, 3, get(t, l, id).doc.Candidates, "partial generation stays visible after terminalization")
	require.Equal(t, 1, get(t, l, id).doc.Eligible, "eligibility also comes from completed durable results")
	require.Equal(t, "done", rows[0].Status)
	require.JSONEq(t, `{"eligible":true}`, string(rows[0].Result))
	for _, r := range rows[1:] {
		require.Equal(t, "cancelled", r.Status)
		require.Equal(t, "interrupted", r.Failure)
	}
	// A stale result arriving after terminalization cannot revive a candidate.
	require.NoError(t, st.EndCandidate(ctx, db.EndCandidateParams{CycleID: id, Seq: 2, Status: "done", Result: []byte(`{}`)}))
	rows, err = st.ListCandidates(ctx, id)
	require.NoError(t, err)
	require.Equal(t, "cancelled", rows[1].Status)
}

func TestSplitFailureAndRestartLeaveNoQueuedCandidates(t *testing.T) {
	for _, scenario := range []string{"split_failure", "restart"} {
		t.Run(scenario, func(t *testing.T) {
			st, l, _ := setup(t)
			ctx := context.Background()
			id, err := l.Begin(ctx, "manual")
			require.NoError(t, err)
			c := get(t, l, id)
			if scenario == "split_failure" {
				c.doc.Config.LookbackDays = 2
				c.doc.Config.Folds = 20
				c.doc.Config.MinFreshBars = 1
				require.NoError(t, l.save(ctx, st.Queries, &c))
				require.NoError(t, l.RunCycle(ctx, id))
				require.Equal(t, Skipped, get(t, l, id).row.Outcome)
			} else {
				require.NoError(t, st.InsertCandidate(ctx, db.InsertCandidateParams{CycleID: id, Seq: 1, Change: "test", Recipe: []byte(`{}`), RecipeHash: "test"}))
				c.row.State = Train
				require.NoError(t, l.save(ctx, st.Queries, &c))
				runCtx, cancel := context.WithTimeout(ctx, 100*time.Millisecond)
				defer cancel()
				require.NoError(t, l.Run(runCtx))
				require.Equal(t, Failed, get(t, l, id).row.Outcome)
			}
			rows, err := st.ListCandidates(ctx, id)
			require.NoError(t, err)
			require.NotEmpty(t, rows)
			require.Equal(t, len(rows), get(t, l, id).doc.Candidates)
			for _, r := range rows {
				require.Equal(t, "cancelled", r.Status)
				require.NotEmpty(t, r.Failure)
			}
		})
	}
}
