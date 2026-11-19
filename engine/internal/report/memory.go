package report

import (
	"context"
	"errors"
	"runtime"
	"time"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/jobs"
)

// admitEvaluation reduces concurrency before rejecting a report that can fit with fewer workers.
// The caller still owns the reservation through persistence or canonical comparison.
func (s Service) admitEvaluation(ctx context.Context, ids []string) (Service, func(), error) {
	raw, bars, err := s.inputCounts(ctx, ids)
	if err != nil {
		return s, nil, err
	}
	for workers := s.parallelism(); ; workers-- {
		bytes, err := jobs.EvaluationBytes(raw, bars, int64(workers))
		if err != nil {
			return s, nil, err
		}
		if release, err := s.Memory.Reserve(ctx, bytes); err == nil {
			s.Parallel = workers
			return s, release, nil
		} else if workers == 1 || !errors.Is(err, jobs.ErrMemory) {
			return s, nil, err
		}
	}
}

// ReserveSimulation uses immutable range metadata before reconstructing a single run.
func (s Service) ReserveSimulation(ctx context.Context, ids []string) (func(), error) {
	raw, bars, err := s.inputCounts(ctx, ids)
	if err != nil {
		return nil, err
	}
	bytes, err := jobs.SimulationBytes(raw, bars)
	if err != nil {
		return nil, err
	}
	return s.Memory.Reserve(ctx, bytes)
}

// ChartBars admits the visible response and either pins verified input arrays or
// reserves reconstruction for a cache miss. The caller releases after projection.
func (s Service) ChartBars(ctx context.Context, ids []string, visible int) (map[string][]data.Bar, data.Timeframe, func(), error) {
	raw, bars, err := s.inputCounts(ctx, ids)
	if err != nil {
		return nil, "", nil, err
	}
	pinned := s.Cache.pin(ids)
	var pinnedBytes int64
	if pinned != nil {
		raw = 0
		// The pinned arrays may outlive eviction, so charge their retained size.
		for _, ds := range pinned {
			pinnedBytes += int64(cap(ds.bars)) * 256
		}
	}
	bytes, err := jobs.WorkBytes(raw, min(bars, int64(visible)), 1)
	if err != nil {
		return nil, "", nil, err
	}
	release, err := s.Memory.Reserve(ctx, bytes+pinnedBytes)
	if err != nil {
		return nil, "", nil, err
	}
	var input map[string][]data.Bar
	var tf data.Timeframe
	if pinned != nil {
		input, tf, _, err = assembleBars(pinned)
	} else {
		input, tf, err = s.Bars(ctx, ids)
	}
	if err != nil {
		release()
		return nil, "", nil, err
	}
	return input, tf, release, nil
}

func (s Service) inputCounts(ctx context.Context, ids []string) (raw, bars int64, err error) {
	if len(ids) == 0 || len(ids) > len(Specs()) {
		return 0, 0, ErrInput
	}
	for _, id := range ids {
		ds, err := s.Store.GetDataset(ctx, id)
		if err != nil {
			return 0, 0, err
		}
		tf := data.Timeframe(ds.Timeframe)
		n, err := data.RawBarCount(tf, ds.RangeFrom, ds.RangeTo)
		if err != nil {
			return 0, 0, err
		}
		raw += int64(n)
		if raw > data.MaxRawBars {
			return 0, 0, data.ErrLimit
		}
		minutes := int64(tf.Duration() / time.Minute)
		bars += (int64(n) + minutes - 1) / minutes
	}
	return raw, bars, nil
}

func (s Service) parallelism() int {
	if s.Parallel > 0 {
		return s.Parallel
	}
	return runtime.NumCPU()
}
