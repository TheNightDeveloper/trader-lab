package api

import (
	"context"
	"errors"
	"fmt"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"tradinglab/engine/internal/assistant"
	"tradinglab/engine/internal/clock"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
)

const assistantTimeout = 12 * time.Second

type Assistant struct {
	Store         *store.Store
	Clock         clock.Clock
	Provider      assistant.Provider
	DailyRequests int
}

func (a *Assistant) ExplainOpportunity(ctx context.Context, req *connect.Request[labv1.ExplainOpportunityRequest]) (*connect.Response[labv1.ExplainOpportunityResponse], error) {
	id := req.Msg.GetOpportunityId()
	if id <= 0 {
		return nil, invalid("شناسهٔ فرصت معتبر نیست")
	}
	if a.Provider == nil || a.DailyRequests <= 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("دستیار در موتور فعال نشده است"))
	}
	record, err := a.Store.RecordedMarketOpportunity(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, connect.NewError(connect.CodeNotFound, errors.New("فرصت ثبت‌شده پیدا نشد"))
	}
	if err != nil {
		return nil, err
	}
	if record.ObservedAt.After(a.Clock.Now()) || instrument.ResearchError(record.Symbol) != nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("شواهد این فرصت در دسترس نیست"))
	}
	bars, err := decodeOpportunitySnapshot(record)
	if err != nil {
		return nil, err
	}
	var match string
	switch record.Reason {
	case "rule entry", "rule regime entry: A", "rule regime entry: B":
		match = record.Reason
	default:
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("دلیل ثبت‌شده برای توضیح دستیار پشتیبانی نمی‌شود"))
	}
	last := bars[len(bars)-1]
	evidence := assistant.Evidence{Symbol: record.Symbol, Match: match, Open: last.O.V, High: last.H.V,
		Low: last.L.V, Close: last.C.V, ValidityMinutes: int64(record.ExpiresAt.Sub(record.ObservedAt) / time.Minute)}
	return a.explain(ctx, record, evidence)
}

func (a *Assistant) explain(ctx context.Context, record db.MarketOpportunity, evidence assistant.Evidence) (*connect.Response[labv1.ExplainOpportunityResponse], error) {
	key := db.ReusableAssistantRunParams{OpportunityID: record.ID, SnapshotSha256: record.SnapshotSha256,
		Model: assistant.Model, PromptVersion: assistant.PromptVersion}
	var run db.AssistantRun
	var newID int64
	err := a.Store.InTx(ctx, func(q *db.Queries) error {
		if err := q.LockAssistantBudget(ctx); err != nil {
			return err
		}
		now := a.Clock.Now()
		// A dead worker cannot keep the same observation locked after its deadline.
		if err := q.InterruptAssistantRuns(ctx, now.Add(-time.Minute)); err != nil {
			return err
		}
		var err error
		run, err = q.ReusableAssistantRun(ctx, key)
		if !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
		day := now.UTC().Truncate(24 * time.Hour)
		count, err := q.CountAssistantRuns(ctx, db.CountAssistantRunsParams{DayStart: day, DayEnd: day.Add(24 * time.Hour)})
		if err != nil || count >= int64(a.DailyRequests) {
			return err
		}
		newID, err = q.ReserveAssistantRun(ctx, db.ReserveAssistantRunParams{OpportunityID: key.OpportunityID,
			SnapshotSha256: key.SnapshotSha256, Model: key.Model, PromptVersion: key.PromptVersion, StartedAt: now})
		return err
	})
	if err != nil {
		return nil, fmt.Errorf("reserve assistant run: %w", err)
	}
	switch {
	case run.Status == "succeeded":
		return explainOpportunityP(record, run.Focus, run.InputTokens.Int32, run.OutputTokens.Int32, true), nil
	case run.Status == "running":
		return nil, connect.NewError(connect.CodeAborted, errors.New("توضیح همین فرصت در حال دریافت است"))
	case newID == 0:
		return nil, connect.NewError(connect.CodeResourceExhausted, errors.New("سهمیهٔ روزانهٔ دستیار تمام شده است"))
	}
	return a.run(ctx, newID, record, evidence)
}

func (a *Assistant) run(ctx context.Context, id int64, record db.MarketOpportunity, evidence assistant.Evidence) (*connect.Response[labv1.ExplainOpportunityResponse], error) {
	providerCtx, stop := context.WithTimeout(ctx, assistantTimeout)
	started := time.Now()
	raw, usage, err := a.Provider.Explain(providerCtx, evidence)
	elapsed := time.Since(started).Milliseconds()
	if providerCtx.Err() != nil {
		err = providerCtx.Err()
	}
	stop()
	var focus string
	if err == nil {
		focus, err = assistant.ParseFocus(raw)
		if usage == nil || usage.InputTokens <= 0 || usage.OutputTokens <= 0 || usage.OutputTokens > assistant.MaxOutput {
			err = assistant.ErrInvalidOutput
			focus = ""
		}
	}
	status, code := assistantOutcome(err)
	finished := db.FinishAssistantRunParams{ID: id, Status: status, Focus: focus, LatencyMs: &elapsed}
	if usage != nil {
		finished.InputTokens = pgtype.Int4{Int32: usage.InputTokens, Valid: usage.InputTokens >= 0}
		finished.OutputTokens = pgtype.Int4{Int32: usage.OutputTokens, Valid: usage.OutputTokens >= 0}
	}
	// Persist the result even when closing the UI has canceled the paid call.
	auditCtx, cancel := context.WithTimeout(context.WithoutCancel(ctx), 3*time.Second)
	defer cancel()
	updated, updateErr := a.Store.FinishAssistantRun(auditCtx, finished)
	if updateErr != nil {
		return nil, fmt.Errorf("finish assistant run: %w", updateErr)
	}
	if updated != 1 {
		return nil, connect.NewError(connect.CodeAborted, errors.New("درخواست توضیح منقضی شده است"))
	}
	if err != nil {
		// Provider payloads and credentials never become client errors or journal entries.
		return nil, connect.NewError(code, errors.New("توضیح دستیار در دسترس نیست"))
	}
	return explainOpportunityP(record, focus, finished.InputTokens.Int32, finished.OutputTokens.Int32, false), nil
}

func assistantOutcome(err error) (string, connect.Code) {
	switch {
	case err == nil:
		return "succeeded", 0
	case errors.Is(err, context.Canceled):
		return "canceled", connect.CodeCanceled
	case errors.Is(err, context.DeadlineExceeded):
		return "timed_out", connect.CodeDeadlineExceeded
	case errors.Is(err, assistant.ErrInvalidOutput):
		return "invalid_output", connect.CodeUnavailable
	default:
		return "provider_error", connect.CodeUnavailable
	}
}

func explainOpportunityP(record db.MarketOpportunity, focus string, input, output int32, cached bool) *connect.Response[labv1.ExplainOpportunityResponse] {
	ref := map[string]labv1.ExplanationFocus{
		"rule": labv1.ExplanationFocus_EXPLANATION_FOCUS_RULE, "snapshot": labv1.ExplanationFocus_EXPLANATION_FOCUS_SNAPSHOT,
		"report": labv1.ExplanationFocus_EXPLANATION_FOCUS_REPORT,
	}[focus]
	return connect.NewResponse(&labv1.ExplainOpportunityResponse{
		Focus: ref, RuleVersionId: record.RuleVersionID, ReportId: record.ReportID, Reason: record.Reason,
		ReferenceClose: usdtP(record.ReferenceClose), CandleClosedAtUnixMs: ms(record.CandleClosedAt),
		ExpiresAtUnixMs: ms(record.ExpiresAt), Model: assistant.Model, InputTokens: input, OutputTokens: output, Cached: cached,
	})
}
