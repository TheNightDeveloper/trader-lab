package data

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"tradinglab/engine/internal/store/db"
)

// Hourly output cannot conceal the cost of the underlying minute candles.
func TestOversizedRangeStopsBeforeRead(t *testing.T) {
	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	to := from.Add(1_000_001 * time.Minute)
	require.NotPanics(t, func() {
		_, err := (Reader{}).Bars(context.Background(), Query{Symbol: "BTCUSDT", Timeframe: TF1h, From: from, To: to, AsOf: to})
		require.Error(t, err)
	})
	require.NotPanics(t, func() {
		_, _, err := CreateDataset(context.Background(), nil, DatasetSpec{Symbol: "BTCUSDT", Timeframe: TF1h, From: from, To: to, GapPolicy: GapFFill})
		require.Error(t, err)
	})
}

func TestRawBarCountBoundaries(t *testing.T) {
	start := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	n, err := RawBarCount(TF1m, start, start.Add(MaxRawBars*time.Minute))
	require.NoError(t, err)
	require.Equal(t, MaxRawBars, n)
	_, err = RawBarCount(TF1m, start, start.Add(MaxRawBars*time.Minute+time.Nanosecond))
	require.ErrorIs(t, err, ErrLimit)
	n, err = RawBarCount(TF1h, start.Add(59*time.Minute), start.Add(time.Hour+time.Second))
	require.NoError(t, err)
	require.Equal(t, 61, n, "include the leading partial bucket and round up the raw minute")
	_, err = RawBarCount(TF1d, start, start.AddDate(1000, 0, 0))
	require.ErrorIs(t, err, ErrLimit, "duration saturation cannot bypass the cap")
	for _, to := range []time.Time{start, start.Add(-time.Second)} {
		_, err = RawBarCount(TF1m, start, to)
		require.Error(t, err)
	}
	_, err = RawBarCount("bad", start, start.Add(time.Hour))
	require.ErrorIs(t, err, ErrTimeframe)
}

// All three generated readers must stop rows at the database boundary.
func TestRawSQLReadersHonorLimit(t *testing.T) {
	st := openSeeded(t)
	ctx := context.Background()
	bs := series(8)
	_, err := UpsertBars(ctx, st, "BTCUSDT", "archive", "limit", bs)
	require.NoError(t, err)
	from, to := bs[0].OpenTime, bs[len(bs)-1].CloseTime
	live, err := st.CandlesAsOf(ctx, db.CandlesAsOfParams{Symbol: "BTCUSDT", FromTime: from, ToTime: to, AsOf: farFuture, KnownAt: farFuture, RowLimit: 2})
	require.NoError(t, err)
	require.Len(t, live, 2)
	snap, err := st.SnapshotCandles(ctx, db.SnapshotCandlesParams{Symbol: "BTCUSDT", FromTime: from, ToTime: to, RowLimit: 2})
	require.NoError(t, err)
	require.Len(t, snap, 2)
	ds, all, err := CreateDataset(ctx, st, DatasetSpec{"BTCUSDT", TF1m, from, to, GapFlag})
	require.NoError(t, err)
	require.Len(t, all, 8, "normal reads are complete")
	pinned, err := st.DatasetCandles(ctx, db.DatasetCandlesParams{DatasetID: ds.ID, Symbol: "BTCUSDT", RowLimit: 2})
	require.NoError(t, err)
	require.Len(t, pinned, 2)
}
