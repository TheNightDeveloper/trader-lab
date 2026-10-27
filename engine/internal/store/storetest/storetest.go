// Package storetest gives each test its own migrated schema in the dev database.
package storetest

import (
	"context"
	"fmt"
	"math/rand/v2"
	"net/url"
	"os"
	"testing"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/store"
)

// DefaultURL matches docker-compose.yml and the local `lab` role.
const DefaultURL = "postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable"

// Open returns a Store on a fresh schema that is dropped when the test ends.
// Without a reachable database the test is skipped, unless REQUIRE_DB=1 (CI).
func Open(t testing.TB) *store.Store {
	t.Helper()
	base := os.Getenv("DATABASE_URL")
	if base == "" {
		base = DefaultURL
	}
	ctx := context.Background()
	admin, err := pgx.Connect(ctx, base)
	if err != nil {
		if os.Getenv("REQUIRE_DB") == "1" {
			t.Fatalf("database required: %v", err)
		}
		t.Skipf("no database (%v); set DATABASE_URL or start PostgreSQL", err)
	}
	schema := fmt.Sprintf("test_%d", rand.Uint64())
	if _, err := admin.Exec(ctx, "CREATE SCHEMA "+schema); err != nil {
		t.Fatalf("create schema: %v", err)
	}
	t.Cleanup(func() {
		_, _ = admin.Exec(context.Background(), "DROP SCHEMA "+schema+" CASCADE")
		_ = admin.Close(context.Background())
	})

	u, err := url.Parse(base)
	if err != nil {
		t.Fatal(err)
	}
	q := u.Query()
	q.Set("search_path", schema)
	u.RawQuery = q.Encode()
	s, err := store.Open(ctx, u.String())
	if err != nil {
		t.Fatalf("open store: %v", err)
	}
	t.Cleanup(s.Close)
	return s
}
