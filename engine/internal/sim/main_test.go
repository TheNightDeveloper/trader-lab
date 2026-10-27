package sim

import (
	"flag"
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	flag.Parse()
	// The ledger property test runs 1,000 random runs unless -rapid.checks is set.
	if f := flag.Lookup("rapid.checks"); f != nil && f.Value.String() == "100" {
		_ = flag.Set("rapid.checks", "1000")
	}
	os.Exit(m.Run())
}
