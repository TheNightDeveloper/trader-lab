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
)

func TestPaperReductionSurvivesPauseAndReconciles(t *testing.T) {
	ctx := context.Background()
	market, wall, client, opportunityID := paperFixture(t)
	p := &Paper{Market: market}
	const unit = paperTestUnit
	_, err := client.InitializePaperAccount(ctx, connect.NewRequest(&labv1.InitializePaperAccountRequest{
		Capital: usdtP(250 * unit), MaxLossPerTrade: usdtP(15 * unit), MaxOpenLoss: usdtP(20 * unit), MaxSpotExposure: usdtP(200 * unit),
	}))
	require.NoError(t, err)
	preview := func() *labv1.PreviewPaperPlanResponse {
		t.Helper()
		v, err := client.PreviewPaperPlan(ctx, connect.NewRequest(&labv1.PreviewPaperPlanRequest{
			Account: paperAccountRef(), OpportunityId: opportunityID, Stop: usdtP(90 * unit), TakeProfit: usdtP(120 * unit),
		}))
		require.NoError(t, err)
		return v.Msg
	}
	plan := preview().GetPlan()
	require.NotNil(t, plan)
	confirmed, err := client.ConfirmPaperPlan(ctx, connect.NewRequest(&labv1.ConfirmPaperPlanRequest{Account: paperAccountRef(), PlanHash: plan.GetPlanHash()}))
	require.NoError(t, err)
	id := confirmed.Msg.GetReceipt().GetId()
	require.Positive(t, id)
	book := func() *labv1.GetPaperAccountResponse {
		t.Helper()
		res, err := client.GetPaperAccount(ctx, connect.NewRequest(&labv1.GetPaperAccountRequest{}))
		require.NoError(t, err)
		return res.Msg
	}
	read := func() *labv1.GetPaperReceiptResponse {
		t.Helper()
		res, err := client.GetPaperReceipt(ctx, connect.NewRequest(&labv1.GetPaperReceiptRequest{ReceiptId: id}))
		require.NoError(t, err)
		return res.Msg
	}
	check := func(recon *labv1.PaperReconciliation) {
		t.Helper()
		require.True(t, recon.GetCashMatches())
		require.True(t, recon.GetReservationsMatch())
		require.True(t, recon.GetPositionsMatch())
		require.True(t, recon.GetEventsMatch())
		require.Positive(t, recon.GetLastEventId())
	}
	ingest := func(offset int, open, high, low, close int64) {
		t.Helper()
		at := now.Add(time.Duration(offset) * time.Minute)
		price := func(v int64) money.Price { return money.Price{V: v * unit, Scale: instrument.Scale} }
		_, err := data.UpsertBars(ctx, market.Store, "BTCUSDT", "rest", "fixture", []data.Bar{{
			OpenTime: at, CloseTime: at.Add(time.Minute), AvailableAt: at.Add(time.Minute),
			O: price(open), H: price(high), L: price(low), C: price(close), Volume: money.Qty{V: 20 * unit, Scale: instrument.Scale},
		}})
		require.NoError(t, err)
		require.NoError(t, wall.Set(at.Add(time.Minute)))
	}
	pause := func(on bool) {
		t.Helper()
		res, err := client.SetPaperEntryPause(ctx, connect.NewRequest(&labv1.SetPaperEntryPauseRequest{Account: paperAccountRef(), Paused: &on}))
		require.NoError(t, err)
		require.Equal(t, on, res.Msg.GetPaused())
	}
	check(book().GetReconciliation())
	ingest(1, 100, 101, 99, 100)
	require.NoError(t, p.runPaperCycle(ctx, nil))
	open := book().GetPositions()[0]
	require.Equal(t, "20000000", open.GetQuantity().GetUnits())
	pause(true)
	pause(true)
	require.Equal(t, "entries_paused", preview().GetRestriction().GetCode())
	ingest(2, 100, 101, 99, 100)
	require.NoError(t, p.runPaperCycle(ctx, nil))
	pause(false)
	require.NoError(t, p.runPaperCycle(ctx, nil))
	require.Equal(t, "20000000", book().GetPositions()[0].GetQuantity().GetUnits())
	pause(true)
	market.Live = nil
	qty := moneyP(money.Amount{V: unit / 10, Asset: instrument.Asset("BTC")})
	reduce := func(rev int64, quantity *labv1.Money) (*labv1.ReducePaperPositionResponse, error) {
		res, err := client.ReducePaperPosition(ctx, connect.NewRequest(&labv1.ReducePaperPositionRequest{
			Account: paperAccountRef(), ReceiptId: id, PositionRevision: rev, Quantity: quantity,
		}))
		if err != nil {
			return nil, err
		}
		return res.Msg, nil
	}
	var group errgroup.Group
	var reduced [2]*labv1.ReducePaperPositionResponse
	for i := range reduced {
		group.Go(func() error {
			v, err := reduce(open.GetRevision(), qty)
			reduced[i] = v
			return err
		})
	}
	require.NoError(t, group.Wait())
	reduction := reduced[0].GetReduction()
	require.Positive(t, reduction.GetId())
	require.Equal(t, reduction.GetId(), reduced[1].GetReduction().GetId())
	require.Equal(t, labv1.PaperReductionState_PAPER_REDUCTION_STATE_PENDING, read().GetReduction().GetState())
	require.Equal(t, "0", book().GetPaperAccount().GetReservedBalance().GetUnits())
	ingest(3, 100, 101, 99, 100)
	require.NoError(t, p.runPaperCycle(ctx, nil))
	filled := read()
	require.Equal(t, labv1.PaperReductionState_PAPER_REDUCTION_STATE_FILLED, filled.GetReduction().GetState())
	remaining := book().GetPositions()[0]
	require.Equal(t, "10000000", remaining.GetQuantity().GetUnits())
	require.Greater(t, remaining.GetRevision(), open.GetRevision())
	check(book().GetReconciliation())

	// Projected cash drift prevents new risk but cannot strand a reconciled position.
	_, err = market.Store.Pool.Exec(ctx, `UPDATE paper_accounts SET cash_available = cash_available + 1 WHERE id = $1`, paperAccountID)
	require.NoError(t, err)
	pause(false)
	require.False(t, book().GetReconciliation().GetCashMatches())
	require.True(t, book().GetReconciliation().GetPositionsMatch())
	require.Equal(t, "ledger_mismatch", preview().GetRestriction().GetCode())
	lastRequest, err := reduce(remaining.GetRevision(), remaining.GetQuantity())
	require.NoError(t, err)
	require.Equal(t, labv1.PaperReductionState_PAPER_REDUCTION_STATE_PENDING, lastRequest.GetReduction().GetState())
	// Finish checking the previous candle's intrabar protection, then observe the next opening gap.
	require.NoError(t, p.runPaperCycle(ctx, nil))
	ingest(4, 123, 125, 88, 100)
	require.NoError(t, p.runPaperCycle(ctx, nil))
	closed := read()
	require.Equal(t, labv1.PaperReductionState_PAPER_REDUCTION_STATE_SUPERSEDED, closed.GetReduction().GetState())
	last := closed.GetEvents()[len(closed.GetEvents())-1]
	require.Equal(t, "target_exit", last.GetKind())
	require.Equal(t, last.GetId(), closed.GetReduction().GetResultEventId())
	require.Empty(t, book().GetPositions())
	require.False(t, book().GetReconciliation().GetCashMatches())
	_, err = market.Store.Pool.Exec(ctx, `UPDATE paper_accounts SET cash_available = cash_available - 1 WHERE id = $1`, paperAccountID)
	require.NoError(t, err)
	final := book()
	check(final.GetReconciliation())
	var pnl int64
	for _, e := range closed.GetEvents() {
		if e.GetRealizedPnl() != nil {
			net, err := strconv.ParseInt(e.GetRealizedPnl().GetUnits(), 10, 64)
			require.NoError(t, err)
			pnl += net
		}
	}
	require.Equal(t, strconv.FormatInt(250*unit+pnl, 10), final.GetPaperAccount().GetSnapshot().GetEquity().GetValue().GetUnits())
}
