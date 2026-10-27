// Package sim runs one strategy over bars and keeps an exact ledger. One run is
// strictly sequential on one goroutine; same inputs give identical results.
package sim

import (
	"cmp"
	"context"
	"errors"
	"fmt"
	"slices"
	"time"

	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/fx"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/strategy"
)

var (
	ErrConfig    = errors.New("sim: invalid config")
	ErrInput     = errors.New("sim: invalid input")
	ErrStrategy  = errors.New("sim: strategy failed")
	ErrInvariant = errors.New("sim: ledger invariant broken")
)

type Sizing string

const (
	SizeEquity Sizing = "equity" // target × current equity (compounding)
	SizeFixed  Sizing = "fixed"  // target × FixedUSDT
)

type Config struct {
	Capital money.Amount `json:"capital"` // USDT
	// Holdings are optional starting balances in other assets (e.g. BTC to trade
	// ETHBTC). They are cash, valued in USDT like everything else.
	Holdings  []money.Amount `json:"holdings,omitempty"`
	FeeRate   money.Ratio    `json:"fee_rate"`  // per side
	SlipRate  money.Ratio    `json:"slip_rate"` // per side
	Sizing    Sizing         `json:"sizing"`
	FixedUSDT money.Amount   `json:"fixed_usdt,omitzero"`
	// LatencyBars: a decision on bar i fills at the open of bar i+LatencyBars (default 1).
	LatencyBars int `json:"latency_bars"`
	// IntentTTL: an intent not filled within this time expires. 0 = LatencyBars+9
	// bars of the input timeframe (10 minutes on 1m bars, 10 hours on 1h bars).
	IntentTTL time.Duration `json:"intent_ttl"`
}

// Normalized validates c and fills in defaults.
func (c Config) Normalized() (Config, error) { return c.normalized() }

func (c Config) normalized() (Config, error) {
	bad := func(f string, a ...any) (Config, error) {
		return Config{}, fmt.Errorf("%w: "+f, append([]any{ErrConfig}, a...)...)
	}
	if c.Capital.Asset != instrument.USDT || c.Capital.V <= 0 {
		return bad("capital must be positive USDT, got %s", c.Capital)
	}
	if c.FeeRate < 0 || c.FeeRate >= money.RatioOne || c.SlipRate < 0 || c.SlipRate >= money.RatioOne {
		return bad("fee and slippage rates must be in [0, 1)")
	}
	seen := map[string]bool{}
	for _, h := range c.Holdings {
		if h.V <= 0 || h.Asset == instrument.USDT || h.Asset.Scale != sc || seen[h.Asset.Code] {
			return bad("holdings must be positive, unique, non-USDT amounts at scale 8 (got %s)", h)
		}
		seen[h.Asset.Code] = true
	}
	switch c.Sizing {
	case "":
		c.Sizing = SizeEquity
	case SizeEquity:
	case SizeFixed:
		if c.FixedUSDT.Asset != instrument.USDT || c.FixedUSDT.V <= 0 {
			return bad("fixed sizing needs a positive USDT amount")
		}
	default:
		return bad("unknown sizing %q", c.Sizing)
	}
	if c.LatencyBars == 0 {
		c.LatencyBars = 1
	}
	if c.LatencyBars < 1 {
		return bad("latency must be >= 1 bar")
	}
	return c, nil
}

type position struct {
	qty, stop, take         int64 // stop/take prices; 0 = none
	trade                   int   // index into Result.Trades of the open round trip
	entryCost, exitProceeds int64 // USDT, for the trade's net
}

type order struct {
	decision   int // index into Result.Decisions
	symbol     string
	intent     strategy.Intent
	fillFrom   int // first bar index of symbol that may fill it
	at         time.Time
	validUntil time.Time
}

type runner struct {
	cfg     Config
	specs   map[string]instrument.Spec
	bars    map[string][]data.Bar
	symbols []string // sorted, for deterministic iteration
	seen    map[string]int
	bal     map[string]int64
	pos     map[string]*position
	pending map[string]*order
	last    map[string]money.Price
	clk     *clock.Virtual
	res     *Result
}

// Run simulates s over bars (per symbol, sorted by open time, closed bars only).
func Run(ctx context.Context, cfg Config, specs map[string]instrument.Spec, bars map[string][]data.Bar, s strategy.Strategy) (*Result, error) {
	cfg, err := cfg.normalized()
	if err != nil {
		return nil, err
	}
	r := &runner{
		cfg: cfg, specs: specs, bars: bars,
		seen: map[string]int{}, bal: map[string]int64{instrument.USDT.Code: cfg.Capital.V},
		pos: map[string]*position{}, pending: map[string]*order{}, last: map[string]money.Price{},
		// Empty slices, not nil: an empty run serializes as [] rather than null.
		res: &Result{Decisions: []Decision{}, Fills: []Fill{}, Trades: []Trade{}, Equity: []EquityPoint{}},
	}
	for _, h := range cfg.Holdings {
		r.bal[h.Asset.Code] = h.V
	}
	events, err := r.events()
	if err != nil {
		return nil, err
	}
	if len(events) == 0 {
		return nil, fmt.Errorf("%w: no bars", ErrInput)
	}
	first := bars[events[0].sym][events[0].i]
	r.clk = clock.NewVirtual(first.AvailableAt)
	if r.cfg.IntentTTL == 0 {
		r.cfg.IntentTTL = time.Duration(r.cfg.LatencyBars+9) * first.CloseTime.Sub(first.OpenTime)
	}

	for start := 0; start < len(events); {
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		at := bars[events[start].sym][events[start].i].AvailableAt
		end := start
		for end < len(events) && bars[events[end].sym][events[end].i].AvailableAt.Equal(at) {
			end++
		}
		if err := r.clk.Set(at); err != nil {
			return nil, fmt.Errorf("%w: %w", ErrInput, err)
		}
		if err := r.batch(ctx, s, events[start:end]); err != nil {
			return nil, err
		}
		start = end
	}
	r.res.Bars = len(events)
	return r.res, r.finish(ctx)
}

type event struct {
	sym string
	i   int
}

// events validates the input and orders every bar by (AvailableAt, OpenTime, symbol):
// the order in which a live engine would have learned about them.
func (r *runner) events() ([]event, error) {
	for sym := range r.bars {
		r.symbols = append(r.symbols, sym)
	}
	slices.Sort(r.symbols)
	var evs []event
	for _, sym := range r.symbols {
		if _, ok := r.specs[sym]; !ok {
			return nil, fmt.Errorf("%w: no instrument spec for %s", ErrInput, sym)
		}
		bs := r.bars[sym]
		for i, b := range bs {
			switch {
			case b.Instrument != sym:
				return nil, fmt.Errorf("%w: %s bar %d belongs to %s", ErrInput, sym, i, b.Instrument)
			case i > 0 && !b.OpenTime.After(bs[i-1].OpenTime):
				return nil, fmt.Errorf("%w: %s bars not strictly increasing at %s", ErrInput, sym, b.OpenTime)
			case b.AvailableAt.Before(b.CloseTime):
				return nil, fmt.Errorf("%w: %s bar %s available before it closed", ErrInput, sym, b.OpenTime)
			}
			evs = append(evs, event{sym, i})
		}
	}
	slices.SortFunc(evs, func(a, b event) int {
		x, y := r.bars[a.sym][a.i], r.bars[b.sym][b.i]
		return cmp.Or(x.AvailableAt.Compare(y.AvailableAt), x.OpenTime.Compare(y.OpenTime), cmp.Compare(a.sym, b.sym))
	})
	return evs, nil
}

// batch processes every bar that became available at the same instant, in three
// phases so nothing sees a price from its own future:
//  1. fills and stop/take exits at each bar's open and range, valued with closes
//     from earlier batches only (an ETHBTC fill at 00:01 must not use the BTCUSDT
//     close of 00:02, even though both bars arrive together);
//  2. record this batch's closes;
//  3. strategies decide on the closed bars; then equity is marked.
func (r *runner) batch(ctx context.Context, s strategy.Strategy, evs []event) error {
	closeAt := time.Time{}
	for _, ev := range evs {
		b := r.bars[ev.sym][ev.i]
		r.seen[ev.sym] = ev.i + 1
		if err := r.fillDue(ctx, ev.sym, ev.i, b); err != nil {
			return err
		}
		if err := r.exits(ctx, ev.sym, b); err != nil {
			return err
		}
		if b.CloseTime.After(closeAt) {
			closeAt = b.CloseTime
		}
	}
	for _, ev := range evs {
		r.last[ev.sym] = r.bars[ev.sym][ev.i].C
	}
	for _, ev := range evs {
		b := r.bars[ev.sym][ev.i]
		intents, err := r.callStrategy(s, b)
		if err != nil {
			return err
		}
		for _, in := range intents {
			r.decide(ev.sym, b, in)
		}
	}
	if err := r.checkInvariants(); err != nil {
		return err
	}
	return r.markEquity(ctx, closeAt)
}

// fillDue executes or expires the pending order of sym if bar i is its fill bar.
func (r *runner) fillDue(ctx context.Context, sym string, i int, b data.Bar) error {
	o := r.pending[sym]
	if o == nil || i < o.fillFrom {
		return nil
	}
	switch {
	case b.OpenTime.After(o.validUntil):
		delete(r.pending, sym)
		r.outcome(o.decision, OutcomeExpired, fmt.Sprintf("no fill by %s (next bar opened %s)", stamp(o.validUntil), stamp(b.OpenTime)))
	case !b.CloseTime.After(o.at):
		// This bar had closed before the decision was made (late, backfilled data):
		// its open is in the past. Wait for a bar still open at decision time.
	default:
		delete(r.pending, sym)
		return r.execute(ctx, o, b)
	}
	return nil
}

func (r *runner) callStrategy(s strategy.Strategy, b data.Bar) (out []strategy.Intent, err error) {
	defer func() {
		if p := recover(); p != nil {
			err = fmt.Errorf("%w: panic on %s %s: %v", ErrStrategy, b.Instrument, stamp(b.OpenTime), p)
		}
	}()
	out, err = s.OnBar(r, b)
	if err != nil {
		err = fmt.Errorf("%w: %s %s: %w", ErrStrategy, b.Instrument, stamp(b.OpenTime), err)
	}
	return out, err
}

func (r *runner) decide(sym string, b data.Bar, in strategy.Intent) {
	d := Decision{
		ID: len(r.res.Decisions) + 1, At: r.clk.Now(), InputSymbol: sym, InputBarOpen: b.OpenTime,
		Instrument: in.Instrument, Target: in.Target, StopLoss: in.StopLoss, TakeProfit: in.TakeProfit,
		Reason: in.Reason, ModelID: in.ModelID, RecipeVersion: in.RecipeVersion,
	}
	reject := func(why string) {
		d.Outcome, d.Detail = OutcomeRejected, why
		r.res.Decisions = append(r.res.Decisions, d)
	}
	_, known := r.specs[in.Instrument]
	switch {
	case !known:
		reject("unknown instrument")
		return
	case in.Target < 0:
		reject("short selling is not allowed (spot only)")
		return
	case in.Target > money.RatioOne:
		reject("leverage is not allowed (target above 100%)")
		return
	case in.StopLoss < 0 || in.StopLoss >= money.RatioOne || in.TakeProfit < 0:
		reject("stop loss must be in [0, 1) and take profit >= 0")
		return
	case r.seen[in.Instrument] == 0:
		reject("no bar of the instrument has been seen yet")
		return
	}
	r.res.Decisions = append(r.res.Decisions, d)
	idx := len(r.res.Decisions) - 1
	if old := r.pending[in.Instrument]; old != nil {
		r.outcome(old.decision, OutcomeSuperseded, fmt.Sprintf("replaced by decision %d", d.ID))
	}
	r.pending[in.Instrument] = &order{
		decision: idx, symbol: in.Instrument, intent: in,
		fillFrom: r.seen[in.Instrument] - 1 + r.cfg.LatencyBars,
		at:       d.At, validUntil: d.At.Add(r.cfg.IntentTTL),
	}
}

func (r *runner) outcome(idx int, o Outcome, detail string) {
	r.res.Decisions[idx].Outcome, r.res.Decisions[idx].Detail = o, detail
}

// execute moves the position toward the intent's target exposure at the bar open.
func (r *runner) execute(ctx context.Context, o *order, b data.Bar) error {
	spec := r.specs[o.symbol]
	p := r.position(o.symbol)
	ref := b.O.V
	quoteRate, err := r.usdtPer(ctx, spec.Quote)
	if errors.Is(err, fx.ErrNoRate) {
		r.outcome(o.decision, OutcomeRejected, "no USDT rate for "+spec.Quote.Code+" yet")
		return nil
	}
	if err != nil {
		return err
	}
	if o.intent.Target == 0 {
		if p.qty == 0 {
			r.outcome(o.decision, OutcomeNoChange, "already flat")
			return nil
		}
		return r.sell(ctx, o.symbol, p.qty, ref, quoteRate, b.OpenTime, "signal", r.res.Decisions[o.decision].ID, false, o.intent.Reason)
	}

	base := r.cfg.FixedUSDT.V
	if r.cfg.Sizing == SizeEquity {
		base, err = r.equity(ctx)
		if errors.Is(err, fx.ErrNoRate) {
			r.outcome(o.decision, OutcomeRejected, "equity cannot be valued yet: "+err.Error())
			return nil
		}
		if err != nil {
			return err
		}
	}
	targetUSDT, err := o.intent.Target.Apply(base, money.Floor)
	if err != nil {
		return err
	}
	curQuote, err := money.MulScaled(p.qty, sc, ref, sc, sc, money.Floor)
	if err != nil {
		return err
	}
	curUSDT, err := money.MulScaled(curQuote, sc, quoteRate, sc, sc, money.Floor)
	if err != nil {
		return err
	}
	delta := targetUSDT - curUSDT
	dQuote, err := money.MulDiv(abs(delta), pow10sc, quoteRate, money.Floor)
	if err != nil {
		return err
	}
	id := r.res.Decisions[o.decision].ID

	if delta < 0 {
		q, err := money.MulDiv(dQuote, pow10sc, ref, money.Floor)
		if err != nil {
			return err
		}
		q = min(lotFloor(spec, q), p.qty)
		if q == 0 {
			r.outcome(o.decision, OutcomeNoChange, "change smaller than one lot")
			return nil
		}
		if q < p.qty {
			l, err := newLeg(false, ref, q, r.cfg.SlipRate, r.cfg.FeeRate)
			if err != nil {
				return err
			}
			if l.value < spec.MinNotional.V {
				r.outcome(o.decision, OutcomeRejected, "order below min notional "+spec.MinNotional.String())
				return nil
			}
		}
		return r.sell(ctx, o.symbol, q, ref, quoteRate, b.OpenTime, "signal", id, false, o.intent.Reason)
	}

	price, err := r.cfg.SlipRate.Plus(ref, money.Ceil)
	if err != nil {
		return err
	}
	want, err := money.MulDiv(dQuote, pow10sc, price, money.Floor)
	if err != nil {
		return err
	}
	if lotFloor(spec, want) == 0 {
		r.outcome(o.decision, OutcomeNoChange, "change smaller than one lot")
		return nil
	}
	q, l, err := affordableQty(spec, ref, want, r.free(spec.Quote.Code), r.cfg.SlipRate, r.cfg.FeeRate)
	if err != nil {
		return err
	}
	switch {
	case q == 0:
		r.outcome(o.decision, OutcomeRejected, "insufficient free "+spec.Quote.Code+" balance")
		return nil
	case l.value < spec.MinNotional.V:
		r.outcome(o.decision, OutcomeRejected, "order below min notional "+spec.MinNotional.String())
		return nil
	}
	if err := r.apply(o.symbol, l, quoteRate, b.OpenTime, "signal", id, false); err != nil {
		return err
	}
	if o.intent.StopLoss > 0 {
		p.stop, _ = o.intent.StopLoss.Minus(l.price, money.Floor)
	}
	if o.intent.TakeProfit > 0 {
		p.take, _ = o.intent.TakeProfit.Plus(l.price, money.Ceil)
	}
	r.outcome(o.decision, OutcomeFilled, "")
	return nil
}

func (r *runner) sell(ctx context.Context, sym string, q, ref, quoteRate int64, at time.Time, kind string, decisionID int, ambiguous bool, reason string) error {
	l, err := newLeg(false, ref, q, r.cfg.SlipRate, r.cfg.FeeRate)
	if err != nil {
		return err
	}
	p := r.pos[sym]
	trade := p.trade
	if err := r.apply(sym, l, quoteRate, at, kind, decisionID, ambiguous); err != nil {
		return err
	}
	if p.qty == 0 && reason != "" {
		r.res.Trades[trade].ExitReason = reason
	}
	if decisionID > 0 {
		r.outcome(decisionID-1, OutcomeFilled, "")
	}
	return nil
}

// exits closes the whole position if the bar touched its stop or take. If both
// were inside the bar, the order is unknown: assume the stop (conservative) and
// flag it. A gap through the level fills at the open, not at the level.
func (r *runner) exits(ctx context.Context, sym string, b data.Bar) error {
	p := r.pos[sym]
	if p == nil || p.qty == 0 {
		return nil
	}
	stopHit := p.stop > 0 && b.L.V <= p.stop
	takeHit := p.take > 0 && b.H.V >= p.take
	if !stopHit && !takeHit {
		return nil
	}
	ambiguous := stopHit && takeHit
	kind, ref := "stop", min(p.stop, b.O.V)
	if !stopHit {
		kind, ref = "take", max(p.take, b.O.V)
	}
	quoteRate, err := r.usdtPer(ctx, r.specs[sym].Quote)
	if err != nil {
		return fmt.Errorf("value %s exit: %w", sym, err)
	}
	if ambiguous {
		r.res.AmbiguousBars++
		r.res.Trades[p.trade].AmbiguousBars++
	}
	reason := map[string]string{"stop": "stop loss", "take": "take profit"}[kind]
	return r.sell(ctx, sym, p.qty, ref, quoteRate, b.OpenTime, kind, 0, ambiguous, reason)
}

// free is the balance of asset not tied up in open positions: only free cash can
// pay for a buy (a BTCUSDT position's BTC cannot fund an ETHBTC buy).
func (r *runner) free(asset string) int64 {
	v := r.bal[asset]
	for _, sym := range r.symbols {
		if p := r.pos[sym]; p != nil && r.specs[sym].Base.Code == asset {
			v -= p.qty
		}
	}
	return v
}

func (r *runner) position(sym string) *position {
	p := r.pos[sym]
	if p == nil {
		p = &position{trade: -1}
		r.pos[sym] = p
	}
	return p
}

// apply books one leg: balances, position, trade round trip, fill record.
func (r *runner) apply(sym string, l leg, quoteRate int64, at time.Time, kind string, decisionID int, ambiguous bool) error {
	spec := r.specs[sym]
	p := r.position(sym)
	usdt := func(v int64) (int64, error) { return money.MulScaled(v, sc, quoteRate, sc, sc, money.HalfEven) }
	refU, err := usdt(l.refValue)
	if err != nil {
		return err
	}
	slipU, err := usdt(l.slippage)
	if err != nil {
		return err
	}
	feeU, err := usdt(l.fee)
	if err != nil {
		return err
	}

	q, a := spec.Quote, func(v int64) money.Amount { return money.Amount{V: v, Asset: instrument.USDT} }
	r.bal[q.Code] += l.cash()
	side := Sell
	if l.buy {
		side = Buy
		r.bal[spec.Base.Code] += l.qty
		if p.qty == 0 {
			z := money.Amount{Asset: instrument.USDT}
			r.res.Trades = append(r.res.Trades, Trade{
				Instrument: sym, OpenedAt: at, Qty: money.Qty{Scale: sc}, OpenQty: money.Qty{Scale: sc},
				EntryRef: z, ExitRef: z, Gross: z, Slippage: z, Fees: z, Net: z,
			})
			p.trade, p.entryCost, p.exitProceeds, p.stop, p.take = len(r.res.Trades)-1, 0, 0, 0, 0
		}
		p.qty += l.qty
		t := &r.res.Trades[p.trade]
		t.Qty.V += l.qty
		t.EntryRef.V += refU
		t.Slippage.V += slipU
		t.Fees.V += feeU
		p.entryCost += refU + slipU + feeU
	} else {
		r.bal[spec.Base.Code] -= l.qty
		p.qty -= l.qty
		t := &r.res.Trades[p.trade]
		t.ExitRef.V += refU
		t.Slippage.V += slipU
		t.Fees.V += feeU
		p.exitProceeds += refU - slipU - feeU
		if p.qty == 0 {
			closed := at
			t.ClosedAt = &closed
			t.Gross.V = t.ExitRef.V - t.EntryRef.V
			t.Net.V = p.exitProceeds - p.entryCost
			if t.Net.V != t.Gross.V-t.Slippage.V-t.Fees.V {
				return fmt.Errorf("%w: %s trade net %d != gross %d - slippage %d - fees %d", ErrInvariant, sym, t.Net.V, t.Gross.V, t.Slippage.V, t.Fees.V)
			}
			p.stop, p.take = 0, 0
		}
	}
	r.res.Fills = append(r.res.Fills, Fill{
		DecisionID: decisionID, Time: at, Instrument: sym, Side: side, Kind: kind,
		Qty:      money.Qty{V: l.qty, Scale: sc},
		RefPrice: money.Price{V: l.ref, Scale: sc}, Price: money.Price{V: l.price, Scale: sc},
		RefValue: money.Amount{V: l.refValue, Asset: q}, Value: money.Amount{V: l.value, Asset: q},
		Slippage: money.Amount{V: l.slippage, Asset: q}, Fee: money.Amount{V: l.fee, Asset: q},
		RefValueUSDT: a(refU), SlippageUSDT: a(slipU), FeeUSDT: a(feeU), Ambiguous: ambiguous,
	})
	return nil
}

// LastClose makes the runner an fx.RateSource. Everything it holds was available
// at the current virtual time, so asOf needs no filtering here.
func (r *runner) LastClose(_ context.Context, symbol string, _ time.Time) (money.Price, error) {
	p, ok := r.last[symbol]
	if !ok {
		return money.Price{}, fmt.Errorf("%w: %s", fx.ErrNoRate, symbol)
	}
	return p, nil
}

// usdtPer is the USDT value of one unit of asset, at scale 8.
func (r *runner) usdtPer(ctx context.Context, a money.Asset) (int64, error) {
	v, err := fx.ToUSDT(ctx, r, money.Amount{V: pow10sc, Asset: a}, r.clk.Now(), money.Floor)
	return v.V, err
}

// equity values every balance in USDT: positions through their own pair (ETHBTC:
// ETH → BTC → USDT), remaining cash through <ASSET>USDT.
func (r *runner) equity(ctx context.Context) (int64, error) {
	cash := map[string]int64{}
	for a, v := range r.bal {
		cash[a] = v
	}
	var total int64
	for _, sym := range r.symbols {
		p := r.pos[sym]
		if p == nil || p.qty == 0 {
			continue
		}
		spec := r.specs[sym]
		cash[spec.Base.Code] -= p.qty
		v, err := fx.PositionUSDT(ctx, r, spec, money.Qty{V: p.qty, Scale: sc}, r.clk.Now(), money.Floor)
		if err != nil {
			return 0, err
		}
		total += v.V
	}
	assets := make([]string, 0, len(cash))
	for a := range cash {
		assets = append(assets, a)
	}
	slices.Sort(assets)
	for _, a := range assets {
		if cash[a] == 0 {
			continue
		}
		v, err := fx.ToUSDT(ctx, r, money.Amount{V: cash[a], Asset: instrument.Asset(a)}, r.clk.Now(), money.Floor)
		if err != nil {
			return 0, err
		}
		total += v.V
	}
	return total, nil
}

// markEquity records equity at a bar close. Until every held asset has a USDT
// rate (e.g. BTC holdings before the first BTCUSDT bar) there is no honest value,
// so no point is recorded.
func (r *runner) markEquity(ctx context.Context, at time.Time) error {
	eq, err := r.equity(ctx)
	if errors.Is(err, fx.ErrNoRate) {
		return nil
	}
	if err != nil {
		return fmt.Errorf("equity at %s: %w", stamp(at), err)
	}
	r.res.Equity = append(r.res.Equity, EquityPoint{Time: at, Equity: money.Amount{V: eq, Asset: instrument.USDT}})
	return nil
}

// checkInvariants runs after every event: no balance is negative and every
// position is covered by its base-asset balance.
func (r *runner) checkInvariants() error {
	held := map[string]int64{}
	for _, sym := range r.symbols {
		if p := r.pos[sym]; p != nil {
			if p.qty < 0 {
				return fmt.Errorf("%w: %s position %d < 0", ErrInvariant, sym, p.qty)
			}
			held[r.specs[sym].Base.Code] += p.qty
		}
	}
	for a, v := range r.bal {
		if v < 0 {
			return fmt.Errorf("%w: %s balance %d < 0", ErrInvariant, a, v)
		}
		if v < held[a] {
			return fmt.Errorf("%w: %s balance %d below positions %d", ErrInvariant, a, v, held[a])
		}
	}
	return nil
}

// finish closes the books: unfilled orders, open trades marked to market,
// final balances and equity.
func (r *runner) finish(ctx context.Context) error {
	for _, sym := range r.symbols {
		if o := r.pending[sym]; o != nil {
			r.outcome(o.decision, OutcomeUnfilled, "run ended before the next bar")
		}
		p := r.pos[sym]
		if p == nil || p.qty == 0 {
			continue
		}
		v, err := fx.PositionUSDT(ctx, r, r.specs[sym], money.Qty{V: p.qty, Scale: sc}, r.clk.Now(), money.Floor)
		if err != nil {
			return err
		}
		// Unrealized: the remaining quantity marked at the last close, no exit costs.
		t := &r.res.Trades[p.trade]
		t.OpenQty = money.Qty{V: p.qty, Scale: sc}
		t.MarkValue = &v
		t.Gross.V = t.ExitRef.V + v.V - t.EntryRef.V
		t.Net.V = p.exitProceeds + v.V - p.entryCost
		if t.Net.V != t.Gross.V-t.Slippage.V-t.Fees.V {
			return fmt.Errorf("%w: open %s trade net != gross - slippage - fees", ErrInvariant, sym)
		}
	}
	assets := make([]string, 0, len(r.bal))
	for a := range r.bal {
		assets = append(assets, a)
	}
	slices.Sort(assets)
	for _, a := range assets {
		r.res.Balances = append(r.res.Balances, Balance{Asset: a, Amount: money.Amount{V: r.bal[a], Asset: instrument.Asset(a)}})
	}
	eq, err := r.equity(ctx)
	if err != nil {
		return err
	}
	r.res.FinalEquity = money.Amount{V: eq, Asset: instrument.USDT}
	return nil
}

// History implements strategy.RunContext. The capacity cap means reslicing past
// the last seen bar panics instead of revealing the future.
func (r *runner) History(symbol string) []data.Bar {
	n := r.seen[symbol]
	return r.bars[symbol][:n:n]
}

func (r *runner) Position(symbol string) money.Qty {
	if p := r.pos[symbol]; p != nil {
		return money.Qty{V: p.qty, Scale: sc}
	}
	return money.Qty{Scale: sc}
}

func abs(v int64) int64 {
	if v < 0 {
		return -v
	}
	return v
}

func stamp(t time.Time) string { return t.UTC().Format("2006-01-02T15:04:05Z") }
