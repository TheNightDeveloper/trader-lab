package api

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"time"

	"github.com/jackc/pgx/v5"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
)

// RunPaper consumes the durable local queue independently of market-scan or research slots.
func (p *Paper) RunPaper(ctx context.Context) {
	tick := time.NewTicker(2 * time.Second)
	defer tick.Stop()
	for ctx.Err() == nil {
		cycle, cancel := context.WithTimeout(ctx, 4*time.Second)
		err := p.runPaperCycle(cycle)
		cancel()
		if err != nil && ctx.Err() == nil {
			slog.WarnContext(ctx, "Paper execution deferred", "error", err)
		}
		select {
		case <-ctx.Done():
			return
		case <-tick.C:
		}
	}
}

func (p *Paper) runPaperCycle(ctx context.Context) error {
	ids, err := p.Market.Store.PendingPaperEntries(ctx, paperAccountID)
	if err != nil {
		return err
	}
	var failures error
	for _, id := range ids {
		if ctx.Err() != nil {
			return errors.Join(failures, ctx.Err())
		}
		if err := p.advancePaper(ctx, id); err != nil {
			failures = errors.Join(failures, fmt.Errorf("receipt %d: %w", id, err))
		}
	}
	return failures
}

func (p *Paper) advancePaper(ctx context.Context, id int64) error {
	return p.Market.Store.InTx(ctx, func(q *db.Queries) error {
		if err := q.LockPaperAccount(ctx, paperAccountID); err != nil {
			return err
		}
		entry, err := readPaperEntry(ctx, q, id)
		if err != nil {
			return err
		}
		position, err := q.ReadPaperPosition(ctx, id)
		if err != nil && !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
		active := paperEntryActive(entry)
		if !active && position.Quantity == 0 {
			return nil
		}
		plan, err := readPaperPlan(ctx, q, entry.PlanHash)
		if err != nil {
			return err
		}
		terms, err := paperEntryTermsFor(plan)
		if err != nil {
			return err
		}
		now := p.Market.Clock.Now()
		var buy, protect db.NextPaperCandleRow
		if active {
			paused, err := q.PaperEntriesPaused(ctx, entry.AccountID)
			if err != nil {
				return err
			}
			if !paused {
				buy, err = paperNextCandle(ctx, q, entry.Symbol, entry.NextOpenAt, now, entry.ExpiresAt)
				if err != nil {
					return err
				}
			}
			if buy.OpenTime.IsZero() && !now.Before(entry.ExpiresAt) {
				entry, err = finishPaperEntry(ctx, q, entry, paperExpired, "expired", now)
				if err != nil {
					return err
				}
			}
		}
		if position.Quantity > 0 {
			// Entry validity ends with the opportunity. Protection of held quantity has no TTL.
			protect, err = paperNextCandle(ctx, q, entry.Symbol, position.NextOpenAt, now, now.Add(time.Minute))
			if err != nil {
				return err
			}
		}
		if !protect.OpenTime.IsZero() && (buy.OpenTime.IsZero() || !protect.OpenTime.After(buy.OpenTime)) {
			return protectPaperPosition(ctx, q, entry, position, terms, protect, now)
		}
		if !buy.OpenTime.IsZero() {
			return fillPaperEntry(ctx, q, entry, terms, buy, now)
		}
		return nil
	})
}

func paperNextCandle(ctx context.Context, q *db.Queries, symbol string, next, now, expires time.Time) (db.NextPaperCandleRow, error) {
	bar, err := q.NextPaperCandle(ctx, db.NextPaperCandleParams{Symbol: symbol, NextOpen: next, Cutoff: now, Expiry: expires})
	if errors.Is(err, pgx.ErrNoRows) {
		return bar, nil
	}
	return bar, err
}

func fillPaperEntry(ctx context.Context, q *db.Queries, entry db.PaperEntry, terms paperEntryTerms, bar db.NextPaperCandleRow, now time.Time) error {
	// Limit simulated participation to 1% of the observed base volume, rounded down to a lot.
	qty := min(entry.Quantity-entry.FilledQuantity, bar.Volume/100)
	qty = qty / terms.spec.Lot.V * terms.spec.Lot.V
	update := db.UpdatePaperEntryParams{ID: entry.ID, State: entry.State, FilledQuantity: entry.FilledQuantity,
		ReservedCash: entry.ReservedCash, NextOpenAt: bar.CloseTime}
	if qty <= 0 || bar.O <= terms.stop || bar.C <= terms.stop {
		_, err := q.UpdatePaperEntry(ctx, update)
		return err
	}
	fill, err := terms.costs.Fill(terms.spec, true, bar.O, qty)
	if err != nil {
		return err
	}
	if fill.Price > terms.limit || fill.Cash > entry.ReservedCash {
		_, err := q.UpdatePaperEntry(ctx, update)
		return err
	}
	ledger, err := q.ReconcilePaperBook(ctx, entry.AccountID)
	if err != nil {
		return err
	}
	if !paperReconciled(ledger) {
		if ledger.CashMatches && ledger.ReservationsMatch && !now.Before(entry.ExpiresAt) {
			_, err := finishPaperEntry(ctx, q, entry, paperExpired, "expired", now)
			return err
		}
		return nil
	}
	update.FilledQuantity += qty
	update.ReservedCash -= fill.Cash
	update.State = paperPartial
	var released int64
	switch {
	case update.FilledQuantity == entry.Quantity:
		update.State, released = paperFilled, update.ReservedCash
		update.ReservedCash = 0
	case update.ReservedCash == 0:
		update.State = paperCancelled
	}
	event, err := q.InsertPaperExecutionEvent(ctx, db.InsertPaperExecutionEventParams{
		EntryID: entry.ID, Kind: "entry_fill", RecordedAt: now, Quantity: qty, Reference: bar.O,
		FillPrice: fill.Price, Fee: fill.Fee, Cash: fill.Cash, CandleOpenAt: &bar.OpenTime, CandleRevision: bar.Revision,
	})
	if err != nil {
		return err
	}
	for leg, posting := range []struct {
		asset, source, dest string
		amount              int64
	}{
		{"USDT", "reserved", "clearing", fill.Notional},
		{"USDT", "reserved", "fees", fill.Fee},
		{"USDT", "reserved", "available", released},
		{terms.spec.Base.Code, "clearing", "position", qty},
	} {
		if err := paperPosting(ctx, q, event, int32(leg), now, posting.asset, posting.source, posting.dest, posting.amount); err != nil {
			return err
		}
	}
	if err := q.MovePaperCash(ctx, db.MovePaperCashParams{ID: entry.AccountID, AvailableDelta: released, ReservedDelta: -fill.Cash - released}); err != nil {
		return err
	}
	// Ignore candles that opened before the fill was observable from the closed bar.
	protectFrom := firstFullPaperMinute(bar.AvailableAt)
	if err := q.AddPaperPosition(ctx, db.AddPaperPositionParams{EntryID: entry.ID, Quantity: qty, CostBasis: fill.Cash, NextOpenAt: protectFrom}); err != nil {
		return err
	}
	_, err = q.UpdatePaperEntry(ctx, update)
	return err
}

func protectPaperPosition(ctx context.Context, q *db.Queries, entry db.PaperEntry, position db.PaperPosition, terms paperEntryTerms, bar db.NextPaperCandleRow, now time.Time) error {
	reduction, err := q.PendingPaperReduction(ctx, entry.ID)
	if err != nil && !errors.Is(err, pgx.ErrNoRows) {
		return err
	}
	var reference int64
	var kind string
	qty := position.Quantity
	switch {
	case bar.O >= terms.target:
		// An opening gap establishes the target before any intrabar stop touch.
		reference, kind = terms.target, "target_exit"
	case bar.O <= terms.stop:
		reference, kind = bar.O, "stop_exit"
	case reduction.ID != 0 && !bar.OpenTime.Before(reduction.NextOpenAt):
		// A requested reduction at the open precedes intrabar triggers.
		reference, kind, qty = bar.O, "manual_exit", reduction.Quantity
	case bar.L <= terms.stop:
		// If both thresholds occur in one OHLC candle, prefer the adverse stop.
		reference, kind = terms.stop, "stop_exit"
	case bar.H >= terms.target:
		reference, kind = terms.target, "target_exit"
	default:
		return q.AdvancePaperPosition(ctx, db.AdvancePaperPositionParams{EntryID: entry.ID, NextOpenAt: bar.CloseTime})
	}
	ledger, err := q.ReconcilePaperBook(ctx, entry.AccountID)
	if err != nil {
		return err
	}
	if !ledger.PositionsMatch || (paperEntryActive(entry) && !ledger.ReservationsMatch) {
		return nil
	}
	if qty <= 0 || qty > position.Quantity {
		return fmt.Errorf("reduction quantity exceeds held position for receipt %d", entry.ID)
	}
	if paperEntryActive(entry) {
		if _, err := finishPaperEntry(ctx, q, entry, paperCancelled, "protection_cancelled_remainder", now); err != nil {
			return err
		}
	}
	event, err := executePaperExit(ctx, q, entry, position, terms, bar, now, kind, reference, qty)
	if err != nil {
		return err
	}
	if reduction.ID == 0 {
		return nil
	}
	state := paperReductionSuperseded
	if kind == "manual_exit" {
		state = paperReductionFilled
	}
	return q.FinishPaperReduction(ctx, db.FinishPaperReductionParams{ID: reduction.ID, State: state, ResultEventID: &event})
}

func executePaperExit(ctx context.Context, q *db.Queries, entry db.PaperEntry, position db.PaperPosition, terms paperEntryTerms, bar db.NextPaperCandleRow, now time.Time, kind string, reference, qty int64) (int64, error) {
	fill, err := terms.costs.Fill(terms.spec, false, reference, qty)
	if err != nil {
		return 0, err
	}
	// Round allocated basis down and leave the remainder with the held coins.
	basis, err := money.MulDiv(position.CostBasis, qty, position.Quantity, money.Floor)
	if err != nil {
		return 0, err
	}
	net, err := money.SubInt64(fill.Cash, basis)
	if err != nil {
		return 0, err
	}
	event, err := q.InsertPaperExecutionEvent(ctx, db.InsertPaperExecutionEventParams{
		EntryID: entry.ID, Kind: kind, RecordedAt: now, Quantity: qty, Reference: reference,
		FillPrice: fill.Price, Fee: fill.Fee, Cash: fill.Cash, CandleOpenAt: &bar.OpenTime,
		CandleRevision: bar.Revision, RealizedPnl: net,
	})
	if err != nil {
		return 0, err
	}
	if err := paperPosting(ctx, q, event, 0, now, "USDT", "clearing", "available", fill.Cash); err != nil {
		return 0, err
	}
	if err := paperPosting(ctx, q, event, 1, now, "USDT", "clearing", "fees", fill.Fee); err != nil {
		return 0, err
	}
	if err := paperPosting(ctx, q, event, 2, now, terms.spec.Base.Code, "position", "clearing", qty); err != nil {
		return 0, err
	}
	if err := q.MovePaperCash(ctx, db.MovePaperCashParams{ID: entry.AccountID, AvailableDelta: fill.Cash}); err != nil {
		return 0, err
	}
	if qty == position.Quantity {
		return event, q.RemovePaperPosition(ctx, position.EntryID)
	}
	// The remainder is still protected from intrabar moves after a manual sale at the open.
	return event, q.UpdatePaperPositionAfterReduction(ctx, db.UpdatePaperPositionAfterReductionParams{
		EntryID: position.EntryID, Sold: qty, ReleasedBasis: basis, NextOpenAt: bar.OpenTime,
	})
}
