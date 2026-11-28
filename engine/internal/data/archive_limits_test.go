package data

import (
	"archive/zip"
	"bytes"
	"context"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
)

// A monthly 1m archive cannot contain more than 31 days of rows.
func TestArchiveRejectsExcessRowsWithoutReturningPrefix(t *testing.T) {
	row := "1704067200000,1,2,1,2,1\n"
	bars, err := ParseKlinesCSV(strings.NewReader(strings.Repeat(row, 31*1440+1)), "BTCUSDT", delay)
	require.ErrorIs(t, err, ErrLimit)
	require.Nil(t, bars)
}

func TestArchiveRejectsOversizedInflatedEntry(t *testing.T) {
	var buf bytes.Buffer
	w := zip.NewWriter(&buf)
	// No large payload is needed: the untrusted size must fail before decompression.
	_, err := w.CreateRaw(&zip.FileHeader{Name: "large.csv", Method: zip.Store, UncompressedSize64: 32<<20 + 1})
	require.NoError(t, err)
	require.NoError(t, w.Close())
	bars, err := ParseArchive(ArchiveFile{Zip: buf.Bytes()}, "BTCUSDT", delay)
	require.ErrorIs(t, err, ErrLimit)
	require.Nil(t, bars)
}

// Loading each daily file before the next fetch prevents a month's ZIPs accumulating.
func TestDailyFallbackStopsFetchingAfterFirstInvalidFile(t *testing.T) {
	day1 := "/data/spot/daily/klines/BTCUSDT/1m/BTCUSDT-1m-2024-02-01.zip"
	day2 := "/data/spot/daily/klines/BTCUSDT/1m/BTCUSDT-1m-2024-02-02.zip"
	base := archiveServer(t, map[string][]byte{
		day1: zipCSV(t, "a.csv", "1706745600000,invalid,1,1,1,1\n"),
		day2: zipCSV(t, "b.csv", "1706832000000,1,1,1,1,1\n"),
	}, false)
	var later atomic.Int32
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if strings.HasPrefix(r.URL.Path, day2) {
			later.Add(1)
		}
		base.Config.Handler.ServeHTTP(w, r)
	}))
	t.Cleanup(srv.Close)
	from := time.Date(2024, 2, 1, 0, 0, 0, 0, time.UTC)
	to := from.Add(48 * time.Hour)
	im := Importer{HTTP: srv.Client(), BaseURL: srv.URL, Clock: clock.NewVirtual(to)}
	_, err := im.Import(context.Background(), "BTCUSDT", from, to, nil)
	require.Error(t, err)
	require.Zero(t, later.Load(), "invalid first file must stop before downloading the next ZIP")
}
