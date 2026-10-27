package api

import (
	"context"
	"net/http"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/proto"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/experiment"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/search"
	"tradinglab/engine/internal/store/storetest"
)

func TestExperimentAndLibraryServices(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	require.NoError(t, experiment.SeedLibrary(ctx, st))
	bars := waveBars(6000)
	_, err := data.UpsertBars(ctx, st, "BTCUSDT", "archive", "t", bars)
	require.NoError(t, err)
	ds, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{Symbol: "BTCUSDT", Timeframe: data.TF1m, From: bars[0].OpenTime, To: bars[len(bars)-1].CloseTime, GapPolicy: data.GapFlag})
	require.NoError(t, err)

	lim := jobs.NewLimiter(2)
	sched := &search.Scheduler{Store: st, Reports: report.Service{Store: st, Version: "test", Parallel: 2}, Limiter: lim, Build: "test", Poll: 20 * time.Millisecond}
	runCtx, stop := context.WithCancel(ctx)
	defer stop()
	go func() { _ = sched.Run(runCtx) }()

	srv := serve(t,
		func(m *http.ServeMux) {
			m.Handle(labv1connect.NewExperimentServiceHandler(&Experiment{Store: st, Scheduler: sched, Limiter: lim, Every: 50 * time.Millisecond}))
		},
		func(m *http.ServeMux) { m.Handle(labv1connect.NewLibraryServiceHandler(&Library{Store: st})) })
	ec := labv1connect.NewExperimentServiceClient(srv.Client(), srv.URL)
	lc := labv1connect.NewLibraryServiceClient(srv.Client(), srv.URL)

	def := &labv1.ExperimentDefinition{
		Name: "api", Hypothesis: "h", Falsifier: "f",
		Objective:        &labv1.Objective{Metric: "total_return", Maximize: true},
		Constraints:      []*labv1.Constraint{{Metric: "max_drawdown", Op: "<=", Value: "0.5"}},
		DatasetIds:       []string{ds.ID},
		AlgorithmVersion: "trend-ema@v1",
		Space:            map[string]*labv1.ParamRange{"fast": {Values: []float64{5, 10}}, "slow": {Values: []float64{30, 60}}},
		Search:           &labv1.SearchPlan{Mode: "grid", MaxAttempts: 10, MaxWallSeconds: 600},
		Capital:          usdtMoney("1000"), Fee: dec("0.001"), Slippage: dec("0.0005"), Folds: 3,
	}

	est, err := ec.Estimate(ctx, connect.NewRequest(&labv1.EstimateRequest{Definition: def}))
	require.NoError(t, err)
	require.Empty(t, est.Msg.GetError())
	require.EqualValues(t, 4, est.Msg.GetAttempts())
	require.EqualValues(t, 4, est.Msg.GetCandidates())

	tooBig := proto.Clone(def).(*labv1.ExperimentDefinition)
	tooBig.Search = &labv1.SearchPlan{Mode: "grid", MaxAttempts: 3, MaxWallSeconds: 600}
	est, err = ec.Estimate(ctx, connect.NewRequest(&labv1.EstimateRequest{Definition: tooBig}))
	require.NoError(t, err)
	require.Contains(t, est.Msg.GetError(), "over the budget", "validation errors come back inline")
	noHyp := proto.Clone(def).(*labv1.ExperimentDefinition)
	noHyp.Hypothesis = ""
	_, err = ec.CreateExperiment(ctx, connect.NewRequest(&labv1.CreateExperimentRequest{Definition: noHyp}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))

	created, err := ec.CreateExperiment(ctx, connect.NewRequest(&labv1.CreateExperimentRequest{Definition: def}))
	require.NoError(t, err)
	id := created.Msg.GetExperimentId()
	again, err := ec.CreateExperiment(ctx, connect.NewRequest(&labv1.CreateExperimentRequest{Definition: def}))
	require.NoError(t, err)
	require.True(t, again.Msg.GetAlreadyExisted())
	require.Equal(t, id, again.Msg.GetExperimentId())

	watch, err := ec.WatchExperiment(ctx, connect.NewRequest(&labv1.WatchExperimentRequest{ExperimentId: id}))
	require.NoError(t, err)
	var last *labv1.WatchExperimentResponse
	for watch.Receive() {
		last = watch.Msg()
	}
	require.NoError(t, watch.Err())
	require.Equal(t, "done", last.GetStatus(), "the stream ends when the experiment does")
	require.EqualValues(t, 4, last.GetCounts().GetDone())
	require.EqualValues(t, 2, last.GetResearchSlots())

	got, err := ec.GetExperiment(ctx, connect.NewRequest(&labv1.GetExperimentRequest{ExperimentId: id}))
	require.NoError(t, err)
	require.Positive(t, got.Msg.GetResult().GetChosen())
	require.Len(t, got.Msg.GetResult().GetReportIds(), 1)
	require.Equal(t, "api", got.Msg.GetDefinition().GetName())
	require.Equal(t, "200000", got.Msg.GetDefinition().GetHoldout().GetUnits(), "defaults stored")

	atts, err := ec.ListAttempts(ctx, connect.NewRequest(&labv1.ListAttemptsRequest{ExperimentId: id, Status: "done", PageSize: 2}))
	require.NoError(t, err)
	require.EqualValues(t, 4, atts.Msg.GetTotal())
	require.Len(t, atts.Msg.GetAttempts(), 2, "server-side pages")
	a := atts.Msg.GetAttempts()[0]
	require.True(t, a.GetHasEligibility())
	require.NotNil(t, a.GetTotalReturn())
	require.Equal(t, "miss", a.GetCache())

	_, err = ec.PauseExperiment(ctx, connect.NewRequest(&labv1.PauseExperimentRequest{ExperimentId: id}))
	require.Equal(t, connect.CodeFailedPrecondition, connect.CodeOf(err), "a finished experiment cannot pause")
	_, err = ec.CancelExperiment(ctx, connect.NewRequest(&labv1.CancelExperimentRequest{ExperimentId: "exp_missing"}))
	require.Equal(t, connect.CodeNotFound, connect.CodeOf(err))

	list, err := ec.ListExperiments(ctx, connect.NewRequest(&labv1.ListExperimentsRequest{}))
	require.NoError(t, err)
	require.EqualValues(t, 1, list.Msg.GetTotal())

	// Library: lifecycle moves step by step and only by explicit request.
	algs, err := lc.ListAlgorithms(ctx, connect.NewRequest(&labv1.ListAlgorithmsRequest{}))
	require.NoError(t, err)
	require.Len(t, algs.Msg.GetAlgorithms(), 4)
	var trend *labv1.Algorithm
	for _, x := range algs.Msg.GetAlgorithms() {
		if x.GetId() == "trend-ema" {
			trend = x
		}
	}
	require.NotNil(t, trend.GetLatestReport(), "the winner report shows as latest evaluation")
	v := trend.GetVersions()[0]
	require.Equal(t, "research", v.GetState())
	require.NotContains(t, v.GetNextStates(), "active", "no jump from research to active")
	_, err = lc.SetVersionState(ctx, connect.NewRequest(&labv1.SetVersionStateRequest{VersionId: v.GetId(), State: "active"}))
	require.Equal(t, connect.CodeFailedPrecondition, connect.CodeOf(err))
	for _, s := range []string{"validation", "forward_test", "active"} {
		_, err = lc.SetVersionState(ctx, connect.NewRequest(&labv1.SetVersionStateRequest{VersionId: v.GetId(), State: s, Note: "by test"}))
		require.NoError(t, err, s)
	}
	ev, err := lc.ListLifecycleEvents(ctx, connect.NewRequest(&labv1.ListLifecycleEventsRequest{VersionId: v.GetId()}))
	require.NoError(t, err)
	require.Len(t, ev.Msg.GetEvents(), 4, "seed + three user steps")
	require.Equal(t, "user", ev.Msg.GetEvents()[0].GetActor())
}
