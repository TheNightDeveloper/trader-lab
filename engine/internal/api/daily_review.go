package api

import (
	"cmp"
	"context"
	"errors"
	"slices"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/db"
)

type DailyReview struct{ Paper *Paper }

func (d *DailyReview) GetDailyReview(ctx context.Context, _ *connect.Request[labv1.GetDailyReviewRequest]) (*connect.Response[labv1.GetDailyReviewResponse], error) {
	m := d.Paper.Market
	now := m.Clock.Now()
	day := dailyReviewDay(now)
	res := &labv1.GetDailyReviewResponse{AsOfUnixMs: ms(now)}
	err := m.Store.InTxOptions(ctx, pgx.TxOptions{IsoLevel: pgx.RepeatableRead, AccessMode: pgx.ReadOnly}, func(q *db.Queries) error {
		status, err := q.ReadDailyReviewStatus(ctx)
		if err != nil {
			return err
		}
		res.Status = dailyReviewStatusP(status, day)
		book := &labv1.GetPaperAccountResponse{}
		if err := d.Paper.readPaperBookAt(ctx, q, book, now); err != nil {
			return err
		}
		res.PaperAccount, res.Positions, res.Reconciliation = book.PaperAccount, book.Positions, book.Reconciliation
		res.Exposure, err = dailyReviewExposure(book.Positions)
		if err != nil {
			return err
		}
		if err := m.readDailyReviewOpportunities(ctx, q, res, day, now); err != nil {
			return err
		}
		symbols := slices.Clone(m.Symbols)
		for _, position := range book.Positions {
			symbols = append(symbols, position.GetSymbol())
		}
		deployments, err := q.ListShadowDeployments(ctx)
		if err != nil {
			return err
		}
		if len(deployments) > 0 {
			row := deployments[0] // The existing Shadow ordering prefers the active run.
			res.Shadow, err = shadowDeploymentP(row)
			if err != nil {
				return err
			}
			rule, err := q.GetRuleVersion(ctx, row.RuleVersionID)
			if err != nil {
				return err
			}
			res.ShadowRuleTitle = rule.Title
			symbols = append(symbols, row.Symbol)
		}
		events, err := q.DailyReviewEvents(ctx, db.DailyReviewEventsParams{Symbols: symbols, DayStart: day, AsOf: now})
		if err != nil {
			return err
		}
		for _, event := range events {
			res.Events = append(res.Events, &labv1.DailyReviewEvent{
				Symbol: event.Symbol, Kind: event.Kind, DetectedAtUnixMs: ms(event.DetectedAt), Detail: event.Detail,
			})
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(res), nil
}

func (m *Market) readDailyReviewOpportunities(ctx context.Context, q *db.Queries, res *labv1.GetDailyReviewResponse, day, now time.Time) error {
	rows, err := q.DailyReviewOpportunities(ctx, db.DailyReviewOpportunitiesParams{DayStart: day, AsOf: now})
	if err != nil || len(rows) == 0 {
		return err
	}
	_, fresh, err := m.marketWatch(ctx, q, now)
	if err != nil {
		return err
	}
	for _, row := range rows {
		item := &labv1.MarketOpportunity{
			Id: row.ID, Symbol: row.Symbol, RuleVersionId: row.RuleVersionID, RuleTitle: row.RuleTitle,
			ReportId: row.ReportID, Reason: row.Reason, ReferenceClose: usdtP(row.ReferenceClose),
			CandleClosedAtUnixMs: ms(row.CandleClosedAt), ObservedAtUnixMs: ms(row.ObservedAt), ExpiresAtUnixMs: ms(row.ExpiresAt),
			Current: opportunityCurrent(fresh[row.Symbol], now, row.CandleClosedAt, row.ExpiresAt),
		}
		if row.Expired {
			res.Expired = append(res.Expired, item)
			res.ExpiredCount = row.Total
		} else {
			res.OpenWindow = append(res.OpenWindow, item)
			res.OpenWindowCount = row.Total
		}
	}
	return nil
}

func (d *DailyReview) GetDailyReviewStatus(ctx context.Context, _ *connect.Request[labv1.GetDailyReviewStatusRequest]) (*connect.Response[labv1.GetDailyReviewStatusResponse], error) {
	m := d.Paper.Market
	status, err := m.Store.ReadDailyReviewStatus(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.GetDailyReviewStatusResponse{Status: dailyReviewStatusP(status, dailyReviewDay(m.Clock.Now()))}), nil
}

func (d *DailyReview) SetDailyReviewReminder(ctx context.Context, req *connect.Request[labv1.SetDailyReviewReminderRequest]) (*connect.Response[labv1.SetDailyReviewReminderResponse], error) {
	if req.Msg.Enabled == nil {
		return nil, invalid("وضعیت یادآوری را مشخص کنید")
	}
	m := d.Paper.Market
	status, err := m.Store.SetDailyReviewReminder(ctx, req.Msg.GetEnabled())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.SetDailyReviewReminderResponse{Status: dailyReviewStatusP(status, dailyReviewDay(m.Clock.Now()))}), nil
}

func (d *DailyReview) MarkDailyReviewRead(ctx context.Context, req *connect.Request[labv1.MarkDailyReviewReadRequest]) (*connect.Response[labv1.MarkDailyReviewReadResponse], error) {
	m := d.Paper.Market
	day := dailyReviewDay(m.Clock.Now())
	// The reviewed page must belong to this UTC day, including after a midnight rollover.
	if req.Msg.GetDayStartUnixMs() != ms(day) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("روز مرور عوض شده است؛ صفحه را به‌روز کنید"))
	}
	status, err := m.Store.MarkDailyReviewRead(ctx, day)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.MarkDailyReviewReadResponse{Status: dailyReviewStatusP(status, day)}), nil
}

func dailyReviewDay(now time.Time) time.Time { return now.UTC().Truncate(24 * time.Hour) }

func dailyReviewStatusP(row db.DailyReviewStatus, day time.Time) *labv1.DailyReviewStatus {
	return &labv1.DailyReviewStatus{
		DayStartUnixMs: ms(day), ReminderEnabled: row.ReminderEnabled,
		ReviewedToday: row.ReviewedDay != nil && row.ReviewedDay.Equal(day),
	}
}

func dailyReviewExposure(positions []*labv1.PaperPosition) ([]*labv1.DailyReviewExposure, error) {
	values := make(map[string]int64)
	var total int64
	for _, position := range positions {
		value, present, err := usdtIn(position.GetMarketValue().GetValue(), "paper mark")
		if err != nil || !present {
			return nil, err // A partial portfolio would inflate all other shares.
		}
		symbol := position.GetSymbol()
		values[symbol], err = money.AddInt64(values[symbol], value.V)
		if err != nil {
			return nil, err
		}
		total, err = money.AddInt64(total, value.V)
		if err != nil {
			return nil, err
		}
	}
	if total <= 0 {
		return nil, nil
	}
	symbols := make([]string, 0, len(values))
	for symbol := range values {
		symbols = append(symbols, symbol)
	}
	slices.SortFunc(symbols, func(a, b string) int {
		if byValue := cmp.Compare(values[b], values[a]); byValue != 0 {
			return byValue
		}
		return cmp.Compare(a, b)
	})
	result := make([]*labv1.DailyReviewExposure, 0, len(symbols))
	for _, symbol := range symbols {
		value := values[symbol]
		share, err := money.MulDiv(value, int64(money.RatioOne), total, money.HalfEven)
		if err != nil {
			return nil, err
		}
		result = append(result, &labv1.DailyReviewExposure{Symbol: symbol, MarketValue: usdtP(value), ShareOfOpenValue: ratioP(money.Ratio(share))})
	}
	return result, nil
}
