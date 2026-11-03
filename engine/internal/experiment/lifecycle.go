package experiment

import (
	"context"
	"errors"
	"fmt"
	"slices"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

var ErrConflict = fmt.Errorf("%w: وضعیت الگوریتم تغییر کرده؛ داده‌ها را تازه‌سازی و تصمیم را دوباره بررسی کنید", ErrState)

// Lifecycle holds the algorithm lock for a single atomic, revision-checked decision.
// Q is transaction-bound: callers must not use the pool for writes inside the callback.
type Lifecycle struct {
	Q         *db.Queries
	Algorithm db.Algorithm
}

func ChangeLifecycle(ctx context.Context, s *store.Store, algorithm string, expected int64, change func(*Lifecycle) error) error {
	return s.InTx(ctx, func(q *db.Queries) error {
		a, err := q.LockAlgorithm(ctx, algorithm)
		if errors.Is(err, pgx.ErrNoRows) {
			return fmt.Errorf("%w: algorithm %s", ErrNotFound, algorithm)
		}
		if err != nil {
			return err
		}
		if a.LifecycleRevision != expected {
			return ErrConflict
		}
		if err := change(&Lifecycle{Q: q, Algorithm: a}); err != nil {
			return err
		}
		n, err := q.BumpLifecycleRevision(ctx, db.BumpLifecycleRevisionParams{ID: algorithm, ExpectedRevision: expected})
		if err != nil {
			return err
		}
		if n != 1 {
			return ErrConflict
		}
		return nil
	})
}

func (l *Lifecycle) ActiveVersion(ctx context.Context) (string, error) {
	vs, err := l.Q.ListAlgorithmVersions(ctx, l.Algorithm.ID)
	if err != nil {
		return "", err
	}
	for _, v := range vs {
		if v.State == Active {
			return v.ID, nil
		}
	}
	return "", nil
}

// Move follows library transitions. Learning activation requires a validated frozen model.
func (l *Lifecycle) Move(ctx context.Context, id, to, note string) error {
	v, def, err := Version(ctx, l.Q, id)
	if err != nil {
		return err
	}
	if v.AlgorithmID != l.Algorithm.ID || !slices.Contains(next[v.State], to) {
		return fmt.Errorf("%w: %s -> %s", ErrState, v.State, to)
	}
	if to == Active {
		if def.Recipe != nil {
			return fmt.Errorf("%w: مدل یادگیری فقط با تأیید چرخه فعال می‌شود", ErrState)
		}
		return l.Activate(ctx, id, "", note)
	}
	if err := l.setState(ctx, v, to, note); err != nil {
		return err
	}
	if v.State == Active {
		return l.Q.SetActiveModel(ctx, db.SetActiveModelParams{ID: l.Algorithm.ID})
	}
	return nil
}

// Activate changes the pair together; retirement is never bypassed by approval/rollback.
func (l *Lifecycle) Activate(ctx context.Context, id, modelID, note string) error {
	v, def, err := Version(ctx, l.Q, id)
	if err != nil {
		return err
	}
	if v.AlgorithmID != l.Algorithm.ID || v.State == Retired {
		return fmt.Errorf("%w: target version is unavailable", ErrState)
	}
	if def.Recipe == nil {
		if modelID != "" {
			return fmt.Errorf("%w: a fixed strategy cannot serve a model", ErrState)
		}
	} else {
		if _, err := checkedModel(ctx, l.Q, l.Algorithm.ID, def, modelID); err != nil {
			return err
		}
	}
	vs, err := l.Q.ListAlgorithmVersions(ctx, l.Algorithm.ID)
	if err != nil {
		return err
	}
	// Stop the old version first so the unique active-version index holds throughout.
	for _, other := range vs {
		if other.State == Active && other.ID != id {
			if err := l.setState(ctx, other, Stopped, note); err != nil {
				return err
			}
		}
	}
	if v.State != Active {
		if err := l.setState(ctx, v, Active, note); err != nil {
			return err
		}
	}
	return l.Q.SetActiveModel(ctx, db.SetActiveModelParams{ID: l.Algorithm.ID, ActiveModel: pgtype.Text{String: modelID, Valid: modelID != ""}})
}

func (l *Lifecycle) setState(ctx context.Context, v db.AlgorithmVersion, to, note string) error {
	if err := l.Q.SetVersionState(ctx, db.SetVersionStateParams{ID: v.ID, State: to}); err != nil {
		return err
	}
	return l.Q.InsertLifecycleEvent(ctx, db.InsertLifecycleEventParams{VersionID: v.ID, FromState: v.State, ToState: to, Note: note, Actor: "user"})
}

func checkedModel(ctx context.Context, q *db.Queries, algorithm string, def VersionDefinition, id string) (*model.Artifact, error) {
	if id == "" || def.Recipe == nil {
		return nil, fmt.Errorf("%w: a frozen model is required", ErrState)
	}
	row, err := q.GetArtifact(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, fmt.Errorf("%w: model %s", ErrState, id)
	}
	if err != nil {
		return nil, err
	}
	m, err := model.Load(row.Body)
	if err != nil {
		return nil, fmt.Errorf("%w: %w", ErrState, err)
	}
	if row.AlgorithmID != algorithm || m.Algorithm != algorithm || m.ID != id || row.RecipeHash != def.Recipe.Hash() || m.RecipeHash != def.Recipe.Hash() {
		return nil, fmt.Errorf("%w: model does not match the algorithm/version recipe", ErrState)
	}
	return &m, nil
}

// LifecycleSnapshot is one coherent read of the serving version/model and revision.
type LifecycleSnapshot struct {
	Algorithm db.Algorithm
	Versions  []db.AlgorithmVersion
	Model     *model.Artifact
}

func Snapshot(ctx context.Context, s *store.Store, algorithm string) (LifecycleSnapshot, error) {
	var out LifecycleSnapshot
	err := s.InTxOptions(ctx, pgx.TxOptions{IsoLevel: pgx.RepeatableRead, AccessMode: pgx.ReadOnly}, func(q *db.Queries) error {
		var err error
		out.Algorithm, err = q.GetAlgorithm(ctx, algorithm)
		if errors.Is(err, pgx.ErrNoRows) {
			return fmt.Errorf("%w: algorithm %s", ErrNotFound, algorithm)
		}
		if err != nil {
			return err
		}
		out.Versions, err = q.ListAlgorithmVersions(ctx, algorithm)
		if err != nil {
			return err
		}
		if !out.Algorithm.ActiveModel.Valid {
			return nil
		}
		for _, v := range out.Versions {
			if v.State == Active {
				_, def, err := Version(ctx, q, v.ID)
				if err != nil {
					return err
				}
				out.Model, err = checkedModel(ctx, q, algorithm, def, out.Algorithm.ActiveModel.String)
				return err
			}
		}
		return fmt.Errorf("%w: serving model has no active version", ErrState)
	})
	return out, err
}
