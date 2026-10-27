package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"os"
	"time"
)

type Config struct {
	Listen   string `json:"listen"`    // must be a loopback address
	WebDir   string `json:"web_dir"`   // built Flutter app; empty disables static serving
	Workers  int    `json:"workers"`   // research worker count (pool arrives in M4)
	LogLevel string `json:"log_level"` // debug | info | warn | error

	DatabaseURL string `json:"database_url"`
	// IngestDelay is added to a bar's close to get AvailableAt (Go duration, e.g. "2s").
	IngestDelay string `json:"ingest_delay"`
	// LiveSymbols are kept current from the REST mirror; [] turns live data off.
	LiveSymbols []string `json:"live_symbols"`
}

func defaultConfig() Config {
	return Config{
		Listen: "127.0.0.1:8080", WebDir: "../app/build/web", Workers: 4, LogLevel: "info",
		DatabaseURL: "postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable",
		IngestDelay: "2s",
		LiveSymbols: []string{"BTCUSDT", "ETHUSDT", "SOLUSDT", "BNBUSDT", "XRPUSDT", "ETHBTC"},
	}
}

// loadConfig reads path over the defaults. A missing file means defaults.
func loadConfig(path string) (Config, error) {
	c := defaultConfig()
	b, err := os.ReadFile(path)
	switch {
	case errors.Is(err, os.ErrNotExist):
	case err != nil:
		return c, fmt.Errorf("read config: %w", err)
	default:
		if err := json.Unmarshal(b, &c); err != nil {
			return c, fmt.Errorf("parse config %s: %w", path, err)
		}
	}
	return c, c.validate()
}

func (c Config) validate() error {
	host, _, err := net.SplitHostPort(c.Listen)
	if err != nil {
		return fmt.Errorf("listen %q: %w", c.Listen, err)
	}
	// Remote access needs auth and TLS first (plan §3.1), so only loopback is allowed.
	if ip := net.ParseIP(host); ip == nil || !ip.IsLoopback() {
		return fmt.Errorf("listen %q: only loopback IPs are allowed (e.g. 127.0.0.1)", c.Listen)
	}
	if d, err := time.ParseDuration(c.IngestDelay); err != nil || d < 0 {
		return fmt.Errorf("ingest_delay %q: want a non-negative duration like \"2s\"", c.IngestDelay)
	}
	if c.Workers < 1 {
		return fmt.Errorf("workers must be >= 1, got %d", c.Workers)
	}
	return nil
}

func (c Config) ingestDelay() time.Duration {
	d, _ := time.ParseDuration(c.IngestDelay) // validated
	return d
}
