package api

import (
	"context"
	"net/http"
	"testing"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/data"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/report"
	"tradinglab/engine/internal/store/storetest"
)

func TestSavedRuleVersions(t *testing.T) {
	st := storetest.Open(t)
	ctx := context.Background()
	srv := serve(t, func(m *http.ServeMux) {
		m.Handle(labv1connect.NewLibraryServiceHandler(&Library{Store: st}))
		m.Handle(labv1connect.NewReportServiceHandler(&Report{Svc: report.Service{Store: st, Version: "test"}}))
	})
	library := labv1connect.NewLibraryServiceClient(srv.Client(), srv.URL)
	reports := labv1connect.NewReportServiceClient(srv.Client(), srv.URL)
	templates, err := library.ListRuleTemplates(ctx, connect.NewRequest(&labv1.ListRuleTemplatesRequest{}))
	require.NoError(t, err)
	require.Len(t, templates.Msg.GetTemplates(), 2)
	template := templates.Msg.GetTemplates()[0]
	save := func(title string, parent int64, key string) *labv1.RuleVersionSummary {
		t.Helper()
		res, err := library.SaveRuleVersion(ctx, connect.NewRequest(&labv1.SaveRuleVersionRequest{
			Title: title, DefinitionJson: template.GetDefinitionJson(), ParentId: parent, TemplateKey: key,
		}))
		require.NoError(t, err)
		return res.Msg.GetVersion()
	}
	_, err = library.SaveRuleVersion(ctx, connect.NewRequest(&labv1.SaveRuleVersionRequest{Title: "invalid", DefinitionJson: `{"format":"rules/v99"}`}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))
	first := save("Percent % first", 0, template.GetKey())
	second := save("Percent % clone", first.GetId(), "")
	require.Equal(t, template.GetKey(), first.GetTemplateKey())
	require.Equal(t, first.GetId(), second.GetParentId())
	require.Equal(t, first.GetContentHash(), second.GetContentHash())

	// Exercise the API's maximum page size with a first item that must remain reachable.
	for range 199 {
		save("Other", 0, "")
	}
	page, err := library.ListRuleVersions(ctx, connect.NewRequest(&labv1.ListRuleVersionsRequest{PageSize: 200}))
	require.NoError(t, err)
	require.Len(t, page.Msg.GetVersions(), 200)
	require.Equal(t, second.GetId(), page.Msg.GetNextBeforeId())
	next, err := library.ListRuleVersions(ctx, connect.NewRequest(&labv1.ListRuleVersionsRequest{PageSize: 200, BeforeId: page.Msg.GetNextBeforeId()}))
	require.NoError(t, err)
	require.Len(t, next.Msg.GetVersions(), 1)
	require.Equal(t, first.GetId(), next.Msg.GetVersions()[0].GetId())
	require.Zero(t, next.Msg.GetNextBeforeId())
	search, err := library.ListRuleVersions(ctx, connect.NewRequest(&labv1.ListRuleVersionsRequest{Query: "PERCENT %"}))
	require.NoError(t, err)
	require.Len(t, search.Msg.GetVersions(), 2)

	combined, err := library.ComposeRuleVersions(ctx, connect.NewRequest(&labv1.ComposeRuleVersionsRequest{
		Title: "Both", FirstId: first.GetId(), SecondId: second.GetId(), EntryMode: "and", ExitOwnerId: second.GetId(),
	}))
	require.NoError(t, err)
	version := combined.Msg.GetVersion()
	require.Equal(t, first.GetId(), version.GetParentId())
	require.Equal(t, second.GetId(), version.GetOtherParentId())
	loaded, err := library.GetRuleVersion(ctx, connect.NewRequest(&labv1.GetRuleVersionRequest{Id: version.GetId()}))
	require.NoError(t, err)
	require.Equal(t, version.GetContentHash(), loaded.Msg.GetVersion().GetContentHash())
	require.Contains(t, loaded.Msg.GetDefinitionJson(), `"op":"and"`)

	require.NoError(t, data.SeedInstruments(ctx, st.Queries))
	bars := waveBars(4_200)
	_, err = data.UpsertBars(ctx, st, "BTCUSDT", "archive", "t", bars)
	require.NoError(t, err)
	ds, _, err := data.CreateDataset(ctx, st, data.DatasetSpec{Symbol: "BTCUSDT", Timeframe: data.TF1m, From: bars[0].OpenTime, To: bars[len(bars)-1].CloseTime, GapPolicy: data.GapFlag})
	require.NoError(t, err)
	input := &labv1.ReportSpec{DatasetIds: []string{ds.ID}, Capital: usdtMoney("1000"), Folds: 3, RuleVersionId: version.GetId(), RuleContentHash: "wrong"}
	_, err = reports.CreateReport(ctx, connect.NewRequest(&labv1.CreateReportRequest{Spec: input}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))
	input.RuleContentHash = version.GetContentHash()
	created, err := reports.CreateReport(ctx, connect.NewRequest(&labv1.CreateReportRequest{Spec: input}))
	require.NoError(t, err)
	id := created.Msg.GetReportId()
	got, err := reports.GetReport(ctx, connect.NewRequest(&labv1.GetReportRequest{ReportId: id}))
	require.NoError(t, err)
	require.Equal(t, version.GetId(), got.Msg.GetReport().GetSpec().GetRuleVersionId())
	require.Equal(t, version.GetContentHash(), got.Msg.GetReport().GetSpec().GetRuleContentHash())
	reproduced, err := reports.Reproduce(ctx, connect.NewRequest(&labv1.ReproduceRequest{ReportId: id}))
	require.NoError(t, err)
	require.True(t, reproduced.Msg.GetIdentical())
}
