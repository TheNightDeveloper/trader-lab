package data

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
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

var errCatchUpPending = errors.New("live backfill has more pages")

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
	Symbols   []LiveSymbolStatus
}

// LiveSymbolStatus reports the last committed candle and recovery status for a feed.
type LiveSymbolStatus struct {
	Symbol    string
	State     LiveState
	LastClose time.Time
}

type liveProgress struct {
	lastOpen  time.Time
	failSince time.Time
}

// Live keeps closed 1m bars current by polling the REST mirror shortly after each
// minute closes. After a failure each symbol backfills from the last stored bar
// and records its own outage. A live bar's
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

	requests *requestPolicy // nil uses the shared production policy
	mu       sync.Mutex
	progress map[string]liveProgress
}

// Run gives each symbol its own poll and recovery schedule.
func (l *Live) Run(ctx context.Context) {
	var workers sync.WaitGroup
	for _, sym := range l.symbols() {
		workers.Go(func() { l.runSymbol(ctx, sym) })
	}
	workers.Wait()
}

func (l *Live) runSymbol(ctx context.Context, sym string) {
	backoff := time.Second
	for ctx.Err() == nil {
		err := l.poll(ctx, sym)
		now := time.Now()
		next := now.Truncate(time.Minute).Add(2 * time.Second)
		if !next.After(now) {
			next = next.Add(time.Minute)
		}
		wait := next.Sub(now)
		switch {
		case err == nil:
			backoff = time.Second
		case errors.Is(err, errCatchUpPending):
			wait = jitter(time.Second)
		case ctx.Err() != nil:
			return
		default:
			wait = jitter(backoff)
			slog.Warn("live ingest failed; retrying", "symbol", sym, "err", err, "in", wait)
			backoff = min(backoff*2, 30*time.Second)
		}
		if waitFor(ctx, wait) != nil {
			return
		}
	}
}

// Tick polls the configured symbols once. Use it with Run stopped.
func (l *Live) Tick(ctx context.Context) error {
	symbols := l.symbols()
	errs := make([]error, len(symbols))
	var workers sync.WaitGroup
	for i, sym := range symbols {
		workers.Go(func() {
			if err := l.poll(ctx, sym); err != nil && !errors.Is(err, errCatchUpPending) {
				errs[i] = fmt.Errorf("%s: %w", sym, err)
			}
		})
	}
	workers.Wait()
	return errors.Join(errs...)
}

func (l *Live) symbols() []string {
	seen := make(map[string]bool, len(l.Symbols))
	var symbols []string
	for _, sym := range l.Symbols {
		if !seen[sym] {
			seen[sym] = true
			symbols = append(symbols, sym)
		}
	}
	return symbols
}

func (l *Live) poll(ctx context.Context, sym string) error {
	poll, cancel := context.WithTimeout(ctx, 30*time.Second)
	defer cancel()
	now := l.Clock.Now()
	l.mu.Lock()
	state := l.progress[sym]
	l.mu.Unlock()
	err := l.catchUp(poll, sym, now, &state)
	if ctx.Err() != nil {
		return ctx.Err()
	}
	switch {
	case errors.Is(err, errCatchUpPending):
		// Progress through a healthy historical backlog is not an outage.
	case err != nil:
		if state.failSince.IsZero() {
			state.failSince = now
		}
	case !state.failSince.IsZero():
		recovered := l.Clock.Now()
		issue := Issue{IssueOutage, state.failSince, recovered, fmt.Sprintf("live feed down %s; received bars are recorded at arrival", recovered.Sub(state.failSince).Round(time.Second))}
		err = SaveIssues(poll, l.Store.Queries, sym, []Issue{issue})
		if err == nil {
			state.failSince = time.Time{}
		}
	}
	// Never hold the health lock during network or database operations.
	l.mu.Lock()
	if l.progress == nil {
		l.progress = make(map[string]liveProgress, len(l.Symbols))
	}
	l.progress[sym] = state
	l.mu.Unlock()
	return err
}

func (l *Live) catchUp(ctx context.Context, sym string, now time.Time, state *liveProgress) error {
	start, err := l.nextOpen(ctx, sym, now, state)
	if err != nil {
		return err
	}
	// Yield after a few pages so a long backfill has a bounded poll cost.
	for range 4 {
		if !start.Before(now.Truncate(time.Minute)) {
			return nil
		}
		bars, full, err := l.fetch(ctx, sym, start, now)
		if err != nil {
			return err
		}
		if len(bars) == 0 {
			return nil
		}
		clean, issues := Clean(bars, TF1m)
		if len(clean) > 0 {
			if _, err := UpsertBars(ctx, l.Store, sym, "rest", "rest", clean); err != nil {
				return err
			}
		}
		if err := SaveIssues(ctx, l.Store.Queries, sym, issues); err != nil {
			return err
		}
		if len(clean) == 0 {
			return fmt.Errorf("live %s: page has no usable closed bars", sym)
		}
		state.lastOpen = clean[len(clean)-1].OpenTime
		if !full {
			return nil
		}
		start = state.lastOpen.Add(time.Minute)
	}
	if !start.Before(now.Truncate(time.Minute)) {
		return nil
	}
	return errCatchUpPending
}

func (l *Live) nextOpen(ctx context.Context, sym string, now time.Time, state *liveProgress) (time.Time, error) {
	if !state.lastOpen.IsZero() {
		return state.lastOpen.Add(time.Minute), nil
	}
	last, err := l.Store.LastCandleOpen(ctx, sym)
	if errors.Is(err, pgx.ErrNoRows) {
		return now.Truncate(time.Minute).Add(-l.Backfill), nil
	}
	if err != nil {
		return time.Time{}, err
	}
	state.lastOpen = last.UTC()
	return state.lastOpen.Add(time.Minute), nil
}

// fetch returns closed bars from start; full reports a full page (more may follow).
func (l *Live) fetch(ctx context.Context, sym string, start, now time.Time) ([]Bar, bool, error) {
	q := url.Values{"symbol": {sym}, "interval": {"1m"}, "startTime": {strconv.FormatInt(start.UnixMilli(), 10)}, "limit": {strconv.Itoa(restPage)}}
	requests := l.requests
	if requests == nil {
		requests = liveRequests
	}
	body, err := requests.get(ctx, l.HTTP, l.BaseURL+"/api/v3/klines?"+q.Encode(), 4<<20)
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
	if dec.Decode(new(any)) != io.EOF || rows == nil || len(rows) > restPage {
		return nil, false, errors.New("invalid live kline page")
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
		if b.OpenTime.Before(start) || !b.OpenTime.Equal(b.OpenTime.Truncate(time.Minute)) {
			return nil, false, errors.New("live kline open time is outside the requested range or unaligned")
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
	now := l.Clock.Now()
	status := LiveStatus{State: LiveFresh}
	missing := false
	for _, sym := range l.symbols() {
		feed := l.symbolStatus(sym, now)
		status.Symbols = append(status.Symbols, feed)
		status.State = max(status.State, feed.State)
		missing = missing || feed.LastClose.IsZero()
		if !feed.LastClose.IsZero() && (status.LastClose.IsZero() || feed.LastClose.Before(status.LastClose)) {
			status.LastClose = feed.LastClose
		}
	}
	if missing {
		status.LastClose = time.Time{}
	}
	return status
}

func (l *Live) symbolStatus(symbol string, now time.Time) LiveSymbolStatus {
	state := l.progress[symbol]
	st := LiveSymbolStatus{Symbol: symbol, State: LiveReconnecting}
	if state.lastOpen.IsZero() {
		return st
	}
	st.State, st.LastClose = LiveFresh, state.lastOpen.Add(time.Minute)
	switch {
	case !state.failSince.IsZero():
		st.State = LiveReconnecting
	case now.Sub(st.LastClose) > 2*time.Minute+l.Delay:
		st.State = LiveStale
	}
	return st
}
