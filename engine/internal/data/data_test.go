package data

import (
	"archive/zip"
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/money"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

const delay = 2 * time.Second

// mk builds a 1m bar at minute i with close c (in whole USDT) and volume v.
func mk(i int, c int64, v int64) Bar {
	open := t0.Add(time.Duration(i) * time.Minute)
	p := func(x int64) money.Price { return money.Price{V: x * 1e8, Scale: 8} }
	return Bar{
		Instrument: "BTCUSDT", OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute + delay),
		O: p(c), H: p(c + 1), L: p(c - 1), C: p(c), Volume: money.Qty{V: v, Scale: 8},
	}
}

func series(n int) []Bar {
	bars := make([]Bar, n)
	for i := range bars {
		bars[i] = mk(i, 100+int64(i), 1e8)
	}
	return bars
}

func kinds(is []Issue) []IssueKind {
	var k []IssueKind
	for _, i := range is {
		k = append(k, i.Kind)
	}
	return k
}

func TestParseKlinesCSVMillisAndMicros(t *testing.T) {
	csv := "open_time,open,high,low,close,volume,close_time\n" +
		"1704067200000,42283.58000000,42298.62000000,42261.02000000,42298.61000000,35.92724000,1704067259999,x,1,2,3,0\n" +
		"1735689600000000,93576.00000000,93610.93000000,93537.50000000,93610.93,8.21827000,1735689659999999,x,1,2,3,0\n"
	bars, err := ParseKlinesCSV(strings.NewReader(csv), "BTCUSDT", delay)
	require.NoError(t, err)
	require.Len(t, bars, 2)
	require.Equal(t, t0, bars[0].OpenTime, "ms timestamp")
	require.Equal(t, time.Date(2025, 1, 1, 0, 0, 0, 0, time.UTC), bars[1].OpenTime, "µs timestamp")
	require.Equal(t, bars[0].OpenTime.Add(time.Minute), bars[0].CloseTime)
	require.Equal(t, bars[0].CloseTime.Add(delay), bars[0].AvailableAt)
	require.Equal(t, int64(4_229_862_000_000), bars[0].H.V)
	require.Equal(t, "35.92724000", bars[0].Volume.String())

	_, err = ParseKlinesCSV(strings.NewReader("1704067200000,1.123456789,1,1,1,1\n"), "BTCUSDT", delay)
	require.ErrorIs(t, err, money.ErrParse, "9 decimals must fail, not round")
	_, err = ParseKlinesCSV(strings.NewReader("1704067200000,1,1,1,1,1\nnope,1,1,1,1,1\n"), "BTCUSDT", delay)
	require.Error(t, err, "only the first line may be a header")
}

func TestCleanDetectsPlantedProblems(t *testing.T) {
	bars := series(10)
	bars = append(bars[:4], bars[5:]...)    // planted gap: minute 4 missing
	bars[6].H = money.Price{V: 1, Scale: 8} // planted bad price at minute 7: high below open/close
	bars[1], bars[2] = bars[2], bars[1]     // out of order
	bars = append(bars, bars[0])            // duplicate of minute 0
	bars[7].Volume.V = 0                    // single zero-volume bar: normal, not reported

	clean, issues := Clean(bars, TF1m)

	require.ElementsMatch(t, []IssueKind{IssueOutOfOrder, IssueOutOfOrder, IssueDuplicate, IssueBadPrice, IssueGap, IssueGap}, kinds(issues))
	byKind := map[IssueKind][]Issue{}
	for _, i := range issues {
		byKind[i.Kind] = append(byKind[i.Kind], i)
	}
	require.Equal(t, t0.Add(4*time.Minute), byKind[IssueGap][0].At, "planted gap")
	require.Equal(t, t0.Add(5*time.Minute), byKind[IssueGap][0].Until)
	require.Equal(t, t0.Add(7*time.Minute), byKind[IssueBadPrice][0].At, "planted bad price")
	require.Equal(t, t0.Add(7*time.Minute), byKind[IssueGap][1].At, "dropped bad bar leaves a gap")

	require.Len(t, clean, 8) // 10 - missing - bad
	for i := 1; i < len(clean); i++ {
		require.True(t, clean[i].OpenTime.After(clean[i-1].OpenTime), "sorted, unique")
	}
}

func TestZeroVolumeRuns(t *testing.T) {
	bars := series(20)
	for i := 3; i < 8; i++ { // 5-bar run: reported
		bars[i].Volume.V = 0
	}
	for i := 12; i < 16; i++ { // 4-bar run: normal
		bars[i].Volume.V = 0
	}
	_, issues := Clean(bars, TF1m)
	require.Len(t, issues, 1)
	require.Equal(t, IssueZeroVolume, issues[0].Kind)
	require.Equal(t, t0.Add(3*time.Minute), issues[0].At)
	require.Equal(t, t0.Add(8*time.Minute), issues[0].Until)
}

func TestGapsAtEdges(t *testing.T) {
	bars := series(10)[2:8]
	g := Gaps(bars, TF1m, t0, t0.Add(10*time.Minute))
	require.Len(t, g, 2)
	require.Equal(t, "2 missing 1m bars", g[0].Detail)
	require.Equal(t, t0.Add(8*time.Minute), g[1].At)
	require.Len(t, Gaps(nil, TF1m, t0, t0.Add(time.Hour)), 1)
}

func TestGapPolicies(t *testing.T) {
	bars := series(6)
	bars = append(bars[:2], bars[4:]...) // minutes 2, 3 missing
	from, to := t0, t0.Add(6*time.Minute)

	out, issues, err := ApplyGapPolicy(bars, TF1m, from, to, GapFlag, delay)
	require.NoError(t, err)
	require.Len(t, out, 4)
	require.Len(t, issues, 1)

	_, _, err = ApplyGapPolicy(bars, TF1m, from, to, GapStop, delay)
	require.ErrorIs(t, err, ErrGap)

	out, issues, err = ApplyGapPolicy(bars, TF1m, from, to, GapFFill, delay)
	require.NoError(t, err)
	require.Len(t, issues, 1, "filled gaps are still reported")
	require.Len(t, out, 6)
	for _, f := range out[2:4] {
		require.Equal(t, FlagFilled, f.Flags)
		require.Equal(t, bars[1].C, f.O, "uses the previous close only")
		require.Equal(t, f.O, f.C)
		require.Zero(t, f.Volume.V)
		require.Equal(t, f.CloseTime.Add(delay), f.AvailableAt, "never available before its own close")
	}
	_, err = ParseGapPolicy("bfill")
	require.Error(t, err)
}

func TestResample(t *testing.T) {
	bars := series(47) // 00:00..00:46 → 15m buckets 00:00, 00:15, 00:30 closed; 00:45 open
	out, err := Resample(bars, TF15m)
	require.NoError(t, err)
	require.Len(t, out, 3, "trailing open bucket is not emitted")
	b := out[1]
	require.Equal(t, t0.Add(15*time.Minute), b.OpenTime)
	require.Equal(t, bars[15].O, b.O)
	require.Equal(t, bars[29].C, b.C)
	require.Equal(t, bars[29].H, b.H)
	require.Equal(t, bars[15].L, b.L)
	require.Equal(t, int64(15e8), b.Volume.V)
	require.Equal(t, bars[29].AvailableAt, b.AvailableAt)
	require.Zero(t, b.Flags)

	// Missing last minute of a bucket: emitted as partial once a later bar proves it closed,
	// and available no earlier than the bucket close.
	holed := append(append([]Bar{}, bars[:14]...), bars[15:]...)
	out, err = Resample(holed, TF15m)
	require.NoError(t, err)
	require.Equal(t, FlagPartial, out[0].Flags)
	require.Equal(t, t0.Add(15*time.Minute+delay), out[0].AvailableAt)

	// 1d buckets align to 00:00 UTC.
	day := []Bar{mk(23*60+59, 100, 1), mk(24*60, 100, 1), mk(48*60, 100, 1)}
	out, err = Resample(day, TF1d)
	require.NoError(t, err)
	require.Len(t, out, 2)
	require.Equal(t, t0, out[0].OpenTime)
	require.Equal(t, t0.Add(24*time.Hour), out[1].OpenTime)
}

func TestHashDataset(t *testing.T) {
	spec := DatasetSpec{"BTCUSDT", TF1m, t0, t0.Add(time.Hour), GapFlag}
	bars := series(60)
	h := HashDataset(spec, bars)
	require.Len(t, h, 64)
	require.Equal(t, h, HashDataset(spec, series(60)), "deterministic")

	changed := series(60)
	changed[30].C.V++
	require.NotEqual(t, h, HashDataset(spec, changed), "any value change")
	later := series(60)
	later[0].AvailableAt = later[0].AvailableAt.Add(time.Second)
	require.NotEqual(t, h, HashDataset(spec, later), "availability is part of the data")
	spec.GapPolicy = GapFFill
	require.NotEqual(t, h, HashDataset(spec, bars), "policy is part of the version")
}

func zipCSV(t *testing.T, name, content string) []byte {
	var buf bytes.Buffer
	zw := zip.NewWriter(&buf)
	w, err := zw.Create(name)
	require.NoError(t, err)
	_, err = w.Write([]byte(content))
	require.NoError(t, err)
	require.NoError(t, zw.Close())
	return buf.Bytes()
}

// archiveServer serves zips by path and their .CHECKSUM files; anything else 404s.
func archiveServer(t *testing.T, files map[string][]byte, badSum bool) *httptest.Server {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		path, isSum := strings.CutSuffix(r.URL.Path, ".CHECKSUM")
		z, ok := files[path]
		if !ok {
			http.NotFound(w, r)
			return
		}
		if isSum {
			s := sha256.Sum256(z)
			if badSum {
				s[0] ^= 1
			}
			_, _ = fmt.Fprintf(w, "%s  %s\n", hex.EncodeToString(s[:]), path[strings.LastIndex(path, "/")+1:])
			return
		}
		_, _ = w.Write(z)
	}))
	t.Cleanup(srv.Close)
	return srv
}

func TestFetchArchive(t *testing.T) {
	z := zipCSV(t, "BTCUSDT-1m-2024-01.csv", "1704067200000,1,2,0.5,1.5,10,1704067259999\n")
	path := "/data/spot/monthly/klines/BTCUSDT/1m/BTCUSDT-1m-2024-01.zip"
	srv := archiveServer(t, map[string][]byte{path: z}, false)
	ctx := context.Background()

	url := MonthlyURL(srv.URL, "BTCUSDT", t0)
	f, err := FetchArchive(ctx, srv.Client(), url)
	require.NoError(t, err)
	sum := sha256.Sum256(z)
	require.Equal(t, hex.EncodeToString(sum[:]), f.SHA256)
	bars, err := ParseArchive(f, "BTCUSDT", delay)
	require.NoError(t, err)
	require.Len(t, bars, 1)

	_, err = FetchArchive(ctx, srv.Client(), MonthlyURL(srv.URL, "BTCUSDT", t0.AddDate(0, 1, 0)))
	require.ErrorIs(t, err, ErrNotPublished)

	bad := archiveServer(t, map[string][]byte{path: z}, true)
	_, err = FetchArchive(ctx, bad.Client(), MonthlyURL(bad.URL, "BTCUSDT", t0))
	require.ErrorIs(t, err, ErrChecksum)
}
