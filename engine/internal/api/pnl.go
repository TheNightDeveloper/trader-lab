package api

import (
	"context"
	"errors"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/jobs"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/sim"
)

type Pnl struct {
	Svc     report.Service
	Limiter *jobs.Limiter // one research slot per recalculation; nil in tests
}

// Recalculate replays a report's recorded intents with overridden capital,
// position size, fee and slippage. With no overrides it reproduces the report.
func (h *Pnl) Recalculate(ctx context.Context, req *connect.Request[labv1.RecalculateRequest]) (*connect.Response[labv1.RecalculateResponse], error) {
	m := req.Msg
	st, err := h.Svc.Load(ctx, m.GetReportId())
	if err != nil {
		return nil, reportErr(err)
	}
	cfg := st.Spec.Sim
	if v, ok, err := usdtIn(m.GetCapital(), "capital"); err != nil {
		return nil, invalid(err.Error())
	} else if ok {
		cfg.Capital = v
	}
	if v, ok, err := ratioIn(m.GetFee(), "fee"); err != nil {
		return nil, invalid(err.Error())
	} else if ok {
		cfg.FeeRate = v
	}
	if v, ok, err := ratioIn(m.GetSlippage(), "slippage"); err != nil {
		return nil, invalid(err.Error())
	} else if ok {
		cfg.SlipRate = v
	}
	size := money.RatioOne
	if v, ok, err := ratioIn(m.GetPositionSize(), "position_size"); err != nil {
		return nil, invalid(err.Error())
	} else if ok {
		size = v
	}

	if h.Limiter != nil {
		if err := h.Limiter.Acquire(ctx); err != nil {
			return nil, err
		}
		defer h.Limiter.Release()
	}
	view, res, err := h.Svc.Recalculate(ctx, m.GetReportId(), cfg, size)
	if err != nil {
		return nil, reportErr(err)
	}
	get := func(k string) int64 { x, _ := metrics.Get(view.Metrics, k); return x.V }
	sum := eval.RecalcSummary(cfg.Capital.V, size, view.Metrics)
	orig, _ := metrics.Get(st.Evaluation.OOS.Metrics, "net_pnl")
	out := &labv1.RecalculateResponse{
		Capital: moneyP(cfg.Capital), PositionSize: ratioP(size), Fee: ratioP(cfg.FeeRate), Slippage: ratioP(cfg.SlipRate),
		Waterfall: &labv1.Waterfall{Gross: usdtP(get("gross_pnl")), Fees: usdtP(get("fees")), Slippage: usdtP(get("slippage")), Net: usdtP(get("net_pnl"))},
		Metrics:   metricsP(view.Metrics), Equity: equityP(view.Equity),
		Verdict: sum.Verdict, Tone: string(sum.Tone), Sentence: sum.Sentence, OriginalNet: usdtP(orig.V),
	}
	for i, t := range res.Trades {
		row := &labv1.TradeRow{
			Seq: int32(i + 1), Instrument: t.Instrument, OpenedUnixMs: ms(t.OpenedAt), Qty: decP(t.Qty.V, 8),
			EntryRef: moneyP(t.EntryRef), ExitRef: moneyP(t.ExitRef), Gross: moneyP(t.Gross), Slippage: moneyP(t.Slippage),
			Fees: moneyP(t.Fees), Net: moneyP(t.Net), ExitReason: t.ExitReason, AmbiguousBars: int32(t.AmbiguousBars), OpenQty: decP(t.OpenQty.V, 8),
		}
		if t.ClosedAt != nil {
			row.ClosedUnixMs = ms(*t.ClosedAt)
		}
		if t.MarkValue != nil {
			row.MarkValue = moneyP(*t.MarkValue)
		}
		out.Trades = append(out.Trades, row)
	}
	if f, ok := sim.BreakEvenFee(res); ok {
		out.BreakEvenFee = ratioP(f)
	}
	if id := m.GetFxRateId(); id != 0 {
		rate, err := loadRate(ctx, h.Svc.Store.Queries, id)
		if err != nil {
			return nil, err
		}
		if out.NetToman, err = toman(get("net_pnl"), rate); err != nil {
			return nil, err
		}
		if out.FinalEquityToman, err = toman(get("final_equity"), rate); err != nil {
			return nil, err
		}
	}
	return connect.NewResponse(out), nil
}

// CalculateTrade: buy `amount` USDT at entry, sell at exit, with the simulator's
// leg math (no lot rounding: a what-if, not an order).
func (h *Pnl) CalculateTrade(ctx context.Context, req *connect.Request[labv1.CalculateTradeRequest]) (*connect.Response[labv1.CalculateTradeResponse], error) {
	m := req.Msg
	entry, ok1, err := usdtIn(m.GetEntry(), "entry")
	if err != nil {
		return nil, invalid(err.Error())
	}
	exit, ok2, err := usdtIn(m.GetExit(), "exit")
	if err != nil {
		return nil, invalid(err.Error())
	}
	amount, ok3, err := usdtIn(m.GetAmount(), "amount")
	if err != nil {
		return nil, invalid(err.Error())
	}
	if !ok1 || !ok2 || !ok3 || entry.V <= 0 || exit.V <= 0 || amount.V <= 0 {
		return nil, invalid("entry, exit and amount must be positive")
	}
	fee, _, err := ratioIn(m.GetFee(), "fee")
	if err != nil {
		return nil, invalid(err.Error())
	}
	slip, _, err := ratioIn(m.GetSlippage(), "slippage")
	if err != nil {
		return nil, invalid(err.Error())
	}
	if fee < 0 || fee >= money.RatioOne || slip < 0 || slip >= money.RatioOne {
		return nil, invalid("fee and slippage must be in [0, 1)")
	}
	buyPrice, err := slip.Plus(entry.V, money.Ceil)
	if err != nil {
		return nil, err
	}
	qty, err := money.MulDiv(amount.V, 100_000_000, buyPrice, money.Floor)
	if err != nil {
		return nil, invalid(err.Error())
	}
	if qty <= 0 {
		return nil, invalid("amount is too small for this price")
	}
	c, err := sim.CalcTrade(money.Price{V: entry.V, Scale: 8}, money.Price{V: exit.V, Scale: 8}, money.Qty{V: qty, Scale: 8}, fee, slip, instrument.USDT)
	if errors.Is(err, sim.ErrInput) {
		return nil, invalid(err.Error())
	}
	if err != nil {
		return nil, err
	}
	leg := func(l sim.LegView) *labv1.TradeLeg {
		price := func(p money.Price) *labv1.Money { return usdtP(p.V) }
		return &labv1.TradeLeg{RefPrice: price(l.RefPrice), Price: price(l.Price), RefValue: moneyP(l.RefValue), Value: moneyP(l.Value), Slippage: moneyP(l.Slippage), Fee: moneyP(l.Fee)}
	}
	sum := eval.TradeSummary(c)
	out := &labv1.CalculateTradeResponse{
		Qty: decP(qty, 8), Buy: leg(c.Buy), Sell: leg(c.Sell),
		Waterfall: &labv1.Waterfall{Gross: moneyP(c.Gross), Fees: moneyP(c.Fees), Slippage: moneyP(c.Slippage), Net: moneyP(c.Net)},
		Cost:      moneyP(c.Cost), Return: ratioP(c.Return), BreakEvenExit: usdtP(c.BreakEvenExit.V),
		Verdict: sum.Verdict, Tone: string(sum.Tone), Sentence: sum.Sentence,
	}
	if id := m.GetFxRateId(); id != 0 {
		rate, err := loadRate(ctx, h.Svc.Store.Queries, id)
		if err != nil {
			return nil, err
		}
		if out.NetToman, err = toman(c.Net.V, rate); err != nil {
			return nil, err
		}
	}
	return connect.NewResponse(out), nil
}
