package api

import (
	"context"
	"encoding/json"
	"net/http"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"golang.org/x/sync/errgroup"
	"google.golang.org/protobuf/proto"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
	"tradinglab/engine/internal/strategy"
)

const paperTestUnit = 100_000_000

func paperFixture(t *testing.T) (*Market, *clock.Virtual, labv1connect.PaperServiceClient, int64) {
	t.Helper()
	ctx := context.Background()
	st := storetest.Open(t)
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	const unit = paperTestUnit
	price := money.Price{V: 100 * unit, Scale: instrument.Scale}
	_, err := data.UpsertBars(ctx, st, "BTCUSDT", "rest", "fixture", []data.Bar{{
		OpenTime: now.Add(-time.Minute), CloseTime: now, AvailableAt: now, O: price, H: price, L: price, C: price,
	}})
	require.NoError(t, err)
	level := 90.0
	entry := strategy.Rule{Op: "gt", Left: &strategy.RuleValue{Kind: "close"}, Right: &strategy.RuleValue{Kind: "constant", Number: &level}}
	exit := entry
	exit.Op = "lt"
	def := strategy.RuleDefinition{Format: strategy.RuleFormatV1, Exposure: money.RatioOne, Entry: entry, Exit: exit}
	body, err := json.Marshal(def)
	require.NoError(t, err)
	hash, err := def.ContentHash()
	require.NoError(t, err)
	version, err := st.InsertRuleVersion(ctx, db.InsertRuleVersionParams{Title: "Paper fixture", ContentHash: hash, Definition: body})
	require.NoError(t, err)
	empty := []byte(`{}`)
	require.NoError(t, st.InsertReport(ctx, db.InsertReportParams{ID: "paper-evidence", Spec: empty, Split: empty, Evaluation: empty, Holdout: empty}))
	bars := make([]data.Bar, 30)
	for i := range bars {
		open := now.Add(time.Duration(i-len(bars)) * time.Hour)
		bars[i] = data.Bar{
			Instrument: "BTCUSDT", OpenTime: open, CloseTime: open.Add(time.Hour), AvailableAt: open.Add(time.Hour),
			O: price, H: price, L: price, C: price,
		}
	}
	snapshot, err := json.Marshal(bars)
	require.NoError(t, err)
	require.NoError(t, st.InsertMarketOpportunity(ctx, db.InsertMarketOpportunityParams{
		Symbol: "BTCUSDT", RuleVersionID: version.ID, ReportID: "paper-evidence", SpecRevision: marketSpecRevision("BTCUSDT"),
		CandleClosedAt: now, ObservedAt: now, ExpiresAt: now.Add(time.Hour), ReferenceClose: price.V,
		Reason: "rule entry", Snapshot: snapshot, SnapshotSha256: paperPlanHash(snapshot), EngineBuildSha256: "scanner-build",
	}))
	opp, err := st.MarketOpportunity(ctx, db.MarketOpportunityParams{RuleVersionID: version.ID, Symbol: "BTCUSDT", CandleClosedAt: now})
	require.NoError(t, err)
	wall := clock.NewVirtual(now.Add(time.Second))
	feed := fakeLive{data.LiveStatus{Symbols: []data.LiveSymbolStatus{{Symbol: "BTCUSDT", State: data.LiveFresh, LastClose: now}}}}
	market := &Market{Store: st, Clock: wall, Live: feed, Symbols: []string{"BTCUSDT"}}
	srv := serve(t, func(mux *http.ServeMux) { mux.Handle(labv1connect.NewPaperServiceHandler(&Paper{Market: market})) })
	return market, wall, labv1connect.NewPaperServiceClient(srv.Client(), srv.URL), opp.ID
}

func TestPaperAccountAndPlanAreDurableAndBoundToReview(t *testing.T) {
	ctx := context.Background()
	market, wall, client, opportunityID := paperFixture(t)
	const unit = paperTestUnit
	before, err := client.GetPaperAccount(ctx, connect.NewRequest(&labv1.GetPaperAccountRequest{}))
	require.NoError(t, err)
	require.Nil(t, before.Msg.GetPaperAccount())
	start := &labv1.InitializePaperAccountRequest{Capital: usdtP(1_000 * unit), MaxLossPerTrade: usdtP(15 * unit),
		MaxOpenLoss: usdtP(30 * unit), MaxSpotExposure: usdtP(250 * unit)}
	var group errgroup.Group
	for range 2 {
		group.Go(func() error {
			_, err := client.InitializePaperAccount(ctx, connect.NewRequest(start))
			return err
		})
	}
	require.NoError(t, group.Wait())
	var funding int64
	require.NoError(t, market.Store.Pool.QueryRow(ctx, `SELECT sum(amount)::bigint FROM paper_postings WHERE account_id = $1 AND destination = 'available'`, paperAccountID).Scan(&funding))
	require.EqualValues(t, 1_000*unit, funding)
	account, err := client.GetPaperAccount(ctx, connect.NewRequest(&labv1.GetPaperAccountRequest{}))
	require.NoError(t, err)
	require.Equal(t, start.GetCapital().GetUnits(), account.Msg.GetPaperAccount().GetSnapshot().GetAvailableBalance().GetValue().GetUnits())
	preview := &labv1.PreviewPaperPlanRequest{Account: paperAccountRef(), OpportunityId: opportunityID, Stop: usdtP(90 * unit), TakeProfit: usdtP(120 * unit)}
	build := func() *labv1.PreviewPaperPlanResponse {
		t.Helper()
		res, err := client.PreviewPaperPlan(ctx, connect.NewRequest(preview))
		require.NoError(t, err)
		return res.Msg
	}
	first := build().GetPlan()
	require.NotNil(t, first)
	require.Equal(t, first.GetPlanHash(), build().GetPlan().GetPlanHash())
	require.EqualValues(t, 1, first.GetReferenceCandleRevision())
	require.Equal(t, "paper-evidence", first.GetReportId())
	require.Equal(t, "BTC", first.GetQuantity().GetAsset())
	preview.Stop = usdtP(95 * unit)
	require.NotEqual(t, first.GetPlanHash(), build().GetPlan().GetPlanHash())
	load := func() *labv1.GetPaperPlanResponse {
		t.Helper()
		res, err := client.GetPaperPlan(ctx, connect.NewRequest(&labv1.GetPaperPlanRequest{PlanHash: first.GetPlanHash()}))
		require.NoError(t, err)
		return res.Msg
	}
	require.True(t, proto.Equal(first, load().GetPlan()))
	require.Nil(t, load().GetRestriction())
	market.Live = nil
	require.Equal(t, "feed_stale", build().GetRestriction().GetCode())
	require.Equal(t, "feed_stale", load().GetRestriction().GetCode())
	require.NoError(t, wall.Set(now.Add(2*time.Minute)))
	require.Equal(t, "plan_expired", load().GetRestriction().GetCode())
}
