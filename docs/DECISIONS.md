# Decisions (ADR log)

Short records: context, decision, consequences. Newest at the bottom.

## ADR-001 Market data source
Decision: no Wallex. Binance public archive for history, public WebSocket closed klines for live data. No account or keys in v1.
Consequence: real execution (Phase 2+) needs a separate venue decision; account restrictions for the user's region are a product risk.

## ADR-002 Accounting currency
Decision: USDT for all accounting, risk and comparison. Non-USDT pairs valued via cross rates available at the time.
Consequence: labels and reports say USDT, not USD.

## ADR-003 Toman display
Decision: display-only conversion using a dated USDT/TOMAN rate, entered manually in v1. Unit name TOMAN (1 TOMAN = 10 IRR). Reports store the rate ID they used.
Consequence: rates never affect research results; automating the source later only changes the `source` field.

## ADR-004 v1 scope
Decision: engine + self-learning loop + UI. Paper trading replaced by forward tests in the same simulator. Orders, risk/behavior gates, journal and market context move to Phase 2.

## ADR-005 Stack
Decision: Go engine (single binary, localhost only), PostgreSQL, protobuf + Connect API, Flutter Web (RTL, desktop-first), KLineChart via HtmlElementView.
Open: Dart Connect client and KLineChart interop to be confirmed by M0 spikes.

## ADR-006 API transport: Connect over HTTP/1.1 (M0 spike)
Context: the Flutter Web client needs server streaming (HealthService.Watch, later run progress).
Decision: keep Connect. `connectrpc` 2.0.1 for Dart with the fetch transport (`package:connectrpc/web.dart`), `protoc_plugin` 25 + `protoc-gen-connect-dart` run locally through buf. Verified in Chrome: the built app served by the engine shows live HealthService stream values in the sidebar. No gRPC-web or OpenAPI/SSE fallback is needed.
Consequence: stream messages are wrapped in `<Rpc>Response` (buf STANDARD lint). The Dart client reconnects forever with capped backoff (Riverpod's default retry gives up after 10 tries).

## ADR-007 Candle chart: KLineChart 10 via HtmlElementView (M0 spike)
Decision: KLineChart 10.1.0 vendored in `app/web/vendor/` (no CDN), wrapped by one adapter, `CandleChart` (`core/widgets/candle_chart*.dart`, `dart:js_interop` + `package:web`). Bars cross the adapter as `Decimal` and become JS numbers only for drawing.
Findings: (1) `<html dir="rtl">` breaks Flutter's platform-view positioning; RTL is set only inside Flutter. (2) The element is created detached, so the chart is created on the first ResizeObserver callback with real width; later callbacks call `resize()`. Verified with headless Chrome: the chart fills its card, LTR inside the RTL page, with token colors.
Open: hover/crosshair and live window resize still need a manual check in a real browser (headless screenshots can't drive the pointer).

## ADR-008 HTTP server: Echo v5
Decision: user's choice. Echo v5.4.2 hosts the Connect handlers (`echo.WrapHandler`), serves the built app with Static middleware in HTML5 mode (deep links → index.html; `os.DirFS(web_dir)`), and CORS only for loopback origins (for `flutter run`). Echo's Response supports Flush, so Connect streaming works through it (tested).
Consequence: one more dependency in the engine; the loopback-only bind is still enforced by config validation.

## ADR-009 Frontend motion and responsive layout
Decision: user's request for a smooth, polished UI. Packages: `flutter_animate` (entrances, status pulse), `flutter_staggered_animations` (sidebar list), `animations` (fade-through page transitions), `skeletonizer` (loading skeletons per UI_SPEC), `responsive_framework` (MOBILE <600, TABLET 600–1199, DESKTOP ≥1200 from UI_SPEC §4).
Rules: durations come from `AppMotion` in tokens; `AppMotion.of(context, d)` returns zero when the OS asks for reduced motion. Motion never carries meaning on its own.
