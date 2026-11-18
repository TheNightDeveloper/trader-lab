package data

import (
	"context"
	"encoding/json"
	"fmt"
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
	srv := klineServer(t, series(4600), &down)
	clk := clock.NewVirtual(t0.Add(4500*time.Minute + 5*time.Second))
	l := &Live{Store: s, HTTP: srv.Client(), BaseURL: srv.URL, Clock: clk, Delay: delay, Symbols: []string{"BTCUSDT"}, Backfill: 4500 * time.Minute}
	require.NoError(t, l.Tick(ctx))
	var n int
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT count(*) FROM candles").Scan(&n))
	require.Equal(t, 4000, n, "a long backfill yields after four REST pages")
	require.Equal(t, LiveStale, l.Status().State, "a healthy backlog is stale, not an outage")
	require.NoError(t, l.Tick(ctx))
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT count(*) FROM candles").Scan(&n))
	require.Equal(t, 4500, n, "the next poll resumes from the committed cursor")
	require.Equal(t, LiveFresh, l.Status().State)
}

func TestLiveOffWithoutSymbols(t *testing.T) {
	require.Equal(t, LiveOff, (&Live{}).Status().State)
}

func TestLiveRunIsolatesStalledSymbol(t *testing.T) {
	s := openSeeded(t)
	started := make(chan struct{})
	var startedOnce atomic.Bool
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("symbol") == "BTCUSDT" {
			if startedOnce.CompareAndSwap(false, true) {
				close(started)
			}
			<-r.Context().Done()
			return
		}
		// A valid closed candle for the other symbol should reach the DB while BTC is stuck.
		_, _ = fmt.Fprintf(w, `[[%d,"1","2","1","2","1"]]`, t0.UnixMilli())
	}))
	defer srv.Close()
	l := &Live{Store: s, HTTP: srv.Client(), BaseURL: srv.URL, Clock: clock.NewVirtual(t0.Add(time.Minute + delay)),
		Symbols: []string{"BTCUSDT", "ETHUSDT"}, Backfill: time.Minute, requests: newRequestPolicy(10*time.Second, time.Millisecond, 2)}
	ctx, stop := context.WithTimeout(context.Background(), 8*time.Second)
	done := make(chan struct{})
	go func() { l.Run(ctx); close(done) }()
	defer func() { stop(); <-done }()
	select {
	case <-started:
	case <-ctx.Done():
		t.Fatal("the stalled request did not start")
	}
	require.Eventually(t, func() bool {
		st := l.Status()
		return len(st.Symbols) == 2 && st.Symbols[0].State == LiveReconnecting && st.Symbols[1].State == LiveFresh
	}, 4*time.Second, 15*time.Millisecond)
	last, err := s.LastCandleOpen(ctx, "ETHUSDT")
	require.NoError(t, err)
	require.True(t, last.Equal(t0))
	stop()
	select {
	case <-done:
	case <-time.After(2 * time.Second):
		t.Fatal("run kept waiting for a stalled symbol after shutdown")
	}
}

func TestLiveOutageRecoveryDoesNotMarkHealthySymbol(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	var down atomic.Bool
	fixture := klineServer(t, series(12), new(atomic.Bool))
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if down.Load() && r.URL.Query().Get("symbol") == "BTCUSDT" {
			w.WriteHeader(http.StatusServiceUnavailable)
			return
		}
		fixture.Config.Handler.ServeHTTP(w, r)
	}))
	defer srv.Close()
	clk := clock.NewVirtual(t0.Add(4*time.Minute + delay))
	l := &Live{Store: s, HTTP: srv.Client(), BaseURL: srv.URL, Clock: clk,
		Symbols: []string{"BTCUSDT", "ETHUSDT"}, Backfill: 4 * time.Minute, requests: newRequestPolicy(time.Second, time.Millisecond, 4)}
	require.NoError(t, l.Tick(ctx))
	down.Store(true)
	require.NoError(t, clk.Set(t0.Add(5*time.Minute+delay)))
	require.ErrorContains(t, l.Tick(ctx), "BTCUSDT")
	require.Equal(t, LiveReconnecting, l.Status().Symbols[0].State)
	require.Equal(t, LiveFresh, l.Status().Symbols[1].State)
	down.Store(false)
	require.NoError(t, clk.Set(t0.Add(7*time.Minute+delay)))
	require.NoError(t, l.Tick(ctx))
	require.Equal(t, LiveFresh, l.Status().State)
	var symbol string
	var count int
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT min(symbol), count(*) FROM quality_issues WHERE kind = 'outage'").Scan(&symbol, &count))
	require.Equal(t, "BTCUSDT", symbol)
	require.Equal(t, 1, count)
}

func TestLiveRejectsNonAdvancingPageBeforeWriting(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		_, _ = fmt.Fprintf(w, `[[%d,"1","2","1","2","1"]]`, t0.UnixMilli())
	}))
	defer srv.Close()
	now := t0.Add(time.Hour)
	l := &Live{HTTP: srv.Client(), BaseURL: srv.URL, Clock: clock.NewVirtual(now), requests: newRequestPolicy(time.Second, time.Millisecond, 1)}
	bars, full, err := l.fetch(context.Background(), "BTCUSDT", t0.Add(time.Minute), now)
	require.ErrorContains(t, err, "requested range")
	require.Nil(t, bars)
	require.False(t, full)
}
