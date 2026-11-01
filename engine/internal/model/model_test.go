package model

import (
	"math"
	"testing"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/feature"
)

func predictionFixture() Artifact {
	return Artifact{Recipe: Recipe{Format: 1, Features: []string{"ret_1", "ret_4", "vol_24"}, Transform: "zscore", Model: "ridge", Alpha: .01, Horizon: 1, Entry: .001, Exposure: 1},
		Scaler: feature.Scaler{Mean: []float64{.01, .02, .03}, Std: []float64{.1, .2, .3}}, Weights: []float64{.2, -.1, .05}, Intercept: .003}
}

func TestRecipeRejectsNonFiniteSettings(t *testing.T) {
	fields := map[string]func(*Recipe, float64){
		"exposure": func(r *Recipe, v float64) { r.Exposure = v },
		"stop":     func(r *Recipe, v float64) { r.StopLoss = v },
		"take":     func(r *Recipe, v float64) { r.TakeProfit = v },
		"filter":   func(r *Recipe, v float64) { r.Filter = &Filter{Feature: "ret_1", Max: v} },
	}
	for name, set := range fields {
		t.Run(name, func(t *testing.T) {
			for _, v := range []float64{math.NaN(), math.Inf(1), math.Inf(-1)} {
				r := predictionFixture().Recipe
				set(&r, v)
				require.ErrorIs(t, r.Validate(), ErrRecipe)
			}
		})
	}
}

// Compare with the existing two-pass calculation so optimization cannot change decisions.
func TestPredictMatchesScaledReference(t *testing.T) {
	a := predictionFixture()
	for _, kind := range []string{"ridge", "logistic"} {
		a.Recipe.Model = kind
		for _, x := range [][]float64{{0, 0, 0}, {.005, -.03, .06}, {1e6, -1e6, 1e-12}} {
			want := a.Intercept
			for j, z := range a.Scaler.Apply(x) {
				want += a.Weights[j] * z
			}
			if kind == "logistic" {
				want = Sigmoid(want)
			}
			require.Equal(t, want, a.Predict(x))
		}
	}
}

// Matching a content hash alone does not make a malformed model safe to execute.
func TestLoadValidatesModelAndPreservesLegacyID(t *testing.T) {
	a := predictionFixture()
	a.RecipeHash = a.Recipe.Hash()
	a.Seal()
	legacyID := a.ID
	body, err := a.Save()
	require.NoError(t, err)
	require.NotContains(t, string(body), "training_version")
	loaded, err := Load(body)
	require.NoError(t, err)
	require.Equal(t, legacyID, loaded.ID)
	for name, change := range map[string]func(*Artifact){
		"weights":         func(a *Artifact) { a.Weights = nil },
		"scaler width":    func(a *Artifact) { a.Scaler.Mean = nil },
		"zero spread":     func(a *Artifact) { a.Scaler.Std = []float64{0, 1, 1} },
		"negative spread": func(a *Artifact) { a.Scaler.Std = []float64{-1, 1, 1} },
		"recipe hash":     func(a *Artifact) { a.RecipeHash = "different" },
		"version":         func(a *Artifact) { a.TrainingVersion = "future" },
	} {
		t.Run(name, func(t *testing.T) {
			bad := a
			change(&bad)
			bad.Seal()
			body, err := bad.Save()
			require.NoError(t, err)
			_, err = Load(body)
			require.ErrorIs(t, err, ErrArtifact)
		})
	}
	a.TrainingVersion = TrainingVersion
	a.Seal()
	require.NotEqual(t, legacyID, a.ID, "training semantics are content-addressed")
}

var predictionSink float64

func BenchmarkPredict(b *testing.B) {
	a := predictionFixture()
	x := []float64{.005, -.03, .06}
	b.ReportAllocs()
	for b.Loop() {
		predictionSink = a.Predict(x)
	}
}
