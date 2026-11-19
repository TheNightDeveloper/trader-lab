# Performance

## P0 F07 runtime and memory calibration (2026-11-19)

The production binary `4a438f5` rejected a 100,000-bar report at the default
1 GiB reservation budget. The request estimate was 6,657,048,576 bytes. A second
run used a temporary 32 GiB reservation budget to measure the same workload.
The setting changes accounting admission and does not allocate that amount.
The reference host is Windows amd64, Core i3-12100F with eight logical CPUs,
Go 1.26.4 and a separate local PostgreSQL process. The fixture uses synthetic
BTCUSDT data in a disposable schema and disables live feeds and backups.

| Measurement | Original runtime | Side-run projection |
|---|---:|---:|
| Queue receipt, 500 attempts | 12.99 ms | 12.26 ms |
| GetReport p95, 100 requests | 63.76 ms | 69.65 ms |
| GetChart p95, 100 requests | 116.58 ms | 111.19 ms |
| Recalculate, one request | 1.06 s | 1.02 s |
| Worst additional health heartbeat delay | 4.28 ms | 9.12 ms |
| Engine peak working set | 456,986,624 B | 446,603,264 B |
| Engine CPU time during the mixed interval | 51.92 s | 54.14 s |
| Mixed elapsed wall time | 10.22 s | 11.50 s |

Five read workers alternated chart and report calls during the same search.
There were 53 and 46 completed attempts when the reads ended, respectively,
and all 500 attempts eventually completed in both runs. The CPU time corresponds
to approximately 63.5% and 58.8% of the host's logical-CPU capacity over the
measured interval. Peak working set covers the engine's lifetime through the
end of that interval. PostgreSQL and browser memory are outside that counter.
These are diagnostic samples with an elevated admission budget.

A separate 100,000-bar simulator stress fixture reached 199,998 fills
and 798,780,098 allocated B/op over three iterations. Total allocations measure
allocation volume. The default large-job admission failure remains open.
Local evidence is in `artifacts/p0-mixed-runtime.txt`,
`p0-mixed-runtime-diagnostic.txt`, `p0-mixed-runtime-projections.txt` and
`p0-dense-ledger.txt`.

At the default 1 GiB admission budget, `14207df` completed a real-process mixed
run over 3,500 synthetic bars. The five read workers started during the search,
which completed all 500 attempts. The fixture measured a 13.55 ms queue receipt,
29.75 ms GetReport p95, 34.67 ms GetChart p95 and one 57.57 ms recalculation.
Three health heartbeats arrived with 0.25 ms worst additional delay. The engine
used 4.22 s of CPU over 2.02 s of elapsed time and peaked at 94,019,584 resident
bytes. Evidence is in `artifacts/p0-runtime-default.txt`. This measurement
covers the smaller fixture. The 100,000-bar default-admission case remains open.

## P0 F07 chart read latency (2026-11-18)

Go 1.26.4 Linux amd64 in Docker Desktop on Windows with local PostgreSQL and race enabled.
`TestReportReadLatency` issues 100 requests from five clients over a cached 100,000-bar
report. GetChart returns 2,000 visible bars with two EMAs and Bollinger Bands.

| Implementation and suite scope | GetReport p95 | GetChart p95 |
|---|---:|---:|
| Before chart changes, full suite | 466 ms | 1,226 ms |
| Visible indicators only, full suite | 292 ms | 1,167 ms |
| Visible indicators and SQL window, focused API run | 149 ms | 523 ms |
| Visible indicators and SQL window, full suite | 320 ms | 792 ms |

The final rows use the real 1 GiB chart admission pool. Report fixture creation uses no
pool. These are individual runs with variable background load and race overhead. The
last run passed the existing 1 s p95 requirement without changing the threshold.
Evidence: artifacts/p0-network-race-go-tests.jsonl, p0-chart-window-race-go-tests.jsonl
and p0-chart-db-race-go-tests.jsonl. Mixed workload resource acceptance remains open.

## P0 F07 import fixture calibration (2026-11-05)

Windows amd64, Go 1.26.4, local PostgreSQL. Compile the existing API test package with
`go test -c -o ../artifacts/api-import-profile.test.exe ./internal/api` from engine, then run
the executable with `-test.run=^TestDataImportStreamAndViews$ -test.v` and REQUIRE_DB=1.
The fixture uses a shared 512 MiB admission pool, a two-day numeric archive with a gap,
repeated imports, snapshots, rejected budgets and a gap-policy failure. It makes no external
market request. Sample the child process every 20 ms using System.Diagnostics.Process
PeakWorkingSet64 and TotalProcessorTime; elapsed time includes process launch/poll overhead.

| Observed counter | Single run |
|---|---:|
| Peak working set sampled | 80,683,008 bytes (about 77 MiB) |
| CPU time sampled | 0.234375 s |
| Elapsed including launch | 1.6753859 s |
| Test's own elapsed / exit | 1.20 s / 0 |

Raw evidence: artifacts/p0-import-profile.json and p0-import-profile.txt (git-ignored).
This is a narrow input calibration: neither maximum-size/mixed workload acceptance nor a
hard process-RSS/CPU guarantee. Database server memory/CPU is outside this child counter;
the last sampling interval can miss work before exit. No before/after speed claim is made.

## P0 FIX-04 local measurement (2026-11-02)

macOS arm64, Apple M4, Go 1.26.5. Same one-iteration command on a temporary copy of
Phase-2 HEAD `d9f7016` and on the final working tree:
`go test ./internal/sim -run '^$' -bench MillionBars -benchtime=1x -benchmem`.

| Source | ns/op | allocated B/op | allocations/op | fills |
|---|---:|---:|---:|---:|
| Before FIX-04 | 338,999,375 | 503,186,872 | 188,462 | 332 |
| Final FIX-04 | 350,002,333 | 523,867,256 | 188,429 | 332 |

As-of open-position marks add transient state to each equity point. Moving fill observation
timestamps onto fills rather than every equity point reduced the initial 581,717,744 B/op
prototype to the final value above. Final allocated bytes are about 4.1% above this local
baseline. This is one run per version, not a latency distribution, peak RAM or a comparison
to the older Windows reference. No performance or profitability improvement is claimed.

The historical measurements below retain their original hardware and test conditions.

Reference hardware: Intel Core i3-12100F (4 cores / 8 threads), 16 GB RAM,
Windows 10, local PostgreSQL 18, Go 1.26. Run `make bench` to reproduce; add a row when a
change could move a number.

| Date | Measure | Dataset | Result | Target |
|---|---|---|---|---|
| 2026-10-26 | Simulator, trend-ema, one run (`BenchmarkMillionBars`) | 1,000,000 1m bars, random walk | 0.65 s, 314 fills | M2 baseline |
| 2026-10-28 | same | same | 0.59 s/op, 503 MB/op, 187k allocs/op | no regression |
| 2026-10-28 | `GetReport`, 5 concurrent clients × 20 (`TestReportReadLatency`) | report over 100,000 1m bars | p50 12 ms, p95 27 ms, max 158 ms | p95 < 1 s |
| 2026-10-28 | `GetChart` with 3 indicators, same load | same, 2,000 bars returned | p50 258 ms, p95 315 ms, max 347 ms | p95 < 1 s |
| 2026-10-28 | same, while the whole test suite runs in parallel | same | p95 **1.26 s** — over target | p95 < 1 s |
| 2026-10-28 | same, with the dataset cache (4 versions in memory) | same | p50 50 ms, p95 65 ms, max 81 ms (GetReport p95 59 ms) | p95 < 1 s |
| 2026-10-27 | Health updates during a 500-attempt search | 100,000 1m bars | worst delay 2–7 ms | < 1 s |
| 2026-10-27 | Report evaluation (main, holdout, stress, neighbourhood, benchmarks) | BTCUSDT 1h, 4,368 bars | 0.4 s | — |
| 2026-10-28 | Learning cycle to freeze (8 candidates × 2 folds, ridge) | 20 days of 1h bars (synthetic) | ≈ 1 s | — |

Notes
- Without a cache, GetChart (and GetDecision, on every marker click) reloaded and re-hashed
  the whole dataset; under load that missed the target. Dataset versions are content-addressed
  and immutable, so the report service keeps the 4 most recent in memory (verified once on load).
- Tests run without `-race` on this machine (no cgo/gcc); numbers are from normal builds.


## P0 starting baseline (2026-11-01)
Local Windows amd64, Intel Core i3-12100F, Go 1.26.4; one iteration without race:
`go test ./internal/sim -run '^$' -bench MillionBars -benchtime=1x -benchmem`.
One million bars: 1,027,394,700 ns/op (1.027 s), 503,084,664 B/op, 187,238 allocations,
314 fills. B/op is allocated bytes, not peak resident memory. This single measurement is
an orientation baseline, not a latency distribution or a cross-machine performance claim.


## P0 FIX-02 baseline (2026-11-01)
Same local Go/Windows/CPU setup and one-iteration command as the starting baseline:
624,214,200 ns/op (0.624 s), 503,164,136 allocated B/op, 188,429 allocations, 332 fills.
Ordered History uses the original prefix without materializing another full bar array.
Backfill holes use a temporary sorted buffer. One timing sample is not evidence of a speedup;
fill count changed with the causal contract, and B/op is not peak resident memory.

## P0 learning review (2026-11-01)
Same local Go/Windows/CPU setup. Identical `BenchmarkLearnedSteadyTarget` source copied into
the engine snapshot at 3ff937c and run against the revised engine. Command in each engine:
`go test ./internal/strategy -run '^$' -bench '^BenchmarkLearnedSteadyTarget$' -benchmem -benchtime=500ms -count=5`.
Data preparation and training are outside `b.Loop`; the timed path keeps the target unchanged.

| Version | ns/op, five runs | Median | B/op | allocs/op |
|---|---|---|---|---|
| 3ff937c | 469.2, 467.0, 563.4, 469.2, 468.0 | 469.2 | 144 | 5 |
| learning review | 252.8, 293.4, 254.8, 269.6, 263.9 | 263.9 | 48 | 2 |

The approximately 44% lower median applies to this hot path only: defer reason formatting
until a decision changes and normalize the required filter/prediction values directly.
It does not establish faster training, whole-cycle performance or better returns. Standalone
Predict measurements had zero heap allocations both before and after, with noisy timings;
no independent Predict speedup is claimed. Local logs: artifacts/learning-bench-{before,after}.txt.
