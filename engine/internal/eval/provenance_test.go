package eval

import (
	"testing"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/instrument"
)

func TestCompareBlocksDifferentExecutionContexts(t *testing.T) {
	for _, tt := range []struct {
		name   string
		change func(*Provenance)
	}{
		{"binary", func(p *Provenance) { p.Build.BinarySHA256 = "other" }},
		{"dirty source", func(p *Provenance) { p.Build.Dirty = true }},
		{"rounding", func(p *Provenance) { p.Instruments[0].Tick.V++ }},
		{"policy", func(p *Provenance) { p.Policies.Accounting = "future" }},
	} {
		t.Run(tt.name, func(t *testing.T) {
			makeProvenance := func() *Provenance {
				return &Provenance{Version: 1, Build: BuildIdentity{BinarySHA256: "same"}, Instruments: instrument.Defaults()}
			}
			a, b := Comparable{Spec: Spec{Provenance: makeProvenance()}}, Comparable{Spec: Spec{Provenance: makeProvenance()}}
			require.True(t, Compare([]Comparable{a, b}).Eligible[1])
			tt.change(b.Spec.Provenance)
			c := Compare([]Comparable{a, b})
			require.False(t, c.Eligible[1])
			require.Contains(t, c.Reasons[1], "منشأ و سیاست اجرا متفاوت است")
			b.Spec.Provenance = nil
			require.False(t, Compare([]Comparable{a, b}).Eligible[1], "missing context is not the recorded context")
		})
	}
}
