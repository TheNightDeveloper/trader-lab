# Progress

Update at the end of every session.

## Current milestone
M2 — Simulator and baseline strategies: **done** (2026-10-27). Next: M3 — Evaluation, reports, comparison, P&L calculator.

## M2 done (2026-10-27)
- `strategy`: Intent (target exposure, stop/take, reason, model/recipe IDs), past-only RunContext, registry with strict params; baselines hold-cash, buy-and-hold, trend-ema, mean-rev-bands; Scripted replay.
- `sim`: deterministic batch event loop on a virtual clock; fill model (next-bar open, slippage, fees, lot, min notional, free cash); exact ledger with invariants after every batch; stop/take with the ambiguous-bar policy; decision records with outcomes; USDT valuation incl. ETHBTC; optional starting holdings. Formulas in METRICS.md; ADR-014..016.
- Golden scenarios (engine/testdata/golden, 11): no-trades, round-trip-fees, partial-size-rounding, ambiguous-bar, gap-during-position, last-bar-incomplete, simultaneous-two-pairs, ethbtc-valuation, and the three baselines.
- Reviewing the ETHBTC golden by hand found a look-ahead: within one batch, a fill could be valued with another symbol's close from the same batch. Fixed with batch phases.

## M2 acceptance
- Golden scenarios byte-identical across two runs and equal to expected.json: `sim/TestGolden` (`make golden`).
- Ledger reconciles and gross − fees − slippage = net exactly for random intent sequences: `sim/TestLedgerReconcilesProperty` (1,000 runs: replay of fills, leg identities, independent equity).
- A strategy reading a future bar fails: `sim/TestStrategyCannotReadFutureBar`.
- Also: `sim/TestNoFloatInAccounting` (verified it catches a planted float64).

## Benchmark baseline (M2.8)
- Reference machine: Intel i3-12100F (4C/8T), Windows 10, Go 1.26.4.
- 1,000,000 1m bars, one symbol, trend-ema 12/26: **0.65 s per run, 503 MB allocated, 187k allocations**, 314 fills.
  Most allocation is the per-bar equity curve. Command: `go test ./internal/sim -run '^$' -bench MillionBars -benchtime 1x -benchmem`.

## M0 done (2026-10-27)
- money (128-bit MulDiv, property tests 10k cases), instrument, clock; proto + buf; engine on Echo v5 with HealthService stream; depguard + probe script; Makefile, CI script; Flutter shell (RTL, fonts, routes, animated sidebar, live status); Connect-web and KLineChart spikes (ADR-006/007).

## M1 done (2026-10-27)
- Instrument registry: BTC/ETH/SOL/BNB/XRP-USDT and ETHBTC from exchangeInfo filters, all at scale 8 (ADR-013); seeded on engine start.
- PostgreSQL store: migrations embedded and applied on start; month-partitioned `candles` with revisions (ADR-012); `quality_issues`, `import_files`, `datasets`, `fx_rates`. sqlc for all queries. `storetest` gives each test its own schema.
- Archive importer: monthly files with daily fallback, SHA-256 verified, ms and µs timestamps, idempotent upsert, gap check across files.
- Resampling 1m → 15m/1h/4h/1d in the engine; closed buckets only.
- Quality checks and gap policies flag / stop / ffill (rules table in METRICS.md).
- Dataset versions: content hash of spec + bars; known_at pinned; reload re-verifies.
- Live ingestion over the REST mirror (ADR-010) with backfill and outage issues; live availability = receive time (ADR-011).
- fx: as-of USDT valuation (ETHBTC via BTCUSDT), Toman display conversion.
- API: DataService (overview, datasets, coverage segments, issues, streamed Import), FxService; Health shows live state and display rate.
- UI: Data screen and Settings FX section; shared AsyncSection / DataTableBox / StatCard / LabChoiceChips.

## M1 acceptance
- Re-import same range → no duplicates, same dataset hash: `data/TestImportIdempotentSameDatasetHash`, `api/TestDataImportStreamAndViews`, and checked on real BTCUSDT + ETHBTC 2024-01 archive files.
- Planted gap and bad price detected: `data/TestCleanDetectsPlantedProblems`.
- As-of query never returns AvailableAt > T: `data/TestBarsNeverAfterAsOf` (property test over 1m/15m/1h with late bars).
- ETHBTC valued in USDT with rates available at the time: `fx/TestETHBTCValuedWithRatesAvailableAtTheTime`.

## Verified
- `go test ./...` (7 packages; DB tests against local PostgreSQL 18), `golangci-lint` 0 issues, depguard probe, `buf lint`, `dart analyze --fatal-infos`, `flutter test` (15 tests incl. 390 px).
- Real end to end: engine + built app in headless Chrome; live feed from data-api.binance.vision (6 symbols, 6–8 s lag); archive import of 2024-01.

## Still open from M0
- `-race`: needs cgo/gcc (not installed). Tests run without `-race`.
- `make`: not installed on Windows; targets run by hand.
- Database: using the local PostgreSQL 18 service (`lab`/`lab` on 127.0.0.1:5432) instead of docker compose; Docker Desktop is installed but not running. The local server listens on 0.0.0.0:5432 (not loopback only).
- Chart hover and live resize: manual check in a real browser.

## Next (M3)
- metrics per METRICS.md (returns, drawdown, exposure, trade stats, Sharpe with validity), walk-forward splitter with embargo and holdout, holdout guard, report builder with Persian summary, comparison, PnlService (re-run recorded intents via Scripted), exports, and the Report / Compare / P&L calculator screens.
- Persist runs: run_results, trades, decisions (ADR-016).

## Open questions
- Reference hardware for benchmarks: using the i3-12100F above unless you prefer another.
- Default timeframes and pairs for the first experiments.
- Sidebar at 1440×900 does not fit all items plus the status block; the nav list scrolls.
- `/queue` and `/reports` list routes were added (UI_SPEC only lists the `:id` versions).
- Live data uses REST polling, not WebSocket (ADR-010). OK, or switch?
- Coverage view scans all candles per request (per-day grouping); materialize if it gets slow with years of 1m data.
