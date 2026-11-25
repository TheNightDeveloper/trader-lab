package api

import (
	"context"

	"connectrpc.com/connect"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
)

const paperJournalPageSize = 20

func (p *Paper) ListPaperJournal(ctx context.Context, req *connect.Request[labv1.ListPaperJournalRequest]) (*connect.Response[labv1.ListPaperJournalResponse], error) {
	before := req.Msg.GetBeforeReceiptId()
	if before < 0 {
		return nil, invalid("شناسهٔ صفحهٔ ژورنال معتبر نیست")
	}
	rows, err := p.Market.Store.ListPaperJournal(ctx, db.ListPaperJournalParams{
		AccountID: paperAccountID, BeforeID: before, PageLimit: paperJournalPageSize + 1,
	})
	if err != nil {
		return nil, err
	}
	result := &labv1.ListPaperJournalResponse{}
	for _, row := range rows[:min(len(rows), paperJournalPageSize)] {
		trade := &labv1.PaperJournalTrade{
			Receipt: paperReceiptP(row.PaperEntry),
			// SQL uses numeric totals, which can exceed int64 over many fills.
			FeesPaid:    &labv1.Money{Units: row.FeesPaid, Scale: instrument.Scale, Asset: instrument.USDT.Code},
			RealizedPnl: &labv1.Money{Units: row.RealizedPnl, Scale: instrument.Scale, Asset: instrument.USDT.Code},
		}
		if row.OpenQuantity > 0 {
			spec, _ := paperSpotSpec(row.PaperEntry.Symbol)
			trade.OpenQuantity = moneyP(money.Amount{Asset: spec.Base, V: row.OpenQuantity})
		}
		result.Trades = append(result.Trades, trade)
	}
	if len(rows) > paperJournalPageSize {
		result.NextBeforeReceiptId = rows[paperJournalPageSize-1].PaperEntry.ID
	}
	return connect.NewResponse(result), nil
}
