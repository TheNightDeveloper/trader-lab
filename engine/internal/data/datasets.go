package data

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

var ErrDatasetChanged = errors.New("data: dataset bars no longer match their hash")

// Dataset is an immutable, content-addressed version of bars.
type Dataset struct {
	ID       string
	Spec     DatasetSpec
	KnownAt  time.Time // candle rows ingested after this are not part of the version
	BarCount int
	Gaps     int
	Filled   int
}

// Manifest is the JSON stored with each dataset version.
type Manifest struct {
	Symbol    string    `json:"symbol"`
	Timeframe Timeframe `json:"timeframe"`
	From      time.Time `json:"from"`
	To        time.Time `json:"to"`
	GapPolicy GapPolicy `json:"gap_policy"`
	KnownAt   time.Time `json:"known_at"`
	Bars      int       `json:"bars"`
	Gaps      int       `json:"gaps"`
	Filled    int       `json:"filled"`
}

// CreateDataset snapshots spec with every bar ingested so far (known_at is the
// database clock, the same clock that stamps ingested_at). The same bars give the
// same ID, so creating it again returns the existing version; a correction gives
// a new ID.
func CreateDataset(ctx context.Context, s *store.Store, spec DatasetSpec) (Dataset, []Bar, error) {
	knownAt, err := s.DBNow(ctx)
	if err != nil {
		return Dataset{}, nil, err
	}
	bars, gaps, err := datasetBars(ctx, s.Queries, spec, knownAt)
	if err != nil {
		return Dataset{}, nil, err
	}
	ds := Dataset{ID: HashDataset(spec, bars), Spec: spec, KnownAt: knownAt.UTC(), BarCount: len(bars), Gaps: len(gaps)}
	for _, b := range bars {
		if b.Flags&FlagFilled != 0 {
			ds.Filled++
		}
	}
	m, err := json.Marshal(Manifest{spec.Symbol, spec.Timeframe, spec.From.UTC(), spec.To.UTC(), spec.GapPolicy, ds.KnownAt, ds.BarCount, ds.Gaps, ds.Filled})
	if err != nil {
		return Dataset{}, nil, err
	}
	err = s.InsertDataset(ctx, db.InsertDatasetParams{
		ID: ds.ID, Symbol: spec.Symbol, Timeframe: string(spec.Timeframe), RangeFrom: spec.From, RangeTo: spec.To,
		GapPolicy: string(spec.GapPolicy), KnownAt: ds.KnownAt, BarCount: int32(ds.BarCount), Manifest: m,
	})
	if err != nil {
		return Dataset{}, nil, fmt.Errorf("save dataset: %w", err)
	}
	stored, err := s.GetDataset(ctx, ds.ID)
	if err != nil {
		return Dataset{}, nil, err
	}
	ds.KnownAt = stored.KnownAt.UTC() // first creation wins; the bars are identical by hash
	if err := SaveIssues(ctx, s.Queries, spec.Symbol, gaps); err != nil {
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
	bars, _, err := datasetBars(ctx, s.Queries, ds.Spec, ds.KnownAt)
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
		ID: row.ID, Spec: DatasetSpec{row.Symbol, tf, row.RangeFrom.UTC(), row.RangeTo.UTC(), gp},
		KnownAt: row.KnownAt.UTC(), BarCount: int(row.BarCount), Gaps: m.Gaps, Filled: m.Filled,
	}, nil
}

// datasetBars reads every bar in the range (availability is filtered later, at
// run time, by the simulator's as-of reads) and applies the gap policy.
func datasetBars(ctx context.Context, q *db.Queries, spec DatasetSpec, knownAt time.Time) ([]Bar, []Issue, error) {
	bars, err := Reader{Q: q}.Bars(ctx, Query{
		Symbol: spec.Symbol, Timeframe: spec.Timeframe, From: spec.From, To: spec.To, AsOf: farFuture, KnownAt: knownAt,
	})
	if err != nil {
		return nil, nil, err
	}
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
	return m, nil
}
