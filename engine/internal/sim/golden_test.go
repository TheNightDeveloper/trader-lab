package sim

import (
	"bytes"
	"context"
	"encoding/csv"
	"encoding/json"
	"flag"
	"maps"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/strategy"
)

var update = flag.Bool("update", false, "rewrite golden expected.json files")

const goldenDir = "../../testdata/golden"

// scenario.json
type scenario struct {
	Description string `json:"description"`
	Config      struct {
		Capital     string            `json:"capital"` // USDT
		Holdings    map[string]string `json:"holdings"`
		Fee         string            `json:"fee"`      // fraction per side, e.g. "0.001"
		Slippage    string            `json:"slippage"` // fraction per side
		Sizing      string            `json:"sizing"`
		FixedUSDT   string            `json:"fixed_usdt"`
		LatencyBars int               `json:"latency_bars"`
		IntentTTL   string            `json:"intent_ttl"`
	} `json:"config"`
	Strategy struct {
		Name   string          `json:"name"` // a registered strategy, or "scripted"
		Params strategy.Params `json:"params"`
	} `json:"strategy"`
	Steps []struct {
		At         time.Time `json:"at"`
		Instrument string    `json:"instrument"`
		Target     string    `json:"target"`
		StopLoss   string    `json:"stop_loss"`
		TakeProfit string    `json:"take_profit"`
		Reason     string    `json:"reason"`
	} `json:"steps"`
	// Until: the run sees only bars available by this time (as-of), like a live
	// engine at that moment. Empty = all bars.
	Until *time.Time `json:"until"`
}

func TestGolden(t *testing.T) {
	dirs, err := os.ReadDir(goldenDir)
	require.NoError(t, err)
	require.NotEmpty(t, dirs)
	for _, d := range dirs {
		if !d.IsDir() {
			continue
		}
		t.Run(d.Name(), func(t *testing.T) {
			dir := filepath.Join(goldenDir, d.Name())
			first := runGolden(t, dir)
			second := runGolden(t, dir)
			require.Equal(t, string(first), string(second), "same inputs must give byte-identical output")

			want := filepath.Join(dir, "expected.json")
			if *update {
				require.NoError(t, os.WriteFile(want, first, 0o644))
				return
			}
			expected, err := os.ReadFile(want)
			require.NoError(t, err, "missing expected.json: run go test ./internal/sim -run Golden -update")
			require.Equal(t, string(expected), string(first))
		})
	}
}

func runGolden(t *testing.T, dir string) []byte {
	t.Helper()
	var sc scenario
	raw, err := os.ReadFile(filepath.Join(dir, "scenario.json"))
	require.NoError(t, err)
	dec := json.NewDecoder(bytes.NewReader(raw))
	dec.DisallowUnknownFields()
	require.NoError(t, dec.Decode(&sc))

	cfg := Config{LatencyBars: sc.Config.LatencyBars, Sizing: Sizing(sc.Config.Sizing)}
	cfg.Capital = amount(t, sc.Config.Capital, "USDT")
	for _, a := range slices.Sorted(maps.Keys(sc.Config.Holdings)) {
		cfg.Holdings = append(cfg.Holdings, amount(t, sc.Config.Holdings[a], a))
	}
	cfg.FeeRate, cfg.SlipRate = ratio(t, sc.Config.Fee), ratio(t, sc.Config.Slippage)
	if sc.Config.FixedUSDT != "" {
		cfg.FixedUSDT = amount(t, sc.Config.FixedUSDT, "USDT")
	}
	if sc.Config.IntentTTL != "" {
		cfg.IntentTTL, err = time.ParseDuration(sc.Config.IntentTTL)
		require.NoError(t, err)
	}

	var strat strategy.Strategy
	if sc.Strategy.Name == "scripted" {
		var steps []strategy.Step
		for _, s := range sc.Steps {
			steps = append(steps, strategy.Step{At: s.At, Intent: strategy.Intent{
				Instrument: s.Instrument, Target: ratio(t, s.Target), StopLoss: ratio(t, s.StopLoss),
				TakeProfit: ratio(t, s.TakeProfit), Reason: s.Reason,
			}})
		}
		strat = strategy.NewScripted(steps)
	} else {
		strat, err = strategy.New(sc.Strategy.Name, sc.Strategy.Params)
		require.NoError(t, err)
	}

	bars := readBars(t, filepath.Join(dir, "bars.csv"), sc.Until)
	res, err := Run(context.Background(), cfg, specs(), bars, strat)
	require.NoError(t, err)
	out, err := json.MarshalIndent(res, "", "  ")
	require.NoError(t, err)
	return append(out, '\n')
}

// bars.csv: symbol,open_time,open,high,low,close,volume[,available_at]
// 1m bars; available_at defaults to close + 2s.
func readBars(t *testing.T, path string, until *time.Time) map[string][]data.Bar {
	f, err := os.Open(path)
	require.NoError(t, err)
	defer func() { _ = f.Close() }()
	r := csv.NewReader(f)
	r.FieldsPerRecord = -1
	r.Comment = '#'
	recs, err := r.ReadAll()
	require.NoError(t, err)
	out := map[string][]data.Bar{}
	for i, rec := range recs {
		if i == 0 && rec[0] == "symbol" {
			continue
		}
		require.GreaterOrEqual(t, len(rec), 7, "line %d", i+1)
		open, err := time.Parse(time.RFC3339, rec[1])
		require.NoError(t, err, "line %d", i+1)
		b := data.Bar{Instrument: rec[0], OpenTime: open, CloseTime: open.Add(time.Minute), AvailableAt: open.Add(time.Minute + delay)}
		if len(rec) > 7 && rec[7] != "" {
			b.AvailableAt, err = time.Parse(time.RFC3339, rec[7])
			require.NoError(t, err, "line %d", i+1)
		}
		for j, dst := range []*int64{&b.O.V, &b.H.V, &b.L.V, &b.C.V, &b.Volume.V} {
			*dst, err = money.Parse(strings.TrimSpace(rec[j+2]), 8)
			require.NoError(t, err, "line %d field %d", i+1, j+3)
		}
		b.O.Scale, b.H.Scale, b.L.Scale, b.C.Scale, b.Volume.Scale = 8, 8, 8, 8, 8
		if until != nil && b.AvailableAt.After(*until) {
			continue // not yet available at the end of the run
		}
		out[rec[0]] = append(out[rec[0]], b)
	}
	return out
}

func amount(t *testing.T, s, asset string) money.Amount {
	v, err := money.Parse(s, 8)
	require.NoError(t, err, "amount %q", s)
	return money.Amount{V: v, Asset: instrument.Asset(asset)}
}

func ratio(t *testing.T, s string) money.Ratio {
	if s == "" {
		return 0
	}
	r, err := money.ParseRatio(s)
	require.NoError(t, err, "ratio %q", s)
	return r
}
