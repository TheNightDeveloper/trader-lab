package api

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/store/db"
)

func (m *Market) SetMarketScanSubscription(ctx context.Context, req *connect.Request[labv1.SetMarketScanSubscriptionRequest]) (*connect.Response[labv1.SetMarketScanSubscriptionResponse], error) {
	input := req.Msg
	symbol, id := input.GetSymbol(), input.GetRuleVersionId()
	if input.Enabled == nil || id < 1 || len(symbol) == 0 || len(symbol) > 16 {
		return nil, invalid("نماد، نسخهٔ قواعد و وضعیت اسکن را مشخص کنید")
	}
	if input.GetEnabled() {
		rule, err := m.marketRule(ctx, symbol, id)
		if err != nil {
			return nil, err
		}
		changed, err := m.Store.EnableMarketScan(ctx, db.EnableMarketScanParams{Symbol: symbol, RuleVersionID: id, ReportID: rule.reportID})
		if err != nil {
			return nil, err
		}
		if changed == 0 {
			return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("برای این نماد اسکن دیگری فعال است؛ ابتدا همان اسکن را متوقف کنید"))
		}
	} else if err := m.Store.PauseMarketScan(ctx, db.PauseMarketScanParams{Symbol: symbol, RuleVersionID: id}); err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.SetMarketScanSubscriptionResponse{}), nil
}

// RunMarketScans follows the same lifecycle as the live feed and needs no open browser.
func (m *Market) RunMarketScans(ctx context.Context) {
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()
	for ctx.Err() == nil {
		cycle, cancel := context.WithTimeout(ctx, 20*time.Second)
		err := m.runMarketScanCycle(cycle)
		cancel()
		if err != nil && ctx.Err() == nil {
			slog.WarnContext(ctx, "background market scan deferred", "error", err)
		}
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
		}
	}
}

func (m *Market) runMarketScanCycle(ctx context.Context) error {
	now := m.Clock.Now()
	width := opportunityTF.Duration()
	// shortcut: observe only the latest closed hour, add historical jobs if backfill scanning is required.
	closed := now.Truncate(width)
	symbols, err := m.Store.DueMarketScans(ctx, db.DueMarketScansParams{Symbols: m.Symbols, ClosedAt: &closed})
	if err != nil {
		return err
	}
	var cycleErr error
	for _, symbol := range symbols {
		if ctx.Err() != nil {
			return errors.Join(cycleErr, ctx.Err())
		}
		if !opportunityCurrent(m.feed(symbol), m.Clock.Now(), closed, closed.Add(width)) {
			continue
		}
		if err := m.runSubscribedMarketScan(ctx, symbol, closed); err != nil && !errors.Is(err, errMarketFeed) {
			cycleErr = errors.Join(cycleErr, fmt.Errorf("%s: %w", symbol, err))
		}
	}
	return cycleErr
}

func (m *Market) runSubscribedMarketScan(ctx context.Context, symbol string, closed time.Time) error {
	if m.Limiter != nil {
		if err := m.Limiter.Acquire(ctx); err != nil {
			return err
		}
		defer m.Limiter.Release()
	}
	return m.Store.InTx(ctx, func(q *db.Queries) error {
		// Pause and the cursor update serialize on this row. A committed pause
		// therefore cannot be followed by a late write from a claimed scan.
		sub, err := q.ClaimMarketScan(ctx, db.ClaimMarketScanParams{Symbol: symbol, ClosedAt: &closed})
		if errors.Is(err, pgx.ErrNoRows) {
			return nil
		}
		if err != nil {
			return err
		}
		version, err := q.GetRuleVersion(ctx, sub.RuleVersionID)
		if err != nil {
			return err
		}
		def, err := decodeSavedRule(version)
		if err != nil {
			return err
		}
		rule := marketScanRule{version: version, def: def, reportID: sub.ReportID}
		res, err := m.scanMarketHour(ctx, q, symbol, rule, closed)
		if err != nil {
			return err
		}
		return q.RecordMarketScan(ctx, db.RecordMarketScanParams{Symbol: symbol, ClosedAt: &closed, State: int32(res.GetState())})
	})
}
