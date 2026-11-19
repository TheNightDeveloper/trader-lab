package api

import (
	"context"
	"net/http"
	"strings"
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
		func(m *http.ServeMux) { m.Handle((&Chart{Svc: svc, Clock: clk}).Handler()) })
	client := labv1connect.NewDataServiceClient(srv.Client(), srv.URL)
	ov, err := client.GetOverview(ctx, connect.NewRequest(&labv1.GetOverviewRequest{}))
	require.NoError(t, err)
	require.Contains(t, ov.Msg.Symbols, "ETHBTC", "data/import scope remains visible")
	caps := map[string]*labv1.ResearchCapability{}
	for _, c := range ov.Msg.ResearchCapabilities {
		caps[c.Symbol] = c
	}
	require.True(t, caps["BTCUSDT"].Supported)
	require.Equal(t, "binance", caps["BTCUSDT"].GetInstrument().GetVenue())
	require.Equal(t, labv1.MarketProduct_MARKET_PRODUCT_SPOT, caps["BTCUSDT"].GetInstrument().GetProduct())
	require.Equal(t, "BTCUSDT", caps["BTCUSDT"].GetInstrument().GetSymbol())
	require.Regexp(t, `^sha256:[0-9a-f]{64}$`, caps["BTCUSDT"].GetInstrument().GetSpecRevision())
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

func TestDatasetCatalogSearchAndSavedSelection(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	// Equal creation times require the ID tie-breaker for deterministic pages.
	_, err := st.Pool.Exec(ctx, `
		INSERT INTO datasets (id, symbol, timeframe, range_from, range_to, gap_policy, known_at, bar_count, manifest)
		SELECT 'ds_' || lpad(i::text, 4, '0'), CASE WHEN i = 202 THEN 'ETHBTC' ELSE 'BTCUSDT' END,
		       '1h', now() - interval '1 hour', now(), 'flag', now(), 1, '{}'::jsonb
		FROM generate_series(1, 202) AS i`)
	require.NoError(t, err)
	srv := serve(t, func(m *http.ServeMux) {
		m.Handle(labv1connect.NewDataServiceHandler(&Data{Store: st}))
	})
	client := labv1connect.NewDataServiceClient(srv.Client(), srv.URL)
	list := func(req *labv1.ListDatasetsRequest) *labv1.ListDatasetsResponse {
		t.Helper()
		resp, err := client.ListDatasets(ctx, connect.NewRequest(req))
		require.NoError(t, err)
		return resp.Msg
	}
	first := list(&labv1.ListDatasetsRequest{PageSize: 200, Query: "  btcusdt   1H ", ResearchOnly: true})
	require.EqualValues(t, 201, first.Total)
	require.Len(t, first.Datasets, 200)
	second := list(&labv1.ListDatasetsRequest{PageSize: 200, Offset: 200, Query: "btcusdt 1h", ResearchOnly: true})
	require.Len(t, second.Datasets, 1)
	require.Equal(t, "ds_0201", second.Datasets[0].Id)
	saved := list(&labv1.ListDatasetsRequest{Ids: []string{"ds_0201", "ds_0202"}, ResearchOnly: true})
	require.EqualValues(t, 1, saved.Total)
	require.Len(t, saved.Datasets, 1)
	require.Equal(t, "ds_0201", saved.Datasets[0].Id)
	require.EqualValues(t, 1, list(&labv1.ListDatasetsRequest{Symbol: " ethbtc "}).Total)
	require.EqualValues(t, 202, list(&labv1.ListDatasetsRequest{Timeframe: "1h"}).Total)
	require.Zero(t, list(&labv1.ListDatasetsRequest{Timeframe: "4h"}).Total)
	require.Zero(t, list(&labv1.ListDatasetsRequest{Query: "%"}).Total, "search characters are literal")
	require.EqualValues(t, 202, list(&labv1.ListDatasetsRequest{Offset: 300}).Total)
	_, err = client.ListDatasets(ctx, connect.NewRequest(&labv1.ListDatasetsRequest{Query: strings.Repeat("x", 129)}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))
}
