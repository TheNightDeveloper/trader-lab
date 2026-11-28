package report

import (
	"bytes"
	"context"
	"encoding/json"
	"math/big"
	"reflect"
	"slices"
	"time"

	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store/db"
)

// jsonEqual accepts jsonb formatting changes without passing numbers through float64.
func jsonEqual(a, b []byte) bool {
	if !json.Valid(a) || !json.Valid(b) {
		return false
	}
	decode := func(raw []byte) (any, error) {
		d := json.NewDecoder(bytes.NewReader(raw))
		d.UseNumber()
		var v any
		err := d.Decode(&v)
		return v, err
	}
	x, err := decode(a)
	if err != nil {
		return false
	}
	y, err := decode(b)
	return err == nil && jsonValueEqual(x, y)
}

func jsonValueEqual(x, y any) bool {
	switch a := x.(type) {
	case json.Number:
		b, ok := y.(json.Number)
		if !ok {
			return false
		}
		ar, aok := new(big.Rat).SetString(string(a))
		br, bok := new(big.Rat).SetString(string(b))
		return aok && bok && ar.Cmp(br) == 0
	case map[string]any:
		b, ok := y.(map[string]any)
		if !ok || len(a) != len(b) {
			return false
		}
		for k, v := range a {
			w, ok := b[k]
			if !ok || !jsonValueEqual(v, w) {
				return false
			}
		}
		return true
	case []any:
		b, ok := y.([]any)
		return ok && slices.EqualFunc(a, b, jsonValueEqual)
	default:
		return reflect.DeepEqual(x, y)
	}
}

type canonicalRun struct {
	trades    []db.CopyTradesParams
	fills     []db.CopyFillsParams
	decisions []db.CopyDecisionsParams
}

// PostgreSQL timestamps persist microseconds; location and sub-microsecond bits are not stored.
func recordTime(t time.Time) time.Time { return t.UTC().Truncate(time.Microsecond) }

func canonicalTrade(t db.CopyTradesParams) db.CopyTradesParams {
	t.OpenedAt = recordTime(t.OpenedAt)
	if t.ClosedAt != nil {
		closed := recordTime(*t.ClosedAt)
		t.ClosedAt = &closed
	}
	return t
}

func (s Service) sameRun(ctx context.Context, id, run string, r *sim.Result) (bool, error) {
	want := runRecords(id, run, r)
	trades, err := s.Store.AllTrades(ctx, db.AllTradesParams{ReportID: id, Run: run})
	if err != nil {
		return false, err
	}
	if !slices.EqualFunc(trades, want.trades, func(a db.Trade, b db.CopyTradesParams) bool {
		return reflect.DeepEqual(canonicalTrade(db.CopyTradesParams(a)), canonicalTrade(b))
	}) {
		return false, nil
	}
	fills, err := s.Store.AllFills(ctx, db.AllFillsParams{ReportID: id, Run: run})
	if err != nil {
		return false, err
	}
	if !slices.EqualFunc(fills, want.fills, func(a db.Fill, b db.CopyFillsParams) bool {
		a.At, b.At = recordTime(a.At), recordTime(b.At)
		return db.CopyFillsParams(a) == b
	}) {
		return false, nil
	}
	decisions, err := s.Store.AllDecisions(ctx, db.AllDecisionsParams{ReportID: id, Run: run})
	if err != nil {
		return false, err
	}
	return slices.EqualFunc(decisions, want.decisions, func(a db.Decision, b db.CopyDecisionsParams) bool {
		a.At, b.At = recordTime(a.At), recordTime(b.At)
		a.InputBarOpen, b.InputBarOpen = recordTime(a.InputBarOpen), recordTime(b.InputBarOpen)
		return db.CopyDecisionsParams(a) == b
	}), nil
}
