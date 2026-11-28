package data

import (
	"context"
	"errors"
	"fmt"
	"io"
	"math/rand/v2"
	"net"
	"net/http"
	"strconv"
	"strings"
	"sync"
	"time"

	"golang.org/x/time/rate"
)

var (
	// The two public hosts have separate limits so imports cannot delay live polls.
	archiveRequests = newRequestPolicy(30*time.Second, 250*time.Millisecond, 2)
	liveRequests    = newRequestPolicy(5*time.Second, 200*time.Millisecond, 6)
)

type requestPolicy struct {
	timeout time.Duration
	starts  *rate.Limiter
	mu      sync.Mutex
	until   time.Time
}

func newRequestPolicy(timeout, interval time.Duration, burst int) *requestPolicy {
	return &requestPolicy{timeout: timeout, starts: rate.NewLimiter(rate.Every(interval), burst)}
}

func (p *requestPolicy) get(ctx context.Context, client *http.Client, url string, limit int64) ([]byte, error) {
	for attempt := 0; ; attempt++ {
		if err := p.starts.Wait(ctx); err != nil {
			return nil, err
		}
		p.mu.Lock()
		until := p.until
		p.mu.Unlock()
		if time.Now().Before(until) {
			return nil, fmt.Errorf("market data requests throttled until %s", until.UTC().Format(time.RFC3339))
		}

		call, cancel := context.WithTimeout(ctx, p.timeout)
		body, retry, cooldown, err := readMarketResponse(call, client, url, limit)
		cancel()
		if !cooldown.IsZero() {
			p.mu.Lock()
			p.until = maxTime(p.until, cooldown)
			p.mu.Unlock()
		}
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		if !retry || attempt == 2 {
			return body, err
		}
		if err := waitFor(ctx, jitter((100*time.Millisecond)<<attempt)); err != nil {
			return nil, err
		}
	}
}

// Retry transport failures and transient statuses. Provider throttling defers
// all new requests to that host until its cooldown instead of retrying in place.
func readMarketResponse(ctx context.Context, c *http.Client, url string, limit int64) ([]byte, bool, time.Time, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, false, time.Time{}, err
	}
	resp, err := c.Do(req)
	if err != nil {
		return nil, transientNetwork(err), time.Time{}, fmt.Errorf("get %s: %w", url, err)
	}
	defer func() { _ = resp.Body.Close() }()
	switch resp.StatusCode {
	case http.StatusOK:
	case http.StatusNotFound:
		return nil, false, time.Time{}, fmt.Errorf("%w: %s", ErrNotPublished, url)
	case http.StatusTooManyRequests, http.StatusTeapot:
		return nil, false, retryAfter(resp.Header.Get("Retry-After"), time.Now()), fmt.Errorf("get %s: status %d", url, resp.StatusCode)
	default:
		retry := resp.StatusCode == http.StatusRequestTimeout || resp.StatusCode >= 500 && resp.StatusCode <= 599
		return nil, retry, time.Time{}, fmt.Errorf("get %s: status %d", url, resp.StatusCode)
	}
	if resp.ContentLength > limit {
		return nil, false, time.Time{}, fmt.Errorf("%w: get %s: larger than %d bytes", ErrLimit, url, limit)
	}
	body, err := io.ReadAll(io.LimitReader(resp.Body, limit+1))
	if err != nil {
		return nil, transientNetwork(err), time.Time{}, fmt.Errorf("read %s: %w", url, err)
	}
	if int64(len(body)) > limit {
		return nil, false, time.Time{}, fmt.Errorf("%w: get %s: larger than %d bytes", ErrLimit, url, limit)
	}
	return body, false, time.Time{}, nil
}

func transientNetwork(err error) bool {
	var op *net.OpError
	var dns *net.DNSError
	if errors.As(err, &dns) {
		return !dns.IsNotFound
	}
	return errors.Is(err, context.DeadlineExceeded) || errors.Is(err, io.EOF) ||
		errors.Is(err, io.ErrUnexpectedEOF) || errors.As(err, &op)
}

func retryAfter(value string, now time.Time) time.Time {
	if seconds, err := strconv.ParseInt(strings.TrimSpace(value), 10, 64); err == nil && seconds >= 0 {
		if seconds > int64((1<<63-1)/time.Second) {
			return now.Add(1<<63 - 1)
		}
		return now.Add(max(time.Second, time.Duration(seconds)*time.Second))
	}
	if until, err := http.ParseTime(value); err == nil {
		return maxTime(now.Add(time.Second), until)
	}
	return now.Add(30 * time.Second)
}

func jitter(base time.Duration) time.Duration {
	return base + rand.N(base/2)
}

func waitFor(ctx context.Context, d time.Duration) error {
	t := time.NewTimer(d)
	defer t.Stop()
	select {
	case <-ctx.Done():
		return ctx.Err()
	case <-t.C:
		return nil
	}
}
