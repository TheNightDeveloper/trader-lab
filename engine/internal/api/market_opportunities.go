package api

import (
	"context"
	"crypto/sha256"
	"encoding/json"
	"errors"
	"fmt"
	"slices"
	"strconv"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/store/db"
)

const opportunityTF = data.TF1h

func (m *Market) ScanMarketOpportunity(ctx context.Context, req *connect.Request[labv1.ScanMarketOpportunityRequest]) (*connect.Response[labv1.ScanMarketOpportunityResponse], error) {
	symbol := req.Msg.GetSymbol()
	if !slices.Contains(m.Symbols, symbol) || instrument.ResearchError(symbol) != nil {
		return nil, invalid("نماد در دیدبان اسپات USDT فعال نیست")
	}
	version, err := getSavedRule(ctx, m.Store, req.Msg.GetRuleVersionId())
	if err != nil {
		return nil, err
	}
	def, err := decodeSavedRule(version)
	if err != nil {
		return nil, err
	}
	if def.BaseTimeframe != "" && def.BaseTimeframe != opportunityTF {
		return nil, invalid("بازهٔ پایهٔ این نسخه با اسکن یک‌ساعته سازگار نیست")
	}
	reportID, err := m.Store.MarketOpportunityReport(ctx, db.MarketOpportunityReportParams{RuleID: strconv.FormatInt(version.ID, 10), Symbol: symbol})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("برای این نسخه و نماد، بک‌تست یک‌ساعته لازم است"))
	}
	if err != nil {
		return nil, err
	}
	if m.Limiter != nil {
		if err := m.Limiter.Acquire(ctx); err != nil {
			return nil, err
		}
		defer m.Limiter.Release()
	}
	now := m.Clock.Now()
	hour := opportunityTF.Duration()
	closedAt := now.Truncate(hour)
	expires := closedAt.Add(hour)
	if err := m.requireMarketFeed(ctx, symbol, now, closedAt, expires); err != nil {
		return nil, err
	}
	key := db.MarketOpportunityParams{RuleVersionID: version.ID, Symbol: symbol, CandleClosedAt: closedAt}
	row, err := m.Store.MarketOpportunity(ctx, key)
	if err == nil {
		return m.opportunityResult(row, symbol, version)
	}
	if !errors.Is(err, pgx.ErrNoRows) {
		return nil, err
	}
	// The validated rules need at most a 1000-bar rolling window and two extra
	// bars for offsets and crosses. The current incomplete hour is excluded.
	bars, err := (data.Reader{Q: m.Store.Queries}).Bars(ctx, data.Query{
		Symbol: symbol, Timeframe: opportunityTF, From: closedAt.Add(-1002 * hour), To: closedAt, AsOf: now,
	})
	if err != nil {
		return nil, err
	}
	history := completeMarketSuffix(bars, closedAt, hour)
	intent, ready, err := def.ProbeEntry(history)
	if err != nil {
		return nil, err
	}
	now = m.Clock.Now()
	if err := m.requireMarketFeed(ctx, symbol, now, closedAt, expires); err != nil {
		return nil, err
	}
	if !ready {
		return connect.NewResponse(&labv1.ScanMarketOpportunityResponse{State: labv1.MarketScanState_MARKET_SCAN_STATE_INCOMPLETE_DATA}), nil
	}
	if intent.Target == 0 {
		return connect.NewResponse(&labv1.ScanMarketOpportunityResponse{State: labv1.MarketScanState_MARKET_SCAN_STATE_NO_MATCH}), nil
	}
	snapshot, err := json.Marshal(history)
	if err != nil {
		return nil, err
	}
	// Store the inputs before acknowledging the match so retries can return the same record.
	close := history[len(history)-1].C.V
	err = m.Store.InsertMarketOpportunity(ctx, db.InsertMarketOpportunityParams{
		Symbol: symbol, RuleVersionID: version.ID, ReportID: reportID, SpecRevision: marketSpecRevision(symbol),
		CandleClosedAt: closedAt, ObservedAt: now, ExpiresAt: expires, ReferenceClose: close,
		Reason: intent.Reason, Snapshot: snapshot, SnapshotSha256: fmt.Sprintf("%x", sha256.Sum256(snapshot)),
	})
	if err != nil {
		return nil, err
	}
	row, err = m.Store.MarketOpportunity(ctx, key)
	if err != nil {
		return nil, err
	}
	return m.opportunityResult(row, symbol, version)
}

func (m *Market) opportunityResult(row db.MarketOpportunityRow, symbol string, version db.StrategyRuleVersion) (*connect.Response[labv1.ScanMarketOpportunityResponse], error) {
	return connect.NewResponse(&labv1.ScanMarketOpportunityResponse{
		State: labv1.MarketScanState_MARKET_SCAN_STATE_MATCH,
		Opportunity: &labv1.MarketOpportunity{
			Id: row.ID, Symbol: symbol, RuleVersionId: version.ID, RuleTitle: version.Title,
			ReportId: row.ReportID, Reason: row.Reason, ReferenceClose: usdtP(row.ReferenceClose),
			CandleClosedAtUnixMs: ms(row.CandleClosedAt), ObservedAtUnixMs: ms(row.ObservedAt), ExpiresAtUnixMs: ms(row.ExpiresAt),
			Current: opportunityCurrent(m.feed(symbol), m.Clock.Now(), row.CandleClosedAt, row.ExpiresAt),
		},
	}), nil
}

func (m *Market) feed(symbol string) data.LiveSymbolStatus {
	if m.Live != nil {
		for _, feed := range m.Live.Status().Symbols {
			if feed.Symbol == symbol {
				return feed
			}
		}
	}
	return data.LiveSymbolStatus{}
}

func opportunityCurrent(feed data.LiveSymbolStatus, now, closed, expires time.Time) bool {
	return feed.State == data.LiveFresh && !feed.LastClose.Before(closed) && !now.Before(closed) && now.Before(expires)
}

func (m *Market) requireMarketFeed(ctx context.Context, symbol string, now, closed, expires time.Time) error {
	feed := m.feed(symbol)
	if opportunityCurrent(feed, now, closed, expires) {
		// The feed can restore its cursor from archive candles at startup. Require
		// a committed public-feed candle before treating that cursor as live evidence.
		candles, err := m.Store.LatestMarketCandles(ctx, db.LatestMarketCandlesParams{Symbols: []string{symbol}, AsOf: now})
		if err != nil {
			return err
		}
		if len(candles) == 1 && marketFeedState(feed, candles[0].CloseTime) == labv1.LiveState_LIVE_STATE_FRESH {
			return nil
		}
	}
	return connect.NewError(connect.CodeFailedPrecondition, errors.New("دادهٔ زندهٔ نماد هنوز تازه نیست؛ پس از بازیابی جریان دوباره بررسی کنید"))
}

func marketSpecRevision(symbol string) string {
	for _, spec := range instrument.Defaults() {
		if spec.Symbol == symbol {
			return spotKey(spec).GetSpecRevision()
		}
	}
	return ""
}

func completeMarketSuffix(bars []data.Bar, end time.Time, width time.Duration) []data.Bar {
	start := len(bars)
	for start > 0 {
		bar := bars[start-1]
		if !bar.CloseTime.Equal(end) || !bar.OpenTime.Equal(end.Add(-width)) || bar.Flags != 0 {
			break
		}
		start--
		end = bar.OpenTime
	}
	return bars[start:]
}
