package data

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

// ErrNoBar means no bar of the symbol was available at the as-of time.
var ErrNoBar = errors.New("data: no bar available")

// upsertBatch keeps one statement's arrays well under PostgreSQL's limits.
const upsertBatch = 10_000

// Upserted reports what an upsert changed.
type Upserted struct {
	Inserted    int
	Corrections []time.Time // open times whose stored values changed (new revision)
}

// UpsertBars stores sorted, unique, clean 1m bars for one symbol in one
// transaction. Identical bars are skipped, so re-importing is a no-op.
func UpsertBars(ctx context.Context, s *store.Store, symbol, source, ref string, bars []Bar) (Upserted, error) {
	var res Upserted
	err := s.InTx(ctx, func(q *db.Queries) error {
		res = Upserted{}
		months := map[time.Time]bool{}
		for _, b := range bars {
			m := time.Date(b.OpenTime.Year(), b.OpenTime.Month(), 1, 0, 0, 0, 0, time.UTC)
			if !months[m] {
				months[m] = true
				if err := q.EnsureCandlePartition(ctx, m); err != nil {
					return fmt.Errorf("partition %s: %w", m.Format("2006-01"), err)
				}
			}
		}
		for start := 0; start < len(bars); start += upsertBatch {
			batch := bars[start:min(start+upsertBatch, len(bars))]
			p := db.UpsertCandlesParams{Symbol: symbol, Source: source, SourceRef: ref}
			for _, b := range batch {
				p.OpenTimes = append(p.OpenTimes, b.OpenTime)
				p.CloseTimes = append(p.CloseTimes, b.CloseTime)
				p.AvailableAts = append(p.AvailableAts, b.AvailableAt)
				p.Os, p.Hs, p.Ls, p.Cs = append(p.Os, b.O.V), append(p.Hs, b.H.V), append(p.Ls, b.L.V), append(p.Cs, b.C.V)
				p.Volumes = append(p.Volumes, b.Volume.V)
			}
			rows, err := q.UpsertCandles(ctx, p)
			if err != nil {
				return fmt.Errorf("upsert %s: %w", symbol, err)
			}
			for _, r := range rows {
				res.Inserted++
				if r.Revision > 1 {
					res.Corrections = append(res.Corrections, r.OpenTime)
				}
			}
		}
		return nil
	})
	return res, err
}

// SaveIssues stores quality issues; already-known issues are ignored.
func SaveIssues(ctx context.Context, q *db.Queries, symbol string, issues []Issue) error {
	for _, i := range issues {
		var until *time.Time
		if !i.Until.IsZero() {
			until = &i.Until
		}
		err := q.InsertQualityIssue(ctx, db.InsertQualityIssueParams{Symbol: symbol, Kind: string(i.Kind), At: i.At, Until: until, Detail: i.Detail})
		if err != nil {
			return fmt.Errorf("save %s issue: %w", i.Kind, err)
		}
	}
	return nil
}

// Reader is the only way to read bars. Every call takes asOf; nothing with
// AvailableAt > asOf is ever returned (plan §7: the as-of API is the only API).
type Reader struct {
	Q *db.Queries
}

// Query selects bars of one symbol and timeframe with open time in [From, To).
// KnownAt excludes rows ingested later (zero means no limit): it pins a dataset version.
type Query struct {
	Symbol    string
	Timeframe Timeframe
	From, To  time.Time
	AsOf      time.Time
	KnownAt   time.Time
}

// farFuture stands in for "no limit" on time filters.
var farFuture = time.Date(9999, 1, 1, 0, 0, 0, 0, time.UTC)

// Bars returns closed bars available at q.AsOf, resampled to q.Timeframe.
func (r Reader) Bars(ctx context.Context, q Query) ([]Bar, error) {
	known := q.KnownAt
	if known.IsZero() {
		known = farFuture
	}
	d := q.Timeframe.Duration()
	rows, err := r.Q.CandlesAsOf(ctx, db.CandlesAsOfParams{
		Symbol: q.Symbol, FromTime: q.From.Truncate(d), ToTime: q.To, AsOf: q.AsOf, KnownAt: known,
	})
	if err != nil {
		return nil, fmt.Errorf("read %s: %w", q.Symbol, err)
	}
	bars := make([]Bar, len(rows))
	for i, row := range rows {
		bars[i] = Bar{
			Instrument: q.Symbol, OpenTime: row.OpenTime.UTC(), CloseTime: row.CloseTime.UTC(), AvailableAt: row.AvailableAt.UTC(),
			O: price(row.O), H: price(row.H), L: price(row.L), C: price(row.C),
			Volume: money.Qty{V: row.Volume, Scale: instrument.Scale},
		}
	}
	out, err := Resample(bars, q.Timeframe)
	if err != nil {
		return nil, err
	}
	// Belt and braces: resampling never invents availability, but the guarantee is
	// cheap to enforce here, where every read passes.
	kept := out[:0]
	for _, b := range out {
		if !b.AvailableAt.After(q.AsOf) && !b.OpenTime.Before(q.From) {
			kept = append(kept, b)
		}
	}
	return kept, nil
}

// LastClose is the close of the last 1m bar available at asOf (fx.RateSource).
func (r Reader) LastClose(ctx context.Context, symbol string, asOf time.Time) (money.Price, error) {
	c, err := r.Q.LastCloseAsOf(ctx, db.LastCloseAsOfParams{Symbol: symbol, AsOf: asOf})
	if errors.Is(err, pgx.ErrNoRows) {
		return money.Price{}, fmt.Errorf("%w: %s at %s", ErrNoBar, symbol, asOf.Format(time.RFC3339))
	}
	if err != nil {
		return money.Price{}, err
	}
	return price(c), nil
}

func price(v int64) money.Price { return money.Price{V: v, Scale: instrument.Scale} }
