package api

import (
	"context"
	"net/http"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store/storetest"
)

func TestMarketSnapshotUsesKnownFeedRevisions(t *testing.T) {
	ctx := context.Background()
	st := storetest.Open(t)
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	wall := clock.NewVirtual(now)
	closeAt := now.Add(-time.Minute)
	bar := data.Bar{OpenTime: closeAt.Add(-time.Minute), CloseTime: closeAt, AvailableAt: closeAt.Add(time.Second)}
	insert := func(source string, b data.Bar, value int64) {
		b.C = money.Price{V: value, Scale: instrument.Scale}
		b.O, b.H, b.L = b.C, b.C, b.C
		_, err := data.UpsertBars(ctx, st, "BTCUSDT", source, source, []data.Bar{b})
		require.NoError(t, err)
	}
	insert("rest", bar, 6_700_000_000_001)
	// A correction is committed but cannot become visible before availability.
	bar.AvailableAt = now.Add(time.Second)
	insert("rest", bar, 6_700_000_000_002)
	insert("archive", data.Bar{OpenTime: closeAt, CloseTime: now, AvailableAt: now}, 6_800_000_000_000)

	m := &Market{Store: st, Clock: wall, Symbols: []string{"ETHUSDT", "BTCUSDT", "ETHBTC", "BTCUSDT", "UNKNOWN"},
		Live: fakeLive{data.LiveStatus{Symbols: []data.LiveSymbolStatus{{Symbol: "BTCUSDT", State: data.LiveFresh, LastClose: closeAt}}}},
	}
	read := func(m *Market) *labv1.GetMarketSnapshotResponse {
		srv := serve(t, func(mux *http.ServeMux) { mux.Handle(labv1connect.NewMarketServiceHandler(m)) })
		client := labv1connect.NewMarketServiceClient(srv.Client(), srv.URL)
		r, err := client.GetMarketSnapshot(ctx, connect.NewRequest(&labv1.GetMarketSnapshotRequest{}))
		require.NoError(t, err)
		return r.Msg
	}
	first := read(m)
	require.Equal(t, now.UnixMilli(), first.GetObservedAtUnixMs())
	watches := first.GetMarketWatch()
	require.Len(t, watches, 2)
	require.Equal(t, "BTCUSDT", watches[0].GetInstrument().GetSymbol())
	require.Equal(t, labv1.LiveState_LIVE_STATE_FRESH, watches[0].GetState())
	require.EqualValues(t, 1, watches[0].GetCandle().GetRevision())
	require.Equal(t, "6700000000001", watches[0].GetCandle().GetClose().GetUnits())
	require.Equal(t, closeAt.UnixMilli(), watches[0].GetCandle().GetClosedAtUnixMs())
	require.Equal(t, "ETHUSDT", watches[1].GetInstrument().GetSymbol())
	require.Equal(t, labv1.LiveState_LIVE_STATE_RECONNECTING, watches[1].GetState())
	require.Nil(t, watches[1].GetCandle())

	require.NoError(t, wall.Set(bar.AvailableAt))
	// A newly started engine can read the committed candle before its first healthy poll.
	restarted := &Market{Store: st, Clock: wall, Symbols: m.Symbols, Live: fakeLive{}}
	last := read(restarted).GetMarketWatch()[0]
	require.Equal(t, labv1.LiveState_LIVE_STATE_RECONNECTING, last.GetState())
	require.EqualValues(t, 2, last.GetCandle().GetRevision())
	require.Equal(t, "6700000000002", last.GetCandle().GetClose().GetUnits())
	require.Equal(t, bar.AvailableAt.UnixMilli(), last.GetCandle().GetAvailableAtUnixMs())
	require.Empty(t, read(&Market{Clock: wall}).GetMarketWatch())
}

func TestMarketSnapshotDoesNotReuseFreshnessForDifferentCandle(t *testing.T) {
	feed := data.LiveSymbolStatus{Symbol: "BTCUSDT", State: data.LiveFresh, LastClose: now}
	require.Equal(t, labv1.LiveState_LIVE_STATE_RECONNECTING, marketFeedState(feed, now.Add(-time.Minute)))
	feed.State = data.LiveStale
	require.Equal(t, labv1.LiveState_LIVE_STATE_STALE, marketFeedState(feed, now))
}
