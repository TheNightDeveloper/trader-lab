package api

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"slices"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"
	"google.golang.org/protobuf/proto"

	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/money"
	"tradinglab/engine/internal/paper"
	"tradinglab/engine/internal/store/db"
)

const paperFillModel = "spot-closed-1m-v1"

func (p *Paper) PreviewPaperPlan(ctx context.Context, req *connect.Request[labv1.PreviewPaperPlanRequest]) (*connect.Response[labv1.PreviewPaperPlanResponse], error) {
	in := req.Msg
	if !paperAccountMatches(in.GetAccount()) || in.GetOpportunityId() <= 0 {
		return nil, invalid("حساب مجازی و فرصت را مشخص کنید")
	}
	stop, hasStop, stopErr := usdtIn(in.GetStop(), "stop")
	target, hasTarget, targetErr := usdtIn(in.GetTakeProfit(), "take profit")
	if !hasStop || !hasTarget || stopErr != nil || targetErr != nil || stop.V <= 0 || target.V <= 0 {
		return nil, invalid("حد ضرر و هدف باید قیمت مثبت USDT باشند")
	}
	account, err := p.Market.Store.ReadPaperAccount(ctx, paperAccountID)
	if errors.Is(err, pgx.ErrNoRows) {
		return rejectPaperPlan("account_missing", "ابتدا حساب مجازی را ایجاد کنید"), nil
	}
	if err != nil {
		return nil, err
	}
	opp, err := p.Market.Store.PaperOpportunity(ctx, in.GetOpportunityId())
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, connect.NewError(connect.CodeNotFound, errors.New("فرصت پیدا نشد"))
	}
	if err != nil {
		return nil, err
	}
	spec, supported := paperSpotSpec(opp.Symbol)
	if !supported || spotKey(spec).GetSpecRevision() != opp.SpecRevision {
		return rejectPaperPlan("instrument_changed", "مشخصات نماد این فرصت دیگر معتبر نیست"), nil
	}
	now := p.Market.Clock.Now()
	if now.Before(opp.ObservedAt) || !now.Before(opp.ExpiresAt) {
		return rejectPaperPlan("opportunity_expired", "اعتبار فرصت پایان یافته است"), nil
	}
	candle, err := p.paperCandle(ctx, opp.Symbol, now, opp.CandleClosedAt)
	if errors.Is(err, errMarketFeed) {
		return rejectPaperPlan("feed_stale", errMarketFeed.Error()), nil
	}
	if err != nil {
		return nil, err
	}
	version, err := p.Market.Store.GetRuleVersion(ctx, opp.RuleVersionID)
	if err != nil {
		return nil, err
	}
	rule, err := decodeSavedRule(version)
	if err != nil {
		return nil, err
	}
	exposure, err := rule.Exposure.Apply(account.InitialCapital, money.Floor)
	if err != nil {
		return nil, err
	}
	limit, err := money.Ratio(account.EntryDriftPpm).Plus(opp.ReferenceClose, money.Floor)
	if err != nil {
		return nil, err
	}
	entryLimit, err := spec.RoundPrice(money.Price{V: limit, Scale: instrument.Scale}, money.Floor)
	if err != nil {
		return nil, err
	}
	costs := paper.Costs{Fee: money.Ratio(account.FeePpm), Slippage: money.Ratio(account.SlippagePpm)}
	estimate, err := costs.Fill(spec, true, candle.C, 0)
	if err != nil {
		return nil, err
	}
	if estimate.Price > entryLimit.V {
		return rejectPaperPlan("entry_drift", "قیمت ورود برآوردی از محدودهٔ مجاز فرصت بالاتر است"), nil
	}
	size, err := paper.SizePlan(spec, costs, paper.PlanInput{
		Reference: candle.C, EntryLimit: entryLimit.V, Stop: stop.V, TakeProfit: target.V,
		Cash: account.CashAvailable, NotionalBudget: min(exposure, account.MaxExposure),
		LossBudget: min(account.MaxLoss, account.MaxOpenLoss), MaxCost: money.Ratio(account.MaxCostPpm),
	})
	switch {
	case errors.Is(err, paper.ErrLevels):
		return rejectPaperPlan("price_levels", "حد ضرر باید پایین‌تر از قیمت مرجع و هدف بالاتر از سقف ورود باشد؛ گام قیمت نماد را رعایت کنید"), nil
	case errors.Is(err, paper.ErrBudget):
		return rejectPaperPlan("risk_budget", "سرمایه یا بودجهٔ ریسک برای حداقل اندازهٔ معامله کافی نیست"), nil
	case errors.Is(err, paper.ErrCost):
		return rejectPaperPlan("cost_limit", "هزینه از سقف سیاست بیشتر است یا بازده خالص در هدف مثبت نیست"), nil
	case err != nil:
		return nil, err
	}
	expires := candle.CloseTime.Add(2 * time.Minute)
	if opp.ExpiresAt.Before(expires) {
		expires = opp.ExpiresAt
	}
	if !p.Market.Clock.Now().Before(expires) {
		return rejectPaperPlan("feed_stale", errMarketFeed.Error()), nil
	}
	quoted := candle.AvailableAt
	if opp.ObservedAt.After(quoted) {
		quoted = opp.ObservedAt
	}
	plan := &labv1.PaperPlan{
		Account: paperAccountRef(), AccountRevision: account.Revision, RiskPolicy: paperPolicyP(account),
		OpportunityId: in.GetOpportunityId(), Instrument: spotKey(spec), RuleVersionId: opp.RuleVersionID,
		ReportId: opp.ReportID, SnapshotSha256: opp.SnapshotSha256, QuotedAtUnixMs: ms(quoted), ExpiresAtUnixMs: ms(expires),
		ReferencePrice: usdtP(candle.C), EstimatedEntry: usdtP(size.EntryPrice), MaxEntryPrice: usdtP(entryLimit.V),
		Stop: usdtP(stop.V), TakeProfit: usdtP(target.V), Quantity: moneyP(money.Amount{V: size.Quantity, Asset: spec.Base}),
		Notional: usdtP(size.Notional), RequiredCash: usdtP(size.ReservedCash), PlannedLoss: usdtP(size.PlannedLoss),
		EstimatedCost: usdtP(size.EstimatedCost), FeeRate: ratioP(costs.Fee), SlippageRate: ratioP(costs.Slippage), FillModel: paperFillModel,
		ReferenceCandleClosedAtUnixMs: ms(candle.CloseTime), ReferenceCandleRevision: candle.Revision,
	}
	// The digest binds the full immutable review, apart from the digest field itself.
	body, err := proto.MarshalOptions{Deterministic: true}.Marshal(plan)
	if err != nil {
		return nil, err
	}
	plan.PlanHash = paperPlanHash(body)
	if err := p.Market.Store.StorePaperPlan(ctx, db.StorePaperPlanParams{
		Hash: plan.PlanHash, AccountID: account.ID, OpportunityID: plan.OpportunityId, ExpiresAt: expires, Body: body,
	}); err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.PreviewPaperPlanResponse{Plan: plan}), nil
}

func (p *Paper) GetPaperPlan(ctx context.Context, req *connect.Request[labv1.GetPaperPlanRequest]) (*connect.Response[labv1.GetPaperPlanResponse], error) {
	plan, err := readPaperPlan(ctx, p.Market.Store.Queries, req.Msg.GetPlanHash())
	if err != nil {
		return nil, err
	}
	account, err := p.Market.Store.ReadPaperAccount(ctx, plan.GetAccount().GetAccountId())
	if err != nil {
		return nil, err
	}
	restriction, err := p.reviewRestriction(ctx, plan, account)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.GetPaperPlanResponse{Plan: plan, Restriction: restriction}), nil
}

func (p *Paper) reviewRestriction(ctx context.Context, plan *labv1.PaperPlan, account db.ReadPaperAccountRow) (*labv1.PaperRestriction, error) {
	now := p.Market.Clock.Now()
	if now.UnixMilli() >= plan.GetExpiresAtUnixMs() {
		return paperRestriction("plan_expired", "اعتبار این برنامه پایان یافته است"), nil
	}
	if account.Revision != plan.GetAccountRevision() || account.PolicyRevision != plan.GetRiskPolicy().GetRevision() {
		return paperRestriction("account_changed", "موجودی یا سیاست حساب تغییر کرده است؛ برنامه را دوباره مرور کنید"), nil
	}
	symbol := plan.GetInstrument().GetSymbol()
	spec, supported := paperSpotSpec(symbol)
	if !supported || spotKey(spec).GetSpecRevision() != plan.GetInstrument().GetSpecRevision() {
		return paperRestriction("instrument_changed", "مشخصات نماد این برنامه دیگر معتبر نیست"), nil
	}
	candle, err := p.paperCandle(ctx, symbol, now, time.UnixMilli(plan.GetReferenceCandleClosedAtUnixMs()))
	if errors.Is(err, errMarketFeed) {
		return paperRestriction("feed_stale", errMarketFeed.Error()), nil
	}
	if err != nil {
		return nil, err
	}
	costs := paper.Costs{Fee: money.Ratio(account.FeePpm), Slippage: money.Ratio(account.SlippagePpm)}
	entry, err := costs.Fill(spec, true, candle.C, 0)
	if err != nil {
		return nil, err
	}
	limit, _, err := usdtIn(plan.GetMaxEntryPrice(), "entry limit")
	if err != nil {
		return nil, err
	}
	stop, _, err := usdtIn(plan.GetStop(), "stop")
	if err != nil {
		return nil, err
	}
	if entry.Price > limit.V || candle.C <= stop.V {
		return paperRestriction("entry_drift", "قیمت از محدودهٔ ورود برنامه خارج شده است"), nil
	}
	return nil, nil
}

func readPaperPlan(ctx context.Context, q *db.Queries, hash string) (*labv1.PaperPlan, error) {
	if len(hash) != sha256.Size*2 {
		return nil, invalid("شناسهٔ برنامه معتبر نیست")
	}
	if _, err := hex.DecodeString(hash); err != nil {
		return nil, invalid("شناسهٔ برنامه معتبر نیست")
	}
	body, err := q.LoadPaperPlan(ctx, hash)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, connect.NewError(connect.CodeNotFound, errors.New("برنامه پیدا نشد"))
	}
	if err != nil {
		return nil, err
	}
	plan := &labv1.PaperPlan{}
	if err := proto.Unmarshal(body, plan); err != nil {
		return nil, fmt.Errorf("decode paper plan: %w", err)
	}
	if paperPlanHash(body) != hash || !paperAccountMatches(plan.GetAccount()) {
		return nil, fmt.Errorf("invalid stored Paper plan %s", hash)
	}
	plan.PlanHash = hash
	return plan, nil
}

func (p *Paper) paperCandle(ctx context.Context, symbol string, now, minClose time.Time) (db.LatestMarketCandlesRow, error) {
	feed := p.Market.feed(symbol)
	if !slices.Contains(p.Market.Symbols, symbol) || feed.LastClose.Before(minClose) || feed.State != data.LiveFresh {
		return db.LatestMarketCandlesRow{}, errMarketFeed
	}
	candles, err := p.Market.Store.LatestMarketCandles(ctx, db.LatestMarketCandlesParams{Symbols: []string{symbol}, AsOf: now})
	if err != nil {
		return db.LatestMarketCandlesRow{}, err
	}
	if len(candles) != 1 || marketFeedState(feed, candles[0].CloseTime) != labv1.LiveState_LIVE_STATE_FRESH ||
		!now.Before(candles[0].CloseTime.Add(2*time.Minute)) || candles[0].C <= 0 {
		return db.LatestMarketCandlesRow{}, errMarketFeed
	}
	return candles[0], nil
}

func paperSpotSpec(symbol string) (instrument.Spec, bool) {
	for _, spec := range instrument.Defaults() {
		if spec.Symbol == symbol && spec.Quote == instrument.USDT {
			return spec, true
		}
	}
	return instrument.Spec{}, false
}

func paperPlanHash(body []byte) string { return fmt.Sprintf("%x", sha256.Sum256(body)) }

func paperRestriction(code, detail string) *labv1.PaperRestriction {
	return &labv1.PaperRestriction{Code: code, Detail: detail}
}

func rejectPaperPlan(code, detail string) *connect.Response[labv1.PreviewPaperPlanResponse] {
	return connect.NewResponse(&labv1.PreviewPaperPlanResponse{Restriction: paperRestriction(code, detail)})
}
