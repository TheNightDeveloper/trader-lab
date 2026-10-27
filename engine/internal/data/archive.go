package data

import (
	"archive/zip"
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/csv"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
)

var (
	ErrNotPublished = errors.New("data: archive file not published")
	ErrChecksum     = errors.New("data: archive checksum mismatch")
)

// ArchiveBaseURL is Binance's public kline archive.
const ArchiveBaseURL = "https://data.binance.vision"

// maxArchiveBytes bounds one download; a month of 1m klines zips to ~2.5 MB.
const maxArchiveBytes = 64 << 20

// MonthlyURL is the 1m kline zip for one month, e.g. 2024-01.
func MonthlyURL(base, symbol string, month time.Time) string {
	return fmt.Sprintf("%s/data/spot/monthly/klines/%s/1m/%s-1m-%s.zip", base, symbol, symbol, month.UTC().Format("2006-01"))
}

// DailyURL is the 1m kline zip for one UTC day.
func DailyURL(base, symbol string, day time.Time) string {
	return fmt.Sprintf("%s/data/spot/daily/klines/%s/1m/%s-1m-%s.zip", base, symbol, symbol, day.UTC().Format("2006-01-02"))
}

// ArchiveFile is a downloaded, checksum-verified kline zip.
type ArchiveFile struct {
	URL    string
	SHA256 string
	Zip    []byte
}

// FetchArchive downloads url and its .CHECKSUM sibling and verifies SHA-256.
// A 404 on either returns ErrNotPublished.
func FetchArchive(ctx context.Context, c *http.Client, url string) (ArchiveFile, error) {
	sum, err := get(ctx, c, url+".CHECKSUM", 4096)
	if err != nil {
		return ArchiveFile{}, err
	}
	want, _, _ := strings.Cut(strings.TrimSpace(string(sum)), " ")
	if len(want) != 64 {
		return ArchiveFile{}, fmt.Errorf("%w: malformed CHECKSUM for %s", ErrChecksum, url)
	}
	body, err := get(ctx, c, url, maxArchiveBytes)
	if err != nil {
		return ArchiveFile{}, err
	}
	h := sha256.Sum256(body)
	if got := hex.EncodeToString(h[:]); !strings.EqualFold(got, want) {
		return ArchiveFile{}, fmt.Errorf("%w: %s: got %s, want %s", ErrChecksum, url, got, want)
	}
	return ArchiveFile{URL: url, SHA256: strings.ToLower(want), Zip: body}, nil
}

func get(ctx context.Context, c *http.Client, url string, limit int64) ([]byte, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, err
	}
	resp, err := c.Do(req)
	if err != nil {
		return nil, fmt.Errorf("get %s: %w", url, err)
	}
	defer func() { _ = resp.Body.Close() }()
	switch {
	case resp.StatusCode == http.StatusNotFound:
		return nil, fmt.Errorf("%w: %s", ErrNotPublished, url)
	case resp.StatusCode != http.StatusOK:
		return nil, fmt.Errorf("get %s: status %d", url, resp.StatusCode)
	}
	b, err := io.ReadAll(io.LimitReader(resp.Body, limit+1))
	if err != nil {
		return nil, fmt.Errorf("read %s: %w", url, err)
	}
	if int64(len(b)) > limit {
		return nil, fmt.Errorf("get %s: larger than %d bytes", url, limit)
	}
	return b, nil
}

// ParseArchive reads the single CSV inside a kline zip.
func ParseArchive(f ArchiveFile, symbol string, delay time.Duration) ([]Bar, error) {
	zr, err := zip.NewReader(bytes.NewReader(f.Zip), int64(len(f.Zip)))
	if err != nil {
		return nil, fmt.Errorf("open zip %s: %w", f.URL, err)
	}
	if len(zr.File) != 1 {
		return nil, fmt.Errorf("zip %s: want 1 file, got %d", f.URL, len(zr.File))
	}
	r, err := zr.File[0].Open()
	if err != nil {
		return nil, err
	}
	defer func() { _ = r.Close() }()
	return ParseKlinesCSV(r, symbol, delay)
}

// ParseKlinesCSV parses Binance 1m kline rows:
// open_time, open, high, low, close, volume, close_time, ...
// Open times are milliseconds before 2025 and microseconds from 2025 on.
// Values must have at most 8 decimals (instrument.Scale); anything else is an error,
// never a silent rounding.
func ParseKlinesCSV(r io.Reader, symbol string, delay time.Duration) ([]Bar, error) {
	cr := csv.NewReader(r)
	cr.FieldsPerRecord = -1
	cr.ReuseRecord = true
	var bars []Bar
	for line := 1; ; line++ {
		rec, err := cr.Read()
		if errors.Is(err, io.EOF) {
			return bars, nil
		}
		if err != nil {
			return nil, fmt.Errorf("csv line %d: %w", line, err)
		}
		b, err := parseKline(rec, symbol, delay)
		var hdr headerError
		if errors.As(err, &hdr) && line == 1 {
			continue // header row
		}
		if err != nil {
			return nil, fmt.Errorf("csv line %d: %w", line, err)
		}
		bars = append(bars, b)
	}
}

type headerError struct{ error }

// parseKline turns one Binance kline record (archive CSV or REST) into a Bar.
func parseKline(rec []string, symbol string, delay time.Duration) (Bar, error) {
	if len(rec) < 6 {
		return Bar{}, fmt.Errorf("%d fields, want >= 6", len(rec))
	}
	ts, err := strconv.ParseInt(rec[0], 10, 64)
	if err != nil {
		return Bar{}, headerError{fmt.Errorf("open_time %q: %w", rec[0], err)}
	}
	open := epoch(ts)
	b := Bar{Instrument: symbol, OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute + delay)}
	for i, dst := range []*int64{&b.O.V, &b.H.V, &b.L.V, &b.C.V, &b.Volume.V} {
		if *dst, err = money.Parse(rec[i+1], instrument.Scale); err != nil {
			return Bar{}, fmt.Errorf("field %d: %w", i+2, err)
		}
	}
	b.O.Scale, b.H.Scale, b.L.Scale, b.C.Scale, b.Volume.Scale = instrument.Scale, instrument.Scale, instrument.Scale, instrument.Scale, instrument.Scale
	return b, nil
}

// epoch reads a Binance timestamp in ms or µs. ms values stay below 1e14 until year 5138.
func epoch(ts int64) time.Time {
	if ts >= 1e14 {
		return time.UnixMicro(ts).UTC()
	}
	return time.UnixMilli(ts).UTC()
}
