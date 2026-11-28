package api

import (
	"context"
	"crypto/sha256"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/assistant"
	"tradinglab/engine/internal/eval"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/metrics"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/store/db"
)

// Only these OOS metrics can enter the prompt or come back as a source.
var researchMetrics = [...]struct {
	key   string
	unit  metrics.Unit
	scale int32
	focus labv1.ResearchFocus
}{
	{"total_return", metrics.Ratio, 6, labv1.ResearchFocus_RESEARCH_FOCUS_RETURN},
	{"max_drawdown", metrics.Ratio, 6, labv1.ResearchFocus_RESEARCH_FOCUS_DRAWDOWN},
	{"closed_trades", metrics.Count, 0, labv1.ResearchFocus_RESEARCH_FOCUS_SAMPLE},
}

func (a *Assistant) ReviewReports(ctx context.Context, req *connect.Request[labv1.ReviewReportsRequest]) (*connect.Response[labv1.ReviewReportsResponse], error) {
	ids := req.Msg.GetReportIds()
	if len(ids) < 1 || len(ids) > 6 {
		return nil, invalid("یک تا شش گزارش انتخاب کنید")
	}
	seen := make(map[string]bool, len(ids))
	for _, id := range ids {
		if len(id) == 0 || len(id) > 128 || strings.TrimSpace(id) != id || strings.ContainsRune(id, 0) || seen[id] {
			return nil, invalid("شناسه‌های گزارش باید معتبر و یکتا باشند")
		}
		seen[id] = true
	}

	response := &labv1.ReviewReportsResponse{}
	comparables := make([]eval.Comparable, 0, len(ids))
	for _, id := range ids {
		row, err := a.Store.GetReportResearchEvidence(ctx, id)
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, reportErr(fmt.Errorf("%w: %s", report.ErrNotFound, id))
		}
		if err != nil {
			return nil, err
		}
		var spec eval.Spec
		var split eval.Split
		var values []metrics.Metric
		if err := errors.Join(json.Unmarshal(row.Spec, &spec), json.Unmarshal(row.Split, &split), json.Unmarshal(row.Metrics, &values)); err != nil {
			return nil, fmt.Errorf("decode report %q research evidence: %w", id, err)
		}
		comparables = append(comparables, comparableReport(id, spec, split, values))
		response.References = append(response.References, &labv1.ResearchReference{ReportId: id, Title: row.Title, OosWindow: windowP(split.OOS)})
		if n, _ := metrics.Get(values, "closed_trades"); !n.Valid || n.Unit != metrics.Count || n.Scale != 0 || n.V < eval.MinReliableTrades {
			minimum := int32(eval.MinReliableTrades)
			response.MinimumClosedTrades = &minimum
		}
	}

	if len(ids) > 1 {
		for _, assumption := range eval.Compare(comparables).Assumptions {
			if assumption.Blocking && assumption.Differs {
				response.BlockingAssumptions = append(response.BlockingAssumptions, assumptionP(assumption))
			}
		}
		// Mismatched runs get a deterministic explanation without paying for inference.
		if len(response.BlockingAssumptions) > 0 {
			response.Focus = labv1.ResearchFocus_RESEARCH_FOCUS_ASSUMPTIONS
			return connect.NewResponse(response), nil
		}
	}
	return a.reviewReportMetrics(ctx, ids, comparables, response)
}

func (a *Assistant) reviewReportMetrics(ctx context.Context, ids []string, comparables []eval.Comparable, response *labv1.ReviewReportsResponse) (*connect.Response[labv1.ReviewReportsResponse], error) {
	columns := make([]map[string]string, len(ids))
	for i := range columns {
		columns[i] = make(map[string]string, len(researchMetrics))
	}
	var focus []string
	for _, candidate := range researchMetrics {
		available := false
		for i, column := range comparables {
			if value, _ := metrics.Get(column.Metrics, candidate.key); value.Valid && value.Unit == candidate.unit && value.Scale == candidate.scale {
				available = true
				columns[i][candidate.key] = strconv.FormatInt(value.V, 10)
			}
		}
		if available {
			focus = append(focus, candidate.key)
		}
	}
	if len(focus) == 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("معیار معتبر خارج از نمونه برای این گزارش‌ها ثبت نشده است"))
	}
	request := assistant.Research(columns, focus)
	input, err := request.InputJSON()
	if err != nil {
		return nil, err
	}
	// Report IDs stay local. They bind the ordered model input to its sources for cache and audit.
	sources, _ := json.Marshal(ids)
	digest := fmt.Sprintf("%x", sha256.Sum256(append(append(sources, '\n'), input...)))
	selection, err := a.explain(ctx, db.ReserveAssistantRunParams{ReportIds: ids, EvidenceSha256: digest}, request)
	if err != nil {
		return nil, err
	}
	for _, candidate := range researchMetrics {
		if candidate.key == selection.focus {
			response.Focus = candidate.focus
			break
		}
	}
	for i, column := range comparables {
		if _, available := columns[i][selection.focus]; available {
			value, _ := metrics.Get(column.Metrics, selection.focus)
			response.References[i].Metric = metricP(value)
		}
	}
	response.Model = assistant.Model
	response.InputTokens, response.OutputTokens, response.Cached = selection.input, selection.output, selection.cached
	return connect.NewResponse(response), nil
}
