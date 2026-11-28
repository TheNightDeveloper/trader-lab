package api

import (
	"context"
	"encoding/json"
	"net/http"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/assistant"
	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/store/db"
)

func TestAssistantResearchUsesPublicEvidenceAndSharedBudget(t *testing.T) {
	ctx := context.Background()
	market, wall, _, opportunity := paperFixture(t)
	marshal := func(value any) []byte {
		t.Helper()
		b, err := json.Marshal(value)
		require.NoError(t, err)
		return b
	}
	window := eval.Window{From: wall.Now().Add(-48 * time.Hour), To: wall.Now().Add(-24 * time.Hour)}
	add := func(id string, closed int64, period eval.Window) {
		t.Helper()
		require.NoError(t, market.Store.InsertReport(ctx, db.InsertReportParams{
			ID: id, Title: "PRIVATE REPORT TITLE",
			Spec: []byte(`{"strategy":"PRIVATE STRATEGY TITLE","sim":{"capital":"100 USDT"}}`), Split: marshal(eval.Split{OOS: period}),
			Evaluation: marshal(eval.Evaluation{OOS: eval.RunView{Metrics: []metrics.Metric{
				{Key: "closed_trades", Unit: metrics.Count, V: closed, Valid: true},
				{Key: "total_return", Unit: metrics.Ratio, V: 123, Scale: 6, Valid: false, Invalid: "UNAVAILABLE VALUE"},
				{Key: "max_drawdown", Unit: metrics.Ratio, V: 450, Scale: 6, Valid: true},
			}}}),
			Holdout: []byte(`{"secret":"PRIVATE HOLDOUT"}`),
		}))
	}
	add("first", 4, window)
	add("second", 40, window)
	add("different-period", 40, eval.Window{From: window.From.Add(time.Hour), To: window.To})

	var calls atomic.Int32
	a := &Assistant{Store: market.Store, Clock: wall, DailyRequests: 2, Provider: assistantFunc(func(_ context.Context, prompt assistant.Request) (string, *assistant.Usage, error) {
		usage := &assistant.Usage{InputTokens: 110, OutputTokens: 9}
		raw, err := prompt.InputJSON()
		if err != nil {
			return "", nil, err
		}
		require.JSONEq(t, `[{"closed_trades":"4","max_drawdown":"450"},{"closed_trades":"40","max_drawdown":"450"}]`, string(raw))
		if calls.Add(1) == 1 {
			return `{"focus":"total_return"}`, usage, nil
		}
		return `{"focus":"closed_trades"}`, usage, nil
	})}
	srv := serve(t, func(mux *http.ServeMux) { mux.Handle(labv1connect.NewAssistantServiceHandler(a)) })
	client := labv1connect.NewAssistantServiceClient(srv.Client(), srv.URL)
	review := func(ids ...string) (*labv1.ReviewReportsResponse, error) {
		res, err := client.ReviewReports(ctx, connect.NewRequest(&labv1.ReviewReportsRequest{ReportIds: ids}))
		if err != nil {
			return nil, err
		}
		return res.Msg, nil
	}
	_, err := review("first", "first")
	require.Equal(t, connect.CodeInvalidArgument, code(err))
	_, err = review("missing")
	require.Equal(t, connect.CodeNotFound, code(err))
	blocked, err := review("first", "different-period")
	require.NoError(t, err)
	require.Equal(t, labv1.ResearchFocus_RESEARCH_FOCUS_ASSUMPTIONS, blocked.GetFocus())
	require.Equal(t, "period", blocked.GetBlockingAssumptions()[0].GetKey())
	require.Empty(t, blocked.GetModel())
	require.Zero(t, calls.Load())

	_, err = review("first", "second")
	require.Equal(t, connect.CodeUnavailable, code(err), "missing metric cannot be cited")
	result, err := review("first", "second")
	require.NoError(t, err)
	require.Equal(t, labv1.ResearchFocus_RESEARCH_FOCUS_SAMPLE, result.GetFocus())
	require.EqualValues(t, eval.MinReliableTrades, result.GetMinimumClosedTrades())
	require.Equal(t, "4", result.GetReferences()[0].GetMetric().GetValue().GetUnits())
	require.Equal(t, "second", result.GetReferences()[1].GetReportId())
	require.Equal(t, ms(window.From), result.GetReferences()[1].GetOosWindow().GetFromUnixMs())
	require.False(t, result.GetCached())
	result, err = review("first", "second")
	require.NoError(t, err)
	require.True(t, result.GetCached())
	_, err = review("second", "first")
	require.Equal(t, connect.CodeResourceExhausted, code(err), "the comparison baseline is ordered")
	_, err = client.ExplainOpportunity(ctx, connect.NewRequest(&labv1.ExplainOpportunityRequest{OpportunityId: opportunity}))
	require.Equal(t, connect.CodeResourceExhausted, code(err), "opportunities share the daily cap")
	require.EqualValues(t, 2, calls.Load())
	var runs int
	require.NoError(t, market.Store.Pool.QueryRow(ctx, `SELECT count(*) FROM assistant_runs WHERE opportunity_id IS NULL AND report_ids = ARRAY['first', 'second']`).Scan(&runs))
	require.Equal(t, 2, runs)
	views, err := market.Store.CountHoldoutViews(ctx, "first")
	require.NoError(t, err)
	require.Zero(t, views)
}
