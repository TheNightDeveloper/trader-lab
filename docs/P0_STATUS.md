# P0 — stabilization and release evidence

Status: **in progress**, 2026-11-05. This continues the new master plan, not
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

## FIX-04 implemented and locally verified (2026-11-02)

F04/F05 now use evaluation **p0.3**, under ADR-044/045. No report, dataset, model or
golden history was rewritten; no proto wire contract or database migration changed.

- `net_pnl`/`period_pnl` are as-of equity changes, with observed fill fees/slippage in
  the same period. Carried positions contribute to period PnL and exposure. Separate
  `cohort_lifetime_pnl` explicitly includes later exits; it never determines fold wins.
- Unrealized PnL and closed-trade statistics use evidence available at the period end.
  New aggregates detect overflow. This does not close all accounting-overflow work.
- Fold wins require valid period metrics and exactly matching test windows.
- Cycle records distinguish `training_cutoff`, `model_created_at`, `freeze_at` and
  `trade_start`. Final models serve from actual completion; freeze follows persistence.
- Forward days require contiguous complete, real data for every symbol. A missing minute,
  missing symbol, synthetic/partial or unavailable candle keeps the gate pending. The end
  remains fixed on late ticks. Final training and forward acquire a research slot; forward
  checks its projected resampled-bar budget before reading.
- Legacy cycles remain readable; older forward cycles fail closed, and older recommendations
  can be rejected but cannot promote. Run a fresh cycle for current evidence.

Local machine: macOS arm64, Go 1.26.5; isolated PostgreSQL 17.11 on loopback port 55432.
PostgreSQL was installed for this verification; no startup service or deployment was enabled.

| Check | Observed result |
|---|---|
| `REQUIRE_DB=1 go test -count=1 -race -json ./...` | **212 passed tests/subtests, 0 failed, 0 skipped; 22 test packages passed** |
| As-of future exits, carried positions, delayed costs, overflow | regression tests pass |
| Clock advances during final fits | model completion/freeze after cutoff; trade-start at/after freeze |
| Missing minute in forward DB data | gate stays pending despite elapsed days; restoring it completes the same fixed interval |
| Legacy forward/recommendation | fail closed; rejection still works |
| Simulator goldens | all 11 pass unchanged, including byte determinism |
| Go vet / CI evidence-summary tests | passed; summary tests: 2 |
| golangci-lint v2.15.0 / planted bad-import depguard probe | 0 issues; forbidden optimizer import rejected and temporary probe removed |
| Dart analysis via Dart MCP | no errors |
| Existing Flutter suite | **48 passed** after removing proxy variables for that test process; initial proxied run failed to connect to local tester WebSockets |
| 1M-bar benchmark, one iteration per source on Apple M4 | 0.350 s, 523,867,256 allocated B/op; 4.1% allocation increase over same-machine HEAD; see PERFORMANCE.md |

Evidence: `artifacts/p0-fix04-go-tests.jsonl` (git-ignored). Race ran locally on this
source; hosted CI and the real-browser UX gate remain unexecuted. Synthetic fixtures
establish the regression contracts, not market profitability or a P0 release pass.

## FIX-05 implemented and locally verified (2026-11-02)

Migration **00006** adds exact raw revision membership (`dataset_members`) and attempt
claim tokens. New dataset manifests use **format_version 1** with a separate snapshot
hash namespace; evaluation stays **p0.3**. SQL bindings were generated with sqlc v1.31.1;
no proto/Dart wire contract or new runtime dependency changed.

- New snapshots select raw revisions, aggregate, hash and store membership/manifest in
  one repeatable-read transaction. Loading follows pinned revisions, verifies raw member
  and output counts and re-hashes values/identities. Late commits cannot add members.
- Even a raw correction hidden by aggregation creates a new version. Availability and
  closure corrections are revisioned; archive reimports cannot backdate observed availability.
  Revision allocation is serialized per symbol, initial month creation across symbols.
- Format-0 datasets retain their exact IDs, manifests and cutoff reconstruction. Their
  historical timestamp-membership limitation is not silently repaired; create a new-format
  version when fixed membership is needed. Missing snapshot members fail the hash/count
  check rather than triggering a newer-data fallback.
- Experiment cancellation closes queued and running attempts in the same transaction.
  Worker notification only stops CPU work. Each claim has a token; registration is followed
  by a durable state re-read, and obsolete tokens cannot complete/cancel a newer execution.
- Recovery requeues interrupted running/paused work but cancels terminal-experiment orphans.
  A per-schema scheduler session lock protects live claims from a second scheduler. Retries
  remain visible in `runs`; computation is not claimed exactly once.
- Learning terminalization/recovery cancels queued candidates and closes the cycle in one
  transaction, preserves completed results and repairs actual counts after partial generation.

| Check | Observed result |
|---|---|
| `REQUIRE_DB=1 go test -count=1 -race -json ./...` | **237 passed tests/subtests, 0 failed, 0 skipped; 22 test packages passed** |
| Ingest transaction opened before snapshot, committed afterward | prior snapshot loads exactly; both aggregation-hidden and visible corrections get distinct new IDs |
| Concurrent snapshot creation / correction allocation / initial multi-symbol partition | pass; one member set, all correction revisions retained |
| Missing member / failed member insertion | corruption rejected; no partial metadata row persisted |
| Migration down/up with legacy records, isolated test schema | prior manifest, ID and bars unchanged |
| Cancel before worker registration / obsolete claim / competing scheduler / terminal recovery | pass; obsolete work cannot revive or overwrite results |
| Cycle finish failure, split failure and restart | rollback atomic; no queued candidate remains in a terminal cycle |
| Simulator goldens | all 11 pass unchanged |
| sqlc v1.31.1 generation / Go vet / golangci-lint | generated output reproducible; vet passed; 0 lint issues |
| Dart MCP analysis / existing Flutter suite | no errors; **48 tests passed** |

Evidence: `artifacts/p0-fix05-go-tests.jsonl` and `artifacts/p0-fix05-flutter-tests.log`
(git-ignored), on the same isolated local PostgreSQL/macOS setup as FIX-04. No hosted
workflow or real-browser UX gate was executed. A member row per raw candle adds storage
and load work; this batch does not establish raw-memory or large-catalog performance bounds.
Dataset provenance is pinned, but full build/instrument/policy provenance and canonical-fill
reproduction (F13), lifecycle serialization (F15), and the complete P0 gate remain open.

## Resource admission and input bounds (2026-11-02)

This batch continues from de3e6a9 and closes the remaining Reproduce admission bypass,
plus the raw-input part of F07. It does not certify all resource or P0 acceptance criteria.

- Reproduce takes the entire weighted research share before any report/dataset read, like
  report creation. Cancellation and database errors leave the semaphore balanced.
- `data.MaxRawBars = 1,000,000` bounds the projected number of raw minute candles, regardless
  of requested output timeframe. The projection includes the leading aggregation bucket,
  rounds up partial minutes and rejects reversed/empty/unknown ranges before reading.
- Live/legacy reads, snapshot creation and pinned member loads query at most cap + 1 rows.
  A result over the cap fails; it is never hashed/scored/persisted as a truncated dataset.
  Manifest/output counts are checked before constructing arrays. SQL bindings regenerated.
- Import checks the range before downloading/writing. Report requests preflight all dataset
  ranges and their combined raw cost before loading the first. Learning collection/forward
  check combined raw inputs; collection now waits for a research slot before materialization.
- Each report/search cache has both its existing dataset-count limit and a total retained-bar
  cap of 1,000,000. Eviction does not invalidate bars already used by an active run.
- Strategy periods are capped at 1000 before ring allocation; NaN/Inf parameters are rejected.
  No evaluation, training, fill or dataset semantic version changes; no migration/proto changes.

Executed on Windows amd64, Go 1.26.4, local PostgreSQL, Flutter 3.44.2/Dart 3.12.2:

| Check | Result |
|---|---|
| Pre-fix regressions | Reproduce bypass, unbounded raw range and strategy period reproduced |
| `REQUIRE_DB=1 go test -count=1 -json ./...` | **245 passed tests/subtests, 0 failed/skipped; 22 packages** |
| Limit boundaries / raw SQL / combined report ranges / cache eviction | passed |
| Reproduce full-share waiting / cancelled waiter / release after DB error | passed |
| Collection cancellation / forward and lifecycle regressions | passed |
| Simulator goldens | all 11 unchanged and passing |
| golangci-lint / go vet / depguard planted import | passed; forbidden import rejected |
| sqlc v1.31.1 generation | byte-reproducible generated market bindings |
| Existing Flutter suite / Dart analysis | **48 passed** / no issues |

Evidence: `artifacts/p0-resources-tests.jsonl` and `artifacts/p0-resources-flutter.txt`
(git-ignored). Race was previously verified on the FIX-04/FIX-05 macOS source above; it
was not executed for this new Windows source (CGO_ENABLED=0, no GCC). No hosted/browser run.

The range preflight is intentionally conservative: sparse long ranges are rejected even
when few rows exist. Existing oversized dataset/report metadata and saved numbers remain
readable, but materializing/charting/replaying/reproducing those inputs now returns a limit
error; create bounded versions rather than rewriting old records. There is no migration.
These are input/retention limits, not a measured process-RSS cap: concurrent loads, active
runs, SQL execution and model-fitting work need further CPU/byte budget and stress checks.

## F08 research capabilities (2026-11-02)

The instrument registry now authorizes application research for known USDT-quoted symbols
only. Unknown symbols and non-USDT pairs fail with a readable reason. Checks precede report
evaluation/reproduction/recalculation, experiment planning, queued attempts (before cache),
and stored learning collect/forward work. Unsupported evidence cannot authorize promotion.
Rejected work is recorded without moving the active version/model. Data import/list/read,
charts and stored report figures remain available, including ETHBTC; rejected recomputation
does not rewrite historical figures. Low-level FX valuation/simulator fixtures are unchanged.

GetOverview adds research_capabilities: symbol, supported, reason. New execution pickers
require affirmative server permission; an older server without the added fields grants none.
Older clients cannot bypass the backend gate. Shared filtered dataset providers keep the full
Data catalog separate. Restored unsupported drafts cannot estimate/submit; learning settings
select only permitted symbols. Class-based notice/picker widgets show loading, errors/retry
and the server explanation using existing Persian RTL, typography and theme components.

| Check | Result |
|---|---|
| Pre-fix non-USDT report/learning regressions | reproduced; pass after gate |
| REQUIRE_DB=1 go test -count=1 -json ./... | **251 passed tests/subtests, 0 failed/skipped; 22 packages** |
| Crafted RPC / misleading queued symbol / prior cache | execution rejected before computation |
| Stored collect/forward cycle and promotion evidence | rejected; active version/model unchanged |
| ETHBTC data/list/chart and saved report figures | remain readable; recompute rejection preserves figures |
| Simulator goldens and FX tests | all 11 unchanged; valuation tests pass |
| Flutter | **52 passed**; four provider/codec unit tests added, no new widget tests |
| Unknown/denied symbol, missing/error/revoked permission | filtered/closed in provider tests |
| Go lint/vet, Dart analysis, proto lint/generation | passed; generated Go/Dart output reproducible |

Evidence: artifacts/p0-capability-go-tests.jsonl and artifacts/p0-capability-flutter.txt
(git-ignored). Windows amd64, Go 1.26.4, local PostgreSQL, Flutter 3.44.2/Dart 3.12.2.
Concurrent material_ui/IDE edits were preserved in the working tree and excluded from F08.
The exact staged application source was exported to artifacts/f08-index-review; its full
52-test Flutter suite and analysis also passed independently with the staged lockfile.
Evidence: artifacts/p0-capability-index-flutter.txt. No concurrent migration is certified here.
An invalid concurrent pubspec edit was corrected to valid YAML while preserving >=3.12.2;
the successful full Flutter run followed. No dependency/migration was added. Evaluation
stays p0.3 and training stays causal-features/v1: eligibility changed, numerical rules did not.
Race, hosted CI and real-browser visual/focus acceptance were not run on this new source.
Full cross-asset execution remains a later capability requiring quote funding/accounting tests.

## F13 report provenance and canonical reproduction (2026-11-03)

New report specs contain optional, engine-owned provenance version 1. This pins the actual
binary SHA-256, available Go VCS commit/time/modified flag, compiler/platform, dataset IDs
and complete manifests, used instrument filters/assets/scales and explicit evaluation, fill,
accounting and research policy identifiers. The existing Sim/Split/Params fields retain the
costs, sizing, latency, TTL and evaluation settings. Metadata unavailable to Go is explicitly
unknown; the release label is never used as a fabricated commit hash.

Reproduce now compares spec, split, evaluation, holdout and summary integers, plus ordered
trades, fills and decisions for both main/holdout. JSON numbers are decoded without float64
and compared as exact rationals, tolerating jsonb decimal/exponent formatting only. Canonical
records reuse the persistence projection, with UTC microsecond timestamps matching PostgreSQL.
Transient simulator observation/mark fields retain their existing exclusion from persistence.
Reproduce and Recalculate use recorded instrument filters; malformed/unknown provenance and
inconsistent assets/scales fail rather than falling back to today's filters. Legacy reports
remain readable; legacy Recalculate retains its old registry fallback, explicitly unpinned.

Identical is deliberately strict: a changed binary/release/context returns false even when
totals match. Reports with missing provenance cannot gain an identical result by backfilling
today's metadata. Comparison blocks differing execution contexts using the full SHA-256 key,
independent of its 12-character display. Existing badges explain legacy/incomplete/dirty build
metadata, and spec_json exports all available provenance. No new RPC/DB schema or numerical
evaluation/training version is introduced, and no stored financial row is rewritten.

| Check | Observed result |
|---|---|
| Pre-fix regressions | >2^53/int64/decimal differences and changed/deleted/reordered canonical records incorrectly reported identical |
| REQUIRE_DB=1 go test -count=1 -json ./... | **282 passed tests/subtests, 0 failed/skipped; 22 packages** |
| Main/holdout fill, trade, decision and summary corruption with saved metrics | difference detected; reproduction leaves stored rows unchanged |
| Historical instrument filters / changed binary or release / legacy JSON | pinned replay passes; context changes and unknown legacy provenance cannot certify identity |
| Forged creation provenance / invalid instrument identity/scales | engine replaces supplied metadata; invalid replay inputs rejected |
| Export JSON / legacy API warning / comparison contexts | passed |
| Simulator goldens | all 11 unchanged and passing |
| Flutter / Dart analysis | **52 existing tests passed** / no issues; no new widget tests |
| Go lint / vet / executable build | passed; built executable contains commit bb04d88 and vcs.modified=true |
| Depguard planted optimizer import / Python CI summary tests | import rejected and temporary probe removed / 2 passed |

Evidence: artifacts/p0-provenance-go-tests.jsonl and artifacts/p0-provenance-flutter.txt
(git-ignored). Windows amd64, Go 1.26.4, local PostgreSQL, Flutter 3.47.4/Dart 3.13.3.
Race was not run (CGO_ENABLED=0, no GCC); no hosted CI or real-browser acceptance. The
canonical row comparison adds reads/allocations; process-wide memory/CPU guarantees remain
F07 work. Full P0 is still open; next is F15.

## F15 atomic lifecycle decisions (2026-11-03)

Library transitions, Approve and Rollback now use one shared lifecycle service in experiment.
It locks the algorithm before its versions/cycle, checks the caller's expected revision,
and commits the version/model pair, lifecycle/promotion audit, cycle closure and revision
increment together. Errors roll everything back. Stopping the active version clears its
model; activating a fixed strategy clears any previous model. Learning activation requires
a sealed artifact whose algorithm and recipe match the target version. Retired versions
cannot be reactivated through promotion or rollback. Version registration shares the lock
for numbering/deduplication, without itself changing the serving-pair revision.

Migration 00007 adds algorithms.lifecycle_revision, promotions.lifecycle_revision and a
unique partial index allowing at most one active version per algorithm. It preserves legacy
states/history and starts counters at zero; ambiguous legacy active versions cause migration
failure rather than an automatic champion choice. Migration tests exercise both cases.
Serving-pair readers in Library and Learning use a repeatable-read snapshot, including
artifact identity validation, rather than combining independently read versions and models.

The champion revision is fixed before training. Approval requires that revision still to
match, even when a client refreshes its request token. Missing legacy champion revisions
cannot authorize promotion. Old/stale recommendations remain readable and rejectable so
the user can start a new cycle. Rollback checks both current pair and promotion revision,
rejecting an intervening change even when the pair returned to its previous values (ABA).
Its request pins the displayed algorithm ID, independent of another tab changing settings.

Library/Approve/Rollback requests now require optional expected_revision to be explicitly
present: missing and zero are distinct. Rollback additionally requires algorithm_id.
Missing/stale tokens return FailedPrecondition with refresh guidance. Flutter captures the
token of the confirmed view and refreshes after a rejected action. Learning activation is
offered through cycle approval; the Library no longer offers model-less learning activation.
The existing class-based UI and confirmations remain; no new widget tests were introduced.

| Check | Observed result |
|---|---|
| Before fixes | stop retained a model; library activation bypassed the algorithm lock |
| REQUIRE_DB=1 go test -count=1 -json ./... (Go-only final run) | **302 passed tests/subtests, 0 failed/skipped; 22 packages** |
| Concurrent approve/stop/switch/rollback, stale tabs and ABA | one winner per revision; serving pairs remain consistent |
| Promotion insert failure | pair, audit, revision and cycle changes roll back together |
| Concurrent version allocation and serving reads | dedup/numbering serialized; model recipe matches the visible version |
| Legacy/champion changes, foreign models and retired versions | activation rejected; stale recommendations remain rejectable |
| Migration with one/two legacy active versions | valid state preserved / ambiguous state rejected without choosing a winner |
| RPC missing/zero/stale token, rollback target vs config | enforced; explicit displayed algorithm used |
| Flutter / analyzer | **54 passed**, including two codec unit tests; no issues |
| Go lint / vet / executable build | passed |
| Proto lint and Go/Dart/SQL regeneration | passed; 84 generated files byte-reproducible |
| Simulator goldens | all 11 unchanged and passing |

Evidence: artifacts/p0-lifecycle-go-tests.jsonl and artifacts/p0-lifecycle-flutter.txt
(git-ignored). An earlier concurrent Go/Flutter/build run had 301 passes and one timeout in
TestKillMidSearchResumesWithoutLossOrDuplicates; preserved as p0-lifecycle-go-tests-first.jsonl.
The isolated test passed in 1.67 s and the later complete Go-only run passed. The timeout's
cause is not established; no test threshold was weakened and no scheduler fix is claimed.
Windows amd64, Go 1.26.4, local PostgreSQL, Flutter 3.47.4/Dart 3.13.3. No local race
(CGO_ENABLED=0/no GCC), hosted CI or real-browser acceptance. Full P0 remains open.
The planted depguard import was rejected and its temporary directory removed; both Python
CI-summary tests passed. No production database migration was applied during this verification.

Compatibility: deploy a matching client/engine; old clients without tokens cannot mutate
lifecycle state. Do not mix old writer binaries with the new service. Preserve a database
backup and revision history; dropping migration 00007 loses the optimistic decision history.
No financial record, simulator/evaluation/training contract or dataset snapshot is rewritten.

## F07 training cancellation and bounded fitting (2026-11-03)

Fit takes context explicitly; WalkForward passes it into sample preparation, readiness,
scaler fitting, standardized-row materialization, ridge/logistic accumulation and loss.
Row passes cooperate at least every 256 rows; logistic also checks each Newton iteration.
Errors/cancellation discard partial outputs. Existing non-context feature helpers remain
compatible wrappers. Completed fits retain their original operation order, hashes and
causal-features/v1 contract; both reference model IDs were captured before the edit and match.

Fit rejects >1,000,000 samples before scaling/standardization allocation. WalkForward checks
combined input bars and <=12 steps before sample/model allocations; no truncated input is
accepted. These caps complement raw-data limits, not replace process-wide byte admission.

From training through walk evaluation and final freeze, the cycle uses a conservative wall
deadline = registered research-slot time / maximum research slots. Waiting/IO also consume
this deadline, so it can expire with recorded active work below the nominal budget. Usage
continues to describe summed active slot wall time, not measured OS CPU time, and now includes
final fits and cancelled training. Parent cancellation remains cancellation; budget expiry
retains errBudget. Existing failed-cycle finalization cancels unfinished candidates and
preserves the serving pair. Already saved unused baseline artifacts are not promoted.

Verified: **311 Go tests/subtests, 0 failed/skipped, 22 packages, database mandatory**.
The pre-fix within-step cancellation regression failed as expected; fixed tests cover
sample/scaler/solver cancellation, preflight rejection, slot release, deadline causes and
unchanged reference artifacts. All 11 simulator goldens remain unchanged.
Evidence: artifacts/p0-training-go-tests.jsonl (git-ignored).
The existing Flutter suite passed **54 tests**; Dart analysis, Go lint/vet and engine build
passed. Flutter evidence: artifacts/p0-training-flutter.txt. No frontend source changed.

No migration, wire/dependency change or new widget test. F07/P0 remain open: aggregate active
memory, OS CPU budgets and load acceptance are not established. Context checks cannot
interrupt allocation/GC or the small feature-bounded Gonum factorization. No local race,
hosted workflow or real-browser acceptance was executed in this batch.

## F07 shared active-memory admission (2026-11-03)

The executable creates one jobs.Memory budget and passes it to the report service and
learning loop; search uses that same report service. research_memory_mib defaults to
1024 MiB, validates 16..65536 and appears in startup logs. Isolated library/test callers
may omit the pool; production construction always supplies it.

Before loading raw inputs, range metadata estimates 1 MiB fixed cost + 1024 bytes per raw
minute + 8192 bytes per projected output candle per (parallel workers + 2 retained runs).
All arithmetic is checked against int64 overflow. The estimate intentionally counts cached
inputs again for each owner. Reservations are atomic, reject immediately on exhaustion,
and have idempotent cleanup. Immediate rejection avoids deadlocks when a retained training
workspace needs CPU slots held by another request. The counter is not measured RSS.

Guards cover Create/CreateWithID/Reproduce through persistence/canonical verification,
Recalculate through replay, scheduler attempts (including cache hits) and winner reports,
learning collection through freeze, each forward evaluation, and chart/decision handlers.
The calculator handler additionally reserves while projecting the returned simulator run;
its conservative outer/inner reservations can reject a request that a direct replay admits.
Chart indicator expansion is capped at eight. Report/chart resource errors use the existing
ResourceExhausted code. A rejected search attempt is durably failed with a resource reason;
collection failure preserves the serving pair, while a forward poll remains retryable.
No rejected job produces a partial evaluation or rewrites saved financial evidence.

Verified: **319 Go tests/subtests passed, zero failed/skipped, 22 packages, DB mandatory**.
Tests cover exact/shared capacity, contention, overflow, cancellation, cleanup after errors,
cached/uncached report guards, idempotent completion and immutable figures, search terminal
ownership, collection rejection and forward retry without a serving-pair change. All 11
simulator goldens remain unchanged. **54 existing Flutter tests**, analyzer, Go lint/vet,
engine build, planted depguard rejection and two Python CI-summary tests passed.
Logs: artifacts/p0-memory-go-tests.jsonl and artifacts/p0-memory-flutter.txt (git-ignored).

Compatibility: older configs inherit the default; previously runnable large inputs may now
require a shorter range/lower parallelism or a deliberately increased machine budget. No
financial/training/dataset semantic version, migration, dependency or wire schema changes.
Retained dataset caches still have their separate count/bar caps, outside the active counter.
Archive import/decompression and outbound serialization are not a hard process-wide memory
boundary. RSS/OS CPU/load acceptance, local race, hosted CI and browser UX remain open.

## F07 archive/import bounds (2026-11-05)

The production Importer now shares main's jobs.Memory pool. It reserves 384 MiB for the
bounded archive/cleaning/database workspace plus 1024 bytes per requested raw minute before
network work; post-import dataset reconstruction reserves separately. Resource errors use
ResourceExhausted in the streaming API. Daily fallback processes each ZIP before fetching
the next instead of retaining the whole month's downloads. Progress includes missing days.

ZIP download/parse input stays limited to 64 MiB. Inflated entry metadata and actual CSV
reads are limited to 32 MiB; each numeric CSV row is single-line, at most 4096 bytes; a file
has at most 44,640 bars (31 days). The scanner bounds a row before encoding/csv allocates
its fields. Quoted numeric fields, blank lines, CRLF, timestamps and fixed-point decoding
retain their interpretation; multiline CSV records are not a supported numeric archive row.
Context-aware parsers check reads and rows; compatibility wrappers use background context.
Cancellation/limits discard local parsed prefixes, and a failed file is never upserted.
Previously committed valid files remain after a later-file/stream failure, as before;
re-import is idempotent. Failure to send progress cancels remaining download/processing.

Before-edit tests reproduced unbounded rows, inflated-size parsing and downloads beyond
the first invalid day. Final verification: **325 Go tests/subtests, 0 failed/skipped,
22 packages, database mandatory**; all 11 goldens unchanged; **54 existing Flutter tests**;
Dart analysis, Go lint/vet/build, planted depguard rejection and both Python summary tests
passed. The real import RPC fixture uses a 512 MiB pool and checks shared exhaustion,
retry, matching snapshot IDs and cleanup, including error paths. Tests also cover the row
boundary, byte/line limits, pre-network rejection and cancellation during reads.
Evidence: artifacts/p0-import-go-tests.jsonl and artifacts/p0-import-flutter.txt (ignored).

A separate compiled API test process was sampled every 20 ms with Windows process counters:
observed peak working set 80,683,008 bytes, CPU 0.234375 s, elapsed 1.6753859 s including
process launch; TestDataImportStreamAndViews passed. Scope/method: PERFORMANCE.md; logs:
artifacts/p0-import-profile.json and .txt. This is not a mixed-workload RSS/CPU acceptance
test, nor a hard OS resource cap. No local race/hosted CI/browser acceptance was executed.
WSL Ubuntu-24.04 is present but has neither Go nor GCC; Windows still has no GCC on PATH.

No dependency, wire/schema migration, dataset/evaluation/training semantic version change
or financial rewrite. Oversized archives now fail explicitly; already stored datasets and
reports remain readable. F07's process-wide resource/load acceptance and full P0 stay open.

## Remaining P0 work / next batch

The analytics/learning review after FIX-02 fixed dependency readiness, fit/model validation,
complete/deterministic search selection and unnecessary per-bar explanation work. New model
artifacts record `causal-features/v1`; that review used evaluation `p0.2`. Verified: 197 Go tests/subtests,
zero skip with DB mandatory, 48 existing Flutter tests, lint/vet, Dart analysis and depguard. See
[P0_LEARNING_REVIEW_FA.md](P0_LEARNING_REVIEW_FA.md) for evidence, measured scope and compatibility.
That historical review preceded FIX-04/FIX-05 above. These batches do not complete all of P0.

1. Finish F07 process-wide CPU/RSS/load acceptance. Archive/import bounds, shared
   active-work byte admission, cooperative fitting cancellation and conservative slot-time
   deadlines are implemented in the scopes above; they are not OS resource quotas.
2. Finish F10 with search-backed paginated pickers. Current pickers fetch all pages into
   memory; a shortcut comment records the limit. Network supervision, accounting overflow,
   economic label/fill alignment and remaining stress cases also remain open.
3. Run the hosted workflow, real-browser chart/async/focus checks and P0 UX gate.

The existing passing suite does **not** establish process-wide resource or accounting-overflow
acceptance criteria. Do not use this checkpoint as a P0 release pass.

## Rollback / compatibility

FIX-05 adds migration 00006 without rewriting prior financial records. Do not run its down
migration on a database retaining format-1 snapshots: their revision membership is required
to load them. Keep a compatible engine and a full backup with those new versions. Existing
legacy datasets remain readable but do not gain fixed membership through an upgrade.
Preserve all reports, attempts and dataset records;
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
