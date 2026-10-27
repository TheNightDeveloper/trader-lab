package clock

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func TestVirtualMonotonic(t *testing.T) {
	t0 := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	v := NewVirtual(t0)
	require.Equal(t, t0, v.Now())
	require.NoError(t, v.Set(t0.Add(time.Minute)))
	require.NoError(t, v.Set(t0.Add(time.Minute)), "same instant is allowed")
	require.Error(t, v.Set(t0))
	require.Equal(t, t0.Add(time.Minute), v.Now(), "failed Set leaves time unchanged")
}

func TestWallIsUTC(t *testing.T) {
	require.Equal(t, time.UTC, Wall{}.Now().Location())
}
