package report

import (
	"context"
	"runtime"
	"time"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/jobs"
)

// ReserveWork uses immutable range metadata before any dataset reconstruction.
// The owner keeps the reservation until evaluation, persistence or response projection ends.
func (s Service) ReserveWork(ctx context.Context, ids []string, parallel int) (func(), error) {
	raw, bars, err := s.inputCounts(ctx, ids)
	if err != nil {
		return nil, err
	}
	return s.reserve(ctx, raw, bars, parallel)
}

// ReserveChart counts reconstruction for the entire input and output only for
// visible bars. The chart never allocates simulator runs for the full history.
func (s Service) ReserveChart(ctx context.Context, ids []string, visible int) (func(), error) {
	raw, bars, err := s.inputCounts(ctx, ids)
	if err != nil {
		return nil, err
	}
	return s.reserve(ctx, raw, min(bars, int64(visible)), 1)
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

func (s Service) reserve(ctx context.Context, raw, bars int64, parallel int) (func(), error) {
	n, err := jobs.WorkBytes(raw, bars, int64(max(1, parallel)))
	if err != nil {
		return nil, err
	}
	return s.Memory.Reserve(ctx, n)
}

func (s Service) parallelism() int {
	if s.Parallel > 0 {
		return s.Parallel
	}
	return runtime.NumCPU()
}
