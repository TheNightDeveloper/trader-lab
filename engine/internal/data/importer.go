package data

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"time"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

// Importer loads Binance archive files into candles.
type Importer struct {
	Store   *store.Store
	HTTP    *http.Client
	BaseURL string        // ArchiveBaseURL in production
	Delay   time.Duration // ingest delay: AvailableAt = close + Delay
	Clock   clock.Clock
	Memory  *jobs.Memory // the process-owned budget, also used by research jobs
}

// Covers one downloaded ZIP, bounded CSV parsing, cleaning and database projections.
const archiveWorkspaceBytes = 384 << 20

// ImportProgress is reported after every file.
type ImportProgress struct {
	File        string
	FilesDone   int
	FilesTotal  int
	Rows        int
	Inserted    int
	Corrections int
	Missing     int // files not published (yet)
}

// Import loads closed 1m bars for [from, to). Whole months use the monthly file;
// a month without one falls back to daily files. Days that are not published are
// skipped and show up as gaps. Re-running the same range inserts nothing.
func (im Importer) Import(ctx context.Context, symbol string, from, to time.Time, progress func(ImportProgress)) (ImportProgress, error) {
	from, to = from.UTC().Truncate(time.Minute), to.UTC().Truncate(time.Minute)
	if now := im.Clock.Now(); to.After(now) {
		to = now.Truncate(time.Minute) // only closed bars
	}
	if !from.Before(to) {
		return ImportProgress{}, fmt.Errorf("import %s: empty range %s – %s", symbol, from.Format(time.RFC3339), to.Format(time.RFC3339))
	}
	n, err := RawBarCount(TF1m, from, to)
	if err != nil {
		return ImportProgress{}, err
	}
	release, err := im.Memory.Reserve(ctx, archiveWorkspaceBytes+int64(n)*1024)
	if err != nil {
		return ImportProgress{}, err
	}
	defer release()
	var p ImportProgress
	months := monthsIn(from, to)
	p.FilesTotal = len(months)
	for _, m := range months {
		if err := im.month(ctx, symbol, m, from, to, &p, progress); err != nil {
			return p, err
		}
	}
	// Gaps across file boundaries and unpublished days.
	bars, err := Reader{Q: im.Store.Queries}.Bars(ctx, Query{Symbol: symbol, Timeframe: TF1m, From: from, To: to, AsOf: farFuture})
	if err != nil {
		return p, err
	}
	if err := SaveIssues(ctx, im.Store.Queries, symbol, Gaps(bars, TF1m, from, to)); err != nil {
		return p, err
	}
	return p, nil
}

// Process daily fallbacks one at a time so downloaded ZIPs cannot accumulate for a month.
func (im Importer) month(ctx context.Context, symbol string, m, from, to time.Time, p *ImportProgress, progress func(ImportProgress)) error {
	f, err := FetchArchive(ctx, im.HTTP, MonthlyURL(im.BaseURL, symbol, m))
	if err == nil {
		return im.load(ctx, symbol, f, from, to, p, progress)
	}
	if !errors.Is(err, ErrNotPublished) {
		return err
	}
	end := m.AddDate(0, 1, 0)
	start := maxTime(m, from.Truncate(24*time.Hour))
	p.FilesTotal-- // the monthly slot becomes daily slots
	for d := start; d.Before(end) && d.Before(to); d = d.AddDate(0, 0, 1) {
		p.FilesTotal++
	}
	for d := start; d.Before(end) && d.Before(to); d = d.AddDate(0, 0, 1) {
		f, err := FetchArchive(ctx, im.HTTP, DailyURL(im.BaseURL, symbol, d))
		if errors.Is(err, ErrNotPublished) {
			p.Missing++
			p.FilesDone++
			if progress != nil {
				progress(*p)
			}
			continue
		}
		if err != nil {
			return err
		}
		if err := im.load(ctx, symbol, f, from, to, p, progress); err != nil {
			return err
		}
	}
	return nil
}

func (im Importer) load(ctx context.Context, symbol string, f ArchiveFile, from, to time.Time, p *ImportProgress, progress func(ImportProgress)) error {
	bars, err := ParseArchiveContext(ctx, f, symbol, im.Delay)
	if err != nil {
		return err
	}
	inRange := bars[:0]
	for _, b := range bars {
		if !b.OpenTime.Before(from) && b.OpenTime.Before(to) {
			inRange = append(inRange, b)
		}
	}
	clean, issues := Clean(inRange, TF1m)
	up, err := UpsertBars(ctx, im.Store, symbol, "archive", f.SHA256, clean)
	if err != nil {
		return err
	}
	for _, t := range up.Corrections {
		issues = append(issues, Issue{IssueCorrection, t, t.Add(time.Minute), "archive values differ from the stored bar; new revision " + f.SHA256[:12]})
	}
	if err := SaveIssues(ctx, im.Store.Queries, symbol, issues); err != nil {
		return err
	}
	if err := im.Store.RecordImportFile(ctx, recordParams(f, symbol, len(bars))); err != nil {
		return fmt.Errorf("record %s: %w", f.URL, err)
	}
	p.File, p.Rows, p.Inserted, p.Corrections = f.URL, p.Rows+len(clean), p.Inserted+up.Inserted, p.Corrections+len(up.Corrections)
	p.FilesDone++
	if progress != nil {
		progress(*p)
	}
	slog.Info("archive imported", "file", f.URL, "rows", len(clean), "inserted", up.Inserted, "corrections", len(up.Corrections), "issues", len(issues))
	return nil
}

func monthsIn(from, to time.Time) []time.Time {
	var ms []time.Time
	for m := time.Date(from.Year(), from.Month(), 1, 0, 0, 0, 0, time.UTC); m.Before(to); m = m.AddDate(0, 1, 0) {
		ms = append(ms, m)
	}
	return ms
}

func recordParams(f ArchiveFile, symbol string, rows int) db.RecordImportFileParams {
	return db.RecordImportFileParams{Sha256: f.SHA256, Symbol: symbol, Url: f.URL, Rows: int32(rows)}
}
