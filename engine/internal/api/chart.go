package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"slices"
	"strconv"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/jobs"
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
	chartBarsDefault   = 2000
	chartBarsMax       = 10_000
	chartIndicatorsMax = 8
)

func (h *Chart) GetChart(ctx context.Context, req *connect.Request[labv1.GetChartRequest]) (*connect.Response[labv1.GetChartResponse], error) {
	m := req.Msg
	// Bound indicator response expansion independently of the visible candle count.
	if len(m.GetIndicators()) > chartIndicatorsMax {
		return nil, invalid("حداکثر ۸ اندیکاتور در هر درخواست نمودار مجاز است")
	}
	limit := int(m.GetMaxBars())
	if limit <= 0 {
		limit = chartBarsDefault
	}
	limit = min(limit, chartBarsMax)
	res := &labv1.GetChartResponse{}
	var bars []data.Bar
	reportID := m.GetReportId()
	sym := m.GetSymbol()
	if reportID != "" {
		st, err := h.reportChartInputs(ctx, reportID)
		if err != nil {
			return nil, reportErr(err)
		}
		release, err := h.Svc.ReserveChart(ctx, st.datasetIDs, limit)
		if err != nil {
			return nil, reportErr(err)
		}
		defer release()
		all, tf, err := h.Svc.Bars(ctx, st.datasetIDs)
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
			return nil, invalid(fmt.Sprintf("report %s has no %s", reportID, sym))
		}
		// The holdout stays hidden: the chart ends where the main run ends.
		bars = all[sym][:firstOpenAtOrAfter(all[sym], st.oosEnd)]
		res.Timeframe, res.ReportTitle = string(tf), st.title
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
		raw, err := data.RawBarCount(tf, from, now)
		if err != nil {
			return nil, reportErr(err)
		}
		bytes, err := jobs.WorkBytes(int64(raw), int64(limit+1000), 1)
		if err != nil {
			return nil, reportErr(err)
		}
		release, err := h.Svc.Memory.Reserve(ctx, bytes)
		if err != nil {
			return nil, reportErr(err)
		}
		defer release()
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

	// Keep the original warm-up while constructing only the visible values.
	start := max(0, len(bars)-limit)
	for _, key := range m.GetIndicators() {
		ind, err := strategy.ComputeIndicatorWindow(key, bars, start)
		if err != nil {
			return nil, invalid(err.Error())
		}
		pi := &labv1.ChartIndicator{Key: ind.Key, Label: ind.Label, Pane: ind.Pane}
		for _, l := range ind.Lines {
			pl := &labv1.IndicatorLine{Name: l.Name, Values: make([]string, 0, len(l.Values))}
			for _, v := range l.Values {
				pl.Values = append(pl.Values, indicatorValue(v))
			}
			pi.Lines = append(pi.Lines, pl)
		}
		res.Indicators = append(res.Indicators, pi)
	}
	shown := bars[start:]
	var decisions []db.Decision
	var fills []db.Fill
	if reportID != "" && len(shown) > 0 {
		// Match the existing millisecond projection even if a stored timestamp has finer precision.
		from := shown[0].OpenTime.Truncate(time.Millisecond)
		to := shown[len(shown)-1].OpenTime.Truncate(time.Millisecond).Add(time.Millisecond)
		var err error
		decisions, err = h.Svc.Store.ChartDecisions(ctx, db.ChartDecisionsParams{ReportID: reportID, Symbol: sym, FromTime: from, ToTime: to})
		if err != nil {
			return nil, err
		}
		fills, err = h.Svc.Store.ChartProtectionFills(ctx, db.ChartProtectionFillsParams{ReportID: reportID, Symbol: sym, FromTime: from, ToTime: to})
		if err != nil {
			return nil, err
		}
	}
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
	res.Markers = append(res.Markers, protectionMarkers(fills, sym, byOpen)...)

	slices.SortStableFunc(res.Markers, func(a, b *labv1.ChartMarker) int { return int(a.BarOpenUnixMs - b.BarOpenUnixMs) })
	return connect.NewResponse(res), nil
}

func (h *Chart) GetDecision(ctx context.Context, req *connect.Request[labv1.GetDecisionRequest]) (*connect.Response[labv1.GetDecisionResponse], error) {
	m := req.Msg
	st, err := h.reportChartInputs(ctx, m.GetReportId())
	if err != nil {
		return nil, reportErr(err)
	}
	release, err := h.Svc.ReserveChart(ctx, st.datasetIDs, 1)
	if err != nil {
		return nil, reportErr(err)
	}
	defer release()
	d, err := h.Svc.Store.GetMainDecision(ctx, db.GetMainDecisionParams{ReportID: m.GetReportId(), ID: m.GetDecisionId()})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("decision %d not found", m.GetDecisionId()))
	}
	if err != nil {
		return nil, err
	}
	res := &labv1.GetDecisionResponse{Decision: &labv1.DecisionRow{
		Id: d.ID, AtUnixMs: ms(d.At), InputSymbol: d.InputSymbol, InputBarOpenUnixMs: ms(d.InputBarOpen), Instrument: d.Instrument,
		Target: decP(d.Target, 6), StopLoss: decP(d.StopLoss, 6), TakeProfit: decP(d.TakeProfit, 6), Reason: d.Reason,
		ModelId: d.ModelID, RecipeVersion: d.RecipeVersion, Outcome: d.Outcome, Detail: d.Detail,
	}}
	all, _, err := h.Svc.Bars(ctx, st.datasetIDs)
	if err != nil {
		return nil, err
	}
	bs := all[d.InputSymbol]
	if j := firstOpenAtOrAfter(bs, d.InputBarOpen); j < len(bs) && bs[j].OpenTime.Equal(d.InputBarOpen) {
		res.RefPrice = moneyP(money.Amount{V: bs[j].C.V, Asset: report.Specs()[d.InputSymbol].Quote})
	}
	return connect.NewResponse(res), nil
}

type chartInputs struct {
	title      string
	datasetIDs []string
	oosEnd     time.Time
}

// Charts need the registered inputs and end time, without loading evaluation or holdout output.
func (h *Chart) reportChartInputs(ctx context.Context, id string) (chartInputs, error) {
	row, err := h.Svc.Store.GetReportChartInputs(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return chartInputs{}, fmt.Errorf("%w: %s", report.ErrNotFound, id)
	}
	if err != nil {
		return chartInputs{}, err
	}
	var spec eval.Spec
	var split eval.Split
	if err := json.Unmarshal(row.Spec, &spec); err != nil {
		return chartInputs{}, fmt.Errorf("report %s spec: %w", id, err)
	}
	if err := json.Unmarshal(row.Split, &split); err != nil {
		return chartInputs{}, fmt.Errorf("report %s split: %w", id, err)
	}
	return chartInputs{title: row.Title, datasetIDs: spec.DatasetIDs, oosEnd: split.OOS.To}, nil
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

// A trade can have many exits: each marker uses its own fill's unit price.
func protectionMarkers(fills []db.Fill, symbol string, shown map[int64]data.Bar) []*labv1.ChartMarker {
	var markers []*labv1.ChartMarker
	for _, f := range fills {
		if f.Instrument != symbol || f.Side != string(sim.Sell) || (f.Kind != "stop" && f.Kind != "take") {
			continue
		}
		if _, ok := shown[f.At.UnixMilli()]; !ok {
			continue
		}
		detail := "stop loss"
		if f.Kind == "take" {
			detail = "take profit"
		}
		markers = append(markers, &labv1.ChartMarker{BarOpenUnixMs: ms(f.At), Kind: "exit", Price: decP(f.RefPrice, 8), Detail: detail})
	}
	return markers
}
