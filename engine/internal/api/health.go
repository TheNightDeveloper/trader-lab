// Package api holds the Connect handlers and the domain ↔ proto mapping.
package api

import (
	"context"
	"time"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/clock"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
)

type Health struct {
	clk     clock.Clock
	version string
	workers int32
	every   time.Duration
}

func NewHealth(clk clock.Clock, version string, workers int, every time.Duration) *Health {
	return &Health{clk: clk, version: version, workers: int32(workers), every: every}
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

// status is the M0 snapshot. Live data (M1), worker pool (M4) and FX rate (M1) fill in
// their fields when they exist.
func (h *Health) status() *labv1.EngineStatus {
	return &labv1.EngineStatus{
		Version:          h.version,
		Mode:             labv1.RunMode_RUN_MODE_RESEARCH,
		AccountingAsset:  "USDT",
		Live:             &labv1.LiveData{State: labv1.LiveState_LIVE_STATE_OFF},
		Workers:          &labv1.Workers{State: labv1.WorkerState_WORKER_STATE_RUNNING, Count: h.workers},
		ServerTimeUnixMs: h.clk.Now().UnixMilli(),
	}
}
