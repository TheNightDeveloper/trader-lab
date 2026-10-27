package data

import (
	"fmt"
	"time"

	"tradinglab/engine/internal/money"
)

// Resample aggregates sorted, closed 1m bars into tf bars aligned to UTC
// (4h buckets start at 00, 04, ...; 1d at 00:00 UTC).
//
// Only closed buckets are emitted: a bucket whose last minute is present, or
// which a later bar proves is over. A bucket closed but missing members is
// emitted with FlagPartial. The trailing, still-open bucket is never emitted.
// A resampled bar is available when its last member is, and never before the
// bucket closes.
func Resample(bars []Bar, tf Timeframe) ([]Bar, error) {
	if tf == TF1m {
		return bars, nil
	}
	d := tf.Duration()
	var out []Bar
	for i := 0; i < len(bars); {
		start := bars[i].OpenTime.Truncate(d) // Truncate is relative to the zero time, which is UTC-aligned
		end := start.Add(d)
		b := Bar{Instrument: bars[i].Instrument, OpenTime: start, CloseTime: end, O: bars[i].O, H: bars[i].H, L: bars[i].L}
		vol := money.Amount{Asset: money.Asset{Scale: bars[i].Volume.Scale}}
		members, j := 0, i
		var last Bar
		for ; j < len(bars) && bars[j].OpenTime.Before(end); j++ {
			m := bars[j]
			if m.H.V > b.H.V {
				b.H = m.H
			}
			if m.L.V < b.L.V {
				b.L = m.L
			}
			var err error
			if vol, err = vol.Add(money.Amount{V: m.Volume.V, Asset: vol.Asset}); err != nil {
				return nil, fmt.Errorf("resample %s volume at %s: %w", tf, start.Format(time.RFC3339), err)
			}
			b.Flags |= m.Flags & FlagFilled
			last = m
			members++
		}
		complete := last.CloseTime.Equal(end)
		if !complete && j == len(bars) {
			break // still open: no later bar proves this bucket is over
		}
		if members < int(d/time.Minute) {
			b.Flags |= FlagPartial
		}
		b.C = last.C
		b.Volume = money.Qty{V: vol.V, Scale: vol.Asset.Scale}
		delay := last.AvailableAt.Sub(last.CloseTime)
		b.AvailableAt = maxTime(last.AvailableAt, end.Add(delay))
		out = append(out, b)
		i = j
	}
	return out, nil
}

func maxTime(a, b time.Time) time.Time {
	if a.After(b) {
		return a
	}
	return b
}
