package assistant

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

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

func (p *OpenAI) Explain(ctx context.Context, request Request) (string, *Usage, error) {
	input, err := request.InputJSON()
	if err != nil {
		return "", nil, err
	}
	body, err := json.Marshal(struct {
		Model          string          `json:"model"`
		Messages       []message       `json:"messages"`
		MaxCompletion  int32           `json:"max_completion_tokens"`
		ResponseFormat json.RawMessage `json:"response_format"`
		Store          bool            `json:"store"`
	}{Model, []message{{"system", request.prompt}, {"user", string(input)}}, request.MaxOutput(), request.schema(), false})
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
