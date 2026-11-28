package api

import (
	"context"
	"crypto/sha256"
	"fmt"
	"strings"
	"unicode/utf8"

	"connectrpc.com/connect"

	"tradinglab/engine/internal/assistant"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/store/db"
)

func (a *Assistant) DraftStrategy(ctx context.Context, req *connect.Request[labv1.DraftStrategyRequest]) (*connect.Response[labv1.DraftStrategyResponse], error) {
	description := strings.TrimSpace(req.Msg.GetDescription())
	if description == "" || len(description) > 4_800 || !utf8.ValidString(description) || utf8.RuneCountInString(description) > 1_200 || strings.ContainsRune(description, 0) {
		return nil, invalid("توضیح استراتژی باید بین ۱ تا ۱۲۰۰ نویسه باشد")
	}
	// A digest deduplicates an in-flight request without storing the description or draft.
	digest := fmt.Sprintf("%x", sha256.Sum256([]byte(description)))
	result, err := a.explain(ctx, db.ReserveAssistantRunParams{EvidenceSha256: digest, RuleDraft: true}, assistant.Draft(description))
	if err != nil {
		return nil, err
	}
	response := &labv1.DraftStrategyResponse{DefinitionJson: result.Draft.Definition, LookbackBars: int32(result.Draft.Lookback),
		Model: assistant.Model, InputTokens: result.input, OutputTokens: result.output}
	for _, question := range result.Draft.Questions {
		response.Questions = append(response.Questions, draftQuestionP[question])
	}
	return connect.NewResponse(response), nil
}

var draftQuestionP = map[string]labv1.DraftQuestion{
	"entry":       labv1.DraftQuestion_DRAFT_QUESTION_ENTRY,
	"exit":        labv1.DraftQuestion_DRAFT_QUESTION_EXIT,
	"exposure":    labv1.DraftQuestion_DRAFT_QUESTION_EXPOSURE,
	"timeframe":   labv1.DraftQuestion_DRAFT_QUESTION_TIMEFRAME,
	"unsupported": labv1.DraftQuestion_DRAFT_QUESTION_UNSUPPORTED,
	"parameters":  labv1.DraftQuestion_DRAFT_QUESTION_PARAMETERS,
}
