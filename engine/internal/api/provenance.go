package api

import (
	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
)

// provenanceP reads the stored inputs so catalog or policy changes cannot relabel a report.
func provenanceP(p *eval.Provenance) *labv1.RunProvenance {
	if p == nil {
		return &labv1.RunProvenance{
			Status: labv1.EvidenceStatus_EVIDENCE_STATUS_LEGACY,
			Detail: "منشأ کامل اجرای این گزارش قدیمی ثبت نشده؛ بازتولید دقیق قابل تأیید نیست",
		}
	}
	out := &labv1.RunProvenance{
		SchemaVersion: int32(p.Version), BinarySha256: p.Build.BinarySHA256,
		SourceCommit: p.Build.Commit, EvaluationPolicy: p.Policies.Evaluation,
		FillPolicy: p.Policies.Fill, AccountingPolicy: p.Policies.Accounting, ResearchPolicy: p.Policies.Research,
	}
	if p.Version != 1 {
		out.Status = labv1.EvidenceStatus_EVIDENCE_STATUS_INCOMPLETE
		out.Detail = "نسخهٔ اطلاعات منشأ گزارش برای این موتور قابل بررسی نیست"
		return out
	}
	for _, dataset := range p.Datasets {
		out.Datasets = append(out.Datasets, &labv1.DatasetProvenance{
			Id: dataset.ID, SnapshotFormat: int32(dataset.Manifest.FormatVersion), ResampleVersion: int32(dataset.Manifest.ResampleVersion),
		})
	}
	for _, spec := range p.Instruments {
		out.Instruments = append(out.Instruments, spotKey(spec))
	}
	switch {
	case p.Build.BinarySHA256 == "" || !p.Build.VCSKnown || p.Build.Commit == "":
		out.Status = labv1.EvidenceStatus_EVIDENCE_STATUS_INCOMPLETE
		out.Detail = "اطلاعات ساخت یا commit کامل نیست؛ جزئیات موجود در خروجی JSON ثبت شده است"
	case len(p.Datasets) == 0 || len(p.Instruments) == 0 || p.Policies.Evaluation == "" ||
		p.Policies.Fill == "" || p.Policies.Accounting == "" || p.Policies.Research == "":
		out.Status = labv1.EvidenceStatus_EVIDENCE_STATUS_INCOMPLETE
		out.Detail = "اطلاعات داده، بازار یا سیاست اجرای گزارش کامل نیست"
	case p.Build.Dirty:
		out.Status = labv1.EvidenceStatus_EVIDENCE_STATUS_LOCAL_BUILD
		out.Detail = "گزارش با تغییرات محلی کد ساخته شده؛ منشأ اجرا در خروجی JSON ثبت شده است"
	default:
		out.Status = labv1.EvidenceStatus_EVIDENCE_STATUS_RECORDED
		out.Detail = "منشأ اجرا در خروجی JSON گزارش ثبت شده است"
	}
	return out
}
