// Package data imports, checks, versions and serves market bars. Every bar carries
// AvailableAt; readers only ever see bars with AvailableAt <= their as-of time.
package data

import (
	"errors"
	"fmt"
	"time"

	"tradinglab/engine/internal/money"
)

var ErrTimeframe = errors.New("data: unknown timeframe")

// Bar is one closed candle. CloseTime is exclusive: OpenTime + timeframe.
type Bar struct {
	Instrument  string
	OpenTime    time.Time
	CloseTime   time.Time
	AvailableAt time.Time // when the engine could first have seen the closed bar
	O, H, L, C  money.Price
	Volume      money.Qty
	Flags       Flags
}

type Flags uint8

const (
	FlagFilled  Flags = 1 << iota // synthetic bar from the forward-fill gap policy
	FlagPartial                   // resampled bar with missing 1m members
)

type Timeframe string

const (
	TF1m  Timeframe = "1m"
	TF15m Timeframe = "15m"
	TF1h  Timeframe = "1h"
	TF4h  Timeframe = "4h"
	TF1d  Timeframe = "1d"
)

var timeframes = map[Timeframe]time.Duration{
	TF1m: time.Minute, TF15m: 15 * time.Minute, TF1h: time.Hour, TF4h: 4 * time.Hour, TF1d: 24 * time.Hour,
}

func ParseTimeframe(s string) (Timeframe, error) {
	tf := Timeframe(s)
	if _, ok := timeframes[tf]; !ok {
		return "", fmt.Errorf("%w: %q", ErrTimeframe, s)
	}
	return tf, nil
}

// Duration of one bar. Panics on an unknown timeframe: parse first.
func (tf Timeframe) Duration() time.Duration {
	d, ok := timeframes[tf]
	if !ok {
		panic(fmt.Sprintf("data: unknown timeframe %q", tf))
	}
	return d
}
