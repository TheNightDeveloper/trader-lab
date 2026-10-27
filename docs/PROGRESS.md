# Progress

Update at the end of every session.

## Current milestone
M3 — Evaluation, reports, comparison, P&L calculator: **done** (2026-10-27). Next: M4 — Experiments, search, queue.

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

## Next (M4)
- Experiment definitions (locked, content-addressed), attempt registry, job queue with research CPU cap and progress streaming, seeded grid/random search with budgets, caches keyed by content hashes, candidate selection with hard constraints, algorithm library; Builder, Queue and Library screens. CreateReport moves onto the queue (ADR-020).

## Open questions
- Reference hardware: i3-12100F unless you prefer another.
- Default timeframes and pairs for the first experiments.
- Live data via REST polling (ADR-010): keep, or switch to WebSocket?
- JetBrains Mono shows zero with an inner dot; at small sizes it can be misread as 8 (I did, in a screenshot). Switch to the slashed-zero variant?
