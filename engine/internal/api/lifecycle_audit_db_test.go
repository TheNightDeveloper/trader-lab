package api

import (
	"net/http"
	"testing"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/proto"

	"tradinglab/engine/internal/experiment"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/store/db"
	"tradinglab/engine/internal/store/storetest"
)

func TestLifecycleAuditUsesScopedCursor(t *testing.T) {
	st := storetest.Open(t)
	ctx := t.Context()
	require.NoError(t, experiment.SeedLibrary(ctx, st))
	const version = "trend-ema@v1"
	insert := func(versionID, note string) {
		t.Helper()
		require.NoError(t, st.InsertLifecycleEvent(ctx, db.InsertLifecycleEventParams{
			VersionID: versionID, FromState: "research", ToState: "validation", Note: note, Actor: "user",
		}))
	}
	for _, note := range []string{"one", "two", "three", "four"} {
		insert(version, note)
	}
	insert("buy-and-hold@v1", "other version")
	srv := serve(t, func(mux *http.ServeMux) { mux.Handle(labv1connect.NewLibraryServiceHandler(&Library{Store: st})) })
	client := labv1connect.NewLibraryServiceClient(srv.Client(), srv.URL)
	list := func(m *labv1.ListLifecycleEventsRequest) *labv1.ListLifecycleEventsResponse {
		t.Helper()
		res, err := client.ListLifecycleEvents(ctx, connect.NewRequest(m))
		require.NoError(t, err)
		return res.Msg
	}
	legacy := list(&labv1.ListLifecycleEventsRequest{VersionId: version})
	require.GreaterOrEqual(t, len(legacy.GetEvents()), 4)
	require.Nil(t, legacy.GetNextCursor())

	first := list(&labv1.ListLifecycleEventsRequest{VersionId: version, PageSize: 2})
	require.Len(t, first.GetEvents(), 2)
	require.Equal(t, "four", first.GetEvents()[0].GetNote())
	require.Equal(t, "three", first.GetEvents()[1].GetNote())
	cursor := first.GetNextCursor()
	require.Equal(t, version, cursor.GetStrategyVersionId())
	require.True(t, proto.Equal(cursor, first.GetEvents()[1].GetAudit().GetCursor()))
	require.Equal(t, labv1.AuditActor_AUDIT_ACTOR_USER, first.GetEvents()[0].GetAudit().GetActor())
	require.Equal(t, first.GetEvents()[0].GetAtUnixMs(), first.GetEvents()[0].GetAudit().GetRecordedAtUnixMs())

	// An insert between reads must not shift the already seen rows into the next page.
	insert(version, "five")
	next := list(&labv1.ListLifecycleEventsRequest{VersionId: version, PageSize: 200, Before: cursor})
	require.Len(t, next.GetEvents(), len(legacy.GetEvents())-2)
	require.Equal(t, "two", next.GetEvents()[0].GetNote())
	require.Nil(t, next.GetNextCursor())
	for _, event := range next.GetEvents() {
		require.Less(t, event.GetAudit().GetCursor().GetSequence(), cursor.GetSequence())
	}

	_, err := client.ListLifecycleEvents(ctx, connect.NewRequest(&labv1.ListLifecycleEventsRequest{
		VersionId: "buy-and-hold@v1", PageSize: 2, Before: cursor,
	}))
	require.Equal(t, connect.CodeInvalidArgument, connect.CodeOf(err))
}
