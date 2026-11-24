package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"strconv"
	"strings"
	"unicode/utf8"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/strategy"
)

func (h *Library) ListRuleVersions(ctx context.Context, req *connect.Request[labv1.ListRuleVersionsRequest]) (*connect.Response[labv1.ListRuleVersionsResponse], error) {
	m := req.Msg
	query := strings.TrimSpace(m.GetQuery())
	if m.GetPageSize() < 0 || m.GetBeforeId() < 0 || !validRuleTitle(query) {
		return nil, invalid("عبارت جست‌وجو یا نشانگر صفحه نامعتبر است")
	}
	through := int64(math.MaxInt64)
	if m.GetBeforeId() > 0 {
		through = m.GetBeforeId() - 1
	}
	var hasReport *bool
	switch m.GetEvidenceFilter() {
	case labv1.RuleEvidenceFilter_RULE_EVIDENCE_FILTER_UNSPECIFIED:
	case labv1.RuleEvidenceFilter_RULE_EVIDENCE_FILTER_WITH_REPORT, labv1.RuleEvidenceFilter_RULE_EVIDENCE_FILTER_WITHOUT_REPORT:
		include := m.GetEvidenceFilter() == labv1.RuleEvidenceFilter_RULE_EVIDENCE_FILTER_WITH_REPORT
		hasReport = &include
	default:
		return nil, invalid("فیلتر گزارش ارزیابی نامعتبر است")
	}
	limit := pageSize(m.GetPageSize())
	rows, err := h.Store.ListRuleVersionsPage(ctx, db.ListRuleVersionsPageParams{ThroughID: through, Query: query, HasReport: hasReport, PageLimit: limit + 1})
	if err != nil {
		return nil, err
	}
	res := &labv1.ListRuleVersionsResponse{}
	if len(rows) > int(limit) {
		rows = rows[:limit]
		res.NextBeforeId = rows[len(rows)-1].ID
	}
	for _, row := range rows {
		res.Versions = append(res.Versions, ruleSummary(row))
	}
	return connect.NewResponse(res), nil
}

func ruleSummary(row db.ListRuleVersionsPageRow) *labv1.RuleVersionSummary {
	res := &labv1.RuleVersionSummary{Id: row.ID, Title: row.Title, ContentHash: row.ContentHash, TemplateKey: row.TemplateKey, CreatedUnixMs: ms(row.CreatedAt)}
	if row.ParentID != nil {
		res.ParentId = *row.ParentID
	}
	if row.OtherParentID != nil {
		res.OtherParentId = *row.OtherParentID
	}
	return res
}

func savedRuleSummary(row db.StrategyRuleVersion) *labv1.RuleVersionSummary {
	return ruleSummary(db.ListRuleVersionsPageRow{
		ID: row.ID, Title: row.Title, ContentHash: row.ContentHash, ParentID: row.ParentID,
		OtherParentID: row.OtherParentID, TemplateKey: row.TemplateKey, CreatedAt: row.CreatedAt,
	})
}

func getSavedRule(ctx context.Context, st *store.Store, id int64) (db.StrategyRuleVersion, error) {
	if id < 1 {
		return db.StrategyRuleVersion{}, invalid("یک نسخهٔ ذخیره‌شده از قواعد انتخاب کنید")
	}
	row, err := st.GetRuleVersion(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return row, connect.NewError(connect.CodeNotFound, errors.New("نسخهٔ قواعد پیدا نشد"))
	}
	return row, err
}

// Decode JSONB through the same validator as new drafts and verify the immutable identity.
func decodeSavedRule(row db.StrategyRuleVersion) (strategy.RuleDefinition, error) {
	var def strategy.RuleDefinition
	if err := json.Unmarshal(row.Definition, &def); err != nil {
		return def, fmt.Errorf("stored rule version %d: %w", row.ID, err)
	}
	hash, err := def.ContentHash()
	if err != nil || hash != row.ContentHash {
		return def, fmt.Errorf("stored rule version %d has a mismatched content hash", row.ID)
	}
	return def, nil
}

func (h *Library) GetRuleVersion(ctx context.Context, req *connect.Request[labv1.GetRuleVersionRequest]) (*connect.Response[labv1.GetRuleVersionResponse], error) {
	row, err := getSavedRule(ctx, h.Store, req.Msg.GetId())
	if err != nil {
		return nil, err
	}
	def, err := decodeSavedRule(row)
	if err != nil {
		return nil, err
	}
	encoded, err := json.Marshal(def)
	if err != nil {
		return nil, err
	}
	res := &labv1.GetRuleVersionResponse{Version: savedRuleSummary(row), DefinitionJson: string(encoded)}
	// The newest report is scoped to the version ID because clones can share a hash.
	latest, err := h.Store.LatestReportForRuleVersion(ctx, strconv.FormatInt(row.ID, 10))
	switch {
	case errors.Is(err, pgx.ErrNoRows):
	case err != nil:
		return nil, err
	default:
		res.LatestReport = &labv1.LatestReport{ReportId: latest.ID, TotalReturn: decP(latest.OosReturn, 6), CreatedUnixMs: ms(latest.CreatedAt)}
	}
	return connect.NewResponse(res), nil
}

func validRuleTitle(value string) bool {
	return utf8.ValidString(value) && !strings.ContainsRune(value, 0) && utf8.RuneCountInString(value) <= 100
}

func (h *Library) insertRule(ctx context.Context, args db.InsertRuleVersionParams, def strategy.RuleDefinition) (*labv1.RuleVersionSummary, error) {
	args.Title = strings.TrimSpace(args.Title)
	if args.Title == "" || !validRuleTitle(args.Title) {
		return nil, invalid("برای قواعد عنوانی با ۱ تا ۱۰۰ نویسه وارد کنید")
	}
	var err error
	args.ContentHash, err = def.ContentHash()
	if err != nil {
		return nil, invalid(err.Error())
	}
	args.Definition, err = json.Marshal(def)
	if err != nil {
		return nil, err
	}
	row, err := h.Store.InsertRuleVersion(ctx, args)
	if err != nil {
		return nil, err
	}
	return savedRuleSummary(row), nil
}

func (h *Library) SaveRuleVersion(ctx context.Context, req *connect.Request[labv1.SaveRuleVersionRequest]) (*connect.Response[labv1.SaveRuleVersionResponse], error) {
	m := req.Msg
	var def strategy.RuleDefinition
	if err := json.Unmarshal([]byte(m.GetDefinitionJson()), &def); err != nil {
		return nil, invalid(err.Error())
	}
	args := db.InsertRuleVersionParams{Title: m.GetTitle()}
	if key := m.GetTemplateKey(); key != "" {
		if m.GetParentId() != 0 {
			return nil, invalid("برای نسخهٔ جدید تنها یک منبع انتخاب کنید")
		}
		for _, template := range ruleTemplates() {
			if template.key == key {
				args.TemplateKey = key
				break
			}
		}
		if args.TemplateKey == "" {
			return nil, invalid("این الگوی قواعد وجود ندارد")
		}
	}
	if id := m.GetParentId(); id != 0 {
		if _, err := getSavedRule(ctx, h.Store, id); err != nil {
			return nil, err
		}
		args.ParentID = &id
	}
	version, err := h.insertRule(ctx, args, def)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.SaveRuleVersionResponse{Version: version}), nil
}

func (h *Library) ComposeRuleVersions(ctx context.Context, req *connect.Request[labv1.ComposeRuleVersionsRequest]) (*connect.Response[labv1.ComposeRuleVersionsResponse], error) {
	m := req.Msg
	first, second := m.GetFirstId(), m.GetSecondId()
	if first < 1 || second < 1 || first == second {
		return nil, invalid("دو نسخهٔ متفاوت انتخاب کنید")
	}
	owner := "a"
	switch m.GetExitOwnerId() {
	case first:
	case second:
		owner = "b"
	default:
		return nil, invalid("مسئول خروج را از میان دو نسخه انتخاب کنید")
	}
	components := make([]strategy.RuleDefinition, 0, 2)
	for _, id := range []int64{first, second} {
		row, err := getSavedRule(ctx, h.Store, id)
		if err != nil {
			return nil, err
		}
		def, err := decodeSavedRule(row)
		if err != nil {
			return nil, err
		}
		components = append(components, def)
	}
	var def strategy.RuleDefinition
	var err error
	switch {
	case m.GetEntryMode() == "regime":
		def, err = strategy.ComposeRegimeRules(components[0], components[1], int(m.GetRegimeSmaPeriod()), owner)
	case m.GetRegimeSmaPeriod() != 0:
		return nil, invalid("دورهٔ میانگین فقط برای انتخاب بر اساس وضعیت بازار است")
	default:
		def, err = strategy.ComposeRules(components[0], components[1], m.GetEntryMode(), owner)
	}
	if err != nil {
		return nil, invalid(err.Error())
	}
	version, err := h.insertRule(ctx, db.InsertRuleVersionParams{Title: m.GetTitle(), ParentID: &first, OtherParentID: &second}, def)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.ComposeRuleVersionsResponse{Version: version}), nil
}

func ruleTemplates() []ruleTemplate {
	// Both initial recipes use only indicators with defined closed-bar semantics.
	return []ruleTemplate{
		{"sma-cross", "تقاطع میانگین‌های متحرک", "ورود با تقاطع صعودی و خروج با تقاطع نزولی میانگین‌های ۱۰ و ۳۰ کندلی", crossTemplate("", &strategy.RuleValue{Kind: "sma", Period: 10}, &strategy.RuleValue{Kind: "sma", Period: 30})},
		{"closed-hour-trend", "تقاطع با قیمت بسته‌شدهٔ ساعتی", "مقایسهٔ قیمت کندل ۱۵ دقیقه‌ای با آخرین قیمت بسته‌شدهٔ یک‌ساعته", crossTemplate(data.TF15m, &strategy.RuleValue{Kind: "close"}, &strategy.RuleValue{Kind: "bucket_close", Timeframe: data.TF1h})},
	}
}

type ruleTemplate struct {
	key, title, description string
	def                     strategy.RuleDefinition
}

func (h *Library) ListRuleTemplates(context.Context, *connect.Request[labv1.ListRuleTemplatesRequest]) (*connect.Response[labv1.ListRuleTemplatesResponse], error) {
	res := &labv1.ListRuleTemplatesResponse{}
	for _, t := range ruleTemplates() {
		if _, err := t.def.Build(); err != nil {
			return nil, err
		}
		encoded, err := json.Marshal(t.def)
		if err != nil {
			return nil, err
		}
		res.Templates = append(res.Templates, &labv1.RuleTemplate{Key: t.key, Title: t.title, Description: t.description, DefinitionJson: string(encoded)})
	}
	return connect.NewResponse(res), nil
}

func crossTemplate(base data.Timeframe, left, right *strategy.RuleValue) strategy.RuleDefinition {
	return strategy.RuleDefinition{
		Format: strategy.RuleFormatV1, Exposure: money.RatioOne, BaseTimeframe: base,
		Entry: strategy.Rule{Op: "cross_above", Left: left, Right: right},
		Exit:  strategy.Rule{Op: "cross_below", Left: left, Right: right},
	}
}
