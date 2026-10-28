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

	"tradinglab/engine/internal/model"
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

// VersionDefinition is what a version fixes: the strategy and its parameter set,
// or for a learning algorithm (Strategy "recipe") its recipe. Trained weights are
// not part of a version; they are model artifacts.
type VersionDefinition struct {
	Strategy string               `json:"strategy"`
	Params   []strategy.ParamSpec `json:"params"`
	Recipe   *model.Recipe        `json:"recipe,omitempty"`
}

// RecipeStrategy marks a learning algorithm's version definition.
const RecipeStrategy = "recipe"

type builtin struct {
	family, description string
	recipe              *model.Recipe // learning algorithms only
}

// Built-in algorithms (Go strategies). Persian descriptions are shown as is.
var builtins = map[string]builtin{
	"trend-ema":      {"trend", "تقاطع میانگین متحرک نمایی سریع و کند؛ ورود با عبور رو به بالا، خروج با عبور رو به پایین.", nil},
	"mean-rev-bands": {"mean_reversion", "ورود وقتی قیمت پس از خروج از باند پایین بولینگر به داخل برمی‌گردد؛ خروج در میانگین.", nil},
	"buy-and-hold":   {"benchmark", "خرید در نخستین کندل و نگهداری تا پایان؛ معیار مقایسه.", nil},
	"hold-cash":      {"benchmark", "هیچ معامله‌ای؛ معیار صفر برای مقایسه.", nil},
	"ridge-h4": {"learning", "رگرسیون ridge برای پیش‌بینی بازده ۴ کندل آینده، با فیلتر نوسان؛ هر گام فقط با گذشته خودش آموزش می‌بیند.", &model.Recipe{
		Format: model.RecipeFormat, Features: []string{"ret_1", "ret_4", "ret_24", "vol_24", "rsi_14"}, Transform: "zscore",
		Model: "ridge", Alpha: 0.1, Horizon: 4, Entry: 0.0015, Filter: &model.Filter{Feature: "vol_24", Max: 1}, Exposure: 1, StopLoss: 0.03,
	}},
	"logit-dir-h1": {"learning", "رگرسیون لجستیک برای جهت بازده کندل بعد؛ ورود وقتی احتمال صعود از آستانه بیشتر است.", &model.Recipe{
		Format: model.RecipeFormat, Features: []string{"ret_1", "ret_4", "rsi_14", "sma_gap_24"}, Transform: "zscore",
		Model: "logistic", Alpha: 0.01, Horizon: 1, Entry: 0.55, Exposure: 1,
	}},
}

// SeedLibrary records every built-in algorithm. A changed rule, parameter set or
// recipe (a content hash no version has) becomes a new version in research; old
// versions stay.
func SeedLibrary(ctx context.Context, s *store.Store) error {
	for _, name := range strategy.Names() {
		if _, ok := builtins[name]; !ok {
			return fmt.Errorf("library: no description for strategy %q", name)
		}
	}
	names := make([]string, 0, len(builtins))
	for n := range builtins {
		names = append(names, n)
	}
	slices.Sort(names)
	for _, name := range names {
		b := builtins[name]
		def := VersionDefinition{Strategy: name, Params: strategy.ParamSpecs[name]}
		if b.recipe != nil {
			def = VersionDefinition{Strategy: RecipeStrategy, Recipe: b.recipe}
		}
		err := s.InTx(ctx, func(q *db.Queries) error {
			if err := q.UpsertAlgorithm(ctx, db.UpsertAlgorithmParams{ID: name, Family: b.family, Description: b.description}); err != nil {
				return err
			}
			_, _, err := AddVersion(ctx, q, name, def, Research, "نسخه تازه: قواعد یا پارامترها تغییر کرد", "system")
			return err
		})
		if err != nil {
			return fmt.Errorf("seed %s: %w", name, err)
		}
	}
	return nil
}

// AddVersion records def as the next version of algorithm in state, unless some
// version already has the same content; then it returns that version's id.
func AddVersion(ctx context.Context, q *db.Queries, algorithm string, def VersionDefinition, state, note, actor string) (string, bool, error) {
	defJ, err := json.Marshal(def)
	if err != nil {
		return "", false, err
	}
	h := sha256.Sum256(defJ)
	hash := hex.EncodeToString(h[:])
	vs, err := q.ListAlgorithmVersions(ctx, algorithm)
	if err != nil {
		return "", false, err
	}
	version := int32(1)
	for _, v := range vs {
		if v.ContentHash == hash {
			return v.ID, false, nil
		}
		version = max(version, v.Version+1)
	}
	id := fmt.Sprintf("%s@v%d", algorithm, version)
	if err := q.InsertAlgorithmVersion(ctx, db.InsertAlgorithmVersionParams{
		ID: id, AlgorithmID: algorithm, Version: version, ContentHash: hash, Definition: defJ, State: state,
	}); err != nil {
		return "", false, err
	}
	err = q.InsertLifecycleEvent(ctx, db.InsertLifecycleEventParams{VersionID: id, FromState: "", ToState: state, Note: note, Actor: actor})
	return id, true, err
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
