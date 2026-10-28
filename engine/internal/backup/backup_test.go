package backup

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
)

func TestNightlyOncePerDayAfterTheHourAndPruned(t *testing.T) {
	dir := t.TempDir()
	clk := clock.NewVirtual(time.Date(2026, 10, 1, 1, 0, 0, 0, time.UTC))
	dumps := 0
	n := &Nightly{Dir: dir, HourUTC: 2, Keep: 3, Clock: clk, Dump: func(_ context.Context, _, file string) error {
		dumps++
		return os.WriteFile(file, []byte("dump"), 0o600)
	}}
	ctx := context.Background()
	f, err := n.Tick(ctx)
	require.NoError(t, err)
	require.Empty(t, f, "before the hour")

	for d := range 5 {
		require.NoError(t, clk.Set(time.Date(2026, 10, 1+d, 3, 0, 0, 0, time.UTC)))
		f, err = n.Tick(ctx)
		require.NoError(t, err)
		require.Equal(t, filepath.Join(dir, time.Date(2026, 10, 1+d, 0, 0, 0, 0, time.UTC).Format("lab-20060102.dump")), f)
		f, err = n.Tick(ctx)
		require.NoError(t, err)
		require.Empty(t, f, "once per day")
	}
	require.Equal(t, 5, dumps)
	left, _ := filepath.Glob(filepath.Join(dir, "lab-*.dump"))
	require.Len(t, left, 3, "newest three kept")
	require.Equal(t, filepath.Join(dir, "lab-20261003.dump"), left[0])

	// A failed dump leaves nothing that looks like a backup.
	require.NoError(t, clk.Set(time.Date(2026, 10, 9, 3, 0, 0, 0, time.UTC)))
	n.Dump = func(_ context.Context, _, file string) error {
		_ = os.WriteFile(file, []byte("half"), 0o600)
		return errors.New("disk full")
	}
	_, err = n.Tick(ctx)
	require.Error(t, err)
	_, err = os.Stat(filepath.Join(dir, "lab-20261009.dump"))
	require.True(t, os.IsNotExist(err))
	_, err = os.Stat(filepath.Join(dir, "lab-20261009.dump.partial"))
	require.True(t, os.IsNotExist(err))
}
