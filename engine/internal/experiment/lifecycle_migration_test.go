package experiment

import (
	"context"
	"testing"

	"github.com/jackc/pgx/v5/stdlib"
	"github.com/pressly/goose/v3"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/store/storetest"
	"tradinglab/engine/migrations"
)

func TestLifecycleMigrationPreservesOrRejectsLegacyState(t *testing.T) {
	for _, ambiguous := range []bool{false, true} {
		t.Run(map[bool]string{false: "single champion", true: "ambiguous champions"}[ambiguous], func(t *testing.T) {
			ctx := context.Background()
			st := storetest.Open(t)
			sqlDB := stdlib.OpenDBFromPool(st.Pool)
			defer func() { _ = sqlDB.Close() }()
			provider, err := goose.NewProvider(goose.DialectPostgres, sqlDB, migrations.FS)
			require.NoError(t, err)
			_, err = provider.DownTo(ctx, 6)
			require.NoError(t, err)
			_, err = st.Pool.Exec(ctx, `INSERT INTO algorithms (id,family,description) VALUES ('legacy','benchmark','unchanged');
  INSERT INTO algorithm_versions (id,algorithm_id,version,content_hash,definition,state) VALUES ('legacy@v1','legacy',1,'first','{"strategy":"hold-cash"}','active')`)
			require.NoError(t, err)
			if ambiguous {
				_, err = st.Pool.Exec(ctx, `INSERT INTO algorithm_versions (id,algorithm_id,version,content_hash,definition,state) VALUES ('legacy@v2','legacy',2,'second','{"strategy":"hold-cash"}','active')`)
				require.NoError(t, err)
			}
			_, err = provider.Up(ctx)
			if ambiguous {
				require.Error(t, err)
				var n int
				require.NoError(t, st.Pool.QueryRow(ctx, "SELECT count(*) FROM algorithm_versions WHERE state='active'").Scan(&n))
				require.Equal(t, 2, n)
			} else {
				require.NoError(t, err)
				a, err := st.GetAlgorithm(ctx, "legacy")
				require.NoError(t, err)
				require.Zero(t, a.LifecycleRevision)
				require.Equal(t, "unchanged", a.Description)
				version, err := st.GetAlgorithmVersion(ctx, "legacy@v1")
				require.NoError(t, err)
				require.Equal(t, Active, version.State)
				require.Equal(t, "first", version.ContentHash)
			}
		})
	}
}
