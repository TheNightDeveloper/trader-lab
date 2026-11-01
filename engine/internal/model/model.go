// Package model holds learning recipes and trained model artifacts: what a
// learned strategy is made of, and how a saved model predicts. Fitting lives in
// model/train, which the judge (sim, eval, metrics) never imports.
package model

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"slices"
	"time"

	"tradinglab/engine/internal/feature"
)

var (
	ErrRecipe   = errors.New("model: invalid recipe")
	ErrArtifact = errors.New("model: artifact does not match its id")
)

// RecipeFormat is the version of the recipe JSON format.
const RecipeFormat = 1

// TrainingVersion distinguishes fits with full dependency availability checks.
const TrainingVersion = "causal-features/v1"

// Recipe is everything a learned strategy is built from, besides its trained
// weights. Any change is a new algorithm version.
type Recipe struct {
	Format   int      `json:"format"`
	Features []string `json:"features"`
	// Transform fit inside each training window: "zscore".
	Transform string `json:"transform"`
	// Model: "ridge" predicts the forward return over Horizon bars; "logistic"
	// predicts the probability that it is positive.
	Model   string  `json:"model"`
	Alpha   float64 `json:"alpha"`   // L2 strength per sample
	Horizon int     `json:"horizon"` // label horizon, bars
	// Entry: go long when the prediction exceeds it (ridge: a return, e.g. 0.002;
	// logistic: a probability, e.g. 0.55). Flat otherwise.
	Entry float64 `json:"entry"`
	// Filter: trade only while the standardized value of a listed feature is at
	// most Max (e.g. vol_24 ≤ 1 = calmer than one spread above average).
	Filter   *Filter `json:"filter,omitempty"`
	Exposure float64 `json:"exposure"` // fraction of equity when long, (0, 1]
	// Exits relative to the fill price; 0 = none.
	StopLoss   float64 `json:"stop_loss,omitempty"`
	TakeProfit float64 `json:"take_profit,omitempty"`
}

type Filter struct {
	Feature string  `json:"feature"`
	Max     float64 `json:"max"`
}

func (r Recipe) Validate() error {
	bad := func(f string, a ...any) error { return fmt.Errorf("%w: "+f, append([]any{ErrRecipe}, a...)...) }
	for _, v := range []float64{r.Alpha, r.Entry, r.Exposure, r.StopLoss, r.TakeProfit} {
		if math.IsNaN(v) || math.IsInf(v, 0) {
			return bad("settings must be finite")
		}
	}
	if r.Filter != nil && (math.IsNaN(r.Filter.Max) || math.IsInf(r.Filter.Max, 0)) {
		return bad("filter maximum must be finite")
	}
	switch {
	case r.Format != RecipeFormat:
		return bad("format %d (want %d)", r.Format, RecipeFormat)
	case len(r.Features) == 0:
		return bad("no features")
	case r.Transform != "zscore":
		return bad("transform %q (have zscore)", r.Transform)
	case r.Model != "ridge" && r.Model != "logistic":
		return bad("model %q (have ridge, logistic)", r.Model)
	case !(r.Alpha >= 0) || math.IsInf(r.Alpha, 0):
		return bad("alpha must be ≥ 0")
	case r.Horizon < 1 || r.Horizon > 500:
		return bad("horizon must be 1..500 bars")
	case r.Model == "logistic" && (r.Entry <= 0 || r.Entry >= 1):
		return bad("logistic entry is a probability in (0, 1)")
	case math.IsNaN(r.Entry) || math.IsInf(r.Entry, 0):
		return bad("entry must be a number")
	case r.Exposure <= 0 || r.Exposure > 1:
		return bad("exposure must be in (0, 1]")
	case r.StopLoss < 0 || r.StopLoss >= 1 || r.TakeProfit < 0:
		return bad("stop loss in [0, 1), take profit ≥ 0")
	}
	if err := feature.Check(r.Features); err != nil {
		return bad("%v", err)
	}
	if r.Filter != nil && !slices.Contains(r.Features, r.Filter.Feature) {
		return bad("filter feature %q is not among the features", r.Filter.Feature)
	}
	return nil
}

// Hash is the content address of the recipe.
func (r Recipe) Hash() string {
	b, _ := json.Marshal(r) // plain struct: cannot fail
	h := sha256.Sum256(b)
	return hex.EncodeToString(h[:])
}

// Artifact is one trained model: the recipe it came from, the data and window it
// saw, the fitted transform and weights. Content-addressed: the ID covers all of it.
type Artifact struct {
	TrainingVersion string    `json:"training_version,omitempty"` // absent on legacy fits; never rewritten
	ID              string    `json:"id"`
	Algorithm       string    `json:"algorithm"`
	Recipe          Recipe    `json:"recipe"`
	RecipeHash      string    `json:"recipe_hash"`
	DatasetIDs      []string  `json:"dataset_ids"`
	TrainFrom       time.Time `json:"train_from"` // feature bars opened in [TrainFrom, TrainTo)
	TrainTo         time.Time `json:"train_to"`
	// AsOf: every training label was ready by then. The model may only be used for
	// decisions on bars opened at or after AsOf.
	AsOf      time.Time      `json:"as_of"`
	Seed      uint64         `json:"seed"`
	Scaler    feature.Scaler `json:"scaler"`
	Weights   []float64      `json:"weights"`
	Intercept float64        `json:"intercept"`
	Samples   int            `json:"samples"`
	// TrainError: in-sample RMSE (ridge) or log loss (logistic).
	TrainError float64 `json:"train_error"`
	Parent     string  `json:"parent,omitempty"` // artifact this one challenged, if any
}

func (a Artifact) contentID() string {
	a.ID = ""
	b, _ := json.Marshal(a)
	h := sha256.Sum256(b)
	return "m_" + hex.EncodeToString(h[:8])
}

// Seal sets the content ID.
func (a *Artifact) Seal() { a.ID = a.contentID() }

// Save is the stored form (JSON; float64 values round-trip exactly).
func (a Artifact) Save() ([]byte, error) { return json.Marshal(a) }

// Load parses a stored artifact and verifies it still matches its ID.
func Load(b []byte) (Artifact, error) {
	var a Artifact
	if err := json.Unmarshal(b, &a); err != nil {
		return a, fmt.Errorf("model: %w", err)
	}
	if a.ID != a.contentID() {
		return a, fmt.Errorf("%w: %s", ErrArtifact, a.ID)
	}
	if err := a.Validate(); err != nil {
		return a, err
	}
	return a, nil
}

// Validate rejects malformed models before they reach prediction or persistence.
func (a Artifact) Validate() error {
	if err := a.Recipe.Validate(); err != nil {
		return fmt.Errorf("%w: %w", ErrArtifact, err)
	}
	k := len(a.Recipe.Features)
	if a.RecipeHash != a.Recipe.Hash() || len(a.Weights) != k || len(a.Scaler.Mean) != k || len(a.Scaler.Std) != k {
		return fmt.Errorf("%w: recipe hash or model dimensions", ErrArtifact)
	}
	if a.TrainingVersion != "" && a.TrainingVersion != TrainingVersion {
		return fmt.Errorf("%w: unknown training version %q", ErrArtifact, a.TrainingVersion)
	}
	for _, values := range [][]float64{a.Weights, a.Scaler.Mean, a.Scaler.Std, {a.Intercept, a.TrainError}} {
		for _, v := range values {
			if math.IsNaN(v) || math.IsInf(v, 0) {
				return fmt.Errorf("%w: non-finite model value", ErrArtifact)
			}
		}
	}
	for _, std := range a.Scaler.Std {
		if std <= 0 {
			return fmt.Errorf("%w: scaler spread must be positive", ErrArtifact)
		}
	}
	return nil
}

// Predict maps one raw feature row to the model output: a forward return (ridge)
// or a probability (logistic).
func (a Artifact) Predict(x []float64) float64 {
	v := a.Intercept
	for j, w := range a.Weights {
		// Normalize once in the dot product, preserving the original operation order.
		z := (x[j] - a.Scaler.Mean[j]) / a.Scaler.Std[j]
		v += w * z
	}
	if a.Recipe.Model == "logistic" {
		return Sigmoid(v)
	}
	return v
}

func Sigmoid(v float64) float64 { return 1 / (1 + math.Exp(-v)) }
