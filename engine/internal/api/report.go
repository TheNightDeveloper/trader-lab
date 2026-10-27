package api

import (
	"bytes"
	"context"
	"encoding/csv"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/fx"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

type Report struct {
	Svc     report.Service
	Limiter *jobs.Limiter // research share; nil in tests that do not need it
}

func (h *Report) ListStrategies(context.Context, *connect.Request[labv1.ListStrategiesRequest]) (*connect.Response[labv1.ListStrategiesResponse], error) {
	res := &labv1.ListStrategiesResponse{}
	for _, n := range strategy.Names() {
		info := &labv1.StrategyInfo{Name: n}
		for _, p := range strategy.ParamSpecs[n] {
			info.Params = append(info.Params, &labv1.ParamSpec{Name: p.Name, Default: p.Default, Integer: p.Integer})
		}
		res.Strategies = append(res.Strategies, info)
	}
	return connect.NewResponse(res), nil
}

// specIn turns a request spec into an eval.Spec, validating every field.
func specIn(p *labv1.ReportSpec) (eval.Spec, error) {
	if p == nil {
		return eval.Spec{}, errors.New("spec is required")
	}
	capital, ok, err := usdtIn(p.GetCapital(), "capital")
	if err != nil {
		return eval.Spec{}, err
	}
	if !ok {
		return eval.Spec{}, errors.New("capital is required")
	}
	fee, _, err := ratioIn(p.GetFee(), "fee")
	if err != nil {
		return eval.Spec{}, err
	}
	slip, _, err := ratioIn(p.GetSlippage(), "slippage")
	if err != nil {
		return eval.Spec{}, err
	}
	fixed, _, err := usdtIn(p.GetFixedUsdt(), "fixed_usdt")
	if err != nil {
		return eval.Spec{}, err
	}
	holdout, _, err := ratioIn(p.GetHoldout(), "holdout")
	if err != nil {
		return eval.Spec{}, err
	}
	if p.GetEmbargoSeconds() < 0 {
		return eval.Spec{}, errors.New("embargo must be >= 0")
	}
	return eval.Spec{
		DatasetIDs: p.GetDatasetIds(),
		Strategy:   p.GetStrategy(),
		Params:     strategy.WithDefaults(p.GetStrategy(), p.GetParams()),
		Sim: sim.Config{
			Capital: capital, FeeRate: fee, SlipRate: slip, Sizing: sim.Sizing(p.GetSizing()),
			FixedUSDT: fixed, LatencyBars: int(p.GetLatencyBars()),
		},
		Split: eval.SplitPlan{Folds: int(p.GetFolds()), Rolling: p.GetRolling(), Holdout: holdout, Embargo: time.Duration(p.GetEmbargoSeconds()) * time.Second},
	}, nil
}

func specP(s eval.Spec) *labv1.ReportSpec {
	p := &labv1.ReportSpec{
		DatasetIds: s.DatasetIDs, Timeframe: string(s.Timeframe), Strategy: s.Strategy, Params: s.Params,
		Capital: moneyP(s.Sim.Capital), Fee: ratioP(s.Sim.FeeRate), Slippage: ratioP(s.Sim.SlipRate),
		Sizing: string(s.Sim.Sizing), LatencyBars: int32(s.Sim.LatencyBars),
		Folds: int32(s.Split.Folds), Rolling: s.Split.Rolling, Holdout: ratioP(s.Split.Holdout),
		EmbargoSeconds: int64(s.Split.Embargo / time.Second), EngineVersion: s.EngineVersion,
	}
	if s.Sim.FixedUSDT.V != 0 {
		p.FixedUsdt = moneyP(s.Sim.FixedUSDT)
	}
	return p
}

// reportErr maps domain errors to Connect codes.
func reportErr(err error) error {
	switch {
	case err == nil:
		return nil
	case errors.Is(err, report.ErrNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, report.ErrInput), errors.Is(err, eval.ErrSpec), errors.Is(err, eval.ErrPlan), errors.Is(err, sim.ErrConfig):
		return connect.NewError(connect.CodeInvalidArgument, err)
	}
	return err
}

func (h *Report) CreateReport(ctx context.Context, req *connect.Request[labv1.CreateReportRequest]) (*connect.Response[labv1.CreateReportResponse], error) {
	spec, err := specIn(req.Msg.GetSpec())
	if err != nil {
		return nil, invalid(err.Error())
	}
	// A quick run is research: it waits for the whole research share, so it never
	// competes with queued attempts for CPU beyond the cap.
	if h.Limiter != nil {
		if err := h.Limiter.AcquireAll(ctx); err != nil {
			return nil, err
		}
		defer h.Limiter.ReleaseN(h.Limiter.Size())
	}
	id, err := h.Svc.Create(ctx, spec)
	if err != nil {
		return nil, reportErr(err)
	}
	return connect.NewResponse(&labv1.CreateReportResponse{ReportId: id}), nil
}

func (h *Report) ListReports(ctx context.Context, req *connect.Request[labv1.ListReportsRequest]) (*connect.Response[labv1.ListReportsResponse], error) {
	rows, err := h.Svc.Store.ListReports(ctx, db.ListReportsParams{Limit: pageSize(req.Msg.GetPageSize()), Offset: max(0, req.Msg.GetOffset())})
	if err != nil {
		return nil, err
	}
	total, err := h.Svc.Store.CountReports(ctx)
	if err != nil {
		return nil, err
	}
	res := &labv1.ListReportsResponse{Total: total}
	for _, r := range rows {
		res.Reports = append(res.Reports, &labv1.ReportListItem{
			Id: r.ID, Title: r.Title, CreatedUnixMs: ms(r.CreatedAt), Net: usdtP(r.OosNet), TotalReturn: decP(r.OosReturn, 6),
			ClosedTrades: r.ClosedTrades, Verdict: r.Verdict, Tone: r.Tone, HoldoutViews: int32(r.HoldoutViews),
		})
	}
	return connect.NewResponse(res), nil
}

func (h *Report) GetReport(ctx context.Context, req *connect.Request[labv1.GetReportRequest]) (*connect.Response[labv1.GetReportResponse], error) {
	st, err := h.Svc.Load(ctx, req.Msg.GetReportId())
	if err != nil {
		return nil, reportErr(err)
	}
	ev := st.Evaluation
	r := &labv1.Report{
		Id: st.Row.ID, Title: st.Row.Title, CreatedUnixMs: ms(st.Row.CreatedAt), Spec: specP(st.Spec),
		Range: windowP(ev.Range), OosWindow: windowP(st.Split.OOS), HoldoutWindow: windowP(st.Split.Holdout),
		Summary: summaryP(ev.Summary), Oos: runViewP(ev.OOS), HoldoutViews: int32(st.Views),
	}
	for _, f := range ev.Folds {
		r.Folds = append(r.Folds, &labv1.FoldView{Index: int32(f.Fold.Index), Train: windowP(f.Fold.Train), Test: windowP(f.Fold.Test), Metrics: metricsP(f.Metrics)})
	}
	for _, s := range ev.Stress {
		r.Stress = append(r.Stress, &labv1.StressView{Key: s.Key, Metrics: metricsP(s.Metrics), Error: s.Error})
	}
	if g := ev.Grid; g != nil {
		pg := &labv1.Grid{X: g.X, Y: g.Y, Xs: g.Xs, Ys: g.Ys}
		for _, row := range g.Cells {
			pr := &labv1.GridRow{}
			for _, c := range row {
				pr.Cells = append(pr.Cells, &labv1.GridCell{TotalReturn: metricP(c.Return), Center: c.Center, Invalid: c.Invalid})
			}
			pg.Rows = append(pg.Rows, pr)
		}
		r.Grid = pg
	}
	for _, b := range ev.Benchmarks {
		r.Benchmarks = append(r.Benchmarks, &labv1.Benchmark{Key: b.Key, Equity: equityP(b.Equity), TotalReturn: metricP(b.Return)})
	}
	if ev.BreakEvenFee != nil {
		r.BreakEvenFee = ratioP(*ev.BreakEvenFee)
	}
	for _, g := range metrics.GroupLabels {
		r.Groups = append(r.Groups, &labv1.MetricGroup{Key: g.Key, Label: g.Label})
	}
	if id := req.Msg.GetFxRateId(); id != 0 {
		rate, err := h.rate(ctx, id)
		if err != nil {
			return nil, err
		}
		final, _ := metrics.Get(ev.OOS.Metrics, "final_equity")
		net, _ := metrics.Get(ev.OOS.Metrics, "net_pnl")
		if r.FinalEquityToman, err = toman(final.V, rate); err != nil {
			return nil, err
		}
		if r.NetToman, err = toman(net.V, rate); err != nil {
			return nil, err
		}
	}
	return connect.NewResponse(&labv1.GetReportResponse{Report: r}), nil
}

func summaryP(s eval.Summary) *labv1.Summary {
	p := &labv1.Summary{Verdict: s.Verdict, Tone: string(s.Tone), Sentence: s.Sentence}
	for _, b := range s.Badges {
		p.Badges = append(p.Badges, &labv1.Badge{Kind: b.Kind, Text: b.Text, Tone: string(b.Tone)})
	}
	return p
}

// rate loads a stored USDT/TOMAN display rate.
func (h *Report) rate(ctx context.Context, id int64) (fx.Rate, error) {
	return loadRate(ctx, h.Svc.Store.Queries, id)
}

func loadRate(ctx context.Context, q *db.Queries, id int64) (fx.Rate, error) {
	row, err := q.GetFxRate(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return fx.Rate{}, invalid(fmt.Sprintf("fx_rate_id %d not found", id))
	}
	if err != nil {
		return fx.Rate{}, err
	}
	return fx.Rate{ID: row.ID, Date: row.RateDate, TomanPerUSDT: money.Price{V: row.Rate, Scale: row.RateScale}, Source: row.Source}, nil
}

// toman converts a USDT amount for display only; it never feeds back.
func toman(usdt int64, r fx.Rate) (*labv1.Money, error) {
	t, err := fx.ToToman(money.Amount{V: usdt, Asset: instrument.USDT}, r)
	if err != nil {
		return nil, err
	}
	return moneyP(t), nil
}

func (h *Report) ViewHoldout(ctx context.Context, req *connect.Request[labv1.ViewHoldoutRequest]) (*connect.Response[labv1.ViewHoldoutResponse], error) {
	v, views, err := h.Svc.ViewHoldout(ctx, req.Msg.GetReportId())
	if err != nil {
		return nil, reportErr(err)
	}
	return connect.NewResponse(&labv1.ViewHoldoutResponse{Holdout: runViewP(v), Views: int32(views)}), nil
}

func tradeP(t db.Trade) *labv1.TradeRow {
	r := &labv1.TradeRow{
		Seq: t.Seq, Instrument: t.Instrument, OpenedUnixMs: ms(t.OpenedAt), Qty: decP(t.Qty, 8),
		EntryRef: usdtP(t.EntryRef), ExitRef: usdtP(t.ExitRef), Gross: usdtP(t.Gross), Slippage: usdtP(t.Slippage),
		Fees: usdtP(t.Fees), Net: usdtP(t.Net), ExitReason: t.ExitReason, AmbiguousBars: t.AmbiguousBars, OpenQty: decP(t.OpenQty, 8),
	}
	if t.ClosedAt != nil {
		r.ClosedUnixMs = ms(*t.ClosedAt)
	}
	if t.MarkValue != nil {
		r.MarkValue = usdtP(*t.MarkValue)
	}
	return r
}

// ListTrades lists the out-of-sample run only; holdout trades stay hidden.
func (h *Report) ListTrades(ctx context.Context, req *connect.Request[labv1.ListTradesRequest]) (*connect.Response[labv1.ListTradesResponse], error) {
	id := req.Msg.GetReportId()
	rows, err := h.Svc.Store.ListTrades(ctx, db.ListTradesParams{ReportID: id, Run: report.RunMain, Limit: pageSize(req.Msg.GetPageSize()), Offset: max(0, req.Msg.GetOffset())})
	if err != nil {
		return nil, err
	}
	total, err := h.Svc.Store.CountTrades(ctx, db.CountTradesParams{ReportID: id, Run: report.RunMain})
	if err != nil {
		return nil, err
	}
	res := &labv1.ListTradesResponse{Total: total}
	for _, t := range rows {
		res.Trades = append(res.Trades, tradeP(t))
	}
	return connect.NewResponse(res), nil
}

func (h *Report) ListDecisions(ctx context.Context, req *connect.Request[labv1.ListDecisionsRequest]) (*connect.Response[labv1.ListDecisionsResponse], error) {
	id := req.Msg.GetReportId()
	rows, err := h.Svc.Store.ListDecisions(ctx, db.ListDecisionsParams{ReportID: id, Run: report.RunMain, Limit: pageSize(req.Msg.GetPageSize()), Offset: max(0, req.Msg.GetOffset())})
	if err != nil {
		return nil, err
	}
	total, err := h.Svc.Store.CountDecisions(ctx, db.CountDecisionsParams{ReportID: id, Run: report.RunMain})
	if err != nil {
		return nil, err
	}
	res := &labv1.ListDecisionsResponse{Total: total}
	for _, d := range rows {
		res.Decisions = append(res.Decisions, &labv1.DecisionRow{
			Id: d.ID, AtUnixMs: ms(d.At), InputSymbol: d.InputSymbol, InputBarOpenUnixMs: ms(d.InputBarOpen), Instrument: d.Instrument,
			Target: decP(d.Target, 6), StopLoss: decP(d.StopLoss, 6), TakeProfit: decP(d.TakeProfit, 6), Reason: d.Reason,
			ModelId: d.ModelID, RecipeVersion: d.RecipeVersion, Outcome: d.Outcome, Detail: d.Detail,
		})
	}
	return connect.NewResponse(res), nil
}

func (h *Report) Compare(ctx context.Context, req *connect.Request[labv1.CompareRequest]) (*connect.Response[labv1.CompareResponse], error) {
	ids := req.Msg.GetReportIds()
	if len(ids) < 2 || len(ids) > 6 {
		return nil, invalid("compare 2 to 6 reports")
	}
	var cs []eval.Comparable
	var stored []report.Stored
	for _, id := range ids {
		st, err := h.Svc.Load(ctx, id)
		if err != nil {
			return nil, reportErr(err)
		}
		stored = append(stored, st)
		attempts := 1
		if st.Spec.Origin != nil {
			attempts = st.Spec.Origin.Attempts
		}
		cs = append(cs, eval.Comparable{ID: id, Spec: st.Spec, Split: st.Split, Metrics: st.Evaluation.OOS.Metrics, Attempts: attempts})
	}
	c := eval.Compare(cs)
	res := &labv1.CompareResponse{Conclusion: c.Conclusion}
	for _, a := range c.Assumptions {
		res.Assumptions = append(res.Assumptions, &labv1.Assumption{Key: a.Key, Label: a.Label, Values: a.Values, Differs: a.Differs, Blocking: a.Blocking})
	}
	for i, st := range stored {
		res.Columns = append(res.Columns, &labv1.CompareColumn{
			ReportId: st.Row.ID, Title: st.Row.Title, Eligible: c.Eligible[i], Reasons: c.Reasons[i],
			Metrics: metricsP(st.Evaluation.OOS.Metrics), Equity: equityP(st.Evaluation.OOS.Equity),
		})
	}
	return connect.NewResponse(res), nil
}

func (h *Report) Reproduce(ctx context.Context, req *connect.Request[labv1.ReproduceRequest]) (*connect.Response[labv1.ReproduceResponse], error) {
	same, err := h.Svc.Reproduce(ctx, req.Msg.GetReportId())
	if err != nil {
		return nil, reportErr(err)
	}
	return connect.NewResponse(&labv1.ReproduceResponse{Identical: same}), nil
}

// Export writes trades or metrics as CSV, or the spec as JSON. Toman columns are
// added only for an explicit rate, named with its id and date.
func (h *Report) Export(ctx context.Context, req *connect.Request[labv1.ExportRequest]) (*connect.Response[labv1.ExportResponse], error) {
	id := req.Msg.GetReportId()
	st, err := h.Svc.Load(ctx, id)
	if err != nil {
		return nil, reportErr(err)
	}
	var rate *fx.Rate
	if rid := req.Msg.GetFxRateId(); rid != 0 {
		r, err := h.rate(ctx, rid)
		if err != nil {
			return nil, err
		}
		rate = &r
	}
	tomanCol := func() string {
		return fmt.Sprintf("net_toman (rate #%d, %s, display only)", rate.ID, rate.Date.Format("2006-01-02"))
	}
	var buf bytes.Buffer
	switch req.Msg.GetKind() {
	case "trades_csv":
		rows, err := h.Svc.Store.AllTrades(ctx, db.AllTradesParams{ReportID: id, Run: report.RunMain})
		if err != nil {
			return nil, err
		}
		w := csv.NewWriter(&buf)
		head := []string{"seq", "instrument", "opened_at", "closed_at", "qty", "entry_ref_usdt", "exit_ref_usdt", "gross_usdt", "slippage_usdt", "fees_usdt", "net_usdt", "exit_reason"}
		if rate != nil {
			head = append(head, tomanCol())
		}
		_ = w.Write(head)
		f8 := func(v int64) string { return money.Format(v, 8) }
		for _, t := range rows {
			closed := ""
			if t.ClosedAt != nil {
				closed = t.ClosedAt.UTC().Format(time.RFC3339)
			}
			rec := []string{strconv.Itoa(int(t.Seq)), t.Instrument, t.OpenedAt.UTC().Format(time.RFC3339), closed, f8(t.Qty),
				f8(t.EntryRef), f8(t.ExitRef), f8(t.Gross), f8(t.Slippage), f8(t.Fees), f8(t.Net), t.ExitReason}
			if rate != nil {
				tm, err := fx.ToToman(money.Amount{V: t.Net, Asset: instrument.USDT}, *rate)
				if err != nil {
					return nil, err
				}
				rec = append(rec, money.Format(tm.V, 0))
			}
			_ = w.Write(rec)
		}
		w.Flush()
		return exportResp(id+"-trades.csv", "text/csv", buf.Bytes())
	case "metrics_csv":
		w := csv.NewWriter(&buf)
		_ = w.Write([]string{"key", "label", "group", "value", "unit", "valid", "invalid"})
		for _, m := range st.Evaluation.OOS.Metrics {
			v := ""
			if m.Valid {
				v = money.Format(m.V, m.Scale)
			}
			_ = w.Write([]string{m.Key, metrics.Definitions[m.Key].Label, m.Group, v, string(m.Unit), strconv.FormatBool(m.Valid), m.Invalid})
		}
		w.Flush()
		return exportResp(id+"-metrics.csv", "text/csv", buf.Bytes())
	case "spec_json":
		b, err := json.MarshalIndent(st.Spec, "", "  ")
		if err != nil {
			return nil, err
		}
		return exportResp(id+"-spec.json", "application/json", b)
	}
	return nil, invalid("kind must be trades_csv, metrics_csv or spec_json")
}

func exportResp(name, mime string, b []byte) (*connect.Response[labv1.ExportResponse], error) {
	return connect.NewResponse(&labv1.ExportResponse{Filename: name, Mime: mime, Content: b}), nil
}
