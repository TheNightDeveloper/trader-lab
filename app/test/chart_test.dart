import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/core/local_store.dart';
import 'package:trading_lab/core/theme/tokens.dart';
import 'package:trading_lab/core/widgets/candle_chart.dart';
import 'package:trading_lab/features/chart/chart_screen.dart';
import 'package:trading_lab/gen/lab/v1/chart.pb.dart';
import 'package:trading_lab/gen/lab/v1/common.pb.dart' as pb;
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/gen/lab/v1/report.pb.dart';
import 'package:trading_lab/l10n/app_localizations.dart';
import 'package:trading_lab/main.dart' show breakpoints;

import 'fake_transport.dart';

pb.Decimal d8(String s) =>
    pb.Decimal(units: (Decimal.parse(s) * Decimal.fromInt(100000000)).toBigInt().toString(), scale: 8);

final t0 = DateTime.utc(2024, 1, 1);

GetChartResponse chart() => GetChartResponse(
  symbol: 'BTCUSDT',
  timeframe: '1h',
  pricePrecision: 2,
  symbols: ['BTCUSDT'],
  totalBars: 3,
  bars: [
    for (var i = 0; i < 3; i++)
      ChartBar(
        openUnixMs: Int64(t0.add(Duration(hours: i)).millisecondsSinceEpoch),
        open: d8('100'),
        high: d8('101'),
        low: d8('99'),
        close: d8('100.5'),
        volume: d8('1'),
      ),
  ],
  indicators: [
    ChartIndicator(
      key: 'ema:10',
      label: 'EMA 10',
      pane: 'main',
      lines: [
        IndicatorLine(name: 'ema', values: ['', '100.12345678', '100.20000000']),
      ],
    ),
  ],
  markers: [
    ChartMarker(
      decisionId: 7,
      barOpenUnixMs: Int64(t0.add(const Duration(hours: 1)).millisecondsSinceEpoch),
      kind: 'entry',
      price: d8('100.5'),
    ),
  ],
);

void main() {
  test('the chart draws exactly the engine values; warm-up is left empty', () {
    final ind = EngineIndicator(
      key: 'ema:10',
      label: 'EMA 10',
      main: true,
      lines: [
        EngineLine('ema', [null, Decimal.parse('100.12345678'), Decimal.parse('100.2')]),
      ],
    );
    final bars = [
      for (var i = 0; i < 3; i++) CandleBar(t0, Decimal.one, Decimal.one, Decimal.one, Decimal.one, Decimal.one),
    ];
    final v = ind.valuesFor(bars);
    expect(v[0], isEmpty, reason: 'undefined is not zero');
    expect(v[1]['ema'], 100.12345678);
    expect(v[2]['ema'], 100.2);
  });

  test('a report shows its strategy own lines', () {
    final r = Report(
      spec: ReportSpec(strategy: 'trend-ema', params: {'fast': 10.0, 'slow': 30.0}.entries),
    );
    expect(strategyLines(r), ['ema:10', 'ema:30']);
    final b = Report(
      spec: ReportSpec(strategy: 'mean-rev-bands', params: {'period': 20.0, 'k': 2.0}.entries),
    );
    expect(strategyLines(b), ['bb:20:2']);
  });

  testWidgets('report layer: strategy lines requested, markers lead to the decision, layout saved', (tester) async {
    localRemove(layoutKey);
    final fake = FakeTransport({
      'GetChart': (_) => chart(),
      'GetReport': (_) => GetReportResponse(
        report: Report(
          id: 'rp_1',
          title: 'trend-ema · BTCUSDT · 1h',
          spec: ReportSpec(strategy: 'trend-ema', params: {'fast': 10.0, 'slow': 30.0}.entries),
        ),
      ),
      'ListReports': (_) => ListReportsResponse(),
      'GetDecision': (_) => GetDecisionResponse(
        decision: DecisionRow(
          id: 7,
          reason: 'EMA10 crossed above EMA30',
          outcome: 'filled',
          target: pb.Decimal(units: '1000000', scale: 6),
        ),
        refPrice: pb.Money(units: '10050000000', scale: 8, asset: 'USDT'),
      ),
    });
    tester.view.physicalSize = const Size(1440, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/chart?report=rp_1',
      routes: [
        GoRoute(
          path: '/chart',
          builder: (_, s) => Scaffold(body: ChartScreen(report: s.uri.queryParameters['report'])),
        ),
        GoRoute(path: '/reports/:id', builder: (_, s) => Text('report:${s.pathParameters['id']}')),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        retry: apiRetry,
        overrides: [
          transportProvider.overrideWithValue(fake),
          engineStatusProvider.overrideWith((ref) => Stream.value(EngineStatus())),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: buildAppTheme(),
          locale: const Locale('fa'),
          supportedLocales: L10n.supportedLocales,
          localizationsDelegates: const [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, c) => ResponsiveBreakpoints.builder(breakpoints: breakpoints, child: c!),
        ),
      ),
    );
    await settle(tester);

    final req = fake.calls['GetChart']!.last as GetChartRequest;
    expect(req.reportId, 'rp_1');
    expect(
      req.indicators,
      containsAll(['ema:10', 'ema:30', 'ema:48']),
      reason: "the strategy's own EMAs, then the user's",
    );
    expect(find.textContaining('خطوط خود راهبرد'), findsOneWidget);

    await tester.tap(find.byTooltip('تصمیم بعدی'));
    await settle(tester);
    expect((fake.calls['GetDecision']!.single as GetDecisionRequest).decisionId, 7);
    expect(find.text('EMA10 crossed above EMA30'), findsOneWidget);
    expect(find.text('ورود خرید'), findsOneWidget);
    expect(find.text('100.50 USDT'), findsOneWidget, reason: 'reference price with unit');

    await tester.tap(find.text('RSI'));
    await settle(tester);
    expect(localGet(layoutKey), contains('RSI'), reason: 'layout saved per browser');
    expect((fake.calls['GetChart']!.last as GetChartRequest).indicators, contains('rsi:14'));

    await tester.tap(find.text('بازگشت به گزارش'));
    await settle(tester);
    expect(find.text('report:rp_1'), findsOneWidget);
  });
}
