import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/core/metric.dart';
import 'package:trading_lab/core/theme/tokens.dart';
import 'package:trading_lab/features/reports/compare_screen.dart';
import 'package:trading_lab/features/reports/report_providers.dart';
import 'package:trading_lab/features/reports/report_screen.dart';
import 'package:trading_lab/gen/lab/v1/common.pb.dart' as pb;
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/gen/lab/v1/report.pb.dart';
import 'package:trading_lab/l10n/app_localizations.dart';
import 'package:trading_lab/main.dart' show breakpoints;

Int64 ms(DateTime t) => Int64(t.millisecondsSinceEpoch);
pb.Money usdt(String units) => pb.Money(units: units, scale: 8, asset: 'USDT');

pb.Metric metric(String key, String units, int scale, String unit, {bool valid = true, String invalid = ''}) =>
    pb.Metric(
      key: key,
      group: 'pnl',
      value: pb.Decimal(units: units, scale: scale),
      unit: unit,
      valid: valid,
      invalid: invalid,
      label: 'label:$key',
      definition: 'def:$key',
    );

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 20; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
}

Future<void> pump(WidgetTester tester, Widget child, List overrides, {Size size = const Size(1440, 4000)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: apiRetry,
      overrides: [engineStatusProvider.overrideWith((ref) => Stream.value(EngineStatus())), ...overrides.cast()],
      child: MaterialApp(
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
        home: Scaffold(body: child),
      ),
    ),
  );
  await settle(tester);
}

final t0 = DateTime.utc(2024, 1, 1);

Report sampleReport() => Report(
  id: 'rp_1',
  title: 'trend-ema · BTCUSDT · 1m',
  spec: ReportSpec(
    strategy: 'trend-ema',
    params: {'fast': 10.0, 'slow': 30.0}.entries,
    datasetIds: ['abcd1234ef'],
    engineVersion: 'dev',
  ),
  range: Window(fromUnixMs: ms(t0), toUnixMs: ms(t0.add(const Duration(days: 10)))),
  oosWindow: Window(fromUnixMs: ms(t0.add(const Duration(days: 2))), toUnixMs: ms(t0.add(const Duration(days: 8)))),
  holdoutWindow: Window(
    fromUnixMs: ms(t0.add(const Duration(days: 8))),
    toUnixMs: ms(t0.add(const Duration(days: 10))),
  ),
  summary: Summary(
    verdict: 'هنوز قابل اتکا نیست',
    tone: 'warning',
    sentence: 'جمله ساده',
    badges: [Badge(text: 'فقط 4 معامله', tone: 'warning')],
  ),
  oos: RunView(
    metrics: [
      metric('net_pnl', '1250000000', 8, 'USDT'),
      metric('gross_pnl', '1500000000', 8, 'USDT'),
      metric('fees', '150000000', 8, 'USDT'),
      metric('slippage', '100000000', 8, 'USDT'),
      metric('final_equity', '101250000000', 8, 'USDT'),
      metric('sharpe', '0', 2, 'number', valid: false, invalid: 'کمتر از 30 بازده روزانه'),
    ],
    equity: [
      pb.EquityPoint(tUnixMs: ms(t0.add(const Duration(days: 3))), equity: usdt('100000000000')),
      pb.EquityPoint(tUnixMs: ms(t0.add(const Duration(days: 7))), equity: usdt('101250000000')),
    ],
  ),
  groups: [MetricGroup(key: 'pnl', label: 'سود و زیان')],
  holdoutViews: 0,
  finalEquityToman: pb.Money(units: '110000000', scale: 0, asset: 'TOMAN'),
);

void main() {
  test('formatMetric reads each unit right and never shows an invalid number', () {
    final l = lookupL10n(const Locale('fa'));
    expect(formatMetric(l, metric('net_pnl', '1250000000', 8, 'USDT')).text, '+12.50');
    expect(formatMetric(l, metric('fees', '150000000', 8, 'USDT')).text, '−1.50', reason: 'costs read negative');
    expect(formatMetric(l, metric('total_return', '84000', 6, 'ratio')).text, '+8.40');
    expect(formatMetric(l, metric('max_drawdown', '112000', 6, 'ratio')).text, '−11.20');
    expect(formatMetric(l, metric('win_rate', '523000', 6, 'ratio')).text, '52.3');
    expect(formatMetric(l, metric('avg_holding', '90000', 0, 'seconds')).text, '1 روز');
    final bad = formatMetric(l, metric('sharpe', '123', 2, 'number', valid: false, invalid: 'x'));
    expect(bad.text, 'نامعتبر');
  });

  testWidgets('report: summary, waterfall, invalid metric, hidden holdout, Toman', (tester) async {
    await pump(tester, const ReportScreen(id: 'rp_1'), [
      reportProvider.overrideWith((ref, id) async => sampleReport()),
    ]);
    expect(find.text('هنوز قابل اتکا نیست'), findsOneWidget);
    expect(find.text('جمله ساده'), findsOneWidget);
    expect(find.text('فقط 4 معامله'), findsOneWidget);
    expect(find.text('نامعتبر'), findsOneWidget, reason: 'invalid Sharpe shows as invalid');
    expect(find.text('+12.50 USDT'), findsWidgets);
    expect(find.text('110,000,000 TOMAN'), findsOneWidget, reason: 'Toman from the engine, display only');
    expect(find.text('نمایش آزمون نهایی'), findsOneWidget, reason: 'holdout hidden until asked');
    expect(tester.takeException(), isNull);
  });

  testWidgets('report at 390 px has no overflow', (tester) async {
    await pump(tester, const ReportScreen(id: 'rp_1'), [
      reportProvider.overrideWith((ref, id) async => sampleReport()),
    ], size: const Size(390, 6000));
    expect(tester.takeException(), isNull);
  });

  testWidgets('compare: assumptions first, mismatch warned, eligibility in words', (tester) async {
    final c = CompareResponse(
      assumptions: [
        Assumption(key: 'fee', label: 'کارمزد هر سمت', values: ['+0.10%', '+0.20%'], differs: true, blocking: true),
        Assumption(key: 'strategy', label: 'راهبرد', values: ['a', 'b'], differs: true, blocking: false),
      ],
      columns: [
        CompareColumn(reportId: 'a', title: 'A', eligible: true, metrics: [metric('net_pnl', '100', 8, 'USDT')]),
        CompareColumn(
          reportId: 'b',
          title: 'B',
          eligible: false,
          reasons: ['کارمزد هر سمت متفاوت است'],
          metrics: [metric('net_pnl', '-100', 8, 'USDT')],
        ),
      ],
      conclusion: 'جمع‌بندی موتور',
    );
    await pump(tester, const CompareScreen(ids: ['a', 'b']), [compareProvider.overrideWith((ref, ids) async => c)]);
    expect(find.textContaining('1 تفاوت در فرض‌ها'), findsOneWidget);
    expect(find.text('متفاوت'), findsOneWidget);
    expect(find.text('در تفسیر لحاظ شود'), findsOneWidget, reason: 'non-blocking difference');
    expect(find.textContaining('خیر: کارمزد هر سمت متفاوت است'), findsOneWidget);
    expect(find.text('جمع‌بندی موتور'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
