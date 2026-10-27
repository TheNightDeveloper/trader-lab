# Start manual

How to install, run and use Trading Research Lab on one computer. The engine only listens
on `127.0.0.1`; it refuses any other address.

## 1. Prerequisites

| Tool | Needed for | Notes |
|---|---|---|
| Go 1.26+ | engine | `go version` |
| Flutter (Dart 3.12+) | web app | `flutter doctor`; enable web with `flutter config --enable-web` |
| PostgreSQL 17+ | all data | Docker (below) or a local install |
| Docker | optional DB | only for `make dev-db` |
| `make` | shortcuts | optional on Windows; each step has a plain command |
| gcc | `-race` tests | optional on Windows; run `make test RACE=` without it |
| `buf`, `sqlc`, `goose`, `golangci-lint` | development only | not needed to run the app; generated code is committed |

An internet connection is needed to import candles (Binance public archive) and for live
bars.

## 2. Start the database

**Docker**

```sh
make dev-db
# or: docker compose up -d --wait db
```

This starts PostgreSQL on `127.0.0.1:5432` with user `lab`, password `lab`, database `lab`.
Data persists in the `pgdata` volume.

**Your own PostgreSQL**: create a database and user, then point the engine at it (section 4).

## 3. Run

```sh
make run
```

This is the same as:

```sh
cd app && flutter build web --release --no-web-resources-cdn
cd ../engine && go run ./cmd/engine
```

Wait for the log line `engine listening addr=http://127.0.0.1:8080`, then open
<http://127.0.0.1:8080>. Stop with Ctrl+C.

On start the engine applies all pending migrations, seeds the instrument list, and (unless
turned off) starts pulling live bars.

**Working on the UI**: build once with `make web`, start the engine, then in another
terminal run `cd app && flutter run -d chrome`. The engine allows CORS from loopback
origins only.

## 4. Configuration

The engine reads `engine.json` from its working directory (`engine/engine.json` if you use
`make run`). A missing file means defaults. The file is git-ignored. Or pass
`-config path/to/file.json`.

```json
{
  "listen": "127.0.0.1:8080",
  "web_dir": "../app/build/web",
  "workers": 4,
  "log_level": "info",
  "database_url": "postgres://lab:lab@127.0.0.1:5432/lab?sslmode=disable",
  "ingest_delay": "2s",
  "live_symbols": ["BTCUSDT", "ETHUSDT", "SOLUSDT", "BNBUSDT", "XRPUSDT", "ETHBTC"]
}
```

| Key | Meaning |
|---|---|
| `listen` | Must be a loopback IP and port |
| `web_dir` | Built web app; empty string turns off static serving |
| `workers` | Research worker count (the pool arrives in M4) |
| `log_level` | `debug`, `info`, `warn`, `error` |
| `database_url` | PostgreSQL connection string |
| `ingest_delay` | Added to a bar's close time to get when it became available |
| `live_symbols` | Pairs kept current from the REST mirror; `[]` turns live data off |

## 5. First use

The sidebar and all text are in Persian. Screen names below are the sidebar labels.

1. **Import data (داده).** Choose symbols, a date range (UTC, `YYYY-MM-DD`), a timeframe
   (`1m`, `15m`, `1h`, `4h`, `1d`) and a gap policy (`flag`, `stop` or `ffill`). Start the
   import and watch the progress. Each import creates a content-addressed dataset. The
   same inputs give the same dataset. Check the coverage timeline and quality issues
   before trusting it.
2. **Run a report (گزارش‌ها).** Pick a strategy and dataset, set capital, fee and slippage
   (in basis points), number of folds and holdout share. Defaults are 10,000 USDT, 10 bps
   fee, 5 bps slippage, 4 folds, 20% holdout. Strategy parameters can be edited. Creating
   a report takes about a second for a few months of hourly bars.
3. **Read the report.** Numbers are USDT. A metric with too few samples shows as invalid
   with a reason, not as a number. The report includes the benchmark (buy-and-hold),
   stress tests, parameter neighbourhood, trades and decisions. Opening the final holdout
   result is logged, so look at it once you have decided what to test.
4. **Compare (مقایسه).** Select reports to compare. Assumptions are shown first. Reports
   built on different data or costs say so before any conclusion.
5. **P&L calculator (ماشین‌حساب سود و زیان).** Recalculate a stored report or a single trade
   with other fees or slippage. With the original inputs it reproduces the original net
   exactly.
6. **Chart (نمودار).** Candles with decision markers.
7. **Settings (تنظیمات).** Enter the `USDT/TOMAN` rate by hand. Toman is for display only.
   Changing the rate never changes a USDT value or a stored report.

Reports are immutable. If a fix changes how numbers are computed, old reports keep their
old numbers, and "Reproduce" on them reports the difference.

## 6. Tests and checks

```sh
make test      # engine (race) and app tests
make lint      # linters and the import-rule check
make golden    # golden scenarios
```

Database tests need the running PostgreSQL from section 2.

**Without `make` (Windows)**

```sh
cd engine && go test ./...
cd app && flutter test
cd app && dart analyze --fatal-infos
cd engine && go test -run Golden ./...
```

## 7. Troubleshooting

| Symptom | Fix |
|---|---|
| `database (...)`: connection refused | PostgreSQL is not running or `database_url` is wrong. Run `make dev-db`, or check your service |
| `listen "...": only loopback IPs are allowed` | Set `listen` to `127.0.0.1:<port>`. Remote access is out of scope for v1 |
| Port 8080 already in use | Change `listen` in `engine.json` |
| Blank page or 404 at `/` | The web app is not built. Run `make web`, and check `web_dir` points at `app/build/web` |
| Live status shows off or stale | `live_symbols` is empty, or the network is down. The status block in the sidebar shows the state |
| `-race requires cgo` | Install gcc, or run `make test RACE=` |
| `make: command not found` | Use the plain commands in sections 3 and 6 |
| Generated code stale (CI) | Run `make gen` (needs `buf` and `sqlc`) and commit the result |

## 8. Reset

To wipe all data and start clean (this deletes every dataset and report):

```sh
docker compose down -v
```
