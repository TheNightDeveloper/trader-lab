package api

import (
	"context"
	"errors"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
)

const (
	paperReductionFilled     = int32(labv1.PaperReductionState_PAPER_REDUCTION_STATE_FILLED)
	paperReductionSuperseded = int32(labv1.PaperReductionState_PAPER_REDUCTION_STATE_SUPERSEDED)
)

func (p *Paper) ReducePaperPosition(ctx context.Context, req *connect.Request[labv1.ReducePaperPositionRequest]) (*connect.Response[labv1.ReducePaperPositionResponse], error) {
	input := req.Msg
	if !paperAccountMatches(input.GetAccount()) || input.GetPositionRevision() <= 0 {
		return nil, invalid("حساب مجازی و نسخهٔ موقعیت را مشخص کنید")
	}
	result := &labv1.ReducePaperPositionResponse{}
	err := p.Market.Store.InTx(ctx, func(q *db.Queries) error {
		if err := q.LockPaperAccount(ctx, paperAccountID); err != nil {
			return err
		}
		entry, err := readPaperEntry(ctx, q, input.GetReceiptId())
		if err != nil {
			return err
		}
		spec, ok := paperSpotSpec(entry.Symbol)
		if !ok {
			return invalid("نماد اسپات قابل کاهش نیست")
		}
		quantity := input.GetQuantity()
		qty, err := scaled(quantity.GetUnits(), quantity.GetScale(), spec.Base.Scale)
		if err != nil || quantity.GetAsset() != spec.Base.Code || qty <= 0 || qty%spec.Lot.V != 0 {
			return invalid("حجم کاهش باید مثبت، با واحد دارایی پایه و مضرب گام حجم نماد باشد")
		}
		existing, err := q.PaperReductionAtRevision(ctx, db.PaperReductionAtRevisionParams{
			EntryID: entry.ID, PositionRevision: input.GetPositionRevision(),
		})
		if err == nil {
			if existing.Quantity != qty {
				result.Restriction = paperRestriction("reduction_exists", "برای این نسخهٔ موقعیت درخواست کاهش دیگری ثبت شده است")
			} else {
				result.Reduction = paperReductionP(entry.Symbol, existing)
			}
			return nil
		}
		if !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
		position, err := q.ReadPaperPosition(ctx, entry.ID)
		if errors.Is(err, pgx.ErrNoRows) {
			result.Restriction = paperRestriction("position_closed", "موقعیت باز برای کاهش وجود ندارد")
			return nil
		}
		if err != nil {
			return err
		}
		if position.Revision != input.GetPositionRevision() || qty > position.Quantity {
			result.Restriction = paperRestriction("position_changed", "حجم یا نسخهٔ موقعیت تغییر کرده است؛ دوباره بررسی کنید")
			return nil
		}
		ledger, err := q.ReconcilePaperBook(ctx, entry.AccountID)
		if err != nil {
			return err
		}
		if !ledger.PositionsMatch || (paperEntryActive(entry) && !ledger.ReservationsMatch) {
			result.Restriction = paperRestriction("reduction_mismatch", "موقعیت یا وجه رزروشده با دفتر تطبیق ندارد")
			return nil
		}
		now := p.Market.Clock.Now()
		if paperEntryActive(entry) {
			if _, err := finishPaperEntry(ctx, q, entry, paperCancelled, "reduction_cancelled_remainder", now); err != nil {
				return err
			}
		}
		// A queued reduction persists through outages, while protection continues to cover the position.
		reduction, err := q.InsertPaperReduction(ctx, db.InsertPaperReductionParams{
			EntryID: entry.ID, PositionRevision: position.Revision, Quantity: qty, RequestedAt: now, NextOpenAt: firstFullPaperMinute(now),
		})
		if err != nil {
			return err
		}
		if _, err := q.InsertPaperExecutionEvent(ctx, db.InsertPaperExecutionEventParams{
			EntryID: entry.ID, Kind: "reduction_requested", RecordedAt: now, Quantity: qty,
		}); err != nil {
			return err
		}
		result.Reduction = paperReductionP(entry.Symbol, reduction)
		return nil
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(result), nil
}

// Candle open must not precede a decision, even if it belongs to the same minute.
func firstFullPaperMinute(at time.Time) time.Time {
	minute := at.Truncate(time.Minute)
	if minute.Before(at) {
		return minute.Add(time.Minute)
	}
	return minute
}

func paperReductionP(symbol string, row db.PaperReduction) *labv1.PaperReduction {
	spec, _ := paperSpotSpec(symbol)
	return &labv1.PaperReduction{
		Id: row.ID, ReceiptId: row.EntryID, State: labv1.PaperReductionState(row.State),
		Quantity:          moneyP(money.Amount{V: row.Quantity, Asset: spec.Base}),
		RequestedAtUnixMs: ms(row.RequestedAt), ResultEventId: row.ResultEventID,
	}
}
