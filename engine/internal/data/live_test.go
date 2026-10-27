package data

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strconv"
	"sync/atomic"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
)

// klineServer serves /api/v3/klines from bars (including the still-open one),
// honoring startTime and limit like Binance. down makes it fail.
func klineServer(t *testing.T, bars []Bar, down *atomic.Bool) *httptest.Server {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if down.Load() {
			http.Error(w, "unavailable", http.StatusServiceUnavailable)
			return
		}
		start, _ := strconv.ParseInt(r.URL.Query().Get("startTime"), 10, 64)
		limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))
		rows := [][]any{}
		for _, b := range bars {
			if b.OpenTime.UnixMilli() >= start && len(rows) < limit {
				rows = append(rows, []any{b.OpenTime.UnixMilli(), b.O.String(), b.H.String(), b.L.String(), b.C.String(), b.Volume.String(), b.CloseTime.UnixMilli() - 1, "0", 1, "0", "0", "0"})
			}
		}
		_ = json.NewEncoder(w).Encode(rows)
	}))
	t.Cleanup(srv.Close)
	return srv
}

func TestLiveCatchUpOutageAndBackfill(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	var down atomic.Bool
	srv := klineServer(t, series(3000), &down)
	clk := clock.NewVirtual(t0.Add(10*time.Minute + 5*time.Second))
	l := &Live{Store: s, HTTP: srv.Client(), BaseURL: srv.URL, Clock: clk, Delay: delay, Symbols: []string{"BTCUSDT"}, Backfill: 10 * time.Minute}
	r := Reader{Q: s.Queries}
	all := func() []Bar {
		bars, err := r.Bars(ctx, Query{Symbol: "BTCUSDT", Timeframe: TF1m, From: t0, To: t0.Add(100 * time.Hour), AsOf: farFuture})
		require.NoError(t, err)
		return bars
	}

	require.Equal(t, LiveReconnecting, l.Status().State, "no bar yet")
	require.NoError(t, l.Tick(ctx))
	got := all()
	require.Len(t, got, 10, "bars 0..9 closed; bar 10 still open is skipped")
	require.Equal(t, LiveFresh, l.Status().State)
	require.Equal(t, t0.Add(10*time.Minute), l.Status().LastClose)

	// Outage for 6 minutes.
	down.Store(true)
	require.NoError(t, clk.Set(t0.Add(13*time.Minute+5*time.Second)))
	require.Error(t, l.Tick(ctx))
	require.Equal(t, LiveReconnecting, l.Status().State)
	down.Store(false)
	require.NoError(t, clk.Set(t0.Add(16*time.Minute+5*time.Second)))
	require.NoError(t, l.Tick(ctx))

	got = all()
	require.Len(t, got, 16, "outage backfilled: no gap")
	recv := t0.Add(16*time.Minute + 5*time.Second)
	require.Equal(t, recv, got[11].AvailableAt, "backfilled bar is available when received, not at close")
	require.Equal(t, t0.Add(10*time.Minute+5*time.Second), got[9].AvailableAt, "first tick: available when received (after close + delay)")

	var outages int
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT count(*) FROM quality_issues WHERE kind = 'outage'").Scan(&outages))
	require.Equal(t, 1, outages)

	// The as-of view during the outage does not include bars that arrived after it.
	during, err := r.Bars(ctx, Query{Symbol: "BTCUSDT", Timeframe: TF1m, From: t0, To: t0.Add(time.Hour), AsOf: t0.Add(14 * time.Minute)})
	require.NoError(t, err)
	require.Len(t, during, 10)

	require.NoError(t, clk.Set(t0.Add(30*time.Minute)))
	require.Equal(t, LiveStale, l.Status().State, "no tick for 14 minutes")
}

func TestLivePagesThroughLongBackfill(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	var down atomic.Bool
	srv := klineServer(t, series(2600), &down)
	clk := clock.NewVirtual(t0.Add(2500*time.Minute + 5*time.Second))
	l := &Live{Store: s, HTTP: srv.Client(), BaseURL: srv.URL, Clock: clk, Delay: delay, Symbols: []string{"BTCUSDT"}, Backfill: 2500 * time.Minute}
	require.NoError(t, l.Tick(ctx))
	var n int
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT count(*) FROM candles").Scan(&n))
	require.Equal(t, 2500, n, "three REST pages")
}

func TestLiveOffWithoutSymbols(t *testing.T) {
	require.Equal(t, LiveOff, (&Live{}).Status().State)
}
