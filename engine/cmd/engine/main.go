// Command engine runs the research engine: Connect API, static web app, scheduler and
// workers. It binds to loopback only.
package main

import (
	"context"
	"flag"
	"fmt"
	"log/slog"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"strings"
	"time"

	"github.com/labstack/echo/v5"
	"github.com/labstack/echo/v5/middleware"

	"tradinglab/engine/internal/api"
	"tradinglab/engine/internal/clock"
	"tradinglab/engine/internal/data"
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
	"tradinglab/engine/internal/store"
)

var version = "dev" // set with -ldflags "-X main.version=..."

func main() {
	if err := run(); err != nil {
		slog.Error("engine stopped", "err", err)
		os.Exit(1)
	}
}

func run() error {
	cfgPath := flag.String("config", "engine.json", "config file (JSON); missing file = defaults")
	flag.Parse()
	cfg, err := loadConfig(*cfgPath)
	if err != nil {
		return err
	}
	var level slog.Level
	if err := level.UnmarshalText([]byte(cfg.LogLevel)); err != nil {
		return fmt.Errorf("log_level: %w", err)
	}
	slog.SetDefault(slog.New(slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{Level: level})))

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	st, err := store.Open(ctx, cfg.DatabaseURL)
	if err != nil {
		return fmt.Errorf("database (%s): %w", redact(cfg.DatabaseURL), err)
	}
	defer st.Close()
	if err := data.SeedInstruments(ctx, st.Queries); err != nil {
		return err
	}

	var live *data.Live
	if len(cfg.LiveSymbols) > 0 {
		live = &data.Live{
			Store: st, HTTP: http.DefaultClient, BaseURL: data.LiveBaseURL, Clock: clock.Wall{},
			Delay: cfg.ingestDelay(), Symbols: cfg.LiveSymbols, Backfill: time.Hour,
		}
		go live.Run(ctx)
	}

	fxSvc := &api.Fx{Store: st, Clock: clock.Wall{}}
	health := &api.Health{Clock: clock.Wall{}, Version: version, Workers: int32(cfg.Workers), Every: time.Second, Live: liveSource(live), Rates: fxSvc}
	dataSvc := &api.Data{
		Store: st, Live: live, Clock: clock.Wall{},
		Importer: data.Importer{Store: st, HTTP: http.DefaultClient, BaseURL: data.ArchiveBaseURL, Delay: cfg.ingestDelay(), Clock: clock.Wall{}},
	}
	sc := echo.StartConfig{
		Address:         cfg.Listen,
		HideBanner:      true,
		HidePort:        true,
		GracefulTimeout: 5 * time.Second,
		ListenerAddrFunc: func(a net.Addr) {
			slog.Info("engine listening", "addr", "http://"+a.String(), "version", version, "web_dir", cfg.WebDir)
		},
		BeforeServeFunc: func(s *http.Server) error {
			s.ReadHeaderTimeout = 5 * time.Second
			return nil
		},
	}
	if err := sc.Start(ctx, newServer(cfg,
		route(labv1connect.NewHealthServiceHandler(health)),
		route(labv1connect.NewDataServiceHandler(dataSvc)),
		route(labv1connect.NewFxServiceHandler(fxSvc)),
	)); err != nil {
		return fmt.Errorf("serve: %w", err)
	}
	return nil
}

// apiRoute is a Connect service: its path prefix and handler.
type apiRoute struct {
	path string
	h    http.Handler
}

func route(path string, h http.Handler) apiRoute { return apiRoute{path, h} }

func newServer(cfg Config, routes ...apiRoute) *echo.Echo {
	e := echo.New()
	e.Use(middleware.Recover())
	// A dev server on another loopback port (flutter run) may call the API.
	// Non-loopback origins get no CORS headers, so browsers block them.
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		UnsafeAllowOriginFunc: func(_ *echo.Context, o string) (string, bool, error) {
			return o, isLoopbackOrigin(o), nil
		},
		AllowMethods:  []string{http.MethodGet, http.MethodPost, http.MethodOptions},
		AllowHeaders:  []string{"Content-Type", "Connect-Protocol-Version", "Connect-Timeout-Ms", "Connect-Content-Encoding", "Connect-Accept-Encoding"},
		ExposeHeaders: []string{"Connect-Content-Encoding", "Grpc-Status", "Grpc-Message"},
	}))

	for _, r := range routes {
		e.Any(r.path+"*", echo.WrapHandler(r.h))
	}

	if cfg.WebDir != "" {
		// HTML5 mode serves index.html for unknown paths so go_router routes deep-link.
		e.Use(middleware.StaticWithConfig(middleware.StaticConfig{Filesystem: os.DirFS(cfg.WebDir), HTML5: true}))
	}
	return e
}

func isLoopbackOrigin(o string) bool {
	u, err := url.Parse(o)
	if err != nil || u.Scheme != "http" {
		return false
	}
	h := u.Hostname()
	ip := net.ParseIP(h)
	return strings.EqualFold(h, "localhost") || ip != nil && ip.IsLoopback()
}

// redact hides the password in a database URL for logs and errors.
func redact(dsn string) string {
	u, err := url.Parse(dsn)
	if err != nil {
		return "(unparseable url)"
	}
	return u.Redacted()
}

// liveSource avoids handing Health a typed-nil *data.Live.
func liveSource(l *data.Live) api.LiveSource {
	if l == nil {
		return nil
	}
	return l
}
