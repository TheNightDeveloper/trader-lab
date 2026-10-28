package api

import (
	"context"
	"net/http"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/proto"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/experiment"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/loop"
	"tradinglab/engine/internal/store/storetest"
)

func TestLearningService(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	require.NoError(t, experiment.SeedLibrary(ctx, st))
	lp := &loop.Loop{Store: st, Clock: clock.Wall{}, Limiter: jobs.NewLimiter(1)}
	srv := serve(t,
		func(m *http.ServeMux) { m.Handle(labv1connect.NewLearningServiceHandler(&Learning{Store: st, Loop: lp})) },
		func(m *http.ServeMux) { m.Handle(labv1connect.NewLibraryServiceHandler(&Library{Store: st})) })
	c := labv1connect.NewLearningServiceClient(srv.Client(), srv.URL)

	got, err := c.GetLearning(ctx, connect.NewRequest(&labv1.GetLearningRequest{}))
	require.NoError(t, err)
	cfg := got.Msg.GetConfig()
	require.Equal(t, "ridge-h4", cfg.GetAlgorithmId(), "defaults")
	require.Equal(t, "200000", cfg.GetGate().GetMaxDrawdown().GetUnits())
	require.ElementsMatch(t, []string{"ridge-h4", "logit-dir-h1"}, got.Msg.GetLearningAlgorithms())
	require.Nil(t, got.Msg.GetCurrent(), "no cycle yet")
	require.False(t, got.Msg.GetCanRollback())

	bad := proto.Clone(cfg).(*labv1.LearningConfig)
	bad.AlgorithmId = "trend-ema"
	_, err = c.SaveConfig(ctx, connect.NewRequest(&labv1.SaveConfigRequest{Config: bad}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err), "a rule algorithm cannot learn")
	bad = proto.Clone(cfg).(*labv1.LearningConfig)
	bad.Gate.MinWalkWins = 9
	_, err = c.SaveConfig(ctx, connect.NewRequest(&labv1.SaveConfigRequest{Config: bad}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err), "more wins than folds")
	cfg.LookbackDays, cfg.Gate.ForwardDays = 30, 7
	_, err = c.SaveConfig(ctx, connect.NewRequest(&labv1.SaveConfigRequest{Config: cfg}))
	require.NoError(t, err)

	// No market data: the cycle skips and says why.
	start, err := c.StartCycle(ctx, connect.NewRequest(&labv1.StartCycleRequest{}))
	require.NoError(t, err)
	var cur *labv1.Cycle
	require.Eventually(t, func() bool {
		r, err := c.GetLearning(ctx, connect.NewRequest(&labv1.GetLearningRequest{}))
		require.NoError(t, err)
		cur = r.Msg.GetCurrent()
		return cur.GetState() == "done"
	}, 20*time.Second, 20*time.Millisecond)
	require.Equal(t, start.Msg.GetCycleId(), cur.GetId())
	require.Equal(t, "skipped", cur.GetOutcome())
	require.Contains(t, cur.GetReason(), "داده تازه ناکافی")
	require.Equal(t, "done", cur.GetSteps()[0].GetStatus(), "collect ran")
	require.Equal(t, "skipped", cur.GetSteps()[1].GetStatus())
	require.EqualValues(t, 7, cur.GetForwardDaysTarget(), "the gate copied at start")

	list, err := c.ListCycles(ctx, connect.NewRequest(&labv1.ListCyclesRequest{}))
	require.NoError(t, err)
	require.EqualValues(t, 1, list.Msg.GetTotal())

	_, err = c.ApproveCycle(ctx, connect.NewRequest(&labv1.ApproveCycleRequest{CycleId: cur.GetId()}))
	require.Equal(t, connect.CodeFailedPrecondition, connect.CodeOf(err), "nothing to approve")
	_, err = c.Rollback(ctx, connect.NewRequest(&labv1.RollbackRequest{}))
	require.Equal(t, connect.CodeFailedPrecondition, connect.CodeOf(err))
	models, err := c.ListModels(ctx, connect.NewRequest(&labv1.ListModelsRequest{}))
	require.NoError(t, err)
	require.Empty(t, models.Msg.GetModels())

	lib := labv1connect.NewLibraryServiceClient(srv.Client(), srv.URL)
	algs, err := lib.ListAlgorithms(ctx, connect.NewRequest(&labv1.ListAlgorithmsRequest{}))
	require.NoError(t, err)
	for _, a := range algs.Msg.GetAlgorithms() {
		if a.GetId() == "ridge-h4" {
			require.Equal(t, "learning", a.GetFamily())
			require.Equal(t, "ret_1, ret_4, ret_24, vol_24, rsi_14", a.GetVersions()[0].GetRecipe()[0].GetValue())
		}
	}
}
