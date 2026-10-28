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
func (l *Loop) Approve(ctx context.Context, id int64, note string) error {
	return l.Store.InTx(ctx, func(q *db.Queries) error {
		c, err := l.decided(ctx, q, id)
		if err != nil {
			return err
		}
		alg := c.row.AlgorithmID
		a, err := q.GetAlgorithm(ctx, alg)
		if err != nil {
			return err
		}
		prevVersion, err := activeVersion(ctx, q, alg)
		if err != nil {
			return err
		}
		why := fmt.Sprintf("ارتقا با تأیید کاربر پس از دروازه چرخه #%d", id)
		if note != "" {
			why += " — " + note
		}
		ch := c.doc.Challenger
		vid, _, err := experiment.AddVersion(ctx, q, alg, experiment.VersionDefinition{Strategy: experiment.RecipeStrategy, Recipe: &ch.Recipe}, experiment.Active, why, "user")
		if err != nil {
			return err
		}
		if err := activate(ctx, q, alg, vid, why); err != nil {
			return err
		}
		if err := q.SetActiveModel(ctx, db.SetActiveModelParams{ID: alg, ActiveModel: text(ch.ModelID)}); err != nil {
			return err
		}
		if err := q.InsertPromotion(ctx, db.InsertPromotionParams{
			AlgorithmID: alg, Action: "promote", VersionID: vid, ModelID: ch.ModelID,
			PrevVersionID: text(prevVersion), PrevModelID: a.ActiveModel, CycleID: &id, Note: note,
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
func (l *Loop) Rollback(ctx context.Context, alg, note string) error {
	return l.Store.InTx(ctx, func(q *db.Queries) error {
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
		a, err := q.GetAlgorithm(ctx, alg)
		if err != nil {
			return err
		}
		cur, err := activeVersion(ctx, q, alg)
		if err != nil {
			return err
		}
		if cur != last.VersionID || a.ActiveModel.String != last.ModelID {
			return fmt.Errorf("%w: the active version changed since the last promotion", ErrState)
		}
		why := "بازگشت به نسخه و مدل پیشین با تصمیم کاربر"
		if note != "" {
			why += " — " + note
		}
		if err := activate(ctx, q, alg, last.PrevVersionID.String, why); err != nil {
			return err
		}
		if err := q.SetActiveModel(ctx, db.SetActiveModelParams{ID: alg, ActiveModel: last.PrevModelID}); err != nil {
			return err
		}
		return q.InsertPromotion(ctx, db.InsertPromotionParams{
			AlgorithmID: alg, Action: "rollback", VersionID: last.PrevVersionID.String, ModelID: last.PrevModelID.String,
			PrevVersionID: text(last.VersionID), PrevModelID: text(last.ModelID), Note: note,
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
	return l.save(ctx, q, c)
}

func activeVersion(ctx context.Context, q *db.Queries, alg string) (string, error) {
	vs, err := q.ListAlgorithmVersions(ctx, alg)
	if err != nil {
		return "", err
	}
	for _, v := range vs {
		if v.State == experiment.Active {
			return v.ID, nil
		}
	}
	return "", nil
}

// activate makes id the only active version of alg, logging each change as the
// user's decision.
func activate(ctx context.Context, q *db.Queries, alg, id, why string) error {
	vs, err := q.ListAlgorithmVersions(ctx, alg)
	if err != nil {
		return err
	}
	for _, v := range vs {
		to := ""
		switch {
		case v.ID == id && v.State != experiment.Active:
			to = experiment.Active
		case v.ID != id && v.State == experiment.Active:
			to = experiment.Stopped
		}
		if to == "" {
			continue
		}
		if err := q.SetVersionState(ctx, db.SetVersionStateParams{ID: v.ID, State: to}); err != nil {
			return err
		}
		if err := q.InsertLifecycleEvent(ctx, db.InsertLifecycleEventParams{VersionID: v.ID, FromState: v.State, ToState: to, Note: why, Actor: "user"}); err != nil {
			return err
		}
	}
	return nil
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
	VersionID string
	Model     *model.Artifact // nil: no active model
}

func (l *Loop) Active(ctx context.Context, alg string) (Active, error) {
	a, err := l.Store.GetAlgorithm(ctx, alg)
	if err != nil {
		return Active{}, fmt.Errorf("%w: algorithm %s", ErrNotFound, alg)
	}
	v, err := activeVersion(ctx, l.Store.Queries, alg)
	if err != nil {
		return Active{}, err
	}
	out := Active{VersionID: v}
	if a.ActiveModel.Valid {
		m, err := l.artifact(ctx, a.ActiveModel.String)
		if err != nil {
			return Active{}, err
		}
		out.Model = &m
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
	return last.PrevModelID.Valid && last.PrevVersionID.Valid && act.VersionID == last.VersionID && act.Model != nil && act.Model.ID == last.ModelID, nil
}
