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
	"tradinglab/engine/internal/strategy"
)

const opportunityTF = data.TF1h

var errMarketFeed = errors.New("دادهٔ زندهٔ نماد هنوز تازه نیست؛ پس از بازیابی جریان دوباره بررسی کنید")

type marketScanRule struct {
	version  db.StrategyRuleVersion
	def      strategy.RuleDefinition
	reportID string
}

// marketRule checks the same evidence when a scan is performed or subscribed to.
func (m *Market) marketRule(ctx context.Context, symbol string, id int64) (marketScanRule, error) {
	var rule marketScanRule
	if !slices.Contains(m.Symbols, symbol) || instrument.ResearchError(symbol) != nil {
		return rule, invalid("نماد در دیدبان اسپات USDT فعال نیست")
	}
	version, err := getSavedRule(ctx, m.Store, id)
	if err != nil {
		return rule, err
	}
	def, err := decodeSavedRule(version)
	if err != nil {
		return rule, err
	}
	if def.BaseTimeframe != "" && def.BaseTimeframe != opportunityTF {
		return rule, invalid("بازهٔ پایهٔ این نسخه با اسکن یک‌ساعته سازگار نیست")
	}
	reportID, err := m.Store.MarketOpportunityReport(ctx, db.MarketOpportunityReportParams{RuleID: strconv.FormatInt(version.ID, 10), Symbol: symbol})
	if errors.Is(err, pgx.ErrNoRows) {
		return rule, connect.NewError(connect.CodeFailedPrecondition, errors.New("برای این نسخه و نماد، بک‌تست یک‌ساعته لازم است"))
	}
	if err != nil {
		return rule, err
	}
	return marketScanRule{version: version, def: def, reportID: reportID}, nil
}

func (m *Market) ScanMarketOpportunity(ctx context.Context, req *connect.Request[labv1.ScanMarketOpportunityRequest]) (*connect.Response[labv1.ScanMarketOpportunityResponse], error) {
	symbol := req.Msg.GetSymbol()
	rule, err := m.marketRule(ctx, symbol, req.Msg.GetRuleVersionId())
	if err != nil {
		return nil, err
	}
	if m.Limiter != nil {
		if err := m.Limiter.Acquire(ctx); err != nil {
			return nil, err
		}
		defer m.Limiter.Release()
	}
	closedAt := m.Clock.Now().Truncate(opportunityTF.Duration())
	result, err := m.scanMarketHour(ctx, m.Store.Queries, symbol, rule, closedAt)
	if errors.Is(err, errMarketFeed) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(result), nil
}

// The worker uses its transaction here so the result and scan cursor commit together.
func (m *Market) scanMarketHour(ctx context.Context, q *db.Queries, symbol string, rule marketScanRule, closedAt time.Time) (*labv1.ScanMarketOpportunityResponse, error) {
	now := m.Clock.Now()
	hour := opportunityTF.Duration()
	expires := closedAt.Add(hour)
	if err := m.requireMarketFeed(ctx, q, symbol, now, closedAt, expires); err != nil {
		return nil, err
	}
	key := db.MarketOpportunityParams{RuleVersionID: rule.version.ID, Symbol: symbol, CandleClosedAt: closedAt}
	row, err := q.MarketOpportunity(ctx, key)
	if err == nil {
		return m.opportunityResult(row, symbol, rule.version), nil
	}
	if !errors.Is(err, pgx.ErrNoRows) {
		return nil, err
	}
	window, probe, err := rule.def.CompileEntryProbe()
	if err != nil {
		return nil, err
	}
	// Retain enough evidence for both the rule and the historical review chart.
	bars, err := (data.Reader{Q: q}).Bars(ctx, data.Query{
		Symbol: symbol, Timeframe: opportunityTF, From: closedAt.Add(-time.Duration(max(window, 24)) * hour), To: closedAt, AsOf: now,
	})
	if err != nil {
		return nil, err
	}
	history := completeMarketSuffix(bars, closedAt, hour)
	intent, ready := probe(history)
	now = m.Clock.Now()
	if err := m.requireMarketFeed(ctx, q, symbol, now, closedAt, expires); err != nil {
		return nil, err
	}
	if !ready {
		return &labv1.ScanMarketOpportunityResponse{State: labv1.MarketScanState_MARKET_SCAN_STATE_INCOMPLETE_DATA}, nil
	}
	if intent.Target == 0 {
		return &labv1.ScanMarketOpportunityResponse{State: labv1.MarketScanState_MARKET_SCAN_STATE_NO_MATCH}, nil
	}
	snapshot, err := json.Marshal(history)
	if err != nil {
		return nil, err
	}
	// Store the inputs before acknowledging the match so retries can return the same record.
	close := history[len(history)-1].C.V
	err = q.InsertMarketOpportunity(ctx, db.InsertMarketOpportunityParams{
		Symbol: symbol, RuleVersionID: rule.version.ID, ReportID: rule.reportID, SpecRevision: marketSpecRevision(symbol),
		CandleClosedAt: closedAt, ObservedAt: now, ExpiresAt: expires, ReferenceClose: close,
		Reason: intent.Reason, Snapshot: snapshot, SnapshotSha256: fmt.Sprintf("%x", sha256.Sum256(snapshot)), EngineBuildSha256: m.Build,
	})
	if err != nil {
		return nil, err
	}
	row, err = q.MarketOpportunity(ctx, key)
	if err != nil {
		return nil, err
	}
	return m.opportunityResult(row, symbol, rule.version), nil
}

func (m *Market) opportunityResult(row db.MarketOpportunityRow, symbol string, version db.StrategyRuleVersion) *labv1.ScanMarketOpportunityResponse {
	return &labv1.ScanMarketOpportunityResponse{
		State: labv1.MarketScanState_MARKET_SCAN_STATE_MATCH,
		Opportunity: &labv1.MarketOpportunity{
			Id: row.ID, Symbol: symbol, RuleVersionId: version.ID, RuleTitle: version.Title,
			ReportId: row.ReportID, Reason: row.Reason, ReferenceClose: usdtP(row.ReferenceClose),
			CandleClosedAtUnixMs: ms(row.CandleClosedAt), ObservedAtUnixMs: ms(row.ObservedAt), ExpiresAtUnixMs: ms(row.ExpiresAt),
			Current: opportunityCurrent(m.feed(symbol), m.Clock.Now(), row.CandleClosedAt, row.ExpiresAt),
		},
	}
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

func (m *Market) requireMarketFeed(ctx context.Context, q *db.Queries, symbol string, now, closed, expires time.Time) error {
	feed := m.feed(symbol)
	if opportunityCurrent(feed, now, closed, expires) {
		// The feed can restore its cursor from archive candles at startup. Require
		// a committed public-feed candle before treating that cursor as live evidence.
		candles, err := q.LatestMarketCandles(ctx, db.LatestMarketCandlesParams{Symbols: []string{symbol}, AsOf: now})
		if err != nil {
			return err
		}
		if len(candles) == 1 && marketFeedState(feed, candles[0].CloseTime) == labv1.LiveState_LIVE_STATE_FRESH {
			return nil
		}
	}
	return errMarketFeed
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
