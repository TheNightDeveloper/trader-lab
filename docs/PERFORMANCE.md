# Performance

Reference hardware: Intel Core i3-12100F (4 cores / 8 threads), 16 GB RAM,
Windows 10, local PostgreSQL 18, Go 1.26. Run `make bench` to reproduce; add a row when a
change could move a number.

| Date | Measure | Dataset | Result | Target |
|---|---|---|---|---|
| 2026-10-26 | Simulator, trend-ema, one run (`BenchmarkMillionBars`) | 1,000,000 1m bars, random walk | 0.65 s, 314 fills | M2 baseline |
| 2026-10-28 | same | same | 0.59 s/op, 503 MB/op, 187k allocs/op | no regression |
| 2026-10-28 | `GetReport`, 5 concurrent clients × 20 (`TestReportReadLatency`) | report over 100,000 1m bars | p50 12 ms, p95 27 ms, max 158 ms | p95 < 1 s |
| 2026-10-28 | `GetChart` with 3 indicators, same load | same, 2,000 bars returned | p50 258 ms, p95 315 ms, max 347 ms | p95 < 1 s |
| 2026-10-27 | Health updates during a 500-attempt search | 100,000 1m bars | worst delay 2–7 ms | < 1 s |
| 2026-10-27 | Report evaluation (main, holdout, stress, neighbourhood, benchmarks) | BTCUSDT 1h, 4,368 bars | 0.4 s | — |
| 2026-10-28 | Learning cycle to freeze (8 candidates × 2 folds, ridge) | 20 days of 1h bars (synthetic) | ≈ 1 s | — |

Notes
- GetChart reloads and verifies the dataset on every call (content hash check); that is most
  of its time. Cache only if a slower machine misses the target.
- Tests run without `-race` on this machine (no cgo/gcc); numbers are from normal builds.
