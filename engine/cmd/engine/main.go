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
	"tradinglab/engine/internal/gen/lab/v1/labv1connect"
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

	health := api.NewHealth(clock.Wall{}, version, cfg.Workers, time.Second)
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
	if err := sc.Start(ctx, newServer(cfg, health)); err != nil {
		return fmt.Errorf("serve: %w", err)
	}
	return nil
}

func newServer(cfg Config, health labv1connect.HealthServiceHandler) *echo.Echo {
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

	path, h := labv1connect.NewHealthServiceHandler(health)
	e.Any(path+"*", echo.WrapHandler(h))

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
