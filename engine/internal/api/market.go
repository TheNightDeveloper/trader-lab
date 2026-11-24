package api

import (
	"context"
	"errors"
	"log/slog"
	"slices"
	"time"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

type Market struct {
	Store   *store.Store
	Clock   clock.Clock
	Live    LiveSource
	Symbols []string // same configuration as public candle ingestion
}

func (m *Market) GetMarketSnapshot(ctx context.Context, _ *connect.Request[labv1.GetMarketSnapshotRequest]) (*connect.Response[labv1.GetMarketSnapshotResponse], error) {
	now := m.Clock.Now()
	response := &labv1.GetMarketSnapshotResponse{ObservedAtUnixMs: now.UnixMilli()}
	specs := instrument.Defaults()
	var symbols []string
	for _, spec := range specs {
		if spec.Quote == instrument.USDT && slices.Contains(m.Symbols, spec.Symbol) {
			symbols = append(symbols, spec.Symbol)
		}
	}
	if len(symbols) == 0 {
		return connect.NewResponse(response), nil
	}
	candles, err := m.Store.LatestMarketCandles(ctx, db.LatestMarketCandlesParams{Symbols: symbols, AsOf: now})
	if err != nil {
		if ctx.Err() != nil {
			return nil, ctx.Err()
		}
		slog.ErrorContext(ctx, "market snapshot query failed", "err", err)
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("دریافت دادهٔ دیدبان بازار ممکن نیست"))
	}
	bySymbol := make(map[string]db.LatestMarketCandlesRow, len(candles))
	for _, candle := range candles {
		bySymbol[candle.Symbol] = candle
	}
	feeds := make(map[string]data.LiveSymbolStatus, len(symbols))
	if m.Live != nil {
		for _, feed := range m.Live.Status().Symbols {
			feeds[feed.Symbol] = feed
		}
	}
	for _, spec := range specs {
		if !slices.Contains(symbols, spec.Symbol) {
			continue
		}
		watch := &labv1.MarketWatch{Instrument: spotKey(spec), State: labv1.LiveState_LIVE_STATE_OFF}
		candle, known := bySymbol[spec.Symbol]
		if known {
			watch.Candle = &labv1.MarketCandle{
				OpenedAtUnixMs: candle.OpenTime.UnixMilli(), ClosedAtUnixMs: candle.CloseTime.UnixMilli(),
				AvailableAtUnixMs: candle.AvailableAt.UnixMilli(), Revision: candle.Revision, Close: usdtP(candle.C),
			}
		}
		if m.Live != nil {
			watch.State = marketFeedState(feeds[spec.Symbol], candle.CloseTime)
		}
		response.MarketWatch = append(response.MarketWatch, watch)
	}
	return connect.NewResponse(response), nil
}

func marketFeedState(feed data.LiveSymbolStatus, closeTime time.Time) labv1.LiveState {
	// A fresh heartbeat can race the SQL read. Only mark its matching candle fresh.
	if feed.Symbol == "" || (feed.State == data.LiveFresh && !feed.LastClose.Equal(closeTime)) || closeTime.IsZero() {
		return labv1.LiveState_LIVE_STATE_RECONNECTING
	}
	return liveStates[feed.State]
}
