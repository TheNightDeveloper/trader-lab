package storetest

import (
	"os"
	"os/exec"
	"testing"

	"github.com/stretchr/testify/require"
)

// Exercise the real testing.T path in a subprocess: a skipped DB is not a CI pass.
func TestUnavailableDatabase(t *testing.T) {
	if os.Getenv("STORETEST_DB_PROBE") == "1" {
		Open(t)
		return
	}
	for _, required := range []string{"0", "1"} {
		t.Run("required_"+required, func(t *testing.T) {
			t.Setenv("STORETEST_DB_PROBE", "1")
			t.Setenv("DATABASE_URL", "postgres://lab:lab@127.0.0.1:1/lab?sslmode=disable&connect_timeout=1")
			t.Setenv("REQUIRE_DB", required)
			out, err := exec.Command(os.Args[0], "-test.run=^TestUnavailableDatabase$", "-test.v").CombinedOutput()
			if required == "1" {
				require.Error(t, err, string(out))
				require.Contains(t, string(out), "database required")
				require.NotContains(t, string(out), "--- SKIP")
			} else {
				require.NoError(t, err, string(out))
				require.Contains(t, string(out), "--- SKIP")
			}
		})
	}
}
