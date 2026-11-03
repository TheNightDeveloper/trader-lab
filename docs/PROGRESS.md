# Progress

Update at the end of every session.

## P0 F07 shared active-memory admission (2026-11-03)
- One process-owned budget now serves report Create/CreateWithID/Reproduce/Recalculate,
  queued search attempts and winner reports, learning collection-through-freeze/forward,
  and chart/decision handlers. Metadata preflight reserves before reconstructing datasets,
  including cached inputs; release spans persistence or handler projection where applicable.
- Reservations reject atomically without waiting while holding CPU slots/retained cycle
  data. Exhaustion returns ResourceExhausted for report/chart RPCs; search failures remain
  recorded, collection fails without moving the serving pair, and forward polls can retry.
- research_memory_mib defaults to 1024 (valid 16..65536). The conservative estimate includes
  raw reconstruction, concurrent working sets and retained results. Chart requests allow
  at most eight indicators. No truncation, migration, numerical or training version change.
- Verified: **319 Go tests/subtests, zero failed/skipped, 22 packages, DB mandatory**;
  **54 existing Flutter tests**, all 11 unchanged goldens, lint/vet, analyzer, engine build,
  planted depguard rejection and two Python CI-summary tests. Evidence:
  artifacts/p0-memory-go-tests.jsonl and artifacts/p0-memory-flutter.txt.
- F07/P0 remain open: estimates are not measured RSS/OS CPU quotas. Retained caches keep
  their separate caps; archive import/decompression and process-wide load acceptance need
  the next pass. Hosted CI/race and real-browser acceptance remain unverified.

## P0 F07 cooperative training cancellation and fit bounds (2026-11-03)
- Fit now requires context. Walk-forward propagates it through sample preparation, readiness
  checks, both scaler passes, standardization, ridge/logistic accumulation and training error.
  Long row passes check every 256 rows; logistic also checks between Newton iterations.
  Cancellation returns no partial artifact/model set. Existing feature APIs remain wrappers.
- Preflight rejects more than 1,000,000 samples/combined source bars or 12 walk-forward steps
  before materializing extra matrices/models. Rejection never truncates or scores a prefix.
- Learning reserves a conservative training-through-freeze deadline: registered slot-time
  budget / maximum research slots. It covers waiting/IO, walk evaluation and final fits too;
  final fitting and cancelled training now contribute to recorded usage. Exhaustion follows
  existing failed-cycle/candidate cleanup and never changes the serving version/model.
- Before-fix cancellation regression reproduced. Full DB-mandatory Go run: **311 passed,
  0 failed/skipped, 22 packages**; simulator goldens unchanged. Completed ridge/logistic fit
  IDs match the exact pre-change references; numerical/training versions remain unchanged.
- Existing Flutter suite: **54 passed**; Dart analysis, Go lint/vet and executable build
  passed. Evidence: artifacts/p0-training-go-tests.jsonl and p0-training-flutter.txt.
- F07 remains partial: process-wide byte admission/RSS and OS CPU guarantees are not proven.
  Cooperative checks do not interrupt allocation/GC or the small bounded Gonum factorization.
  Next: shared memory budgets, then remaining F10 and P0 accounting/network/label/UX gates.

## P0 F15 atomic version/model lifecycle (2026-11-03)
- F13 was committed as fe7d078 before this batch. Library moves, learning approval and
  rollback now share one algorithm lock, expected lifecycle revision and transaction for
  version/model changes, audit records and revision advancement. Stop clears the serving
  model; fixed-strategy switches cannot retain a learning model. Retired versions stay retired.
- Migration 00007 adds algorithm/promotion revisions and a unique active-version index.
  Version allocation uses the same lock. Reads of the serving pair use a coherent snapshot;
  activation checks the artifact hash, algorithm and version recipe before any state change.
- Learning captures the champion revision before training. Changed or legacy evidence cannot
  promote, but remains rejectable. Rollback also checks the promotion revision (including ABA)
  and targets the explicitly displayed algorithm rather than mutable global configuration.
- API mutations require an explicitly present expected_revision, including zero. Go/Dart
  bindings regenerated reproducibly (84 files checked). Flutter sends the confirmed token,
  refreshes stale decisions and keeps rejection enabled; no new widget tests or visual redesign.
- Verified: **302 Go tests/subtests, 0 failed/skipped; 22 packages, DB mandatory**; all 11
  simulator goldens unchanged; **54 Flutter tests** (2 new codec unit tests); analyzer, Go
  lint/vet and engine build passed. See P0_STATUS.md and ADR-052 for compatibility and limits.
- A combined Go/Flutter/build run had one search-recovery timeout. Isolated recovery passed
  in 1.67 s, then the complete Go-only run passed. No timeout/threshold was relaxed; the cause
  of the earlier timeout is unproven. Logs are retained in artifacts/p0-lifecycle-*.jsonl/txt.
- Next: remaining F07 process-wide budgets and fitting cancellation, then F10 and the P0
  accounting/network/label/UX gates. Race, hosted CI and real-browser acceptance remain open.

## P0 F13 report provenance and exact reproduction (2026-11-03)
- New reports record provenance v1: binary SHA-256, available VCS commit/time/dirty state,
  Go/platform, each dataset ID and manifest, used instrument filters/assets/scales, and
  evaluation/fill/accounting/research policy versions. Clients cannot supply this metadata.
- Reproduce checks exact JSON numbers, separate spec/split/summary records, and every ordered
  trade/fill/decision in main and holdout. Equal PnL no longer hides different fills. Both
  reproduction and P&L replay use recorded instrument filters. Timestamp identity follows
  PostgreSQL's stored UTC microsecond precision; transient simulator fields stay excluded.
- Reproduction is strict about execution context: another binary/release is not identical,
  even with matching financial totals. Comparison also blocks different execution contexts.
  Full context is available through the existing spec JSON export; existing badges explain
  missing provenance/build metadata or locally modified source. Historical rows stay unchanged.
- Verified: **282 Go tests/subtests, 0 failed/skipped, 22 packages, DB mandatory**; all
  **11 goldens unchanged**; **52 existing Flutter tests**; Dart analysis, Go lint/vet passed.
  Depguard rejected a planted optimizer import; both Python CI-summary tests passed.
  Engine build succeeded with VCS metadata (bb04d88 + dirty source) and a binary SHA-256.
- Evidence: artifacts/p0-provenance-go-tests.jsonl and artifacts/p0-provenance-flutter.txt.
  No migration, dependency, wire-contract, numerical version or new widget test was added.
- Next: F15 synchronized version/model lifecycle, then remaining F07/F10 and P0 gates.
  Race, hosted CI and browser acceptance remain open.

## Material UI migration error fixes (2026-11-02)
- Completed the in-progress material_ui import migration. Resolved 13 analyzer errors from
  ambiguous GlobalMaterialLocalizations and resulting const-list errors in app/test hosts.
- One shared constant delegate list supplies extracted Material/Cupertino localization types
  alongside original Flutter types required by dependencies. Persian/RTL remains configured.
- material_ui is constrained to ^1.9.0; minimum Dart 3.13 / Flutter 3.47 and CI Flutter 3.47.4
  match the installed package and IDE SDK at D:/flutter347. The older PATH SDK is incompatible.
- Verified: 52 existing Flutter tests, analyzer clean, offline enforced lockfile resolution,
  and release web build successful. Existing CupertinoIcons font warning remains; no new widget tests.
- Local logs: artifacts/material-ui-tests.txt and artifacts/material-ui-build.txt. No manual
  browser review or hosted CI run; this frontend fix does not close the remaining P0 gates.

## P0 F08 research capability restrictions (2026-11-02)
- One registry-based gate permits known USDT-quoted symbols only. Reports/replays,
  experiment planning, queued cache reuse and stored learning execution recheck permission.
  Unsupported stored evidence cannot authorize promotion; rejected work leaves active models untouched.
- GetOverview adds per-symbol research_capabilities (supported/reason). Go/Dart bindings
  regenerated reproducibly. Shared server-filtered pickers and learning symbol settings
  require affirmative permission; missing/failed responses and stale drafts cannot grant it.
- Data import/list/read, charts, saved figures and low-level FX/simulator fixtures remain
  available. No migration, financial version change or stored-result rewrite.
- UI/UX Pro Max informed inline explanations and loading/error states using existing RTL
  components. Four provider/codec unit tests added; no new widget tests.
- Verified: **251 Go tests/subtests, zero failed/skipped, 22 packages, DB mandatory**;
  11 unchanged goldens; **52 Flutter tests**; Go lint/vet, Dart analysis, proto lint and
  reproducible generation passed. Details and compatibility: P0_STATUS.md, ADR-049.
- A simultaneous SDK-constraint edit was preserved as >=3.12.2 with valid YAML syntax;
  Flutter tools and the full suite then passed. Unrelated IDE/analyzer edits are outside this bundle.
- Next: F13 full provenance and canonical-fill reproduction, then F15/F10. F07 global
  budgets, accounting/network/label and UX gates remain open; P0 is still in progress.

## P0 resource admission and input bounds (2026-11-02)
- Reviewed the clean checkpoint at de3e6a9; FIX-04/FIX-05 are already implemented.
- Reproduce now acquires the whole research share before loading a report; cancelled
  waiters preserve other jobs' slots and admitted errors release all acquired slots.
- Shared data preflight caps requested raw 1m ranges at 1,000,000 candles, including leading
  aggregation buckets. Live/legacy/snapshot SQL readers have a cap-plus-one limit and reject
  overflow; no truncated result is returned. Import rejects oversized ranges before download.
- Reports preflight the combined raw cost before loading; learning collection and forward
  check raw inputs as well as their own budgets. Collection holds a research slot and releases
  it before parallel training. Report/search caches retain at most 1,000,000 output bars each.
- Strategy periods are bounded to 1..1000 and non-finite parameters are rejected before use.
- Verified on Windows: **245 Go tests/subtests, 0 failed/skipped, 22 packages; DB mandatory**;
  11 unchanged goldens; Go lint/vet, depguard and reproducible sqlc generation. Existing
  Flutter suite: 48 passed; Dart analysis clean. Local evidence: P0_STATUS.md.
- F07 is partially complete: hard process-wide RAM/CPU deadlines and cancellation inside
  fitting remain open. Next is F08 execution capability restrictions, then F13/F15/F10.
- P0 remains open; this Windows run does not include race, hosted CI or browser acceptance.

## P0 FIX-05 (2026-11-02)
- Additive migration 00006 pins exact candle revisions in dataset_members and adds claim
  tokens. New dataset format 1 has a separate hash namespace covering raw/aggregate values
  and revision identities; old IDs/manifests/results remain unchanged. Evaluation stays p0.3.
- Snapshot selection/hash/member persistence is one repeatable-read transaction; late commits
  and aggregation-hidden corrections cannot alter an existing new-format version.
- Durable cancellation closes every unfinished attempt; token-fenced writes reject stale
  workers. A per-schema scheduler lease protects startup recovery; retries remain visible.
- Cycle finish/recovery atomically closes queued candidates and retains actual generation
  counts. Completed candidate results stay unchanged. See ADR-046/047.
- Verified locally: **237 Go tests/subtests with DB mandatory and race, 0 failed/skipped,
  22 packages**, 11 unchanged goldens, 48 Flutter tests, Dart MCP analysis, lint/vet and
  reproducible sqlc generation. Evidence and migration limits: P0_STATUS.md.
- Next: F07 Reproduce/raw-memory bounds and F08 capability restrictions; remaining F10,
  F13, F15, accounting/network/label and hosted/browser gates keep P0 open.

## P0 FIX-04 (2026-11-02)
- Evaluation p0.3 separates as-of period PnL from opening-cohort lifetime PnL, with causal
  fill-cost attribution, carried-position exposure and identical-window fold scoring.
- Final model completion, actual freeze and first tradable boundary are separate from the
  training cutoff. Forward requires a contiguous complete-data prefix for every symbol;
  elapsed time with missing data cannot produce a recommendation.
- Final fits and forward hold research slots; legacy learning evidence cannot promote.
- Verified locally: **212 Go tests/subtests, 0 failed/skipped, 22 packages, race enabled
  and DB mandatory**; 11 unchanged simulator goldens; go vet; 48 Flutter tests; Dart MCP
  analysis; 2 CI-summary tests; lint and planted bad-import depguard probe. Same-machine
  1M-bar allocation increases 4.1% for as-of marks; see PERFORMANCE.md. See P0_STATUS.md
  and ADR-044/045 for contracts and evidence.
- Next: FIX-05 snapshot membership, terminal candidates and claim/cancel recovery. Full P0,
  hosted CI, accounting/lifecycle gates and real-browser UX acceptance remain open.

## P0 analytics / learning review (2026-11-01)
- Rechecked feature readiness, fitting, prediction, search selection, fold attribution and
  forward gates. Detailed findings and priorities: [P0_LEARNING_REVIEW_FA.md](P0_LEARNING_REVIEW_FA.md).
- Fixed late feature dependencies entering past fits; enforce sample windows, dimensions and
  finite values; validate model artifacts before execution. New fits record causal-features/v1;
  valid legacy model IDs remain readable and immutable.
- Search requires every registered dataset exactly once, canonical metric scale, deterministic
  tie-breaking and overflow-safe mean. No promotion thresholds or golden fixtures changed.
- Unchanged-target prediction path: median 469.2 to 263.9 ns/op, 144 to 48 B/op across five
  local measurements per version. This is not whole-cycle speed or profitability evidence.
- Verified: 197 Go tests/subtests, zero skip, DB mandatory; all 11 goldens unchanged;
  48 existing Flutter tests; Go lint/vet, Dart analysis and depguard passed.
- Next remains FIX-04. The review additionally identifies close-to-close labels ending before
  or at causal execution for horizon=1, and cancellation/budget gaps inside training.
- P0 remains in progress. No local race or new real-market profitability evaluation.

## Table alignment fix (2026-11-01)
- Shared DataTableBox cells align to the same directional start edge as their headers;
  numeric/date/symbol text keeps its LTR reading direction inside RTL tables.
- Replaced the cell helper with a class-based widget. No new widget tests.
- Verified: Dart analysis clean, 32 existing table/page/responsive tests passed,
  including the 390 px route sweep. Real-browser visual review was not performed.

## P0 FIX-02 done (2026-11-01)
- Causal signal fills, observed-only History, availability-time equity and protection against
  delayed ranges acting on newer position state. Evaluation p0.2 records the fill model.
- Version-2 aggregation timestamps include all constituents and closure evidence; legacy
  dataset reconstruction/dedup stays readable. Golden outputs reviewed under ADR-039..041.
- Verified: 163 Go tests/subtests with DB mandatory, zero skip; 48 Flutter tests; lint/vet,
  Dart analysis and depguard passed. Race/hosted CI/browser review remain unverified.
- Next: FIX-04 actual freeze/forward coverage and period/cohort metrics. See P0_STATUS.md.

## Current phase
P0 — correctness and evidence stabilization: **in progress** (2026-11-03).
The new P0–P8 phases are defined in `Trading_Lab_Master_Plan_FA.md`; M0–M6 below
are historical implementation milestones, not evidence that the P0 release gate passed.

First P0 batch: atomic weighted research admission (F03), buy-and-hold warm-up (F02),
exact comparison assumptions (F14), stop/take chart unit prices (F09), cancellable P&L
requests (F11), shared dataset cache invalidation and retrieval beyond 200 (part of F10).
The first batch used evaluation `p0.1`, FIX-02 used `p0.2`, and current evaluations
use `p0.3` (FIX-04).
CI now has PostgreSQL, mandatory DB tests, race and retained pass/fail/skip evidence (F12);
the hosted workflow still needs its first run. See [P0_STATUS.md](P0_STATUS.md) for the
executed checks, remaining work, UX states and rollback notes.

FIX-02, FIX-04 and FIX-05 are implemented within their recorded scopes. F07 now includes
Reproduce admission and raw-input/retention caps; process-wide budgets remain open. F13 report
provenance/canonical reproduction and F08 capability restrictions are implemented in their
recorded scopes. F15 lifecycle locking/revision checks are implemented; next is remaining F07.
Server-side dataset search and remaining
P0 resource/accounting/network/label and stress/UX gates are still open.
**Do not start P1 yet.**

## M6 done (2026-10-28)
- ChartService: bars, engine-computed indicators (MA, EMA, BB, RSI, MACD), decision markers (entry, exit, rejected, stop/take), decision record; report charts end at the out-of-sample end.
- Chart screen: KLineChart draws engine values only (ADR-033); a report's own strategy lines added automatically; markers clickable and reachable with previous/next; layout saved per browser; reports link to their chart.
- Home screen: champion, retraining schedule, research queue, data health, last learning cycle, recent experiments, alerts. Placeholders removed.
- Performance: read latency test and `make bench`; numbers in docs/PERFORMANCE.md; dataset cache (ADR-034).
- Backup: nightly pg_dump in the engine, `cmd/verifydb`, `scripts/restore-drill.sh`; docs/BACKUP.md (ADR-035).
- Usability: every route checked at 390 px by a test; fixes for the chart's source picker, unset Money, empty Compare, Persian issue labels on Home, help text on every Learning settings field.

## Historical v1 release gate (M6; not the P0 gate)
| Condition | Evidence |
|---|---|
| All golden scenarios and leak tests pass | `sim/TestGolden` (11 scenarios), `model/train/TestFeaturesAndLabelsOnlySeeThePast`, `TestFittingOnAllHistoryIsCaught`, `strategy/TestFutureRowsDoNotChangePastDecisions`, `TestSavedModelReproducesPredictions` |
| A full learning cycle runs unattended end to end and records its decision | `loop/TestScheduledCycleRunsUnattendedAndRecordsItsDecision`: with the schedule on, the scheduler alone starts, freezes, forward-tests and decides; the gate and decision are stored |
| Every attempt, including failed ones, is visible in the UI | experiments: attempt registry with server-side status tabs incl. failed and cancelled (`app/test/experiments_test.dart`); learning: every cycle candidate with status, failure and why (`app/test/learning_test.dart`, `api/TestLearningService`) |
| No code path can send a real order | `release/TestNoCodePathCanSendARealOrder` (AST scan: GET only, no order/account endpoints, no order RPC) and `TestScanCatchesAnOrderCall` (the scan catches a planted order call); RunMode is research only |

Also: depguard probe passes (sim/eval/metrics never import search, loop or model/train); lint clean; all Go and Flutter tests pass.

## Verified (M6)
- Real report (trend-ema 12/26 on BTCUSDT 1h): the chart shows EMA 12/26 from the engine, the buy marker on the bar where EMA 12 crosses above EMA 26, and EMA 48 when toggled (headless Chrome against the engine).
- Restore drill on the live database (8.8 MB): first run failed on encoding (WIN1252 cluster), second run OK with every dataset re-hashed.
- Read latency on the reference machine: GetReport p95 27–59 ms, GetChart p95 65 ms with the cache.

## M5 done (2026-10-28)
- `feature`: seven window features, forward-return labels with ReadyAt, z-score scaler; fits reject anything not available at their as-of time.
- `model`: recipe format v1 (features, transform, ridge/logistic, horizon, entry, filter, exits), content-addressed artifacts, save/load, predict. `model/train`: ridge and logistic (gonum Cholesky), walk-forward training per step.
- `strategy`: recipe interpreter that only predicts (ADR-027). `eval.RunSplit` for prebuilt strategies.
- Library: `ridge-h4` and `logit-dir-h1` as learning algorithms; versions match on any existing content hash (a restart no longer re-adds a superseded built-in).
- `loop`: cycle state machine (collect → labels → generate → train → walk-forward → forward test → decision), bounded candidates recorded per cycle, budgets (CPU slot-minutes, bars, candidates), forward test on new bars, pre-registered gate, recommend/approve/reject/rollback, restart recovery, daily schedule.
- API: LearningService; Library shows recipes and the active model.
- UI: Learning screen (current cycle steps, champion vs challenger, gate checklist, approve/reject with confirms, all candidates, history, model registry with rollback, budgets, config dialog).
- Fixed on the way: `flutter run` called the dev server instead of the engine (debug builds now default to 127.0.0.1:8080).

## M5 acceptance
- Leak tests: future rows change no past sample, model or decision (`model/train/TestFeaturesAndLabelsOnlySeeThePast`, `strategy/TestFutureRowsDoNotChangePastDecisions`); a scaler or model fit on all history fails with look-ahead (`model/train/TestFittingOnAllHistoryIsCaught`).
- Saved models reproduce predictions within 1e−12, bit-identical in practice (`model/train/TestSavedModelReproducesPredictions`).
- A challenger that cannot clear the pre-registered improvement ends "not better" and the champion is unchanged (`loop/TestWorseChallengerAndInterruptionsLeaveTheChampion`).
- An interrupted training run, and a cycle cut off by a restart, end failed with the active version and model untouched (same test).
- Only the user promotes: a recommendation changes nothing until Approve (`loop/TestCycleRecommendsAndOnlyTheUserPromotes`); UI approval only when the engine allows it and after a confirm (`app/test/learning_test.dart`).

## Verified
- Synthetic 1m data with hourly momentum: walk-forward challenger `+ret_1` +40.3% vs champion −3.4%. With a 2-day forward window noise won (+0.46% vs +1.46%, "not better"), so the test uses 4 days — an honest example of why the forward test exists.
- Real database: a manual cycle on ridge-h4 skipped with "داده تازه ناکافی — 24 از 168 کندل لازم" (only live bars in the last 180 days; the archive is from 2024). Learning screen checked in headless Chrome against the running engine.

## M4 done (2026-10-27)
- `experiment`: pre-registered definitions (hypothesis and falsifier required), content id `exp_…`, locked on create; the same definition opens the existing experiment. Pause, resume, cancel.
- Attempt registry: one row per candidate × pair with status, failure, metrics, eligibility, violations, cache info; never deleted.
- `search`: grid and seeded random candidates, budgets (attempts, wall time), DB-backed scheduler (ADR-022) inside the research limiter (ADR-023), run cache keyed on every input (METRICS.md), selection with hard constraints first, winner report with origin and attempt count (ADR-025).
- Library: built-in algorithms as content-hashed versions with lifecycle states; only an explicit user action moves a version, one step at a time; activating stops the previously active version; every move is logged.
- API: ExperimentService (estimate, create, list, get, watch stream, attempts with server paging and status filter, pause/resume/cancel), LibraryService (algorithms, set state, lifecycle events).
- UI: Experiment Builder (six steps, three templates, goals, one dataset per pair, suggested parameter values, live run count and ETA, folded advanced options, local draft), Run Queue (list, live progress bar, budget cards, result with chosen candidate and report link, attempt table with server-side tabs, pause/cancel confirms), Library (family chips, cards, detail with recipe, versions, lifecycle moves with a note, history, lock note).
- Fixed on the way: shared choice chips stretched to the full row width (all screens); constraint violations now isolate `<= 0.25` LTR so RTL text does not mirror the operator.

## M4 acceptance
- Kill mid-search and restart: every attempt completes exactly once (`search/TestKillMidSearchResumesWithoutLossOrDuplicates`); cancel records every attempt (`TestCancelRecordsEveryAttempt`).
- A 500-attempt search on 100k bars never delays health beyond 1 s: worst observed 2–7 ms (`search/TestHealthStaysOnTimeDuringLargeSearch`).
- Cache reuse impossible when any input differs: `search/TestCacheKeyCoversEveryInput`; cached runs are marked per attempt.
- UI: `app/test/experiments_test.dart` (Builder sends the exact locked definition, draft restore, queue tabs filter server-side, cancel and lifecycle moves only after confirm).

## Verified on real data (M4)
- BTCUSDT 1h (4,368 bars), trend-ema@v1, fast {9, 12, 15} × slow {20, 26, 33}, 10 bps + 5 bps: 9 attempts finished within seconds. With max drawdown ≤ 25%: 8 eligible, winner fast=12 slow=26, +20.67% (the M3 report, reproduced). With ≤ 20%: 4 eligible, same winner. Queue, result and attempt table checked in headless Chrome against the running engine.

## M3 done (2026-10-27)
- `metrics`: exact P&L sums, return, drawdown and duration, exposure, trade stats, integer Sharpe; invalid metrics carry a Persian reason and no number; Persian labels and definitions.
- `eval`: splitter (expanding/rolling, embargo, holdout), continuous OOS run sliced into folds (ADR-017), hidden holdout run, stress, parameter neighbourhood, benchmarks, Persian summary/verdict/badges, comparison with assumptions first and a conclusion, replay.
- `report`: persistence (reports, trades, fills, decisions, holdout_views), logged holdout views, recalculation from stored decisions, reproduce, engine version and data-quality badges.
- API: ReportService (strategies, create, list, get with optional Toman, holdout, trades, decisions, compare, export CSV/JSON, reproduce), PnlService (recalculate, single trade).
- UI: Reports list + quick run form, Report, Compare, P&L calculator; EquityChart, Heatmap, WaterfallBars, MetricTile.

## M3 acceptance
- Report numbers equal the sum of trade-level numbers exactly: `eval/TestEvaluateIdentitiesAndIsolation`, `report/TestCreateLoadViewRecalculate` (stored trades), `api/TestReportAndPnlServices`.
- Calculator with default inputs reproduces the original net exactly: `eval/TestReplayReproducesNetExactly` (identical fills), report and API tests; seen live: +2,067.20 USDT both ways.
- Too few samples display as invalid, not a number: `metrics/TestFewSamplesAreInvalidNotNumbers`, `app/test/report_test.dart`.
- Changing the Toman rate never changes a USDT value or a stored report: `api/TestReportAndPnlServices` (two rates, proto equality without Toman fields, stored JSON unchanged).

## Verified on real data
- BTCUSDT 1h, 2024-01 → 2024-06 (4,368 bars), OOS 2024-01-30 → 2024-05-25, 10,000 USDT, 10 bps fee, 5 bps slippage:
  trend-ema 12/26 net +2,067.20 USDT (+20.67%, max DD −15.64%, 46 closed trades, Sharpe 1.49, break-even fee 29.4 bps) vs buy-and-hold +58.02%;
  mean-rev-bands 20/2 net −761.23 USDT. Evaluation time 0.4 s per report. Fee×2 stress equals a separate 20 bps report exactly (+995.63).
- Reviewing these reports by hand found three bugs, all fixed with tests: intent TTL on 1h bars (ADR-021), flat buy-and-hold benchmark, split defaults not stored.

## Still open
- Headless screenshots sometimes catch the sidebar mid-animation (faded entries); a real browser shows it settled. Check by hand if it bothers you.
- `-race` (needs gcc), `make` (not installed), Docker (not running; local PostgreSQL 18 is used), chart hover/resize manual check — as before.
- Reports created before the TTL/benchmark fixes keep their old numbers (immutable); Reproduce on them now reports a difference, as it should.

## Open questions
- Learning needs recent history: import recent months (Data screen) or lower the lookback/fresh-bar settings for ridge-h4 before the daily schedule is useful. Enable the schedule?
- Builder defaults: drawdown cap 25%, at least 10 closed trades, 500 attempts, 60 minutes. Adjust?
- Reference hardware: i3-12100F unless you prefer another.
- Default timeframes and pairs for the first experiments.
- Live data via REST polling (ADR-010): keep, or switch to WebSocket?
- JetBrains Mono shows zero with an inner dot; at small sizes it can be misread as 8 (I did, in a screenshot). Switch to the slashed-zero variant?
