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

// RuleValue selects an observed price, rolling indicator, closed bucket or constant.
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
	s, err := d.compile()
	if err != nil {
		return nil, err
	}
	return s, nil
}

// BuildWithEntryGate leaves rejected entries flat and always evaluates exits.
func (d RuleDefinition) BuildWithEntryGate(allow func(data.Bar) bool) (Strategy, error) {
	s, err := d.compile()
	if err != nil {
		return nil, err
	}
	s.allowEntry = allow
	return s, nil
}

func (d RuleDefinition) compile() (*ruleStrategy, error) {
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
		entry: entry.test, exit: exit.test, reason: entry.reason, bars: max(entry.bars, exit.bars),
		probeBars: max(entry.bars, exit.bars, c.bucketBars),
		exposure:  d.Exposure, base: c.base, long: make(map[string]bool),
	}, nil
}

// ProbeEntry observes the latest candle from flat exposure without consuming strategy state.
// ready distinguishes missing indicator inputs from a confirmed absence of an entry.
func (d RuleDefinition) ProbeEntry(history []data.Bar) (intent Intent, ready bool, err error) {
	_, probe, err := d.CompileEntryProbe()
	if err != nil {
		return Intent{}, false, err
	}
	intent, ready = probe(history)
	return intent, ready, nil
}

// CompileEntryProbe returns the history needed by both the entry and its exit veto.
func (d RuleDefinition) CompileEntryProbe() (int, func([]data.Bar) (Intent, bool), error) {
	s, err := d.compile()
	if err != nil {
		return 0, nil, err
	}
	return s.probeBars, s.probeEntry, nil
}

func (s *ruleStrategy) probeEntry(history []data.Bar) (Intent, bool) {
	if len(history) < s.bars {
		return Intent{}, false
	}
	exit, ready := s.exit(history)
	if !ready || exit {
		return Intent{}, ready
	}
	entry, ready := s.entry(history)
	if !ready || !entry {
		return Intent{}, ready
	}
	return s.entryIntent(history[len(history)-1].Instrument, history), true
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

// ComposeRules combines entry predicates while pinning one exit and exposure owner.
func ComposeRules(a, b RuleDefinition, entryMode, exitOwner string) (RuleDefinition, error) {
	if entryMode != "and" && entryMode != "or" {
		return RuleDefinition{}, fmt.Errorf("strategy: composition entry mode must be 'and' or 'or'")
	}
	return composeEntry(a, b, Rule{Op: entryMode, Args: []Rule{a.Entry, b.Entry}}, exitOwner)
}

// ComposeRegimeRules chooses one entry from the closed-bar trend and keeps the exit owner fixed.
func ComposeRegimeRules(a, b RuleDefinition, period int, exitOwner string) (RuleDefinition, error) {
	gate := Rule{Op: "gte", Left: &RuleValue{Kind: "close"}, Right: &RuleValue{Kind: "sma", Period: period}}
	return composeEntry(a, b, Rule{Op: "route", Args: []Rule{gate, a.Entry, b.Entry}}, exitOwner)
}

func composeEntry(a, b RuleDefinition, entry Rule, exitOwner string) (RuleDefinition, error) {
	owner := a
	switch exitOwner {
	case "a":
	case "b":
		owner = b
	default:
		return RuleDefinition{}, fmt.Errorf("strategy: composition exit owner must be a or b")
	}
	base := a.BaseTimeframe
	if base == "" {
		base = b.BaseTimeframe
	} else if b.BaseTimeframe != "" && b.BaseTimeframe != base {
		return RuleDefinition{}, fmt.Errorf("strategy: composition requires compatible base timeframes")
	}
	for _, component := range []RuleDefinition{a, b} {
		if _, err := component.Build(); err != nil {
			return RuleDefinition{}, err
		}
	}
	d := RuleDefinition{Format: RuleFormatV1, BaseTimeframe: base, Exposure: owner.Exposure,
		Entry: entry, Exit: owner.Exit}
	if _, err := d.Build(); err != nil {
		return RuleDefinition{}, err
	}
	return d, nil
}
