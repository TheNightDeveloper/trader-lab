package search

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"

	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/experiment"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/strategy"
)

// CacheKey addresses one full OOS run. Every input is in it — engine build, data
// content, timeframe, strategy, every parameter, every cost and sizing setting,
// the split plan — so a cached result can only be reused when all of them match.
func CacheKey(build string, spec eval.Spec) (string, error) {
	cfg, err := spec.Sim.Normalized()
	if err != nil {
		return "", err
	}
	key := struct {
		V        int             `json:"v"`
		Build    string          `json:"build"`
		Datasets []string        `json:"datasets"`
		TF       string          `json:"tf"`
		Strategy string          `json:"strategy"`
		Params   strategy.Params `json:"params"`
		Sim      sim.Config      `json:"sim"`
		Split    eval.SplitPlan  `json:"split"`
	}{1, build, spec.DatasetIDs, string(spec.Timeframe), spec.Strategy, spec.Params, cfg, spec.Split}
	b, err := json.Marshal(key)
	if err != nil {
		return "", err
	}
	h := sha256.Sum256(b)
	return hex.EncodeToString(h[:]), nil
}

// Check applies hard constraints. An invalid metric (too few samples) fails its
// constraint: an unknown value can never satisfy a hard limit.
func Check(cs []experiment.Constraint, ms []metrics.Metric) (bool, []string) {
	var violations []string
	for _, c := range cs {
		m, ok := metrics.Get(ms, c.Metric)
		label := metrics.Definitions[c.Metric].Label
		if !ok || !m.Valid {
			violations = append(violations, fmt.Sprintf("%s نامعتبر است", label))
			continue
		}
		limit, err := money.Parse(c.Value, m.Scale)
		if err != nil {
			violations = append(violations, fmt.Sprintf("%s: حد نامعتبر", label))
			continue
		}
		if (c.Op == ">=" && m.V < limit) || (c.Op == "<=" && m.V > limit) {
			violations = append(violations, fmt.Sprintf("%s %s %s نیست", label, c.Op, c.Value))
		}
	}
	return len(violations) == 0, violations
}

// AttemptResult is one finished attempt as selection sees it.
type AttemptResult struct {
	Candidate int
	Params    strategy.Params
	DatasetID string
	Status    string
	Eligible  bool
	Metrics   []metrics.Metric
}

// Result of an experiment: the chosen candidate or a recorded "none".
type Result struct {
	Chosen             int             `json:"chosen"` // candidate number, 0 = none
	Params             strategy.Params `json:"params,omitempty"`
	Objective          *metrics.Metric `json:"objective,omitempty"` // mean over pairs
	Candidates         int             `json:"candidates"`
	EligibleCandidates int             `json:"eligible_candidates"`
	Attempts           int             `json:"attempts"` // every attempt, failed and cancelled included
	ReportIDs          []string        `json:"report_ids,omitempty"`
	Reason             string          `json:"reason,omitempty"` // Persian, when nothing was chosen
}

// Select applies the pre-declared rule: a candidate is eligible only if every
// pair finished and passed every hard constraint; among eligible candidates the
// objective (mean over pairs) decides, ties to the earlier candidate. "No
// eligible candidate" is a valid result.
func Select(def experiment.Definition, attempts []AttemptResult) Result {
	type agg struct {
		params  strategy.Params
		ok      bool
		sum     int64
		n       int64
		scale   int32
		invalid bool
	}
	byCand := map[int]*agg{}
	var order []int
	for _, a := range attempts {
		g := byCand[a.Candidate]
		if g == nil {
			g = &agg{params: a.Params, ok: true}
			byCand[a.Candidate] = g
			order = append(order, a.Candidate)
		}
		if a.Status != "done" || !a.Eligible {
			g.ok = false
			continue
		}
		m, found := metrics.Get(a.Metrics, def.Objective.Metric)
		if !found || !m.Valid {
			g.invalid = true
			continue
		}
		g.sum += m.V
		g.n++
		g.scale = m.Scale
	}
	r := Result{Candidates: len(order), Attempts: len(attempts)}
	best, bestV := 0, int64(0)
	for _, c := range order {
		g := byCand[c]
		if !g.ok || g.invalid || g.n == 0 {
			continue
		}
		r.EligibleCandidates++
		v, _ := money.MulDiv(g.sum, 1, g.n, money.HalfEven)
		better := best == 0 || (def.Objective.Maximize && v > bestV) || (!def.Objective.Maximize && v < bestV)
		if better {
			best, bestV = c, v
		}
	}
	if best == 0 {
		r.Reason = "هیچ نامزدی همه محدودیت‌های سخت را روی همه جفت‌ها برآورده نکرد."
		return r
	}
	g := byCand[best]
	unit, _, _ := metrics.UnitOf(def.Objective.Metric)
	r.Chosen, r.Params = best, g.params
	r.Objective = &metrics.Metric{Key: def.Objective.Metric, V: bestV, Scale: g.scale, Unit: unit, Valid: true}
	return r
}
