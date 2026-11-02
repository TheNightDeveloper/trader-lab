package loop

import (
	"context"
	"fmt"
	"time"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/strategy"
)

// CurrentEvidence rejects historical recommendations whose fold and forward
// evidence used older semantics. They remain readable and can be rejected.
func CurrentEvidence(d Doc) bool {
	return d.EvaluationVersion == eval.Version && d.TrainingCutoff != nil &&
		d.ModelCreatedAt != nil && d.FreezeAt != nil && d.TradeStart != nil &&
		!d.ModelCreatedAt.Before(*d.TrainingCutoff) && !d.FreezeAt.Before(*d.ModelCreatedAt) &&
		!d.TradeStart.Before(*d.FreezeAt)
}

// Advance updates every cycle in its forward test and decides those whose test
// is complete. Called by the scheduler; tests call it with a virtual clock.
func (l *Loop) Advance(ctx context.Context) error {
	open, err := l.Store.OpenCycles(ctx)
	if err != nil {
		return err
	}
	for _, row := range open {
		if row.State != ForwardTest {
			continue
		}
		c, err := l.load(ctx, l.Store.Queries, row.ID)
		if err != nil {
			return err
		}
		if err := l.forward(ctx, &c); err != nil {
			return fmt.Errorf("cycle %d forward test: %w", row.ID, err)
		}
	}
	return nil
}

// forward runs the frozen challenger and the champion over the bars that became
// available after the freeze, with the same simulator and costs.
func (l *Loop) forward(ctx context.Context, c *cycle) error {
	if !CurrentEvidence(c.doc) || c.doc.Challenger == nil {
		return l.finish(c, Failed, "شواهد چرخه با قرارداد فعلی سازگار نیست؛ یک چرخه تازه اجرا کنید.")
	}
	cfg := c.doc.Config
	tf := cfg.Timeframe.Duration()
	start := *c.doc.TradeStart
	now := l.Clock.Now().UTC()
	through := dataEnd(now, tf)
	end := start.Add(time.Duration(cfg.Gate.ForwardDays) * 24 * time.Hour)
	if through.After(end) {
		through = end // a late scheduler tick must not change the registered window
	}
	if !through.After(start) {
		return nil
	}
	if err := l.Limiter.Acquire(ctx); err != nil {
		return err
	}
	defer l.Limiter.Release()
	chal, err := l.artifact(ctx, c.doc.Challenger.ModelID)
	if err != nil {
		return err
	}
	champ, err := l.artifact(ctx, c.doc.Champion.ModelID)
	if err != nil {
		return err
	}
	// Warm-up: enough earlier bars for the first features after the freeze.
	warm := time.Duration(max(feature.Lookback(chal.Recipe.Features), feature.Lookback(champ.Recipe.Features))+2) * tf
	rawCount, err := data.RawBarCount(cfg.Timeframe, start.Add(-warm), through)
	if err != nil {
		return err
	}
	if rawCount > data.MaxRawBars/len(cfg.Symbols) {
		return data.ErrLimit
	}
	if int64(through.Sub(start.Add(-warm))/tf)*int64(len(cfg.Symbols)) > int64(cfg.MaxBars) {
		return fmt.Errorf("%w: forward window exceeds bar budget", ErrConfig)
	}
	bars := map[string][]data.Bar{}
	for _, sym := range cfg.Symbols {
		bs, err := data.Reader{Q: l.Store.Queries}.Bars(ctx, data.Query{Symbol: sym, Timeframe: cfg.Timeframe, From: start.Add(-warm), To: through, AsOf: now})
		if err != nil {
			return err
		}
		bars[sym] = bs
	}
	through, missing := coveredThrough(bars, cfg.Symbols, start, through, now, tf)
	fwd := &Forward{Through: through, Days: int(through.Sub(start) / (24 * time.Hour)), MissingSymbols: missing}
	c.doc.Forward = fwd
	c.doc.Steps[ForwardTest] = fmt.Sprintf("%d / %d d", fwd.Days, cfg.Gate.ForwardDays)
	if len(missing) > 0 {
		c.doc.Steps[ForwardTest] += fmt.Sprintf(" — پوشش داده ناقص: %v", missing)
	}
	if !through.After(start) {
		c.doc.Gate = gate(cfg.Gate, &c.doc, false)
		return l.save(ctx, l.Store.Queries, c)
	}
	// Limit inputs to the proven common candle interval; eval also clips scores
	// by the observation time of each event.
	for sym, bs := range bars {
		kept := bs[:0]
		for _, b := range bs {
			if !b.AvailableAt.After(now) && b.OpenTime.Before(through) {
				kept = append(kept, b)
			}
		}
		bars[sym] = kept
	}
	w := eval.Window{From: start, To: through}
	split := eval.Split{Folds: []eval.Fold{{Index: 1, Test: w}}, OOS: w, Holdout: eval.Window{From: through, To: through}}
	run := func(m model.Artifact) ([]metrics.Metric, error) {
		s, err := strategy.NewLearned([]model.Artifact{m})
		if err != nil {
			return nil, err
		}
		v, _, _, err := eval.RunSplit(ctx, s, cfg.sim(), report.Specs(), bars, split)
		return v.Metrics, err
	}
	if fwd.Challenger, err = run(chal); err != nil {
		return err
	}
	if fwd.Champion, err = run(champ); err != nil {
		return err
	}
	complete := fwd.Days >= cfg.Gate.ForwardDays && len(missing) == 0
	c.doc.Gate = gate(cfg.Gate, &c.doc, complete)
	if !complete {
		return l.save(ctx, l.Store.Queries, c)
	}

	// Decision. Record the forward window as dataset versions, then judge.
	for _, sym := range cfg.Symbols {
		ds, _, err := data.CreateDataset(ctx, l.Store, data.DatasetSpec{Symbol: sym, Timeframe: cfg.Timeframe, From: start.Add(-warm), To: through, GapPolicy: data.GapFlag})
		if err != nil {
			return err
		}
		c.doc.ForwardDatasets = append(c.doc.ForwardDatasets, ds.ID)
	}
	c.doc.Steps[Decision] = "—"
	// The forward data used here becomes training-only for later cycles.
	c.row.ConsumedUntil = &through
	outcome, reason := decide(c.doc.Gate)
	if outcome == Recommended {
		c.row.State, c.row.Outcome, c.row.Reason = Decision, Recommended, reason
		return l.save(ctx, l.Store.Queries, c)
	}
	return l.finish(c, outcome, reason)
}

// coveredThrough proves a contiguous common prefix of real, complete bars.
// Wall-clock age, sparse bars, synthetic gap fills and partial aggregates are
// never substitutes for observed coverage of every configured instrument.
func coveredThrough(bars map[string][]data.Bar, symbols []string, start, end, asOf time.Time, tf time.Duration) (time.Time, []string) {
	through := end
	var missing []string
	if len(symbols) == 0 {
		return start, []string{"no instruments"}
	}
	for _, sym := range symbols {
		t := start
		bs := bars[sym]
		for i := firstAtOrAfter(bs, start); i < len(bs) && t.Before(end); i++ {
			b := bs[i]
			if b.Instrument != sym || !b.OpenTime.Equal(t) || !b.CloseTime.Equal(t.Add(tf)) ||
				b.AvailableAt.Before(b.CloseTime) || b.AvailableAt.After(asOf) || b.Flags&(data.FlagFilled|data.FlagPartial) != 0 {
				break
			}
			t = b.CloseTime
		}
		if t.Before(end) {
			missing = append(missing, sym)
		}
		if t.Before(through) {
			through = t
		}
	}
	return through, missing
}

// decide: all pass → recommend. Otherwise not better when the improvement
// condition failed, else the first failed condition.
func decide(items []GateItem) (string, string) {
	var first *GateItem
	for i, g := range items {
		if g.Status == "pass" {
			continue
		}
		if g.Key == "improvement" {
			return NotBetter, "نامزد بهتر نیست: " + g.Text
		}
		if first == nil {
			first = &items[i]
		}
	}
	if first != nil {
		return GateFailed, "رد: " + first.Text
	}
	return Recommended, "همه شرط‌های دروازه برقرار است؛ ارتقا منتظر تأیید شماست."
}

// ltr isolates numbers inside Persian text.
func ltr(s string) string { return "\u2066" + s + "\u2069" }

// pct formats a ratio at scale 6 (ppm) as a percent with two decimals.
func pct(ppm int64, signed bool) string {
	sign := ""
	switch {
	case ppm < 0:
		sign, ppm = "−", -ppm
	case signed && ppm > 0:
		sign = "+"
	}
	h := (ppm + 50) / 100 // hundredths of a percent, half up
	return fmt.Sprintf("%s%d.%02d%%", sign, h/100, h%100)
}

// points formats a ratio difference as percentage points ("1.00").
func points(ppm int64, signed bool) string {
	s := pct(ppm, signed)
	return s[:len(s)-1]
}

// gate evaluates the pre-registered conditions. Before the forward test is
// complete, trade and day counts are pending; at the decision every pending
// condition fails.
func gate(g Gate, d *Doc, final bool) []GateItem {
	var fc, fp []metrics.Metric
	days := 0
	if d.Forward != nil {
		fc, fp, days = d.Forward.Challenger, d.Forward.Champion, d.Forward.Days
	}
	status := func(ok, known bool) string {
		switch {
		case !known && !final:
			return "pending"
		case ok && known:
			return "pass"
		default:
			return "fail"
		}
	}
	var out []GateItem

	dd, okDD := metricOK(fc, "max_drawdown")
	walkDD, okWalk := metricOK(d.Challenger.walk(), "max_drawdown")
	t := fmt.Sprintf("همه محدودیت‌های سخت رعایت شده (افت سرمایه کمتر از %s)", ltr(pct(int64(g.MaxDrawdown), false)))
	if okDD {
		t += fmt.Sprintf(" — پیشرو %s", ltr(pct(dd, false)))
	}
	out = append(out, GateItem{"constraints", status(dd <= int64(g.MaxDrawdown) && okWalk && walkDD <= int64(g.MaxDrawdown), okDD), t})

	rc, ok1 := metricOK(fc, "total_return")
	rp, ok2 := metricOK(fp, "total_return")
	t = fmt.Sprintf("بازده خالص پیشرو ≥ قهرمان + %s واحد درصد", ltr(points(int64(g.MinImprovement), false)))
	if ok1 && ok2 {
		t += fmt.Sprintf(" (اکنون %s)", ltr(points(rc-rp, true)))
	}
	out = append(out, GateItem{"improvement", status(rc-rp >= int64(g.MinImprovement), ok1 && ok2), t})

	dp, ok3 := metricOK(fp, "max_drawdown")
	t = fmt.Sprintf("افت سرمایه حداکثر %s واحد درصد بدتر از قهرمان", ltr(points(int64(g.MaxDDDegradation), false)))
	if okDD && ok3 {
		t += fmt.Sprintf(" (اکنون %s)", ltr(points(dd-dp, true)))
	}
	out = append(out, GateItem{"drawdown", status(dd-dp <= int64(g.MaxDDDegradation), okDD && ok3), t})

	trades := int(metricV(fc, "trades"))
	out = append(out, GateItem{"trades", status(true, trades >= g.MinForwardTrades),
		fmt.Sprintf("حداقل %s معامله در دوره پیشرو (اکنون %s)", ltr(fmt.Sprint(g.MinForwardTrades)), ltr(fmt.Sprint(trades)))})
	out = append(out, GateItem{"days", status(true, days >= g.ForwardDays),
		fmt.Sprintf("حداقل %s روز آزمون پیشرو (اکنون %s)", ltr(fmt.Sprint(g.ForwardDays)), ltr(fmt.Sprint(days)))})

	wins, folds := 0, 0
	if d.Walk != nil {
		wins, folds = d.Walk.Wins, len(d.Walk.Folds)
	}
	out = append(out, GateItem{"walk", status(wins >= g.MinWalkWins, d.Walk != nil),
		fmt.Sprintf("برتر در گام‌به‌گام: %s از %s گام (لازم: %s)", ltr(fmt.Sprint(wins)), ltr(fmt.Sprint(folds)), ltr(fmt.Sprint(g.MinWalkWins)))})
	return out
}

func (c *Contender) walk() []metrics.Metric {
	if c == nil {
		return nil
	}
	return c.Walk
}
