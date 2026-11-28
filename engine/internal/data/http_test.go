package data

import (
	"context"
	"fmt"
	"net/http"
	"net/http/httptest"
	"sync/atomic"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func TestMarketRequestsRetryTransientFailuresOnly(t *testing.T) {
	var calls atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		n := calls.Add(1)
		switch {
		case r.URL.Path == "/missing":
			w.WriteHeader(http.StatusNotFound)
		case r.URL.Path == "/invalid":
			w.WriteHeader(http.StatusBadRequest)
		case n < 3:
			w.WriteHeader(http.StatusServiceUnavailable)
		default:
			_, _ = fmt.Fprint(w, "closed klines")
		}
	}))
	defer srv.Close()
	p := newRequestPolicy(time.Second, time.Millisecond, 3)
	body, err := p.get(context.Background(), srv.Client(), srv.URL, 100)
	require.NoError(t, err)
	require.Equal(t, "closed klines", string(body))
	require.EqualValues(t, 3, calls.Load())
	_, err = p.get(context.Background(), srv.Client(), srv.URL+"/missing", 100)
	require.ErrorIs(t, err, ErrNotPublished)
	_, err = p.get(context.Background(), srv.Client(), srv.URL+"/invalid", 100)
	require.ErrorContains(t, err, "status 400")
	require.EqualValues(t, 5, calls.Load(), "permanent statuses must not retry")
}

func TestMarketRequestTimeoutIncludesStalledResponseBody(t *testing.T) {
	var calls atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls.Add(1)
		_, _ = fmt.Fprint(w, "partial body")
		if err := http.NewResponseController(w).Flush(); err != nil {
			return
		}
		<-r.Context().Done()
	}))
	defer srv.Close()
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	p := newRequestPolicy(100*time.Millisecond, time.Millisecond, 3)
	body, err := p.get(ctx, srv.Client(), srv.URL, 100)
	require.ErrorIs(t, err, context.DeadlineExceeded)
	require.NoError(t, ctx.Err(), "individual requests must time out independently of the caller")
	require.Nil(t, body)
	require.EqualValues(t, 3, calls.Load())
}

func TestMarketRateAndCooldownAreSharedAcrossRequests(t *testing.T) {
	var calls atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls.Add(1)
		if r.URL.Path == "/limited" {
			w.Header().Set("Retry-After", "90")
			w.WriteHeader(http.StatusTooManyRequests)
		}
	}))
	defer srv.Close()
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	rate := newRequestPolicy(time.Second, time.Hour, 1)
	_, err := rate.get(ctx, srv.Client(), srv.URL, 100)
	require.NoError(t, err)
	_, err = rate.get(ctx, srv.Client(), srv.URL, 100)
	require.Error(t, err)
	require.EqualValues(t, 1, calls.Load(), "a rate-limited call must not hit the network")
	limited := newRequestPolicy(time.Second, time.Millisecond, 3)
	_, err = limited.get(ctx, srv.Client(), srv.URL+"/limited", 100)
	require.ErrorContains(t, err, "status 429")
	require.Greater(t, time.Until(limited.until), 80*time.Second)
	_, err = limited.get(ctx, srv.Client(), srv.URL+"/other-symbol", 100)
	require.ErrorContains(t, err, "throttled until")
	require.EqualValues(t, 2, calls.Load(), "cooldown applies across symbols of the same provider")
}
