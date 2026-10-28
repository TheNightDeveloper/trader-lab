import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/app/nav.dart';
import 'package:trading_lab/app/router.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/main.dart';

EngineStatus _status({int workers = 8}) => EngineStatus(
  mode: RunMode.RUN_MODE_RESEARCH,
  accountingAsset: 'USDT',
  live: LiveData(state: LiveState.LIVE_STATE_OFF),
  workers: Workers(state: WorkerState.WORKER_STATE_RUNNING, count: workers),
);

/// pumpAndSettle never returns while status dots pulse, so run frames for ~1 s.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<StreamController<EngineStatus>> _pumpApp(WidgetTester tester, Size size, {String at = '/'}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final health = StreamController<EngineStatus>.broadcast();
  addTearDown(health.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [engineStatusProvider.overrideWith((ref) => health.stream)],
      child: LabApp(router: buildRouter(initialLocation: at)),
    ),
  );
  await _settle(tester); // entrance animations
  return health;
}

void main() {
  testWidgets('desktop: RTL sidebar, live status, navigation', (tester) async {
    final health = await _pumpApp(tester, const Size(1440, 1600)); // tall: whole sidebar built

    expect(Directionality.of(tester.element(find.text('خانه').first)), TextDirection.rtl);
    for (final label in ['کتابخانه الگوریتم', 'چرخه یادگیری', 'داده', 'تنظیمات']) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.text('فاز ۲'), findsNWidgets(4), reason: 'Phase 2 items are badged');
    expect(find.byTooltip('باز کردن منو'), findsNothing, reason: 'no drawer at desktop width');

    health.add(_status());
    await _settle(tester);
    expect(find.text('فعال · 8 کارگر'), findsOneWidget);
    expect(find.text('هنوز نرخی ثبت نشده'), findsOneWidget);

    await tester.tap(find.text('چرخه یادگیری').first);
    await _settle(tester);
    expect(find.text('چرخه یادگیری'), findsNWidgets(2), reason: 'sidebar entry and page title');
  });

  testWidgets('engine down: banner shows and last status stays visible', (tester) async {
    final health = await _pumpApp(tester, const Size(1440, 900));
    health.add(_status(workers: 3));
    await _settle(tester);

    health.addError(Exception('connection refused'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('موتور در دسترس نیست'), findsOneWidget);
    expect(find.text('قطع'), findsOneWidget);
    expect(find.text('USDT'), findsWidgets, reason: 'last known values stay on screen');

    // Reconnect (provider retries onto the same broadcast stream).
    await _settle(tester);
    health.add(_status(workers: 3));
    await _settle(tester);
    expect(find.textContaining('موتور در دسترس نیست'), findsNothing);
    expect(find.text('فعال · 3 کارگر'), findsOneWidget);
  });

  testWidgets('390 px: sidebar becomes a drawer', (tester) async {
    await _pumpApp(tester, const Size(390, 844), at: '/experiments/abc/queue');
    expect(find.text('کتابخانه الگوریتم'), findsNothing);
    expect(find.text('صف اجرا و جست‌وجو'), findsOneWidget, reason: 'deep link resolves to the queue');

    await tester.tap(find.byTooltip('باز کردن منو'));
    await _settle(tester);
    expect(find.text('کتابخانه الگوریتم'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'no overflow at 390 px');
  });

  test('Dest.of picks the right sidebar entry', () {
    expect(Dest.of('/'), Dest.home);
    expect(Dest.of('/experiments/new'), Dest.builder);
    expect(Dest.of('/experiments/abc/queue'), Dest.queue);
    expect(Dest.of('/reports/42'), Dest.reports);
    expect(Dest.of('/nope'), isNull);
  });
}
