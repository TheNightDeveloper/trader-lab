package api

import (
	"context"
	"net/http"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
	"tradinglab/engine/internal/strategy"
)

func TestChartService(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	bars := waveBars(6000)
	_, err := data.UpsertBars(ctx, st, "BTCUSDT", "archive", "t", bars)
	require.NoError(t, err)
	ds, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{Symbol: "BTCUSDT", Timeframe: data.TF1m, From: bars[0].OpenTime, To: bars[len(bars)-1].CloseTime, GapPolicy: data.GapFlag})
	require.NoError(t, err)
	svc := report.Service{Store: st, Version: "test"}
	srv := serve(t,
		func(m *http.ServeMux) { m.Handle(labv1connect.NewReportServiceHandler(&Report{Svc: svc})) },
		func(m *http.ServeMux) {
			m.Handle(labv1connect.NewChartServiceHandler(&Chart{Svc: svc, Clock: clock.NewVirtual(bars[len(bars)-1].CloseTime.Add(time.Minute))}))
		})
	rc := labv1connect.NewReportServiceClient(srv.Client(), srv.URL)
	cc := labv1connect.NewChartServiceClient(srv.Client(), srv.URL)
	created, err := rc.CreateReport(ctx, connect.NewRequest(&labv1.CreateReportRequest{Spec: &labv1.ReportSpec{
		DatasetIds: []string{ds.ID}, Strategy: "trend-ema", Params: map[string]float64{"fast": 10, "slow": 30},
		Capital: usdtMoney("1000"), Fee: dec("0.001"), Slippage: dec("0.0005"), Folds: 3,
	}}))
	require.NoError(t, err)
	id := created.Msg.GetReportId()
	stored, err := svc.Load(ctx, id)
	require.NoError(t, err)

	res, err := cc.GetChart(ctx, connect.NewRequest(&labv1.GetChartRequest{ReportId: id, Indicators: []string{"ema:10", "ema:30", "rsi:14"}, MaxBars: 10_000}))
	require.NoError(t, err)
	c := res.Msg
	require.Equal(t, "BTCUSDT", c.GetSymbol())
	require.EqualValues(t, 2, c.GetPricePrecision())
	last := c.GetBars()[len(c.GetBars())-1]
	require.Less(t, last.GetOpenUnixMs(), stored.Split.OOS.To.UnixMilli(), "the holdout stays hidden")
	require.Equal(t, int(c.GetTotalBars()), len(c.GetBars()))

	// Indicator values are the engine's, to 8 decimals.
	shown := bars[:len(c.GetBars())]
	ema10, err := strategy.ComputeIndicator("ema:10", shown)
	require.NoError(t, err)
	for i, v := range c.GetIndicators()[0].GetLines()[0].GetValues() {
		require.Equal(t, indicatorValue(ema10.Lines[0].Values[i]), v, "bar %d", i)
	}
	require.Empty(t, c.GetIndicators()[1].GetLines()[0].GetValues()[0], "warm-up: no value, not zero")
	require.Equal(t, "sub", c.GetIndicators()[2].GetPane())

	// Every filled decision is a marker on its bar; entries above zero target.
	decs, err := st.AllDecisions(ctx, db.AllDecisionsParams{ReportID: id, Run: report.RunMain})
	require.NoError(t, err)
	filled := 0
	for _, d := range decs {
		if sim.Outcome(d.Outcome) == sim.OutcomeFilled {
			filled++
		}
	}
	require.Positive(t, filled)
	n := 0
	for _, m := range c.GetMarkers() {
		if m.GetDecisionId() > 0 && m.GetKind() != "rejected" {
			n++
		}
	}
	require.Equal(t, filled, n)
	m := c.GetMarkers()[0]
	require.Equal(t, "entry", m.GetKind(), "trend-ema starts flat: first marker buys")

	dr, err := cc.GetDecision(ctx, connect.NewRequest(&labv1.GetDecisionRequest{ReportId: id, DecisionId: m.GetDecisionId()}))
	require.NoError(t, err)
	require.Contains(t, dr.Msg.GetDecision().GetReason(), "crossed above")
	require.Equal(t, m.GetPrice().GetUnits(), dr.Msg.GetRefPrice().GetUnits(), "reference = close of the decision bar")

	// The latest bars cut keeps indicators warm from earlier bars.
	cut, err := cc.GetChart(ctx, connect.NewRequest(&labv1.GetChartRequest{ReportId: id, Indicators: []string{"ema:30"}, MaxBars: 100}))
	require.NoError(t, err)
	require.Len(t, cut.Msg.GetBars(), 100)
	require.NotEmpty(t, cut.Msg.GetIndicators()[0].GetLines()[0].GetValues()[0])

	// No report: latest bars of a pair.
	live, err := cc.GetChart(ctx, connect.NewRequest(&labv1.GetChartRequest{Symbol: "BTCUSDT", Timeframe: "1h", MaxBars: 50}))
	require.NoError(t, err)
	require.Len(t, live.Msg.GetBars(), 50)
	require.Empty(t, live.Msg.GetMarkers())
	_, err = cc.GetChart(ctx, connect.NewRequest(&labv1.GetChartRequest{Symbol: "NOPE", Timeframe: "1h"}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))
	_, err = cc.GetChart(ctx, connect.NewRequest(&labv1.GetChartRequest{ReportId: id, Indicators: []string{"vwap:3"}}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))
}
