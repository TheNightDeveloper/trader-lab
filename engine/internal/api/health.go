// Package api holds the Connect handlers and the domain ↔ proto mapping.
package api

import (
	"context"
	"log/slog"
	"time"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
)

// LiveSource reports the live feed; nil means no feed.
type LiveSource interface {
	Status() data.LiveStatus
}

// RateSource gives the latest USDT/TOMAN display rate; nil rate means none entered.
type RateSource interface {
	LatestDisplayRate(ctx context.Context) (*labv1.DisplayRate, error)
}

type Health struct {
	Clock   clock.Clock
	Version string
	Workers int32
	Every   time.Duration // heartbeat
	Live    LiveSource    // optional
	Rates   RateSource    // optional
}

// Watch sends the status now and then every h.every until the client goes away.
func (h *Health) Watch(ctx context.Context, _ *connect.Request[labv1.WatchRequest], s *connect.ServerStream[labv1.WatchResponse]) error {
	t := time.NewTicker(h.Every)
	defer t.Stop()
	for {
		if err := s.Send(&labv1.WatchResponse{Status: h.status(ctx)}); err != nil {
			return err
		}
		select {
		case <-ctx.Done():
			return nil
		case <-t.C:
		}
	}
}

// status is the current snapshot. The worker pool (M4) fills in busy/paused later.
func (h *Health) status(ctx context.Context) *labv1.EngineStatus {
	now := h.Clock.Now()
	st := &labv1.EngineStatus{
		Version:          h.Version,
		Mode:             labv1.RunMode_RUN_MODE_RESEARCH,
		AccountingAsset:  "USDT",
		Live:             h.liveData(now),
		Workers:          &labv1.Workers{State: labv1.WorkerState_WORKER_STATE_RUNNING, Count: h.Workers},
		ServerTimeUnixMs: now.UnixMilli(),
	}
	if h.Rates != nil {
		r, err := h.Rates.LatestDisplayRate(ctx)
		if err != nil {
			slog.Warn("health: display rate unavailable", "err", err)
		}
		st.DisplayRate = r
	}
	return st
}

func (h *Health) liveData(now time.Time) *labv1.LiveData {
	if h.Live == nil {
		return &labv1.LiveData{State: labv1.LiveState_LIVE_STATE_OFF}
	}
	st := h.Live.Status()
	d := &labv1.LiveData{State: liveStates[st.State]}
	if !st.LastClose.IsZero() {
		d.LastBarAgeSeconds = int64(max(0, now.Sub(st.LastClose)/time.Second))
	}
	return d
}

var liveStates = map[data.LiveState]labv1.LiveState{
	data.LiveOff:          labv1.LiveState_LIVE_STATE_OFF,
	data.LiveFresh:        labv1.LiveState_LIVE_STATE_FRESH,
	data.LiveStale:        labv1.LiveState_LIVE_STATE_STALE,
	data.LiveReconnecting: labv1.LiveState_LIVE_STATE_RECONNECTING,
}
