// Package metrics computes report numbers from a run's equity and trades. All
// integer math (math/big where needed): same inputs give the same digits on every
// machine, and money never passes through a float.
package metrics

import (
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
	var gross, fees, slip, net, unreal int64
	var closed []Trade
	for _, t := range in.Trades {
		gross += t.Gross
		fees += t.Fees
		slip += t.Slippage
		net += t.Net
		if t.Closed == nil {
			unreal += t.Net
		} else {
			closed = append(closed, t)
		}
	}
	add(usdt("net_pnl", GroupPnL, net))
	add(usdt("gross_pnl", GroupPnL, gross))
	add(usdt("fees", GroupPnL, fees))
	add(usdt("slippage", GroupPnL, slip))
	add(usdt("unrealized_pnl", GroupPnL, unreal))

	final := in.Initial
	if n := len(in.Equity); n > 0 {
		final = in.Equity[n-1].Equity
	}
	add(usdt("final_equity", GroupReturn, final))
	add(ratio("total_return", GroupReturn, final-in.Initial, in.Initial, ""))

	dd, ddDur := drawdown(in)
	add(Metric{Key: "max_drawdown", Group: GroupRisk, V: dd, Scale: 6, Unit: Ratio, Valid: true})
	add(Metric{Key: "max_drawdown_duration", Group: GroupRisk, V: int64(ddDur / time.Second), Unit: Seconds, Valid: true})
	add(sharpe(in))
	add(exposure(in))

	add(Metric{Key: "trades", Group: GroupTrades, V: int64(len(in.Trades)), Unit: Count, Valid: true})
	out = append(out, tradeStats(in, closed)...)
	return out
}

// Get finds a metric by key.
func Get(ms []Metric, key string) (Metric, bool) {
	i := slices.IndexFunc(ms, func(m Metric) bool { return m.Key == key })
	if i < 0 {
		return Metric{}, false
	}
	return ms[i], true
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
func drawdown(in Input) (int64, time.Duration) {
	peak, peakT := in.Initial, in.Start
	var worst int64
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
		if peak > 0 {
			d, _ := money.MulDiv(peak-p.Equity, int64(money.RatioOne), peak, money.HalfEven)
			worst = max(worst, d)
		}
	}
	if under && in.End.Sub(peakT) > longest {
		longest = in.End.Sub(peakT)
	}
	return worst, longest
}

// exposure: share of the window during which at least one position was open.
func exposure(in Input) Metric {
	m := Metric{Key: "exposure", Group: GroupRisk, Scale: 6, Unit: Ratio}
	span := in.End.Sub(in.Start)
	if span <= 0 {
		m.Invalid = "بازه خالی است"
		return m
	}
	type iv struct{ a, b time.Time }
	ivs := make([]iv, 0, len(in.Trades))
	for _, t := range in.Trades {
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
	var wins, losses []int64
	var hold time.Duration
	best, worst := int64(0), int64(0)
	for i, t := range closed {
		if t.Net > 0 {
			wins = append(wins, t.Net)
		} else {
			losses = append(losses, t.Net)
		}
		if i == 0 || t.Net > best {
			best = t.Net
		}
		if i == 0 || t.Net < worst {
			worst = t.Net
		}
		hold += t.Closed.Sub(t.Opened)
	}
	sum := func(xs []int64) int64 {
		var s int64
		for _, x := range xs {
			s += x
		}
		return s
	}
	avg := func(key string, xs []int64, emptyWhy string) Metric {
		m := Metric{Key: key, Group: GroupTrades, Scale: 8, Unit: USDT}
		switch {
		case few != "":
			m.Invalid = few
		case len(xs) == 0:
			m.Invalid = emptyWhy
		default:
			m.V, _ = money.MulDiv(sum(xs), 1, int64(len(xs)), money.HalfEven)
			m.Valid = true
		}
		return m
	}
	pf := ratio("profit_factor", GroupTrades, sum(wins), -sum(losses), few)
	if few == "" && len(losses) == 0 {
		pf = Metric{Key: "profit_factor", Group: GroupTrades, Scale: 6, Unit: Ratio, Invalid: "هیچ معامله زیان‌ده نبود"}
	}
	holdM := Metric{Key: "avg_holding", Group: GroupTrades, Unit: Seconds}
	if n == 0 {
		holdM.Invalid = "معامله بسته‌شده‌ای نیست"
	} else {
		holdM.V, holdM.Valid = int64(hold/time.Second)/int64(n), true
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
		ratio("win_rate", GroupTrades, int64(len(wins)), int64(n), few),
		pf,
		avg("avg_win", wins, "هیچ معامله سودده نبود"),
		avg("avg_loss", losses, "هیچ معامله زیان‌ده نبود"),
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
		r, err := money.MulDiv(last-prev, rs, prev, money.HalfEven)
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
