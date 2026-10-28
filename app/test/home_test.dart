import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/core/theme/tokens.dart';
import 'package:trading_lab/features/home/home_screen.dart';
import 'package:trading_lab/gen/lab/v1/data.pb.dart';
import 'package:trading_lab/gen/lab/v1/experiment.pb.dart';
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/gen/lab/v1/learning.pb.dart';
import 'package:trading_lab/gen/lab/v1/report.pb.dart';
import 'package:trading_lab/l10n/app_localizations.dart';
import 'package:trading_lab/main.dart' show breakpoints;

import 'fake_transport.dart';

void main() {
  testWidgets('home: champion, schedule, queue, data health, last cycle, experiments, alerts', (tester) async {
    final fake = FakeTransport({
      'GetLearning': (_) => GetLearningResponse(
        config: LearningConfig(enabled: true, hourUtc: 3, minFreshBars: 168),
        active: ActiveModel(versionId: 'ridge-h4@v2', modelId: 'm_7c21', modelAsOfUnixMs: Int64(1730000000000)),
        current: Cycle(
          id: Int64(41),
          trigger: 'schedule',
          state: 'done',
          outcome: 'skipped',
          reason: 'پرش: داده تازه ناکافی',
          steps: [CycleStep(key: 'collect', status: 'done', meta: '+24 bars')],
        ),
      ),
      'ListExperiments': (_) => ListExperimentsResponse(
        total: Int64(1),
        experiments: [
          ExperimentSummary(
            id: 'exp_1',
            name: 'جست‌وجوی روند',
            status: 'running',
            counts: AttemptCounts(running: 2, queued: 7, done: 3, total: 12),
          ),
        ],
      ),
      'GetOverview': (_) => GetOverviewResponse(symbols: ['BTCUSDT', 'ETHUSDT']),
      'ListQualityIssues': (_) => ListQualityIssuesResponse(
        total: Int64(1),
        issues: [QualityIssue(symbol: 'ETHUSDT', kind: 'gap', detail: '17 minutes missing')],
      ),
      'ListReports': (_) => ListReportsResponse(
        reports: [ReportListItem(id: 'rp_1', title: 'trend-ema · BTCUSDT', holdoutViews: 1)],
      ),
    });
    tester.view.physicalSize = const Size(1440, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        retry: apiRetry,
        overrides: [
          transportProvider.overrideWithValue(fake),
          engineStatusProvider.overrideWith((ref) => Stream.value(EngineStatus())),
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
          builder: (context, c) => ResponsiveBreakpoints.builder(breakpoints: breakpoints, child: c!),
          home: const Scaffold(body: HomeScreen()),
        ),
      ),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);

    expect(find.text('ridge-h4@v2'), findsOneWidget);
    expect(find.text('03:00 UTC'), findsOneWidget);
    expect(find.text('2 در حال اجرا · 7 در صف'), findsOneWidget);
    expect(find.text('2 جفت · 1 هشدار'), findsOneWidget);
    expect(find.textContaining('چرخه #41'), findsOneWidget);
    expect(find.text('جست‌وجوی روند'), findsOneWidget);
    expect(find.textContaining('17 minutes missing'), findsOneWidget, reason: 'data alert');
    expect(find.textContaining('trend-ema · BTCUSDT'), findsOneWidget, reason: 'holdout alert');
    expect(find.textContaining('#41: پرش'), findsOneWidget, reason: 'skipped cycle alert');
  });
}
