package paper

import (
	"testing"

	"github.com/stretchr/testify/require"
	"tradinglab/engine/internal/instrument"
)

func TestSpotPlanBoundsAdverseFillAndCosts(t *testing.T) {
	const unit = 100_000_000
	spec := instrument.Defaults()[0]
	cost := Costs{Fee: 1_000, Slippage: 2_000}
	in := PlanInput{
		Reference: 100 * unit, EntryLimit: 101 * unit, Stop: 90 * unit, TakeProfit: 120 * unit,
		Cash: 1_000 * unit, NotionalBudget: 250 * unit, LossBudget: 5 * unit, MaxCost: 10_000,
	}
	size, err := SizePlan(spec, cost, in)
	require.NoError(t, err)
	require.EqualValues(t, 10020*unit/100, size.EntryPrice)
	require.Zero(t, size.Quantity%spec.Lot.V)
	entry, err := cost.atPrice(true, in.EntryLimit, size.Quantity)
	require.NoError(t, err)
	stop, err := cost.Fill(spec, false, in.Stop, size.Quantity)
	require.NoError(t, err)
	require.Equal(t, entry.Cash, size.ReservedCash)
	require.Equal(t, entry.Cash-stop.Cash, size.PlannedLoss)
	require.LessOrEqual(t, size.PlannedLoss, in.LossBudget)
	require.Less(t, size.PlannedLoss, size.ReservedCash)
	require.Positive(t, size.EstimatedCost)
	in.MaxCost = 1_000
	_, err = SizePlan(spec, cost, in)
	require.ErrorIs(t, err, ErrCost)
	in.TakeProfit = in.EntryLimit
	_, err = SizePlan(spec, cost, in)
	require.ErrorIs(t, err, ErrLevels)
	in.TakeProfit = 120 * unit
	in.Cash = unit
	_, err = SizePlan(spec, cost, in)
	require.ErrorIs(t, err, ErrBudget)
}
