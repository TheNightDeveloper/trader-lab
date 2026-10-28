package report

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
	"tradinglab/engine/internal/strategy"
)

var t0 = time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

// wave: n 1m bars of a seeded walk with a ±21% wave, so trend-ema trades.
func wave(n int) []data.Bar {
	x := uint64(11)
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

func setup(t *testing.T) (*store.Store, string) {
	s := storetest.Open(t)
	ctx := context.Background()
	require.NoError(t, data.SeedInstruments(ctx, s.Queries))
	bars := wave(10_000)
	_, err := data.UpsertBars(ctx, s, "BTCUSDT", "archive", "test", bars)
	require.NoError(t, err)
	ds, _, err := data.CreateDataset(ctx, s, data.DatasetSpec{Symbol: "BTCUSDT", Timeframe: data.TF1m, From: t0, To: bars[len(bars)-1].CloseTime, GapPolicy: data.GapFlag})
	require.NoError(t, err)
	return s, ds.ID
}

func spec(ds string) eval.Spec {
	return eval.Spec{
		DatasetIDs: []string{ds}, Strategy: "trend-ema",
		Params: strategy.WithDefaults("trend-ema", strategy.Params{"fast": 10, "slow": 30}),
		Sim:    sim.Config{Capital: money.Amount{V: 1000e8, Asset: instrument.USDT}, FeeRate: 1000, SlipRate: 500},
		Split:  eval.SplitPlan{Folds: 3},
	}
}

func TestCreateLoadViewRecalculate(t *testing.T) {
	st, ds := setup(t)
	ctx := context.Background()
	svc := Service{Store: st, Version: "test-1"}

	id, err := svc.Create(ctx, spec(ds))
	require.NoError(t, err)
	got, err := svc.Load(ctx, id)
	require.NoError(t, err)
	require.Equal(t, data.TF1m, got.Spec.Timeframe)
	require.Equal(t, "trend-ema · BTCUSDT · 1m", got.Row.Title)
	require.Len(t, got.Evaluation.Folds, 3)
	require.Equal(t, "test-1", got.Spec.EngineVersion)
	require.Zero(t, got.Views)

	net, _ := metrics.Get(got.Evaluation.OOS.Metrics, "net_pnl")
	require.Equal(t, net.V, got.Row.OosNet)

	// Stored trades sum to the report's net.
	trades, err := st.AllTrades(ctx, allParams(id, RunMain))
	require.NoError(t, err)
	var sum int64
	for _, tr := range trades {
		sum += tr.Net
	}
	require.Equal(t, net.V, sum, "report = Σ stored trade nets")

	// Holdout: every look is logged.
	hv, views, err := svc.ViewHoldout(ctx, id)
	require.NoError(t, err)
	require.EqualValues(t, 1, views)
	require.Equal(t, got.Split.Holdout, hv.Window)
	_, views, err = svc.ViewHoldout(ctx, id)
	require.NoError(t, err)
	require.EqualValues(t, 2, views)

	// Plan M3 acceptance: the calculator with default inputs reproduces the net exactly.
	v, _, err := svc.Recalculate(ctx, id, got.Spec.Sim, money.RatioOne)
	require.NoError(t, err)
	re, _ := metrics.Get(v.Metrics, "net_pnl")
	require.Equal(t, net.V, re.V)

	same, err := svc.Reproduce(ctx, id)
	require.NoError(t, err)
	require.True(t, same, "re-evaluation from stored inputs is identical")

	_, err = svc.Load(ctx, "rp_missing")
	require.ErrorIs(t, err, ErrNotFound)
	_, err = svc.Create(ctx, spec("ds-missing"))
	require.ErrorIs(t, err, ErrInput)
}

func allParams(id, run string) db.AllTradesParams { return db.AllTradesParams{ReportID: id, Run: run} }

func TestDatasetCacheReusesVerifiedBarsAndEvicts(t *testing.T) {
	st, ds := setup(t)
	ctx := context.Background()
	other, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{Symbol: "BTCUSDT", Timeframe: data.TF1m, From: t0, To: t0.Add(time.Hour), GapPolicy: data.GapFlag})
	require.NoError(t, err)
	svc := Service{Store: st, Cache: NewDatasetCache(1)}
	a, _, err := svc.Bars(ctx, []string{ds})
	require.NoError(t, err)
	b, _, err := svc.Bars(ctx, []string{ds})
	require.NoError(t, err)
	require.Same(t, &a["BTCUSDT"][0], &b["BTCUSDT"][0], "second read served from memory")
	_, _, err = svc.Bars(ctx, []string{other.ID})
	require.NoError(t, err)
	c, _, err := svc.Bars(ctx, []string{ds})
	require.NoError(t, err)
	require.NotSame(t, &a["BTCUSDT"][0], &c["BTCUSDT"][0], "evicted by the newer version, loaded and verified again")
	require.Equal(t, a, c)
}
