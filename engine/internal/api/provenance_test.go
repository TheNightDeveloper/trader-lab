package api

import (
	"testing"

	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
)

func TestProvenanceClassifiesRecordedEvidence(t *testing.T) {
	stored := eval.Provenance{
		Version: 1, Build: eval.BuildIdentity{BinarySHA256: "binary", Commit: "source", VCSKnown: true},
		Datasets: []eval.DatasetInput{{ID: "recorded"}}, Instruments: instrument.Defaults()[:1],
		Policies: eval.Policies{Evaluation: "old-eval", Fill: "old-fill", Accounting: "old-accounting", Research: "old-research"},
	}
	view := provenanceP(&stored)
	require.Equal(t, labv1.EvidenceStatus_EVIDENCE_STATUS_RECORDED, view.GetStatus())
	require.Equal(t, "old-eval", view.GetEvaluationPolicy())
	require.Equal(t, "source", view.GetSourceCommit())
	require.Equal(t, spotKey(stored.Instruments[0]).GetSpecRevision(), view.GetInstruments()[0].GetSpecRevision())

	stored.Build.Dirty = true
	require.Equal(t, labv1.EvidenceStatus_EVIDENCE_STATUS_LOCAL_BUILD, provenanceP(&stored).GetStatus())
	stored.Build.VCSKnown = false
	require.Equal(t, labv1.EvidenceStatus_EVIDENCE_STATUS_INCOMPLETE, provenanceP(&stored).GetStatus())
	stored.Version++
	require.Empty(t, provenanceP(&stored).GetInstruments(), "unrecognized schema is not projected as a Binance spot key")
}
