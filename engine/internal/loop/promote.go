package loop

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/store/db"
)

// Approve is the user's promotion of a recommended challenger: its recipe becomes
// the active version (a new version when the recipe is new) and its frozen model
// the active model. The previous pair is recorded for rollback.
func (l *Loop) Approve(ctx context.Context, id int64, note string, expected int64) error {
	row, err := l.Store.GetCycle(ctx, id)
	if err != nil {
		return fmt.Errorf("%w: cycle %d", ErrNotFound, id)
	}
	// Lock order is algorithm, then cycle, shared with library/rollback writers.
	return experiment.ChangeLifecycle(ctx, l.Store, row.AlgorithmID, expected, func(lifecycle *experiment.Lifecycle) error {
		q := lifecycle.Q
		c, err := l.decided(ctx, q, id)
		if err != nil {
			return err
		}
		if !CurrentEvidence(c.doc) || c.doc.Challenger == nil {
			return fmt.Errorf("%w: legacy evidence requires a new learning cycle", ErrState)
		}
		alg := c.row.AlgorithmID
		a := lifecycle.Algorithm
		if c.doc.Champion.Revision == nil || *c.doc.Champion.Revision != a.LifecycleRevision {
			return fmt.Errorf("%w: champion changed since evaluation; run a new cycle", ErrState)
		}
		prevVersion, err := lifecycle.ActiveVersion(ctx)
		if err != nil {
			return err
		}
		why := fmt.Sprintf("ارتقا با تأیید کاربر پس از دروازه چرخه #%d", id)
		if note != "" {
			why += " — " + note
		}
		ch := c.doc.Challenger
		vid, _, err := experiment.AddVersion(ctx, q, alg, experiment.VersionDefinition{Strategy: experiment.RecipeStrategy, Recipe: &ch.Recipe}, experiment.Research, why, "user")
		if err != nil {
			return err
		}
		if err := lifecycle.Activate(ctx, vid, ch.ModelID, why); err != nil {
			return err
		}
		if err := q.InsertPromotion(ctx, db.InsertPromotionParams{
			AlgorithmID: alg, Action: "promote", VersionID: vid, ModelID: ch.ModelID,
			PrevVersionID: text(prevVersion), PrevModelID: a.ActiveModel, CycleID: &id, Note: note, LifecycleRevision: expected + 1,
		}); err != nil {
			return err
		}
		return l.close(ctx, q, &c, Approved, why)
	})
}

// Reject is the user's refusal of a recommended challenger. Nothing changes.
func (l *Loop) Reject(ctx context.Context, id int64, note string) error {
	return l.Store.InTx(ctx, func(q *db.Queries) error {
		c, err := l.decided(ctx, q, id)
		if err != nil {
			return err
		}
		why := "رد با تصمیم کاربر"
		if note != "" {
			why += " — " + note
		}
		return l.close(ctx, q, &c, Rejected, why)
	})
}

// Rollback restores the version and model that the last promotion replaced. It
// refuses when the active pair has changed since (e.g. in the library).
func (l *Loop) Rollback(ctx context.Context, alg, note string, expected int64) error {
	return experiment.ChangeLifecycle(ctx, l.Store, alg, expected, func(lifecycle *experiment.Lifecycle) error {
		q := lifecycle.Q
		last, err := q.LastPromotion(ctx, alg)
		if errors.Is(err, pgx.ErrNoRows) {
			return fmt.Errorf("%w: %s has no promotion to roll back", ErrState, alg)
		}
		if err != nil {
			return err
		}
		if !last.PrevModelID.Valid || !last.PrevVersionID.Valid {
			return fmt.Errorf("%w: there was no active model before the last promotion", ErrState)
		}
		a := lifecycle.Algorithm
		cur, err := lifecycle.ActiveVersion(ctx)
		if err != nil {
			return err
		}
		if cur != last.VersionID || a.ActiveModel.String != last.ModelID || last.LifecycleRevision != a.LifecycleRevision {
			return fmt.Errorf("%w: the active version changed since the last promotion", ErrState)
		}
		why := "بازگشت به نسخه و مدل پیشین با تصمیم کاربر"
		if note != "" {
			why += " — " + note
		}
		if err := lifecycle.Activate(ctx, last.PrevVersionID.String, last.PrevModelID.String, why); err != nil {
			return err
		}
		return q.InsertPromotion(ctx, db.InsertPromotionParams{
			AlgorithmID: alg, Action: "rollback", VersionID: last.PrevVersionID.String, ModelID: last.PrevModelID.String,
			PrevVersionID: text(last.VersionID), PrevModelID: text(last.ModelID), Note: note, LifecycleRevision: expected + 1,
		})
	})
}

func (l *Loop) decided(ctx context.Context, q *db.Queries, id int64) (cycle, error) {
	if _, err := q.GetCycleForUpdate(ctx, id); err != nil {
		return cycle{}, fmt.Errorf("%w: cycle %d", ErrNotFound, id)
	}
	c, err := l.load(ctx, q, id)
	if err != nil {
		return cycle{}, err
	}
	if c.row.State != Decision || c.row.Outcome != Recommended {
		return cycle{}, fmt.Errorf("%w: cycle %d has no recommendation waiting", ErrState, id)
	}
	return c, nil
}

func (l *Loop) close(ctx context.Context, q *db.Queries, c *cycle, outcome, reason string) error {
	now := l.Clock.Now().UTC()
	c.row.State, c.row.Outcome, c.row.Reason, c.row.FinishedAt = Done, outcome, reason, &now
	if _, err := q.CancelCycleCandidates(ctx, db.CancelCycleCandidatesParams{CycleID: c.row.ID, Failure: reason}); err != nil {
		return err
	}
	return l.save(ctx, q, c)
}

func text(s string) pgtype.Text { return pgtype.Text{String: s, Valid: s != ""} }

// Run is the scheduler: it fails cycles a restart interrupted, then every Poll
// advances forward tests and starts the daily cycle when it is due.
func (l *Loop) Run(ctx context.Context) error {
	l.base = ctx
	open, err := l.Store.OpenCycles(ctx)
	if err != nil {
		return err
	}
	for _, row := range open {
		switch row.State {
		case ForwardTest, Decision: // durable: they continue
		default:
			c, err := l.load(ctx, l.Store.Queries, row.ID)
			if err != nil {
				return err
			}
			if err := l.finish(&c, Failed, interrupted); err != nil {
				return err
			}
		}
	}
	poll := l.Poll
	if poll <= 0 {
		poll = time.Minute
	}
	t := time.NewTicker(poll)
	defer t.Stop()
	for {
		if err := l.tick(ctx); err != nil && ctx.Err() == nil {
			l.logErr(err)
		}
		select {
		case <-ctx.Done():
			return nil
		case <-t.C:
		}
	}
}

func (l *Loop) tick(ctx context.Context) error {
	if err := l.Advance(ctx); err != nil {
		return err
	}
	cfg, err := LoadConfig(ctx, l.Store.Queries)
	if err != nil || !cfg.Enabled {
		return err
	}
	now := l.Clock.Now().UTC()
	due := time.Date(now.Year(), now.Month(), now.Day(), cfg.HourUTC, 0, 0, 0, time.UTC)
	if now.Before(due) {
		return nil
	}
	last, err := l.Store.LastCycleStart(ctx, cfg.Algorithm)
	if err != nil {
		return err
	}
	if !last.Before(due) {
		return nil
	}
	_, err = l.Start(ctx, "schedule")
	if errors.Is(err, ErrBusy) {
		return nil // a cycle is still open (forward test or awaiting approval)
	}
	return err
}

// DocOf parses a cycle row's record.
func DocOf(row db.LearningCycle) (Doc, error) {
	var d Doc
	err := json.Unmarshal(row.Doc, &d)
	return d, err
}

// Active is the champion pair: the active version and the model serving it.
type Active struct {
	Revision  int64
	VersionID string
	Model     *model.Artifact // nil: no active model
}

func (l *Loop) Active(ctx context.Context, alg string) (Active, error) {
	snapshot, err := experiment.Snapshot(ctx, l.Store, alg)
	if errors.Is(err, experiment.ErrNotFound) {
		return Active{}, fmt.Errorf("%w: algorithm %s", ErrNotFound, alg)
	}
	if err != nil {
		return Active{}, err
	}
	out := Active{Revision: snapshot.Algorithm.LifecycleRevision, Model: snapshot.Model}
	for _, v := range snapshot.Versions {
		if v.State == experiment.Active {
			out.VersionID = v.ID
			break
		}
	}
	return out, nil
}

// CanRollback: the last promotion replaced an earlier active pair that is still
// what a rollback would restore.
func (l *Loop) CanRollback(ctx context.Context, alg string) (bool, error) {
	last, err := l.Store.LastPromotion(ctx, alg)
	if errors.Is(err, pgx.ErrNoRows) {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	act, err := l.Active(ctx, alg)
	if err != nil {
		return false, err
	}
	return last.LifecycleRevision == act.Revision && last.PrevModelID.Valid && last.PrevVersionID.Valid && act.VersionID == last.VersionID && act.Model != nil && act.Model.ID == last.ModelID, nil
}
