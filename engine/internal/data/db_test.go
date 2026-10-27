package data

import (
	"context"
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"pgregory.net/rapid"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/storetest"
)

func openSeeded(t *testing.T) *store.Store {
	s := storetest.Open(t)
	require.NoError(t, SeedInstruments(context.Background(), s.Queries))
	return s
}

// csvFor renders bars as Binance kline rows (ms timestamps).
func csvFor(bars []Bar) string {
	var sb strings.Builder
	for _, b := range bars {
		fmt.Fprintf(&sb, "%d,%s,%s,%s,%s,%s,%d,0,1,0,0,0\n", b.OpenTime.UnixMilli(), b.O, b.H, b.L, b.C, b.Volume, b.CloseTime.UnixMilli()-1)
	}
	return sb.String()
}

func TestImportIdempotentSameDatasetHash(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()

	// January: monthly file, 3 days, with a planted 10-minute gap.
	jan := series(3 * 1440)
	jan = append(jan[:600], jan[610:]...)
	// February: no monthly file yet; daily file for Feb 1, Feb 2 unpublished.
	feb1 := make([]Bar, 1440)
	for i := range feb1 {
		feb1[i] = mk(31*1440+i, 500, 1e8)
	}
	files := map[string][]byte{
		"/data/spot/monthly/klines/BTCUSDT/1m/BTCUSDT-1m-2024-01.zip":  zipCSV(t, "a.csv", csvFor(jan)),
		"/data/spot/daily/klines/BTCUSDT/1m/BTCUSDT-1m-2024-02-01.zip": zipCSV(t, "b.csv", csvFor(feb1)),
	}
	srv := archiveServer(t, files, false)
	now := time.Date(2024, 2, 3, 0, 0, 0, 0, time.UTC)
	im := Importer{Store: s, HTTP: srv.Client(), BaseURL: srv.URL, Delay: delay, Clock: clock.NewVirtual(now)}

	from, to := t0, time.Date(2024, 2, 3, 0, 0, 0, 0, time.UTC)
	// January has only 3 days in the file; import just those plus February.
	p, err := im.Import(ctx, "BTCUSDT", from, to, nil)
	require.NoError(t, err)
	require.Equal(t, len(jan)+len(feb1), p.Inserted)
	require.Equal(t, 1, p.Missing, "Feb 2 not published")

	spec := DatasetSpec{"BTCUSDT", TF1h, from, to, GapFlag}
	ds1, bars1, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)

	// Re-import: nothing inserted, nothing corrected, same dataset hash.
	p2, err := im.Import(ctx, "BTCUSDT", from, to, nil)
	require.NoError(t, err)
	require.Zero(t, p2.Inserted)
	require.Zero(t, p2.Corrections)
	ds2, bars2, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	require.Equal(t, ds1.ID, ds2.ID)
	require.Equal(t, ds1.KnownAt, ds2.KnownAt, "first creation wins")
	require.Equal(t, bars1, bars2)

	var rows int
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT count(*) FROM candles WHERE symbol = 'BTCUSDT'").Scan(&rows))
	require.Equal(t, len(jan)+len(feb1), rows, "no duplicates")

	// Quality issues: planted gap, rest of January missing, Feb 2 missing.
	issues, err := s.Pool.Query(ctx, "SELECT kind, at FROM quality_issues WHERE kind = 'gap' ORDER BY at")
	require.NoError(t, err)
	var gaps []time.Time
	for issues.Next() {
		var k string
		var at time.Time
		require.NoError(t, issues.Scan(&k, &at))
		gaps = append(gaps, at.UTC())
	}
	require.Contains(t, gaps, t0.Add(600*time.Minute), "planted gap detected")
	require.Contains(t, gaps, time.Date(2024, 1, 4, 0, 0, 0, 0, time.UTC), "rest of January")
	require.Contains(t, gaps, time.Date(2024, 2, 2, 0, 0, 0, 0, time.UTC), "unpublished day")
}

func TestCorrectionCreatesNewVersionOldStaysReadable(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	bars := series(120)
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "v1", bars)
	require.NoError(t, err)
	spec := DatasetSpec{"BTCUSDT", TF1m, t0, t0.Add(120 * time.Minute), GapFlag}
	v1, _, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)

	time.Sleep(10 * time.Millisecond) // ingested_at strictly after v1.KnownAt
	fixed := series(120)
	fixed[50].C.V += 1e6
	up, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "v2", fixed)
	require.NoError(t, err)
	require.Equal(t, 1, up.Inserted)
	require.Equal(t, []time.Time{t0.Add(50 * time.Minute)}, utc(up.Corrections))

	v2, bars2, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	require.NotEqual(t, v1.ID, v2.ID, "correction makes a new version")
	require.Equal(t, fixed[50].C, bars2[50].C)

	_, old, err := LoadDataset(ctx, s, v1.ID)
	require.NoError(t, err, "old version still loads and verifies")
	require.Equal(t, bars[50].C, old[50].C)
}

func utc(ts []time.Time) []time.Time {
	for i := range ts {
		ts[i] = ts[i].UTC()
	}
	return ts
}

func TestBarsNeverAfterAsOf(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	bars := series(600)
	// Irregular availability: some bars arrive late (e.g. backfilled after an outage).
	for i := range bars {
		if i%7 == 0 {
			bars[i].AvailableAt = bars[i].AvailableAt.Add(time.Duration(i%5) * time.Hour)
		}
	}
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "x", bars)
	require.NoError(t, err)
	r := Reader{Q: s.Queries}

	rapid.Check(t, func(rt *rapid.T) {
		asOf := t0.Add(time.Duration(rapid.Int64Range(-60, 900).Draw(rt, "asOfMin")) * time.Minute).
			Add(time.Duration(rapid.Int64Range(0, 59).Draw(rt, "asOfSec")) * time.Second)
		tf := rapid.SampledFrom([]Timeframe{TF1m, TF15m, TF1h}).Draw(rt, "tf")
		got, err := r.Bars(ctx, Query{Symbol: "BTCUSDT", Timeframe: tf, From: t0, To: t0.Add(10 * time.Hour), AsOf: asOf})
		require.NoError(rt, err)
		for _, b := range got {
			require.False(rt, b.AvailableAt.After(asOf), "%s bar %s available %s > as-of %s", tf, b.OpenTime, b.AvailableAt, asOf)
		}
		if tf == TF1m {
			want := 0
			for _, b := range bars {
				if !b.AvailableAt.After(asOf) {
					want++
				}
			}
			require.Len(rt, got, want, "everything available is returned")
		}
	})
}

func TestLastCloseAsOf(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "x", series(3))
	require.NoError(t, err)
	r := Reader{Q: s.Queries}
	p, err := r.LastClose(ctx, "BTCUSDT", t0.Add(2*time.Minute+delay))
	require.NoError(t, err)
	require.Equal(t, int64(101e8), p.V, "bar 1 is the last available")
	_, err = r.LastClose(ctx, "BTCUSDT", t0)
	require.ErrorIs(t, err, ErrNoBar)
}
