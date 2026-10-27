// Package experiment holds pre-registered experiment definitions, locks them on
// start, and keeps the attempt registry. Attempts are never deleted (invariant 6).
package experiment

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

var (
	ErrNotFound = errors.New("experiment: not found")
	ErrExists   = errors.New("experiment: an identical experiment already exists")
	ErrState    = errors.New("experiment: not allowed in this state")
	ErrInvalid  = errors.New("experiment: invalid definition")
)

type Objective struct {
	Metric   string `json:"metric"`   // a metrics key, e.g. total_return
	Maximize bool   `json:"maximize"` // false: minimize (e.g. max_drawdown)
}

// Constraint is a hard limit; violators can never be chosen.
type Constraint struct {
	Metric string `json:"metric"`
	Op     string `json:"op"`    // ">=" | "<="
	Value  string `json:"value"` // decimal in the metric unit: ratios as fractions ("0.2" = 20%)
}

// ParamRange is either explicit Values or Min..Max by Step (inclusive).
type ParamRange struct {
	Values []float64 `json:"values,omitempty"`
	Min    float64   `json:"min,omitempty"`
	Max    float64   `json:"max,omitempty"`
	Step   float64   `json:"step,omitempty"`
}

type SearchPlan struct {
	Mode           string `json:"mode"` // grid | random
	Seed           uint64 `json:"seed"`
	MaxAttempts    int    `json:"max_attempts"`     // budget: candidate × pair runs
	MaxWallSeconds int    `json:"max_wall_seconds"` // budget: queued attempts are cancelled after this
}

// Definition is everything decided before the first result is seen.
type Definition struct {
	Name             string                `json:"name"`
	Hypothesis       string                `json:"hypothesis"`
	Falsifier        string                `json:"falsifier"` // the result that would prove the idea wrong
	Objective        Objective             `json:"objective"`
	Constraints      []Constraint          `json:"constraints"`
	DatasetIDs       []string              `json:"dataset_ids"` // one per pair
	AlgorithmVersion string                `json:"algorithm_version"`
	Space            map[string]ParamRange `json:"space"` // parameters to search; others keep the version defaults
	Search           SearchPlan            `json:"search"`
	Sim              sim.Config            `json:"sim"`
	Split            eval.SplitPlan        `json:"split"`
}

// ContentID addresses the definition: the same definition is the same experiment;
// any change is a new one.
func (d Definition) ContentID() (string, error) {
	b, err := json.Marshal(d) // struct fields in order, map keys sorted
	if err != nil {
		return "", err
	}
	h := sha256.Sum256(b)
	return "exp_" + hex.EncodeToString(h[:8]), nil
}

// NewAttempt is one candidate × pair to register.
type NewAttempt struct {
	Candidate int
	Params    strategy.Params
	DatasetID string
	Symbol    string
}

// Create locks def and registers every attempt as queued, in one transaction.
func Create(ctx context.Context, s *store.Store, def Definition, attempts []NewAttempt) (string, error) {
	id, err := def.ContentID()
	if err != nil {
		return "", err
	}
	defJ, err := json.Marshal(def)
	if err != nil {
		return "", err
	}
	if _, err := s.GetExperiment(ctx, id); err == nil {
		return id, fmt.Errorf("%w: %s", ErrExists, id)
	}
	rows := make([]db.CopyAttemptsParams, len(attempts))
	for i, a := range attempts {
		pj, err := json.Marshal(a.Params)
		if err != nil {
			return "", err
		}
		rows[i] = db.CopyAttemptsParams{ExperimentID: id, Seq: int32(i + 1), Candidate: int32(a.Candidate), Params: pj, DatasetID: a.DatasetID, Symbol: a.Symbol, Status: "queued"}
	}
	err = s.InTx(ctx, func(q *db.Queries) error {
		if err := q.InsertExperiment(ctx, db.InsertExperimentParams{ID: id, Name: def.Name, Definition: defJ}); err != nil {
			return fmt.Errorf("insert experiment: %w", err)
		}
		if _, err := q.CopyAttempts(ctx, rows); err != nil {
			return fmt.Errorf("register attempts: %w", err)
		}
		return nil
	})
	return id, err
}

type Experiment struct {
	Row db.Experiment
	Def Definition
}

func Load(ctx context.Context, q *db.Queries, id string) (Experiment, error) {
	row, err := q.GetExperiment(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return Experiment{}, fmt.Errorf("%w: %s", ErrNotFound, id)
	}
	if err != nil {
		return Experiment{}, err
	}
	var def Definition
	if err := json.Unmarshal(row.Definition, &def); err != nil {
		return Experiment{}, fmt.Errorf("experiment %s definition: %w", id, err)
	}
	return Experiment{row, def}, nil
}

// transition moves id from one of from to to; ErrState if it was in no such state.
func transition(ctx context.Context, q *db.Queries, id, to string, from ...string) error {
	n, err := q.SetExperimentStatus(ctx, db.SetExperimentStatusParams{ToStatus: to, ID: id, FromStatuses: from})
	if err != nil {
		return err
	}
	if n == 0 {
		if _, err := Load(ctx, q, id); err != nil {
			return err
		}
		return fmt.Errorf("%w: cannot move to %s", ErrState, to)
	}
	return nil
}

// Pause stops new attempts from starting; running ones finish.
func Pause(ctx context.Context, q *db.Queries, id string) error {
	return transition(ctx, q, id, "paused", "running")
}

func Resume(ctx context.Context, q *db.Queries, id string) error {
	return transition(ctx, q, id, "running", "paused")
}

// Cancel ends the experiment: queued attempts become cancelled (recorded, never
// deleted). Running attempts are stopped by the scheduler.
func Cancel(ctx context.Context, s *store.Store, id string) error {
	return s.InTx(ctx, func(q *db.Queries) error {
		if err := transition(ctx, q, id, "cancelled", "running", "paused"); err != nil {
			return err
		}
		_, err := q.CancelQueued(ctx, db.CancelQueuedParams{ExperimentID: id, Failure: "لغو به درخواست کاربر"})
		return err
	})
}
