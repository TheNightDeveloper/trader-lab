# Decisions (ADR log)

Short records: context, decision, consequences. Newest at the bottom.

## ADR-001 Market data source
Decision: no Wallex. Binance public archive for history, public WebSocket closed klines for live data. No account or keys in v1.
Consequence: real execution (Phase 2+) needs a separate venue decision; account restrictions for the user's region are a product risk.

## ADR-002 Accounting currency
Decision: USDT for all accounting, risk and comparison. Non-USDT pairs valued via cross rates available at the time.
Consequence: labels and reports say USDT, not USD.

## ADR-003 Toman display
Decision: display-only conversion using a dated USDT/TOMAN rate, entered manually in v1. Unit name TOMAN (1 TOMAN = 10 IRR). Reports store the rate ID they used.
Consequence: rates never affect research results; automating the source later only changes the `source` field.

## ADR-004 v1 scope
Decision: engine + self-learning loop + UI. Paper trading replaced by forward tests in the same simulator. Orders, risk/behavior gates, journal and market context move to Phase 2.

## ADR-005 Stack
Decision: Go engine (single binary, localhost only), PostgreSQL, protobuf + Connect API, Flutter Web (RTL, desktop-first), KLineChart via HtmlElementView.
Open: Dart Connect client and KLineChart interop to be confirmed by M0 spikes.

## ADR-006 API transport: Connect over HTTP/1.1 (M0 spike)
Context: the Flutter Web client needs server streaming (HealthService.Watch, later run progress).
Decision: keep Connect. `connectrpc` 2.0.1 for Dart with the fetch transport (`package:connectrpc/web.dart`), `protoc_plugin` 25 + `protoc-gen-connect-dart` run locally through buf. Verified in Chrome: the built app served by the engine shows live HealthService stream values in the sidebar. No gRPC-web or OpenAPI/SSE fallback is needed.
Consequence: stream messages are wrapped in `<Rpc>Response` (buf STANDARD lint). The Dart client reconnects forever with capped backoff (Riverpod's default retry gives up after 10 tries).

## ADR-007 Candle chart: KLineChart 10 via HtmlElementView (M0 spike)
Decision: KLineChart 10.1.0 vendored in `app/web/vendor/` (no CDN), wrapped by one adapter, `CandleChart` (`core/widgets/candle_chart*.dart`, `dart:js_interop` + `package:web`). Bars cross the adapter as `Decimal` and become JS numbers only for drawing.
Findings: (1) `<html dir="rtl">` breaks Flutter's platform-view positioning; RTL is set only inside Flutter. (2) The element is created detached, so the chart is created on the first ResizeObserver callback with real width; later callbacks call `resize()`. Verified with headless Chrome: the chart fills its card, LTR inside the RTL page, with token colors.
Open: hover/crosshair and live window resize still need a manual check in a real browser (headless screenshots can't drive the pointer).

## ADR-008 HTTP server: Echo v5
Decision: user's choice. Echo v5.4.2 hosts the Connect handlers (`echo.WrapHandler`), serves the built app with Static middleware in HTML5 mode (deep links → index.html; `os.DirFS(web_dir)`), and CORS only for loopback origins (for `flutter run`). Echo's Response supports Flush, so Connect streaming works through it (tested).
Consequence: one more dependency in the engine; the loopback-only bind is still enforced by config validation.

## ADR-009 Frontend motion and responsive layout
Decision: user's request for a smooth, polished UI. Packages: `flutter_animate` (entrances, status pulse), `flutter_staggered_animations` (sidebar list), `animations` (fade-through page transitions), `skeletonizer` (loading skeletons per UI_SPEC), `responsive_framework` (MOBILE <600, TABLET 600–1199, DESKTOP ≥1200 from UI_SPEC §4).
Rules: durations come from `AppMotion` in tokens; `AppMotion.of(context, d)` returns zero when the OS asks for reduced motion. Motion never carries meaning on its own.

## ADR-010 Live data over REST polling, not WebSocket
Context: plan M1.6 says WebSocket; Go's stdlib has no WebSocket client and api.binance.com answers 451 from this network. The public mirror data-api.binance.vision works through the local proxy.
Decision: poll /api/v3/klines on the mirror ~2 s after every minute close; closed bars only; page through backfills; resume from the last stored bar after failures. No new dependency.
Consequence: 6–8 s steady latency (fine for 1m research). Switching to the kline WebSocket stream is a contained change in `data.Live` if sub-second latency is ever needed (would add `coder/websocket`).

## ADR-011 Availability of live and backfilled bars
Decision: a live bar's AvailableAt is when the engine actually received it, never earlier than close + ingest_delay. Bars backfilled after an outage are therefore late, and as-of reads during the outage do not see them. Outages are stored as `outage` quality issues.
Consequence: backtests over live-ingested periods reflect what the live system really knew. Archive re-imports of the same bars with identical values do not change their stored AvailableAt (no new revision).

## ADR-012 Bitemporal candles and content-addressed datasets
Decision: candle rows are never updated. A source correction inserts revision+1. Reads filter by AvailableAt (as-of, virtual time) and ingested_at (known-at, knowledge time). A dataset version pins known_at and its id is the SHA-256 of spec + bars; loading re-verifies the hash. known_at comes from the database clock, the same clock that stamps ingested_at.
Consequence: old versions stay readable after corrections; re-importing identical data gives the same id.

## ADR-013 Fixed scale 8 for prices and quantities
Decision: every price, quantity and coin amount is stored at scale 8 (Binance's precision for all v1 pairs); tick and lot sizes are expressed at the same scale. TOMAN display rates use scale 2.
Consequence: archive values are exact; USDT amounts cap near 92e9 per value (int64), far above research needs.

## ADR-014 Exact leg arithmetic, rounding against the trader
Decision: every leg is integer math at scale 8 with fixed rounding directions (costs and fees up, proceeds down). Gross is the difference of rounded leg ref values; slippage and fees are sums of rounded leg values; net is cash out minus cash in. The identity net = gross − slippage − fees is algebraic, not approximate.
Consequence: gross can differ by a unit from `qty × (exit − entry)` computed in one step; METRICS.md defines gross the way the ledger computes it.

## ADR-015 Simultaneous signals settle in symbol order from free cash
Context: plan M2.3 mentions reservations. With one goroutine and batch phases, fills at the same instant already happen in a fixed order (symbol), and each buy can only spend free cash (balance minus coins backing positions).
Decision: no reservation system; deterministic sequential settlement. A BTCUSDT position's BTC never funds ETHBTC; trading ETHBTC needs free BTC (e.g. `Config.Holdings`).
Consequence: earlier symbols get priority when cash is short; visible in the golden `simultaneous-two-pairs`.

## ADR-016 Decision records live in the run result until runs are persisted
Decision: every intent and its outcome (filled, rejected, expired, superseded, no_change, unfilled) with the input bar reference and model/recipe IDs is part of `sim.Result`. The `decisions` table is written together with run results when reports and the attempt registry arrive (M3/M4).
Consequence: M2 has no DB writes; the golden files are the record of decisions for now.

## ADR-017 Walk-forward as one continuous run, sliced into folds
Context: separate per-fold runs restart from flat with fresh capital, so folds do not add up to the report and positions are cut at artificial boundaries.
Decision: one continuous out-of-sample run (warm-up gated), folds are windows of it; the holdout is its own run. In M5 the retrained model of each step feeds intents into the same continuous run.
Consequence: report = Σ folds = Σ trades exactly; fold "train" windows matter only once models train (M5).

## ADR-018 Integer statistics, including Sharpe
Decision: no float anywhere in metrics; Sharpe uses math/big with integer square roots (10⁶ extra precision) and is truncated at 2 decimals. The no-float guard covers sim, money and metrics.
Consequence: identical digits on every platform; Sharpe can differ from a float implementation in the last digit (documented test against a float reference).

## ADR-019 Break-even exit follows the engine fee model
Decision: break-even exit = entry × (1 + s)(1 + f) / ((1 − s)(1 − f)), not the plan formula with (1 − f)², because the engine charges the buy fee on top in the quote asset rather than from the bought coins.
Consequence: the calculator and the simulator agree; METRICS.md records the difference.

## ADR-020 Reports are synchronous until the job queue exists
Decision: CreateReport evaluates inside the request (main, holdout, 3 stress, ≤9 neighbourhood cells, 2 benchmarks run in parallel; 0.4 s for 6 months of 1h bars). M4 moves this onto the research queue with progress events and attempt records.
Consequence: very large 1m datasets can make the request slow in M3; no attempt registry yet.

## ADR-021 Intent TTL scales with the timeframe
Decision: an unset TTL is (latency + 9) bars of the input timeframe (10 minutes on 1m bars, as before). A fixed 10 minutes expired every intent in the +1 latency stress on 1h bars.
Consequence: golden scenarios unchanged; stored specs keep 0 = automatic, so reproduction is deterministic.

## ADR-022 The research queue lives in PostgreSQL
Context: a search must survive an engine kill without losing or repeating attempts.
Decision: attempts are rows; the scheduler claims them with `FOR UPDATE SKIP LOCKED`, marks done/failed in the same transaction as the result, and re-queues `running` rows on start. No in-memory queue or message broker.
Consequence: kill/resume is exact (`search/TestKillMidSearchResumesWithoutLossOrDuplicates`); throughput is bounded by DB round trips (fine at thousands of attempts, not millions).

## ADR-023 One limiter for all research work
Decision: `jobs.Limiter` holds the research share of CPUs (default 75%, always leaving one core). Search attempts take one slot each; a quick report (CreateReport) takes all slots; a P&L recalculation takes one. Health, data ingestion and the API never take a slot.
Consequence: a quick report waits for running attempts; a 500-attempt search delays health updates by under 10 ms (`search/TestHealthStaysOnTimeDuringLargeSearch`). Supersedes the "synchronous" part of ADR-020 only in that reports now share the cap.

## ADR-024 The display rate is cached in memory
Context: the health stream read the latest FX rate from the DB every tick; under full research load that took up to 1.2 s.
Decision: `api.Fx` keeps the latest display rate in memory, loaded once and invalidated by AddRate.
Consequence: health ticks do no DB work; a rate added directly in SQL shows after restart only.

## ADR-025 Attempts run a light evaluation; only the winner gets a full report
Decision: each attempt runs the continuous OOS evaluation only (no holdout, stress, neighbourhood or benchmarks). After selection the winner, and only the winner, is evaluated fully and stored as a report with a deterministic id.
Consequence: searches are fast and never peek at the holdout; the holdout of the chosen candidate is still behind the logged "show" action.

## ADR-026 Builder maps goals onto objective + constraints
Decision: the Builder offers three goals instead of raw metric pickers: highest return with a drawdown cap (total_return ↑, max_drawdown ≤ cap), smallest drawdown with a return floor (max_drawdown ↓, total_return ≥ floor), best Sharpe with a drawdown cap. Every goal adds `closed_trades ≥ N` (default 10). The caps live under "advanced".
Consequence: fewer choices for the user; the engine definition stays general, so M5 or a later "custom" goal can use any metric.

## ADR-027 Training happens outside the judge; strategies only predict
Decision: `model/train` fits one model per walk-forward step before a run; the recipe strategy receives the schedule of models and uses, for each bar, the latest model whose as-of is not after the bar's open. eval gains `RunSplit` for a prebuilt strategy and never trains.
Consequence: invariant 5 holds (depguard probe for model/train passes); "train once on all history" cannot be expressed, because a step that trains past its serve time is rejected.

## ADR-028 Features are windows of the past, shared by training and prediction
Decision: every feature is a function of the bars up to and including the current one (bounded lookback), used both to build training rows and to predict in the simulator. RSI uses simple averages (not Wilder) to stay window-bounded.
Consequence: appending future bars cannot change a past feature or prediction (`strategy/TestFutureRowsDoNotChangePastDecisions`); feature cost is O(lookback) per bar.

## ADR-029 Only frozen models are stored
Decision: model_artifacts holds the challenger and baseline frozen at each cycle (content-addressed). Per-fold models are deterministic from recipe, dataset and steps, so they are recomputed rather than stored.
Consequence: the registry stays small; reproducing a cycle's walk-forward means retraining (seconds).

## ADR-030 The forward test runs in real time on bars after the freeze
Decision: a cycle freezes its challenger at the end of its data and waits (state `forward_test`, durable across restarts) until the configured number of days of new bars has arrived; the scheduler re-evaluates both contenders every tick and decides when complete. Forward data used in a decision marks `consumed_until`; later cycles may train on it but their test windows start after it.
Consequence: a recommendation takes at least the forward length (default 14 days); one open cycle per algorithm, so a waiting recommendation blocks the next scheduled cycle (it is not recorded as skipped).

## ADR-031 Promotion jumps straight to active, as a user decision
Decision: approving a recommendation records the challenger's recipe as a version in state active (or re-activates an existing version with the same recipe), stops the previous active version and points the algorithm's active model at the challenger's frozen model, all in one transaction with lifecycle events by "user" and a promotions row. Rollback restores the pair the last promotion replaced, only if it is still active.
Consequence: the library's one-step-at-a-time rule applies to manual moves; a learning promotion has passed walk-forward, forward test and the gate instead. Failed, interrupted or restarted cycles never touch the active pair (`loop/TestWorseChallengerAndInterruptionsLeaveTheChampion`).

## ADR-032 Learning algorithms are not searched in experiments
Decision: experiments reject algorithm versions with a recipe; the Builder hides them. Their candidates come from the cycle's bounded variants instead.
Consequence: no grid search over recipes yet; parameter search stays for rule strategies.

## ADR-033 The chart draws engine values through custom indicators
Decision: KLineChart's built-in indicators are not used. For each engine indicator the adapter registers a template whose `calc` returns the engine's values per bar (looked up by timestamp) and computes nothing; markers are custom overlays with click handlers. Chart indicators come from `strategy.ComputeIndicator`, which reuses the strategies' EMA and Bollinger code.
Consequence: what the chart shows is what the strategy traded on (parity test); KLineChart stays replaceable behind `CandleChart`.

## ADR-034 Recent dataset versions are cached in memory
Context: GetChart and GetDecision reloaded and re-hashed a whole dataset per call; under load GetChart's p95 reached 1.26 s.
Decision: the report service keeps the 4 most recently used dataset versions after one verified load. Versions are content-addressed and immutable, so the cache cannot be stale; callers share the bars read-only (checked: nothing writes into input bars).
Consequence: GetChart p95 65 ms, GetReport 59 ms under the same load; up to 4 datasets of memory (about 70 MB for four 100k-bar datasets, ~176 bytes per bar).

## ADR-035 The engine takes the nightly backup; restores are manual and verified
Decision: the engine runs `pg_dump` once a day (written aside, renamed when complete, newest 14 kept). Restoring is a documented manual step followed by `cmd/verifydb`, which re-hashes datasets and model artifacts. The drill restores into a throwaway UTF8 cluster started as the current OS user.
Consequence: backups need no external scheduler; `pg_dump` must be on PATH. The drill never needs privileges on the real server. Its first run found that a default Windows cluster (WIN1252) cannot hold the Persian text; restore targets must be UTF8 (docs/BACKUP.md).

## ADR-036 Release checks are tests
Decision: the release gate's cross-cutting promises are tests that run with the suite: an AST scan proves every outbound request is a GET and no code or RPC names an order or account endpoint (with a planted-probe test that the scan is live); a scheduled learning cycle runs to its decision with no manual call; every route renders at 390 px.
Consequence: a change that adds an order path, breaks unattended learning or overflows a phone layout fails `make test`.
