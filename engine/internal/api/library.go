package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"slices"
	"strings"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"

	"tradinglab/engine/internal/experiment"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/model"
	"tradinglab/engine/internal/store"
	"tradinglab/engine/internal/store/db"
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
		snapshot, err := experiment.Snapshot(ctx, h.Store, a.ID)
		if err != nil {
			return nil, expErr(err)
		}
		a = snapshot.Algorithm
		pa := &labv1.Algorithm{Id: a.ID, Family: a.Family, Description: a.Description, ActiveModel: a.ActiveModel.String, LifecycleRevision: a.LifecycleRevision}
		vs := snapshot.Versions
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
				// Learning activation is available only through evaluated cycle approval.
				pv.NextStates = slices.DeleteFunc(slices.Clone(pv.NextStates), func(s string) bool { return s == experiment.Active })
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

// SetVersionState delegates library decisions to the shared revision-checked lifecycle service.
func (h *Library) SetVersionState(ctx context.Context, req *connect.Request[labv1.SetVersionStateRequest]) (*connect.Response[labv1.SetVersionStateResponse], error) {
	m := req.Msg
	if m.ExpectedRevision == nil {
		return nil, expErr(experiment.ErrConflict)
	}
	if err := experiment.SetState(ctx, h.Store, m.GetVersionId(), m.GetState(), m.GetNote(), m.GetExpectedRevision()); err != nil {
		return nil, expErr(err)
	}
	return connect.NewResponse(&labv1.SetVersionStateResponse{}), nil
}

func (h *Library) ListLifecycleEvents(ctx context.Context, req *connect.Request[labv1.ListLifecycleEventsRequest]) (*connect.Response[labv1.ListLifecycleEventsResponse], error) {
	versionID := req.Msg.GetVersionId()
	var rows []db.LifecycleEvent
	var err error
	res := &labv1.ListLifecycleEventsResponse{}
	if req.Msg.GetPageSize() == 0 && req.Msg.GetBefore() == nil {
		// Existing clients get the complete chronological history they requested before paging existed.
		rows, err = h.Store.ListLifecycleEvents(ctx, versionID)
	} else {
		if versionID == "" || req.Msg.GetPageSize() < 0 {
			return nil, invalid("شناسهٔ نسخه و اندازهٔ صفحهٔ رویدادها نامعتبر است")
		}
		throughID := int64(math.MaxInt64)
		if before := req.Msg.GetBefore(); before != nil {
			if before.GetStrategyVersionId() != versionID || before.GetSequence() < 1 {
				return nil, invalid("نشانگر رویدادها به این نسخه تعلق ندارد")
			}
			throughID = before.GetSequence() - 1
		}
		limit := pageSize(req.Msg.GetPageSize())
		rows, err = h.Store.ListLifecycleEventsPage(ctx, db.ListLifecycleEventsPageParams{
			VersionID: versionID, ThroughID: throughID, PageLimit: limit + 1,
		})
		if len(rows) > int(limit) {
			rows = rows[:limit]
			res.NextCursor = lifecycleCursor(rows[len(rows)-1])
		}
	}
	if err != nil {
		return nil, err
	}
	for _, r := range rows {
		res.Events = append(res.Events, &labv1.LifecycleEvent{
			FromState: r.FromState, ToState: r.ToState, Note: r.Note, Actor: r.Actor, AtUnixMs: ms(r.At),
			Audit: &labv1.AuditEvent{Cursor: lifecycleCursor(r), Actor: auditActors[r.Actor], RecordedAtUnixMs: ms(r.At)},
		})
	}
	return connect.NewResponse(res), nil
}

func lifecycleCursor(row db.LifecycleEvent) *labv1.AuditCursor {
	return &labv1.AuditCursor{Scope: &labv1.AuditCursor_StrategyVersionId{StrategyVersionId: row.VersionID}, Sequence: row.ID}
}

var auditActors = map[string]labv1.AuditActor{
	"user":   labv1.AuditActor_AUDIT_ACTOR_USER,
	"system": labv1.AuditActor_AUDIT_ACTOR_SYSTEM,
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
