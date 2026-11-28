package api

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
)

func TestShadowAttributionReportsFixedPointAndPartialDay(t *testing.T) {
	closed := now.Add(time.Hour)
	result := &sim.Result{Trades: []sim.Trade{
		{ClosedAt: &closed, Net: money.Amount{V: -6}},
		{ClosedAt: &closed, Net: money.Amount{V: 1}},
		{Net: money.Amount{V: 9999}}, // An open mark is outside the closed-trade mean.
	}, Fills: []sim.Fill{
		{Value: money.Amount{V: 100}},
		{Value: money.Amount{V: 200}},
	}}
	metrics := shadowExecutionMetrics(result)
	require.Equal(t, "-2", metrics[0].GetValue().GetUnits())
	require.Equal(t, "300", metrics[1].GetValue().GetUnits())

	common := make([]data.Bar, 25)
	for i := range common {
		open := now.Add(time.Duration(i) * time.Hour)
		common[i] = data.Bar{OpenTime: open, AvailableAt: open.Add(time.Hour + shadowDecisionDelay)}
	}
	result.Equity = []sim.EquityPoint{
		{Time: common[23].AvailableAt, Equity: money.Amount{V: 900}},
		{Time: common[24].AvailableAt, Equity: money.Amount{V: 950}},
	}
	periods := shadowPeriods(common, result, 1000)
	require.Len(t, periods, 2)
	require.EqualValues(t, 24, periods[0].GetSampledHours())
	require.Equal(t, "-100", periods[0].GetNetPnl().GetUnits())
	require.Equal(t, ms(common[24].OpenTime), periods[1].GetFromUnixMs())
	require.EqualValues(t, 1, periods[1].GetSampledHours())
	require.Equal(t, "50", periods[1].GetNetPnl().GetUnits())
}
