package main

import (
	"context"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/stretchr/testify/require"

	"tradinglab/engine/internal/api"
	"tradinglab/engine/internal/clock"
	labv1 "tradinglab/engine/internal/gen/lab/v1"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
)

func TestConfigLoopbackOnly(t *testing.T) {
	for _, tc := range []struct {
		listen string
		ok     bool
	}{
		{"127.0.0.1:8080", true},
		{"[::1]:8080", true},
		{"0.0.0.0:8080", false},
		{":8080", false},
		{"192.168.1.5:8080", false},
		{"localhost:8080", false}, // a name could resolve elsewhere; require an IP
		{"bad", false},
	} {
		c := defaultConfig()
		c.Listen = tc.listen
		err := c.validate()
		if tc.ok {
			require.NoError(t, err, tc.listen)
		} else {
			require.Error(t, err, tc.listen)
		}
	}
}

func TestLoadConfigMissingFileUsesDefaults(t *testing.T) {
	c, err := loadConfig(filepath.Join(t.TempDir(), "none.json"))
	require.NoError(t, err)
	require.Equal(t, defaultConfig(), c)
}

// testServer runs the real Echo stack over a temp web dir.
func testServer(t *testing.T) *httptest.Server {
	root := t.TempDir()
	require.NoError(t, os.WriteFile(filepath.Join(root, "secret.txt"), []byte("SECRET"), 0o644))
	dir := filepath.Join(root, "web")
	require.NoError(t, os.Mkdir(dir, 0o755))
	require.NoError(t, os.WriteFile(filepath.Join(dir, "index.html"), []byte("INDEX"), 0o644))
	require.NoError(t, os.WriteFile(filepath.Join(dir, "main.dart.js"), []byte("JS"), 0o644))
	cfg := defaultConfig()
	cfg.WebDir = dir
	srv := httptest.NewServer(newServer(cfg, api.NewHealth(clock.Wall{}, "test", 2, 10*time.Millisecond, nil)))
	t.Cleanup(srv.Close)
	return srv
}

func TestHealthStreamThroughEcho(t *testing.T) {
	srv := testServer(t)
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	stream, err := labv1connect.NewHealthServiceClient(srv.Client(), srv.URL).Watch(ctx, connect.NewRequest(&labv1.WatchRequest{}))
	require.NoError(t, err)
	defer func() { _ = stream.Close() }()
	for range 3 { // several messages proves Echo flushes each one
		require.True(t, stream.Receive(), "%v", stream.Err())
		require.Equal(t, "USDT", stream.Msg().GetStatus().GetAccountingAsset())
	}
}

func TestLoopbackCORS(t *testing.T) {
	srv := testServer(t)
	for origin, allowed := range map[string]bool{
		"http://localhost:5000":  true,
		"http://127.0.0.1:61234": true,
		"http://evil.example":    false,
		"https://localhost:5000": false,
		"null":                   false,
	} {
		r, err := http.NewRequest(http.MethodOptions, srv.URL+"/lab.v1.HealthService/Watch", nil)
		require.NoError(t, err)
		r.Header.Set("Origin", origin)
		r.Header.Set("Access-Control-Request-Method", http.MethodPost)
		resp, err := srv.Client().Do(r)
		require.NoError(t, err)
		_ = resp.Body.Close()
		got := resp.Header.Get("Access-Control-Allow-Origin")
		if allowed {
			require.Equal(t, origin, got)
		} else {
			require.Empty(t, got, origin)
		}
	}
}

func TestStaticHTML5Fallback(t *testing.T) {
	srv := testServer(t)
	get := func(path string) string {
		resp, err := srv.Client().Get(srv.URL + path)
		require.NoError(t, err)
		defer func() { _ = resp.Body.Close() }()
		b, err := io.ReadAll(resp.Body)
		require.NoError(t, err)
		return string(b)
	}
	require.Equal(t, "INDEX", get("/"))
	require.Equal(t, "JS", get("/main.dart.js"))
	require.Equal(t, "INDEX", get("/reports/42"))
	for _, p := range []string{"/../secret.txt", "/..%2fsecret.txt", "/%2e%2e/secret.txt"} {
		require.NotContains(t, get(p), "SECRET", "traversal %s escaped the web dir", p)
	}
}
