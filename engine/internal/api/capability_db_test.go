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
	"tradinglab/engine/internal/store/storetest"
)

func TestCapabilitiesKeepCrossDataReadableAndRejectExecution(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	bs := waveBars(10)
	for i := range bs {
		bs[i].Instrument = "ETHBTC"
	}
	_, err := data.UpsertBars(ctx, st, "ETHBTC", "archive", "capability", bs)
	require.NoError(t, err)
	ds, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{Symbol: "ETHBTC", Timeframe: data.TF1m, From: bs[0].OpenTime, To: bs[len(bs)-1].CloseTime, GapPolicy: data.GapFlag})
	require.NoError(t, err)
	svc := report.Service{Store: st}
	clk := clock.NewVirtual(bs[len(bs)-1].CloseTime.Add(time.Hour))
	srv := serve(t,
		func(m *http.ServeMux) { m.Handle(labv1connect.NewDataServiceHandler(&Data{Store: st, Clock: clk})) },
		func(m *http.ServeMux) { m.Handle(labv1connect.NewReportServiceHandler(&Report{Svc: svc})) },
		func(m *http.ServeMux) { m.Handle(labv1connect.NewChartServiceHandler(&Chart{Svc: svc, Clock: clk})) })
	client := labv1connect.NewDataServiceClient(srv.Client(), srv.URL)
	ov, err := client.GetOverview(ctx, connect.NewRequest(&labv1.GetOverviewRequest{}))
	require.NoError(t, err)
	require.Contains(t, ov.Msg.Symbols, "ETHBTC", "data/import scope remains visible")
	caps := map[string]*labv1.ResearchCapability{}
	for _, c := range ov.Msg.ResearchCapabilities {
		caps[c.Symbol] = c
	}
	require.True(t, caps["BTCUSDT"].Supported)
	require.False(t, caps["ETHBTC"].Supported)
	require.Contains(t, caps["ETHBTC"].Reason, "USDT")
	list, err := client.ListDatasets(ctx, connect.NewRequest(&labv1.ListDatasetsRequest{}))
	require.NoError(t, err)
	require.Equal(t, ds.ID, list.Msg.Datasets[0].Id)
	_, _, err = svc.Bars(ctx, []string{ds.ID})
	require.NoError(t, err, "historical data reads are independent of execution permission")
	chart, err := labv1connect.NewChartServiceClient(srv.Client(), srv.URL).GetChart(ctx, connect.NewRequest(&labv1.GetChartRequest{Symbol: "ETHBTC", Timeframe: "1m"}))
	require.NoError(t, err)
	require.Equal(t, "ETHBTC", chart.Msg.Symbol)
	_, err = labv1connect.NewReportServiceClient(srv.Client(), srv.URL).CreateReport(ctx, connect.NewRequest(&labv1.CreateReportRequest{Spec: &labv1.ReportSpec{DatasetIds: []string{ds.ID}, Strategy: "hold-cash", Capital: usdtMoney("1000")}}))
	require.Equal(t, connect.CodeFailedPrecondition, connect.CodeOf(err), "crafted RPCs cannot bypass the picker")
}
