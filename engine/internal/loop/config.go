// Package loop runs learning cycles: collect data, generate candidates around the
// champion's recipe, retrain them walk-forward, freeze the best, forward-test it
// alongside the champion on bars that arrive after the freeze, and apply a gate
// fixed before the cycle started. It may recommend; only a user's approval moves
// the active model (invariant 9).
package loop

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"slices"

	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/feature"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/store/db"
)

var (
	ErrConfig   = errors.New("loop: invalid config")
	ErrBusy     = errors.New("loop: a cycle is already open for this algorithm")
	ErrNotFound = errors.New("loop: not found")
	ErrState    = errors.New("loop: not allowed in this state")
)

// Config is copied into every cycle when it starts, so the gate a cycle is judged
// by is the one registered before it saw any data.
type Config struct {
	Algorithm    string         `json:"algorithm"`
	Symbols      []string       `json:"symbols"`
	Timeframe    data.Timeframe `json:"timeframe"`
	LookbackDays int            `json:"lookback_days"`
	Enabled      bool           `json:"enabled"`  // daily scheduled cycles
	HourUTC      int            `json:"hour_utc"` // when the daily cycle starts
	// MinFreshBars: bars (of Timeframe) since the last decision's forward data;
	// fewer and the cycle is skipped with a recorded reason.
	MinFreshBars  int          `json:"min_fresh_bars"`
	Folds         int          `json:"folds"`
	MaxCandidates int          `json:"max_candidates"`
	CPUMinutes    int          `json:"cpu_minutes"` // research-slot minutes per cycle
	MaxBars       int          `json:"max_bars"`    // memory budget: bars loaded per cycle
	Seed          uint64       `json:"seed"`
	Capital       money.Amount `json:"capital"`
	Fee           money.Ratio  `json:"fee"`
	Slippage      money.Ratio  `json:"slippage"`
	Gate          Gate         `json:"gate"`
}

// Gate: every condition must pass for a recommendation.
type Gate struct {
	MaxDrawdown      money.Ratio `json:"max_drawdown"`       // hard constraint, walk-forward and forward
	MinForwardTrades int         `json:"min_forward_trades"` // challenger trades in the forward window
	ForwardDays      int         `json:"forward_days"`       // forward test length
	MinImprovement   money.Ratio `json:"min_improvement"`    // forward return over the champion's
	MaxDDDegradation money.Ratio `json:"max_dd_degradation"` // forward drawdown worse than the champion's by at most
	MinWalkWins      int         `json:"min_walk_wins"`      // folds where the challenger's net beats the champion's
}

func Default() Config {
	return Config{
		Algorithm: "ridge-h4", Symbols: []string{"BTCUSDT"}, Timeframe: data.TF1h, LookbackDays: 180,
		Enabled: false, HourUTC: 3, MinFreshBars: 168, Folds: 4, MaxCandidates: 30, CPUMinutes: 45,
		MaxBars: 2_000_000, Seed: 42,
		Capital: money.Amount{V: 10_000 * 100_000_000, Asset: instrument.USDT}, Fee: 1000, Slippage: 500,
		Gate: Gate{MaxDrawdown: 200_000, MinForwardTrades: 20, ForwardDays: 14, MinImprovement: 10_000, MaxDDDegradation: 10_000, MinWalkWins: 3},
	}
}

func (c Config) Validate() error {
	bad := func(f string, a ...any) error { return fmt.Errorf("%w: "+f, append([]any{ErrConfig}, a...)...) }
	if _, err := data.ParseTimeframe(string(c.Timeframe)); err != nil {
		return bad("%v", err)
	}
	g := c.Gate
	switch {
	case c.Algorithm == "":
		return bad("algorithm is required")
	case len(c.Symbols) == 0:
		return bad("choose at least one pair")
	case c.LookbackDays < 7 || c.LookbackDays > 3650:
		return bad("lookback must be 7..3650 days")
	case c.HourUTC < 0 || c.HourUTC > 23:
		return bad("hour must be 0..23 UTC")
	case c.MinFreshBars < 1:
		return bad("minimum fresh bars must be at least 1")
	case c.Folds < 1 || c.Folds > 12:
		return bad("folds must be 1..12")
	case c.MaxCandidates < 1 || c.MaxCandidates > 200:
		return bad("candidates must be 1..200")
	case c.CPUMinutes < 1 || c.CPUMinutes > 1440:
		return bad("CPU budget must be 1..1440 minutes")
	case c.MaxBars < 1000:
		return bad("bar budget must be at least 1000")
	case c.Capital.Asset != instrument.USDT || c.Capital.V <= 0:
		return bad("capital must be positive USDT")
	case c.Fee < 0 || c.Fee > 100_000 || c.Slippage < 0 || c.Slippage > 100_000:
		return bad("fee and slippage must be 0..10%%")
	case g.MaxDrawdown <= 0 || g.MaxDrawdown > money.RatioOne:
		return bad("drawdown cap must be in (0, 100%%]")
	case g.MinForwardTrades < 0 || g.ForwardDays < 1 || g.ForwardDays > 365:
		return bad("forward test: trades ≥ 0, days 1..365")
	case g.MinImprovement < 0 || g.MaxDDDegradation < 0:
		return bad("improvement and drawdown margins must be ≥ 0")
	case g.MinWalkWins < 0 || g.MinWalkWins > c.Folds:
		return bad("walk-forward wins must be 0..folds")
	}
	seen := map[string]bool{}
	for _, s := range c.Symbols {
		if _, ok := report.Specs()[s]; !ok || seen[s] {
			return bad("unknown or repeated pair %q", s)
		}
		seen[s] = true
	}
	return nil
}

const settingKey = "learning"

// LoadConfig returns the saved config, or the defaults.
func LoadConfig(ctx context.Context, q *db.Queries) (Config, error) {
	b, err := q.GetSetting(ctx, settingKey)
	if errors.Is(err, pgx.ErrNoRows) {
		return Default(), nil
	}
	if err != nil {
		return Config{}, err
	}
	c := Default()
	if err := json.Unmarshal(b, &c); err != nil {
		return Config{}, fmt.Errorf("learning config: %w", err)
	}
	return c, nil
}

// SaveConfig validates and stores c; running cycles keep the copy they started with.
func SaveConfig(ctx context.Context, q *db.Queries, c Config) error {
	if err := c.Validate(); err != nil {
		return err
	}
	b, err := json.Marshal(c)
	if err != nil {
		return err
	}
	return q.PutSetting(ctx, db.PutSettingParams{Key: settingKey, Value: b})
}

// Variant is one candidate: the parent recipe with one bounded change.
type Variant struct {
	Change string       `json:"change"`
	Recipe model.Recipe `json:"recipe"`
}

// Variants generates up to n candidates around parent, one change each, in a fixed
// order: add a feature, drop a feature, move or toggle the filter, scale the L2
// strength, scale the entry threshold. Duplicates and the parent itself are left out.
func Variants(parent model.Recipe, n int) []Variant {
	var out []Variant
	seen := map[string]bool{parent.Hash(): true}
	add := func(change string, r model.Recipe) {
		if len(out) >= n || r.Validate() != nil || seen[r.Hash()] {
			return
		}
		seen[r.Hash()] = true
		out = append(out, Variant{change, r})
	}
	clone := func() model.Recipe {
		r := parent
		r.Features = slices.Clone(parent.Features)
		if parent.Filter != nil {
			f := *parent.Filter
			r.Filter = &f
		}
		return r
	}
	for _, f := range feature.Names() {
		if !slices.Contains(parent.Features, f) {
			r := clone()
			r.Features = append(r.Features, f)
			add("+"+f, r)
		}
	}
	if len(parent.Features) > 2 {
		for i, f := range parent.Features {
			if parent.Filter != nil && parent.Filter.Feature == f {
				continue
			}
			r := clone()
			r.Features = slices.Delete(r.Features, i, i+1)
			add("−"+f, r)
		}
	}
	if parent.Filter != nil {
		for _, d := range []float64{-0.5, 0.5} {
			r := clone()
			r.Filter.Max += d
			add(fmt.Sprintf("filter %s ≤ %g", r.Filter.Feature, r.Filter.Max), r)
		}
		r := clone()
		r.Filter = nil
		add("no filter", r)
	} else if slices.Contains(parent.Features, "vol_24") {
		r := clone()
		r.Filter = &model.Filter{Feature: "vol_24", Max: 1}
		add("filter vol_24 ≤ 1", r)
	}
	for _, k := range []float64{0.1, 10} {
		r := clone()
		r.Alpha = parent.Alpha * k
		add(fmt.Sprintf("alpha %g", r.Alpha), r)
	}
	if parent.Model == "logistic" {
		for _, d := range []float64{-0.02, 0.02} {
			r := clone()
			r.Entry = parent.Entry + d
			add(fmt.Sprintf("entry %g", r.Entry), r)
		}
	} else {
		for _, k := range []float64{0.5, 2} {
			r := clone()
			r.Entry = parent.Entry * k
			add(fmt.Sprintf("entry %g", r.Entry), r)
		}
	}
	return out
}
