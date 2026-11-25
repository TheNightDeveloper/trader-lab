package api

import (
	"context"
	"encoding/json"
	"fmt"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/store/db"
)

func (p *Paper) GetPaperPlanContext(ctx context.Context, req *connect.Request[labv1.GetPaperPlanContextRequest]) (*connect.Response[labv1.GetPaperPlanContextResponse], error) {
	q := p.Market.Store.Queries
	plan, err := readPaperPlan(ctx, q, req.Msg.GetPlanHash())
	if err != nil {
		return nil, err
	}
	record, bars, err := readPaperMarketInput(ctx, q, plan)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.GetPaperPlanContextResponse{MarketContext: paperMarketContextP(record, bars)}), nil
}

// Chart and replay share the exact causal input from the opportunity bound to the plan.
func readPaperMarketInput(ctx context.Context, q *db.Queries, plan *labv1.PaperPlan) (db.MarketOpportunity, []data.Bar, error) {
	record, err := q.PaperReplayOpportunity(ctx, plan.GetOpportunityId())
	if err != nil {
		return record, nil, err
	}
	if paperPlanHash(record.Snapshot) != record.SnapshotSha256 || record.SnapshotSha256 != plan.GetSnapshotSha256() ||
		record.Symbol != plan.GetInstrument().GetSymbol() || record.RuleVersionID != plan.GetRuleVersionId() ||
		record.ReportID != plan.GetReportId() || record.SpecRevision != plan.GetInstrument().GetSpecRevision() {
		return record, nil, fmt.Errorf("paper opportunity %d does not match its review", record.ID)
	}
	var bars []data.Bar
	if err := json.Unmarshal(record.Snapshot, &bars); err != nil {
		return record, nil, fmt.Errorf("decode paper opportunity %d: %w", record.ID, err)
	}
	if len(bars) == 0 {
		return record, nil, fmt.Errorf("paper opportunity %d has no recorded input", record.ID)
	}
	for _, bar := range bars {
		if bar.Instrument != record.Symbol || bar.CloseTime.After(record.CandleClosedAt) || bar.AvailableAt.After(record.ObservedAt) {
			return record, nil, fmt.Errorf("paper opportunity %d contains an invalid input", record.ID)
		}
	}
	last := bars[len(bars)-1]
	if !last.CloseTime.Equal(record.CandleClosedAt) || last.C.V != record.ReferenceClose {
		return record, nil, fmt.Errorf("paper opportunity %d has a mismatched reference candle", record.ID)
	}
	return record, bars, nil
}

func paperMarketContextP(record db.MarketOpportunity, bars []data.Bar) *labv1.PaperMarketContext {
	view := &labv1.PaperMarketContext{
		CandleClosedAtUnixMs: ms(record.CandleClosedAt), ObservedAtUnixMs: ms(record.ObservedAt),
		ScannerBuildSha256: record.EngineBuildSha256,
	}
	// Keep the chart bounded while preserving the last observed hourly candle.
	for _, b := range bars[max(0, len(bars)-24):] {
		view.Candles = append(view.Candles, chartBarP(b))
	}
	return view
}
