package api

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/clock"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
)

func TestHealthWatchStreams(t *testing.T) {
	t0 := time.Date(2026, 1, 2, 3, 4, 5, 0, time.UTC)
	mux := http.NewServeMux()
	mux.Handle(labv1connect.NewHealthServiceHandler(NewHealth(clock.NewVirtual(t0), "test", 8, 10*time.Millisecond)))
	srv := httptest.NewServer(mux)
	defer srv.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	// Connect protocol over HTTP/1.1, as the browser client uses.
	c := labv1connect.NewHealthServiceClient(srv.Client(), srv.URL)
	stream, err := c.Watch(ctx, connect.NewRequest(&labv1.WatchRequest{}))
	require.NoError(t, err)
	defer func() { _ = stream.Close() }()

	for i := range 3 {
		require.True(t, stream.Receive(), "message %d: %v", i, stream.Err())
		st := stream.Msg().GetStatus()
		require.Equal(t, labv1.RunMode_RUN_MODE_RESEARCH, st.GetMode())
		require.Equal(t, "USDT", st.GetAccountingAsset())
		require.EqualValues(t, 8, st.GetWorkers().GetCount())
		require.Equal(t, t0.UnixMilli(), st.GetServerTimeUnixMs())
		require.Nil(t, st.GetDisplayRate(), "no rate entered yet")
	}
}
