package strategy_test

import (
	"context"
	"testing"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/model/train"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/strategy"
)

type learnedBenchContext struct{ bars []data.Bar }

func (c learnedBenchContext) History(string) []data.Bar { return c.bars }
func (learnedBenchContext) Position(string) money.Qty   { return money.Qty{} }

// Most input bars leave exposure unchanged; explanations need not allocate there.
func BenchmarkLearnedSteadyTarget(b *testing.B) {
	bs := bars(450, 11)
	asOf := bs[300].OpenTime
	rows, err := feature.Samples(recipe.Features, recipe.Horizon, bs, t0, asOf, asOf)
	if err != nil {
		b.Fatal(err)
	}
	a, err := train.Fit(context.Background(), recipe, rows, t0, asOf, asOf, train.Meta{})
	if err != nil {
		b.Fatal(err)
	}
	s, err := strategy.NewLearned([]model.Artifact{a})
	if err != nil {
		b.Fatal(err)
	}
	ctx := learnedBenchContext{bs}
	last := bs[len(bs)-1]
	if _, err := s.OnBar(ctx, last); err != nil {
		b.Fatal(err)
	}
	b.ReportAllocs()
	for b.Loop() {
		intents, err := s.OnBar(ctx, last)
		if err != nil || len(intents) != 0 {
			b.Fatalf("unstable target: %v, %v", intents, err)
		}
	}
}
