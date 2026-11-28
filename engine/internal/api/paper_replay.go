package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"
	"google.golang.org/protobuf/proto"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/store/db"
)

const paperReplayReview = -1

func (p *Paper) GetPaperReplay(ctx context.Context, req *connect.Request[labv1.GetPaperReplayRequest]) (*connect.Response[labv1.GetPaperReplayResponse], error) {
	cursor := req.Msg.GetCursor()
	if cursor < paperReplayReview {
		return nil, invalid("نشانگر بازپخش معتبر نیست")
	}
	response := &labv1.GetPaperReplayResponse{}
	// Read only the selected historical step. The receipt's current state and future fill values stay out.
	err := p.Market.Store.InTxOptions(ctx, pgx.TxOptions{IsoLevel: pgx.RepeatableRead, AccessMode: pgx.ReadOnly}, func(q *db.Queries) error {
		entry, err := readPaperEntry(ctx, q, req.Msg.GetReceiptId())
		if err != nil {
			return err
		}
		response.Symbol = entry.Symbol
		switch cursor {
		case 0:
			observation, err := readPaperReplayObservation(ctx, q, entry)
			if err != nil {
				return err
			}
			response.Step = &labv1.GetPaperReplayResponse_Observation{Observation: observation}
			response.NextCursor = proto.Int64(paperReplayReview)
		case paperReplayReview:
			plan, err := readPaperPlan(ctx, q, entry.PlanHash)
			if err != nil {
				return err
			}
			first, err := q.FirstPaperReplayEvent(ctx, entry.ID)
			if err != nil {
				return err
			}
			response.Step = &labv1.GetPaperReplayResponse_Plan{Plan: plan}
			response.PreviousCursor = proto.Int64(0)
			if first > 0 {
				response.NextCursor = proto.Int64(first)
			}
		default:
			return readPaperReplayExecution(ctx, q, entry, cursor, response)
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(response), nil
}

func readPaperReplayObservation(ctx context.Context, q *db.Queries, entry db.PaperEntry) (*labv1.PaperReplayObservation, error) {
	plan, err := readPaperPlan(ctx, q, entry.PlanHash)
	if err != nil {
		return nil, err
	}
	if plan.GetOpportunityId() != entry.OpportunityID || plan.GetInstrument().GetSymbol() != entry.Symbol {
		return nil, fmt.Errorf("paper replay receipt %d does not match its review", entry.ID)
	}
	record, bars, err := readPaperMarketInput(ctx, q, plan)
	if err != nil {
		return nil, err
	}
	last := bars[len(bars)-1]
	version, err := q.GetRuleVersion(ctx, record.RuleVersionID)
	if err != nil {
		return nil, err
	}
	def, err := decodeSavedRule(version)
	if err != nil {
		return nil, err
	}
	rule, err := json.MarshalIndent(def.Entry, "", "  ")
	if err != nil {
		return nil, err
	}
	return &labv1.PaperReplayObservation{
		Opportunity: &labv1.MarketOpportunity{
			Id: record.ID, Symbol: record.Symbol, RuleVersionId: version.ID, RuleTitle: version.Title,
			ReportId: record.ReportID, Reason: record.Reason, ReferenceClose: usdtP(record.ReferenceClose),
			CandleClosedAtUnixMs: ms(record.CandleClosedAt), ObservedAtUnixMs: ms(record.ObservedAt), ExpiresAtUnixMs: ms(record.ExpiresAt),
		},
		SnapshotSha256: record.SnapshotSha256, InputCandleCount: int32(len(bars)), LastInputAvailableAtUnixMs: ms(last.AvailableAt),
		LastInputOpen: usdtP(last.O.V), LastInputHigh: usdtP(last.H.V), LastInputLow: usdtP(last.L.V),
		RuleSha256: version.ContentHash, EntryRuleJson: string(rule), MarketContext: paperMarketContextP(record, bars),
	}, nil
}

func readPaperReplayExecution(ctx context.Context, q *db.Queries, entry db.PaperEntry, cursor int64, response *labv1.GetPaperReplayResponse) error {
	row, err := q.PaperReplayEvent(ctx, db.PaperReplayEventParams{ReceiptID: entry.ID, EventID: cursor})
	if errors.Is(err, pgx.ErrNoRows) {
		return connect.NewError(connect.CodeNotFound, errors.New("رویداد برای این رسید پیدا نشد"))
	}
	if err != nil {
		return err
	}
	execution := &labv1.PaperReplayExecution{Event: paperEventP(entry, row.PaperExecutionEvent)}
	if execution.Event.GetKind() == "accepted" {
		evidence, err := q.PaperConfirmationEvidence(ctx, cursor)
		if err == nil {
			execution.ApprovalBuildSha256 = evidence.EngineBuildSha256
			execution.ConfirmationCandle = &labv1.MarketCandle{
				OpenedAtUnixMs: ms(evidence.OpenTime), ClosedAtUnixMs: ms(evidence.CloseTime),
				AvailableAtUnixMs: ms(evidence.AvailableAt), Revision: evidence.Revision, Close: usdtP(evidence.ClosePrice),
			}
		} else if !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
	}
	response.Step = &labv1.GetPaperReplayResponse_Execution{Execution: execution}
	previous := row.PreviousID
	if previous == 0 {
		previous = paperReplayReview
	}
	response.PreviousCursor = proto.Int64(previous)
	if row.NextID > 0 {
		response.NextCursor = proto.Int64(row.NextID)
	}
	return nil
}
