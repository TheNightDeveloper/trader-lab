package api

import (
	"context"
	"net/http"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/proto"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/store/storetest"
)

func waveBars(n int) []data.Bar {
	x := uint64(21)
	next := func(m int64) int64 {
		x = x*6364136223846793005 + 1442695040888963407
		return int64(x>>33) % m
	}
	t0 := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	bs := make([]data.Bar, n)
	p := int64(100e8)
	for i := range bs {
		o := p
		d := int64(3_000_000)
		if (i/700)%2 == 1 {
			d = -d
		}
		c := max(50e8, o+d+next(20_000_000)-10_000_000)
		open := t0.Add(time.Duration(i) * time.Minute)
		bs[i] = data.Bar{Instrument: "BTCUSDT", OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute + 2*time.Second),
			O: money.Price{V: o, Scale: 8}, H: money.Price{V: max(o, c) + next(5_000_000), Scale: 8},
			L: money.Price{V: min(o, c) - next(5_000_000), Scale: 8}, C: money.Price{V: c, Scale: 8}, Volume: money.Qty{V: 1e8, Scale: 8}}
		p = c
	}
	return bs
}

func dec(s string) *labv1.Decimal {
	v, err := money.Parse(s, 6)
	if err != nil {
		panic(err)
	}
	return decP(v, 6)
}

func usdtMoney(s string) *labv1.Money {
	v, err := money.Parse(s, 8)
	if err != nil {
		panic(err)
	}
	return usdtP(v)
}

func TestReportAndPnlServices(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	bars := waveBars(10_000)
	_, err := data.UpsertBars(ctx, st, "BTCUSDT", "archive", "t", bars)
	require.NoError(t, err)
	ds, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{Symbol: "BTCUSDT", Timeframe: data.TF1m, From: bars[0].OpenTime, To: bars[len(bars)-1].CloseTime, GapPolicy: data.GapFlag})
	require.NoError(t, err)

	svc := report.Service{Store: st, Version: "test"}
	fxSvc := &Fx{Store: st, Clock: clock.NewVirtual(time.Date(2026, 10, 27, 0, 0, 0, 0, time.UTC))}
	srv := serve(t,
		func(m *http.ServeMux) { m.Handle(labv1connect.NewReportServiceHandler(&Report{Svc: svc})) },
		func(m *http.ServeMux) { m.Handle(labv1connect.NewPnlServiceHandler(&Pnl{Svc: svc})) },
		func(m *http.ServeMux) { m.Handle(labv1connect.NewFxServiceHandler(fxSvc)) })
	rc := labv1connect.NewReportServiceClient(srv.Client(), srv.URL)
	pc := labv1connect.NewPnlServiceClient(srv.Client(), srv.URL)
	fc := labv1connect.NewFxServiceClient(srv.Client(), srv.URL)

	strategies, err := rc.ListStrategies(ctx, connect.NewRequest(&labv1.ListStrategiesRequest{}))
	require.NoError(t, err)
	require.Len(t, strategies.Msg.GetStrategies(), 4)

	spec := func(fee string) *labv1.ReportSpec {
		return &labv1.ReportSpec{
			DatasetIds: []string{ds.ID}, Strategy: "trend-ema", Params: map[string]float64{"fast": 10, "slow": 30},
			Capital: usdtMoney("1000"), Fee: dec(fee), Slippage: dec("0.0005"), Folds: 3,
		}
	}
	for _, bad := range []*labv1.ReportSpec{
		{DatasetIds: []string{ds.ID}, Strategy: "trend-ema"},                                                  // no capital
		{DatasetIds: []string{ds.ID}, Strategy: "nope", Capital: usdtMoney("1000")},                           // unknown strategy
		{DatasetIds: []string{"missing"}, Strategy: "trend-ema", Capital: usdtMoney("1000")},                  // unknown dataset
		{DatasetIds: []string{ds.ID}, Strategy: "trend-ema", Capital: usdtMoney("1000"), Fee: decP(1, 7)},     // 7 decimals
		{DatasetIds: []string{ds.ID}, Strategy: "trend-ema", Capital: usdtMoney("1000"), Folds: 99},           // bad split
		{DatasetIds: []string{ds.ID}, Strategy: "trend-ema", Capital: &labv1.Money{Units: "1", Asset: "BTC"}}, // not USDT
	} {
		_, err := rc.CreateReport(ctx, connect.NewRequest(&labv1.CreateReportRequest{Spec: bad}))
		require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err), "%v: %v", bad, err)
	}

	created, err := rc.CreateReport(ctx, connect.NewRequest(&labv1.CreateReportRequest{Spec: spec("0.001")}))
	require.NoError(t, err)
	id := created.Msg.GetReportId()
	other, err := rc.CreateReport(ctx, connect.NewRequest(&labv1.CreateReportRequest{Spec: spec("0.002")}))
	require.NoError(t, err)

	list, err := rc.ListReports(ctx, connect.NewRequest(&labv1.ListReportsRequest{}))
	require.NoError(t, err)
	require.EqualValues(t, 2, list.Msg.GetTotal())

	got, err := rc.GetReport(ctx, connect.NewRequest(&labv1.GetReportRequest{ReportId: id}))
	require.NoError(t, err)
	r := got.Msg.GetReport()
	require.Equal(t, "test", r.GetSpec().GetEngineVersion())
	require.NotEmpty(t, r.GetSummary().GetSentence())
	require.Len(t, r.GetFolds(), 3)
	require.Len(t, r.GetBenchmarks(), 2)
	require.Len(t, r.GetGroups(), 4)
	require.Nil(t, r.GetNetToman(), "no rate asked: no Toman")
	net := findMetric(r.GetOos().GetMetrics(), "net_pnl")
	require.NotEmpty(t, net.GetLabel())

	// Trades are paged and sum to the net; holdout trades are not listed.
	trades, err := rc.ListTrades(ctx, connect.NewRequest(&labv1.ListTradesRequest{ReportId: id, PageSize: 200}))
	require.NoError(t, err)
	var sum int64
	for _, tr := range trades.Msg.GetTrades() {
		require.True(t, tr.GetOpenedUnixMs() < r.GetHoldoutWindow().GetFromUnixMs(), "no holdout trade leaks")
		v, _ := money.Parse(tr.GetNet().GetUnits(), 0)
		sum += v
	}
	require.EqualValues(t, trades.Msg.GetTotal(), len(trades.Msg.GetTrades()))
	require.Equal(t, net.GetValue().GetUnits(), money.Format(sum, 0))

	decisions, err := rc.ListDecisions(ctx, connect.NewRequest(&labv1.ListDecisionsRequest{ReportId: id}))
	require.NoError(t, err)
	require.Positive(t, decisions.Msg.GetTotal())

	hv, err := rc.ViewHoldout(ctx, connect.NewRequest(&labv1.ViewHoldoutRequest{ReportId: id}))
	require.NoError(t, err)
	require.EqualValues(t, 1, hv.Msg.GetViews())
	again, err := rc.GetReport(ctx, connect.NewRequest(&labv1.GetReportRequest{ReportId: id}))
	require.NoError(t, err)
	require.EqualValues(t, 1, again.Msg.GetReport().GetHoldoutViews(), "the look is counted")

	// Toman: two rates change only the Toman fields; USDT and the stored report do not move.
	rowBefore, err := st.GetReport(ctx, id)
	require.NoError(t, err)
	r1, err := fc.AddRate(ctx, connect.NewRequest(&labv1.AddRateRequest{Date: "2026-10-26", TomanPerUsdt: "100000"}))
	require.NoError(t, err)
	r2, err := fc.AddRate(ctx, connect.NewRequest(&labv1.AddRateRequest{Date: "2026-10-27", TomanPerUsdt: "110000"}))
	require.NoError(t, err)
	a, err := rc.GetReport(ctx, connect.NewRequest(&labv1.GetReportRequest{ReportId: id, FxRateId: r1.Msg.GetRate().GetId()}))
	require.NoError(t, err)
	b, err := rc.GetReport(ctx, connect.NewRequest(&labv1.GetReportRequest{ReportId: id, FxRateId: r2.Msg.GetRate().GetId()}))
	require.NoError(t, err)
	require.NotEqual(t, a.Msg.GetReport().GetNetToman().GetUnits(), b.Msg.GetReport().GetNetToman().GetUnits())
	ca, cb := proto.Clone(a.Msg.GetReport()).(*labv1.Report), proto.Clone(b.Msg.GetReport()).(*labv1.Report)
	ca.NetToman, ca.FinalEquityToman, cb.NetToman, cb.FinalEquityToman = nil, nil, nil, nil
	require.True(t, proto.Equal(ca, cb), "every USDT value identical across rates")
	rowAfter, err := st.GetReport(ctx, id)
	require.NoError(t, err)
	require.Equal(t, rowBefore.Evaluation, rowAfter.Evaluation, "stored report unchanged")

	// Compare: different fee → second report ineligible.
	cmp, err := rc.Compare(ctx, connect.NewRequest(&labv1.CompareRequest{ReportIds: []string{id, other.Msg.GetReportId()}}))
	require.NoError(t, err)
	require.True(t, cmp.Msg.GetColumns()[0].GetEligible())
	require.False(t, cmp.Msg.GetColumns()[1].GetEligible())
	require.NotEmpty(t, cmp.Msg.GetConclusion())
	_, err = rc.Compare(ctx, connect.NewRequest(&labv1.CompareRequest{ReportIds: []string{id}}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))

	// Exports.
	csvT, err := rc.Export(ctx, connect.NewRequest(&labv1.ExportRequest{ReportId: id, Kind: "trades_csv", FxRateId: r2.Msg.GetRate().GetId()}))
	require.NoError(t, err)
	lines := strings.Split(strings.TrimSpace(string(csvT.Msg.GetContent())), "\n")
	require.Contains(t, lines[0], "net_toman (rate #")
	require.Len(t, lines, len(trades.Msg.GetTrades())+1)
	for _, kind := range []string{"metrics_csv", "spec_json"} {
		ex, err := rc.Export(ctx, connect.NewRequest(&labv1.ExportRequest{ReportId: id, Kind: kind}))
		require.NoError(t, err, kind)
		require.NotEmpty(t, ex.Msg.GetContent())
	}

	rep, err := rc.Reproduce(ctx, connect.NewRequest(&labv1.ReproduceRequest{ReportId: id}))
	require.NoError(t, err)
	require.True(t, rep.Msg.GetIdentical())

	// P&L calculator: defaults reproduce the net exactly; overrides change it.
	rec, err := pc.Recalculate(ctx, connect.NewRequest(&labv1.RecalculateRequest{ReportId: id}))
	require.NoError(t, err)
	require.Equal(t, net.GetValue().GetUnits(), rec.Msg.GetWaterfall().GetNet().GetUnits())
	require.Equal(t, rec.Msg.GetOriginalNet().GetUnits(), rec.Msg.GetWaterfall().GetNet().GetUnits())
	require.Equal(t, "1000000", rec.Msg.GetPositionSize().GetUnits(), "settings used are echoed for reset")
	cheaper, err := pc.Recalculate(ctx, connect.NewRequest(&labv1.RecalculateRequest{ReportId: id, Fee: dec("0"), PositionSize: dec("0.5")}))
	require.NoError(t, err)
	require.NotEqual(t, rec.Msg.GetWaterfall().GetNet().GetUnits(), cheaper.Msg.GetWaterfall().GetNet().GetUnits())
	require.Equal(t, "0", cheaper.Msg.GetWaterfall().GetFees().GetUnits())

	// Single trade.
	tr, err := pc.CalculateTrade(ctx, connect.NewRequest(&labv1.CalculateTradeRequest{
		Entry: usdtMoney("67400"), Exit: usdtMoney("68900"), Amount: usdtMoney("2000"), Fee: dec("0.001"), Slippage: dec("0.0005"),
		FxRateId: r2.Msg.GetRate().GetId(),
	}))
	require.NoError(t, err)
	require.Equal(t, "positive", tr.Msg.GetTone())
	require.NotNil(t, tr.Msg.GetNetToman())
	_, err = pc.CalculateTrade(ctx, connect.NewRequest(&labv1.CalculateTradeRequest{Entry: usdtMoney("0"), Exit: usdtMoney("1"), Amount: usdtMoney("1")}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))
}

func findMetric(ms []*labv1.Metric, key string) *labv1.Metric {
	for _, m := range ms {
		if m.GetKey() == key {
			return m
		}
	}
	return nil
}
