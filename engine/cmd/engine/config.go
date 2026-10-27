package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"os"
)

type Config struct {
	Listen   string `json:"listen"`    // must be a loopback address
	WebDir   string `json:"web_dir"`   // built Flutter app; empty disables static serving
	Workers  int    `json:"workers"`   // research worker count (pool arrives in M4)
	LogLevel string `json:"log_level"` // debug | info | warn | error
}

func defaultConfig() Config {
	return Config{Listen: "127.0.0.1:8080", WebDir: "../app/build/web", Workers: 4, LogLevel: "info"}
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
	if c.Workers < 1 {
		return fmt.Errorf("workers must be >= 1, got %d", c.Workers)
	}
	return nil
}
