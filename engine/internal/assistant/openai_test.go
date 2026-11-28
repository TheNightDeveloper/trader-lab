package assistant

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestParseFocus(t *testing.T) {
	prompt := Opportunity(Evidence{})
	for _, focus := range []string{"rule", "snapshot", "report"} {
		got, err := prompt.ParseFocus(`{ "focus" : "` + focus + `" }`)
		require.NoError(t, err)
		require.Equal(t, focus, got)
	}
	for _, raw := range []string{
		`{"focus":"external_news"}`, `{"focus":"rule","price":120}`, `{"focus":99}`,
		`{"focus":"rule","focus":"report"}`, `{"focus":"rule"}{}`, `{"tool":"place_order"}`, `null`,
	} {
		_, err := prompt.ParseFocus(raw)
		require.ErrorIs(t, err, ErrInvalidOutput, raw)
	}
}

func TestResearchFocusRequiresAnAvailableMetric(t *testing.T) {
	prompt := Research([]map[string]string{{"closed_trades": "4"}}, []string{"closed_trades"})
	focus, err := prompt.ParseFocus(`{"focus":"closed_trades"}`)
	require.NoError(t, err)
	require.Equal(t, "closed_trades", focus)
	_, err = prompt.ParseFocus(`{"focus":"total_return"}`)
	require.ErrorIs(t, err, ErrInvalidOutput)
}

type transportFunc func(*http.Request) (*http.Response, error)

func (f transportFunc) RoundTrip(req *http.Request) (*http.Response, error) { return f(req) }

func TestOpenAIUsesBoundedStructuredRequest(t *testing.T) {
	p := NewOpenAI("fixture-key")
	prompt := Opportunity(Evidence{Symbol: "BTCUSDT", Match: "rule entry"})
	p.client.Transport = transportFunc(func(r *http.Request) (*http.Response, error) {
		require.Equal(t, "https://api.openai.com/v1/chat/completions", r.URL.String())
		require.Equal(t, "Bearer fixture-key", r.Header.Get("Authorization"))
		defer func() { _ = r.Body.Close() }()
		var request map[string]json.RawMessage
		require.NoError(t, json.NewDecoder(r.Body).Decode(&request))
		require.JSONEq(t, `"`+Model+`"`, string(request["model"]))
		require.JSONEq(t, `96`, string(request["max_completion_tokens"]))
		require.JSONEq(t, `false`, string(request["store"]))
		require.JSONEq(t, string(prompt.schema()), string(request["response_format"]))
		require.NotContains(t, request, "tools")
		require.NotContains(t, request, "tool_choice")
		return &http.Response{StatusCode: http.StatusOK, Body: io.NopCloser(strings.NewReader(`{
			"model":"` + Model + `","choices":[{"finish_reason":"stop","message":{"role":"assistant","content":"{\"focus\":\"rule\"}"}}],
			"usage":{"prompt_tokens":100,"completion_tokens":8}
		}`))}, nil
	})
	text, usage, err := p.Explain(context.Background(), prompt)
	require.NoError(t, err)
	require.JSONEq(t, `{"focus":"rule"}`, text)
	require.Equal(t, &Usage{InputTokens: 100, OutputTokens: 8}, usage)
}

func TestOpenAIRefusesRedirects(t *testing.T) {
	p := NewOpenAI("fixture-key")
	calls := 0
	p.client.Transport = transportFunc(func(r *http.Request) (*http.Response, error) {
		calls++
		return &http.Response{StatusCode: http.StatusTemporaryRedirect,
			Header: http.Header{"Location": {"https://example.com/redirect"}}, Body: http.NoBody, Request: r}, nil
	})
	_, _, err := p.Explain(context.Background(), Opportunity(Evidence{}))
	require.ErrorContains(t, err, "HTTP 307")
	require.Equal(t, 1, calls)
}
