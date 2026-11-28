package data

import (
	"context"
	"encoding/json"
	"fmt"
	"sync"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/stdlib"
	"github.com/pressly/goose/v3"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/migrations"
)

// A cutoff timestamp cannot exclude an old ingest transaction that commits late.
func TestSnapshotMembershipSurvivesLateCommit(t *testing.T) {
	for _, index := range []int{50, 59} {
		t.Run(fmt.Sprint(index), func(t *testing.T) {
			s := openSeeded(t)
			ctx := context.Background()
			raw := series(120)
			_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "original", raw)
			require.NoError(t, err)
			tx, err := s.Pool.Begin(ctx)
			require.NoError(t, err)
			defer func() { _ = tx.Rollback(ctx) }()
			b := raw[index]
			_, err = db.New(tx).UpsertCandles(ctx, db.UpsertCandlesParams{
				Symbol: "BTCUSDT", Source: "archive", SourceRef: "late-commit",
				OpenTimes: []time.Time{b.OpenTime}, CloseTimes: []time.Time{b.CloseTime}, AvailableAts: []time.Time{b.AvailableAt},
				Os: []int64{b.O.V}, Hs: []int64{b.H.V}, Ls: []int64{b.L.V}, Cs: []int64{b.C.V + 1}, Volumes: []int64{b.Volume.V},
			})
			require.NoError(t, err)
			spec := DatasetSpec{"BTCUSDT", TF15m, t0, t0.Add(120 * time.Minute), GapFlag}
			before, bars, err := CreateDataset(ctx, s, spec)
			require.NoError(t, err)
			require.NoError(t, tx.Commit(ctx))
			_, loaded, err := LoadDataset(ctx, s, before.ID)
			require.NoError(t, err, "late commit cannot change the snapshot's revision membership")
			require.Equal(t, bars, loaded)
			after, _, err := CreateDataset(ctx, s, spec)
			require.NoError(t, err)
			require.NotEqual(t, before.ID, after.ID, "new visible revision is a different snapshot even if aggregation hides its close")
		})
	}
}

func TestLegacyAndSnapshotFormatsRemainIndependent(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	raw := series(60)
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "original", raw)
	require.NoError(t, err)
	spec := DatasetSpec{"BTCUSDT", TF15m, t0, t0.Add(time.Hour), GapFlag}
	known, err := s.DBNow(ctx)
	require.NoError(t, err)
	oldBars, _, err := datasetBars(ctx, s.Queries, spec, known, false)
	require.NoError(t, err)
	oldID := HashDataset(spec, oldBars)
	manifest, err := json.Marshal(Manifest{ResampleVersion: resampleVersion, Symbol: spec.Symbol, Timeframe: spec.Timeframe, From: spec.From, To: spec.To, GapPolicy: spec.GapPolicy, KnownAt: known, Bars: len(oldBars)})
	require.NoError(t, err)
	require.NoError(t, s.InsertDataset(ctx, db.InsertDatasetParams{ID: oldID, Symbol: spec.Symbol, Timeframe: string(spec.Timeframe), RangeFrom: spec.From, RangeTo: spec.To, GapPolicy: string(spec.GapPolicy), KnownAt: known, BarCount: int32(len(oldBars)), Manifest: manifest}))
	current, bars, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	require.NotEqual(t, oldID, current.ID)
	require.Equal(t, oldBars, bars)
	for _, id := range []string{oldID, current.ID} {
		_, loaded, err := LoadDataset(ctx, s, id)
		require.NoError(t, err)
		require.Equal(t, bars, loaded)
	}
	row, err := s.GetDataset(ctx, oldID)
	require.NoError(t, err)
	require.JSONEq(t, string(manifest), string(row.Manifest))
	// Missing membership is corruption, never an invitation to reconstruct it
	// from a newer timestamp cutoff.
	_, err = s.Pool.Exec(ctx, "DELETE FROM dataset_members WHERE dataset_id=$1 AND open_time=$2", current.ID, raw[20].OpenTime)
	require.NoError(t, err)
	_, _, err = LoadDataset(ctx, s, current.ID)
	require.ErrorIs(t, err, ErrDatasetChanged)
	_, err = ParseManifest([]byte(`{"format_version":99}`))
	require.ErrorContains(t, err, "format_version")
}

func TestConcurrentSnapshotDedupIsAtomic(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "original", series(120))
	require.NoError(t, err)
	spec := DatasetSpec{"BTCUSDT", TF15m, t0, t0.Add(2 * time.Hour), GapFlag}
	var wg sync.WaitGroup
	const n = 4
	ids := make([]string, n)
	errs := make([]error, n)
	start := make(chan struct{})
	for i := range n {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			var ds Dataset
			ds, _, errs[i] = CreateDataset(ctx, s, spec)
			ids[i] = ds.ID
		}()
	}
	close(start)
	wg.Wait()
	for i := range n {
		require.NoError(t, errs[i])
		require.Equal(t, ids[0], ids[i])
	}
	var members int
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT count(*) FROM dataset_members WHERE dataset_id=$1", ids[0]).Scan(&members))
	require.Equal(t, 120, members)
	_, _, err = LoadDataset(ctx, s, ids[0])
	require.NoError(t, err)
}

func TestSnapshotWriteFailureDoesNotPersistPartialVersion(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "original", series(20))
	require.NoError(t, err)
	_, err = s.Pool.Exec(ctx, `CREATE FUNCTION reject_members() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN RAISE EXCEPTION 'membership write failure'; END $$;
CREATE TRIGGER reject_members BEFORE INSERT ON dataset_members FOR EACH ROW EXECUTE FUNCTION reject_members();`)
	require.NoError(t, err)
	_, _, err = CreateDataset(ctx, s, DatasetSpec{"BTCUSDT", TF1m, t0, t0.Add(20 * time.Minute), GapFlag})
	require.Error(t, err)
	n, err := s.CountDatasets(ctx)
	require.NoError(t, err)
	require.Zero(t, n)
}

func TestConcurrentIngestKeepsEveryCorrectionRevision(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	raw := series(60)
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "original", raw)
	require.NoError(t, err)
	var wg sync.WaitGroup
	errs := make([]error, 2)
	start := make(chan struct{})
	for i := range 2 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			b := raw[10]
			b.C.V += int64(i + 1)
			<-start
			_, errs[i] = UpsertBars(ctx, s, "BTCUSDT", "archive", "correction", []Bar{b})
		}()
	}
	close(start)
	wg.Wait()
	for _, err := range errs {
		require.NoError(t, err)
	}
	var count, maxRevision int
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT count(*),max(revision) FROM candles WHERE symbol='BTCUSDT' AND open_time=$1", raw[10].OpenTime).Scan(&count, &maxRevision))
	require.Equal(t, 3, count)
	require.Equal(t, 3, maxRevision)
}

func TestArchiveReimportCannotBackdateObservedAvailability(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	raw := series(20)
	raw[2].AvailableAt = raw[2].AvailableAt.Add(time.Hour)
	_, err := UpsertBars(ctx, s, "BTCUSDT", "rest", "late-observation", raw)
	require.NoError(t, err)
	spec := DatasetSpec{"BTCUSDT", TF1m, t0, t0.Add(20 * time.Minute), GapFlag}
	before, _, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	up, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "publication-assumption", series(20))
	require.NoError(t, err)
	require.Zero(t, up.Inserted, "same-value reimport cannot assert an earlier observation")
	after, bars, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	require.Equal(t, before.ID, after.ID)
	require.Equal(t, raw[2].AvailableAt, bars[2].AvailableAt)
}

func TestConcurrentSymbolsCreateOneMonthPartition(t *testing.T) {
	s := openSeeded(t)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	var wg sync.WaitGroup
	errs := make([]error, 2)
	start := make(chan struct{})
	for i, symbol := range []string{"BTCUSDT", "ETHUSDT"} {
		wg.Add(1)
		go func() {
			defer wg.Done()
			raw := series(60)
			for j := range raw {
				raw[j].Instrument = symbol
			}
			<-start
			_, errs[i] = UpsertBars(ctx, s, symbol, "archive", "concurrent", raw)
		}()
	}
	close(start)
	wg.Wait()
	for _, err := range errs {
		require.NoError(t, err)
	}
	var count int
	require.NoError(t, s.Pool.QueryRow(ctx, "SELECT count(*) FROM candles").Scan(&count))
	require.Equal(t, 120, count)
}

func TestSnapshotMigrationPreservesLegacyRecords(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	raw := series(30)
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "legacy", raw)
	require.NoError(t, err)
	spec := DatasetSpec{"BTCUSDT", TF1m, t0, t0.Add(30 * time.Minute), GapFlag}
	known, err := s.DBNow(ctx)
	require.NoError(t, err)
	id := HashDataset(spec, raw)
	manifest, err := json.Marshal(Manifest{ResampleVersion: resampleVersion, Symbol: spec.Symbol, Timeframe: spec.Timeframe, From: spec.From, To: spec.To, GapPolicy: spec.GapPolicy, KnownAt: known, Bars: len(raw)})
	require.NoError(t, err)
	require.NoError(t, s.InsertDataset(ctx, db.InsertDatasetParams{ID: id, Symbol: spec.Symbol, Timeframe: string(spec.Timeframe), RangeFrom: spec.From, RangeTo: spec.To, GapPolicy: string(spec.GapPolicy), KnownAt: known, BarCount: int32(len(raw)), Manifest: manifest}))
	sqlDB := stdlib.OpenDBFromPool(s.Pool)
	defer func() { _ = sqlDB.Close() }()
	p, err := goose.NewProvider(goose.DialectPostgres, sqlDB, migrations.FS)
	require.NoError(t, err)
	// Only legacy records exist here: exercise the actual v6 down/up migration
	// against populated data rather than fabricating a new-format old manifest.
	_, err = p.DownTo(ctx, 5)
	require.NoError(t, err)
	_, err = p.Up(ctx)
	require.NoError(t, err)
	row, err := s.GetDataset(ctx, id)
	require.NoError(t, err)
	require.JSONEq(t, string(manifest), string(row.Manifest))
	ds, bars, err := LoadDataset(ctx, s, id)
	require.NoError(t, err)
	require.Zero(t, ds.FormatVersion)
	require.Equal(t, raw, bars)
}

func TestAvailabilityOnlyCorrectionIsRevisioned(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	raw := series(10)
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "original", raw)
	require.NoError(t, err)
	spec := DatasetSpec{"BTCUSDT", TF1m, t0, t0.Add(10 * time.Minute), GapFlag}
	before, bs, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	raw[2].AvailableAt = raw[2].AvailableAt.Add(time.Hour)
	up, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "availability-correction", raw)
	require.NoError(t, err)
	require.Equal(t, 1, up.Inserted)
	_, old, err := LoadDataset(ctx, s, before.ID)
	require.NoError(t, err)
	require.Equal(t, bs, old)
	after, _, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	require.NotEqual(t, before.ID, after.ID)
}
