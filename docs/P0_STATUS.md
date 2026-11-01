# P0 — stabilization, first implementation batch

Status: **in progress**, 2026-11-01. This is the start of the new master plan, not
completion of P0 and not approval to begin P1 or any execution feature.

## Implemented scope

| Finding | Change | Regression evidence |
|---|---|---|
| F02 | buy-and-hold does not consume its first purchase during evaluation warm-up | `eval/TestBuyAndHoldSurvivesWarmup`: buys in both OOS and holdout |
| F03 | weighted atomic research admission using the existing x/sync dependency | jobs: concurrent exclusive jobs, cancellation, capacity bounds |
| F09 | stop/take markers use each fill's reference unit price | API test with quantities 3 and 2, multiple exits, other symbols, hidden bars |
| F11 | generation and cancellation on edit/reset/rate/report switch; mounted guards | Dart unit tests: out-of-order reply, pre-debounce invalidation, dispose |
| F14 | exact ppm/time/split comparison, with visible cost precision | eval tests for 1 ppm, intraday timestamp, holdout and evaluation version |
| F12 (implementation) | PostgreSQL GitHub workflow, pinned tools, mandatory DB and race, JSON evidence | local DB failure/skip subprocess tests, summary unit tests; hosted workflow not run |
| F10 (partial) | one data-owned picker cache, import invalidation, fetch pages past 200 | provider unit test selects version 201, imports, then reads version 202 |
| F13 (partial) | evaluation `p0.1`, cache schema 2, legacy annotation and comparison block | version-aware evaluation tests and DB test proving legacy reads do not mutate rows |
| F16 (partial) | README, PROGRESS, METRICS and UI_SPEC distinguish implementation from verification | this checkpoint and ADR-037/038 |

Changes reach the existing API clients/callers without changing proto wire contracts.
The report provider re-exports the shared dataset provider to preserve existing imports.
No database migration, new runtime dependency, widget test or real-order path is added.
Backend calculations remain authoritative; UI changes only govern presentation and requests.

## Executed verification

Local machine: Windows amd64, Intel Core i3-12100F, Go 1.26.4, Flutter 3.44.2 / Dart 3.12.2,
Python 3.12.10, local PostgreSQL. No remote service or deployment was changed.

| Check | Observed result |
|---|---|
| Initial focused regressions before fixes | failed for partial admission, cancelled acquisition, exact costs/window/split and buy-and-hold warm-up |
| Final `REQUIRE_DB=1 go test -count=1 -json ./...` | **146 passed tests/subtests, 0 failed, 0 skipped; 21 test packages passed** |
| Simulator golden tests | all 11 scenarios included in the Go run; expected files unchanged |
| Full existing `flutter test` suite plus new unit/provider tests | **48 passed** |
| After class-based calculator refactor | 20 relevant unit/provider/report/390 px cases passed |
| Dart analyze --fatal-infos | no issues |
| golangci-lint + go vet | no issues |
| buf lint/generate + sqlc generate | passed; no generated Go/SQL/proto Dart drift |
| Depguard planted bad import | rejected through depguard; temporary probe cleaned up |
| Python CI summary tests | 2 passed |
| Flutter Web release build | passed; existing CupertinoIcons font-family warning remains |
| 1M-bar benchmark, one iteration | 1.027 s, 503,084,664 allocated B/op; see PERFORMANCE.md |
| Local race run | **not executed successfully**: enabling cgo fails because gcc is absent |
| Hosted CI / race on Ubuntu | configured, **not run** in this session |
| Real-browser multi-width/focus/interop review | **not performed**; 390 px widget smoke is separate evidence |

Local JSON evidence is in `artifacts/go-tests.jsonl` (git-ignored). CI uploads the same
format on every attempted workflow run. Test/subtest counts include parent tests;
package successes are reported separately and skips never count as passes.

## UI/UX behavior

UI/UX Pro Max's design-system and Flutter searches informed this pass. Keep the existing
dark theme, semantic tokens, Persian typography, RTL form and LTR financial text.
The calculator now uses class-based field/rate/layout/result/status widgets, with the
responsive layout based on actual content constraints.

| State / action | User-visible behavior |
|---|---|
| Valid input / request pending | clear old figures, show a labeled progress bar |
| Invalid or incomplete input | inline validation and explanatory empty output; no stale result shown as fresh |
| New edit during a request | immediately cancel/invalidate the old call, then debounce the new input |
| Rate/report switch or reset | cancel the previous request and pending debounce before requesting a new result |
| Stale success or failure arrives | ignore it; only the latest generation may update the screen |
| RPC failure | show the existing error/retry control |
| Screen disposal | cancel timer and request; mounted/current-generation checks prevent setState after disposal |
| Dataset import, including partial success | invalidate shared picker and Data screen caches |
| Legacy report | visible server warning; persisted record and figures remain unchanged |

## Remaining P0 work / next batch

1. FIX-02: causal signal fills for zero/2-second/multi-bar delay and backfill; availability-safe
   History and resampling; intentional golden changes with a new evaluation version.
2. FIX-04: actual training/freeze timestamps, forward coverage, period vs cohort PnL.
3. FIX-05: fixed dataset membership/revisions, terminal candidates and claim/cancel recovery.
4. Finish F07 admission/memory bounds on Reproduce and forward, F08 non-USDT capability,
   F13 full provenance and exact canonical fills, F15 synchronized version/model lifecycle.
5. Finish F10 with search-backed paginated pickers. Current pickers fetch all pages into
   memory; a shortcut comment records the limit. Network supervision, accounting overflow,
   concurrent-ingest snapshot and remaining stress cases also remain open.
6. Run the hosted workflow (race), real-browser chart/async/focus checks and P0 UX gate.

The existing passing suite does **not** establish the new causal-fill, freeze, snapshot,
overflow or lifecycle acceptance criteria. Do not use this checkpoint as a P0 release pass.

## Rollback

Revert this batch's code to restore the prior UI/admission/evaluation behavior; there is
no destructive migration. New report JSON has one optional field and is readable by old
code. Do not delete or rewrite reports or attempts. Cache namespace changes prevent reuse
of older evaluations by the new engine; old reports must be recreated to use the corrected
buy-and-hold behavior. No commit or push was performed in this session.
