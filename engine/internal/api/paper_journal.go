package api

import (
	"context"
	"errors"
	"math"
	"strings"
	"unicode/utf8"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
)

const paperJournalPageSize = 20

func (p *Paper) SavePaperJournalNote(ctx context.Context, req *connect.Request[labv1.SavePaperJournalNoteRequest]) (*connect.Response[labv1.SavePaperJournalNoteResponse], error) {
	input := req.Msg
	body := strings.TrimSpace(input.GetText())
	revision := input.GetExpectedRevision()
	if revision < 0 || revision == math.MaxInt64 || !utf8.ValidString(body) || strings.ContainsRune(body, 0) || utf8.RuneCountInString(body) > 1000 {
		return nil, invalid("یادداشت باید حداکثر ۱۰۰۰ نویسه و نسخهٔ آن معتبر باشد")
	}
	q := p.Market.Store.Queries
	entry, err := readPaperEntry(ctx, q, input.GetReceiptId())
	if err != nil {
		return nil, err
	}
	note, err := q.AppendPaperJournalNote(ctx, db.AppendPaperJournalNoteParams{
		ReceiptID: entry.ID, ExpectedRevision: revision, NoteBody: body, NoteTime: p.Market.Clock.Now(),
	})
	if errors.Is(err, pgx.ErrNoRows) {
		// A retry after a lost response recovers the committed revision.
		note, err = q.LatestPaperJournalNote(ctx, entry.ID)
		if errors.Is(err, pgx.ErrNoRows) || err == nil && (note.Revision != revision+1 || note.Body != body) {
			return nil, connect.NewError(connect.CodeAborted, errors.New("یادداشت در جای دیگری تغییر کرده است"))
		}
	}
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.SavePaperJournalNoteResponse{Note: paperJournalNoteP(note)}), nil
}

func paperJournalNoteP(row db.PaperJournalNote) *labv1.PaperJournalNote {
	return &labv1.PaperJournalNote{Text: row.Body, Revision: row.Revision, RecordedAtUnixMs: ms(row.RecordedAt)}
}

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
