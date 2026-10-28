// Package backup takes the nightly database dump (pg_dump, custom format) and
// keeps the newest files. Restoring is a manual, documented step (docs/BACKUP.md).
package backup

import (
	"bytes"
	"context"
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"slices"
	"strings"
	"time"

	"tradinglab/engine/internal/clock"
)

// Nightly dumps the database once a day after HourUTC into Dir/lab-YYYYMMDD.dump.
type Nightly struct {
	URL     string
	Dir     string
	HourUTC int
	Keep    int
	Clock   clock.Clock
	// Dump writes a dump of url to file; PgDump unless a test replaces it.
	Dump func(ctx context.Context, url, file string) error
}

// PgDump runs pg_dump (custom format, restorable with pg_restore).
func PgDump(ctx context.Context, url, file string) error {
	var stderr bytes.Buffer
	cmd := exec.CommandContext(ctx, "pg_dump", "--format=custom", "--no-owner", "--file="+file, url)
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("pg_dump: %w: %s", err, strings.TrimSpace(stderr.String()))
	}
	return nil
}

// Run checks every 10 minutes whether today's dump is due.
func (n *Nightly) Run(ctx context.Context) {
	t := time.NewTicker(10 * time.Minute)
	defer t.Stop()
	for {
		if file, err := n.Tick(ctx); err != nil {
			slog.Error("nightly backup failed", "err", err)
		} else if file != "" {
			slog.Info("nightly backup", "file", file)
		}
		select {
		case <-ctx.Done():
			return
		case <-t.C:
		}
	}
}

// Tick takes today's dump if it is due and missing; it returns the new file.
func (n *Nightly) Tick(ctx context.Context) (string, error) {
	now := n.Clock.Now().UTC()
	if now.Hour() < n.HourUTC {
		return "", nil
	}
	file := filepath.Join(n.Dir, "lab-"+now.Format("20060102")+".dump")
	if _, err := os.Stat(file); err == nil {
		return "", nil
	}
	if err := os.MkdirAll(n.Dir, 0o750); err != nil {
		return "", err
	}
	dump := n.Dump
	if dump == nil {
		dump = PgDump
	}
	// Written aside and renamed: a half-written dump never looks like a backup.
	partial := file + ".partial"
	if err := dump(ctx, n.URL, partial); err != nil {
		_ = os.Remove(partial)
		return "", err
	}
	if err := os.Rename(partial, file); err != nil {
		return "", err
	}
	return file, n.prune()
}

// prune keeps the newest Keep dumps (names sort by date).
func (n *Nightly) prune() error {
	files, err := filepath.Glob(filepath.Join(n.Dir, "lab-*.dump"))
	if err != nil {
		return err
	}
	slices.Sort(files)
	for len(files) > max(1, n.Keep) {
		if err := os.Remove(files[0]); err != nil {
			return err
		}
		files = files[1:]
	}
	return nil
}
