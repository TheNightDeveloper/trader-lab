package data

import (
	"errors"
	"fmt"
	"time"
)

// MaxRawBars bounds materialized minute inputs, including inputs to larger timeframes.
const MaxRawBars = 1_000_000

var ErrLimit = errors.New("data: درخواست از سقف منابع مجاز بیشتر است؛ بازه را کوتاه‌تر کنید")

// RawBarCount is a conservative preflight, including a partially requested bucket.
// Bounding the range also bounds synthetic gap filling before any allocation.
func RawBarCount(tf Timeframe, from, to time.Time) (int, error) {
	if _, err := ParseTimeframe(string(tf)); err != nil {
		return 0, err
	}
	if !from.Before(to) {
		return 0, fmt.Errorf("data: range end must follow start")
	}
	span := to.Sub(from.Truncate(tf.Duration()))
	n := span / time.Minute
	if span%time.Minute != 0 {
		n++
	}
	if n > MaxRawBars {
		return 0, fmt.Errorf("%w: حداکثر %d کندل خام یک‌دقیقه‌ای؛ بازه را کوتاه‌تر کنید", ErrLimit, MaxRawBars)
	}
	return int(n), nil
}
