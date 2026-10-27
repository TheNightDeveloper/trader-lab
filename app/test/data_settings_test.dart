import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/core/theme/tokens.dart';
import 'package:trading_lab/features/data/data_providers.dart';
import 'package:trading_lab/features/data/data_screen.dart';
import 'package:trading_lab/features/settings/settings_screen.dart';
import 'package:trading_lab/gen/lab/v1/common.pb.dart';
import 'package:trading_lab/gen/lab/v1/data.pb.dart';
import 'package:trading_lab/gen/lab/v1/fx.pb.dart';
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/l10n/app_localizations.dart';
import 'package:trading_lab/main.dart' show breakpoints;

final now = DateTime.utc(2024, 3, 10, 12);
Int64 ms(DateTime t) => Int64(t.millisecondsSinceEpoch);

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 20; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
}

Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen,
  List overrides, {
  Size size = const Size(1440, 2400),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: apiRetry,
      overrides: [
        engineStatusProvider.overrideWith(
          (ref) => Stream.value(
            EngineStatus(
              live: LiveData(state: LiveState.LIVE_STATE_FRESH, lastBarAgeSeconds: Int64(4)),
            ),
          ),
        ),
        ...overrides.cast(),
      ],
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
        builder: (context, child) => ResponsiveBreakpoints.builder(breakpoints: breakpoints, child: child!),
        home: Scaffold(body: screen),
      ),
    ),
  );
  await settle(tester);
}

final overview = GetOverviewResponse(
  liveSymbols: 6,
  outagesToday: 2,
  outageSecondsToday: Int64(360),
  storageBytes: Int64(41019805696),
  symbols: ['BNBUSDT', 'BTCUSDT', 'ETHBTC', 'ETHUSDT', 'SOLUSDT', 'XRPUSDT'],
);

List dataOverrides({ListDatasetsResponse? datasets, Object? coverageError}) => [
  overviewProvider.overrideWith((ref) async => overview),
  datasetsProvider.overrideWith(
    (ref, offset) async =>
        datasets ??
        ListDatasetsResponse(
          total: Int64(1),
          datasets: [
            Dataset(
              id: '7f3a9d00000000000000000000000000000000000000000000000000000000c1',
              symbol: 'BTCUSDT',
              timeframe: '1h',
              fromUnixMs: ms(DateTime.utc(2024, 1, 1)),
              toUnixMs: ms(DateTime.utc(2024, 1, 3)),
              barCount: 48,
              gaps: 1,
            ),
          ],
        ),
  ),
  coverageProvider.overrideWith((ref) async {
    if (coverageError != null) throw coverageError;
    return GetCoverageResponse(
      coverage: [
        Coverage(
          symbol: 'BTCUSDT',
          firstOpenUnixMs: ms(DateTime.utc(2024, 1, 1)),
          lastOpenUnixMs: ms(DateTime.utc(2024, 1, 2, 23, 59)),
          bars: Int64(2875),
          segments: [TimeRange(fromUnixMs: ms(DateTime.utc(2024, 1, 1)), untilUnixMs: ms(DateTime.utc(2024, 1, 3)))],
          problems: [
            TimeRange(
              fromUnixMs: ms(DateTime.utc(2024, 1, 1, 1, 40)),
              untilUnixMs: ms(DateTime.utc(2024, 1, 1, 1, 45)),
            ),
          ],
        ),
      ],
    );
  }),
  issuesProvider.overrideWith(
    (ref, offset) async => ListQualityIssuesResponse(
      total: Int64(1),
      issues: [
        QualityIssue(
          kind: 'gap',
          symbol: 'BTCUSDT',
          atUnixMs: ms(DateTime.utc(2024, 1, 1, 1, 40)),
          untilUnixMs: ms(DateTime.utc(2024, 1, 1, 1, 45)),
          detail: '5 missing 1m bars',
        ),
      ],
    ),
  ),
];

void main() {
  testWidgets('Data screen shows engine data with units and states', (tester) async {
    await pumpScreen(tester, DataScreen(now: now), dataOverrides());
    expect(find.text('6 جفت · REST'), findsOneWidget);
    expect(find.text('4 ثانیه'), findsOneWidget);
    expect(find.text('2 · مجموع 6 دقیقه'), findsOneWidget);
    expect(find.text('38.2 GB'), findsOneWidget);
    expect(find.text('ds:7f3a…c1'), findsOneWidget);
    expect(find.text('2024-01-01 → 2024-01-02'), findsOneWidget, reason: 'exclusive end shown as the last day');
    expect(find.text('1 شکاف'), findsOneWidget);
    expect(find.text('شکاف'), findsOneWidget, reason: 'issue kind is text, not only color');
    expect(find.text('5 missing 1m bars'), findsOneWidget);
    expect(find.text('BTCUSDT'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Data screen: empty and error states offer a next action', (tester) async {
    await pumpScreen(
      tester,
      DataScreen(now: now),
      dataOverrides(datasets: ListDatasetsResponse(), coverageError: Exception('connection refused')),
    );
    expect(find.textContaining('هنوز نسخه‌ای از داده ساخته نشده است'), findsOneWidget);
    expect(find.textContaining('connection refused'), findsOneWidget);
    expect(find.text('تلاش دوباره'), findsOneWidget);
  });

  testWidgets('Import form validates before calling the engine', (tester) async {
    await pumpScreen(tester, DataScreen(now: now), dataOverrides());
    await tester.tap(find.text('BTCUSDT').last); // deselect the default pair
    await tester.enterText(find.widgetWithText(TextField, 'از'), '2024-02-31');
    await tester.tap(find.text('واردسازی و ساخت نسخه'));
    await settle(tester);
    expect(find.text('دست‌کم یک جفت انتخاب کنید.'), findsOneWidget);
    expect(find.text('تاریخ را به شکل 2024-01-31 وارد کنید.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'از'), '2024-03-09');
    await tester.enterText(find.widgetWithText(TextField, 'تا'), '2024-03-01');
    await settle(tester);
    expect(find.text('«از» باید پیش از «تا» باشد و «تا» از امروز نگذرد.'), findsOneWidget);
  });

  testWidgets('Data screen at 390 px has no overflow', (tester) async {
    await pumpScreen(tester, DataScreen(now: now), dataOverrides(), size: const Size(390, 3200));
    expect(tester.takeException(), isNull);
    expect(find.text('واردسازی تاریخچه'), findsOneWidget, reason: 'import form stacks below');
  });

  List settingsOverrides(List<FxRate> rates) => [
    ratesProvider.overrideWith((ref) async => ListRatesResponse(rates: rates)),
  ];

  testWidgets('Settings: rate history and validation', (tester) async {
    await pumpScreen(
      tester,
      SettingsScreen(today: now),
      settingsOverrides([
        FxRate(
          id: Int64(2),
          date: '2024-03-10',
          tomanPerUsdt: Money(units: '6012350', scale: 2, asset: 'TOMAN'),
          source: 'manual',
          enteredUnixMs: ms(now),
        ),
      ]),
    );
    expect(find.text('60,123.5 TOMAN'), findsOneWidget);
    expect(find.text('دستی'), findsOneWidget);
    expect(find.text('2024-03-10'), findsWidgets, reason: 'date field defaults to today; history row');

    await tester.enterText(find.widgetWithText(TextField, 'نرخ امروز (تومان به ازای ۱ USDT)'), '60000.123');
    await tester.enterText(find.widgetWithText(TextField, 'تاریخ اعمال'), '2024-03-11');
    await tester.tap(find.text('ثبت نرخ'));
    await settle(tester);
    expect(find.text('نرخ باید عددی مثبت با حداکثر دو رقم اعشار باشد.'), findsOneWidget);
    expect(find.text('تاریخ نمی‌تواند در آینده باشد.'), findsOneWidget);
  });

  testWidgets('Settings: empty history and 390 px', (tester) async {
    await pumpScreen(tester, SettingsScreen(today: now), settingsOverrides([]), size: const Size(390, 2400));
    expect(find.textContaining('هنوز نرخی ثبت نشده است'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('validRate matches the engine rule', () {
    expect(validRate('60000'), isTrue);
    expect(validRate('60000.12'), isTrue);
    expect(validRate('0'), isFalse);
    expect(validRate('60000.123'), isFalse);
    expect(validRate('6e4'), isFalse);
    expect(validRate('-5'), isFalse);
  });
}
