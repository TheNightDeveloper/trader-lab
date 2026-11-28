package api

import (
	"context"
	"net/http"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/assistant"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
)

type assistantFunc func(context.Context, assistant.Evidence) (string, *assistant.Usage, error)

func (f assistantFunc) Explain(ctx context.Context, e assistant.Evidence) (string, *assistant.Usage, error) {
	return f(ctx, e)
}

func TestAssistantAuditsFailureAndReusesRecordedEvidence(t *testing.T) {
	ctx := context.Background()
	market, wall, _, id := paperFixture(t)
	usage := &assistant.Usage{InputTokens: 120, OutputTokens: 8}
	var calls atomic.Int32
	a := &Assistant{Store: market.Store, Clock: wall, DailyRequests: 1, Provider: assistantFunc(func(_ context.Context, input assistant.Evidence) (string, *assistant.Usage, error) {
		require.Equal(t, "rule entry", input.Match)
		require.EqualValues(t, 100*paperTestUnit, input.Close)
		if calls.Add(1) == 1 {
			return `{"focus":"rule","price":123}`, usage, nil
		}
		return `{"focus":"report"}`, usage, nil
	})}
	srv := serve(t, func(mux *http.ServeMux) { mux.Handle(labv1connect.NewAssistantServiceHandler(a)) })
	client := labv1connect.NewAssistantServiceClient(srv.Client(), srv.URL)
	explain := func(id int64) (*connect.Response[labv1.ExplainOpportunityResponse], error) {
		return client.ExplainOpportunity(ctx, connect.NewRequest(&labv1.ExplainOpportunityRequest{OpportunityId: id}))
	}
	_, err := explain(id + 1)
	require.Equal(t, connect.CodeNotFound, code(err))
	_, err = explain(id)
	require.Equal(t, connect.CodeUnavailable, code(err))
	_, err = explain(id)
	require.Equal(t, connect.CodeResourceExhausted, code(err))
	var status string
	var input int32
	var latency int64
	require.NoError(t, market.Store.Pool.QueryRow(ctx, `SELECT status, input_tokens, latency_ms FROM assistant_runs`).Scan(&status, &input, &latency))
	require.Equal(t, "invalid_output", status)
	require.Equal(t, usage.InputTokens, input)
	require.GreaterOrEqual(t, latency, int64(0))

	// Only the historical observation is used once the opportunity has expired.
	require.NoError(t, wall.Set(wall.Now().Add(24*time.Hour)))
	first, err := explain(id)
	require.NoError(t, err)
	require.False(t, first.Msg.GetCached())
	require.Equal(t, "paper-evidence", first.Msg.GetReportId())
	require.Equal(t, usdtP(100*paperTestUnit).GetUnits(), first.Msg.GetReferenceClose().GetUnits())
	require.Equal(t, labv1.ExplanationFocus_EXPLANATION_FOCUS_REPORT, first.Msg.GetFocus())
	second, err := explain(id)
	require.NoError(t, err)
	require.True(t, second.Msg.GetCached())
	require.Equal(t, first.Msg.GetFocus(), second.Msg.GetFocus())
	require.EqualValues(t, 2, calls.Load())
}

func TestAssistantDeduplicatesConcurrentRequestsAndPersistsCancellation(t *testing.T) {
	market, wall, _, id := paperFixture(t)
	started := make(chan struct{})
	a := &Assistant{Store: market.Store, Clock: wall, DailyRequests: 2, Provider: assistantFunc(func(ctx context.Context, _ assistant.Evidence) (string, *assistant.Usage, error) {
		close(started)
		<-ctx.Done()
		return "", nil, ctx.Err()
	})}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	request := connect.NewRequest(&labv1.ExplainOpportunityRequest{OpportunityId: id})
	result := make(chan error, 1)
	go func() {
		_, err := a.ExplainOpportunity(ctx, request)
		result <- err
	}()
	select {
	case <-started:
	case err := <-result:
		t.Fatalf("provider did not start: %v", err)
	case <-ctx.Done():
		t.Fatal(ctx.Err())
	}
	_, err := a.ExplainOpportunity(ctx, connect.NewRequest(request.Msg))
	require.Equal(t, connect.CodeAborted, code(err))
	cancel()
	require.Equal(t, connect.CodeCanceled, code(<-result))
	var rows int
	var status string
	var usageMissing bool
	require.NoError(t, market.Store.Pool.QueryRow(context.Background(), `SELECT count(*), min(status), bool_and(input_tokens IS NULL) FROM assistant_runs`).Scan(&rows, &status, &usageMissing))
	require.Equal(t, 1, rows)
	require.Equal(t, "canceled", status)
	require.True(t, usageMissing)
}
