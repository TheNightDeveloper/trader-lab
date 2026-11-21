package strategy

import (
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"math"
	"strings"
)

const NativeFormatV1 = "native/v1"

// NativeDefinition names a registered strategy and the input parameters of an evaluation.
type NativeDefinition struct {
	Format string `json:"format"`
	Name   string `json:"name"`
	Params Params `json:"params"`
}

// Build creates fresh strategy state for every run, including native warm-up hooks.
func (d NativeDefinition) Build() (Strategy, error) {
	if d.Format != NativeFormatV1 {
		return nil, fmt.Errorf("strategy: unsupported native definition format %q", d.Format)
	}
	for key, v := range d.Params {
		if math.IsNaN(v) || math.IsInf(v, 0) {
			return nil, fmt.Errorf("strategy: %s must be finite", key)
		}
	}
	build, ok := registry[d.Name]
	if !ok {
		return nil, fmt.Errorf("%w %q (have %s)", ErrUnknown, d.Name, strings.Join(Names(), ", "))
	}
	return build(d.Params)
}

// ContentHash identifies the format and effective parameters. The recorded engine
// build still identifies the implementation that evaluated them.
func (d NativeDefinition) ContentHash() (string, error) {
	d.Params = WithDefaults(d.Name, d.Params)
	if _, err := d.Build(); err != nil {
		return "", err
	}
	encoded, err := json.Marshal(d)
	if err != nil {
		return "", err
	}
	return fmt.Sprintf("sha256:%x", sha256.Sum256(encoded)), nil
}
