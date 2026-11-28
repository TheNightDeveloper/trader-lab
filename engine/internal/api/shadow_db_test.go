package api

import (
	"context"
	"encoding/json"
	"errors"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"golang.org/x/sync/errgroup"

	"tradinglab/engine/internal/assistant"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store/db"
)

func TestShadowRegistersBeforeLiveEvidenceAndAttributesTracks(t *testing.T) {
	ctx := context.Background()
	market, wall, _, opportunityID := paperFixture(t)
	st := market.Store
	opp, err := st.RecordedMarketOpportunity(ctx, opportunityID)
	require.NoError(t, err)
	const unit = paperTestUnit
	addHour := func(open time.Time, units int64) {
		t.Helper()
		p := money.Price{V: units * unit, Scale: instrument.Scale}
		minutes := make([]data.Bar, 60)
		for i := range minutes {
			at := open.Add(time.Duration(i) * time.Minute)
			minutes[i] = data.Bar{Instrument: opp.Symbol, OpenTime: at, CloseTime: at.Add(time.Minute),
				AvailableAt: at.Add(time.Minute), O: p, H: p, L: p, C: p}
		}
		_, err := data.UpsertBars(ctx, st, opp.Symbol, "rest", "shadow-fixture", minutes)
		require.NoError(t, err)
	}
	previous := now.Add(-time.Hour)
	addHour(previous, 100)
	dataset, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{Symbol: opp.Symbol, Timeframe: data.TF1h, From: previous, To: now, GapPolicy: data.GapStop})
	require.NoError(t, err)
	spec, err := json.Marshal(eval.Spec{DatasetIDs: []string{dataset.ID}, RuleVersionID: opp.RuleVersionID, Timeframe: data.TF1h,
		FillModel: sim.FillModel, Sim: sim.Config{Capital: money.Amount{V: 1000 * unit, Asset: instrument.USDT}, FeeRate: 1000, SlipRate: 500}})
	require.NoError(t, err)
	empty := []byte(`{}`)
	require.NoError(t, st.InsertReport(ctx, db.InsertReportParams{ID: "shadow-report", Spec: spec, Split: empty, Evaluation: empty, Holdout: empty}))
	calls := 0
	a := &Assistant{Store: st, Clock: wall, DailyRequests: 8, Provider: assistantFunc(func(_ context.Context, r assistant.Request) (string, *assistant.Usage, error) {
		require.Equal(t, assistant.ShadowPromptVersion, r.Version())
		calls++
		switch calls {
		case 1:
			return `{"focus":"block"}`, &assistant.Usage{InputTokens: 100, OutputTokens: 8}, nil
		case 2:
			return `{"focus":"allow"}`, &assistant.Usage{InputTokens: 100, OutputTokens: 8}, nil
		default:
			return "", nil, errors.New("fixture provider unavailable")
		}
	})}
	s := &Shadow{Market: market, Assistant: a, ModelRates: &ShadowModelRates{InputPerMillion: unit, OutputPerMillion: 2 * unit}}
	startReq := connect.NewRequest(&labv1.StartShadowDeploymentRequest{Symbol: opp.Symbol, RuleVersionId: opp.RuleVersionID, UserTrack: true})
	start, err := s.StartShadowDeployment(ctx, startReq)
	require.NoError(t, err)
	duplicate, err := s.StartShadowDeployment(ctx, startReq)
	require.NoError(t, err)
	require.Equal(t, start.Msg.GetDeploymentId(), duplicate.Msg.GetDeploymentId())
	withoutUser := connect.NewRequest(&labv1.StartShadowDeploymentRequest{Symbol: opp.Symbol, RuleVersionId: opp.RuleVersionID})
	_, err = s.StartShadowDeployment(ctx, withoutUser)
	require.Equal(t, connect.CodeFailedPrecondition, code(err), "a retry cannot change the frozen policies")
	s.ModelRates.InputPerMillion = 9 * unit
	read := func() *labv1.GetShadowSnapshotResponse {
		t.Helper()
		r, err := s.GetShadowSnapshot(ctx, connect.NewRequest(&labv1.GetShadowSnapshotRequest{DeploymentId: start.Msg.GetDeploymentId()}))
		require.NoError(t, err)
		return r.Msg
	}
	registered := read().GetSelected()
	tradeStart := time.UnixMilli(registered.GetStartAtUnixMs()).UTC()
	require.True(t, tradeStart.After(wall.Now()))
	require.Equal(t, "shadow-report", registered.GetReportId())
	require.Equal(t, "100000000000", registered.GetCapital().GetUnits())
	require.True(t, registered.GetUserTrack())
	require.Equal(t, "100000000", registered.GetModelInputPerMillion().GetUnits())
	require.NoError(t, s.advanceShadow(ctx))
	require.Zero(t, calls)
	require.Empty(t, read().GetObservations(), "past paper opportunity remains outside the shadow")

	decide := func(observation int64, allow bool) (*connect.Response[labv1.SetShadowUserDecisionResponse], error) {
		return s.SetShadowUserDecision(ctx, connect.NewRequest(&labv1.SetShadowUserDecisionRequest{
			DeploymentId: start.Msg.GetDeploymentId(), ObservationId: observation, Allow: &allow,
		}))
	}
	observe := func(index int, price int64, decideBeforeCutoff func(int64)) int64 {
		t.Helper()
		open := tradeStart.Add(time.Duration(index) * time.Hour)
		close := open.Add(time.Hour)
		addHour(open, price)
		market.Live = fakeLive{data.LiveStatus{Symbols: []data.LiveSymbolStatus{{Symbol: opp.Symbol, State: data.LiveFresh, LastClose: close}}}}
		require.NoError(t, wall.Set(close.Add(time.Second)))
		require.NoError(t, s.advanceShadow(ctx))
		require.NoError(t, s.advanceShadow(ctx))
		observation := read().GetObservations()[0]
		if decideBeforeCutoff != nil {
			require.Equal(t, labv1.ShadowUserDecision_SHADOW_USER_DECISION_OPEN, observation.GetUserDecision())
			decideBeforeCutoff(observation.GetId())
		}
		require.NoError(t, wall.Set(close.Add(shadowDecisionDelay)))
		return observation.GetId()
	}
	var acceptedAt int64
	first := observe(0, 110, func(id int64) {
		var receipts [2]int64
		var racing errgroup.Group
		for i := range receipts {
			racing.Go(func() error {
				accepted, err := decide(id, true)
				if err == nil {
					receipts[i] = accepted.Msg.GetDecidedAtUnixMs()
				}
				return err
			})
		}
		require.NoError(t, racing.Wait())
		require.Equal(t, receipts[0], receipts[1])
		acceptedAt = receipts[0]
	})
	retry, err := decide(first, true)
	require.NoError(t, err)
	require.Equal(t, acceptedAt, retry.Msg.GetDecidedAtUnixMs())
	_, err = decide(first, false)
	require.Equal(t, connect.CodeAlreadyExists, code(err))
	observe(1, 111, func(id int64) {
		_, err := decide(id, false)
		require.NoError(t, err)
	})
	missed := observe(2, 112, nil)
	_, err = decide(missed, true)
	require.Equal(t, connect.CodeFailedPrecondition, code(err), "the exact cutoff is exclusive")
	result := read()
	require.EqualValues(t, 3, result.GetSampledHours())
	require.EqualValues(t, 1, result.GetBaseline().GetEntries())
	require.Zero(t, result.GetAi().GetEntries(), "the allowed second signal cannot fill at its already-open next hour")
	require.EqualValues(t, 1, result.GetUser().GetEntries())
	require.Equal(t, labv1.ShadowUserDecision_SHADOW_USER_DECISION_UNANSWERED, result.GetObservations()[0].GetUserDecision())
	require.Equal(t, labv1.ShadowUserDecision_SHADOW_USER_DECISION_SKIP, result.GetObservations()[1].GetUserDecision())
	require.Equal(t, acceptedAt, result.GetObservations()[2].GetUserDecidedAtUnixMs())
	require.Equal(t, ms(tradeStart.Add(2*time.Hour)), result.GetObservations()[2].GetUserEntry().GetFilledAtUnixMs())
	require.Equal(t, labv1.ShadowGate_SHADOW_GATE_UNAVAILABLE, result.GetObservations()[0].GetGate())
	addHour(tradeStart, 999)
	require.Equal(t, "11000000000", read().GetObservations()[2].GetReferenceClose().GetUnits(), "later revisions do not alter captured evidence")

	// An unavailable gate cannot veto the exit on either track.
	observe(3, 80, nil)
	observe(4, 81, nil)
	observe(5, 82, nil)
	result = read()
	for _, track := range []*labv1.ShadowTrack{result.GetBaseline(), result.GetAi(), result.GetUser()} {
		require.EqualValues(t, 1, track.GetEntries())
		var closed string
		for _, m := range track.GetMetrics() {
			if m.GetKey() == "closed_trades" {
				closed = m.GetValue().GetUnits()
			}
		}
		require.Equal(t, "1", closed)
		require.EqualValues(t, 6, track.GetPeriods()[0].GetSampledHours())
	}
	require.EqualValues(t, 1, result.GetAi().GetAttribution().GetBaselineOnlyEntries())
	require.EqualValues(t, 1, result.GetAi().GetAttribution().GetTrackOnlyEntries())
	require.EqualValues(t, 1, result.GetUser().GetAttribution().GetSharedEntries())
	require.Equal(t, "0", result.GetUser().GetAttribution().GetNetPnlDelta().GetUnits())
	require.NotEqual(t, "0", result.GetAi().GetAttribution().GetNetPnlDelta().GetUnits())
	require.EqualValues(t, 200, result.GetInputTokens())
	require.EqualValues(t, 3, result.GetModelAttempts())
	require.EqualValues(t, 1, result.GetMissingModelUsage())
	require.Equal(t, "23200", result.GetEstimatedModelCost().GetUnits(), "the estimate uses frozen rates and known tokens")
	require.Equal(t, 3, calls)

	missing := tradeStart.Add(7 * time.Hour)
	require.NoError(t, wall.Set(missing.Add(shadowDecisionDelay)))
	require.NoError(t, s.advanceShadow(ctx))
	require.Equal(t, labv1.ShadowState_SHADOW_STATE_GAP, read().GetSelected().GetState())
	addHour(missing.Add(-time.Hour), 120)
	require.NoError(t, s.advanceShadow(ctx))
	require.EqualValues(t, 6, read().GetSampledHours())
	var paperEntries int
	require.NoError(t, st.Pool.QueryRow(ctx, `SELECT count(*) FROM paper_entries`).Scan(&paperEntries))
	require.Zero(t, paperEntries)
	newRun, err := s.StartShadowDeployment(ctx, withoutUser)
	require.NoError(t, err)
	stop := connect.NewRequest(&labv1.StopShadowDeploymentRequest{DeploymentId: newRun.Msg.GetDeploymentId()})
	_, err = s.StopShadowDeployment(ctx, stop)
	require.NoError(t, err)
	_, err = s.StopShadowDeployment(ctx, stop)
	require.NoError(t, err)
	stopped, err := s.GetShadowSnapshot(ctx, connect.NewRequest(&labv1.GetShadowSnapshotRequest{DeploymentId: newRun.Msg.GetDeploymentId()}))
	require.NoError(t, err)
	require.Equal(t, labv1.ShadowState_SHADOW_STATE_STOPPED, stopped.Msg.GetSelected().GetState())
	require.False(t, stopped.Msg.GetSelected().GetUserTrack())
}
