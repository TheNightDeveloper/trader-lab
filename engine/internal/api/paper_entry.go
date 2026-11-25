package api

import (
	"context"
	"errors"
	"fmt"
	"strconv"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/paper"
	"tradinglab/engine/internal/store/db"
)

const paperPositionLimit = 4

const (
	paperPending   = int32(labv1.PaperEntryState_PAPER_ENTRY_STATE_PENDING)
	paperPartial   = int32(labv1.PaperEntryState_PAPER_ENTRY_STATE_PARTIAL)
	paperFilled    = int32(labv1.PaperEntryState_PAPER_ENTRY_STATE_FILLED)
	paperCancelled = int32(labv1.PaperEntryState_PAPER_ENTRY_STATE_CANCELLED)
	paperExpired   = int32(labv1.PaperEntryState_PAPER_ENTRY_STATE_EXPIRED)
)

type paperEntryTerms struct {
	spec                          instrument.Spec
	costs                         paper.Costs
	quantity, limit, stop, target int64
}

// Decode exact units from the hashed review, never from confirmation inputs.
func paperEntryTermsFor(plan *labv1.PaperPlan) (paperEntryTerms, error) {
	var terms paperEntryTerms
	spec, ok := paperSpotSpec(plan.GetInstrument().GetSymbol())
	if !ok || plan.GetFillModel() != paperFillModel || spotKey(spec).GetSpecRevision() != plan.GetInstrument().GetSpecRevision() {
		return terms, fmt.Errorf("paper plan %s has unsupported execution terms", plan.GetPlanHash())
	}
	qty := plan.GetQuantity()
	q, err := scaled(qty.GetUnits(), qty.GetScale(), spec.Base.Scale)
	if err != nil || qty.GetAsset() != spec.Base.Code || q <= 0 || q%spec.Lot.V != 0 {
		return terms, fmt.Errorf("paper plan %s has invalid quantity", plan.GetPlanHash())
	}
	for _, price := range []struct {
		wire *labv1.Money
		out  *int64
	}{{plan.GetMaxEntryPrice(), &terms.limit}, {plan.GetStop(), &terms.stop}, {plan.GetTakeProfit(), &terms.target}} {
		amount, present, err := usdtIn(price.wire, "paper price")
		if err != nil || !present || amount.V <= 0 || amount.V%spec.Tick.V != 0 {
			return terms, fmt.Errorf("paper plan %s has invalid price levels", plan.GetPlanHash())
		}
		*price.out = amount.V
	}
	fee, hasFee, err := ratioIn(plan.GetFeeRate(), "paper fee")
	slip, hasSlip, slipErr := ratioIn(plan.GetSlippageRate(), "paper slippage")
	if err != nil || slipErr != nil || !hasFee || !hasSlip || fee < 0 || fee >= money.RatioOne || slip < 0 || slip >= money.RatioOne {
		return terms, fmt.Errorf("paper plan %s has invalid costs", plan.GetPlanHash())
	}
	terms.spec, terms.quantity, terms.costs = spec, q, paper.Costs{Fee: fee, Slippage: slip}
	return terms, nil
}

func (p *Paper) ConfirmPaperPlan(ctx context.Context, req *connect.Request[labv1.ConfirmPaperPlanRequest]) (*connect.Response[labv1.ConfirmPaperPlanResponse], error) {
	if !paperAccountMatches(req.Msg.GetAccount()) {
		return nil, invalid("تأیید به حساب مجازی مشخص نیاز دارد")
	}
	plan, err := readPaperPlan(ctx, p.Market.Store.Queries, req.Msg.GetPlanHash())
	if err != nil {
		return nil, err
	}
	response := &labv1.ConfirmPaperPlanResponse{}
	err = p.Market.Store.InTx(ctx, func(q *db.Queries) error {
		if err := q.LockPaperAccount(ctx, paperAccountID); err != nil {
			return err
		}
		entry, err := q.PaperEntryForOpportunity(ctx, db.PaperEntryForOpportunityParams{AccountID: paperAccountID, OpportunityID: plan.GetOpportunityId()})
		if err == nil {
			response.Receipt = paperReceiptP(entry)
			return nil
		}
		if !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
		entry, response.Restriction, err = p.reservePaperPlan(ctx, q, plan)
		if err == nil && response.Restriction == nil {
			response.Receipt = paperReceiptP(entry)
		}
		return err
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(response), nil
}

// reservePaperPlan runs with the account row locked. The receipt acts as the local outbox.
func (p *Paper) reservePaperPlan(ctx context.Context, q *db.Queries, plan *labv1.PaperPlan) (db.PaperEntry, *labv1.PaperRestriction, error) {
	var entry db.PaperEntry
	account, err := q.ReadPaperAccount(ctx, paperAccountID)
	if err != nil {
		return entry, nil, err
	}
	candle, restriction, err := p.revalidatePaperPlan(ctx, q, plan, account)
	if err != nil || restriction != nil {
		return entry, restriction, err
	}
	terms, err := paperEntryTermsFor(plan)
	if err != nil {
		return entry, nil, err
	}
	reserve, _, err := usdtIn(plan.GetRequiredCash(), "paper reserve")
	if err != nil {
		return entry, nil, err
	}
	loss, _, err := usdtIn(plan.GetPlannedLoss(), "paper loss")
	if err != nil {
		return entry, nil, err
	}
	exposure, err := money.MulScaled(terms.quantity, terms.spec.Base.Scale, terms.limit, instrument.Scale, instrument.Scale, money.Ceil)
	if err != nil {
		return entry, nil, err
	}
	usage, err := q.PaperExposure(ctx, db.PaperExposureParams{AccountID: account.ID, Symbol: terms.spec.Symbol})
	if err != nil {
		return entry, nil, err
	}
	if usage.SymbolBusy || usage.Slots >= paperPositionLimit || reserve.V <= 0 || reserve.V > account.CashAvailable ||
		loss.V <= 0 || loss.V > min(account.MaxLoss, account.MaxOpenLoss-usage.OpenLoss) || exposure > account.MaxExposure-usage.Exposure {
		return entry, paperRestriction("risk_budget", "وجه آزاد، سقف ریسک یا ظرفیت موقعیت‌های حساب کافی نیست"), nil
	}
	opp, err := q.PaperOpportunity(ctx, plan.GetOpportunityId())
	if err != nil {
		return entry, nil, err
	}
	now := p.Market.Clock.Now()
	if now.UnixMilli() >= plan.GetExpiresAtUnixMs() || !now.Before(opp.ExpiresAt) {
		return entry, paperRestriction("plan_expired", "اعتبار برنامه یا فرصت پایان یافته است"), nil
	}
	next := firstFullPaperMinute(now)
	expires := now.Add(10 * time.Minute)
	if opp.ExpiresAt.Before(expires) {
		expires = opp.ExpiresAt
	}
	if !next.Add(time.Minute).Before(expires) {
		return entry, paperRestriction("entry_window", "تا پایان اعتبار فرصت، زمان کافی برای رسیدن کندل بعدی باقی نمانده است"), nil
	}
	entry, err = q.InsertPaperEntry(ctx, db.InsertPaperEntryParams{
		AccountID: account.ID, OpportunityID: plan.GetOpportunityId(), PlanHash: plan.GetPlanHash(), Symbol: terms.spec.Symbol,
		ConfirmedAt: now, ExpiresAt: expires, NextOpenAt: next, Quantity: terms.quantity, ReservedCash: reserve.V,
		ExposureBound: exposure, LossBound: loss.V,
	})
	if err != nil {
		return entry, nil, err
	}
	event, err := q.InsertPaperExecutionEvent(ctx, db.InsertPaperExecutionEventParams{EntryID: entry.ID, Kind: "accepted", RecordedAt: now, Cash: reserve.V})
	if err != nil {
		return entry, nil, err
	}
	if err := q.StorePaperConfirmationEvidence(ctx, db.StorePaperConfirmationEvidenceParams{
		EventID: event, OpenTime: candle.OpenTime, CloseTime: candle.CloseTime, AvailableAt: candle.AvailableAt,
		Revision: candle.Revision, ClosePrice: candle.C,
	}); err != nil {
		return entry, nil, err
	}
	if err := paperPosting(ctx, q, event, 0, now, "USDT", "available", "reserved", reserve.V); err != nil {
		return entry, nil, err
	}
	err = q.MovePaperCash(ctx, db.MovePaperCashParams{ID: account.ID, AvailableDelta: -reserve.V, ReservedDelta: reserve.V})
	return entry, nil, err
}

func (p *Paper) GetPaperReceipt(ctx context.Context, req *connect.Request[labv1.GetPaperReceiptRequest]) (*connect.Response[labv1.GetPaperReceiptResponse], error) {
	response := &labv1.GetPaperReceiptResponse{}
	err := p.Market.Store.InTxOptions(ctx, pgx.TxOptions{IsoLevel: pgx.RepeatableRead, AccessMode: pgx.ReadOnly}, func(q *db.Queries) error {
		entry, err := readPaperEntry(ctx, q, req.Msg.GetReceiptId())
		if err != nil {
			return err
		}
		response.Receipt = paperReceiptP(entry)
		reduction, err := q.LatestPaperReduction(ctx, entry.ID)
		if err == nil {
			response.Reduction = paperReductionP(entry.Symbol, reduction)
		} else if !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
		events, err := q.PaperExecutionEvents(ctx, entry.ID)
		if err != nil {
			return err
		}
		for _, event := range events {
			response.Events = append(response.Events, paperEventP(entry, event))
		}
		note, err := q.LatestPaperJournalNote(ctx, entry.ID)
		if err == nil {
			response.Note = paperJournalNoteP(note)
		} else if !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(response), nil
}

func (p *Paper) CancelPaperEntry(ctx context.Context, req *connect.Request[labv1.CancelPaperEntryRequest]) (*connect.Response[labv1.CancelPaperEntryResponse], error) {
	if !paperAccountMatches(req.Msg.GetAccount()) {
		return nil, invalid("لغو به حساب مجازی مشخص نیاز دارد")
	}
	var entry db.PaperEntry
	err := p.Market.Store.InTx(ctx, func(q *db.Queries) error {
		if err := q.LockPaperAccount(ctx, paperAccountID); err != nil {
			return err
		}
		var err error
		entry, err = readPaperEntry(ctx, q, req.Msg.GetReceiptId())
		if err != nil || !paperEntryActive(entry) {
			return err
		}
		entry, err = finishPaperEntry(ctx, q, entry, paperCancelled, "cancelled", p.Market.Clock.Now())
		return err
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.CancelPaperEntryResponse{Receipt: paperReceiptP(entry)}), nil
}

func finishPaperEntry(ctx context.Context, q *db.Queries, entry db.PaperEntry, state int32, kind string, at time.Time) (db.PaperEntry, error) {
	event, err := q.InsertPaperExecutionEvent(ctx, db.InsertPaperExecutionEventParams{EntryID: entry.ID, Kind: kind, RecordedAt: at, Cash: entry.ReservedCash})
	if err != nil {
		return entry, err
	}
	if err := paperPosting(ctx, q, event, 0, at, "USDT", "reserved", "available", entry.ReservedCash); err != nil {
		return entry, err
	}
	if err := q.MovePaperCash(ctx, db.MovePaperCashParams{ID: entry.AccountID, AvailableDelta: entry.ReservedCash, ReservedDelta: -entry.ReservedCash}); err != nil {
		return entry, err
	}
	return q.UpdatePaperEntry(ctx, db.UpdatePaperEntryParams{
		ID: entry.ID, State: state, FilledQuantity: entry.FilledQuantity, NextOpenAt: entry.NextOpenAt,
	})
}

func readPaperEntry(ctx context.Context, q *db.Queries, id int64) (db.PaperEntry, error) {
	if id <= 0 {
		return db.PaperEntry{}, invalid("شناسهٔ رسید معتبر نیست")
	}
	entry, err := q.ReadPaperEntry(ctx, db.ReadPaperEntryParams{ID: id, AccountID: paperAccountID})
	if errors.Is(err, pgx.ErrNoRows) {
		return entry, connect.NewError(connect.CodeNotFound, errors.New("رسید مجازی پیدا نشد"))
	}
	return entry, err
}

func paperEntryActive(e db.PaperEntry) bool {
	return e.State == paperPending || e.State == paperPartial
}

func paperPosting(ctx context.Context, q *db.Queries, event int64, leg int32, at time.Time, asset, source, destination string, amount int64) error {
	if amount == 0 {
		return nil
	}
	return q.InsertPaperPosting(ctx, db.InsertPaperPostingParams{
		AccountID: paperAccountID, EventKey: "event:" + strconv.FormatInt(event, 10), Leg: leg, RecordedAt: at,
		Asset: asset, Source: source, Destination: destination, Amount: amount,
	})
}

func paperReceiptP(e db.PaperEntry) *labv1.PaperReceipt {
	spec, _ := paperSpotSpec(e.Symbol)
	return &labv1.PaperReceipt{
		Id: e.ID, Account: paperAccountRef(), PlanHash: e.PlanHash, Symbol: e.Symbol, State: labv1.PaperEntryState(e.State),
		RequestedQuantity: moneyP(money.Amount{V: e.Quantity, Asset: spec.Base}),
		FilledQuantity:    moneyP(money.Amount{V: e.FilledQuantity, Asset: spec.Base}), ReservedCash: usdtP(e.ReservedCash),
		ConfirmedAtUnixMs: ms(e.ConfirmedAt), ExpiresAtUnixMs: ms(e.ExpiresAt),
	}
}

func paperEventP(entry db.PaperEntry, row db.PaperExecutionEvent) *labv1.PaperExecutionEvent {
	event := &labv1.PaperExecutionEvent{Id: row.ID, Kind: row.Kind, RecordedAtUnixMs: ms(row.RecordedAt)}
	if row.Kind != "reduction_requested" {
		event.Cash = usdtP(row.Cash)
	}
	if row.Quantity > 0 {
		spec, _ := paperSpotSpec(entry.Symbol)
		event.Quantity = moneyP(money.Amount{V: row.Quantity, Asset: spec.Base})
	}
	if row.CandleOpenAt != nil {
		opened := ms(*row.CandleOpenAt)
		event.CandleOpenedAtUnixMs, event.CandleRevision = &opened, row.CandleRevision
		event.ReferencePrice, event.FillPrice, event.Fee = usdtP(row.Reference), usdtP(row.FillPrice), usdtP(row.Fee)
		if row.Kind != "entry_fill" {
			event.RealizedPnl = usdtP(row.RealizedPnl)
		}
	}
	return event
}
