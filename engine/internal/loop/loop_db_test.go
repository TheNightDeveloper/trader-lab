package loop

import (
	"context"
	"math"
	"math/rand/v2"
	"sync"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
)

var day0 = time.Date(2024, 3, 1, 0, 0, 0, 0, time.UTC)

// momentumBars: 1m bars whose hourly returns are autocorrelated (0.6), so a model
// that sees the last hour's return has a real edge on the next one.
func momentumBars(days int) []data.Bar {
	rng := rand.New(rand.NewPCG(9, 9))
	var out []data.Bar
	price, r := 100.0, 0.0
	p := func(v float64) money.Price { return money.Price{V: int64(v * 1e8), Scale: instrument.Scale} }
	for h := range days * 24 {
		r = 0.6*r + rng.NormFloat64()*0.006
		target := price * (1 + r)
		prev := price
		for m := range 60 {
			c := price + (target-price)*float64(m+1)/60
			ot := day0.Add(time.Duration(h)*time.Hour + time.Duration(m)*time.Minute)
			out = append(out, data.Bar{Instrument: "BTCUSDT", OpenTime: ot, CloseTime: ot.Add(time.Minute), AvailableAt: ot.Add(time.Minute + 2*time.Second),
				O: p(prev), H: p(math.Max(prev, c) * 1.0002), L: p(math.Min(prev, c) * 0.9998), C: p(c), Volume: money.Qty{V: 1e8, Scale: instrument.Scale}})
			prev = c
		}
		price = target
	}
	return out
}

// weak: volatility-only features, no direction. Its variants include +ret_1.
var weak = model.Recipe{Format: 1, Features: []string{"range_24", "vol_24"}, Transform: "zscore", Model: "ridge", Alpha: 0.01, Horizon: 1, Entry: 0, Exposure: 1}

func testConfig() Config {
	c := Default()
	c.Algorithm, c.LookbackDays, c.MinFreshBars, c.Folds, c.MaxCandidates = "test-learn", 20, 24, 2, 8
	c.Fee, c.Slippage = 0, 0
	c.Gate = Gate{MaxDrawdown: money.RatioOne, MinForwardTrades: 0, ForwardDays: 4, MinImprovement: 0, MaxDDDegradation: money.RatioOne, MinWalkWins: 0}
	return c
}

func setup(t *testing.T) (*store.Store, *Loop, *clock.Virtual) {
	st := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	_, err := data.UpsertBars(ctx, st, "BTCUSDT", "archive", "t", momentumBars(36))
	require.NoError(t, err)
	require.NoError(t, st.InTx(ctx, func(q *db.Queries) error {
		if err := q.UpsertAlgorithm(ctx, db.UpsertAlgorithmParams{ID: "test-learn", Family: "learning", Description: "t"}); err != nil {
			return err
		}
		_, _, err := experiment.AddVersion(ctx, q, "test-learn", experiment.VersionDefinition{Strategy: experiment.RecipeStrategy, Recipe: &weak}, experiment.Research, "seed", "system")
		return err
	}))
	require.NoError(t, SaveConfig(ctx, st.Queries, testConfig()))
	clk := clock.NewVirtual(day0.Add(21 * 24 * time.Hour))
	return st, &Loop{Store: st, Clock: clk, Limiter: jobs.NewLimiter(2)}, clk
}

func get(t *testing.T, l *Loop, id int64) cycle {
	c, err := l.load(context.Background(), l.Store.Queries, id)
	require.NoError(t, err)
	return c
}

// runToDecision runs a cycle and its forward test (advancing the clock) to the end.
func runToDecision(t *testing.T, l *Loop, clk *clock.Virtual) cycle {
	ctx := context.Background()
	id, err := l.Begin(ctx, "manual")
	require.NoError(t, err)
	require.NoError(t, l.RunCycle(ctx, id))
	c := get(t, l, id)
	if c.row.State != ForwardTest {
		return c
	}
	require.NoError(t, clk.Set(clk.Now().Add(25*time.Hour)))
	require.NoError(t, l.Advance(ctx))
	c = get(t, l, id)
	require.Equal(t, ForwardTest, c.row.State, "one day in: still testing")
	require.Equal(t, 1, c.doc.Forward.Days)
	days := time.Duration(c.doc.Config.Gate.ForwardDays-1) * 24 * time.Hour
	require.NoError(t, clk.Set(clk.Now().Add(days)))
	require.NoError(t, l.Advance(ctx))
	return get(t, l, id)
}

func active(t *testing.T, l *Loop) (string, string) {
	a, err := l.Store.GetAlgorithm(context.Background(), "test-learn")
	require.NoError(t, err)
	v, err := activeVersion(context.Background(), l.Store.Queries, "test-learn")
	require.NoError(t, err)
	return v, a.ActiveModel.String
}

func TestCycleRecommendsAndOnlyTheUserPromotes(t *testing.T) {
	_, l, clk := setup(t)
	ctx := context.Background()

	c := runToDecision(t, l, clk)
	require.Equal(t, Recommended, c.row.Outcome, c.row.Reason)
	require.Equal(t, Decision, c.row.State)
	require.NotNil(t, c.row.ConsumedUntil, "forward data used in the decision is marked")
	cands, err := l.Store.ListCandidates(ctx, c.row.ID)
	require.NoError(t, err)
	require.Len(t, cands, c.doc.Candidates, "every candidate is recorded")
	require.Equal(t, 8, c.doc.Candidates)
	for _, g := range c.doc.Gate {
		require.Equal(t, "pass", g.Status, g.Text)
	}
	chal, err := l.artifact(ctx, c.doc.Challenger.ModelID)
	require.NoError(t, err)
	require.Equal(t, c.doc.Champion.ModelID, chal.Parent)
	require.Equal(t, *c.doc.FreezeAt, chal.AsOf, "frozen at the freeze")

	v, m := active(t, l)
	require.Empty(t, v+m, "a recommendation changes nothing by itself")

	require.NoError(t, l.Approve(ctx, c.row.ID, "looks right"))
	v, m = active(t, l)
	require.Equal(t, c.doc.Challenger.ModelID, m)
	_, def, err := experiment.Version(ctx, l.Store.Queries, v)
	require.NoError(t, err)
	require.Equal(t, c.doc.Challenger.Recipe.Hash(), def.Recipe.Hash(), "the challenger's recipe is the new active version")
	require.Equal(t, "test-learn@v2", v)
	ev, err := l.Store.ListLifecycleEvents(ctx, v)
	require.NoError(t, err)
	require.Equal(t, "user", ev[0].Actor)

	require.ErrorIs(t, l.Approve(ctx, c.row.ID, ""), ErrState, "approved once")
	require.ErrorIs(t, l.Rollback(ctx, "test-learn", ""), ErrState, "no earlier active model to return to")

	// Right after a decision, the forward data is used up: the next cycle skips.
	id, err := l.Begin(ctx, "manual")
	require.NoError(t, err)
	require.NoError(t, l.RunCycle(ctx, id))
	s := get(t, l, id)
	require.Equal(t, Skipped, s.row.Outcome)
	require.Contains(t, s.row.Reason, "داده تازه ناکافی")
}

func TestWorseChallengerAndInterruptionsLeaveTheChampion(t *testing.T) {
	st, l, clk := setup(t)
	ctx := context.Background()
	first := runToDecision(t, l, clk)
	require.Equal(t, Recommended, first.row.Outcome, first.row.Reason)
	require.NoError(t, l.Approve(ctx, first.row.ID, ""))
	v0, m0 := active(t, l)
	p0, err := st.LastPromotion(ctx, "test-learn")
	require.NoError(t, err)

	// A challenger held to a bar it cannot clear (100 points better than the
	// champion): the cycle ends "not better" and nothing moves.
	cfg := testConfig()
	cfg.Gate.MinImprovement = money.RatioOne
	require.NoError(t, SaveConfig(ctx, st.Queries, cfg))
	require.NoError(t, clk.Set(clk.Now().Add(3*24*time.Hour)))
	c := runToDecision(t, l, clk)
	require.Equal(t, NotBetter, c.row.Outcome, c.row.Reason)
	require.Equal(t, Done, c.row.State)
	v, m := active(t, l)
	require.Equal(t, [2]string{v0, m0}, [2]string{v, m}, "champion unchanged")
	p, err := st.LastPromotion(ctx, "test-learn")
	require.NoError(t, err)
	require.Equal(t, p0.ID, p.ID)

	// Training interrupted mid-way: the cycle fails, the active pair stays.
	lim := jobs.NewLimiter(1)
	require.NoError(t, lim.Acquire(ctx)) // hold the only research slot
	l2 := &Loop{Store: st, Clock: clk, Limiter: lim}
	require.NoError(t, clk.Set(clk.Now().Add(2*24*time.Hour)))
	id, err := l2.Begin(ctx, "manual")
	require.NoError(t, err)
	runCtx, cancel := context.WithCancel(ctx)
	errc := make(chan error, 1)
	go func() { errc <- l2.RunCycle(runCtx, id) }()
	require.Eventually(t, func() bool { return get(t, l2, id).row.State == Train }, 30*time.Second, 10*time.Millisecond)
	cancel()
	require.Error(t, <-errc)
	lim.Release()
	c = get(t, l2, id)
	require.Equal(t, Failed, c.row.Outcome)
	require.Equal(t, interrupted, c.row.Reason)
	v, m = active(t, l)
	require.Equal(t, [2]string{v0, m0}, [2]string{v, m}, "an interrupted training run leaves the active version untouched")

	// A cycle a restart cut off mid-run is closed as interrupted on start.
	id, err = l.Begin(ctx, "manual")
	require.NoError(t, err)
	cut := get(t, l, id)
	cut.row.State = WalkForward
	require.NoError(t, l.save(ctx, st.Queries, &cut))
	runCtx, cancel = context.WithTimeout(ctx, 300*time.Millisecond)
	defer cancel()
	l3 := &Loop{Store: st, Clock: clk, Limiter: jobs.NewLimiter(1), Poll: 50 * time.Millisecond}
	require.NoError(t, l3.Run(runCtx))
	c = get(t, l3, id)
	require.Equal(t, Failed, c.row.Outcome)
	v, m = active(t, l)
	require.Equal(t, [2]string{v0, m0}, [2]string{v, m})
}

// syncClock: the scheduler goroutine and the test both read it.
type syncClock struct {
	mu sync.Mutex
	t  time.Time
}

func (c *syncClock) Now() time.Time {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.t
}

func (c *syncClock) add(d time.Duration) {
	c.mu.Lock()
	c.t = c.t.Add(d)
	c.mu.Unlock()
}

// Release gate: with the schedule on, nobody calls anything — the scheduler
// starts the day's cycle, runs it to the forward test, and decides when the
// forward days have passed. The decision is recorded.
func TestScheduledCycleRunsUnattendedAndRecordsItsDecision(t *testing.T) {
	st, _, _ := setup(t)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	cfg := testConfig()
	cfg.Enabled, cfg.HourUTC = true, 0
	require.NoError(t, SaveConfig(ctx, st.Queries, cfg))
	clk := &syncClock{t: day0.Add(21*24*time.Hour + 30*time.Minute)}
	l := &Loop{Store: st, Clock: clk, Limiter: jobs.NewLimiter(2), Poll: 20 * time.Millisecond}
	done := make(chan error, 1)
	go func() { done <- l.Run(ctx) }()

	var id int64
	require.Eventually(t, func() bool {
		open, err := st.OpenCycles(ctx)
		require.NoError(t, err)
		if len(open) == 1 && open[0].State == ForwardTest {
			id = open[0].ID
			return true
		}
		return false
	}, 60*time.Second, 20*time.Millisecond, "the scheduler started and froze a cycle")

	clk.add(time.Duration(cfg.Gate.ForwardDays)*24*time.Hour + 2*time.Hour)
	var c cycle
	require.Eventually(t, func() bool {
		c = get(t, l, id)
		return c.row.Outcome != ""
	}, 60*time.Second, 20*time.Millisecond, "the scheduler decided after the forward test")
	require.Equal(t, "schedule", c.row.Trigger)
	require.NotNil(t, c.row.ConsumedUntil)
	require.Len(t, c.doc.Gate, 6, "every gate condition recorded")
	require.Contains(t, []string{Recommended, NotBetter, GateFailed}, c.row.Outcome, c.row.Reason)
	cancel()
	require.NoError(t, <-done)
}
