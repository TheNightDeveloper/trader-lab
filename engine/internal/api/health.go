// Package api holds the Connect handlers and the domain ↔ proto mapping.
package api

import (
	"context"
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

type Health struct {
	clk     clock.Clock
	version string
	workers int32
	every   time.Duration
	live    LiveSource
}

func NewHealth(clk clock.Clock, version string, workers int, every time.Duration, live LiveSource) *Health {
	return &Health{clk: clk, version: version, workers: int32(workers), every: every, live: live}
}

// Watch sends the status now and then every h.every until the client goes away.
func (h *Health) Watch(ctx context.Context, _ *connect.Request[labv1.WatchRequest], s *connect.ServerStream[labv1.WatchResponse]) error {
	t := time.NewTicker(h.every)
	defer t.Stop()
	for {
		if err := s.Send(&labv1.WatchResponse{Status: h.status()}); err != nil {
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
func (h *Health) status() *labv1.EngineStatus {
	now := h.clk.Now()
	return &labv1.EngineStatus{
		Version:          h.version,
		Mode:             labv1.RunMode_RUN_MODE_RESEARCH,
		AccountingAsset:  "USDT",
		Live:             h.liveData(now),
		Workers:          &labv1.Workers{State: labv1.WorkerState_WORKER_STATE_RUNNING, Count: h.workers},
		ServerTimeUnixMs: now.UnixMilli(),
	}
}

func (h *Health) liveData(now time.Time) *labv1.LiveData {
	if h.live == nil {
		return &labv1.LiveData{State: labv1.LiveState_LIVE_STATE_OFF}
	}
	st := h.live.Status()
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
