package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/experiment"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/store"
)

type Library struct {
	Store *store.Store
}

func (h *Library) ListAlgorithms(ctx context.Context, _ *connect.Request[labv1.ListAlgorithmsRequest]) (*connect.Response[labv1.ListAlgorithmsResponse], error) {
	algs, err := h.Store.ListAlgorithms(ctx)
	if err != nil {
		return nil, err
	}
	res := &labv1.ListAlgorithmsResponse{}
	for _, a := range algs {
		pa := &labv1.Algorithm{Id: a.ID, Family: a.Family, Description: a.Description, ActiveModel: a.ActiveModel.String}
		vs, err := h.Store.ListAlgorithmVersions(ctx, a.ID)
		if err != nil {
			return nil, err
		}
		for _, v := range vs {
			var def experiment.VersionDefinition
			if err := json.Unmarshal(v.Definition, &def); err != nil {
				return nil, err
			}
			pv := &labv1.AlgorithmVersion{Id: v.ID, Version: v.Version, State: v.State, ContentHash: v.ContentHash, CreatedUnixMs: ms(v.CreatedAt), NextStates: experiment.NextStates(v.State)}
			for _, p := range def.Params {
				pv.Params = append(pv.Params, &labv1.ParamSpec{Name: p.Name, Default: p.Default, Integer: p.Integer})
			}
			if def.Recipe != nil {
				pv.Recipe = recipeItems(*def.Recipe)
			}
			pa.Versions = append(pa.Versions, pv)
		}
		latest, err := h.Store.LatestReportForStrategy(ctx, a.ID)
		switch {
		case errors.Is(err, pgx.ErrNoRows):
		case err != nil:
			return nil, err
		default:
			pa.LatestReport = &labv1.LatestReport{ReportId: latest.ID, TotalReturn: decP(latest.OosReturn, 6), CreatedUnixMs: ms(latest.CreatedAt)}
		}
		res.Algorithms = append(res.Algorithms, pa)
	}
	return connect.NewResponse(res), nil
}

// SetVersionState is the only path to a lifecycle change, and it is a user action.
func (h *Library) SetVersionState(ctx context.Context, req *connect.Request[labv1.SetVersionStateRequest]) (*connect.Response[labv1.SetVersionStateResponse], error) {
	m := req.Msg
	if err := experiment.SetState(ctx, h.Store, m.GetVersionId(), m.GetState(), m.GetNote()); err != nil {
		return nil, expErr(err)
	}
	return connect.NewResponse(&labv1.SetVersionStateResponse{}), nil
}

func (h *Library) ListLifecycleEvents(ctx context.Context, req *connect.Request[labv1.ListLifecycleEventsRequest]) (*connect.Response[labv1.ListLifecycleEventsResponse], error) {
	rows, err := h.Store.ListLifecycleEvents(ctx, req.Msg.GetVersionId())
	if err != nil {
		return nil, err
	}
	res := &labv1.ListLifecycleEventsResponse{}
	for _, r := range rows {
		res.Events = append(res.Events, &labv1.LifecycleEvent{FromState: r.FromState, ToState: r.ToState, Note: r.Note, Actor: r.Actor, AtUnixMs: ms(r.At)})
	}
	return connect.NewResponse(res), nil
}

// recipeItems describes a recipe for the library's detail panel.
func recipeItems(r model.Recipe) []*labv1.RecipeItem {
	item := func(k, v string) *labv1.RecipeItem { return &labv1.RecipeItem{Key: k, Value: v} }
	out := []*labv1.RecipeItem{
		item("ویژگی‌ها", strings.Join(r.Features, ", ")),
		item("تبدیل", r.Transform+" (fit in train)"),
		item("مدل", fmt.Sprintf("%s α=%g", r.Model, r.Alpha)),
		item("برچسب", fmt.Sprintf("h=%d bars", r.Horizon)),
		item("ورود", fmt.Sprintf("prediction > %g", r.Entry)),
	}
	if r.Filter != nil {
		out = append(out, item("فیلتر", fmt.Sprintf("%s z ≤ %g", r.Filter.Feature, r.Filter.Max)))
	}
	exit := "signal off"
	if r.StopLoss > 0 {
		exit += fmt.Sprintf(" | stop %g%%", r.StopLoss*100)
	}
	if r.TakeProfit > 0 {
		exit += fmt.Sprintf(" | take %g%%", r.TakeProfit*100)
	}
	return append(out, item("خروج", exit), item("سهم سرمایه", fmt.Sprintf("%g%%", r.Exposure*100)))
}
