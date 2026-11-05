package data

import (
	"archive/zip"
	"bufio"
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

// Monthly numeric CSVs are bounded independently of ZIP compression and request range.
const (
	maxArchiveCSVBytes  = 32 << 20
	maxArchiveRows      = 31 * 1440
	maxArchiveLineBytes = 4096
)

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
	if resp.ContentLength > limit {
		return nil, fmt.Errorf("%w: get %s: larger than %d bytes", ErrLimit, url, limit)
	}
	b, err := io.ReadAll(io.LimitReader(resp.Body, limit+1))
	if err != nil {
		return nil, fmt.Errorf("read %s: %w", url, err)
	}
	if int64(len(b)) > limit {
		return nil, fmt.Errorf("%w: get %s: larger than %d bytes", ErrLimit, url, limit)
	}
	return b, nil
}

// ParseArchive reads the single CSV inside a kline zip.
func ParseArchive(f ArchiveFile, symbol string, delay time.Duration) ([]Bar, error) {
	return ParseArchiveContext(context.Background(), f, symbol, delay)
}

// ParseArchiveContext checks cancellation during decompression as well as row parsing.
func ParseArchiveContext(ctx context.Context, f ArchiveFile, symbol string, delay time.Duration) ([]Bar, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if len(f.Zip) > maxArchiveBytes {
		return nil, fmt.Errorf("%w: archive ZIP exceeds %d bytes", ErrLimit, maxArchiveBytes)
	}
	zr, err := zip.NewReader(bytes.NewReader(f.Zip), int64(len(f.Zip)))
	if err != nil {
		return nil, fmt.Errorf("open zip %s: %w", f.URL, err)
	}
	if len(zr.File) != 1 {
		return nil, fmt.Errorf("zip %s: want 1 file, got %d", f.URL, len(zr.File))
	}
	if zr.File[0].UncompressedSize64 > maxArchiveCSVBytes {
		return nil, fmt.Errorf("%w: archive CSV exceeds %d bytes", ErrLimit, maxArchiveCSVBytes)
	}
	r, err := zr.File[0].Open()
	if err != nil {
		return nil, err
	}
	defer func() { _ = r.Close() }()
	return ParseKlinesCSVContext(ctx, r, symbol, delay)
}

// ParseKlinesCSV parses Binance 1m kline rows:
// open_time, open, high, low, close, volume, close_time, ...
// Open times are milliseconds before 2025 and microseconds from 2025 on.
// Values must have at most 8 decimals (instrument.Scale); anything else is an error,
// never a silent rounding.
func ParseKlinesCSV(r io.Reader, symbol string, delay time.Duration) ([]Bar, error) {
	return ParseKlinesCSVContext(context.Background(), r, symbol, delay)
}

// Numeric archive rows are single-line records; bound a line before CSV allocates its fields.
func ParseKlinesCSVContext(ctx context.Context, r io.Reader, symbol string, delay time.Duration) ([]Bar, error) {
	limited := &io.LimitedReader{R: archiveReader{ctx, r}, N: maxArchiveCSVBytes + 1}
	scanner := bufio.NewScanner(limited)
	scanner.Buffer(make([]byte, maxArchiveLineBytes), maxArchiveLineBytes+1)
	// Reuse CSV's input buffer; allocating 4 KiB per numeric row multiplies import work.
	row := bytes.NewReader(nil)
	csvBuffer := bufio.NewReader(row)
	var bars []Bar
	line := 0
	for scanner.Scan() {
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		if limited.N <= 0 {
			return nil, fmt.Errorf("%w: archive CSV exceeds %d bytes", ErrLimit, maxArchiveCSVBytes)
		}
		if len(scanner.Bytes()) == 0 {
			continue // match encoding/csv's empty-line handling
		}
		line++
		row.Reset(scanner.Bytes())
		csvBuffer.Reset(row)
		cr := csv.NewReader(csvBuffer)
		cr.FieldsPerRecord = -1
		rec, err := cr.Read()
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
		if len(bars) >= maxArchiveRows {
			return nil, fmt.Errorf("%w: archive exceeds %d rows", ErrLimit, maxArchiveRows)
		}
		bars = append(bars, b)
	}
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if limited.N <= 0 || errors.Is(scanner.Err(), bufio.ErrTooLong) {
		return nil, fmt.Errorf("%w: CSV byte or line limit exceeded", ErrLimit)
	}
	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("read archive CSV: %w", err)
	}
	return bars, nil
}

// A long row or compressed stream must observe cancellation at each buffered read.
type archiveReader struct {
	ctx context.Context
	r   io.Reader
}

func (r archiveReader) Read(p []byte) (int, error) {
	if err := r.ctx.Err(); err != nil {
		return 0, err
	}
	return r.r.Read(p)
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
