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
	if len(ids) == 0 || len(ids) > len(Specs()) {
		return nil, ErrInput
	}
	raw, bars := int64(0), int64(0)
	for _, id := range ids {
		ds, err := s.Store.GetDataset(ctx, id)
		if err != nil {
			return nil, err
		}
		tf := data.Timeframe(ds.Timeframe)
		n, err := data.RawBarCount(tf, ds.RangeFrom, ds.RangeTo)
		if err != nil {
			return nil, err
		}
		raw += int64(n)
		if raw > data.MaxRawBars {
			return nil, data.ErrLimit
		}
		minutes := int64(tf.Duration() / time.Minute)
		bars += (int64(n) + minutes - 1) / minutes
	}
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
