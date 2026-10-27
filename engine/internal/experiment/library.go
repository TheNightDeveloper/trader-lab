package experiment

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"slices"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

// Lifecycle states of an algorithm version.
const (
	Research    = "research"
	Validation  = "validation"
	ForwardTest = "forward_test"
	Active      = "active"
	Stopped     = "stopped"
	Retired     = "retired"
)

// next lists the states a version may move to. Only a person moves a version to
// active (invariant 9): SetState is reachable only from the user API.
var next = map[string][]string{
	Research:    {Validation, Stopped, Retired},
	Validation:  {ForwardTest, Research, Stopped, Retired},
	ForwardTest: {Active, Validation, Stopped, Retired},
	Active:      {Stopped},
	Stopped:     {Research, Retired},
	Retired:     {},
}

// VersionDefinition is what a version fixes: the strategy and its parameter set.
type VersionDefinition struct {
	Strategy string               `json:"strategy"`
	Params   []strategy.ParamSpec `json:"params"`
}

type builtin struct {
	family, description string
}

// Built-in algorithms (Go strategies). Persian descriptions are shown as is.
var builtins = map[string]builtin{
	"trend-ema":      {"trend", "تقاطع میانگین متحرک نمایی سریع و کند؛ ورود با عبور رو به بالا، خروج با عبور رو به پایین."},
	"mean-rev-bands": {"mean_reversion", "ورود وقتی قیمت پس از خروج از باند پایین بولینگر به داخل برمی‌گردد؛ خروج در میانگین."},
	"buy-and-hold":   {"benchmark", "خرید در نخستین کندل و نگهداری تا پایان؛ معیار مقایسه."},
	"hold-cash":      {"benchmark", "هیچ معامله‌ای؛ معیار صفر برای مقایسه."},
}

// SeedLibrary records every built-in algorithm. A changed rule or parameter set
// (different content hash) becomes a new version in research; old versions stay.
func SeedLibrary(ctx context.Context, s *store.Store) error {
	for _, name := range strategy.Names() {
		b, ok := builtins[name]
		if !ok {
			return fmt.Errorf("library: no description for strategy %q", name)
		}
		def := VersionDefinition{Strategy: name, Params: strategy.ParamSpecs[name]}
		defJ, err := json.Marshal(def)
		if err != nil {
			return err
		}
		h := sha256.Sum256(defJ)
		hash := hex.EncodeToString(h[:])
		err = s.InTx(ctx, func(q *db.Queries) error {
			if err := q.UpsertAlgorithm(ctx, db.UpsertAlgorithmParams{ID: name, Family: b.family, Description: b.description}); err != nil {
				return err
			}
			last, err := q.LatestAlgorithmVersion(ctx, name)
			version := int32(1)
			switch {
			case errors.Is(err, pgx.ErrNoRows):
			case err != nil:
				return err
			case last.ContentHash == hash:
				return nil
			default:
				version = last.Version + 1
			}
			id := fmt.Sprintf("%s@v%d", name, version)
			if err := q.InsertAlgorithmVersion(ctx, db.InsertAlgorithmVersionParams{
				ID: id, AlgorithmID: name, Version: version, ContentHash: hash, Definition: defJ, State: Research,
			}); err != nil {
				return err
			}
			return q.InsertLifecycleEvent(ctx, db.InsertLifecycleEventParams{VersionID: id, FromState: "", ToState: Research, Note: "نسخه تازه: قواعد یا پارامترها تغییر کرد", Actor: "system"})
		})
		if err != nil {
			return fmt.Errorf("seed %s: %w", name, err)
		}
	}
	return nil
}

// Version loads an algorithm version and its definition.
func Version(ctx context.Context, q *db.Queries, id string) (db.AlgorithmVersion, VersionDefinition, error) {
	v, err := q.GetAlgorithmVersion(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return v, VersionDefinition{}, fmt.Errorf("%w: algorithm version %s", ErrNotFound, id)
	}
	if err != nil {
		return v, VersionDefinition{}, err
	}
	var def VersionDefinition
	err = json.Unmarshal(v.Definition, &def)
	return v, def, err
}

// SetState moves a version along its lifecycle on a user decision. Activating a
// version stops the previously active version of the same algorithm.
func SetState(ctx context.Context, s *store.Store, id, to, note string) error {
	return s.InTx(ctx, func(q *db.Queries) error {
		v, _, err := Version(ctx, q, id)
		if err != nil {
			return err
		}
		if !slices.Contains(next[v.State], to) {
			return fmt.Errorf("%w: %s → %s is not allowed", ErrState, v.State, to)
		}
		if to == Active {
			vs, err := q.ListAlgorithmVersions(ctx, v.AlgorithmID)
			if err != nil {
				return err
			}
			for _, o := range vs {
				if o.State == Active && o.ID != id {
					if err := q.SetVersionState(ctx, db.SetVersionStateParams{ID: o.ID, State: Stopped}); err != nil {
						return err
					}
					if err := q.InsertLifecycleEvent(ctx, db.InsertLifecycleEventParams{VersionID: o.ID, FromState: Active, ToState: Stopped, Note: "جایگزین شد با " + id, Actor: "user"}); err != nil {
						return err
					}
				}
			}
		}
		if err := q.SetVersionState(ctx, db.SetVersionStateParams{ID: id, State: to}); err != nil {
			return err
		}
		return q.InsertLifecycleEvent(ctx, db.InsertLifecycleEventParams{VersionID: id, FromState: v.State, ToState: to, Note: note, Actor: "user"})
	})
}

// NextStates is what the UI may offer for a version in state.
func NextStates(state string) []string { return next[state] }
