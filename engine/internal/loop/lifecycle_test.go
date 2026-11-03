package loop

import (
	"context"
	"encoding/json"
	"errors"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
)

// Lifecycle fixtures use valid sealed artifacts; no training/PnL claim is derived from them.
func lifecycleFixture(t *testing.T) (*Loop, model.Artifact, model.Artifact) {
	t.Helper()
	ctx := context.Background()
	st := storetest.Open(t)
	require.NoError(t, st.UpsertAlgorithm(ctx, db.UpsertAlgorithmParams{ID: "test-learn", Family: "learning"}))
	l := &Loop{Store: st, Clock: clock.NewVirtual(day0.Add(48 * time.Hour))}
	makeModel := func(seed uint64) model.Artifact {
		recipe := weak
		recipe.Alpha = float64(seed) / 100
		m := model.Artifact{Algorithm: "test-learn", Recipe: recipe, RecipeHash: recipe.Hash(), Seed: seed, Scaler: feature.Scaler{Mean: []float64{0, 0}, Std: []float64{1, 1}}, Weights: []float64{0, 0}, AsOf: day0.Add(time.Hour)}
		m.Seal()
		require.NoError(t, m.Validate())
		body, err := m.Save()
		require.NoError(t, err)
		require.NoError(t, st.InsertArtifact(ctx, db.InsertArtifactParams{ID: m.ID, AlgorithmID: m.Algorithm, RecipeHash: m.RecipeHash, AsOf: m.AsOf, Body: body}))
		require.NoError(t, st.InTx(ctx, func(q *db.Queries) error {
			_, _, err := experiment.AddVersion(ctx, q, m.Algorithm, experiment.VersionDefinition{Strategy: experiment.RecipeStrategy, Recipe: &recipe}, experiment.Research, "fixture", "system")
			return err
		}))
		return m
	}
	a, b := makeModel(1), makeModel(2)
	require.NoError(t, experiment.ChangeLifecycle(ctx, st, "test-learn", 0, func(lc *experiment.Lifecycle) error { return lc.Activate(ctx, "test-learn@v1", a.ID, "fixture") }))
	return l, a, b
}

func recommendation(t *testing.T, l *Loop, m model.Artifact) int64 {
	t.Helper()
	ctx := context.Background()
	a, err := l.Active(ctx, "test-learn")
	require.NoError(t, err)
	cutoff, created, freeze, start := day0, day0.Add(time.Hour), day0.Add(65*time.Minute), day0.Add(2*time.Hour)
	cfg := Default()
	cfg.Algorithm = "test-learn"
	doc := Doc{Config: cfg, EvaluationVersion: eval.Version, TrainingCutoff: &cutoff, ModelCreatedAt: &created, FreezeAt: &freeze, TradeStart: &start,
		Champion: Contender{VersionID: a.VersionID, ModelID: a.Model.ID, Recipe: a.Model.Recipe, Active: true, Revision: &a.Revision}, Challenger: &Contender{ModelID: m.ID, Recipe: m.Recipe}}
	require.True(t, CurrentEvidence(doc))
	body, err := json.Marshal(doc)
	require.NoError(t, err)
	id, err := l.Store.InsertCycle(ctx, db.InsertCycleParams{AlgorithmID: "test-learn", Trigger: "manual", Doc: body, StartedAt: day0})
	require.NoError(t, err)
	c := get(t, l, id)
	c.row.State, c.row.Outcome = Decision, Recommended
	require.NoError(t, l.save(ctx, l.Store.Queries, &c))
	return id
}

func assertServingPair(t *testing.T, l *Loop, a, b model.Artifact) {
	t.Helper()
	state, err := l.Active(context.Background(), "test-learn")
	require.NoError(t, err)
	if state.Model == nil {
		require.Empty(t, state.VersionID)
		return
	}
	_, def, err := experiment.Version(context.Background(), l.Store.Queries, state.VersionID)
	require.NoError(t, err)
	require.Equal(t, def.Recipe.Hash(), state.Model.RecipeHash)
	require.Contains(t, []string{a.ID, b.ID}, state.Model.ID)
}

func TestConcurrentApproveStopAndRollbackKeepPairsConsistent(t *testing.T) {
	for _, action := range []string{"approve-stop", "approve-switch", "rollback-stop", "rollback-approve"} {
		t.Run(action, func(t *testing.T) {
			ctx := context.Background()
			l, a, b := lifecycleFixture(t)
			id := recommendation(t, l, b)
			var left, right func() error
			switch action {
			case "approve-stop":
				left = func() error { return l.Approve(ctx, id, "approve", 1) }
				right = func() error { return experiment.SetState(ctx, l.Store, "test-learn@v1", experiment.Stopped, "stop", 1) }
			case "approve-switch":
				var fixed string
				require.NoError(t, l.Store.InTx(ctx, func(q *db.Queries) error {
					var err error
					fixed, _, err = experiment.AddVersion(ctx, q, "test-learn", experiment.VersionDefinition{Strategy: "hold-cash"}, experiment.ForwardTest, "fixture", "system")
					return err
				}))
				left = func() error { return l.Approve(ctx, id, "approve", 1) }
				right = func() error { return experiment.SetState(ctx, l.Store, fixed, experiment.Active, "switch", 1) }
			default:
				require.NoError(t, l.Approve(ctx, id, "approve", 1))
				left = func() error { return l.Rollback(ctx, "test-learn", "rollback", 2) }
				if action == "rollback-stop" {
					right = func() error { return experiment.SetState(ctx, l.Store, "test-learn@v2", experiment.Stopped, "stop", 2) }
				} else {
					id = recommendation(t, l, a)
					right = func() error { return l.Approve(ctx, id, "approve", 2) }
				}
			}
			start := make(chan struct{})
			done := make(chan error, 2)
			go func() { <-start; done <- left() }()
			go func() { <-start; done <- right() }()
			close(start)
			successes := 0
			for range 2 {
				err := <-done
				if err == nil {
					successes++
				} else {
					require.ErrorIs(t, err, experiment.ErrConflict)
				}
			}
			require.Equal(t, 1, successes)
			state, err := l.Active(ctx, "test-learn")
			require.NoError(t, err)
			if state.Model == nil {
				if state.VersionID != "" {
					_, def, err := experiment.Version(ctx, l.Store.Queries, state.VersionID)
					require.NoError(t, err)
					require.Nil(t, def.Recipe)
				}
			} else {
				assertServingPair(t, l, a, b)
			}
		})
	}
}

func TestStaleChampionAndLegacyRecommendationsRemainRejectable(t *testing.T) {
	for _, legacy := range []bool{false, true} {
		t.Run(map[bool]string{false: "changed", true: "legacy"}[legacy], func(t *testing.T) {
			ctx := context.Background()
			l, _, b := lifecycleFixture(t)
			id := recommendation(t, l, b)
			if legacy {
				c := get(t, l, id)
				c.doc.Champion.Revision = nil
				require.NoError(t, l.save(ctx, l.Store.Queries, &c))
			} else {
				require.NoError(t, experiment.SetState(ctx, l.Store, "test-learn@v1", experiment.Stopped, "stop", 1))
			}
			current := lifecycleRevision(t, l)
			require.ErrorIs(t, l.Approve(ctx, id, "old evidence", current), ErrState)
			require.Equal(t, current, lifecycleRevision(t, l))
			require.Equal(t, Recommended, get(t, l, id).row.Outcome)
			require.NoError(t, l.Reject(ctx, id, "new cycle required"))
		})
	}
}

func TestPromotionFailureRollsBackPairAuditRevisionAndCycle(t *testing.T) {
	ctx := context.Background()
	l, a, b := lifecycleFixture(t)
	id := recommendation(t, l, b)
	_, err := l.Store.Pool.Exec(ctx, `CREATE FUNCTION fail_promotion() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN RAISE EXCEPTION 'injected promotion failure'; END $$;
 CREATE TRIGGER fail_promotion BEFORE INSERT ON promotions FOR EACH ROW EXECUTE FUNCTION fail_promotion()`)
	require.NoError(t, err)
	require.Error(t, l.Approve(ctx, id, "fail", 1))
	require.EqualValues(t, 1, lifecycleRevision(t, l))
	state, err := l.Active(ctx, "test-learn")
	require.NoError(t, err)
	require.Equal(t, a.ID, state.Model.ID)
	require.Equal(t, Recommended, get(t, l, id).row.Outcome)
	var n int
	require.NoError(t, l.Store.Pool.QueryRow(ctx, "SELECT count(*) FROM promotions").Scan(&n))
	require.Zero(t, n)
	events, err := l.Store.ListLifecycleEvents(ctx, "test-learn@v2")
	require.NoError(t, err)
	require.Len(t, events, 1)
}

func TestRollbackDetectsABAAndModelMismatch(t *testing.T) {
	ctx := context.Background()
	l, a, b := lifecycleFixture(t)
	id := recommendation(t, l, b)
	require.NoError(t, l.Approve(ctx, id, "approve", 1))
	require.NoError(t, experiment.SetState(ctx, l.Store, "test-learn@v2", experiment.Stopped, "stop", 2))
	require.NoError(t, experiment.ChangeLifecycle(ctx, l.Store, "test-learn", 3, func(lc *experiment.Lifecycle) error { return lc.Activate(ctx, "test-learn@v2", b.ID, "restore pair") }))
	require.ErrorIs(t, l.Rollback(ctx, "test-learn", "old promotion", 4), ErrState)
	can, err := l.CanRollback(ctx, "test-learn")
	require.NoError(t, err)
	require.False(t, can)
	require.ErrorIs(t, experiment.ChangeLifecycle(ctx, l.Store, "test-learn", 4, func(lc *experiment.Lifecycle) error { return lc.Activate(ctx, "test-learn@v1", b.ID, "wrong recipe") }), experiment.ErrState)
	require.NoError(t, experiment.SetState(ctx, l.Store, "test-learn@v1", experiment.Retired, "retire", 4))
	require.ErrorIs(t, experiment.ChangeLifecycle(ctx, l.Store, "test-learn", 5, func(lc *experiment.Lifecycle) error { return lc.Activate(ctx, "test-learn@v1", a.ID, "retired") }), experiment.ErrState)
	require.True(t, errors.Is(l.Rollback(ctx, "test-learn", "stale tab", 2), experiment.ErrConflict))
	assertServingPair(t, l, a, b)
}

func TestServingSnapshotsDuringConcurrentSwitches(t *testing.T) {
	l, a, b := lifecycleFixture(t)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	finished := make(chan error, 1)
	go func() {
		for i := range 30 {
			id, modelID := "test-learn@v1", a.ID
			if i%2 == 0 {
				id, modelID = "test-learn@v2", b.ID
			}
			err := experiment.ChangeLifecycle(ctx, l.Store, "test-learn", int64(i+1), func(lc *experiment.Lifecycle) error { return lc.Activate(ctx, id, modelID, "switch") })
			if err != nil {
				finished <- err
				return
			}
		}
		finished <- nil
	}()
	reads := 0
	for {
		assertServingPair(t, l, a, b)
		reads++
		select {
		case err := <-finished:
			require.NoError(t, err)
			require.Positive(t, reads)
			return
		default:
		}
	}
}

func TestLearningActivationCannotBypassModelIdentity(t *testing.T) {
	ctx := context.Background()
	l, a, b := lifecycleFixture(t)
	require.NoError(t, experiment.SetState(ctx, l.Store, "test-learn@v2", experiment.Validation, "prepare", 1))
	require.NoError(t, experiment.SetState(ctx, l.Store, "test-learn@v2", experiment.ForwardTest, "prepare", 2))
	require.ErrorIs(t, experiment.SetState(ctx, l.Store, "test-learn@v2", experiment.Active, "no model", 3), experiment.ErrState)
	// A valid foreign artifact with the same recipe is still not this algorithm's model.
	other := b
	other.Algorithm = "another-algorithm"
	other.Seal()
	body, err := other.Save()
	require.NoError(t, err)
	require.NoError(t, l.Store.InsertArtifact(ctx, db.InsertArtifactParams{ID: other.ID, AlgorithmID: "test-learn", RecipeHash: other.RecipeHash, AsOf: other.AsOf, Body: body}))
	require.ErrorIs(t, experiment.ChangeLifecycle(ctx, l.Store, "test-learn", 3, func(lc *experiment.Lifecycle) error {
		return lc.Activate(ctx, "test-learn@v2", other.ID, "foreign model")
	}), experiment.ErrState)
	require.EqualValues(t, 3, lifecycleRevision(t, l))
	assertServingPair(t, l, a, b)
}
