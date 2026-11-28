// Package assistant interprets model output without exposing engine commands.
package assistant

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
)

const Model = "gpt-4.1-mini-2025-04-14"

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
	Explain(context.Context, Request) (string, *Usage, error)
}

// Request uses a pinned prompt and a per-request evidence allowlist.
type Request struct {
	version, prompt string
	input           any
	focus           []string
}

func Opportunity(e Evidence) Request {
	return Request{"opportunity-focus-v1", `Select the best evidence to inspect first for a saved spot strategy observation. Choose rule to inspect the trigger (including regime matches), snapshot to inspect an unusual candle or short validity window, or report to examine historical evidence when the observation alone is routine. Prices use one common integer scale. Return only the focus reference. There are no actions to execute.`,
		e, []string{"rule", "snapshot", "report"}}
}

// Research receives only fixed-point out-of-sample metrics, in displayed order.
func Research(columns []map[string]string, focus []string) Request {
	return Request{"research-focus-v1", `Pick the out-of-sample metric most useful to review for these saved research runs. Ratios are integer parts per million and closed trades are counts. For low counts prefer closed_trades when available. Otherwise draw attention to the return or worst peak-to-trough loss, especially a large difference. Missing fields are unavailable. No ranking, new numbers, trade advice, or actions. Return only the focus reference.`,
		columns, focus}
}

func (r Request) Version() string { return r.version }

func (r Request) InputJSON() ([]byte, error) { return json.Marshal(r.input) }

func (r Request) MaxOutput() int32 {
	if r.IsDraft() {
		return 1800
	}
	return 96
}

func (r Request) schema() json.RawMessage {
	if r.IsDraft() {
		return json.RawMessage(draftSchema)
	}
	values, _ := json.Marshal(r.focus) // strings always encode
	return json.RawMessage(fmt.Sprintf(`{"type":"json_schema","json_schema":{"name":"evidence_focus","strict":true,"schema":{"type":"object","properties":{"focus":{"type":"string","enum":%s}},"required":["focus"],"additionalProperties":false}}}`, values))
}

type Result struct {
	Focus string
	Draft DraftResult
}

func (r Request) Parse(raw string) (Result, error) {
	if description, ok := r.input.(draftText); ok {
		draft, err := parseDraft(raw, description)
		if err != nil {
			return Result{}, err
		}
		focus := "draft"
		if len(draft.Questions) > 0 {
			focus = "needs_definition"
		}
		return Result{Focus: focus, Draft: draft}, nil
	}
	focus, err := r.ParseFocus(raw)
	return Result{Focus: focus}, err
}

// ParseFocus allows JSON whitespace. The exact shape rejects duplicate keys,
// unsupported references, extra fields and model-generated numbers.
func (r Request) ParseFocus(raw string) (string, error) {
	var compact bytes.Buffer
	if err := json.Compact(&compact, []byte(raw)); err != nil {
		return "", ErrInvalidOutput
	}
	for _, focus := range r.focus {
		if compact.String() == `{"focus":`+fmt.Sprintf("%q", focus)+`}` {
			return focus, nil
		}
	}
	return "", ErrInvalidOutput
}
