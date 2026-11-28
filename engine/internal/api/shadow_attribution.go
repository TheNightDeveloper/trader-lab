package api

import (
	"context"
	"math/big"
	"sort"
	"time"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

type shadowReplay struct {
	track   *labv1.ShadowTrack
	metrics []metrics.Metric
	entries map[time.Time]*labv1.ShadowEntryEvidence // input candle open
}

func replayShadow(ctx context.Context, cfg sim.Config, spec instrument.Spec, def strategy.RuleDefinition, history, common []data.Bar, allow func(data.Bar) bool) (shadowReplay, error) {
	strat, err := def.BuildWithEntryGate(allow)
	if err != nil {
		return shadowReplay{}, err
	}
	window := eval.Window{From: common[0].OpenTime, To: common[len(common)-1].AvailableAt}
	view, _, result, err := eval.RunSplit(ctx, strat, cfg, map[string]instrument.Spec{spec.Symbol: spec},
		map[string][]data.Bar{spec.Symbol: history}, eval.Split{OOS: window})
	if err != nil {
		return shadowReplay{}, err
	}
	track := &labv1.ShadowTrack{Periods: shadowPeriods(common, result, cfg.Capital.V)}
	replay := shadowReplay{track: track, metrics: view.Metrics, entries: make(map[time.Time]*labv1.ShadowEntryEvidence)}
	for _, metric := range view.Metrics {
		switch metric.Key {
		case "net_pnl", "total_return", "max_drawdown", "closed_trades", "fees", "slippage", "final_equity":
			track.Metrics = append(track.Metrics, metricP(metric))
		}
	}
	byID := make(map[int]*labv1.ShadowEntryEvidence)
	for _, decision := range result.Decisions {
		if decision.Target > 0 {
			evidence := &labv1.ShadowEntryEvidence{}
			byID[decision.ID], replay.entries[decision.InputBarOpen.UTC()] = evidence, evidence
		}
	}
	for _, fill := range result.Fills {
		if fill.Side == sim.Buy {
			track.Entries++
			if evidence := byID[fill.DecisionID]; evidence != nil && evidence.FilledAtUnixMs == 0 {
				evidence.FilledAtUnixMs = ms(fill.Time)
			}
		}
	}
	track.Metrics = append(track.Metrics, shadowExecutionMetrics(result)...)
	return replay, nil
}

func shadowAttribution(base, track shadowReplay) *labv1.ShadowAttribution {
	out := &labv1.ShadowAttribution{}
	for key := range base.entries {
		if _, shared := track.entries[key]; shared {
			out.SharedEntries++
		}
	}
	out.BaselineOnlyEntries = int32(len(base.entries)) - out.SharedEntries
	out.TrackOnlyEntries = int32(len(track.entries)) - out.SharedEntries
	if delta, ok := shadowMetricDelta(base.metrics, track.metrics, "net_pnl"); ok {
		out.NetPnlDelta = usdtP(delta)
	}
	if delta, ok := shadowMetricDelta(base.metrics, track.metrics, "total_return"); ok {
		out.ReturnDelta = decP(delta, 6)
	}
	return out
}

func shadowMetricDelta(base, track []metrics.Metric, key string) (int64, bool) {
	a, _ := metrics.Get(base, key)
	b, _ := metrics.Get(track, key)
	if !a.Valid || !b.Valid || a.Scale != b.Scale || a.Unit != b.Unit {
		return 0, false
	}
	delta, err := money.SubInt64(b.V, a.V)
	return delta, err == nil
}

func shadowMinimumTrades(replays ...shadowReplay) *int32 {
	for _, replay := range replays {
		if replay.track != nil {
			closed, _ := metrics.Get(replay.metrics, "closed_trades")
			if !closed.Valid || closed.V < eval.MinReliableTrades {
				minimum := int32(eval.MinReliableTrades)
				return &minimum
			}
		}
	}
	return nil
}

func shadowExecutionMetrics(result *sim.Result) []*labv1.Metric {
	var net, turnover, term big.Int
	var closed int64
	for _, trade := range result.Trades {
		if trade.ClosedAt != nil {
			net.Add(&net, term.SetInt64(trade.Net.V))
			closed++
		}
	}
	for _, fill := range result.Fills {
		turnover.Add(&turnover, term.SetInt64(fill.Value.V)) // the pinned instrument settles in USDT
	}
	average := &labv1.Metric{Key: "shadow_net_expectancy", Label: "میانگین سود خالص هر معاملهٔ بسته", Unit: string(metrics.USDT), Invalid: "معاملهٔ بسته‌ای ثبت نشده است"}
	if closed != 0 {
		average.Value = decP(net.Quo(&net, term.SetInt64(closed)).Int64(), instrument.Scale)
		average.Valid, average.Invalid = true, ""
	}
	volume := &labv1.Metric{Key: "shadow_turnover", Label: "ارزش کل معاملات", Unit: string(metrics.USDT), Invalid: metrics.OverflowReason}
	if turnover.IsInt64() {
		volume.Value = decP(turnover.Int64(), instrument.Scale)
		volume.Valid, volume.Invalid = true, ""
	}
	return []*labv1.Metric{average, volume}
}

func shadowPeriods(common []data.Bar, result *sim.Result, opening int64) []*labv1.ShadowPeriodResult {
	const dayHours = 24
	var periods []*labv1.ShadowPeriodResult
	for from := 0; from < len(common); from += dayHours {
		end := min(from+dayHours, len(common))
		last := common[end-1].AvailableAt
		mark := sort.Search(len(result.Equity), func(i int) bool { return result.Equity[i].Time.After(last) }) - 1
		if mark < 0 {
			break
		}
		closing := result.Equity[mark].Equity.V
		period := &labv1.ShadowPeriodResult{FromUnixMs: ms(common[from].OpenTime), SampledHours: int32(end - from)}
		if delta, err := money.SubInt64(closing, opening); err == nil {
			period.NetPnl = usdtP(delta)
		}
		periods = append(periods, period)
		opening = closing
	}
	return periods
}

func shadowModelCost(deployment db.ShadowDeployment, usage db.ShadowUsageRow) *labv1.Money {
	if deployment.ModelInputPerMillion == nil || deployment.ModelOutputPerMillion == nil ||
		(usage.MissingUsage > 0 && usage.InputTokens == 0 && usage.OutputTokens == 0) {
		return nil
	}
	// Calculate an estimate from known tokens at the two recorded rates.
	input, inErr := money.MulDiv(usage.InputTokens, *deployment.ModelInputPerMillion, 1_000_000, money.HalfEven)
	output, outErr := money.MulDiv(usage.OutputTokens, *deployment.ModelOutputPerMillion, 1_000_000, money.HalfEven)
	total, err := money.AddInt64(input, output)
	if inErr != nil || outErr != nil || err != nil {
		return nil
	}
	return usdtP(total)
}
