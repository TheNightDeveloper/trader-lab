package eval

import (
	"fmt"
	"slices"
	"strings"
	"time"

	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
)

// Comparable is what Compare needs from a stored report.
type Comparable struct {
	ID       string
	Spec     Spec
	Split    Split
	Metrics  []metrics.Metric // out of sample
	Attempts int              // candidates tried to find this one (M4); 1 for a single run
}

type Assumption struct {
	Key     string   `json:"key"`
	Label   string   `json:"label"`
	Values  []string `json:"values"`
	Differs bool     `json:"differs"`
	// Blocking differences make results incomparable; the strategy and its
	// parameters are what is being compared, so they never block.
	Blocking bool `json:"blocking"`
}

type Comparison struct {
	IDs         []string           `json:"ids"`
	Assumptions []Assumption       `json:"assumptions"`
	Eligible    []bool             `json:"eligible"`
	Reasons     [][]string         `json:"reasons"` // per report: why it is not comparable to the first
	Metrics     [][]metrics.Metric `json:"metrics"`
	Conclusion  string             `json:"conclusion"` // Persian
}

// Compare lists assumptions first. A report whose blocking assumptions differ from
// the first (reference) report is ineligible, with the reasons.
func Compare(rs []Comparable) Comparison {
	c := Comparison{}
	rows := []struct {
		key, label string
		blocking   bool
		val        func(r Comparable) string
	}{
		{"evaluation_version", "نسخه ارزیابی", true, func(r Comparable) string {
			if r.Spec.EvaluationVersion == "" {
				return "legacy"
			}
			return r.Spec.EvaluationVersion
		}},
		{"datasets", "نسخه داده", true, func(r Comparable) string { return strings.Join(r.Spec.DatasetIDs, ", ") }},
		{"period", "دوره خارج از نمونه", true, func(r Comparable) string {
			return r.Split.OOS.From.UTC().Format(time.RFC3339Nano) + " → " + r.Split.OOS.To.UTC().Format(time.RFC3339Nano)
		}},
		{"timeframe", "تایم‌فریم", true, func(r Comparable) string { return string(r.Spec.Timeframe) }},
		{"fee", "کارمزد هر سمت", true, func(r Comparable) string { return exactPct(r.Spec.Sim.FeeRate) }},
		{"slippage", "لغزش هر سمت", true, func(r Comparable) string { return exactPct(r.Spec.Sim.SlipRate) }},
		{"capital", "سرمایه اولیه", true, func(r Comparable) string { return r.Spec.Sim.Capital.String() }},
		{"sizing", "اندازه موقعیت", true, func(r Comparable) string {
			if r.Spec.Sim.Sizing == "fixed" {
				return "fixed " + r.Spec.Sim.FixedUSDT.String()
			}
			return string(r.Spec.Sim.Sizing)
		}},
		{"latency", "تأخیر اجرا (کندل)", true, func(r Comparable) string { return fmt.Sprint(r.Spec.Sim.LatencyBars) }},
		{"split", "تقسیم داده", true, func(r Comparable) string {
			mode := "expanding"
			if r.Spec.Split.Rolling {
				mode = "rolling"
			}
			return fmt.Sprintf("%d folds · %s · holdout %s · embargo %s", r.Spec.Split.Folds, mode, exactPct(r.Spec.Split.Holdout), r.Spec.Split.Embargo)
		}},
		{"attempts", "تعداد تلاش‌ها", false, func(r Comparable) string { return fmt.Sprint(max(1, r.Attempts)) }},
		{"strategy", "راهبرد و پارامترها", false, func(r Comparable) string { return r.Spec.Strategy + " " + params(r.Spec) }},
	}
	for _, r := range rs {
		c.IDs = append(c.IDs, r.ID)
		c.Metrics = append(c.Metrics, r.Metrics)
	}
	c.Eligible = make([]bool, len(rs))
	c.Reasons = make([][]string, len(rs))
	for i := range rs {
		c.Eligible[i] = true
	}
	for _, row := range rows {
		a := Assumption{Key: row.key, Label: row.label, Blocking: row.blocking}
		for _, r := range rs {
			a.Values = append(a.Values, row.val(r))
		}
		for i := 1; i < len(a.Values); i++ {
			if assumptionKey(row.key, rs[i], a.Values[i]) != assumptionKey(row.key, rs[0], a.Values[0]) {
				a.Differs = true
				if row.blocking {
					c.Eligible[i] = false
					c.Reasons[i] = append(c.Reasons[i], row.label+" متفاوت است")
				}
			}
		}
		c.Assumptions = append(c.Assumptions, a)
	}
	c.Conclusion = conclude(rs, c.Eligible)
	return c
}

// conclude names the best eligible report by net return, unless some report has
// too few trades for any ranking to mean something.
func conclude(rs []Comparable, eligible []bool) string {
	var thin []string
	best, bestRet := -1, int64(0)
	n := 0
	for i, r := range rs {
		if m(r.Metrics, "closed_trades").V < MinReliableTrades {
			thin = append(thin, label(i))
		}
		if !eligible[i] {
			continue
		}
		n++
		if ret := m(r.Metrics, "total_return"); ret.Valid && (best < 0 || ret.V > bestRet) {
			best, bestRet = i, ret.V
		}
	}
	var b strings.Builder
	fmt.Fprintf(&b, "از %s اجرا، %s اجرا با فرض‌های یکسان قابل مقایسه است.", ltr(fmt.Sprint(len(rs))), ltr(fmt.Sprint(n)))
	switch {
	case len(thin) > 0:
		fmt.Fprintf(&b, " رتبه‌بندی قطعی ممکن نیست: %s کمتر از %s معامله بسته دارد.", strings.Join(thin, "، "), ltr(fmt.Sprint(MinReliableTrades)))
	case best >= 0:
		fmt.Fprintf(&b, " بیشترین بازده خالص در میان آن‌ها: %s با %s.", label(best), ltr(Pct(bestRet)))
	}
	if n < len(rs) {
		b.WriteString(" اجراهای ناهم‌فرض فقط برای مشاهده آمده‌اند.")
	}
	return b.String()
}

// label is the column letter of the i-th report: A, B, C…
func label(i int) string { return string(rune('A' + i)) }

func params(s Spec) string {
	keys := make([]string, 0, len(s.Params))
	for k := range s.Params {
		keys = append(keys, k)
	}
	slices.Sort(keys)
	parts := make([]string, len(keys))
	for i, k := range keys {
		parts[i] = fmt.Sprintf("%s=%g", k, s.Params[k])
	}
	return strings.Join(parts, " ")
}

// Display rounding is never an identity for costs, timestamps or split settings.
func assumptionKey(key string, r Comparable, display string) string {
	switch key {
	case "fee":
		return r.Spec.Sim.FeeRate.String()
	case "slippage":
		return r.Spec.Sim.SlipRate.String()
	case "period":
		return r.Split.OOS.From.UTC().Format(time.RFC3339Nano) + "/" + r.Split.OOS.To.UTC().Format(time.RFC3339Nano)
	case "split":
		return fmt.Sprintf("%#v", r.Spec.Split.withDefaults())
	default:
		return display
	}
}

// A one-ppm cost difference needs four percent decimals to remain visible.
func exactPct(rate money.Ratio) string {
	sign := ""
	if rate > 0 {
		sign = "+"
	}
	return sign + money.Format(int64(rate), 4) + "%"
}
