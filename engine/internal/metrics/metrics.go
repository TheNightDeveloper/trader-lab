// Package metrics computes report numbers from a run's equity and trades. All
// integer math (math/big where needed): same inputs give the same digits on every
// machine, and money never passes through a float.
package metrics

import (
	"errors"
	"fmt"
	"math/big"
	"slices"
	"time"

	"tradinglab/engine/internal/money"
)

// Unit of a metric value.
type Unit string

const (
	USDT    Unit = "USDT"
	Ratio   Unit = "ratio"   // fraction in ppm (scale 6): 0.25 = 250000; shown as %
	Count   Unit = "count"   // scale 0
	Seconds Unit = "seconds" // scale 0
	Number  Unit = "number"  // plain fixed-point number (e.g. Sharpe, scale 2)
)

// Metric is one reported number. Invalid metrics carry the reason (Persian, shown
// to the user as is) instead of a misleading value.
type Metric struct {
	Key     string `json:"key"`
	Group   string `json:"group"`
	V       int64  `json:"v"`
	Scale   int32  `json:"scale"`
	Unit    Unit   `json:"unit"`
	Valid   bool   `json:"valid"`
	Invalid string `json:"invalid,omitempty"`
}

// Point is equity (USDT, scale 8) at a bar close.
type Point struct {
	T      time.Time
	Equity int64
}

// Trade is what metrics needs from a round trip (USDT, scale 8).
type Trade struct {
	Opened                     time.Time
	Closed                     *time.Time // nil = still open at End
	Gross, Fees, Slippage, Net int64
}

type Input struct {
	Start, End time.Time // the evaluated window [Start, End)
	Initial    int64     // starting equity, USDT
	Equity     []Point   // sorted by time, within the window
	Trades     []Trade
	// ExposureTrades may include positions carried into a window, whereas Trades
	// is its opening cohort for counts and closed-trade statistics. Nil retains
	// the standalone calculator's historical behavior.
	ExposureTrades []Trade
	// Sharpe sampling: Period (default 24h), periods per year (default 365, crypto
	// trades every day), minimum samples (default 30).
	Period      time.Duration
	PeriodsYear int64
	MinSamples  int
	MinTrades   int // for win rate, averages, profit factor (default 5)
}

// Groups in report order.
const (
	GroupPnL    = "pnl"
	GroupReturn = "return"
	GroupRisk   = "risk"
	GroupTrades = "trades"
)

// OverflowReason is the display reason shared by checked metric producers.
const OverflowReason = "خارج از محدوده عددی"

var ErrInvalid = errors.New("metrics: required value unavailable")

func (in *Input) defaults() {
	if in.Period == 0 {
		in.Period = 24 * time.Hour
	}
	if in.PeriodsYear == 0 {
		in.PeriodsYear = 365
	}
	if in.MinSamples == 0 {
		in.MinSamples = 30
	}
	if in.MinTrades == 0 {
		in.MinTrades = 5
	}
}

// Compute returns every metric in report order. P&L lines are exact sums of the
// trade-level numbers.
func Compute(in Input) []Metric {
	in.defaults()
	var out []Metric
	add := func(m Metric) { out = append(out, m) }
	usdt := func(key, group string, v int64) Metric {
		return Metric{Key: key, Group: group, V: v, Scale: 8, Unit: USDT, Valid: true}
	}

	// P&L: sums over all trades (open trades contribute their unrealized net).
	var gross, fees, slip, net, unreal big.Int
	var term big.Int
	var closed []Trade
	for _, t := range in.Trades {
		gross.Add(&gross, term.SetInt64(t.Gross))
		fees.Add(&fees, term.SetInt64(t.Fees))
		slip.Add(&slip, term.SetInt64(t.Slippage))
		net.Add(&net, term.SetInt64(t.Net))
		if t.Closed == nil {
			unreal.Add(&unreal, term.SetInt64(t.Net))
		} else {
			closed = append(closed, t)
		}
	}
	for _, total := range []struct {
		key string
		v   *big.Int
	}{{"net_pnl", &net}, {"gross_pnl", &gross}, {"fees", &fees}, {"slippage", &slip}, {"unrealized_pnl", &unreal}} {
		m := usdt(total.key, GroupPnL, 0)
		if total.v.IsInt64() {
			m.V = total.v.Int64()
		} else {
			m.Valid, m.Invalid = false, OverflowReason
		}
		add(m)
	}

	final := in.Initial
	if n := len(in.Equity); n > 0 {
		final = in.Equity[n-1].Equity
	}
	add(usdt("final_equity", GroupReturn, final))
	ret := Metric{Key: "total_return", Group: GroupReturn, Scale: 6, Unit: Ratio}
	switch v, err := scaledDelta(final, in.Initial, in.Initial, int64(money.RatioOne)); {
	case in.Initial == 0:
		ret.Invalid = "مخرج صفر است"
	case err != nil:
		ret.Invalid = OverflowReason
	default:
		ret.V, ret.Valid = v, true
	}
	add(ret)

	dd, ddDur := drawdown(in)
	add(dd)
	add(Metric{Key: "max_drawdown_duration", Group: GroupRisk, V: int64(ddDur / time.Second), Unit: Seconds, Valid: true})
	add(sharpe(in))
	add(exposure(in))

	add(Metric{Key: "trades", Group: GroupTrades, V: int64(len(in.Trades)), Unit: Count, Valid: true})
	out = append(out, tradeStats(in, closed)...)
	return out
}

// Wide totals are rounded only after the final quotient is known.
func scaledBig(num, den *big.Int, scale int64) (int64, error) {
	if den.Sign() == 0 {
		return 0, money.ErrDivZero
	}
	var product, quotient, remainder, divisor big.Int
	product.Mul(num, big.NewInt(scale))
	quotient.QuoRem(&product, den, &remainder)
	remainder.Abs(&remainder).Lsh(&remainder, 1)
	divisor.Abs(den)
	cmp := remainder.Cmp(&divisor)
	if cmp > 0 || cmp == 0 && quotient.Bit(0) != 0 {
		quotient.Add(&quotient, big.NewInt(int64(product.Sign()*den.Sign())))
	}
	if !quotient.IsInt64() {
		return 0, money.ErrOverflow
	}
	return quotient.Int64(), nil
}

func scaledDelta(a, b, denominator, scale int64) (int64, error) {
	d, err := money.SubInt64(a, b)
	if err == nil {
		return money.MulDiv(d, scale, denominator, money.HalfEven)
	}
	var wide big.Int
	wide.Sub(big.NewInt(a), big.NewInt(b))
	return scaledBig(&wide, big.NewInt(denominator), scale)
}

// Get finds a metric by key.
func Get(ms []Metric, key string) (Metric, bool) {
	i := slices.IndexFunc(ms, func(m Metric) bool { return m.Key == key })
	if i < 0 {
		return Metric{}, false
	}
	return ms[i], true
}

// Require checks metrics destined for fields that cannot convey validity.
func Require(ms []Metric, keys ...string) error {
	for _, key := range keys {
		m, ok := Get(ms, key)
		if ok && m.Valid {
			continue
		}
		err := ErrInvalid
		if m.Invalid == OverflowReason {
			err = money.ErrOverflow
		}
		return fmt.Errorf("%w: %s %s", err, key, m.Invalid)
	}
	return nil
}

func ratio(key, group string, num, den int64, invalid string) Metric {
	m := Metric{Key: key, Group: group, Scale: 6, Unit: Ratio}
	if invalid != "" {
		m.Invalid = invalid
		return m
	}
	if den == 0 {
		m.Invalid = "مخرج صفر است"
		return m
	}
	v, err := money.MulDiv(num, int64(money.RatioOne), den, money.HalfEven)
	if err != nil {
		m.Invalid = err.Error()
		return m
	}
	m.V, m.Valid = v, true
	return m
}

// drawdown: largest fall from a running peak of equity at bar closes, as a ratio,
// and the longest time spent below a previous peak (to recovery or the end).
func drawdown(in Input) (Metric, time.Duration) {
	peak, peakT := in.Initial, in.Start
	m := Metric{Key: "max_drawdown", Group: GroupRisk, Scale: 6, Unit: Ratio, Valid: true}
	var longest time.Duration
	under := false
	for _, p := range in.Equity {
		if p.Equity >= peak {
			if under && p.T.Sub(peakT) > longest {
				longest = p.T.Sub(peakT)
			}
			peak, peakT, under = p.Equity, p.T, false
			continue
		}
		under = true
		if peak > 0 && m.Valid {
			d, err := scaledDelta(peak, p.Equity, peak, int64(money.RatioOne))
			if err != nil {
				m.V, m.Valid, m.Invalid = 0, false, OverflowReason
			} else {
				m.V = max(m.V, d)
			}
		}
	}
	if under && in.End.Sub(peakT) > longest {
		longest = in.End.Sub(peakT)
	}
	return m, longest
}

// exposure: share of the window during which at least one position was open.
func exposure(in Input) Metric {
	m := Metric{Key: "exposure", Group: GroupRisk, Scale: 6, Unit: Ratio}
	span := in.End.Sub(in.Start)
	if span <= 0 {
		m.Invalid = "بازه خالی است"
		return m
	}
	if !in.Start.Add(span).Equal(in.End) {
		m.Invalid = OverflowReason
		return m
	}
	type iv struct{ a, b time.Time }
	trades := in.ExposureTrades
	if trades == nil {
		trades = in.Trades
	}
	ivs := make([]iv, 0, len(trades))
	for _, t := range trades {
		end := in.End
		if t.Closed != nil {
			end = *t.Closed
		}
		a, b := maxT(t.Opened, in.Start), minT(end, in.End)
		if b.After(a) {
			ivs = append(ivs, iv{a, b})
		}
	}
	slices.SortFunc(ivs, func(x, y iv) int { return x.a.Compare(y.a) })
	var covered time.Duration
	var cur iv
	for i, v := range ivs {
		switch {
		case i == 0:
			cur = v
		case !v.a.After(cur.b):
			cur.b = maxT(cur.b, v.b)
		default:
			covered += cur.b.Sub(cur.a)
			cur = v
		}
	}
	if len(ivs) > 0 {
		covered += cur.b.Sub(cur.a)
	}
	v, _ := money.MulDiv(int64(covered), int64(money.RatioOne), int64(span), money.HalfEven)
	m.V, m.Valid = v, true
	return m
}

func tradeStats(in Input, closed []Trade) []Metric {
	n := len(closed)
	few := ""
	if n < in.MinTrades {
		few = "کمتر از " + itoa(in.MinTrades) + " معامله بسته‌شده"
	}
	var wins, losses, hold, term big.Int
	var nWins, nLosses int64
	holdRepresentable := true
	best, worst := int64(0), int64(0)
	for i, t := range closed {
		if t.Net > 0 {
			wins.Add(&wins, term.SetInt64(t.Net))
			nWins++
		} else {
			losses.Add(&losses, term.SetInt64(t.Net))
			nLosses++
		}
		if i == 0 || t.Net > best {
			best = t.Net
		}
		if i == 0 || t.Net < worst {
			worst = t.Net
		}
		duration := t.Closed.Sub(t.Opened)
		holdRepresentable = holdRepresentable && t.Opened.Add(duration).Equal(*t.Closed)
		hold.Add(&hold, term.SetInt64(int64(duration)))
	}
	avg := func(key string, total *big.Int, count int64, emptyWhy string) Metric {
		m := Metric{Key: key, Group: GroupTrades, Scale: 8, Unit: USDT}
		switch {
		case few != "":
			m.Invalid = few
		case count == 0:
			m.Invalid = emptyWhy
		default:
			if v, err := scaledBig(total, big.NewInt(count), 1); err != nil {
				m.Invalid = OverflowReason
			} else {
				m.V, m.Valid = v, true
			}
		}
		return m
	}
	pf := Metric{Key: "profit_factor", Group: GroupTrades, Scale: 6, Unit: Ratio}
	switch {
	case few != "":
		pf.Invalid = few
	case nLosses == 0:
		pf.Invalid = "هیچ معامله زیان‌ده نبود"
	case losses.Sign() == 0:
		pf.Invalid = "مخرج صفر است"
	default:
		if v, err := scaledBig(&wins, term.Neg(&losses), int64(money.RatioOne)); err != nil {
			pf.Invalid = OverflowReason
		} else {
			pf.V, pf.Valid = v, true
		}
	}
	holdM := Metric{Key: "avg_holding", Group: GroupTrades, Unit: Seconds}
	if n == 0 {
		holdM.Invalid = "معامله بسته‌شده‌ای نیست"
	} else if !holdRepresentable {
		holdM.Invalid = OverflowReason
	} else {
		hold.Quo(&hold, term.SetInt64(int64(time.Second)))
		hold.Quo(&hold, term.SetInt64(int64(n)))
		holdM.V, holdM.Valid = hold.Int64(), true
	}
	extreme := func(key string, v int64) Metric {
		m := Metric{Key: key, Group: GroupTrades, Scale: 8, Unit: USDT}
		if n == 0 {
			m.Invalid = "معامله بسته‌شده‌ای نیست"
		} else {
			m.V, m.Valid = v, true
		}
		return m
	}
	return []Metric{
		{Key: "closed_trades", Group: GroupTrades, V: int64(n), Unit: Count, Valid: true},
		ratio("win_rate", GroupTrades, nWins, int64(n), few),
		pf,
		avg("avg_win", &wins, nWins, "هیچ معامله سودده نبود"),
		avg("avg_loss", &losses, nLosses, "هیچ معامله زیان‌ده نبود"),
		extreme("best_trade", best),
		extreme("worst_trade", worst),
		holdM,
	}
}

// sharpe: mean / sample standard deviation of period returns × sqrt(periods per
// year), risk-free 0. Equity is sampled at each period end (last close at or
// before it). Integer math throughout; result has scale 2, truncated.
func sharpe(in Input) Metric {
	m := Metric{Key: "sharpe", Group: GroupRisk, Scale: 2, Unit: Number}
	if in.Period <= 0 || in.PeriodsYear <= 0 {
		m.Invalid = "دوره محاسبه معتبر نیست"
		return m
	}
	const rs = 1_000_000_000 // returns at scale 9
	var samples []int64
	prev := in.Initial
	j := 0
	last := in.Initial
	for t := in.Start.Add(in.Period); !t.After(in.End); t = t.Add(in.Period) {
		for j < len(in.Equity) && !in.Equity[j].T.After(t) {
			last = in.Equity[j].Equity
			j++
		}
		if prev <= 0 {
			m.Invalid = "سرمایه به صفر رسید"
			return m
		}
		r, err := scaledDelta(last, prev, prev, rs)
		if err != nil {
			m.Invalid = err.Error()
			return m
		}
		samples = append(samples, r)
		prev = last
	}
	n := len(samples)
	if n < in.MinSamples {
		m.Invalid = "کمتر از " + itoa(in.MinSamples) + " بازده " + periodName(in.Period) + " (موجود: " + itoa(n) + ")"
		return m
	}
	sum := new(big.Int)
	for _, r := range samples {
		sum.Add(sum, big.NewInt(r))
	}
	N := big.NewInt(int64(n))
	// Work at scale 9 × n to keep the mean exact: dev_i = r_i·n − Σr.
	ss := new(big.Int)
	for _, r := range samples {
		d := new(big.Int).Sub(new(big.Int).Mul(big.NewInt(r), N), sum)
		ss.Add(ss, d.Mul(d, d))
	}
	if ss.Sign() == 0 {
		m.Invalid = "بازده‌ها نوسانی ندارند"
		return m
	}
	// sd·n = sqrt(ss/(n−1)); Sharpe = (Σr/n) / sd × sqrt(P) = Σr·sqrt(P) / (sd·n)
	// ×100 for scale 2, with 10^6 extra precision inside both square roots.
	sdN := new(big.Int).Sqrt(new(big.Int).Mul(new(big.Int).Quo(ss, big.NewInt(int64(n-1))), big.NewInt(1e12)))
	sqrtP := new(big.Int).Sqrt(new(big.Int).Mul(big.NewInt(in.PeriodsYear), big.NewInt(1e12)))
	num := new(big.Int).Mul(sum, sqrtP)
	num.Mul(num, big.NewInt(100))
	num.Mul(num, big.NewInt(1e6))
	den := new(big.Int).Mul(sdN, big.NewInt(1e6))
	v := new(big.Int).Quo(num, den)
	if !v.IsInt64() {
		m.Invalid = "خارج از محدوده"
		return m
	}
	m.V, m.Valid = v.Int64(), true
	return m
}

func periodName(d time.Duration) string {
	if d == 24*time.Hour {
		return "روزانه"
	}
	return d.String()
}

func itoa(n int) string { return big.NewInt(int64(n)).String() }

func maxT(a, b time.Time) time.Time {
	if a.After(b) {
		return a
	}
	return b
}

func minT(a, b time.Time) time.Time {
	if a.Before(b) {
		return a
	}
	return b
}
