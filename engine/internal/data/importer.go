package data

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"time"

	"tradinglab/engine/internal/clock"
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
}

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
	var p ImportProgress
	months := monthsIn(from, to)
	p.FilesTotal = len(months)
	for _, m := range months {
		files, err := im.monthFiles(ctx, symbol, m, from, to, &p)
		if err != nil {
			return p, err
		}
		for _, f := range files {
			if err := im.load(ctx, symbol, f, from, to, &p); err != nil {
				return p, err
			}
			p.FilesDone++
			if progress != nil {
				progress(p)
			}
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

// monthFiles fetches the monthly file for m, or the daily files when the monthly
// one is not published.
func (im Importer) monthFiles(ctx context.Context, symbol string, m, from, to time.Time, p *ImportProgress) ([]ArchiveFile, error) {
	f, err := FetchArchive(ctx, im.HTTP, MonthlyURL(im.BaseURL, symbol, m))
	if err == nil {
		return []ArchiveFile{f}, nil
	}
	if !errors.Is(err, ErrNotPublished) {
		return nil, err
	}
	var files []ArchiveFile
	end := m.AddDate(0, 1, 0)
	p.FilesTotal-- // the monthly slot becomes daily slots
	for d := maxTime(m, from.Truncate(24*time.Hour)); d.Before(end) && d.Before(to); d = d.AddDate(0, 0, 1) {
		p.FilesTotal++
		f, err := FetchArchive(ctx, im.HTTP, DailyURL(im.BaseURL, symbol, d))
		if errors.Is(err, ErrNotPublished) {
			p.Missing++
			p.FilesDone++
			continue
		}
		if err != nil {
			return nil, err
		}
		files = append(files, f)
	}
	return files, nil
}

func (im Importer) load(ctx context.Context, symbol string, f ArchiveFile, from, to time.Time, p *ImportProgress) error {
	bars, err := ParseArchive(f, symbol, im.Delay)
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
