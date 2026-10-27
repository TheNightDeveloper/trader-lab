package api

import (
	"archive/zip"
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/storetest"
)

var now = time.Date(2024, 3, 10, 12, 0, 0, 0, time.UTC)

func serve(t *testing.T, routes ...func(*http.ServeMux)) *httptest.Server {
	mux := http.NewServeMux()
	for _, r := range routes {
		r(mux)
	}
	srv := httptest.NewServer(mux)
	t.Cleanup(srv.Close)
	return srv
}

func code(err error) connect.Code { return connect.CodeOf(err) }

func TestFxRatesAndSidebar(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	fxSvc := &Fx{Store: st, Clock: clock.NewVirtual(now)}
	health := &Health{Clock: clock.NewVirtual(now), Every: time.Hour, Rates: fxSvc}
	srv := serve(t,
		func(m *http.ServeMux) { m.Handle(labv1connect.NewFxServiceHandler(fxSvc)) },
		func(m *http.ServeMux) { m.Handle(labv1connect.NewHealthServiceHandler(health)) })
	c := labv1connect.NewFxServiceClient(srv.Client(), srv.URL)

	for _, bad := range []*labv1.AddRateRequest{
		{Date: "2024-03-11", TomanPerUsdt: "60000"},     // future
		{Date: "10/03/2024", TomanPerUsdt: "60000"},     // format
		{Date: "2024-03-10", TomanPerUsdt: "0"},         // not positive
		{Date: "2024-03-10", TomanPerUsdt: "60000.123"}, // 3 decimals
		{Date: "2024-03-10", TomanPerUsdt: "6e4"},
	} {
		_, err := c.AddRate(ctx, connect.NewRequest(bad))
		require.Equal(t, connect.CodeInvalidArgument, code(err), "%v", bad)
	}

	_, err := c.AddRate(ctx, connect.NewRequest(&labv1.AddRateRequest{Date: "2024-03-09", TomanPerUsdt: "59500"}))
	require.NoError(t, err)
	res, err := c.AddRate(ctx, connect.NewRequest(&labv1.AddRateRequest{Date: "2024-03-10", TomanPerUsdt: "60123.5", Source: " bonbast "}))
	require.NoError(t, err)
	r := res.Msg.GetRate()
	require.Equal(t, "6012350", r.GetTomanPerUsdt().GetUnits())
	require.EqualValues(t, 2, r.GetTomanPerUsdt().GetScale())
	require.Equal(t, "TOMAN", r.GetTomanPerUsdt().GetAsset())
	require.Equal(t, "bonbast", r.GetSource())

	list, err := c.ListRates(ctx, connect.NewRequest(&labv1.ListRatesRequest{}))
	require.NoError(t, err)
	require.Len(t, list.Msg.GetRates(), 2)
	require.Equal(t, "2024-03-10", list.Msg.GetRates()[0].GetDate(), "newest first")
	require.Equal(t, "manual", list.Msg.GetRates()[1].GetSource())

	stream, err := labv1connect.NewHealthServiceClient(srv.Client(), srv.URL).Watch(ctx, connect.NewRequest(&labv1.WatchRequest{}))
	require.NoError(t, err)
	defer func() { _ = stream.Close() }()
	require.True(t, stream.Receive(), "%v", stream.Err())
	dr := stream.Msg().GetStatus().GetDisplayRate()
	require.Equal(t, "6012350", dr.GetTomanPerUsdt().GetUnits())
	require.Equal(t, "2024-03-10", dr.GetAsOfDate())
	require.Equal(t, fmt.Sprint(r.GetId()), dr.GetRateId())
}

func zipOf(t *testing.T, content string) []byte {
	var buf bytes.Buffer
	zw := zip.NewWriter(&buf)
	w, err := zw.Create("k.csv")
	require.NoError(t, err)
	_, _ = w.Write([]byte(content))
	require.NoError(t, zw.Close())
	return buf.Bytes()
}

func TestDataImportStreamAndViews(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))

	// Archive: 2024-01 monthly file with two days of bars and a 5-minute gap.
	var sb strings.Builder
	t0 := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	for i := 0; i < 2*1440; i++ {
		if i >= 100 && i < 105 {
			continue
		}
		ms := t0.Add(time.Duration(i) * time.Minute).UnixMilli()
		fmt.Fprintf(&sb, "%d,100.5,101,100,100.5,2,%d,0,1,0,0,0\n", ms, ms+59_999)
	}
	z := zipOf(t, sb.String())
	sum := sha256.Sum256(z)
	archive := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/data/spot/monthly/klines/BTCUSDT/1m/BTCUSDT-1m-2024-01.zip":
			_, _ = w.Write(z)
		case "/data/spot/monthly/klines/BTCUSDT/1m/BTCUSDT-1m-2024-01.zip.CHECKSUM":
			_, _ = fmt.Fprintf(w, "%s  x.zip\n", hex.EncodeToString(sum[:]))
		default:
			http.NotFound(w, r)
		}
	}))
	t.Cleanup(archive.Close)

	clk := clock.NewVirtual(now)
	svc := &Data{Store: st, Clock: clk, Importer: data.Importer{Store: st, HTTP: archive.Client(), BaseURL: archive.URL, Delay: 2 * time.Second, Clock: clk}}
	srv := serve(t, func(m *http.ServeMux) { m.Handle(labv1connect.NewDataServiceHandler(svc)) })
	c := labv1connect.NewDataServiceClient(srv.Client(), srv.URL)

	runImport := func(req *labv1.ImportRequest) ([]*labv1.ImportResponse, error) {
		s, err := c.Import(ctx, connect.NewRequest(req))
		require.NoError(t, err)
		defer func() { _ = s.Close() }()
		var evs []*labv1.ImportResponse
		for s.Receive() {
			evs = append(evs, s.Msg())
		}
		return evs, s.Err()
	}

	for _, bad := range []*labv1.ImportRequest{
		{Symbols: []string{"BTCUSDT"}, FromDate: "2024-01-02", ToDate: "2024-01-01", Timeframe: "1h", GapPolicy: "flag"},
		{Symbols: []string{"DOGEUSDT"}, FromDate: "2024-01-01", ToDate: "2024-01-02", Timeframe: "1h", GapPolicy: "flag"},
		{Symbols: []string{"BTCUSDT"}, FromDate: "2024-01-01", ToDate: "2024-01-02", Timeframe: "7m", GapPolicy: "flag"},
		{Symbols: []string{"BTCUSDT"}, FromDate: "2024-01-01", ToDate: "2024-01-02", Timeframe: "1h", GapPolicy: "bfill"},
		{FromDate: "2024-01-01", ToDate: "2024-01-02", Timeframe: "1h", GapPolicy: "flag"},
	} {
		_, err := runImport(bad)
		require.Equal(t, connect.CodeInvalidArgument, code(err), "%v", bad)
	}

	req := &labv1.ImportRequest{Symbols: []string{"BTCUSDT"}, FromDate: "2024-01-01", ToDate: "2024-01-02", Timeframe: "1h", GapPolicy: "flag"}
	evs, err := runImport(req)
	require.NoError(t, err)
	require.GreaterOrEqual(t, len(evs), 2)
	prog := evs[0].GetProgress()
	require.Equal(t, int32(2*1440-5), prog.GetInserted())
	ds := evs[len(evs)-1].GetDataset()
	require.NotEmpty(t, ds.GetId())
	require.EqualValues(t, 48, ds.GetBarCount())
	require.EqualValues(t, 0, ds.GetGaps(), "a 5-minute hole inside an hour still yields a (partial) 1h bar")

	// Same import again: no new rows, same version.
	evs2, err := runImport(req)
	require.NoError(t, err)
	require.Zero(t, evs2[0].GetProgress().GetInserted())
	require.Equal(t, ds.GetId(), evs2[len(evs2)-1].GetDataset().GetId())

	// ffill on 1m makes a different version; stop refuses.
	req.Timeframe, req.GapPolicy = "1m", "stop"
	_, err = runImport(req)
	require.Equal(t, connect.CodeFailedPrecondition, code(err))

	list, err := c.ListDatasets(ctx, connect.NewRequest(&labv1.ListDatasetsRequest{}))
	require.NoError(t, err)
	require.Len(t, list.Msg.GetDatasets(), 1)
	require.EqualValues(t, 1, list.Msg.GetTotal())

	cov, err := c.GetCoverage(ctx, connect.NewRequest(&labv1.GetCoverageRequest{}))
	require.NoError(t, err)
	require.Len(t, cov.Msg.GetCoverage(), 1)
	bc := cov.Msg.GetCoverage()[0]
	require.Equal(t, int64(2*1440-5), bc.GetBars())
	require.Len(t, bc.GetProblems(), 1)
	require.Len(t, bc.GetSegments(), 1, "two consecutive days merge into one segment")
	require.Equal(t, t0.Add(2*24*time.Hour).UnixMilli(), bc.GetSegments()[0].GetUntilUnixMs())
	require.Equal(t, t0.Add(100*time.Minute).UnixMilli(), bc.GetProblems()[0].GetFromUnixMs())

	// A bar 10 days later is a separate segment: holes must look like holes.
	later := t0.Add(12 * 24 * time.Hour)
	px := money.Price{V: 100e8, Scale: 8}
	_, err = data.UpsertBars(ctx, st, "BTCUSDT", "archive", "x", []data.Bar{{
		Instrument: "BTCUSDT", OpenTime: later, CloseTime: later.Add(time.Minute), AvailableAt: later.Add(time.Minute),
		O: px, H: px, L: px, C: px, Volume: money.Qty{V: 1, Scale: 8},
	}})
	require.NoError(t, err)
	cov, err = c.GetCoverage(ctx, connect.NewRequest(&labv1.GetCoverageRequest{}))
	require.NoError(t, err)
	require.Len(t, cov.Msg.GetCoverage()[0].GetSegments(), 2)

	iss, err := c.ListQualityIssues(ctx, connect.NewRequest(&labv1.ListQualityIssuesRequest{Symbol: "BTCUSDT", PageSize: 10}))
	require.NoError(t, err)
	require.EqualValues(t, 1, iss.Msg.GetTotal())
	require.Equal(t, "gap", iss.Msg.GetIssues()[0].GetKind())

	ov, err := c.GetOverview(ctx, connect.NewRequest(&labv1.GetOverviewRequest{}))
	require.NoError(t, err)
	require.Len(t, ov.Msg.GetSymbols(), 6)
	require.Positive(t, ov.Msg.GetStorageBytes())
}
