// Package assistant interprets model output without exposing engine commands.
package assistant

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
)

const (
	PromptVersion = "opportunity-focus-v1"
	Model         = "gpt-4.1-mini-2025-04-14"
	MaxOutput     = 96
)

var ErrInvalidOutput = errors.New("invalid assistant output")

// Evidence contains only engine facts. Titles, rules and external prose stay local.
type Evidence struct {
	Symbol          string `json:"symbol"`
	Match           string `json:"match"`
	Open            int64  `json:"open,string"`
	High            int64  `json:"high,string"`
	Low             int64  `json:"low,string"`
	Close           int64  `json:"close,string"`
	ValidityMinutes int64  `json:"validity_minutes"`
}

type Usage struct {
	InputTokens  int32 `json:"prompt_tokens"`
	OutputTokens int32 `json:"completion_tokens"`
}

type Provider interface {
	Explain(context.Context, Evidence) (string, *Usage, error)
}

// ParseFocus accepts one known reference. Compaction permits JSON whitespace while
// the exact shape also rejects duplicate keys, unsupported fields and model numbers.
func ParseFocus(raw string) (string, error) {
	var compact bytes.Buffer
	if err := json.Compact(&compact, []byte(raw)); err != nil {
		return "", ErrInvalidOutput
	}
	switch compact.String() {
	case `{"focus":"rule"}`:
		return "rule", nil
	case `{"focus":"snapshot"}`:
		return "snapshot", nil
	case `{"focus":"report"}`:
		return "report", nil
	default:
		return "", ErrInvalidOutput
	}
}
