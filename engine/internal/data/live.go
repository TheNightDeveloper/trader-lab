package data

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"net/url"
	"strconv"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/store"
)

// LiveBaseURL is Binance's public market-data REST mirror. It serves regions where
// api.binance.com answers 451, and needs no account or key.
const LiveBaseURL = "https://data-api.binance.vision"

// restPage is Binance's max klines per request.
const restPage = 1000

type LiveState int

const (
	LiveOff LiveState = iota
	LiveFresh
	LiveStale
	LiveReconnecting
)

type LiveStatus struct {
	State     LiveState
	LastClose time.Time // oldest "latest close" across symbols
}

// Live keeps closed 1m bars current by polling the REST mirror shortly after each
// minute closes. After a failure it backfills from the last stored bar, so outages
// leave no gap; they are recorded as outage issues instead. A live bar's
// AvailableAt is when the engine actually received it, never earlier than
// close + Delay, so late (backfilled) bars are honestly late.
// ponytail: REST polling instead of WebSocket (no new dependency); switch to the
// kline stream if sub-second latency ever matters.
type Live struct {
	Store    *store.Store
	HTTP     *http.Client
	BaseURL  string
	Clock    clock.Clock
	Delay    time.Duration
	Symbols  []string
	Backfill time.Duration // how far back to start for a symbol with no stored bars

	mu        sync.Mutex
	last      map[string]time.Time // last stored open time per symbol
	failing   bool
	failSince time.Time
}

// Run ticks a few seconds after every minute until ctx ends.
func (l *Live) Run(ctx context.Context) {
	backoff := time.Second
	for {
		wait := time.Until(time.Now().Truncate(time.Minute).Add(time.Minute + 2*time.Second))
		if err := l.Tick(ctx); err != nil {
			slog.Warn("live ingest failed; retrying", "err", err, "in", backoff)
			wait, backoff = backoff, min(backoff*2, 30*time.Second)
		} else {
			backoff = time.Second
		}
		select {
		case <-ctx.Done():
			return
		case <-time.After(wait):
		}
	}
}

// Tick fetches every closed bar after the last stored one, for each symbol.
func (l *Live) Tick(ctx context.Context) error {
	now := l.Clock.Now()
	var errs []error
	for _, sym := range l.Symbols {
		if err := l.catchUp(ctx, sym, now); err != nil {
			errs = append(errs, fmt.Errorf("%s: %w", sym, err))
		}
	}
	l.mu.Lock()
	defer l.mu.Unlock()
	if len(errs) > 0 {
		if !l.failing {
			l.failing, l.failSince = true, now
		}
		return errors.Join(errs...)
	}
	if l.failing {
		l.failing = false
		for _, sym := range l.Symbols {
			issue := Issue{IssueOutage, l.failSince, now, fmt.Sprintf("live feed down %s; bars backfilled late", now.Sub(l.failSince).Round(time.Second))}
			if err := SaveIssues(ctx, l.Store.Queries, sym, []Issue{issue}); err != nil {
				return err
			}
		}
	}
	return nil
}

func (l *Live) catchUp(ctx context.Context, sym string, now time.Time) error {
	start, err := l.nextOpen(ctx, sym, now)
	if err != nil {
		return err
	}
	for {
		bars, full, err := l.fetch(ctx, sym, start, now)
		if err != nil {
			return err
		}
		if len(bars) == 0 {
			return nil
		}
		clean, issues := Clean(bars, TF1m)
		if _, err := UpsertBars(ctx, l.Store, sym, "rest", "rest", clean); err != nil {
			return err
		}
		// Gaps inside one REST page mean the exchange itself has no bar there.
		if err := SaveIssues(ctx, l.Store.Queries, sym, issues); err != nil {
			return err
		}
		lastOpen := clean[len(clean)-1].OpenTime
		l.mu.Lock()
		if l.last == nil {
			l.last = map[string]time.Time{}
		}
		l.last[sym] = lastOpen
		l.mu.Unlock()
		if !full {
			return nil
		}
		start = lastOpen.Add(time.Minute)
	}
}

func (l *Live) nextOpen(ctx context.Context, sym string, now time.Time) (time.Time, error) {
	l.mu.Lock()
	t, ok := l.last[sym]
	l.mu.Unlock()
	if ok {
		return t.Add(time.Minute), nil
	}
	last, err := l.Store.LastCandleOpen(ctx, sym)
	if errors.Is(err, pgx.ErrNoRows) {
		return now.Truncate(time.Minute).Add(-l.Backfill), nil
	}
	if err != nil {
		return time.Time{}, err
	}
	return last.UTC().Add(time.Minute), nil
}

// fetch returns closed bars from start; full reports a full page (more may follow).
func (l *Live) fetch(ctx context.Context, sym string, start, now time.Time) ([]Bar, bool, error) {
	q := url.Values{"symbol": {sym}, "interval": {"1m"}, "startTime": {strconv.FormatInt(start.UnixMilli(), 10)}, "limit": {strconv.Itoa(restPage)}}
	body, err := get(ctx, l.HTTP, l.BaseURL+"/api/v3/klines?"+q.Encode(), 4<<20)
	if err != nil {
		return nil, false, err
	}
	received := l.Clock.Now()
	dec := json.NewDecoder(bytes.NewReader(body))
	dec.UseNumber()
	var rows [][]any
	if err := dec.Decode(&rows); err != nil {
		return nil, false, fmt.Errorf("decode klines: %w", err)
	}
	bars := make([]Bar, 0, len(rows))
	rec := make([]string, 6)
	for _, row := range rows {
		if len(row) < 6 {
			return nil, false, fmt.Errorf("kline row has %d fields", len(row))
		}
		for i := range rec {
			rec[i] = fmt.Sprint(row[i])
		}
		b, err := parseKline(rec, sym, l.Delay)
		if err != nil {
			return nil, false, err
		}
		if b.CloseTime.After(now) {
			continue // still open
		}
		b.AvailableAt = maxTime(b.AvailableAt, received)
		bars = append(bars, b)
	}
	return bars, len(rows) == restPage, nil
}

// Status summarizes the feed for the sidebar.
func (l *Live) Status() LiveStatus {
	if len(l.Symbols) == 0 {
		return LiveStatus{State: LiveOff}
	}
	l.mu.Lock()
	defer l.mu.Unlock()
	var oldest time.Time
	for _, sym := range l.Symbols {
		t, ok := l.last[sym]
		if !ok {
			return LiveStatus{State: LiveReconnecting}
		}
		if oldest.IsZero() || t.Before(oldest) {
			oldest = t
		}
	}
	st := LiveStatus{State: LiveFresh, LastClose: oldest.Add(time.Minute)}
	switch {
	case l.failing:
		st.State = LiveReconnecting
	case l.Clock.Now().Sub(st.LastClose) > 2*time.Minute+l.Delay:
		st.State = LiveStale
	}
	return st
}
