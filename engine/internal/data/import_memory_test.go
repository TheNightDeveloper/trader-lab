package data

import (
	"context"
	"io"
	"strings"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/jobs"
)

func TestImportAdmissionPrecedesNetworkAndReleasesAfterError(t *testing.T) {
	to := t0.Add(time.Hour)
	memory := jobs.NewMemory(512 << 20)
	release, err := memory.Reserve(context.Background(), 512<<20)
	require.NoError(t, err)
	im := Importer{Clock: clock.NewVirtual(to), Memory: memory}
	_, err = im.Import(context.Background(), "BTCUSDT", t0, to, nil)
	require.ErrorIs(t, err, jobs.ErrMemory, "no HTTP client or store should be touched")
	require.EqualValues(t, 512<<20, memory.InUse())
	release()
	file := "/data/spot/monthly/klines/BTCUSDT/1m/BTCUSDT-1m-2024-01.zip"
	srv := archiveServer(t, map[string][]byte{file: zipCSV(t, "a.csv", "1704067200000,invalid,1,1,1,1\n")}, false)
	im.HTTP, im.BaseURL = srv.Client(), srv.URL
	_, err = im.Import(context.Background(), "BTCUSDT", t0, to, nil)
	require.Error(t, err)
	require.NotErrorIs(t, err, jobs.ErrMemory, "the work was admitted before parsing failed")
	require.Zero(t, memory.InUse())
}

func TestCSVBoundsAndCancellation(t *testing.T) {
	for _, input := range []string{
		strings.Repeat("1", maxArchiveLineBytes+1),
		strings.Repeat("\n", maxArchiveCSVBytes+1),
	} {
		bars, err := ParseKlinesCSV(strings.NewReader(input), "BTCUSDT", delay)
		require.ErrorIs(t, err, ErrLimit)
		require.Nil(t, bars)
	}
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	bars, err := ParseKlinesCSVContext(ctx, nil, "BTCUSDT", delay)
	require.ErrorIs(t, err, context.Canceled)
	require.Nil(t, bars)
	bars, err = ParseArchiveContext(ctx, ArchiveFile{}, "BTCUSDT", delay)
	require.ErrorIs(t, err, context.Canceled)
	require.Nil(t, bars)
	live, cancelLive := context.WithCancel(context.Background())
	defer cancelLive()
	r := &cancelArchiveReader{r: strings.NewReader(strings.Repeat("1704067200000,1,2,1,2,1\n", 100)), cancel: cancelLive}
	bars, err = ParseKlinesCSVContext(live, r, "BTCUSDT", delay)
	require.ErrorIs(t, err, context.Canceled)
	require.Nil(t, bars, "discard parsed rows when the input is cancelled mid-stream")
	// Quoted numeric fields and empty lines retain their original CSV interpretation.
	bars, err = ParseKlinesCSV(strings.NewReader("\n1704067200000,\"1\",2,1,2,1\r\n\n"), "BTCUSDT", delay)
	require.NoError(t, err)
	require.Len(t, bars, 1)
	row := "1704067200000,1,2,1,2,1\n"
	bars, err = ParseKlinesCSV(strings.NewReader(strings.Repeat(row, maxArchiveRows)), "BTCUSDT", delay)
	require.NoError(t, err)
	require.Len(t, bars, maxArchiveRows, "accept the complete boundary, never truncate")
}

// Small chunks force a context change after parsing has already started.
type cancelArchiveReader struct {
	r      io.Reader
	cancel context.CancelFunc
	reads  int
}

func (r *cancelArchiveReader) Read(p []byte) (int, error) {
	r.reads++
	if r.reads == 2 {
		r.cancel()
	}
	return r.r.Read(p[:min(len(p), 32)])
}
