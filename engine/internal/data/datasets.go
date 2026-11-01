package data

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"

	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

var ErrDatasetChanged = errors.New("data: dataset bars no longer match their hash")

// Dataset is an immutable, content-addressed version of bars.
type Dataset struct {
	FormatVersion   int
	ResampleVersion int
	ID              string
	Spec            DatasetSpec
	KnownAt         time.Time // provenance; only legacy formats reconstruct membership from this cutoff
	BarCount        int
	Gaps            int
	Filled          int
}

// Manifest is the JSON stored with each dataset version.
type Manifest struct {
	FormatVersion   int       `json:"format_version,omitempty"`
	Members         int       `json:"members,omitempty"`
	ResampleVersion int       `json:"resample_version,omitempty"`
	Symbol          string    `json:"symbol"`
	Timeframe       Timeframe `json:"timeframe"`
	From            time.Time `json:"from"`
	To              time.Time `json:"to"`
	GapPolicy       GapPolicy `json:"gap_policy"`
	KnownAt         time.Time `json:"known_at"`
	Bars            int       `json:"bars"`
	Gaps            int       `json:"gaps"`
	Filled          int       `json:"filled"`
}

// CreateDataset fixes exact raw revision membership in one repeatable-read
// transaction. KnownAt is informative; membership never depends on commit timing.
func CreateDataset(ctx context.Context, s *store.Store, spec DatasetSpec) (Dataset, []Bar, error) {
	for range 3 {
		ds, bars, err := createSnapshot(ctx, s, spec)
		var pe *pgconn.PgError
		if !errors.As(err, &pe) || pe.Code != "40001" {
			return ds, bars, err
		}
		if ctx.Err() != nil {
			return Dataset{}, nil, ctx.Err()
		}
	}
	return Dataset{}, nil, errors.New("data: concurrent snapshot creation; retry")
}

const snapshotFormat = 1

func createSnapshot(ctx context.Context, s *store.Store, spec DatasetSpec) (Dataset, []Bar, error) {
	var ds Dataset
	var bars []Bar
	err := s.InTxOptions(ctx, pgx.TxOptions{IsoLevel: pgx.RepeatableRead}, func(q *db.Queries) error {
		knownAt, err := q.DBNow(ctx)
		if err != nil {
			return err
		}
		from := spec.From.Truncate(spec.Timeframe.Duration())
		rows, err := q.SnapshotCandles(ctx, db.SnapshotCandlesParams{Symbol: spec.Symbol, FromTime: from, ToTime: spec.To})
		if err != nil {
			return err
		}
		raw, revisions := revisionBars(spec.Symbol, len(rows), func(i int) db.SnapshotCandlesRow { return rows[i] })
		var gaps []Issue
		bars, gaps, err = snapshotBars(spec, raw, false)
		if err != nil {
			return err
		}
		ds = Dataset{FormatVersion: snapshotFormat, ResampleVersion: resampleVersion, ID: hashSnapshot(spec, bars, raw, revisions), Spec: spec, KnownAt: knownAt.UTC(), BarCount: len(bars), Gaps: len(gaps)}
		for _, b := range bars {
			if b.Flags&FlagFilled != 0 {
				ds.Filled++
			}
		}
		m, err := json.Marshal(Manifest{FormatVersion: snapshotFormat, Members: len(rows), ResampleVersion: resampleVersion, Symbol: spec.Symbol, Timeframe: spec.Timeframe, From: spec.From.UTC(), To: spec.To.UTC(), GapPolicy: spec.GapPolicy, KnownAt: ds.KnownAt, Bars: ds.BarCount, Gaps: ds.Gaps, Filled: ds.Filled})
		if err != nil {
			return err
		}
		n, err := q.InsertSnapshotDataset(ctx, db.InsertSnapshotDatasetParams{
			ID: ds.ID, Symbol: spec.Symbol, Timeframe: string(spec.Timeframe), RangeFrom: spec.From, RangeTo: spec.To,
			GapPolicy: string(spec.GapPolicy), KnownAt: ds.KnownAt, BarCount: int32(ds.BarCount), Manifest: m,
		})
		if err != nil {
			return fmt.Errorf("save dataset: %w", err)
		}
		if n > 0 {
			count, err := q.InsertDatasetMembers(ctx, db.InsertDatasetMembersParams{DatasetID: ds.ID, Symbol: spec.Symbol, FromTime: from, ToTime: spec.To})
			if err != nil {
				return err
			}
			if count != int64(len(rows)) {
				return fmt.Errorf("%w: snapshot membership count", ErrDatasetChanged)
			}
		}
		stored, err := q.GetDataset(ctx, ds.ID)
		if err != nil {
			return err
		}
		ds, err = datasetFromRow(stored) // first creation wins for identical membership
		if err != nil {
			return err
		}
		return SaveIssues(ctx, q, spec.Symbol, gaps)
	})
	if err != nil {
		return Dataset{}, nil, err
	}
	return ds, bars, nil
}

// LoadDataset rebuilds a version's bars and verifies they still hash to its ID.
func LoadDataset(ctx context.Context, s *store.Store, id string) (Dataset, []Bar, error) {
	row, err := s.GetDataset(ctx, id)
	if err != nil {
		return Dataset{}, nil, fmt.Errorf("dataset %s: %w", id, err)
	}
	ds, err := datasetFromRow(row)
	if err != nil {
		return Dataset{}, nil, err
	}
	if ds.FormatVersion == snapshotFormat {
		m, err := ParseManifest(row.Manifest)
		if err != nil {
			return Dataset{}, nil, err
		}
		rows, err := s.DatasetCandles(ctx, db.DatasetCandlesParams{DatasetID: id, Symbol: ds.Spec.Symbol})
		if err != nil {
			return Dataset{}, nil, err
		}
		if len(rows) != m.Members {
			return Dataset{}, nil, fmt.Errorf("%w: %s membership count", ErrDatasetChanged, id)
		}
		raw, revisions := revisionBars(ds.Spec.Symbol, len(rows), func(i int) db.SnapshotCandlesRow { return db.SnapshotCandlesRow(rows[i]) })
		bars, _, err := snapshotBars(ds.Spec, raw, ds.ResampleVersion < resampleVersion)
		if err != nil {
			return Dataset{}, nil, err
		}
		if len(bars) != ds.BarCount || hashSnapshot(ds.Spec, bars, raw, revisions) != id {
			return Dataset{}, nil, fmt.Errorf("%w: %s", ErrDatasetChanged, id)
		}
		return ds, bars, nil
	}
	bars, _, err := datasetBars(ctx, s.Queries, ds.Spec, ds.KnownAt, ds.ResampleVersion < resampleVersion)
	if err != nil {
		return Dataset{}, nil, err
	}
	if HashDataset(ds.Spec, bars) != id {
		return Dataset{}, nil, fmt.Errorf("%w: %s", ErrDatasetChanged, id)
	}
	return ds, bars, nil
}

func datasetFromRow(row db.Dataset) (Dataset, error) {
	tf, err := ParseTimeframe(row.Timeframe)
	if err != nil {
		return Dataset{}, err
	}
	gp, err := ParseGapPolicy(row.GapPolicy)
	if err != nil {
		return Dataset{}, err
	}
	m, err := ParseManifest(row.Manifest)
	if err != nil {
		return Dataset{}, fmt.Errorf("dataset %s: %w", row.ID, err)
	}
	return Dataset{
		FormatVersion:   m.FormatVersion,
		ResampleVersion: m.ResampleVersion,
		ID:              row.ID, Spec: DatasetSpec{row.Symbol, tf, row.RangeFrom.UTC(), row.RangeTo.UTC(), gp},
		KnownAt: row.KnownAt.UTC(), BarCount: int(row.BarCount), Gaps: m.Gaps, Filled: m.Filled,
	}, nil
}

// datasetBars reads every bar in the range (availability is filtered later, at
// run time, by the simulator's as-of reads) and applies the gap policy.
func datasetBars(ctx context.Context, q *db.Queries, spec DatasetSpec, knownAt time.Time, legacy bool) ([]Bar, []Issue, error) {
	bars, err := (Reader{Q: q}).bars(ctx, Query{
		Symbol: spec.Symbol, Timeframe: spec.Timeframe, From: spec.From, To: spec.To, AsOf: farFuture, KnownAt: knownAt,
	}, legacy)
	if err != nil {
		return nil, nil, err
	}
	return datasetPolicy(spec, bars)
}

func revisionBars(symbol string, n int, row func(int) db.SnapshotCandlesRow) ([]Bar, []int32) {
	// Adapt generated query row types one at a time; never duplicate the full
	// raw-candle row buffer when loading a large snapshot.
	raw := make([]Bar, n)
	revisions := make([]int32, n)
	for i := range n {
		r := row(i)
		raw[i] = Bar{Instrument: symbol, OpenTime: r.OpenTime.UTC(), CloseTime: r.CloseTime.UTC(), AvailableAt: r.AvailableAt.UTC(), O: price(r.O), H: price(r.H), L: price(r.L), C: price(r.C), Volume: money.Qty{V: r.Volume, Scale: instrument.Scale}}
		revisions[i] = r.Revision
	}
	return raw, revisions
}

func snapshotBars(spec DatasetSpec, raw []Bar, legacy bool) ([]Bar, []Issue, error) {
	bars, err := resample(raw, spec.Timeframe, legacy)
	if err != nil {
		return nil, nil, err
	}
	// TF1m returns raw itself; retain every selected row for membership hashing.
	from := 0
	for from < len(bars) && bars[from].OpenTime.Before(spec.From) {
		from++
	}
	return datasetPolicy(spec, bars[from:])
}

func datasetPolicy(spec DatasetSpec, bars []Bar) ([]Bar, []Issue, error) {
	var delay time.Duration
	if len(bars) > 0 {
		delay = bars[0].AvailableAt.Sub(bars[0].CloseTime)
	}
	return ApplyGapPolicy(bars, spec.Timeframe, spec.From, spec.To, spec.GapPolicy, delay)
}

func ParseManifest(b []byte) (Manifest, error) {
	var m Manifest
	if err := json.Unmarshal(b, &m); err != nil {
		return Manifest{}, fmt.Errorf("manifest: %w", err)
	}
	if m.ResampleVersion < 0 || m.ResampleVersion > resampleVersion {
		return Manifest{}, fmt.Errorf("manifest: unsupported resample_version %d", m.ResampleVersion)
	}
	if m.FormatVersion < 0 || m.FormatVersion > snapshotFormat || m.Members < 0 {
		return Manifest{}, fmt.Errorf("manifest: unsupported format_version %d or member count", m.FormatVersion)
	}
	return m, nil
}
