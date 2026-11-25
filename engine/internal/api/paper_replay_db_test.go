package api

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/proto"

	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
)

func TestPaperReplayUsesOnlyRecordedDecisionEvidence(t *testing.T) {
	ctx := context.Background()
	market, _, client, opportunityID := paperFixture(t)
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
	revise := func(value int64) {
		t.Helper()
		price := money.Price{V: value, Scale: instrument.Scale}
		_, err := data.UpsertBars(ctx, market.Store, "BTCUSDT", "rest", "fixture", []data.Bar{{
			OpenTime: now.Add(-time.Minute), CloseTime: now, AvailableAt: now, O: price, H: price, L: price, C: price,
		}})
		require.NoError(t, err)
	}
	revise(100*unit + unit/10)
	confirmed, err := client.ConfirmPaperPlan(ctx, connect.NewRequest(&labv1.ConfirmPaperPlanRequest{
		Account: paperAccountRef(), PlanHash: plan.GetPlanHash(),
	}))
	require.NoError(t, err)
	id := confirmed.Msg.GetReceipt().GetId()
	require.Positive(t, id)

	// The live source moves on and the order reaches a terminal state before replay.
	revise(99 * unit)
	market.Live = nil
	_, err = client.CancelPaperEntry(ctx, connect.NewRequest(&labv1.CancelPaperEntryRequest{Account: paperAccountRef(), ReceiptId: id}))
	require.NoError(t, err)
	read := func(cursor int64) *labv1.GetPaperReplayResponse {
		t.Helper()
		result, err := client.GetPaperReplay(ctx, connect.NewRequest(&labv1.GetPaperReplayRequest{ReceiptId: id, Cursor: cursor}))
		require.NoError(t, err)
		return result.Msg
	}
	observation := read(0)
	require.Nil(t, observation.PreviousCursor)
	require.EqualValues(t, -1, observation.GetNextCursor())
	require.Nil(t, observation.GetExecution())
	require.Nil(t, observation.GetPlan())
	require.Equal(t, plan.GetSnapshotSha256(), observation.GetObservation().GetSnapshotSha256())
	require.Equal(t, usdtP(100*unit).GetUnits(), observation.GetObservation().GetOpportunity().GetReferenceClose().GetUnits())
	require.EqualValues(t, 1, observation.GetObservation().GetInputCandleCount())
	require.Contains(t, observation.GetObservation().GetEntryRuleJson(), `"op": "gt"`)
	review := read(observation.GetNextCursor())
	require.NotNil(t, review.PreviousCursor)
	require.Zero(t, review.GetPreviousCursor())
	require.True(t, proto.Equal(plan, review.GetPlan()))
	require.Nil(t, review.GetExecution())
	accepted := read(review.GetNextCursor())
	require.EqualValues(t, -1, accepted.GetPreviousCursor())
	require.Equal(t, "accepted", accepted.GetExecution().GetEvent().GetKind())
	require.EqualValues(t, 2, accepted.GetExecution().GetConfirmationCandle().GetRevision())
	require.Equal(t, usdtP(100*unit+unit/10).GetUnits(), accepted.GetExecution().GetConfirmationCandle().GetClose().GetUnits())
	require.Nil(t, accepted.GetExecution().GetEvent().GetFee())
	cancelled := read(accepted.GetNextCursor())
	require.Equal(t, accepted.GetExecution().GetEvent().GetId(), cancelled.GetPreviousCursor())
	require.Equal(t, "cancelled", cancelled.GetExecution().GetEvent().GetKind())
	require.Nil(t, cancelled.NextCursor)
	require.Nil(t, cancelled.GetExecution().GetConfirmationCandle())

	// Receipts created before the migration still replay without inventing the confirmation quote.
	_, err = market.Store.Pool.Exec(ctx, "DELETE FROM paper_confirmation_evidence WHERE event_id = $1", review.GetNextCursor())
	require.NoError(t, err)
	require.Nil(t, read(review.GetNextCursor()).GetExecution().GetConfirmationCandle())
}
