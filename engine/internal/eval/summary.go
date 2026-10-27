package eval

import (
	"fmt"
	"strings"

	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
)

// MinReliableTrades: fewer closed out-of-sample trades and the verdict is "not yet
// reliable", whatever the P&L says.
const MinReliableTrades = 30

type Tone string

const (
	Positive Tone = "positive"
	Negative Tone = "negative"
	Warning  Tone = "warning"
	Neutral  Tone = "neutral"
)

type Badge struct {
	Kind string `json:"kind"`
	Text string `json:"text"`
	Tone Tone   `json:"tone"`
}

// Summary is the plain-language top of a report (Persian; numbers isolated LTR).
type Summary struct {
	Verdict  string  `json:"verdict"`
	Tone     Tone    `json:"tone"`
	Sentence string  `json:"sentence"`
	Badges   []Badge `json:"badges"`
}

// ltr isolates a number inside RTL text (U+2066 … U+2069) so signs and digits
// keep their order.
func ltr(s string) string { return "⁦" + s + "⁩" }

// Pct formats a ppm ratio as a signed percent with two decimals: "+3.21%".
func Pct(v int64) string {
	h, _ := money.MulDiv(v, 1, 100, money.HalfEven) // ppm → hundredths of a percent
	s := money.Format(h, 2)
	if v > 0 {
		s = "+" + s
	}
	return strings.Replace(s, "-", "−", 1) + "%"
}

// USDTText formats USDT units (scale 8) with sign and two decimals: "+1234.56".
func USDTText(v int64) string {
	c, _ := money.Rescale(v, 8, 2, money.HalfEven)
	s := money.Format(c, 2)
	if v > 0 {
		s = "+" + s
	}
	return strings.Replace(s, "-", "−", 1)
}

func m(ms []metrics.Metric, key string) metrics.Metric {
	x, _ := metrics.Get(ms, key)
	return x
}

func summarize(ev *Evaluation) Summary {
	oos := ev.OOS.Metrics
	net, ret, dd := m(oos, "net_pnl"), m(oos, "total_return"), m(oos, "max_drawdown")
	closed, win := m(oos, "closed_trades"), m(oos, "win_rate")
	w := ev.Split.OOS

	var b strings.Builder
	fmt.Fprintf(&b, "در دوره خارج از نمونه %s تا %s، این راهبرد پس از کسر کارمزد و لغزش %s بازده خالص داشت (%s USDT)؛ بیشترین افت سرمایه %s بود",
		ltr(w.From.Format("2006-01-02")), ltr(w.To.Add(-1).Format("2006-01-02")),
		ltr(Pct(ret.V)), ltr(USDTText(net.V)), ltr(Pct(-dd.V)))
	if win.Valid {
		fmt.Fprintf(&b, " و از %s معامله بسته %s سودده بود.", ltr(fmt.Sprint(closed.V)), ltr(strings.TrimPrefix(Pct(win.V), "+")))
	} else {
		fmt.Fprintf(&b, " و %s معامله بسته انجام شد.", ltr(fmt.Sprint(closed.V)))
	}

	s := Summary{Sentence: b.String()}
	switch {
	case closed.V < MinReliableTrades:
		s.Verdict, s.Tone = "هنوز قابل اتکا نیست", Warning
	case net.V > 0:
		s.Verdict, s.Tone = "سودده پس از هزینه‌ها", Positive
	default:
		s.Verdict, s.Tone = "زیان‌ده پس از هزینه‌ها", Negative
	}

	if closed.V < MinReliableTrades {
		s.Badges = append(s.Badges, Badge{"few_trades", fmt.Sprintf("فقط %s معامله بسته؛ کمتر از %s", ltr(fmt.Sprint(closed.V)), ltr(fmt.Sprint(MinReliableTrades))), Warning})
	}
	var positive int
	for _, f := range ev.Folds {
		if m(f.Metrics, "net_pnl").V > 0 {
			positive++
		}
	}
	foldTone := Positive
	if positive*2 < len(ev.Folds) {
		foldTone = Warning
	}
	s.Badges = append(s.Badges, Badge{"folds", fmt.Sprintf("%s از %s دوره آزمون سودده", ltr(fmt.Sprint(positive)), ltr(fmt.Sprint(len(ev.Folds)))), foldTone})
	if ev.OOS.AmbiguousBars > 0 {
		s.Badges = append(s.Badges, Badge{"ambiguous", fmt.Sprintf("%s کندل مبهم؛ حد ضرر فرض شد", ltr(fmt.Sprint(ev.OOS.AmbiguousBars))), Warning})
	}
	for _, st := range ev.Stress {
		if st.Key == "fee_x2" && net.V > 0 && st.Error == "" && m(st.Metrics, "net_pnl").V <= 0 {
			s.Badges = append(s.Badges, Badge{"fragile_costs", "با کارمزد دو برابر زیان‌ده می‌شود", Warning})
		}
	}
	if g := ev.Grid; g != nil {
		var pos, n int
		for _, row := range g.Cells {
			for _, c := range row {
				if c.Invalid == "" {
					n++
					if c.Return.V > 0 {
						pos++
					}
				}
			}
		}
		tone := Positive
		if pos*2 < n {
			tone = Warning
		}
		s.Badges = append(s.Badges, Badge{"stability", fmt.Sprintf("پایداری پارامتر: %s از %s ترکیب همسایه سودده", ltr(fmt.Sprint(pos)), ltr(fmt.Sprint(n))), tone})
	}
	return s
}
