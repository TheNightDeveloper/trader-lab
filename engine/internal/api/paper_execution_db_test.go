package api

import (
	"context"
	"strconv"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"golang.org/x/sync/errgroup"

	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
)

func TestPaperConfirmationPartialFillCancelAndProtectiveExit(t *testing.T) {
	ctx := context.Background()
	market, wall, client, opportunityID := paperFixture(t)
	p := &Paper{Market: market}
	const unit = paperTestUnit
	_, err := client.InitializePaperAccount(ctx, connect.NewRequest(&labv1.InitializePaperAccountRequest{
		Capital: usdtP(250 * unit), MaxLossPerTrade: usdtP(15 * unit), MaxOpenLoss: usdtP(20 * unit), MaxSpotExposure: usdtP(200 * unit),
	}))
	require.NoError(t, err)
	preview, err := client.PreviewPaperPlan(ctx, connect.NewRequest(&labv1.PreviewPaperPlanRequest{
		Account: paperAccountRef(), OpportunityId: opportunityID, Stop: usdtP(90 * unit), TakeProfit: usdtP(120 * unit),
	}))
	require.NoError(t, err)
	plan := preview.Msg.GetPlan()
	require.NotNil(t, plan)
	other, err := client.PreviewPaperPlan(ctx, connect.NewRequest(&labv1.PreviewPaperPlanRequest{
		Account: paperAccountRef(), OpportunityId: opportunityID, Stop: usdtP(91 * unit), TakeProfit: usdtP(120 * unit),
	}))
	require.NoError(t, err)
	require.NotNil(t, other.Msg.GetPlan())
	confirm := func() (*labv1.ConfirmPaperPlanResponse, error) {
		res, err := client.ConfirmPaperPlan(ctx, connect.NewRequest(&labv1.ConfirmPaperPlanRequest{Account: paperAccountRef(), PlanHash: plan.GetPlanHash()}))
		if err != nil {
			return nil, err
		}
		return res.Msg, nil
	}
	feed := market.Live
	market.Live = nil
	rejected, err := confirm()
	require.NoError(t, err)
	require.Equal(t, "feed_stale", rejected.GetRestriction().GetCode())
	market.Live = feed
	var group errgroup.Group
	var receipts [2]int64
	for i := range receipts {
		group.Go(func() error {
			result, err := confirm()
			receipts[i] = result.GetReceipt().GetId()
			return err
		})
	}
	require.NoError(t, group.Wait())
	id := receipts[0]
	require.Positive(t, id)
	require.Equal(t, id, receipts[1])
	otherHash := other.Msg.GetPlan().GetPlanHash()
	conflict, err := client.ConfirmPaperPlan(ctx, connect.NewRequest(&labv1.ConfirmPaperPlanRequest{Account: paperAccountRef(), PlanHash: otherHash}))
	require.NoError(t, err)
	require.Nil(t, conflict.Msg.GetReceipt())
	require.Equal(t, "opportunity_already_confirmed", conflict.Msg.GetRestriction().GetCode())
	reopened, err := client.GetPaperPlan(ctx, connect.NewRequest(&labv1.GetPaperPlanRequest{PlanHash: otherHash}))
	require.NoError(t, err)
	require.Nil(t, reopened.Msg.GetReceipt())
	require.Equal(t, "opportunity_already_confirmed", reopened.Msg.GetRestriction().GetCode())
	read := func() *labv1.GetPaperReceiptResponse {
		t.Helper()
		res, err := client.GetPaperReceipt(ctx, connect.NewRequest(&labv1.GetPaperReceiptRequest{ReceiptId: id}))
		require.NoError(t, err)
		return res.Msg
	}
	book := func() *labv1.GetPaperAccountResponse {
		t.Helper()
		res, err := client.GetPaperAccount(ctx, connect.NewRequest(&labv1.GetPaperAccountRequest{}))
		require.NoError(t, err)
		return res.Msg
	}
	units := func(value *labv1.Money) int64 {
		t.Helper()
		v, err := strconv.ParseInt(value.GetUnits(), 10, 64)
		require.NoError(t, err)
		return v
	}
	initial := read()
	require.Len(t, initial.GetEvents(), 1)
	require.Equal(t, labv1.PaperEntryState_PAPER_ENTRY_STATE_PENDING, initial.GetReceipt().GetState())
	reserved := units(plan.GetRequiredCash())
	require.Equal(t, reserved, units(initial.GetReceipt().GetReservedCash()))
	require.Equal(t, int64(250*unit)-reserved, units(book().GetPaperAccount().GetSnapshot().GetAvailableBalance().GetValue()))

	ingest := func(offset int, open, lo, hi, close int64) {
		t.Helper()
		at := now.Add(time.Duration(offset) * time.Minute)
		price := func(v int64) money.Price { return money.Price{V: v * unit, Scale: instrument.Scale} }
		_, err := data.UpsertBars(ctx, market.Store, "BTCUSDT", "rest", "fixture", []data.Bar{{
			OpenTime: at, CloseTime: at.Add(time.Minute), AvailableAt: at.Add(time.Minute),
			O: price(open), H: price(hi), L: price(lo), C: price(close), Volume: money.Qty{V: 20 * unit, Scale: instrument.Scale},
		}})
		require.NoError(t, err)
		require.NoError(t, wall.Set(at.Add(time.Minute)))
	}
	ingest(0, 100, 99, 101, 100) // opened before the confirmation
	require.NoError(t, p.runPaperCycle(ctx, nil))
	require.Len(t, read().GetEvents(), 1)
	ingest(1, 100, 99, 101, 100)
	// A fresh service instance consumes the same durable queue after restart.
	p = &Paper{Market: market}
	require.NoError(t, p.runPaperCycle(ctx, nil))
	partial := read()
	require.Equal(t, labv1.PaperEntryState_PAPER_ENTRY_STATE_PARTIAL, partial.GetReceipt().GetState())
	require.EqualValues(t, unit/5, units(partial.GetReceipt().GetFilledQuantity()))
	require.Len(t, book().GetPositions(), 1)
	require.Equal(t, labv1.MoneyAvailability_MONEY_AVAILABILITY_STALE, book().GetPaperAccount().GetSnapshot().GetEquity().GetUnavailable().GetReason())
	journal, err := client.ListPaperJournal(ctx, connect.NewRequest(&labv1.ListPaperJournalRequest{}))
	require.NoError(t, err)
	require.Len(t, journal.Msg.GetTrades(), 1)
	require.Equal(t, units(partial.GetReceipt().GetFilledQuantity()), units(journal.Msg.GetTrades()[0].GetOpenQuantity()))

	ingest(2, 100, 99, 101, 100)
	require.NoError(t, p.runPaperCycle(ctx, nil)) // protection advances before another entry on the same bar
	group = errgroup.Group{}
	group.Go(func() error { return p.runPaperCycle(ctx, nil) })
	group.Go(func() error {
		_, err := client.CancelPaperEntry(ctx, connect.NewRequest(&labv1.CancelPaperEntryRequest{Account: paperAccountRef(), ReceiptId: id}))
		return err
	})
	require.NoError(t, group.Wait())
	cancelled := read()
	require.Equal(t, labv1.PaperEntryState_PAPER_ENTRY_STATE_CANCELLED, cancelled.GetReceipt().GetState())
	require.Zero(t, units(cancelled.GetReceipt().GetReservedCash()))
	opened := book().GetPositions()[0]
	require.Equal(t, units(cancelled.GetReceipt().GetFilledQuantity()), units(opened.GetQuantity()))
	spent := units(opened.GetCostBasis())
	require.Equal(t, int64(250*unit)-spent, units(book().GetPaperAccount().GetSnapshot().GetAvailableBalance().GetValue()))
	recovered, err := confirm()
	require.NoError(t, err)
	require.Equal(t, id, recovered.GetReceipt().GetId())

	market.Live = nil // protecting existing positions never needs entry permission
	ingest(3, 85, 80, 122, 105)
	require.NoError(t, p.runPaperCycle(ctx, nil))
	require.NoError(t, p.runPaperCycle(ctx, nil))
	closed := read()
	last := closed.GetEvents()[len(closed.GetEvents())-1]
	require.Equal(t, "stop_exit", last.GetKind())
	require.EqualValues(t, 85*unit, units(last.GetReferencePrice()))
	pnl := units(last.GetCash()) - spent
	require.Equal(t, pnl, units(last.GetRealizedPnl()))
	final := book()
	require.Empty(t, final.GetPositions())
	require.Equal(t, int64(250*unit)+pnl, units(final.GetPaperAccount().GetSnapshot().GetEquity().GetValue()))
	var available, reservedAfter, positionAfter, fees int64
	require.NoError(t, market.Store.Pool.QueryRow(ctx, `SELECT
coalesce(sum(amount * ((destination = 'available')::int - (source = 'available')::int)) FILTER (WHERE asset = 'USDT'), 0)::bigint,
coalesce(sum(amount * ((destination = 'reserved')::int - (source = 'reserved')::int)) FILTER (WHERE asset = 'USDT'), 0)::bigint,
coalesce(sum(amount * ((destination = 'position')::int - (source = 'position')::int)) FILTER (WHERE asset = 'BTC'), 0)::bigint,
coalesce(sum(amount) FILTER (WHERE destination = 'fees' AND asset = 'USDT'), 0)::bigint
FROM paper_postings WHERE account_id = $1`, paperAccountID).Scan(&available, &reservedAfter, &positionAfter, &fees))
	require.Equal(t, int64(250*unit)+pnl, available)
	require.Zero(t, reservedAfter)
	require.Zero(t, positionAfter)
	var eventFees int64
	for _, event := range closed.GetEvents() {
		if event.GetFee() != nil {
			eventFees += units(event.GetFee())
		}
	}
	require.Equal(t, eventFees, fees)
	journal, err = client.ListPaperJournal(ctx, connect.NewRequest(&labv1.ListPaperJournalRequest{}))
	require.NoError(t, err)
	require.Len(t, journal.Msg.GetTrades(), 1)
	trade := journal.Msg.GetTrades()[0]
	require.Equal(t, id, trade.GetReceipt().GetId())
	require.Nil(t, trade.GetOpenQuantity())
	require.Equal(t, fees, units(trade.GetFeesPaid()))
	require.Equal(t, pnl, units(trade.GetRealizedPnl()))

	// Seed archived receipts to exercise the exclusive cursor without running more fills.
	_, err = market.Store.Pool.Exec(ctx, `
WITH opportunities AS (
    INSERT INTO market_opportunities (symbol, rule_version_id, report_id, spec_revision, candle_closed_at,
        observed_at, expires_at, reference_close, reason, snapshot, snapshot_sha256)
    SELECT o.symbol, o.rule_version_id, o.report_id, o.spec_revision, o.candle_closed_at - n * interval '1 hour',
        o.observed_at, o.expires_at, o.reference_close, o.reason, o.snapshot, o.snapshot_sha256
    FROM market_opportunities o CROSS JOIN generate_series(1, 20) n WHERE o.id = $1
    RETURNING id, symbol, observed_at, expires_at
), plans AS (
    INSERT INTO paper_trade_plans (hash, account_id, opportunity_id, expires_at, body)
    SELECT 'archived-' || id, $2, id, expires_at, ''::bytea FROM opportunities
    RETURNING hash, opportunity_id
)
INSERT INTO paper_entries (account_id, opportunity_id, plan_hash, symbol, state, confirmed_at,
    expires_at, next_open_at, quantity, reserved_cash, exposure_bound, loss_bound)
SELECT $2, o.id, plans.hash, o.symbol, 4, o.observed_at, o.expires_at, o.observed_at, 1, 0, 1, 1
FROM opportunities o JOIN plans ON plans.opportunity_id = o.id`, opportunityID, paperAccountID)
	require.NoError(t, err)
	firstPage, err := client.ListPaperJournal(ctx, connect.NewRequest(&labv1.ListPaperJournalRequest{}))
	require.NoError(t, err)
	require.Len(t, firstPage.Msg.GetTrades(), 20)
	cursor := firstPage.Msg.GetNextBeforeReceiptId()
	require.Equal(t, firstPage.Msg.GetTrades()[19].GetReceipt().GetId(), cursor)
	lastPage, err := client.ListPaperJournal(ctx, connect.NewRequest(&labv1.ListPaperJournalRequest{BeforeReceiptId: cursor}))
	require.NoError(t, err)
	require.Len(t, lastPage.Msg.GetTrades(), 1)
	require.Equal(t, id, lastPage.Msg.GetTrades()[0].GetReceipt().GetId())
	require.Zero(t, lastPage.Msg.GetNextBeforeReceiptId())
}

func TestPaperPartialFillsKeepTheirProtectionWindows(t *testing.T) {
	for _, name := range []string{"continuous", "restart"} {
		t.Run(name, func(t *testing.T) {
			ctx := context.Background()
			market, wall, client, opportunityID := paperFixture(t)
			p := &Paper{Market: market}
			const unit = paperTestUnit
			_, err := client.InitializePaperAccount(ctx, connect.NewRequest(&labv1.InitializePaperAccountRequest{
				Capital: usdtP(250 * unit), MaxLossPerTrade: usdtP(15 * unit), MaxOpenLoss: usdtP(20 * unit), MaxSpotExposure: usdtP(200 * unit),
			}))
			require.NoError(t, err)
			preview, err := client.PreviewPaperPlan(ctx, connect.NewRequest(&labv1.PreviewPaperPlanRequest{
				Account: paperAccountRef(), OpportunityId: opportunityID, Stop: usdtP(90 * unit), TakeProfit: usdtP(120 * unit),
			}))
			require.NoError(t, err)
			plan := preview.Msg.GetPlan()
			require.Equal(t, paperFillModelV2, plan.GetFillModel())
			confirmed, err := client.ConfirmPaperPlan(ctx, connect.NewRequest(&labv1.ConfirmPaperPlanRequest{
				Account: paperAccountRef(), PlanHash: plan.GetPlanHash(),
			}))
			require.NoError(t, err)
			id := confirmed.Msg.GetReceipt().GetId()
			require.Positive(t, id)
			ingest := func(minute int, low, close int64) {
				t.Helper()
				at := now.Add(time.Duration(minute) * time.Minute)
				available := at.Add(time.Minute + 5*time.Second)
				price := func(v int64) money.Price { return money.Price{V: v * unit, Scale: instrument.Scale} }
				_, err := data.UpsertBars(ctx, market.Store, "BTCUSDT", "rest", "fixture", []data.Bar{{
					OpenTime: at, CloseTime: at.Add(time.Minute), AvailableAt: available,
					O: price(100), H: price(101), L: price(low), C: price(close), Volume: money.Qty{V: 20 * unit, Scale: instrument.Scale},
				}})
				require.NoError(t, err)
				require.NoError(t, wall.Set(available))
				require.NoError(t, p.runPaperCycle(ctx, nil))
			}
			ingest(1, 88, 89) // A lower close does not veto the buy at the open in v2.
			ingest(2, 99, 100)
			if name == "restart" {
				p = &Paper{Market: market}
			}
			ingest(3, 89, 95) // Only the first fill can exit on this candle.
			position, err := market.Store.ReadPaperPosition(ctx, id)
			require.NoError(t, err)
			require.EqualValues(t, unit/5, position.Quantity)
			ingest(4, 89, 95)
			events, err := market.Store.PaperExecutionEvents(ctx, id)
			require.NoError(t, err)
			require.Len(t, events, 6)
			require.Equal(t, "protection_cancelled_remainder", events[3].Kind)
			for index, minute := range []int{3, 4} {
				exit := events[4+index]
				require.Equal(t, "stop_exit", exit.Kind)
				require.EqualValues(t, unit/5, exit.Quantity)
				require.True(t, exit.CandleOpenAt.Equal(now.Add(time.Duration(minute)*time.Minute)))
			}
			entry, err := readPaperEntry(ctx, market.Store.Queries, id)
			require.NoError(t, err)
			require.Zero(t, entry.ReservedCash)
			ledger, err := market.Store.ReconcilePaperBook(ctx, entry.AccountID)
			require.NoError(t, err)
			require.True(t, paperReconciled(ledger))
		})
	}
}

func TestPaperCycleDrainsFourReceiptsWithAnHourOfCandles(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	market, wall, client, opportunityID := paperFixture(t)
	st := market.Store
	const unit = paperTestUnit
	_, err := client.InitializePaperAccount(ctx, connect.NewRequest(&labv1.InitializePaperAccountRequest{
		Capital: usdtP(1000 * unit), MaxLossPerTrade: usdtP(10 * unit), MaxOpenLoss: usdtP(100 * unit), MaxSpotExposure: usdtP(800 * unit),
	}))
	require.NoError(t, err)
	original, err := st.RecordedMarketOpportunity(ctx, opportunityID)
	require.NoError(t, err)
	market.Symbols = []string{"BTCUSDT", "ETHUSDT", "SOLUSDT", "BNBUSDT"}
	var feeds []data.LiveSymbolStatus
	for _, symbol := range market.Symbols {
		feeds = append(feeds, data.LiveSymbolStatus{Symbol: symbol, State: data.LiveFresh, LastClose: now})
	}
	market.Live = fakeLive{data.LiveStatus{Symbols: feeds}}
	var receipts []int64
	for _, symbol := range market.Symbols {
		price := money.Price{V: 100 * unit, Scale: instrument.Scale}
		_, err := data.UpsertBars(ctx, st, symbol, "rest", "fixture", []data.Bar{{
			OpenTime: now.Add(-time.Minute), CloseTime: now, AvailableAt: now, O: price, H: price, L: price, C: price,
		}})
		require.NoError(t, err)
		require.NoError(t, st.InsertMarketOpportunity(ctx, db.InsertMarketOpportunityParams{
			Symbol: symbol, RuleVersionID: original.RuleVersionID, ReportID: original.ReportID, SpecRevision: marketSpecRevision(symbol),
			CandleClosedAt: now, ObservedAt: now, ExpiresAt: now.Add(time.Hour), ReferenceClose: price.V,
			Reason: original.Reason, Snapshot: original.Snapshot, SnapshotSha256: original.SnapshotSha256,
		}))
		opp, err := st.MarketOpportunity(ctx, db.MarketOpportunityParams{RuleVersionID: original.RuleVersionID, Symbol: symbol, CandleClosedAt: now})
		require.NoError(t, err)
		preview, err := client.PreviewPaperPlan(ctx, connect.NewRequest(&labv1.PreviewPaperPlanRequest{
			Account: paperAccountRef(), OpportunityId: opp.ID, Stop: usdtP(90 * unit), TakeProfit: usdtP(120 * unit),
		}))
		require.NoError(t, err)
		require.NotNil(t, preview.Msg.GetPlan(), "%s", preview.Msg.GetRestriction().GetDetail())
		confirmed, err := client.ConfirmPaperPlan(ctx, connect.NewRequest(&labv1.ConfirmPaperPlanRequest{
			Account: paperAccountRef(), PlanHash: preview.Msg.GetPlan().GetPlanHash(),
		}))
		require.NoError(t, err)
		require.Positive(t, confirmed.Msg.GetReceipt().GetId())
		receipts = append(receipts, confirmed.Msg.GetReceipt().GetId())

		bars := make([]data.Bar, 61)
		for i := range bars {
			open := now.Add(time.Duration(i+1) * time.Minute)
			bars[i] = data.Bar{OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute),
				O: price, H: price, L: price, C: price, Volume: money.Qty{V: 1000 * unit, Scale: instrument.Scale}}
		}
		bars[len(bars)-1].L.V = 89 * unit
		_, err = data.UpsertBars(ctx, st, symbol, "rest", "fixture", bars)
		require.NoError(t, err)
	}
	require.NoError(t, wall.Set(now.Add(62*time.Minute)))
	cycle, stop := context.WithTimeout(ctx, 4*time.Second)
	defer stop()
	require.NoError(t, (&Paper{Market: market}).runPaperCycle(cycle, nil))
	for _, id := range receipts {
		events, err := st.PaperExecutionEvents(ctx, id)
		require.NoError(t, err)
		require.Len(t, events, 3)
		require.Equal(t, "entry_fill", events[1].Kind)
		require.Equal(t, "stop_exit", events[2].Kind)
		require.True(t, events[2].CandleOpenAt.Equal(now.Add(61*time.Minute)))
	}
	ledger, err := st.ReconcilePaperBook(ctx, paperAccountID)
	require.NoError(t, err)
	require.True(t, paperReconciled(ledger))
}

func TestPaperEntriesShareCashAcrossSymbols(t *testing.T) {
	ctx := context.Background()
	market, wall, client, btcID := paperFixture(t)
	const unit = paperTestUnit
	st := market.Store
	btc, err := st.PaperOpportunity(ctx, btcID)
	require.NoError(t, err)
	price := money.Price{V: 100 * unit, Scale: instrument.Scale}
	_, err = data.UpsertBars(ctx, st, "ETHUSDT", "rest", "fixture", []data.Bar{{
		OpenTime: now.Add(-time.Minute), CloseTime: now, AvailableAt: now, O: price, H: price, L: price, C: price,
	}})
	require.NoError(t, err)
	require.NoError(t, st.InsertMarketOpportunity(ctx, db.InsertMarketOpportunityParams{
		Symbol: "ETHUSDT", RuleVersionID: btc.RuleVersionID, ReportID: btc.ReportID, SpecRevision: marketSpecRevision("ETHUSDT"),
		CandleClosedAt: now, ObservedAt: now, ExpiresAt: btc.ExpiresAt, ReferenceClose: price.V,
		Reason: "rule entry", Snapshot: []byte(`[]`), SnapshotSha256: btc.SnapshotSha256,
	}))
	eth, err := st.MarketOpportunity(ctx, db.MarketOpportunityParams{RuleVersionID: btc.RuleVersionID, Symbol: "ETHUSDT", CandleClosedAt: now})
	require.NoError(t, err)
	market.Symbols = []string{"BTCUSDT", "ETHUSDT"}
	market.Live = fakeLive{data.LiveStatus{Symbols: []data.LiveSymbolStatus{
		{Symbol: "BTCUSDT", State: data.LiveFresh, LastClose: now}, {Symbol: "ETHUSDT", State: data.LiveFresh, LastClose: now},
	}}}
	_, err = client.InitializePaperAccount(ctx, connect.NewRequest(&labv1.InitializePaperAccountRequest{
		Capital: usdtP(100 * unit), MaxLossPerTrade: usdtP(40 * unit), MaxOpenLoss: usdtP(40 * unit), MaxSpotExposure: usdtP(100 * unit),
	}))
	require.NoError(t, err)
	preview := func(id int64) *labv1.PreviewPaperPlanResponse {
		t.Helper()
		res, err := client.PreviewPaperPlan(ctx, connect.NewRequest(&labv1.PreviewPaperPlanRequest{
			Account: paperAccountRef(), OpportunityId: id, Stop: usdtP(90 * unit), TakeProfit: usdtP(120 * unit),
		}))
		require.NoError(t, err)
		return res.Msg
	}
	plans := []*labv1.PaperPlan{preview(btcID).GetPlan(), preview(eth.ID).GetPlan()}
	var group errgroup.Group
	var results [2]*labv1.ConfirmPaperPlanResponse
	for i, plan := range plans {
		require.NotNil(t, plan)
		group.Go(func() error {
			res, err := client.ConfirmPaperPlan(ctx, connect.NewRequest(&labv1.ConfirmPaperPlanRequest{Account: paperAccountRef(), PlanHash: plan.GetPlanHash()}))
			if err == nil {
				results[i] = res.Msg
			}
			return err
		})
	}
	require.NoError(t, group.Wait())
	var accepted int
	for i, res := range results {
		if res.GetReceipt() != nil {
			accepted++
		} else {
			require.Equal(t, "account_changed", res.GetRestriction().GetCode())
			require.Equal(t, "risk_budget", preview(plans[i].GetOpportunityId()).GetRestriction().GetCode())
		}
	}
	require.Equal(t, 1, accepted)
	require.NoError(t, wall.Set(now.Add(11*time.Minute)))
	require.NoError(t, (&Paper{Market: market}).runPaperCycle(ctx, nil))
	book, err := client.GetPaperAccount(ctx, connect.NewRequest(&labv1.GetPaperAccountRequest{}))
	require.NoError(t, err)
	require.Len(t, book.Msg.GetRecentReceipts(), 1)
	require.Equal(t, labv1.PaperEntryState_PAPER_ENTRY_STATE_EXPIRED, book.Msg.GetRecentReceipts()[0].GetState())
	require.Equal(t, usdtP(100*unit).GetUnits(), book.Msg.GetPaperAccount().GetSnapshot().GetAvailableBalance().GetValue().GetUnits())
	require.Equal(t, "0", book.Msg.GetPaperAccount().GetReservedBalance().GetUnits())
}
