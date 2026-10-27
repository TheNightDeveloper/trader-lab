# CLAUDE.md — Trading Research Lab

Personal research platform for crypto spot trading algorithms. A Go engine builds, tests,
and continuously retrains strategies; a Flutter Web UI (Persian, RTL) defines experiments
and shows results. No real orders exist in v1.

Read `docs/IMPLEMENTATION_PLAN.md` before starting any task. Work on one milestone at a
time and record progress in `docs/PROGRESS.md`.

## Repository layout

```
engine/            Go module: engine service, workers, scheduler
  cmd/engine/      main: HTTP/Connect API + scheduler + worker pool
  internal/        all engine packages (see plan §3)
  migrations/      PostgreSQL migrations (goose)
  testdata/golden/ reference scenarios and their expected outputs
proto/lab/v1/      API contract (protobuf, Connect). Source of truth for Go and Dart types
app/               Flutter Web app (desktop-first, RTL)
design/            exported design screens, tokens.json, screenshots
docs/              plan, decisions, progress, metric definitions, UI spec
```

## Commands

```
make dev-db        # start PostgreSQL via docker compose
make gen           # buf generate -> Go + Dart code from proto/
make migrate       # apply migrations
make test          # go test ./... (race on) + flutter test
make lint          # golangci-lint + dart analyze
make golden        # run golden scenarios; fails on any diff
make run           # engine on 127.0.0.1:8080 serving API + built web app
```

Run `make lint test golden` before declaring any task done.

## Non-negotiable invariants

These come from the PRD. Never weaken a test to make it pass; if an invariant seems wrong,
stop and ask.

1. **Determinism.** Same inputs (dataset hash, config, code version, seed) produce
   bit-identical trades, ledger, and metrics. Inside one run, process events strictly in
   order on one goroutine. Parallelism only happens across runs. Never iterate a Go map
   where order affects output; sort keys first. No `time.Now()` inside sim/eval; use the
   injected `clock.Clock`.
2. **No look-ahead.** Every bar, feature, label, and FX rate carries `AvailableAt`. Code in
   a run may only read data with `AvailableAt <= now(virtual)`. Labels become usable only
   after their horizon closes. Transforms (scaling, feature selection) are fit only inside
   the training window of each step.
3. **Money is fixed-point.** Use `money.Amount` (int64 + per-asset scale). No `float64`
   for balances, fees, PnL, or prices in the ledger. Floats are allowed only inside model
   math (features, regression), never in accounting.
4. **USDT is the accounting currency.** All PnL, risk, and comparisons are in USDT.
   Toman is display-only: `fx` converts at render/export time with a stored `FxRate` ID.
   Toman never enters strategy, ledger, metrics, or comparisons. Unit name is `TOMAN`
   (1 TOMAN = 10 IRR).
5. **The judge never imports the optimizer.** `sim`, `eval`, `metrics` must not import
   `search`, `loop`, or `model/train`. Enforced by depguard in `.golangci.yml`.
6. **Every attempt is recorded.** Every run of a search or learning cycle, including
   failed and cancelled ones, is written to the attempt registry. Never delete attempts.
7. **Immutable records.** Experiments are locked on start; datasets and model artifacts
   are content-addressed. Changing anything creates a new version that references the old.
8. **Holdout discipline.** Viewing a final-holdout result is logged. Forward-test data used
   in a promotion decision becomes training-only data in later cycles.
9. **Promotion is human.** The learning loop may recommend; only an explicit user action
   changes the active (champion) version.
10. **Spot only.** No shorting, no leverage. Orders that need either are rejected.

## Go conventions

- Go latest stable, modules, `log/slog` for logging, `context.Context` first arg.
- Errors: wrap with `fmt.Errorf("...: %w", err)`; sentinel errors per package.
- DB access via `sqlc`-generated code in `internal/store`; no ORM.
- Tests: table-driven; property tests with `pgregory.net/rapid` for ledger and money;
  golden files for end-to-end scenarios. Run with `-race`.
- Ask before adding a dependency. Allowed without asking: stdlib, gonum, pgx, sqlc,
  goose, connect-go, rapid, testify/require.

## Flutter conventions

- Flutter Web, desktop-first; layouts must still work at 390 px wide.
- `Directionality` RTL app-wide; numbers, symbols, and code render LTR in mono font.
  Fonts: Vazirmatn (UI), JetBrains Mono (numbers).
- State: Riverpod. Routing: go_router. API: generated Connect client from `proto/`.
- **Never use `double` or `int` for money from the API.** Money arrives as strings with a
  scale; parse with `package:decimal`. Dart `int` on web is exact only to 2^53.
- The UI never computes PnL, metrics, or indicators that matter. It displays engine
  output. The P&L calculator calls the engine's `PnlService`.
- Design reference: `design/screens/*.dc.html` (structure, copy, sample data, behavior),
  `design/png/` (screenshots) and `docs/UI_SPEC.md` (widgets, routes, states, API per
  screen). Read the matching design file before building any screen. Colors and spacing
  live in `app/lib/core/theme/tokens.dart`; never hard-code colors in widgets.
- Every number shown to the user has a sign (+/−) and a unit; color is never the only cue.

## Definition of done (per task)

- Acceptance criteria in the plan are met and covered by tests.
- `make lint test golden` passes.
- New metrics or formulas are documented in `docs/METRICS.md`.
- `docs/PROGRESS.md` updated: what was done, what is next, open questions.
- Decisions with trade-offs added to `docs/DECISIONS.md` (short ADR form).
