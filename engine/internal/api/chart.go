package api

import (
	"context"
	"fmt"
	"math"
	"slices"
	"strconv"
	"time"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

type Chart struct {
	Svc   report.Service
	Clock clock.Clock
}

const (
	chartBarsDefault = 2000
	chartBarsMax     = 10_000
)

func (h *Chart) GetChart(ctx context.Context, req *connect.Request[labv1.GetChartRequest]) (*connect.Response[labv1.GetChartResponse], error) {
	m := req.Msg
	limit := int(m.GetMaxBars())
	if limit <= 0 {
		limit = chartBarsDefault
	}
	limit = min(limit, chartBarsMax)
	res := &labv1.GetChartResponse{}
	var bars []data.Bar
	var decisions []db.Decision
	var trades []db.Trade
	sym := m.GetSymbol()
	if id := m.GetReportId(); id != "" {
		st, err := h.Svc.Load(ctx, id)
		if err != nil {
			return nil, reportErr(err)
		}
		all, tf, err := h.Svc.Bars(ctx, st.Spec.DatasetIDs)
		if err != nil {
			return nil, err
		}
		for s := range all {
			res.Symbols = append(res.Symbols, s)
		}
		slices.Sort(res.Symbols)
		if sym == "" {
			sym = res.Symbols[0]
		}
		if !slices.Contains(res.Symbols, sym) {
			return nil, invalid(fmt.Sprintf("report %s has no %s", id, sym))
		}
		// The holdout stays hidden: the chart ends where the main run ends.
		bars = all[sym][:firstOpenAtOrAfter(all[sym], st.Split.OOS.To)]
		res.Timeframe, res.ReportTitle = string(tf), st.Row.Title
		if decisions, err = h.Svc.Store.AllDecisions(ctx, db.AllDecisionsParams{ReportID: id, Run: report.RunMain}); err != nil {
			return nil, err
		}
		if trades, err = h.Svc.Store.AllTrades(ctx, db.AllTradesParams{ReportID: id, Run: report.RunMain}); err != nil {
			return nil, err
		}
	} else {
		if _, ok := report.Specs()[sym]; !ok {
			return nil, invalid(fmt.Sprintf("unknown pair %q", sym))
		}
		tf, err := data.ParseTimeframe(m.GetTimeframe())
		if err != nil {
			return nil, invalid(err.Error())
		}
		now := h.Clock.Now()
		// Enough history for indicator warm-up before the shown window.
		from := now.Add(-time.Duration(limit+1000) * tf.Duration())
		if bars, err = (data.Reader{Q: h.Svc.Store.Queries}).Bars(ctx, data.Query{Symbol: sym, Timeframe: tf, From: from, To: now, AsOf: now}); err != nil {
			return nil, err
		}
		for s := range report.Specs() {
			res.Symbols = append(res.Symbols, s)
		}
		slices.Sort(res.Symbols)
		res.Timeframe = string(tf)
	}
	res.Symbol, res.TotalBars = sym, int32(len(bars))
	res.PricePrecision = precision(report.Specs()[sym])

	// Indicators see all bars (warm-up), the response only the last limit.
	start := max(0, len(bars)-limit)
	for _, key := range m.GetIndicators() {
		ind, err := strategy.ComputeIndicator(key, bars)
		if err != nil {
			return nil, invalid(err.Error())
		}
		pi := &labv1.ChartIndicator{Key: ind.Key, Label: ind.Label, Pane: ind.Pane}
		for _, l := range ind.Lines {
			pl := &labv1.IndicatorLine{Name: l.Name, Values: make([]string, 0, len(bars)-start)}
			for _, v := range l.Values[start:] {
				pl.Values = append(pl.Values, indicatorValue(v))
			}
			pi.Lines = append(pi.Lines, pl)
		}
		res.Indicators = append(res.Indicators, pi)
	}
	shown := bars[start:]
	byOpen := make(map[int64]data.Bar, len(shown))
	for _, b := range shown {
		byOpen[b.OpenTime.UnixMilli()] = b
		res.Bars = append(res.Bars, &labv1.ChartBar{
			OpenUnixMs: ms(b.OpenTime), Open: decP(b.O.V, 8), High: decP(b.H.V, 8), Low: decP(b.L.V, 8), Close: decP(b.C.V, 8), Volume: decP(b.Volume.V, 8),
		})
	}
	for _, d := range decisions {
		b, ok := byOpen[d.InputBarOpen.UnixMilli()]
		if d.InputSymbol != sym || d.Instrument != sym || !ok {
			continue
		}
		kind := ""
		switch sim.Outcome(d.Outcome) {
		case sim.OutcomeFilled:
			kind = "exit"
			if d.Target > 0 {
				kind = "entry"
			}
		case sim.OutcomeRejected, sim.OutcomeExpired:
			kind = "rejected"
		}
		if kind != "" {
			res.Markers = append(res.Markers, &labv1.ChartMarker{DecisionId: d.ID, BarOpenUnixMs: ms(b.OpenTime), Kind: kind, Price: decP(b.C.V, 8)})
		}
	}
	for _, t := range trades {
		if t.Instrument != sym || t.ClosedAt == nil || (t.ExitReason != "stop loss" && t.ExitReason != "take profit") {
			continue
		}
		if _, ok := byOpen[t.ClosedAt.UnixMilli()]; ok {
			res.Markers = append(res.Markers, &labv1.ChartMarker{BarOpenUnixMs: ms(*t.ClosedAt), Kind: "exit", Price: decP(t.ExitRef, 8), Detail: t.ExitReason})
		}
	}
	slices.SortStableFunc(res.Markers, func(a, b *labv1.ChartMarker) int { return int(a.BarOpenUnixMs - b.BarOpenUnixMs) })
	return connect.NewResponse(res), nil
}

func (h *Chart) GetDecision(ctx context.Context, req *connect.Request[labv1.GetDecisionRequest]) (*connect.Response[labv1.GetDecisionResponse], error) {
	m := req.Msg
	st, err := h.Svc.Load(ctx, m.GetReportId())
	if err != nil {
		return nil, reportErr(err)
	}
	ds, err := h.Svc.Store.AllDecisions(ctx, db.AllDecisionsParams{ReportID: m.GetReportId(), Run: report.RunMain})
	if err != nil {
		return nil, err
	}
	i := slices.IndexFunc(ds, func(d db.Decision) bool { return d.ID == m.GetDecisionId() })
	if i < 0 {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("decision %d not found", m.GetDecisionId()))
	}
	d := ds[i]
	res := &labv1.GetDecisionResponse{Decision: &labv1.DecisionRow{
		Id: d.ID, AtUnixMs: ms(d.At), InputSymbol: d.InputSymbol, InputBarOpenUnixMs: ms(d.InputBarOpen), Instrument: d.Instrument,
		Target: decP(d.Target, 6), StopLoss: decP(d.StopLoss, 6), TakeProfit: decP(d.TakeProfit, 6), Reason: d.Reason,
		ModelId: d.ModelID, RecipeVersion: d.RecipeVersion, Outcome: d.Outcome, Detail: d.Detail,
	}}
	all, _, err := h.Svc.Bars(ctx, st.Spec.DatasetIDs)
	if err != nil {
		return nil, err
	}
	bs := all[d.InputSymbol]
	if j := firstOpenAtOrAfter(bs, d.InputBarOpen); j < len(bs) && bs[j].OpenTime.Equal(d.InputBarOpen) {
		res.RefPrice = moneyP(money.Amount{V: bs[j].C.V, Asset: report.Specs()[d.InputSymbol].Quote})
	}
	return connect.NewResponse(res), nil
}

func firstOpenAtOrAfter(bs []data.Bar, t time.Time) int {
	i, _ := slices.BinarySearchFunc(bs, t, func(b data.Bar, t time.Time) int { return b.OpenTime.Compare(t) })
	return i
}

// indicatorValue: 8 decimals, the precision the chart shows; "" = undefined.
func indicatorValue(v float64) string {
	if math.IsNaN(v) || math.IsInf(v, 0) {
		return ""
	}
	return strconv.FormatFloat(v, 'f', 8, 64)
}

// precision: decimals of the pair's tick size.
func precision(s instrument.Spec) int32 {
	n, v := int32(8), s.Tick.V
	for n > 0 && v%10 == 0 {
		n--
		v /= 10
	}
	return n
}
