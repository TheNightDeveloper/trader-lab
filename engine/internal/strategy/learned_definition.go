package strategy

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"strings"

	"tradinglab/engine/internal/model"
)

const LearnedFormatV1 = "learned/v1"

// LearnedDefinition pins the artifact sequence used for walk-forward inference.
// Sequence order breaks ties when models share an AsOf timestamp.
type LearnedDefinition struct {
	Format   string   `json:"format"`
	ModelIDs []string `json:"model_ids"`
}

// DescribeLearned records content IDs in the order supplied by the caller.
func DescribeLearned(models []model.Artifact) LearnedDefinition {
	d := LearnedDefinition{Format: LearnedFormatV1, ModelIDs: make([]string, len(models))}
	for i, m := range models {
		d.ModelIDs[i] = m.ID
	}
	return d
}

func (d LearnedDefinition) validate() error {
	if d.Format != LearnedFormatV1 {
		return fmt.Errorf("strategy: unsupported learned definition format %q", d.Format)
	}
	if len(d.ModelIDs) < 1 || len(d.ModelIDs) > 50 {
		return fmt.Errorf("strategy: a learned definition needs 1..50 models")
	}
	for _, id := range d.ModelIDs {
		hexID, ok := strings.CutPrefix(id, "m_")
		if !ok || len(hexID) != 16 || strings.ToLower(hexID) != hexID {
			return fmt.Errorf("strategy: invalid model ID %q", id)
		}
		if _, err := hex.DecodeString(hexID); err != nil {
			return fmt.Errorf("strategy: invalid model ID %q", id)
		}
	}
	return nil
}

// Build creates fresh simulation state from the exact pinned artifacts.
func (d LearnedDefinition) Build(models []model.Artifact) (Strategy, error) {
	if err := d.validate(); err != nil {
		return nil, err
	}
	if len(models) != len(d.ModelIDs) {
		return nil, fmt.Errorf("strategy: got %d trained models for %d references", len(models), len(d.ModelIDs))
	}
	for i, m := range models {
		if err := m.Validate(); err != nil {
			return nil, err
		}
		// Verify the body as well as the ID supplied by the artifact loader.
		originalID := m.ID
		m.Seal()
		if originalID != m.ID || m.ID != d.ModelIDs[i] {
			return nil, fmt.Errorf("strategy: artifact %d does not match reference %s", i+1, d.ModelIDs[i])
		}
		if m.RecipeHash != models[0].RecipeHash {
			return nil, fmt.Errorf("strategy: models %s and %s come from different recipes", models[0].ID, m.ID)
		}
	}
	return buildLearned(models), nil
}

// ContentHash identifies the versioned references without copying artifact bodies.
func (d LearnedDefinition) ContentHash() (string, error) {
	if err := d.validate(); err != nil {
		return "", err
	}
	encoded, err := json.Marshal(d)
	if err != nil {
		return "", err
	}
	return fmt.Sprintf("sha256:%x", sha256.Sum256(encoded)), nil
}
