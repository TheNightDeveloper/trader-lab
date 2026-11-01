package data

import (
	"context"
	"encoding/json"
	"fmt"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/store/db"
)

// Old manifests must rebuild the old bytes, while new snapshots use causal availability.
func TestDatasetResampleVersionsRemainReadable(t *testing.T) {
	for _, partial := range []bool{false, true} {
		t.Run(fmt.Sprintf("partial_%v", partial), func(t *testing.T) {
			s := openSeeded(t)
			ctx := context.Background()
			raw := series(30)
			if partial {
				raw = append(raw[:14], raw[15:]...)
			}
			raw[2].AvailableAt = t0.Add(time.Hour)
			_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "test", raw)
			require.NoError(t, err)
			spec := DatasetSpec{"BTCUSDT", TF15m, t0, t0.Add(30 * time.Minute), GapFlag}
			current, bars, err := CreateDataset(ctx, s, spec)
			require.NoError(t, err)
			require.Equal(t, raw[2].AvailableAt, bars[0].AvailableAt)
			require.Equal(t, resampleVersion, current.ResampleVersion)

			legacy := append([]Bar(nil), bars...)
			legacy[0].AvailableAt = t0.Add(15*time.Minute + delay) // v1 used the last member and bucket-end delay
			oldID := HashDataset(spec, legacy)
			require.NotEqual(t, current.ID, oldID)
			manifest, err := json.Marshal(Manifest{Symbol: spec.Symbol, Timeframe: spec.Timeframe, From: spec.From, To: spec.To, GapPolicy: spec.GapPolicy, KnownAt: current.KnownAt, Bars: len(legacy)})
			require.NoError(t, err)
			require.NoError(t, s.InsertDataset(ctx, db.InsertDatasetParams{
				ID: oldID, Symbol: spec.Symbol, Timeframe: string(spec.Timeframe), RangeFrom: spec.From, RangeTo: spec.To,
				GapPolicy: string(spec.GapPolicy), KnownAt: current.KnownAt, BarCount: int32(len(legacy)), Manifest: manifest,
			}))
			for id, want := range map[string][]Bar{oldID: legacy, current.ID: bars} {
				_, loaded, err := LoadDataset(ctx, s, id)
				require.NoError(t, err)
				require.Equal(t, want, loaded)
			}
			repeated, _, err := CreateDataset(ctx, s, spec)
			require.NoError(t, err)
			require.Equal(t, current.ID, repeated.ID)
			row, err := s.GetDataset(ctx, oldID)
			require.NoError(t, err)
			require.JSONEq(t, string(manifest), string(row.Manifest), "reading never rewrites a legacy manifest")

		})
	}
}

func TestManifestRejectsUnknownResampleVersion(t *testing.T) {
	_, err := ParseManifest([]byte(`{"resample_version":99}`))
	require.ErrorContains(t, err, "unsupported resample_version")
}

func TestDatasetDedupKeepsStoredManifestVersion(t *testing.T) {
	s := openSeeded(t)
	ctx := context.Background()
	_, err := UpsertBars(ctx, s, "BTCUSDT", "archive", "test", series(30))
	require.NoError(t, err)
	spec := DatasetSpec{"BTCUSDT", TF15m, t0, t0.Add(30 * time.Minute), GapFlag}
	first, _, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	// No constituent is delayed: legacy and current bars have the same content hash.
	_, err = s.Pool.Exec(ctx, "UPDATE datasets SET manifest = manifest - 'resample_version' WHERE id = $1", first.ID)
	require.NoError(t, err)
	repeated, _, err := CreateDataset(ctx, s, spec)
	require.NoError(t, err)
	require.Equal(t, first.ID, repeated.ID)
	require.Zero(t, repeated.ResampleVersion, "return the actual first-creation manifest version")
}
