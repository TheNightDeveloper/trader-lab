# Implementation Plan — Trading Research Lab (v1)

This plan turns the PRD (v1.2) and the agreed scope changes into milestones Claude Code can
execute one at a time. Read `CLAUDE.md` first; its invariants override anything here.

## 1. Scope of v1

**In v1:** versioned market data (Binance public archive + live closed bars), deterministic
event-driven simulator, evaluation with walk-forward and holdout, reports and comparison,
P&L calculator, experiments with bounded search, a self-learning loop (retraining,
challengers, forward test, human-approved promotion), chart with decision markers, and the
Flutter Web UI for all of the above.

**Decisions already made:**
- No Wallex. Historical data from the Binance public archive; live data from public
  WebSocket closed klines. No account or API key is needed in v1.
- Accounting currency USDT. Multiple pairs selectable; non-USDT pairs (e.g. ETHBTC) are
  valued in USDT via a cross rate available at that moment.
- Toman is display-only, via a dated `USDT/TOMAN` rate entered manually for now.
- Paper trading is replaced by a **forward test**: a frozen candidate runs in the same
  simulator on bars that arrived after it was frozen.
- UI is part of v1; the engine and algorithms are the priority.

**Not in v1 (Phase 2+):** paper accounts and order lifecycle, risk and behavior gates on
orders, journal, news/fundamentals/sentiment, AI assistant, ICT rules, shared-capital
portfolios, real execution. Keep the data model open for them (see §3.4) but build nothing.

## 2. How to work through this plan with Claude Code

- One milestone per working session. Start each session with:
  > Read CLAUDE.md, docs/IMPLEMENTATION_PLAN.md §<milestone>, and docs/PROGRESS.md.
  > Propose a task breakdown for this milestone before writing code.
- Use plan mode for the breakdown, then implement task by task.
- For each task, write the failing tests from the acceptance criteria first, then the code.
- Keep commits small: one task, or one coherent part of one, per commit.
- At the end of each session, update `docs/PROGRESS.md` and list open questions.
- Never start a milestone before the previous one's acceptance criteria pass, except where
  a task is marked **parallel**.

## 3. Architecture

### 3.1 Runtime

One Go binary (`engine`) runs on the user's computer and binds only to `127.0.0.1`:
- Connect API (HTTP/1.1 + JSON or binary) for the Flutter app, with server streaming for
  progress.
- Serves the built Flutter Web app as static files.
- Scheduler (learning cycles, live ingestion supervision).
- Worker pool with two priority classes: `control` (ingestion, scheduler, API) is never
  starved by `research` (backtests, training). The research share is capped by config.

PostgreSQL runs via docker compose. Remote access is out of scope; it requires auth and TLS
first.

### 3.2 Engine packages (`engine/internal/`)

| Package | Responsibility | May import |
|---|---|---|
| `money` | Fixed-point `Amount`, `Price`, `Qty`; rounding rules; per-asset scale | stdlib |
| `instrument` | Pair specs: base, quote, tick size, lot size, min notional, scales | money |
| `clock` | `Clock` interface; virtual clock for runs, wall clock for live | stdlib |
| `data` | Archive import, checksum verify, normalization, quality checks, dataset versions, live ingest | instrument, store, clock |
| `fx` | Cross-rate valuation to USDT; `USDT/TOMAN` display rates | money, data |
| `sim` | Event loop, order intents → fills, fee/slippage model, ledger, portfolio valuation | money, instrument, clock, fx, strategy |
| `strategy` | `Strategy` interface, rule strategies, recipe interpreter | feature, model/predict |
| `feature` | Feature and label generation with `AvailableAt`; fit-in-window transforms | data |
| `model` | `predict` (load + infer) and `train` (fit) sub-packages; artifact registry | feature |
| `metrics` | Metric definitions (see `docs/METRICS.md`), P&L breakdown, validity flags | money |
| `eval` | Walk-forward splitter, embargo, holdout tracking, run orchestration for one candidate | sim, metrics, strategy |
| `search` | Candidate generation (grid, seeded random, feature/filter combos), budgets, cache keys | eval, experiment |
| `experiment` | Experiment definitions, locking, content IDs, attempt registry | store |
| `loop` | Learning cycle state machine, forward test, promotion gate, scheduler hooks | search, eval, model/train |
| `jobs` | Priority queue, worker pool, pause/resume/cancel, progress events | stdlib |
| `store` | sqlc queries, migrations, transactions | pgx |
| `api` | Connect handlers; maps domain ↔ proto | everything above |

Dependency rule enforced by depguard: `sim`, `eval`, `metrics` must not import `search`,
`loop`, or `model/train`.

### 3.3 Core types (sketch)

```go
type Amount struct{ V int64; Asset string } // scale comes from the asset registry
type Bar struct {
    Instrument string
    OpenTime, CloseTime time.Time
    AvailableAt time.Time // when the engine could first have seen the closed bar
    O, H, L, C money.Price
    Volume money.Qty
    Flags QualityFlags
}
type Intent struct { // strategy output; never an exchange order
    Instrument string; Side Side; TargetExposure Fraction
    Reason string; DecisionAt time.Time; ValidUntil time.Time
    ModelID, RecipeVersion string
}
type Strategy interface {
    OnBar(ctx RunContext, b Bar) ([]Intent, error) // RunContext exposes only past data
}
```

### 3.4 Data model (PostgreSQL)

v1 tables: `instruments`, `candles` (partitioned by month), `datasets`,
`dataset_members`, `quality_issues`, `fx_rates`, `algorithms`, `algorithm_versions`,
`recipes`, `experiments`, `attempts`, `run_results`, `trades`, `decisions`, `reports`,
`model_artifacts`, `learning_cycles`, `cycle_candidates`, `promotions`, `holdout_views`,
`settings`.

Reserved for Phase 2 (no tables yet; keep IDs and enums compatible): accounts, orders,
fills (real), policies, journal entries, events/news.

### 3.5 API (proto services)

`DataService`, `FxService`, `LibraryService`, `ExperimentService` (create, lock, start,
pause, cancel, stream progress, list attempts with pagination), `ReportService` (get,
compare, export), `PnlService` (calculate for a run with overrides; calculate one trade),
`LearningService` (cycles, candidates, gate status, approve/reject, rollback),
`ChartService` (bars, engine-computed indicators, markers, decision detail),
`SettingsService`, `HealthService` (stream engine status for the sidebar).

Money in proto: `message Money { string units = 1; int32 scale = 2; string asset = 3; }`.

## 4. P&L and metric definitions (single source of truth)

The engine implements these in `metrics` and `sim`; `docs/METRICS.md` documents them; the
P&L calculator and reports both call the engine, so they always agree.

- **Fill price (spot, long only):** buy fills at `ref * (1 + slip)`, sell at
  `ref * (1 − slip)`; `ref` is the next bar's open after the decision (1-bar latency
  default). Slippage and fee rates are per side, in bps.
- **Fee:** `fee_rate × notional` charged on each leg in the quote asset, converted to USDT
  at the cross rate available at fill time.
- **Gross P&L of a trade:** `qty × (exit_ref − entry_ref)` (no costs).
- **Net P&L:** `exit_proceeds − entry_cost`, all costs included.
- **Cost breakdown:** `fees` and `slippage` reported separately; `gross − fees − slippage =
  net` must hold exactly in fixed-point (test this).
- **Position size:** fraction of current equity (compounding) by default; fixed USDT
  amount as an option.
- **Break-even sell price (one trade):** `entry × (1 + s) / ((1 − f)² × (1 − s))`.
- **Break-even fee (run):** per-side fee at which net P&L reaches zero, holding slippage
  and trades fixed.
- **Ambiguous bar** (both stop and target inside one bar): conservative by default (stop
  first), flagged in the report.
- **Drawdown:** from running peak of equity marked at bar closes.
- **Sharpe:** risk-free 0 unless configured; frequency and annualization factor stored
  with the report. Return `invalid` (not a number) when samples are below a minimum or
  the denominator is zero.
- **Toman display:** `usdt_value × rate(fx_rate_id)`, rounded to whole TOMAN, computed at
  render/export only.

## 5. Milestones

Each milestone pairs engine work with the UI screens that expose it. Screens follow the
design canvas.

### M0 — Foundations

Goal: a running skeleton both halves build on.

Tasks
1. Monorepo, Makefile, docker compose (PostgreSQL), goose migrations, sqlc config.
2. `golangci-lint` config with depguard rules from §3.2; CI script running lint, tests
   with `-race`, golden checks.
3. `proto/` with `buf` config; generate Go (connect-go) and Dart clients.
   **Spike:** confirm the Dart Connect client works in Flutter Web, including server
   streaming. If it does not, fall back to gRPC-web or OpenAPI + SSE and record the ADR.
4. `money` and `instrument` packages with property tests (addition, rounding, scale
   conversion, no overflow at realistic magnitudes including TOMAN display values).
5. `clock` package (virtual + wall).
6. Engine binary: config file, slog, `HealthService` stream, static file serving, bind to
   127.0.0.1 only.
7. Flutter app shell: theme tokens from the canvas, RTL, fonts, go_router with all
   routes, sidebar with status block fed by `HealthService`, placeholder screens.
8. **Spike (parallel):** KLineChart inside Flutter Web via `HtmlElementView` and
   `dart:js_interop`; show static candles with RTL page and LTR chart; verify resize and
   pointer events.

Acceptance
- `make run` serves the app; the sidebar shows live engine status.
- `money` property tests pass 10k cases; depguard fails a deliberate bad import.
- Both spikes have a short ADR with the decision.

### M1 — Market data

Goal: trustworthy, versioned candles with availability times.

Tasks
1. Instrument registry seeded for BTCUSDT, ETHUSDT, SOLUSDT, BNBUSDT, XRPUSDT, ETHBTC
   with tick/lot/min-notional.
2. Binance archive importer: download monthly/daily kline files, verify checksums,
   normalize to `Bar`, idempotent upsert, set `AvailableAt = CloseTime + ingest_delay`.
3. Resampling 1m → 15m/1h/4h/1d inside the engine (closed bars only).
4. Quality checks: gaps, out-of-order, zero/negative price, zero volume, duplicate, source
   correction. Store as `quality_issues`; gap policy per experiment (flag / stop /
   forward-fill-without-future).
5. Dataset versions: manifest of (instrument, timeframe, range, file checksums, policy) →
   content hash. Corrections create a new version; old ones stay readable.
6. Live ingestion of closed 1m klines over public WebSocket with reconnect, gap detection,
   and backfill from REST/archive. Outages become quality issues.
7. `fx`: cross-rate valuation (ETHBTC → USDT via BTCUSDT at the same `AvailableAt`).
   `fx_rates` table for `USDT/TOMAN` with date, rate, source, entered_at.
8. UI: **Data** screen (datasets, coverage, issues, import form, live status) and the FX
   section of **Settings**.

Acceptance
- Re-importing the same range creates no duplicates and the same dataset hash.
- A planted gap and a planted bad price are detected in tests.
- A query for bars "as of" time T never returns a bar with `AvailableAt > T`.
- An ETHBTC position is valued in USDT using only rates available at that time.

### M2 — Simulator and baseline strategies

Goal: a deterministic backtest whose ledger always reconciles.

Tasks
1. Event loop over bars in time order with a virtual clock; strategy receives a
   `RunContext` that exposes only past data.
2. Fill model per §4: next-bar-open reference, slippage, fees, min notional, lot rounding,
   insufficient balance rejection, spot-only rejection of shorts.
3. Ledger: balances per asset, reservations, fills, fees, realized/unrealized P&L in USDT.
   Invariant check after every event in debug builds.
4. Stop/target handling, including the ambiguous-bar policy.
5. Decision records: every intent (accepted or rejected) stored with reason, inputs
   snapshot reference, model/recipe IDs.
6. Baseline strategies: `trend-ema` (EMA fast/slow cross) and `mean-rev-bands`
   (Bollinger re-entry), plus `buy-and-hold` and `hold-cash` benchmarks.
7. Golden scenarios in `testdata/golden/`: no trades; one round trip with fees;
   partial-size rounding; ambiguous bar; gap during position; last bar incomplete;
   simultaneous signals on two pairs; ETHBTC valuation. Expected trades and ledger
   committed as files.
8. Benchmark: one strategy over 1M 1m bars; record time and memory in
   `docs/PROGRESS.md` as the baseline.

Acceptance
- Running any golden scenario twice gives byte-identical output; `make golden` passes.
- Property test: for random intent sequences, ledger totals always reconcile and
  `gross − fees − slippage = net` exactly.
- A strategy that tries to read a future bar fails a dedicated leak test.

### M3 — Evaluation, reports, comparison, P&L calculator

Goal: honest numbers a user can understand.

Tasks
1. `metrics` per `docs/METRICS.md`: returns, P&L breakdown, drawdown and duration,
   exposure, trade stats, Sharpe with stored assumptions, validity flags.
2. Walk-forward splitter: expanding or rolling train window, test window, step count,
   embargo equal to the label horizon, final holdout range.
3. Holdout guard: holdout results are hidden until explicitly requested; each view is
   logged in `holdout_views` and shown as a badge.
4. Report builder: plain-language summary sentence generated from the numbers (Persian
   templates), metric groups with definitions, fold table, stress scenarios (fee ×2,
   slippage ×3, +1 bar latency), parameter-neighbourhood stability.
5. Comparison: assumption diff (dataset, period, costs, capital, split, attempt count)
   shown before metrics; ineligible candidates marked.
6. `PnlService`: recompute a recorded run with overridden capital, sizing, fee, slippage
   (re-runs the simulator on the recorded intents); single-trade calculator; Toman via a
   chosen `fx_rate_id`.
7. Exports: trades and metrics CSV; experiment definition JSON.
8. UI: **Report**, **Compare**, **P&L calculator**, Toman display wherever money appears.

Acceptance
- Report numbers equal the sum of trade-level numbers exactly.
- The calculator with default inputs reproduces the original run's net P&L exactly.
- Metrics with too few samples display as invalid, never as a misleading number.
- Changing the Toman rate never changes any USDT value or a stored report.

### M4 — Experiments, search, queue

Goal: many runs, all tracked, none of them blocking the engine.

Tasks
1. Experiment definition: hypothesis, falsifying result, objective, hard constraints,
   pairs, timeframe, period, dataset version, algorithm + version, parameter space, costs,
   validation plan, seed, budgets. Locked on start; content ID.
2. Attempt registry: one row per candidate × pair, status
   (queued/running/done/failed/cancelled), failure reason, cache info.
3. `jobs`: priority queue, worker pool, research CPU cap, pause/resume/cancel, progress
   events streamed to the UI.
4. Search: grid and seeded random over the parameter space; budget limits (attempts,
   wall time); stop early only by pre-declared rules.
5. Caches: feature cache keyed by (dataset hash, feature fn, params); full-run reuse only
   when the content hash of every input matches.
6. Candidate selection: hard constraints first (violators are never "winners"), then the
   objective; "no eligible candidate" is a valid outcome; the attempt count travels with
   the chosen candidate.
7. Algorithm library: versions and lifecycle states (research, validation, forward test,
   active, stopped, retired); rule changes create versions.
8. UI: **Experiment builder** (6-step wizard with templates and folded advanced options),
   **Run queue** (progress, budget, server-paginated attempts with filters), **Library**.

Acceptance
- Killing the engine mid-search and restarting resumes without duplicate or lost attempts.
- A 500-attempt search never delays `HealthService` updates beyond 1 s.
- Reusing a cached result is impossible if any input (costs, split, policy) differs.

### M5 — Self-learning loop

Goal: the engine retrains and proposes better versions on its own, honestly.

Tasks
1. Feature and label pipeline: features with `AvailableAt`; labels with horizon and
   `ReadyAt`; nothing unready enters training.
2. Recipe format (YAML or JSON, versioned): features, transforms, model, filters, exits.
   Recipe interpreter as a `Strategy`.
3. Models in Go (gonum): ridge regression on forward returns; logistic regression on
   direction. Train / predict / save / load separated. Artifacts content-hashed with
   recipe version, dataset hash, window, seed, weights, transforms, metrics, parent.
4. Walk-forward that simulates retraining: at each step train on the past, predict the
   next window, update only with ready labels. Training once on all history is rejected.
5. Candidate generation: bounded combinations of allowed features and filters around the
   parent recipe; every candidate counted as an attempt.
6. Forward test: freeze candidate; evaluate on bars that arrived after the freeze, same
   simulator and costs, alongside the champion.
7. Promotion gate (configured before the cycle): hard constraints; minimum forward
   trades; minimum forward days; minimum improvement over champion in net return; maximum
   allowed drawdown degradation; walk-forward wins. Result: recommend or reject.
8. Cycle state machine and scheduler: collect → wait for labels → generate → train →
   walk-forward → forward test → decision. Skips with a recorded reason when fresh data is
   insufficient. Budgets for CPU, memory, candidates.
9. Promotion and rollback: user approval moves the active pointer; rollback restores the
   previous artifact; failures never touch the active version.
10. UI: **Learning** screen (current cycle, champion vs challenger, gate checklist with
    plain-language explanations, history, model registry, budgets).

Acceptance
- Leak tests: appending future rows to source data does not change past predictions;
  fitting a scaler on all history is caught.
- A saved model reproduces predictions on reference input within a stated tolerance.
- A cycle with a deliberately worse challenger ends in "not better", and the champion is
  unchanged.
- An interrupted training run leaves the active version untouched.

### M6 — Chart, hardening, release

Tasks
1. Chart: KLineChart wrapper with typed Dart API; bars and indicators from
   `ChartService` (engine-computed); entry/exit/rejected markers; clicking a marker opens
   the decision record; saved layout per user.
2. Indicator parity test: values shown on the chart equal engine values.
3. Home screen: engine status, last cycle summary, recent experiments, alerts.
4. Performance: reference hardware and dataset recorded; report-read API p95 < 1 s at 5
   concurrent requests; 1M-bar benchmark tracked.
5. Backup and restore drill (pg_dump nightly; restore tested once and documented).
6. Usability pass on every screen: one-sentence summary first, help text on every field,
   safe defaults, advanced options folded, next action on every result and empty state,
   signs and units on every number, works at 390 px.

Release gate (v1 done)
- All golden scenarios and leak tests pass.
- A full learning cycle runs unattended end to end and records its decision.
- Every attempt, including failed ones, is visible in the UI.
- No code path can send a real order.

## 6. Phase 2 outline (not now)

Paper accounts and order lifecycle → risk and behavior policy gate (cooldown after loss,
period loss lock, persistence across restarts) → journal → market context (news,
fear and greed, events, with availability times) → AI research assistant → real execution
behind its own acceptance gate.

## 7. Risks to watch during implementation

- **Leakage through convenience:** helpers that load "all bars" are the usual culprit.
  Make the as-of API the only API.
- **Silent float use in accounting:** add a linter rule or test that scans `sim` and
  `metrics` for `float64` in ledger types.
- **Search as multiple testing:** keep attempt counts visible everywhere a winner appears.
- **Flutter Web interop:** keep KLineChart behind one small adapter so it can be replaced.
- **Unattended loop drift:** budgets and pre-registered gates are configuration, versioned
  with each cycle; changing them mid-cycle is not allowed.
