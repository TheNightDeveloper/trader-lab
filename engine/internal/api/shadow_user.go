package api

import (
	"context"
	"errors"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/store/db"
)

func (s *Shadow) SetShadowUserDecision(ctx context.Context, req *connect.Request[labv1.SetShadowUserDecisionRequest]) (*connect.Response[labv1.SetShadowUserDecisionResponse], error) {
	m := req.Msg
	if m.GetDeploymentId() <= 0 || m.GetObservationId() <= 0 || m.Allow == nil {
		return nil, invalid("اجرا، سیگنال و تصمیم ورود را مشخص کنید")
	}
	var saved db.ShadowUserDecision
	err := s.Market.Store.InTx(ctx, func(q *db.Queries) error {
		// Use the same deployment lock as stop and candle capture. The first decision wins.
		deployment, err := q.LockShadowDeployment(ctx, m.GetDeploymentId())
		if errors.Is(err, pgx.ErrNoRows) {
			return connect.NewError(connect.CodeNotFound, errors.New("اجرای سایه پیدا نشد"))
		}
		if err != nil {
			return err
		}
		hour, err := q.GetShadowHour(ctx, db.GetShadowHourParams{DeploymentID: deployment.ID, ID: m.GetObservationId()})
		if errors.Is(err, pgx.ErrNoRows) {
			return connect.NewError(connect.CodeNotFound, errors.New("سیگنال این اجرا پیدا نشد"))
		}
		if err != nil {
			return err
		}
		saved, err = q.GetShadowUserDecision(ctx, hour.ID)
		if err == nil {
			if saved.Allow != m.GetAllow() {
				return connect.NewError(connect.CodeAlreadyExists, errors.New("برای این کندل قبلاً تصمیم دیگری ثبت شده است"))
			}
			return nil // Reply retries can recover the original receipt after the cutoff.
		}
		if !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
		now := s.Market.Clock.Now().UTC().Truncate(time.Microsecond)
		if !shadowUserOpen(deployment, hour, now) || deployment.EngineBuild != s.Market.Build {
			return connect.NewError(connect.CodeFailedPrecondition, errors.New("مهلت تصمیم کاربر برای این سیگنال باز نیست"))
		}
		saved, err = q.RecordShadowUserDecision(ctx, db.RecordShadowUserDecisionParams{HourID: hour.ID, Allow: m.GetAllow(), DecidedAt: now})
		return err
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&labv1.SetShadowUserDecisionResponse{DecidedAtUnixMs: ms(saved.DecidedAt)}), nil
}

func shadowUserOpen(d db.ShadowDeployment, h db.ShadowHour, now time.Time) bool {
	return d.UserTrack && d.State == "active" && h.Gate != "no_signal" && !now.Before(h.ObservedAt) && now.Before(h.DecisionAt)
}
