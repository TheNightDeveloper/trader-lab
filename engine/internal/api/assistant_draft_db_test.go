package api

import (
	"context"
	"encoding/json"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/assistant"
	"tradinglab/engine/internal/clock"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/store/storetest"
)

func TestAssistantDraftRequiresReviewAndAuditsWithoutText(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	st := storetest.Open(t)
	const description = "خصوصی: کندل ۱ ساعته؛ ورود بالای میانگین ۲۰، خروج زیر میانگین ۱۰، سهم ۲۵ درصد"
	const definition = `{"format":"rules/v1","base_timeframe":"1h","exposure":"0.25","entry":{"op":"gt","left":{"kind":"close"},"right":{"kind":"sma","period":20}},"exit":{"op":"lt","left":{"kind":"close"},"right":{"kind":"sma","period":10}}}`
	modelDraft, err := json.Marshal(map[string]any{"definition_json": definition, "questions": []string{}})
	require.NoError(t, err)
	entered, publish := make(chan struct{}), make(chan struct{})
	var calls atomic.Int32
	a := &Assistant{Store: st, Clock: clock.Wall{}, DailyRequests: 2, Provider: assistantFunc(func(ctx context.Context, prompt assistant.Request) (string, *assistant.Usage, error) {
		input, _ := prompt.InputJSON()
		var text string
		if err := json.Unmarshal(input, &text); err != nil || text != description {
			return "", nil, assistant.ErrInvalidOutput
		}
		usage := &assistant.Usage{InputTokens: 640, OutputTokens: 175}
		if calls.Add(1) == 1 {
			close(entered)
			select {
			case <-publish:
			case <-ctx.Done():
				return "", nil, ctx.Err()
			}
			return string(modelDraft), usage, nil
		}
		return `{"definition_json":"","questions":["exit"]}`, usage, nil
	})}
	draft := func(text string) (*connect.Response[labv1.DraftStrategyResponse], error) {
		return a.DraftStrategy(ctx, connect.NewRequest(&labv1.DraftStrategyRequest{Description: text}))
	}
	for _, text := range []string{"   ", strings.Repeat("ا", 1201), "الف\x00ب"} {
		_, err := draft(text)
		require.Equal(t, connect.CodeInvalidArgument, code(err))
	}
	type reply struct {
		res *connect.Response[labv1.DraftStrategyResponse]
		err error
	}
	first := make(chan reply, 1)
	go func() {
		res, err := draft(description)
		first <- reply{res, err}
	}()
	select {
	case <-entered:
	case got := <-first:
		t.Fatalf("provider did not start: %v", got.err)
	case <-ctx.Done():
		t.Fatal(ctx.Err())
	}
	_, err = draft(description)
	close(publish)
	require.Equal(t, connect.CodeAborted, code(err))
	got := <-first
	require.NoError(t, got.err)
	require.JSONEq(t, strings.Replace(definition, `"0.25"`, `"0.250000"`, 1), got.res.Msg.GetDefinitionJson())
	require.EqualValues(t, 20, got.res.Msg.GetLookbackBars())
	clarification, err := draft(description)
	require.NoError(t, err)
	require.Equal(t, []labv1.DraftQuestion{labv1.DraftQuestion_DRAFT_QUESTION_EXIT}, clarification.Msg.GetQuestions())
	require.Empty(t, clarification.Msg.GetDefinitionJson())
	_, err = draft(description)
	require.Equal(t, connect.CodeResourceExhausted, code(err))
	require.EqualValues(t, 2, calls.Load())

	var versions int
	require.NoError(t, st.Pool.QueryRow(ctx, `SELECT count(*) FROM strategy_rule_versions`).Scan(&versions))
	require.Zero(t, versions)
	var audit string
	require.NoError(t, st.Pool.QueryRow(ctx, `SELECT json_agg(to_jsonb(a) ORDER BY id)::text FROM assistant_runs a WHERE rule_draft`).Scan(&audit))
	require.Contains(t, audit, `"focus": "draft"`)
	require.Contains(t, audit, `"focus": "needs_definition"`)
	require.NotContains(t, audit, "خصوصی")
	require.NotContains(t, audit, "base_timeframe")
	_, err = (&Library{Store: st}).SaveRuleVersion(ctx, connect.NewRequest(&labv1.SaveRuleVersionRequest{
		Title: "Reviewed draft", DefinitionJson: got.res.Msg.GetDefinitionJson(),
	}))
	require.NoError(t, err)
}
