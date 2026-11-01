# P0 — stabilization, first implementation batch

Status: **in progress**, 2026-11-01. This is the start of the new master plan, not
completion of P0 and not approval to begin P1 or any execution feature.

## First batch scope

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

## First batch verification

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

## FIX-02 completed (2026-11-01)

The toolchain execution restriction recorded below is resolved. This second batch implements
F01 and the late-data checks in master-plan section 3.1. Full P0 is still **in progress**.

- Signal fills require both target-index latency and OpenTime >= decision AvailableAt, within
  TTL. New report specifications record evaluation `p0.2` and fill model `causal-next-open/v1`.
- History returns exactly the observed bars in chronological order, without leaking unavailable
  prefix members or slice capacity. Ordered streams keep the original allocation-free prefix.
- Backfills cannot rewind the latest known price, equity timestamp, or protection state.
- New resampling includes all constituent availability and later-bar closure evidence.
  Manifest version 2 records the rule; legacy manifests reconstruct their original hashes,
  and dedup preserves the first-creation manifest. No schema migration or rewrite is needed.
- Reports from any older evaluation version, including p0.1, show the legacy badge.
- Golden outputs changed intentionally under ADR-039/041; all 11 scenario fill counts remain
  unchanged, purpose checks pass, and exact money identities were independently audited.

Executed on the current source:

| Check | Result |
|---|---|
| Pre-fix regressions | reproduced pre-decision fills, unavailable History members, stale valuation, early resampling |
| `REQUIRE_DB=1 go test -count=1 -json ./...` | **163 passed tests/subtests, 0 failed, 0 skipped; 21 test packages passed** |
| Golden scenarios | all 11 pass, each deterministic across two runs; no CSV input changes |
| Legacy dataset complete/partial and dedup | stored versions remain readable with exact hashes; unknown versions rejected |
| Independent golden audit | every signal fill is causal and every trade satisfies gross - fees - slippage = net |
| Existing Flutter suite | **48 passed**; no new widget tests |
| Go lint/vet, Dart analyze, depguard positive/negative probe | passed |
| Generated contract diff | no Go/SQL/Dart wire-contract changes |
| 1M-bar benchmark | 0.624 s, 503,164,136 allocated B/op; see PERFORMANCE.md |

Evidence: local `artifacts/p0-causal-tests.jsonl` and `artifacts/p0-golden-audit.json`
(git-ignored). Current checks do not include race, hosted CI, or a real-browser visual review.
Old dataset versions retain their historical aggregation semantics; recreate/import versions
for corrected availability. Current computations can differ from saved legacy results, which
remain immutable. No live execution or real-market validation is claimed.

## Remaining P0 work / next batch

The analytics/learning review after FIX-02 fixed dependency readiness, fit/model validation,
complete/deterministic search selection and unnecessary per-bar explanation work. New model
artifacts record `causal-features/v1`; evaluation remains `p0.2`. Verified: 197 Go tests/subtests,
zero skip with DB mandatory, 48 existing Flutter tests, lint/vet, Dart analysis and depguard. See
[P0_LEARNING_REVIEW_FA.md](P0_LEARNING_REVIEW_FA.md) for evidence, measured scope and compatibility.
This additional batch does not complete FIX-04 or P0.

1. FIX-04: actual training/freeze timestamps, forward coverage, period vs cohort PnL.
2. FIX-05: fixed dataset membership/revisions, terminal candidates and claim/cancel recovery.
3. Finish F07 admission/memory bounds on Reproduce and forward, F08 non-USDT capability,
   F13 full provenance and exact canonical fills, F15 synchronized version/model lifecycle.
4. Finish F10 with search-backed paginated pickers. Current pickers fetch all pages into
   memory; a shortcut comment records the limit. Network supervision, accounting overflow,
   concurrent-ingest snapshot and remaining stress cases also remain open.
5. Run the hosted workflow (race), real-browser chart/async/focus checks and P0 UX gate.

The existing passing suite does **not** establish the pending freeze/coverage, period/cohort,
snapshot, overflow or concurrent-lifecycle acceptance criteria. Do not use this checkpoint as a P0 release pass.

## Rollback / compatibility

There is no destructive migration. Preserve all reports, attempts and dataset records;
no history is rewritten. The first batch and table alignment were committed as `2d998d5`.
New report JSON fields are optional to older readers, but old binaries do not implement
version-2 resampling: they may fail a new dataset's hash check if its availability changed.
Keep this engine version available when retaining new version-2 datasets; do not rewrite
hashes or manifests to force an older binary to accept them. Older dataset versions remain
readable by this engine using legacy reconstruction. No push is performed by this work.

## Historical toolchain blocker (2026-11-01; resolved for FIX-02 above)

The first implementation batch and shared table-alignment fix are committed as
`2d998d5` (`fix(p0): stabilize research admission, evaluation and UI state`).
The pre-existing, untracked `graphify-out/` artifacts remain outside the commit.

FIX-02 callers, simulator tests, resampling and immutable dataset loading were inspected.
Before any new source edit, Windows refused to launch `go.exe`, `gofmt.exe` and
`python.exe` with "This program is blocked by group policy". Consequently no new
regression file, production change or golden update was applied, and no new test
execution is claimed. The working tree was verified to contain only the pre-existing
graph artifacts before this documentation update.

Resume FIX-02 after those tools are permitted to execute. Resampling changes must retain
legacy dataset reconstruction by manifest version so existing content hashes remain
readable; causal fill changes need evaluation versioning and reviewed golden outputs.
