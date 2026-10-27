# Progress

Update at the end of every session.

## Current milestone
M0 — Foundations (code done; three checks still need this machine set up, see below)

## Done (2026-10-27)
- Repo layout per CLAUDE.md; design export copied into `design/screens`, `design/png`, `docs/UI_SPEC.md`, `app/lib/core/theme/tokens.dart`.
- `money`: checked int64 fixed-point, 128-bit `MulDiv` (the single primitive for price×qty, fees, FX), Floor/Ceil/HalfEven, strict Parse/Format. Property tests vs a `math/big` oracle, 10,000 cases each (set in TestMain). Overflow returns `ErrOverflow`, never wraps.
  Limit to know: USDT at scale 8 caps near 92e9 USDT per amount.
- `instrument`: Spec with tick/lot rounding (qty only rounds down) and min-notional check.
- `clock`: Wall (UTC) and Virtual (monotonic, single goroutine).
- Proto `lab/v1` (Money, HealthService.Watch); buf lint + generate for Go and Dart.
- Engine: JSON config (loopback-only enforced), slog, Echo v5, Connect HealthService stream, static app with deep links, loopback-only CORS. Tests run the real Echo stack.
- `.golangci.yml` with depguard (invariant 5); `scripts/check-depguard.sh` plants a sim→search import and requires lint to fail. Passing.
- PostgreSQL docker compose, goose migration `00001_settings`, sqlc config + generated `store/db`.
- Makefile, `scripts/ci.sh`.
- Flutter app: RTL + fa l10n (`lib/l10n/fa.arb`), bundled Vazirmatn / JetBrains Mono, go_router with every UI_SPEC route + fade-through, responsive shell (drawer <600), animated sidebar from the design, live status block from HealthService with stale banner + reconnect, Num/Mono/PageHeader/SectionCard/WarningBanner, placeholder screens, chart spike.
- Both spikes recorded: ADR-006, ADR-007. Also ADR-008 (Echo), ADR-009 (motion/responsive).

## Verified
- `go test ./...` (5 packages), `golangci-lint` 0 issues, depguard probe, `buf lint`, `dart analyze --fatal-infos`, `flutter test` (6 tests incl. 390 px drawer and engine-down banner).
- Built app served by the engine, screenshotted in headless Chrome: live status from the engine stream; chart renders correctly.

## Not yet verified on this machine (M0 acceptance gaps)
- `-race`: needs cgo/gcc (none installed). Tests ran without `-race`. Install a gcc (e.g. MSYS2 mingw-w64) or run CI elsewhere.
- `make`: not installed on Windows; targets were run by hand. `winget install GnuWin32.Make` or use Git Bash + make.
- `make dev-db` / `make migrate`: Docker daemon was not running; migration not applied yet.
- Chart hover/crosshair and live resize: manual check in a real browser (`make run`, open /chart).

## Next
- Close the gaps above, then start M1 (instrument registry, Binance archive importer, AvailableAt, quality checks, dataset versions).

## Open questions
- Reference hardware for benchmarks.
- Default timeframes and pairs for the first experiments.
- Sidebar at 1440×900 does not fit all items plus the status block; the nav list scrolls (Settings is below the fold). Acceptable, or compact the items?
- `/queue` and `/reports` list routes were added because the sidebar needs a target without an id; UI_SPEC only lists `/experiments/:id/queue` and `/reports/:id`.
