// Package train fits models from recipes. It is the optimizer side: sim, eval and
// metrics never import it (depguard).
package train

import (
	"context"
	"errors"
	"fmt"
	"math"
	"slices"
	"time"

	"gonum.org/v1/gonum/mat"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/model"
)

var ErrTooFew = errors.New("train: too few samples")

// Meta is recorded in the artifact; it does not change the fit.
type Meta struct {
	Algorithm  string
	DatasetIDs []string
	Seed       uint64
	Parent     string
}

// MinSamples a fit needs: 30, or 10 per feature.
func MinSamples(features int) int { return max(30, 10*features) }

// Fit trains r on samples, every one of which must have been available (features
// and label) at asOf; otherwise it fails with feature.ErrLookAhead.
func Fit(r model.Recipe, samples []feature.Sample, from, to, asOf time.Time, meta Meta) (model.Artifact, error) {
	if err := r.Validate(); err != nil {
		return model.Artifact{}, err
	}
	if err := feature.CheckAsOf(samples, asOf); err != nil {
		return model.Artifact{}, err
	}
	if n := len(samples); n < MinSamples(len(r.Features)) {
		return model.Artifact{}, fmt.Errorf("%w: %d (need %d)", ErrTooFew, n, MinSamples(len(r.Features)))
	}
	sc, err := feature.FitScaler(samples, asOf)
	if err != nil {
		return model.Artifact{}, err
	}
	z := make([][]float64, len(samples))
	for i, s := range samples {
		z[i] = sc.Apply(s.X)
	}
	a := model.Artifact{
		Algorithm: meta.Algorithm, Recipe: r, RecipeHash: r.Hash(), DatasetIDs: meta.DatasetIDs,
		TrainFrom: from.UTC(), TrainTo: to.UTC(), AsOf: asOf.UTC(), Seed: meta.Seed, Scaler: sc,
		Samples: len(samples), Parent: meta.Parent,
	}
	switch r.Model {
	case "ridge":
		a.Weights, a.Intercept, err = ridge(z, samples, r.Alpha)
	case "logistic":
		a.Weights, a.Intercept, err = logistic(z, samples, r.Alpha)
	}
	if err != nil {
		return model.Artifact{}, err
	}
	a.TrainError = trainError(a, samples)
	a.Seal()
	return a, nil
}

// ridge solves (ZᵀZ + αn·I) w = Zᵀ(y − ȳ); the intercept ȳ is not penalized
// (Z is centered by the scaler).
func ridge(z [][]float64, s []feature.Sample, alpha float64) ([]float64, float64, error) {
	n, k := len(z), len(z[0])
	var ybar float64
	for _, r := range s {
		ybar += r.Y / float64(n)
	}
	A := mat.NewSymDense(k, nil)
	b := mat.NewVecDense(k, nil)
	for i, row := range z {
		for p := range k {
			b.SetVec(p, b.AtVec(p)+row[p]*(s[i].Y-ybar))
			for q := p; q < k; q++ {
				A.SetSym(p, q, A.At(p, q)+row[p]*row[q])
			}
		}
	}
	for p := range k {
		A.SetSym(p, p, A.At(p, p)+alpha*float64(n))
	}
	w, err := solve(A, b)
	return w, ybar, err
}

// logistic fits P(y > 0) with L2 by Newton's method (IRLS), at most 50 steps.
func logistic(z [][]float64, s []feature.Sample, alpha float64) ([]float64, float64, error) {
	n, k := len(z), len(z[0])
	w := make([]float64, k+1) // [0] intercept
	x := func(i, p int) float64 {
		if p == 0 {
			return 1
		}
		return z[i][p-1]
	}
	for range 50 {
		H := mat.NewSymDense(k+1, nil)
		g := mat.NewVecDense(k+1, nil)
		for i := range n {
			v := w[0]
			for p := 1; p <= k; p++ {
				v += w[p] * z[i][p-1]
			}
			pr := model.Sigmoid(v)
			y := 0.0
			if s[i].Y > 0 {
				y = 1
			}
			wt := pr * (1 - pr)
			for p := 0; p <= k; p++ {
				g.SetVec(p, g.AtVec(p)+(pr-y)*x(i, p))
				for q := p; q <= k; q++ {
					H.SetSym(p, q, H.At(p, q)+wt*x(i, p)*x(i, q))
				}
			}
		}
		H.SetSym(0, 0, H.At(0, 0)+1e-9) // keeps a one-sided sample solvable
		for p := 1; p <= k; p++ {
			g.SetVec(p, g.AtVec(p)+alpha*float64(n)*w[p])
			H.SetSym(p, p, H.At(p, p)+alpha*float64(n))
		}
		d, err := solve(H, g)
		if err != nil {
			return nil, 0, err
		}
		step := 0.0
		for p := range w {
			w[p] -= d[p]
			step = math.Max(step, math.Abs(d[p]))
		}
		if step < 1e-10 {
			break
		}
	}
	return w[1:], w[0], nil
}

func solve(A *mat.SymDense, b *mat.VecDense) ([]float64, error) {
	var ch mat.Cholesky
	if !ch.Factorize(A) {
		return nil, errors.New("train: system is not positive definite (constant features or no samples?)")
	}
	var x mat.VecDense
	if err := ch.SolveVecTo(&x, b); err != nil {
		return nil, fmt.Errorf("train: %w", err)
	}
	return x.RawVector().Data, nil
}

func trainError(a model.Artifact, s []feature.Sample) float64 {
	var sum float64
	for _, r := range s {
		p := a.Predict(r.X)
		if a.Recipe.Model == "logistic" {
			p = min(max(p, 1e-12), 1-1e-12)
			if r.Y > 0 {
				sum -= math.Log(p)
			} else {
				sum -= math.Log(1 - p)
			}
			continue
		}
		sum += (p - r.Y) * (p - r.Y)
	}
	if a.Recipe.Model == "logistic" {
		return sum / float64(len(s))
	}
	return math.Sqrt(sum / float64(len(s)))
}

// Step is one retraining point of a walk-forward: train on feature bars opened in
// [From, To) whose labels were ready at AsOf; the model serves from AsOf on.
type Step struct {
	From, To, AsOf time.Time
}

// WalkForward trains one model per step, each on its own past only. Symbols are
// pooled in sorted order. A step whose window has no ready labels fails: there is
// no "train once on everything".
func WalkForward(ctx context.Context, r model.Recipe, bars map[string][]data.Bar, steps []Step, meta Meta) ([]model.Artifact, error) {
	syms := make([]string, 0, len(bars))
	for s := range bars {
		syms = append(syms, s)
	}
	slices.Sort(syms)
	out := make([]model.Artifact, 0, len(steps))
	for i, st := range steps {
		if err := ctx.Err(); err != nil {
			return nil, err
		}
		if st.To.After(st.AsOf) {
			return nil, fmt.Errorf("%w: step %d trains on bars up to %s but serves from %s", feature.ErrLookAhead, i+1, st.To, st.AsOf)
		}
		var samples []feature.Sample
		for _, s := range syms {
			ss, err := feature.Samples(r.Features, r.Horizon, bars[s], st.From, st.To, st.AsOf)
			if err != nil {
				return nil, err
			}
			samples = append(samples, ss...)
		}
		a, err := Fit(r, samples, st.From, st.To, st.AsOf, meta)
		if err != nil {
			return nil, fmt.Errorf("step %d: %w", i+1, err)
		}
		out = append(out, a)
	}
	return out, nil
}
