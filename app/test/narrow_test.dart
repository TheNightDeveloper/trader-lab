import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/app/router.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/gen/lab/v1/data.pb.dart';
import 'package:trading_lab/gen/lab/v1/experiment.pb.dart';
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/gen/lab/v1/library.pb.dart';
import 'package:trading_lab/gen/lab/v1/report.pb.dart';
import 'package:trading_lab/main.dart';

import 'chart_test.dart' as chart;
import 'experiments_test.dart' as exp;
import 'fake_transport.dart';
import 'learning_test.dart' as learning;
import 'report_test.dart' as report;

/// Every route at 390 px with realistic data where we have fixtures and empty
/// engine answers elsewhere (empty states). Any overflow or exception fails the
/// test through the framework, with the widget that caused it.
FakeTransport engine() {
  final counts = AttemptCounts(queued: 186, running: 2, done: 290, failed: 15, cancelled: 7, total: 500);
  final summary = ExperimentSummary(
    id: 'exp_1',
    name: 'جست‌وجوی روند با نام طولانی برای آزمون شکستن خط',
    status: 'running',
    algorithmVersion: 'trend-ema@v1',
    counts: counts,
  );
  return FakeTransport(
    {
      ...learning.fake(ready: true).unaries,
      'GetChart': (_) => chart.chart(),
      'GetReport': (_) => GetReportResponse(report: report.sampleReport()),
      'ListReports': (_) => ListReportsResponse(
        total: Int64(1),
        reports: [ReportListItem(id: 'rp_1', title: 'trend-ema · BTCUSDT · 1h', holdoutViews: 1)],
      ),
      'ListExperiments': (_) => ListExperimentsResponse(total: Int64(1), experiments: [summary]),
      'GetExperiment': (_) => GetExperimentResponse(summary: summary, definition: ExperimentDefinition()),
      'ListAttempts': (_) => ListAttemptsResponse(
        total: Int64(1),
        attempts: [
          AttemptRow(
            seq: 3,
            params: {'fast': 9.0, 'slow': 20.0}.entries,
            symbol: 'BTCUSDT',
            status: 'done',
            totalReturn: exp.ratio('total_return', '117000'),
            maxDrawdown: exp.ratio('max_drawdown', '241000'),
            hasEligibility: true,
            violations: ['بیشترین افت سرمایه \u2066<= 0.2\u2069 نیست'],
            cache: 'miss',
          ),
        ],
      ),
      'ListAlgorithms': (_) => ListAlgorithmsResponse(algorithms: [exp.trendEma()]),
      'ListDatasets': (_) => ListDatasetsResponse(datasets: [exp.dataset('aaaa1111', 'BTCUSDT', '1h')]),
      'GetOverview': (_) => GetOverviewResponse(symbols: ['BTCUSDT', 'ETHUSDT']),
      'ListQualityIssues': (_) => ListQualityIssuesResponse(
        total: Int64(1),
        issues: [QualityIssue(symbol: 'ETHUSDT', kind: 'gap', detail: '17 minutes missing between two bars')],
      ),
    },
    streams: {
      'WatchExperiment': (_) => Stream.value(
        WatchExperimentResponse(status: 'running', counts: counts, attemptBudget: 500, researchSlots: 3),
      ),
    },
  );
}

const routes = [
  '/',
  '/library',
  '/experiments/new',
  '/queue',
  '/experiments/exp_1/queue',
  '/reports',
  '/reports/rp_1',
  '/compare?ids=rp_1,rp_2',
  '/pnl',
  '/learning',
  '/chart?report=rp_1',
  '/data',
  '/settings',
];

void main() {
  for (final at in routes) {
    testWidgets('390 px: $at', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          retry: apiRetry,
          overrides: [
            transportProvider.overrideWithValue(engine()),
            engineStatusProvider.overrideWith((ref) => Stream.value(EngineStatus(accountingAsset: 'USDT'))),
          ],
          child: LabApp(router: buildRouter(initialLocation: at)),
        ),
      );
      await settle(tester, 30);
      // Scroll to the bottom: lower sections lay out too.
      final scroll = find.byType(Scrollable).first;
      await tester.drag(scroll, const Offset(0, -4000));
      await settle(tester, 10);
    });
  }
}
