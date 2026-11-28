package api

import (
	"context"
	"net/http"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"golang.org/x/sync/errgroup"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
)

func TestDailyReviewUsesUTCWindowAndDurableReminder(t *testing.T) {
	ctx := context.Background()
	st := storetest.Open(t)
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	day := time.Date(2026, 11, 27, 0, 0, 0, 0, time.UTC)
	wall := clock.NewVirtual(day.Add(5 * time.Minute))
	m := &Market{Store: st, Clock: wall, Symbols: []string{"BTCUSDT"}}
	paper := &Paper{Market: m}
	srv := serve(t, func(mux *http.ServeMux) {
		mux.Handle(labv1connect.NewDailyReviewServiceHandler(&DailyReview{Paper: paper}))
	})
	client := labv1connect.NewDailyReviewServiceClient(srv.Client(), srv.URL)
	read := func() *labv1.GetDailyReviewResponse {
		t.Helper()
		r, err := client.GetDailyReview(ctx, connect.NewRequest(&labv1.GetDailyReviewRequest{}))
		require.NoError(t, err)
		return r.Msg
	}
	empty := read()
	require.Nil(t, empty.GetPaperAccount())
	require.False(t, empty.GetStatus().GetReminderEnabled())
	require.Equal(t, ms(day), empty.GetStatus().GetDayStartUnixMs())
	_, err := paper.InitializePaperAccount(ctx, connect.NewRequest(&labv1.InitializePaperAccountRequest{
		Capital: usdtP(1_000_000_000), MaxLossPerTrade: usdtP(100_000_000),
		MaxOpenLoss: usdtP(100_000_000), MaxSpotExposure: usdtP(1_000_000_000),
	}))
	require.NoError(t, err)
	rule, err := (&Library{Store: st}).SaveRuleVersion(ctx, connect.NewRequest(&labv1.SaveRuleVersionRequest{
		Title: "Daily review rule",
		DefinitionJson: `{"format":"rules/v1","base_timeframe":"1h","exposure":"0.25",` +
			`"entry":{"op":"gt","left":{"kind":"close"},"right":{"kind":"constant","number":100}},` +
			`"exit":{"op":"lt","left":{"kind":"close"},"right":{"kind":"constant","number":50}}}`,
	}))
	require.NoError(t, err)
	json := []byte(`{}`)
	require.NoError(t, st.InsertReport(ctx, db.InsertReportParams{ID: "daily-evidence", Spec: json, Split: json, Evaluation: json, Holdout: json}))
	record := func(closed time.Time) {
		t.Helper()
		require.NoError(t, st.InsertMarketOpportunity(ctx, db.InsertMarketOpportunityParams{
			Symbol: "BTCUSDT", RuleVersionID: rule.Msg.GetVersion().GetId(), ReportID: "daily-evidence", SpecRevision: "fixture",
			CandleClosedAt: closed, ObservedAt: closed.Add(time.Minute), ExpiresAt: closed.Add(time.Hour),
			ReferenceClose: 110_00000000, Reason: "fixture", Snapshot: []byte(`[]`),
		}))
	}
	record(day.Add(-2 * time.Hour)) // Expired before the review window.
	record(day.Add(-time.Hour))     // Expired at midnight.
	record(day)
	record(day.Add(time.Hour)) // Future observation cannot enter this read.
	closeAt := day.Add(time.Minute)
	price := money.Price{V: 110_00000000, Scale: instrument.Scale}
	_, err = data.UpsertBars(ctx, st, "BTCUSDT", "rest", "fixture", []data.Bar{{
		Instrument: "BTCUSDT", OpenTime: day, CloseTime: closeAt, AvailableAt: closeAt, O: price, H: price, L: price, C: price,
	}})
	require.NoError(t, err)
	_, err = st.Pool.Exec(ctx, `INSERT INTO quality_issues (symbol, kind, at, detected_at, detail) VALUES
		('BTCUSDT','gap',$1,$2,'known'), ('ETHUSDT','gap',$1,$2,'untracked'), ('BTCUSDT','correction',$1,$3,'future')`, day, closeAt, day.Add(time.Hour))
	require.NoError(t, err)
	current := read()
	require.NotNil(t, current.GetPaperAccount())
	require.True(t, current.GetReconciliation().GetEventsMatch())
	require.EqualValues(t, 1, current.GetOpenWindowCount())
	require.EqualValues(t, 1, current.GetExpiredCount())
	require.False(t, current.GetOpenWindow()[0].GetCurrent())
	require.Equal(t, ms(day), current.GetExpired()[0].GetExpiresAtUnixMs())
	require.Len(t, current.GetEvents(), 1)
	require.Equal(t, "known", current.GetEvents()[0].GetDetail())
	m.Live = fakeLive{data.LiveStatus{Symbols: []data.LiveSymbolStatus{{Symbol: "BTCUSDT", State: data.LiveFresh, LastClose: closeAt}}}}
	require.True(t, read().GetOpenWindow()[0].GetCurrent())

	_, err = client.SetDailyReviewReminder(ctx, connect.NewRequest(&labv1.SetDailyReviewReminderRequest{}))
	require.Equal(t, connect.CodeInvalidArgument, code(err))
	enabled := true
	_, err = client.SetDailyReviewReminder(ctx, connect.NewRequest(&labv1.SetDailyReviewReminderRequest{Enabled: &enabled}))
	require.NoError(t, err)
	mark := func() error {
		_, err := client.MarkDailyReviewRead(ctx, connect.NewRequest(&labv1.MarkDailyReviewReadRequest{DayStartUnixMs: ms(day)}))
		return err
	}
	var retry errgroup.Group
	retry.Go(mark)
	retry.Go(mark)
	require.NoError(t, retry.Wait())
	require.True(t, read().GetStatus().GetReviewedToday())
	require.NoError(t, wall.Set(day.Add(24*time.Hour)))
	require.Equal(t, connect.CodeFailedPrecondition, code(mark()))
	status, err := client.GetDailyReviewStatus(ctx, connect.NewRequest(&labv1.GetDailyReviewStatusRequest{}))
	require.NoError(t, err)
	require.True(t, status.Msg.GetStatus().GetReminderEnabled())
	require.False(t, status.Msg.GetStatus().GetReviewedToday())
}

func TestDailyReviewExposureNeedsAllMarks(t *testing.T) {
	positions := []*labv1.PaperPosition{
		{Symbol: "BTCUSDT", MarketValue: paperMoneyValue(200)},
		{Symbol: "BTCUSDT", MarketValue: paperMoneyValue(400)},
		{Symbol: "ETHUSDT", MarketValue: paperMoneyValue(400)},
	}
	values, err := dailyReviewExposure(positions)
	require.NoError(t, err)
	require.Len(t, values, 2)
	require.Equal(t, "BTCUSDT", values[0].GetSymbol())
	require.Equal(t, "600000", values[0].GetShareOfOpenValue().GetUnits())
	require.Equal(t, "400000", values[1].GetShareOfOpenValue().GetUnits())
	positions[2].MarketValue = stalePaperValue()
	values, err = dailyReviewExposure(positions)
	require.NoError(t, err)
	require.Empty(t, values)
}
