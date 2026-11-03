package jobs

import (
	"context"
	"errors"
	"fmt"
	"math"
	"sync"
	"sync/atomic"
)

var ErrMemory = errors.New("jobs: بودجهٔ حافظهٔ پژوهش کافی نیست؛ بازه یا هم‌زمانی را کاهش دهید و دوباره تلاش کنید")

// Memory accounts for conservative active-work reservations across research services.
// Cached bars have separate retention caps; this counter does not measure process RSS.
type Memory struct {
	limit int64
	used  atomic.Int64
}

func NewMemory(bytes int64) *Memory { return &Memory{limit: max(1, bytes)} }

func (m *Memory) InUse() int64 { return m.used.Load() }

// WorkBytes budgets raw reconstruction, concurrent runs and retained/serialized results.
// shortcut: these are conservative estimates, calibrate against RSS when workloads change.
func WorkBytes(raw, bars, parallel int64) (int64, error) {
	const base, rawBytes, runBytes = int64(1 << 20), int64(1024), int64(8192)
	if raw < 0 || bars < 0 || parallel < 1 || parallel > math.MaxInt64-2 || raw > (math.MaxInt64-base)/rawBytes {
		return 0, ErrMemory
	}
	n := base + raw*rawBytes
	workers := parallel + 2 // main/holdout outputs can outlive their worker slots
	if bars > (math.MaxInt64-n)/runBytes/workers {
		return 0, ErrMemory
	}
	return n + bars*runBytes*workers, nil
}

// Reserve never waits while holding CPU slots or a cycle's retained inputs.
// Failing atomically avoids a memory/CPU lock inversion between these services.
func (m *Memory) Reserve(ctx context.Context, bytes int64) (func(), error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if m == nil { // isolated services/tests may opt out; main always supplies one pool
		return func() {}, nil
	}
	if bytes <= 0 || bytes > m.limit {
		return nil, fmt.Errorf("%w: requested=%d, limit=%d bytes", ErrMemory, bytes, m.limit)
	}
	for {
		used := m.used.Load()
		if bytes > m.limit-used {
			return nil, fmt.Errorf("%w: requested=%d, available=%d bytes", ErrMemory, bytes, m.limit-used)
		}
		if m.used.CompareAndSwap(used, used+bytes) {
			var once sync.Once
			return func() { once.Do(func() { m.used.Add(-bytes) }) }, nil
		}
		if err := ctx.Err(); err != nil {
			return nil, err
		}
	}
}
