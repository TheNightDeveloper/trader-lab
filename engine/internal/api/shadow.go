package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/assistant"
	"tradinglab/engine/internal/eval"
	"tradinglab/engine/internal/fillpolicy"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/instrument"
	"tradinglab/engine/internal/sim"
	"tradinglab/engine/internal/store/db"
)

const (
	shadowPolicy        = "spot-hourly-shadow/v1"
	shadowHorizon       = 7 * 24 * time.Hour
	shadowDecisionDelay = 2 * time.Minute
)

type Shadow struct {
	Market    *Market
	Assistant *Assistant
}

func (s *Shadow) assistantEnabled() bool {
	return s.Assistant != nil && s.Assistant.Provider != nil && s.Assistant.DailyRequests > 0
}

func (s *Shadow) StartShadowDeployment(ctx context.Context, req *connect.Request[labv1.StartShadowDeploymentRequest]) (*connect.Response[labv1.StartShadowDeploymentResponse], error) {
	symbol, id := req.Msg.GetSymbol(), req.Msg.GetRuleVersionId()
	if id <= 0 || symbol == "" || len(symbol) > 16 {
		return nil, invalid("نماد و نسخهٔ قواعد را انتخاب کنید")
	}
	st := s.Market.Store
	if active, err := st.ActiveShadowDeployment(ctx); err == nil {
		return shadowStartResult(active, symbol, id)
	} else if !errors.Is(err, pgx.ErrNoRows) {
		return nil, err
	}
	if s.Market.Live == nil || !s.assistantEnabled() {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("برای شروع شَدو، جریان بازار و دستیار را در موتور فعال کنید"))
	}
	rule, err := s.Market.marketRule(ctx, symbol, id)
	if err != nil {
		return nil, err
	}
	report, err := st.GetReportChartInputs(ctx, rule.reportID)
	if err != nil {
		return nil, err
	}
	var spec eval.Spec
	if err := json.Unmarshal(report.Spec, &spec); err != nil {
		return nil, fmt.Errorf("shadow report spec: %w", err)
	}
	if spec.FillModel != sim.FillModel || spec.Timeframe != opportunityTF || len(spec.Sim.Holdings) > 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("گزارش ساعتی با مدل اجرای فعلی و سرمایهٔ USDT لازم است"))
	}
	cfg, err := spec.Sim.Normalized()
	if err != nil {
		return nil, reportErr(err)
	}
	if cfg.IntentTTL == 0 {
		cfg.IntentTTL = fillpolicy.DefaultTTL(cfg.LatencyBars, time.Hour)
	}
	config, err := json.Marshal(cfg)
	if err != nil {
		return nil, err
	}
	now := s.Market.Clock.Now().UTC()
	start := now.Truncate(time.Hour).Add(time.Hour)
	deployment, err := st.StartShadowDeployment(ctx, db.StartShadowDeploymentParams{
		Symbol: symbol, RuleVersionID: id, RuleContentHash: rule.version.ContentHash, ReportID: rule.reportID,
		RegisteredAt: now, StartAt: start, EndAt: start.Add(shadowHorizon), SimConfig: config,
		SpecRevision: marketSpecRevision(symbol), RuntimePolicy: shadowPolicy, FillModel: sim.FillModel,
		AiModel: assistant.Model, AiPromptVersion: assistant.ShadowPromptVersion, EngineBuild: s.Market.Build,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		active, err := st.ActiveShadowDeployment(ctx)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return nil, connect.NewError(connect.CodeAborted, errors.New("ثبت شَدو هم‌زمان با یک تغییر دیگر بود. دوباره بررسی کنید"))
			}
			return nil, err
		}
		return shadowStartResult(active, symbol, id)
	}
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.StartShadowDeploymentResponse{DeploymentId: deployment}), nil
}

func shadowStartResult(active db.ShadowDeployment, symbol string, version int64) (*connect.Response[labv1.StartShadowDeploymentResponse], error) {
	if active.Symbol != symbol || active.RuleVersionID != version {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("یک اجرای شَدو فعال است"))
	}
	return connect.NewResponse(&labv1.StartShadowDeploymentResponse{DeploymentId: active.ID}), nil
}

func (s *Shadow) StopShadowDeployment(ctx context.Context, req *connect.Request[labv1.StopShadowDeploymentRequest]) (*connect.Response[labv1.StopShadowDeploymentResponse], error) {
	id := req.Msg.GetDeploymentId()
	if id <= 0 {
		return nil, invalid("شناسهٔ اجرای شَدو معتبر نیست")
	}
	err := s.Market.Store.InTx(ctx, func(q *db.Queries) error {
		d, err := q.LockShadowDeployment(ctx, id)
		if errors.Is(err, pgx.ErrNoRows) {
			return connect.NewError(connect.CodeNotFound, errors.New("اجرای شَدو پیدا نشد"))
		}
		if err != nil || d.State != "active" {
			return err
		}
		now := s.Market.Clock.Now()
		if err := resolveUnfinishedShadow(ctx, q, id, now); err != nil {
			return err
		}
		return q.SettleShadowDeployment(ctx, db.SettleShadowDeploymentParams{ID: id, State: "stopped", SettledAt: &now})
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.StopShadowDeploymentResponse{}), nil
}

func resolveUnfinishedShadow(ctx context.Context, q *db.Queries, id int64, at time.Time) error {
	last, err := q.LatestShadowHour(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil
	}
	if err != nil || last.Gate != "running" {
		return err
	}
	return q.ResolveShadowGate(ctx, db.ResolveShadowGateParams{ID: last.ID, Gate: "unavailable", GateResolvedAt: &at})
}

func shadowInstrument(d db.ShadowDeployment) (instrument.Spec, error) {
	for _, spec := range instrument.SpotSpecsV1() {
		if spec.Symbol == d.Symbol && spec.Quote == instrument.USDT && spotKey(spec).GetSpecRevision() == d.SpecRevision {
			return spec, nil
		}
	}
	return instrument.Spec{}, fmt.Errorf("shadow %d has an unknown spot specification", d.ID)
}
