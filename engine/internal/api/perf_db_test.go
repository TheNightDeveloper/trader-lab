package api

import (
	"context"
	"net/http"
	"slices"
	"sync"
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

// Plan M6: report-read API p95 < 1 s at 5 concurrent requests. Measured on a
// report over 100k 1m bars; GetChart (which reloads the dataset) is measured too.
func TestReportReadLatency(t *testing.T) {
	if testing.Short() {
		t.Skip("performance test")
	}
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	bars := waveBars(100_000)
	_, err := data.UpsertBars(ctx, st, "BTCUSDT", "archive", "t", bars)
	require.NoError(t, err)
	ds, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{Symbol: "BTCUSDT", Timeframe: data.TF1m, From: bars[0].OpenTime, To: bars[len(bars)-1].CloseTime, GapPolicy: data.GapFlag})
	require.NoError(t, err)
	svc := report.Service{Store: st, Version: "test"}
	srv := serve(t,
		func(m *http.ServeMux) { m.Handle(labv1connect.NewReportServiceHandler(&Report{Svc: svc})) },
		func(m *http.ServeMux) {
			m.Handle(labv1connect.NewChartServiceHandler(&Chart{Svc: svc, Clock: clock.NewVirtual(time.Now())}))
		})
	rc := labv1connect.NewReportServiceClient(srv.Client(), srv.URL)
	cc := labv1connect.NewChartServiceClient(srv.Client(), srv.URL)
	created, err := rc.CreateReport(ctx, connect.NewRequest(&labv1.CreateReportRequest{Spec: &labv1.ReportSpec{
		DatasetIds: []string{ds.ID}, Strategy: "trend-ema", Params: map[string]float64{"fast": 10, "slow": 30},
		Capital: usdtMoney("1000"), Fee: dec("0.001"), Slippage: dec("0.0005"), Folds: 4,
	}}))
	require.NoError(t, err)
	id := created.Msg.GetReportId()

	measure := func(name string, call func() error) {
		const clients, each = 5, 20
		var mu sync.Mutex
		var lat []time.Duration
		var wg sync.WaitGroup
		for range clients {
			wg.Go(func() {
				for range each {
					t0 := time.Now()
					require.NoError(t, call())
					d := time.Since(t0)
					mu.Lock()
					lat = append(lat, d)
					mu.Unlock()
				}
			})
		}
		wg.Wait()
		slices.Sort(lat)
		p50, p95 := lat[len(lat)/2], lat[len(lat)*95/100]
		t.Logf("%s: %d requests, 5 concurrent: p50 %s, p95 %s, max %s", name, len(lat), p50.Round(time.Millisecond), p95.Round(time.Millisecond), lat[len(lat)-1].Round(time.Millisecond))
		require.Less(t, p95, time.Second, name)
	}
	measure("GetReport", func() error {
		_, err := rc.GetReport(ctx, connect.NewRequest(&labv1.GetReportRequest{ReportId: id}))
		return err
	})
	measure("GetChart", func() error {
		_, err := cc.GetChart(ctx, connect.NewRequest(&labv1.GetChartRequest{ReportId: id, Indicators: []string{"ema:10", "ema:30", "bb:20:2"}}))
		return err
	})
}
