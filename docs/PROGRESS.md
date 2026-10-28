# Progress

Update at the end of every session.

## Current milestone
M5 — Self-learning loop: **done** (2026-10-28). Next: M6 — Chart, hardening, release.

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

## Next (M6)
- Chart screen with engine indicators and decision markers, hardening, release.

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

## Next (M5)
- Self-learning loop: scheduled retraining cycles, gates, recommendations; promotion stays a human action (Learning screen).

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
- `-race` (needs gcc), `make` (not installed), Docker (not running; local PostgreSQL 18 is used), chart hover/resize manual check — as before.
- Reports created before the TTL/benchmark fixes keep their old numbers (immutable); Reproduce on them now reports a difference, as it should.

## Open questions
- Learning needs recent history: import recent months (Data screen) or lower the lookback/fresh-bar settings for ridge-h4 before the daily schedule is useful. Enable the schedule?
- Builder defaults: drawdown cap 25%, at least 10 closed trades, 500 attempts, 60 minutes. Adjust?
- Reference hardware: i3-12100F unless you prefer another.
- Default timeframes and pairs for the first experiments.
- Live data via REST polling (ADR-010): keep, or switch to WebSocket?
- JetBrains Mono shows zero with an inner dot; at small sizes it can be misread as 8 (I did, in a screenshot). Switch to the slashed-zero variant?
