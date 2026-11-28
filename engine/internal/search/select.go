package search

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"math/big"
	"slices"

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
		V          int             `json:"v"`
		Evaluation string          `json:"evaluation_version"`
		Build      string          `json:"build"`
		Datasets   []string        `json:"datasets"`
		TF         string          `json:"tf"`
		Strategy   string          `json:"strategy"`
		Params     strategy.Params `json:"params"`
		Sim        sim.Config      `json:"sim"`
		Split      eval.SplitPlan  `json:"split"`
	}{2, eval.Version, build, spec.DatasetIDs, string(spec.Timeframe), spec.Strategy, spec.Params, cfg, spec.Split}
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
			// The operator and limit read left to right inside the Persian sentence;
			// without the isolate, RTL layout mirrors "<=" and swaps it with the number.
			violations = append(violations, fmt.Sprintf("%s \u2066%s %s\u2069 نیست", label, c.Op, c.Value))
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
		sum     big.Int
		n       int64
		scale   int32
		invalid bool
		seen    map[string]bool
	}
	expected := make(map[string]bool, len(def.DatasetIDs))
	for _, id := range def.DatasetIDs {
		expected[id] = true
	}
	byCand := map[int]*agg{}
	var order []int
	for _, a := range attempts {
		g := byCand[a.Candidate]
		if g == nil {
			g = &agg{params: a.Params, ok: true, seen: map[string]bool{}}
			byCand[a.Candidate] = g
			order = append(order, a.Candidate)
		}
		// Every registered pair must contribute exactly once, even after recovery.
		if !expected[a.DatasetID] || g.seen[a.DatasetID] {
			g.ok = false
		}
		g.seen[a.DatasetID] = true
		if a.Status != "done" || !a.Eligible {
			g.ok = false
			continue
		}
		m, found := metrics.Get(a.Metrics, def.Objective.Metric)
		_, scale, known := metrics.UnitOf(def.Objective.Metric)
		if !found || !m.Valid || !known || m.Scale != scale {
			g.invalid = true
			continue
		}
		g.sum.Add(&g.sum, big.NewInt(m.V))
		g.n++
		g.scale = m.Scale
	}
	slices.Sort(order) // Completion/database order must not decide a tie.
	r := Result{Candidates: len(order), Attempts: len(attempts)}
	best, bestV := 0, int64(0)
	for _, c := range order {
		g := byCand[c]
		if !g.ok || g.invalid || g.n == 0 || len(g.seen) != len(expected) {
			continue
		}
		r.EligibleCandidates++
		v := mean(&g.sum, g.n)
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

// mean keeps the sum wide; an average of int64 inputs still fits in int64.
func mean(sum *big.Int, n int64) int64 {
	den := big.NewInt(n)
	q, rem := new(big.Int), new(big.Int)
	q.QuoRem(sum, den, rem)
	rem.Abs(rem).Lsh(rem, 1)
	if cmp := rem.Cmp(den); cmp > 0 || (cmp == 0 && q.Bit(0) == 1) {
		q.Add(q, big.NewInt(int64(sum.Sign()))) // Half-even, including negative ties.
	}
	return q.Int64()
}
