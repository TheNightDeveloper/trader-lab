package report

import (
	"cmp"
	"context"
	"encoding/json"
	"fmt"
	"runtime"
	"runtime/debug"
	"slices"

	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/sim"
)

// CurrentBuild reads compiler-provided VCS metadata; go run/tests may have none.
func CurrentBuild(binarySHA256 string) eval.BuildIdentity {
	b := eval.BuildIdentity{BinarySHA256: binarySHA256, GoVersion: runtime.Version(), GOOS: runtime.GOOS, GOARCH: runtime.GOARCH}
	if info, ok := debug.ReadBuildInfo(); ok {
		for _, s := range info.Settings {
			switch s.Key {
			case "vcs.revision":
				b.Commit = s.Value
			case "vcs.time":
				b.CommitTime = s.Value
			case "vcs.modified":
				b.VCSKnown = s.Value == "true" || s.Value == "false"
				b.Dirty = s.Value == "true"
			}
		}
	}
	b.VCSKnown = b.VCSKnown && b.Commit != ""
	return b
}

func (s Service) provenance(ctx context.Context, ids []string, specs map[string]instrument.Spec) (*eval.Provenance, error) {
	p := &eval.Provenance{Version: 1, Build: s.Build, Policies: eval.Policies{
		Evaluation: eval.Version, Fill: sim.FillModel, Accounting: sim.AccountingPolicy, Research: instrument.ResearchPolicy,
	}}
	used := map[string]bool{}
	for _, id := range ids {
		ds, err := s.Store.GetDataset(ctx, id)
		if err != nil {
			return nil, err
		}
		input := eval.DatasetInput{ID: id}
		if err := json.Unmarshal(ds.Manifest, &input.Manifest); err != nil {
			return nil, fmt.Errorf("dataset %s provenance: %w", id, err)
		}
		p.Datasets = append(p.Datasets, input)
		if !used[ds.Symbol] {
			sp, ok := specs[ds.Symbol]
			if !ok {
				return nil, fmt.Errorf("%w: missing recorded instrument %s", ErrInput, ds.Symbol)
			}
			p.Instruments = append(p.Instruments, sp)
			used[ds.Symbol] = true
		}
	}
	slices.SortFunc(p.Instruments, func(a, b instrument.Spec) int { return cmp.Compare(a.Symbol, b.Symbol) })
	return p, nil
}

// recordedSpecs pins rounding/funding inputs instead of silently adopting today's registry.
func recordedSpecs(p *eval.Provenance) (map[string]instrument.Spec, error) {
	if p == nil {
		return Specs(), nil
	}
	if p.Version != 1 || len(p.Instruments) == 0 {
		return nil, fmt.Errorf("%w: unsupported or incomplete report provenance", ErrInput)
	}
	out := map[string]instrument.Spec{}
	for _, sp := range p.Instruments {
		registered, ok := Specs()[sp.Symbol]
		if !ok || sp.Base != registered.Base || sp.Quote != registered.Quote {
			return nil, fmt.Errorf("%w: recorded asset identity differs for %s", ErrInput, sp.Symbol)
		}
		if _, dup := out[sp.Symbol]; dup {
			return nil, fmt.Errorf("%w: duplicate recorded instrument %s", ErrInput, sp.Symbol)
		}
		if err := sp.Validate(); err != nil {
			return nil, fmt.Errorf("%w: %w", ErrInput, err)
		}
		if sp.Base.Scale != instrument.Scale || sp.Quote.Scale != instrument.Scale || sp.Tick.Scale != instrument.Scale || sp.Lot.Scale != instrument.Scale {
			return nil, fmt.Errorf("%w: unsupported recorded scales for %s", ErrInput, sp.Symbol)
		}
		out[sp.Symbol] = sp
	}
	return out, nil
}
