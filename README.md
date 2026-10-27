# Trading Research Lab

A personal research platform for crypto **spot** trading algorithms. A Go engine imports
market data, runs deterministic simulations and evaluates strategies. A Flutter Web UI
(Persian, RTL) shows the results. **No real orders exist in v1.** There is no account and
no API key.

> Status: milestones M0–M3 are done (data, simulator, evaluation, reports, comparison,
> P&L calculator). Experiments, search, the job queue and the learning loop (M4+) are not
> built yet. See [docs/PROGRESS.md](docs/PROGRESS.md).

## What works today

| Area | What you can do |
|---|---|
| Data | Import Binance public-archive candles, see coverage and quality issues, keep recent bars current from the live REST mirror |
| Reports | Run a strategy on a dataset with walk-forward folds and a hidden holdout, then read metrics, trades, decisions and stress tests |
| Compare | Put reports side by side; assumptions come first, then a conclusion |
| P&L calculator | Recalculate a stored report or a single trade under different fees or slippage |
| Chart | Candles with decision markers |
| Strategies | `hold-cash`, `buy-and-hold`, `trend-ema`, `mean-rev-bands` |

Screens named "Library", "Builder", "Queue" and "Learning" in the sidebar are placeholders
until M4.

## Layout

```
engine/     Go module: API, simulator, evaluation, reports, migrations
proto/      API contract (protobuf + Connect); source of Go and Dart types
app/        Flutter Web app
design/     Exported design screens and tokens
docs/       Plan, progress, decisions, metric definitions, UI spec
scripts/    CI and architecture checks
```

## Quick start

Needs Go, Flutter, and PostgreSQL 17+ (Docker or a local install). Full steps, Windows
notes and troubleshooting are in **[docs/START.md](docs/START.md)**.

```sh
make dev-db   # PostgreSQL in Docker (skip if you run your own)
make run      # builds the web app, then starts the engine
```

Open <http://127.0.0.1:8080>. The engine applies database migrations on start.

## Rules the code is built around

Determinism (same inputs give bit-identical results), no look-ahead, fixed-point money,
USDT as the only accounting currency (Toman is display-only), a judge that never imports the
optimizer, recorded attempts, immutable records, holdout discipline, human-only promotion,
and spot only. The full list is in [CLAUDE.md](CLAUDE.md).

## Documents

- [docs/START.md](docs/START.md): setup and first-use manual
- [docs/IMPLEMENTATION_PLAN.md](docs/IMPLEMENTATION_PLAN.md): scope, architecture, milestones
- [docs/PROGRESS.md](docs/PROGRESS.md): what is done, what is next, open questions
- [docs/METRICS.md](docs/METRICS.md): every metric and formula
- [docs/DECISIONS.md](docs/DECISIONS.md): design decisions (ADRs)
- [docs/UI_SPEC.md](docs/UI_SPEC.md): screens, widgets, routes

## Development

```sh
make gen     # buf + sqlc: regenerate Go and Dart code after editing proto/ or SQL
make test    # go test (race) + flutter test
make lint    # golangci-lint, depguard check, dart analyze
make golden  # golden scenarios; fails on any diff
make ci      # all of the above, plus a stale-generated-code check
```

Run `make lint test golden` before calling any task done.
