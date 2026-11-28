package assistant

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

const focusPrompt = `Select the best evidence to inspect first for a saved spot strategy observation. Choose rule to inspect the trigger (including regime matches), snapshot to inspect an unusual candle or short validity window, or report to examine historical evidence when the observation alone is routine. Prices use one common integer scale. Return only the focus reference. There are no actions to execute.`

const focusSchema = `{"type":"json_schema","json_schema":{"name":"opportunity_focus","strict":true,"schema":{"type":"object","properties":{"focus":{"type":"string","enum":["rule","snapshot","report"]}},"required":["focus"],"additionalProperties":false}}}`

type OpenAI struct {
	key    string
	client *http.Client
}

func NewOpenAI(key string) *OpenAI {
	return &OpenAI{key: key, client: &http.Client{
		// The paid request and its credentials belong to one fixed endpoint.
		CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse },
	}}
}

type message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

func (p *OpenAI) Explain(ctx context.Context, evidence Evidence) (string, *Usage, error) {
	input, err := json.Marshal(evidence)
	if err != nil {
		return "", nil, err
	}
	body, err := json.Marshal(struct {
		Model          string          `json:"model"`
		Messages       []message       `json:"messages"`
		MaxCompletion  int             `json:"max_completion_tokens"`
		ResponseFormat json.RawMessage `json:"response_format"`
		Store          bool            `json:"store"`
	}{Model, []message{{"system", focusPrompt}, {"user", string(input)}}, MaxOutput, json.RawMessage(focusSchema), false})
	if err != nil {
		return "", nil, err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, "https://api.openai.com/v1/chat/completions", bytes.NewReader(body))
	if err != nil {
		return "", nil, err
	}
	req.Header.Set("Authorization", "Bearer "+p.key)
	req.Header.Set("Content-Type", "application/json")
	res, err := p.client.Do(req)
	if err != nil {
		return "", nil, err
	}
	defer func() { _ = res.Body.Close() }()
	if res.StatusCode != http.StatusOK {
		return "", nil, fmt.Errorf("assistant provider returned HTTP %d", res.StatusCode)
	}
	var result struct {
		Model   string `json:"model"`
		Choices []struct {
			Finish  string  `json:"finish_reason"`
			Message message `json:"message"`
		} `json:"choices"`
		Usage *Usage `json:"usage"`
	}
	const maxResponse = 32 << 10
	payload, err := io.ReadAll(io.LimitReader(res.Body, maxResponse+1))
	if err != nil {
		return "", nil, err
	}
	if len(payload) > maxResponse || json.Unmarshal(payload, &result) != nil {
		return "", nil, ErrInvalidOutput
	}
	if result.Model != Model || len(result.Choices) != 1 || result.Choices[0].Finish != "stop" || result.Choices[0].Message.Role != "assistant" {
		return "", result.Usage, ErrInvalidOutput
	}
	return result.Choices[0].Message.Content, result.Usage, nil
}
