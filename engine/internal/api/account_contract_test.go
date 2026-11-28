package api

import (
	"os"
	"testing"

	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
)

func TestAccountSnapshotZeroAndUnavailable(t *testing.T) {
	// The Flutter contract test reads the same sample, including a revision above 2^53.
	fixture, err := os.ReadFile("../../../testdata/contracts/account-snapshot.json")
	require.NoError(t, err)
	var snapshot labv1.AccountSnapshot
	require.NoError(t, protojson.Unmarshal(fixture, &snapshot))
	require.Equal(t, labv1.Environment_ENVIRONMENT_PAPER, snapshot.GetAccount().GetEnvironment())
	require.EqualValues(t, 9007199254740993, snapshot.GetRevision())
	require.Equal(t, "0", snapshot.GetEquity().GetValue().GetUnits())
	require.Nil(t, snapshot.GetEquity().GetUnavailable())
	require.Nil(t, snapshot.GetAvailableBalance().GetValue())
	require.Equal(t, labv1.MoneyAvailability_MONEY_AVAILABILITY_MISSING, snapshot.GetAvailableBalance().GetUnavailable().GetReason())
	require.EqualValues(t, 2, snapshot.GetRiskPolicy().GetRevision())

	wire, err := proto.Marshal(&snapshot)
	require.NoError(t, err)
	var roundTrip labv1.AccountSnapshot
	require.NoError(t, proto.Unmarshal(wire, &roundTrip))
	require.True(t, proto.Equal(&snapshot, &roundTrip))
}
