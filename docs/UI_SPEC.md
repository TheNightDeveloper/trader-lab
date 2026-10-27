# UI Spec — design to Flutter

The design lives in `design/screens/*.dc.html` (exported from the canvas "Trading Research
Platform UI"). These files need the canvas runtime to render, so view them on the canvas;
in the repo they are read as source: markup gives structure, copy and inline styles, and
the `renderVals()` script holds the sample data and interaction logic (tabs, steps, toggles,
calculator math). Screenshots of each artboard go in `design/png/<Screen>.png` so the
visual reference is also available offline.

Rules for implementing from the design:
- The HTML is a **visual and behavioral reference**, not code to port. Rebuild each screen
  from the shared widgets below.
- Colors, spacing, radii, fonts come only from `app/lib/core/theme/tokens.dart`
  (mirrors `design/tokens.json`).
- All numbers in the design are **sample data**. Real values come from the engine API.
  The calculator's JavaScript math is a prototype: production math is `PnlService` in Go.
- Persian copy in the design is the starting copy; keep it in `app/lib/l10n/fa.arb`.

## 1. Shell

| Element | Design source | Flutter |
|---|---|---|
| App layout | every screen: sidebar + `main` | `AppShell` with `Row` (≥600 px) or sidebar as `Drawer` (<600 px). Page padding `AppSpace.page`, section gap `AppSpace.xl`. |
| Sidebar | `Sidebar.dc.html` | `AppSidebar(active: Route)`; nav items with group headers; Phase 2 items disabled with a “فاز ۲” badge; status block bound to `HealthService` stream. |
| Page header | `h1` + subtitle + action buttons | `PageHeader(title, subtitle, actions)`; actions wrap on narrow widths. |

Direction: `Directionality(textDirection: TextDirection.rtl)` at the root. Wrap every number,
symbol, hash and chart in `Directionality(ltr)` via the `Num` widget.

## 2. Shared widgets (build these first, in `app/lib/core/widgets/`)

| Widget | Seen in | Props / behavior |
|---|---|---|
| `Num` | everywhere | `value` (decimal string), `unit`, `signed`, `tone` (auto: positive/negative/neutral). Always shows +/− when `signed`. Mono, tabular figures, LTR. |
| `SectionCard` | all panels | `title`, optional `trailing`, `child`; surface bg, 1 px border, radius lg, padding 16–18. Variant `tone` for verdict border (positive/negative). |
| `StatCard` | Home, Queue, Calculator | `label`, `value` (Num), `sub`, optional progress bar (`fraction`, `tone`). |
| `VerdictCard` | Calculator, Report | `verdict` text + tone, `sentence` (plain-language summary from engine). |
| `WaterfallBars` | Calculator, Report | rows of (label, amount); bar width ∝ \|amount\| / max; gross positive, costs negative, net accent. |
| `ChoiceChip` group | Library, Builder, Queue, Chart | single or multi select; selected = accentSoftBg + accent border + bold; min 44 px. |
| `StepNav` | Builder | steps with number/✓ dot, current highlighted, clickable to go back. |
| `MetricRow` | Report, Learning | label + `?` help button (tooltip = metric definition from engine) + Num. |
| `DataTableBox` | Home, Queue, Report, Data… | horizontal scroll when narrow; header muted; row divider; **server-side pagination**; status cell colored + text. |
| `StatusDot` / `StatusText` | Home cycle steps, Queue | status enum → color + label (never color alone). |
| `GateItem` | Learning | status pill (قبول / رد / در انتظار) + text. |
| `WarningBanner` | Builder, Compare, Report badges | warningBg + warningBorder + warningText. |
| `FieldWithHelp` | Builder, Calculator, Settings | label, unit, input, helper text below; numeric inputs LTR. |
| `EquityChart` | Report, Compare, Calculator | lightweight custom painter (not KLineChart); shaded in-sample / OOS / holdout regions; series distinguished by color **and** dash. |
| `Heatmap` | Report | grid of signed values; selected cell outlined. |
| `CandleChart` | Chart | KLineChart adapter via `HtmlElementView` (see M0 spike); markers clickable → decision panel. |

## 3. Screens

States every screen must handle: **loading** (skeleton of the same layout), **empty**
(one sentence + the next action button), **error** (what failed + retry), **stale** (engine
unreachable: banner, last data kept visible).

| Route | Design file | API | Notes |
|---|---|---|---|
| `/` Home | `Main.dc.html` | Health, Learning (last cycle), Experiment (recent), Data (alerts) | Cycle steps as a horizontal grid; recent runs table links to report. Empty: “هنوز آزمایشی ندارید” + “آزمایش تازه”. |
| `/library` | `Library.dc.html` | Library | Family filter chips; card select → detail panel (recipe, versions). Active versions show a lock note. |
| `/experiments/new` | `Builder.dc.html` | Library, Data, Experiment | 6-step wizard; template on step 0 jumps to step 1; summary aside always visible; “Advanced” collapsed by default; run count and ETA from `Experiment.Estimate`. Draft auto-saved locally. |
| `/experiments/:id/queue` | `Queue.dc.html` | Experiment (stream progress, list attempts) | Stacked progress bar (done/failed/cancelled); tabs filter attempts server-side; pause/cancel confirm dialog. |
| `/reports/:id` | `Report.dc.html` | Report, Pnl | Order: badges → plain summary + waterfall → equity → metric groups → folds + stress → sensitivity. Holdout section hidden behind an explicit “show” action that logs a view. |
| `/compare` | `Compare.dc.html` | Report.Compare | Assumption diff table first; mismatches highlighted with warning banner; then chart and metrics. |
| `/pnl` | `Calculator.dc.html` | Pnl, Fx | Two tabs. Inputs debounce 300 ms → `PnlService`. Reset restores the run's original settings. Toman shown only when a rate is chosen. |
| `/learning` | `Learning.dc.html` | Learning | Approve button disabled until every gate passes; approve and rollback require a confirm dialog that restates what changes. |
| `/chart` | `Chart.dc.html` | Chart | Chart area LTR inside RTL page; selected marker drives the decision panel. Replay button disabled (later phase). |
| `/data` | `Data.dc.html` | Data | Coverage timeline LTR; import form validates range and shows the resulting dataset version on success. |
| `/settings` | `Settings.dc.html` | Settings, Fx | Rate entry: date defaults to today; saving shows how many reports reference each rate; past rates are read-only. |

## 4. Responsive

| Width | Behavior |
|---|---|
| ≥ 1200 | Sidebar fixed; two-column screens side by side (form + summary, table + panel). |
| 600–1199 | Sidebar fixed; secondary columns wrap below primary. |
| < 600 | Sidebar becomes a drawer; all columns stack; tables scroll horizontally; stat grids become 2 columns. Monitoring and reading must work; building experiments is desktop-first. |

## 5. Accessibility

- Every interactive element is a real button/link/field with a semantic label; icon-only
  buttons have tooltips and `Semantics(label:)`.
- Tab order follows visual RTL order: header actions → filters → content → panel.
- Contrast ≥ 4.5:1 for text (tokens already satisfy this on surface colors).
- Status always has text, not only color; P&L always has a sign.

## 6. Verifying the build matches the design

1. Widget golden tests (`matchesGoldenFile`) for each shared widget in default, selected,
   disabled, loading, and error states, at 1440 and 390 widths.
2. For each screen, a golden test with fake API data equal to the design's sample data.
   Compare the golden PNG side by side with `design/png/<Screen>.png`.
3. A design change goes: edit canvas → re-export the changed `.dc.html` into
   `design/screens/` → commit → ask Claude Code to update the matching screen and its
   golden.
