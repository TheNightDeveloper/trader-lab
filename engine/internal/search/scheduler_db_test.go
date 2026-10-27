package search_test

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"runtime"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/api"
	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/search"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/storetest"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

func wave(n int) []data.Bar {
	x := uint64(31)
	next := func(m int64) int64 {
		x = x*6364136223846793005 + 1442695040888963407
		return int64(x>>33) % m
	}
	bs := make([]data.Bar, n)
	p := int64(100e8)
	for i := range bs {
		o := p
		d := int64(3_000_000)
		if (i/700)%2 == 1 {
			d = -d
		}
		c := max(50e8, o+d+next(20_000_000)-10_000_000)
		open := t0.Add(time.Duration(i) * time.Minute)
		bs[i] = data.Bar{Instrument: "BTCUSDT", OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute + 2*time.Second),
			O: money.Price{V: o, Scale: 8}, H: money.Price{V: max(o, c) + next(5_000_000), Scale: 8},
			L: money.Price{V: min(o, c) - next(5_000_000), Scale: 8}, C: money.Price{V: c, Scale: 8}, Volume: money.Qty{V: 1e8, Scale: 8}}
		p = c
	}
	return bs
}

func setup(t *testing.T, bars int) (*store.Store, string) {
	s := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, s.Queries))
	require.NoError(t, experiment.SeedLibrary(ctx, s))
	bs := wave(bars)
	_, err := data.UpsertBars(ctx, s, "BTCUSDT", "archive", "t", bs)
	require.NoError(t, err)
	ds, _, err := data.CreateDataset(ctx, s, data.DatasetSpec{Symbol: "BTCUSDT", Timeframe: data.TF1m, From: t0, To: bs[len(bs)-1].CloseTime, GapPolicy: data.GapFlag})
	require.NoError(t, err)
	return s, ds.ID
}

func definition(ds string, fast, slow experiment.ParamRange, budget int) experiment.Definition {
	return experiment.Definition{
		Name: "test", Hypothesis: "faster EMAs catch the wave", Falsifier: "no candidate beats cash",
		Objective:        experiment.Objective{Metric: "total_return", Maximize: true},
		Constraints:      []experiment.Constraint{{Metric: "max_drawdown", Op: "<=", Value: "0.5"}},
		DatasetIDs:       []string{ds},
		AlgorithmVersion: "trend-ema@v1",
		Space:            map[string]experiment.ParamRange{"fast": fast, "slow": slow},
		Search:           experiment.SearchPlan{Mode: "grid", MaxAttempts: budget, MaxWallSeconds: 3600},
		Sim:              sim.Config{Capital: money.Amount{V: 1000e8, Asset: instrument.USDT}, FeeRate: 1000, SlipRate: 500},
		Split:            eval.SplitPlan{Folds: 3},
	}
}

func start(t *testing.T, s *store.Store, def experiment.Definition) string {
	ctx := context.Background()
	atts, err := search.Plan(ctx, s, def)
	require.NoError(t, err)
	id, err := experiment.Create(ctx, s, def, atts)
	require.NoError(t, err)
	return id
}

func scheduler(s *store.Store, slots int) *search.Scheduler {
	return &search.Scheduler{Store: s, Reports: report.Service{Store: s, Version: "test", Parallel: slots}, Limiter: jobs.NewLimiter(slots), Build: "test-build", Poll: 20 * time.Millisecond}
}

func waitStatus(t *testing.T, s *store.Store, id, status string, within time.Duration) {
	deadline := time.Now().Add(within)
	for time.Now().Before(deadline) {
		e, err := s.GetExperiment(context.Background(), id)
		require.NoError(t, err)
		if e.Status == status {
			return
		}
		time.Sleep(20 * time.Millisecond)
	}
	e, _ := s.GetExperiment(context.Background(), id)
	t.Fatalf("experiment %s is %s, want %s", id, e.Status, status)
}

func counts(t *testing.T, s *store.Store, id string) map[string]int32 {
	rows, err := s.AttemptCounts(context.Background(), id)
	require.NoError(t, err)
	out := map[string]int32{}
	for _, r := range rows {
		out[r.Status] = r.N
	}
	return out
}

func TestSearchRunsSelectsAndReports(t *testing.T) {
	s, ds := setup(t, 6000)
	id := start(t, s, definition(ds, experiment.ParamRange{Values: []float64{5, 10}}, experiment.ParamRange{Values: []float64{30, 60}}, 10))
	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan struct{})
	go func() { _ = scheduler(s, 2).Run(ctx); close(done) }()
	waitStatus(t, s, id, "done", 60*time.Second)
	cancel()
	<-done

	require.Equal(t, map[string]int32{"done": 4}, counts(t, s, id))
	e, err := experiment.Load(context.Background(), s.Queries, id)
	require.NoError(t, err)
	var res search.Result
	require.NoError(t, json.Unmarshal(e.Row.Result, &res))
	require.Positive(t, res.Chosen)
	require.Equal(t, 4, res.Attempts)
	require.Len(t, res.ReportIDs, 1)

	st, err := report.Service{Store: s}.Load(context.Background(), res.ReportIDs[0])
	require.NoError(t, err)
	require.NotNil(t, st.Spec.Origin, "the attempt count travels with the chosen candidate")
	require.Equal(t, 4, st.Spec.Origin.Attempts)

	// An equivalent experiment under another name reuses every run.
	def2 := definition(ds, experiment.ParamRange{Values: []float64{5, 10}}, experiment.ParamRange{Values: []float64{30, 60}}, 10)
	def2.Name = "again"
	id2 := start(t, s, def2)
	ctx, cancel = context.WithCancel(context.Background())
	done = make(chan struct{})
	go func() { _ = scheduler(s, 2).Run(ctx); close(done) }()
	waitStatus(t, s, id2, "done", 60*time.Second)
	cancel()
	<-done
	hits, err := s.CacheHits(context.Background(), id2)
	require.NoError(t, err)
	require.EqualValues(t, 4, hits.Hits)

	_, err = experiment.Create(context.Background(), s, def2, nil)
	require.ErrorIs(t, err, experiment.ErrExists, "identical definition is the same experiment")
}

// Plan M4 acceptance: killing the engine mid-search and restarting resumes
// without duplicate or lost attempts.
func TestKillMidSearchResumesWithoutLossOrDuplicates(t *testing.T) {
	s, ds := setup(t, 20_000)
	id := start(t, s, definition(ds, experiment.ParamRange{Min: 3, Max: 12, Step: 1}, experiment.ParamRange{Values: []float64{30, 45, 60}}, 100))
	total := int32(30)

	ctx, kill := context.WithCancel(context.Background())
	stopped := make(chan struct{})
	go func() { _ = scheduler(s, 2).Run(ctx); close(stopped) }()
	for counts(t, s, id)["done"] < 5 {
		time.Sleep(5 * time.Millisecond)
	}
	kill() // like SIGKILL for the queue: running attempts are left running in the database
	<-stopped
	mid := counts(t, s, id)
	require.Less(t, mid["done"], total, "killed before the end")
	require.Zero(t, mid["cancelled"]+mid["failed"], "a shutdown never marks attempts failed or cancelled")

	ctx, stop := context.WithCancel(context.Background())
	stopped = make(chan struct{})
	go func() { _ = scheduler(s, 2).Run(ctx); close(stopped) }()
	waitStatus(t, s, id, "done", 120*time.Second)
	stop()
	<-stopped

	require.Equal(t, map[string]int32{"done": total}, counts(t, s, id), "every attempt exactly once")
	rows, err := s.AllAttempts(context.Background(), id)
	require.NoError(t, err)
	require.Len(t, rows, int(total))
	for i, r := range rows {
		require.EqualValues(t, i+1, r.Seq)
		require.NotNil(t, r.Metrics)
		require.GreaterOrEqual(t, r.Runs, int32(1))
	}
}

func TestCancelRecordsEveryAttempt(t *testing.T) {
	s, ds := setup(t, 20_000)
	id := start(t, s, definition(ds, experiment.ParamRange{Min: 3, Max: 12, Step: 1}, experiment.ParamRange{Values: []float64{30, 45, 60}}, 100))
	sch := scheduler(s, 1)
	ctx, stop := context.WithCancel(context.Background())
	defer stop()
	go func() { _ = sch.Run(ctx) }()
	for counts(t, s, id)["done"] < 2 {
		time.Sleep(5 * time.Millisecond)
	}
	require.NoError(t, experiment.Cancel(context.Background(), s, id))
	sch.Cancel(id)
	deadline := time.Now().Add(10 * time.Second)
	for counts(t, s, id)["running"]+counts(t, s, id)["queued"] > 0 && time.Now().Before(deadline) {
		time.Sleep(10 * time.Millisecond)
	}
	c := counts(t, s, id)
	require.EqualValues(t, 30, c["done"]+c["cancelled"], "cancelled attempts stay recorded")
	require.Positive(t, c["cancelled"])
	e, _ := s.GetExperiment(context.Background(), id)
	require.Equal(t, "cancelled", e.Status)
}

// Plan M4 acceptance: a 500-attempt search never delays HealthService updates
// beyond 1 s.
func TestHealthStaysOnTimeDuringLargeSearch(t *testing.T) {
	if testing.Short() {
		t.Skip("long")
	}
	s, ds := setup(t, 100_000) // long enough (~10 s) to observe many health updates
	def := definition(ds, experiment.ParamRange{Min: 2, Max: 26, Step: 1}, experiment.ParamRange{Min: 30, Max: 49, Step: 1}, 500)
	id := start(t, s, def)

	mux := http.NewServeMux()
	mux.Handle(labv1connect.NewHealthServiceHandler(&api.Health{Clock: clock.Wall{}, Every: time.Second, Rates: &api.Fx{Store: s, Clock: clock.Wall{}}}))
	srv := httptest.NewServer(mux)
	defer srv.Close()

	ctx, stop := context.WithCancel(context.Background())
	defer stop()
	slots := jobs.ResearchSlots(runtime.NumCPU(), 75)
	go func() { _ = scheduler(s, slots).Run(ctx) }()

	stream, err := labv1connect.NewHealthServiceClient(srv.Client(), srv.URL).Watch(ctx, connect.NewRequest(&labv1.WatchRequest{}))
	require.NoError(t, err)
	defer func() { _ = stream.Close() }()
	var arrivals []time.Time
	for stream.Receive() {
		arrivals = append(arrivals, time.Now())
		e, err := s.GetExperiment(context.Background(), id)
		require.NoError(t, err)
		if e.Status == "done" {
			break
		}
	}
	require.Equal(t, map[string]int32{"done": 500}, counts(t, s, id))
	require.Greater(t, len(arrivals), 2, "the search must last long enough to measure")
	var worst time.Duration
	for i := 1; i < len(arrivals); i++ {
		worst = max(worst, arrivals[i].Sub(arrivals[i-1])-time.Second)
	}
	t.Logf("500 attempts over %s with %d research slots; worst health delay %s", arrivals[len(arrivals)-1].Sub(arrivals[0]), slots, worst)
	require.Less(t, worst, time.Second)
}
