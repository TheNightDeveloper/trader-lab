package strategy

import (
	"bytes"
	"crypto/sha256"
	"encoding/json"
	"fmt"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
)

const RuleFormatV1 = "rules/v1"

const (
	maxRuleBytes = 32 << 10
	maxRuleDepth = 8
	maxRuleNodes = 64
	maxRuleBars  = 1000
)

// RuleDefinition describes a long/flat strategy on one closed-bar stream per instrument.
type RuleDefinition struct {
	Format        string         `json:"format"`
	Exposure      money.Ratio    `json:"exposure"`
	Entry         Rule           `json:"entry"`
	Exit          Rule           `json:"exit"`
	BaseTimeframe data.Timeframe `json:"base_timeframe,omitempty"`
}

// Rule holds either boolean children or two numeric operands, depending on Op.
type Rule struct {
	Op    string     `json:"op"`
	Args  []Rule     `json:"args,omitempty"`
	Left  *RuleValue `json:"left,omitempty"`
	Right *RuleValue `json:"right,omitempty"`
}

// RuleValue selects a close, trailing mean, closed bucket or nonnegative constant.
type RuleValue struct {
	Kind      string         `json:"kind"`
	Number    *float64       `json:"number,omitempty"`
	Period    int            `json:"period,omitempty"`
	Timeframe data.Timeframe `json:"timeframe,omitempty"`
}

// UnmarshalJSON checks the wire format before assigning even a partially valid tree.
func (d *RuleDefinition) UnmarshalJSON(raw []byte) error {
	if len(raw) > maxRuleBytes {
		return fmt.Errorf("strategy: rule definition exceeds %d bytes", maxRuleBytes)
	}
	type wire RuleDefinition
	var decoded wire
	dec := json.NewDecoder(bytes.NewReader(raw))
	dec.DisallowUnknownFields()
	if err := dec.Decode(&decoded); err != nil {
		return fmt.Errorf("strategy: rule definition: %w", err)
	}
	if len(bytes.TrimSpace(raw[dec.InputOffset():])) != 0 {
		return fmt.Errorf("strategy: trailing data after rule definition")
	}
	candidate := RuleDefinition(decoded)
	if _, err := candidate.Build(); err != nil {
		return err
	}
	*d = candidate
	return nil
}

// Build compiles validated rules and creates independent target state for a run.
func (d RuleDefinition) Build() (Strategy, error) {
	if d.Format != RuleFormatV1 {
		return nil, fmt.Errorf("strategy: unsupported rule definition format %q", d.Format)
	}
	if d.Exposure <= 0 || d.Exposure > money.RatioOne {
		return nil, fmt.Errorf("strategy: rule exposure must be in (0, 1]")
	}
	c := ruleCompiler{remaining: maxRuleNodes}
	if d.BaseTimeframe != "" {
		tf, err := data.ParseTimeframe(string(d.BaseTimeframe))
		if err != nil {
			return nil, err
		}
		c.base = tf.Duration()
	}
	entry, err := c.compile(d.Entry, 1)
	if err != nil {
		return nil, fmt.Errorf("strategy: entry: %w", err)
	}
	exit, err := c.compile(d.Exit, 1)
	if err != nil {
		return nil, fmt.Errorf("strategy: exit: %w", err)
	}
	return &ruleStrategy{
		entry: entry.test, exit: exit.test, bars: max(entry.bars, exit.bars),
		exposure: d.Exposure, base: c.base, long: make(map[string]bool),
	}, nil
}

// ContentHash identifies the validated ordered AST through its canonical JSON.
func (d RuleDefinition) ContentHash() (string, error) {
	if _, err := d.Build(); err != nil {
		return "", err
	}
	encoded, err := json.Marshal(d)
	if err != nil {
		return "", err
	}
	return fmt.Sprintf("sha256:%x", sha256.Sum256(encoded)), nil
}
