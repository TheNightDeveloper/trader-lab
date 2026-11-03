package report

import (
	"context"
	"encoding/json"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/sim"
)

func TestJSONEqualityPreservesExactNumbers(t *testing.T) {
	for _, tt := range []struct {
		name, a, b string
		same       bool
	}{
		{"integer precision", `{"v":9007199254740992}`, `{"v":9007199254740993}`, false},
		{"int64 boundary", `9223372036854775806`, `9223372036854775807`, false},
		{"decimal precision", `0.12345678901234567890`, `0.12345678901234567891`, false},
		{"jsonb normalization", `{"a":1e-6,"b":[true,null,"x"]}`, `{"b":[true,null,"x"],"a":0.0000010}`, true},
		{"array order", `[1,2]`, `[2,1]`, false},
		{"missing null", `{"a":null}`, `{"b":null}`, false},
		{"number versus string", `1`, `"1"`, false},
		{"invalid", `{"a":`, `{"a":`, false},
		{"trailing input", `1 2`, `1`, false},
	} {
		t.Run(tt.name, func(t *testing.T) {
			require.Equal(t, tt.same, jsonEqual([]byte(tt.a), []byte(tt.b)))
		})
	}
}

func TestReproduceChecksCanonicalRecordsWithUnchangedPnL(t *testing.T) {
	st, ds := setup(t)
	ctx := context.Background()
	svc := Service{Store: st, Version: "test"}
	for _, tt := range []struct{ name, sql string }{
		{"main fill price", "UPDATE fills SET price=price+1 WHERE report_id=$1 AND run='main' AND seq=1"},
		{"holdout fill time", "UPDATE fills SET at=at+interval '1 microsecond' WHERE report_id=$1 AND run='holdout' AND seq=1"},
		{"trade attribution", "UPDATE trades SET exit_reason=exit_reason || 'changed' WHERE report_id=$1 AND run='main' AND seq=1"},
		{"decision input", "UPDATE decisions SET input_bar_open=input_bar_open+interval '1 minute' WHERE report_id=$1 AND run='holdout' AND id=1"},
		{"missing fill", "DELETE FROM fills WHERE report_id=$1 AND run='main' AND seq=1"},
		{"missing trade", "DELETE FROM trades WHERE report_id=$1 AND run='holdout' AND seq=1"},
		{"fill order", "UPDATE fills SET seq=seq+100000 WHERE report_id=$1 AND run='main' AND seq=1"},
		{"stored summary", "UPDATE reports SET oos_net=oos_net+1 WHERE id=$1"},
	} {
		t.Run(tt.name, func(t *testing.T) {
			id, err := svc.Create(ctx, spec(ds))
			require.NoError(t, err)
			// Corrupt a fresh isolated fixture; production records remain immutable.
			tag, err := st.Pool.Exec(ctx, tt.sql, id)
			require.NoError(t, err)
			require.EqualValues(t, 1, tag.RowsAffected())
			before, err := st.GetReport(ctx, id)
			require.NoError(t, err)
			same, err := svc.Reproduce(ctx, id)
			require.NoError(t, err)
			require.False(t, same, "equal aggregate PnL must not hide different records")
			after, err := st.GetReport(ctx, id)
			require.NoError(t, err)
			require.Equal(t, before, after, "reproduction must not rewrite the report or its saved PnL")
		})
	}
}

func TestReportProvenanceIsEngineOwnedAndReproductionIsStrict(t *testing.T) {
	st, ds := setup(t)
	ctx := context.Background()
	svc := Service{Store: st, Version: "test", Build: CurrentBuild(strings.Repeat("a", 64))}
	input := spec(ds)
	input.Provenance = &eval.Provenance{Version: 999}
	id, err := svc.Create(ctx, input)
	require.NoError(t, err)
	got, err := svc.Load(ctx, id)
	require.NoError(t, err)
	p := got.Spec.Provenance
	require.NotNil(t, p)
	require.Equal(t, 1, p.Version)
	require.Equal(t, svc.Build, p.Build)
	require.NotEmpty(t, p.Build.GoVersion)
	require.Len(t, p.Datasets, 1)
	require.Equal(t, ds, p.Datasets[0].ID)
	require.Equal(t, "BTCUSDT", p.Datasets[0].Manifest.Symbol)
	require.Equal(t, 1, p.Datasets[0].Manifest.FormatVersion)
	require.Equal(t, data.TF1m, p.Datasets[0].Manifest.Timeframe)
	require.Equal(t, Specs()["BTCUSDT"], p.Instruments[0])
	require.Equal(t, eval.Version, p.Policies.Evaluation)
	require.Equal(t, sim.FillModel, p.Policies.Fill)
	require.NotEmpty(t, p.Policies.Accounting)
	require.NotEmpty(t, p.Policies.Research)

	same, err := svc.Reproduce(ctx, id)
	require.NoError(t, err)
	require.True(t, same)
	other := svc
	other.Build.BinarySHA256 = strings.Repeat("b", 64)
	same, err = other.Reproduce(ctx, id)
	require.NoError(t, err)
	require.False(t, same, "a different binary cannot certify identical execution provenance")
	other = svc
	other.Version = "another release"
	same, err = other.Reproduce(ctx, id)
	require.NoError(t, err)
	require.False(t, same)
	row, err := st.GetReport(ctx, id)
	require.NoError(t, err)
	require.Equal(t, got.Row, row)
}

func TestRecalculateUsesRecordedInstrumentsAndLegacyStaysReadable(t *testing.T) {
	st, ds := setup(t)
	ctx := context.Background()
	svc := Service{Store: st, Version: "test"}
	// Model a historical registry with a min notional that prohibits all fills.
	pinned := Specs()
	sp := pinned["BTCUSDT"]
	sp.MinNotional.V = 1_000_000e8
	pinned[sp.Symbol] = sp
	input := spec(ds)
	input.EngineVersion = svc.Version
	ev, bars, err := svc.evaluate(ctx, input, pinned)
	require.NoError(t, err)
	require.Empty(t, ev.Main.Fills)
	id := "rp_pinned"
	require.NoError(t, svc.persist(ctx, id, bars, ev))
	same, err := svc.Reproduce(ctx, id)
	require.NoError(t, err)
	require.True(t, same, "use recorded rules even when today's registry permits fills")
	_, run, err := svc.Recalculate(ctx, id, ev.Spec.Sim, money.RatioOne)
	require.NoError(t, err)
	require.Empty(t, run.Fills)

	// Legacy JSON is read without backfilling today's build or instrument metadata.
	_, err = st.Pool.Exec(ctx, "UPDATE reports SET spec=spec-'provenance', evaluation=evaluation #- '{spec,provenance}' WHERE id=$1", id)
	require.NoError(t, err)
	legacy, err := svc.Load(ctx, id)
	require.NoError(t, err)
	require.Nil(t, legacy.Spec.Provenance)
	same, err = svc.Reproduce(ctx, id)
	require.NoError(t, err)
	require.False(t, same)
	after, err := svc.Load(ctx, id)
	require.NoError(t, err)
	require.Equal(t, legacy.Row, after.Row)
}

func TestRecordedProvenanceRejectsInvalidInstruments(t *testing.T) {
	for _, tt := range []string{
		`{"version":2}`, `{"version":1,"instruments":[]}`,
	} {
		var p eval.Provenance
		require.NoError(t, json.Unmarshal([]byte(tt), &p))
		_, err := recordedSpecs(&p)
		require.ErrorIs(t, err, ErrInput)
	}
	sp := Specs()["BTCUSDT"]
	for _, tt := range []struct {
		name   string
		change func(*eval.Provenance)
	}{
		{"duplicates", func(p *eval.Provenance) { p.Instruments = append(p.Instruments, sp) }},
		{"zero tick", func(p *eval.Provenance) { p.Instruments[0].Tick.V = 0 }},
		{"scale", func(p *eval.Provenance) { p.Instruments[0].Tick.Scale = 7 }},
		{"quote funding", func(p *eval.Provenance) { p.Instruments[0].Quote = instrument.Asset("BTC") }},
	} {
		t.Run(tt.name, func(t *testing.T) {
			p := eval.Provenance{Version: 1, Instruments: []instrument.Spec{sp}}
			tt.change(&p)
			_, err := recordedSpecs(&p)
			require.ErrorIs(t, err, ErrInput)
		})
	}
}
