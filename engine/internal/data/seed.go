package data

import (
	"context"
	"fmt"

	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/store/db"
)

// SeedInstruments writes the default registry. Safe to run on every start.
func SeedInstruments(ctx context.Context, q *db.Queries) error {
	for _, s := range instrument.Defaults() {
		if err := s.Validate(); err != nil {
			return err
		}
		err := q.UpsertInstrument(ctx, db.UpsertInstrumentParams{
			Symbol: s.Symbol, Base: s.Base.Code, Quote: s.Quote.Code,
			BaseScale: s.Base.Scale, QuoteScale: s.Quote.Scale, PriceScale: s.Tick.Scale,
			Tick: s.Tick.V, Lot: s.Lot.V, MinNotional: s.MinNotional.V,
		})
		if err != nil {
			return fmt.Errorf("seed %s: %w", s.Symbol, err)
		}
	}
	return nil
}
