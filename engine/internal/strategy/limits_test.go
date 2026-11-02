package strategy

import (
	"math"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestStrategyRejectsUnboundedAndNonFiniteParameters(t *testing.T) {
	for _, p := range []Params{{"period": 1001}, {"period": 1e9}, {"k": math.NaN()}, {"k": math.Inf(1)}, {"exposure": math.NaN()}} {
		_, err := New("mean-rev-bands", p)
		require.Error(t, err, p)
	}
	_, err := New("trend-ema", Params{"fast": 1000, "slow": 1001})
	require.Error(t, err)
}
