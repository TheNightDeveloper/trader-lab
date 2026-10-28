package strategy

import (
	"errors"
	"fmt"
	"slices"
	"time"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/money"
)

// learned is the recipe interpreter. It predicts with whichever model was valid
// when the bar opened (a walk-forward schedule: each model serves from its AsOf,
// trained only on labels ready by then) and goes long or flat when the signal
// changes. It never trains.
type learned struct {
	models     []model.Artifact // by AsOf
	r          model.Recipe
	exposure   money.Ratio
	stop, take money.Ratio
	filter     int // index of the filter feature, -1 = none
	long       map[string]bool
}

// NewLearned builds a strategy from trained models of one recipe.
func NewLearned(models []model.Artifact) (Strategy, error) {
	if len(models) == 0 {
		return nil, errors.New("strategy: no trained models")
	}
	r := models[0].Recipe
	if err := r.Validate(); err != nil {
		return nil, err
	}
	for _, m := range models {
		if m.RecipeHash != models[0].RecipeHash {
			return nil, fmt.Errorf("strategy: models %s and %s come from different recipes", models[0].ID, m.ID)
		}
	}
	ms := slices.Clone(models)
	slices.SortStableFunc(ms, func(a, b model.Artifact) int { return a.AsOf.Compare(b.AsOf) })
	ratio := func(f float64) money.Ratio { return money.Ratio(f*float64(money.RatioOne) + 0.5) }
	s := &learned{models: ms, r: r, exposure: ratio(r.Exposure), stop: ratio(r.StopLoss), take: ratio(r.TakeProfit), filter: -1, long: map[string]bool{}}
	if r.Filter != nil {
		s.filter = slices.Index(r.Features, r.Filter.Feature)
	}
	return s, nil
}

func (s *learned) OnBar(ctx RunContext, b data.Bar) ([]Intent, error) {
	i, _ := slices.BinarySearchFunc(s.models, b.OpenTime, func(m model.Artifact, t time.Time) int {
		if m.AsOf.After(t) {
			return 1
		}
		return -1
	})
	if i == 0 {
		return nil, nil // no model trained for this time yet
	}
	m := s.models[i-1]
	x, ok := feature.Row(s.r.Features, ctx.History(b.Instrument))
	if !ok {
		return nil, nil
	}
	p := m.Predict(x)
	want := p > s.r.Entry
	why := fmt.Sprintf("پیش‌بینی \u2066%.5f\u2069 در برابر آستانه \u2066%.5f\u2069", p, s.r.Entry)
	if want && s.filter >= 0 {
		if z := m.Scaler.Apply(x)[s.filter]; z > s.r.Filter.Max {
			want = false
			why += fmt.Sprintf("؛ فیلتر %s رد کرد", s.r.Filter.Feature)
		}
	}
	if was, seen := s.long[b.Instrument]; seen && was == want {
		return nil, nil
	}
	s.long[b.Instrument] = want
	in := Intent{Instrument: b.Instrument, Reason: why, ModelID: m.ID, RecipeVersion: m.RecipeHash[:12]}
	if want {
		in.Target, in.StopLoss, in.TakeProfit = s.exposure, s.stop, s.take
	}
	return []Intent{in}, nil
}
