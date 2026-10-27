import 'dart:convert';

import 'package:connectrpc/connect.dart' as connect;
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
import 'package:trading_lab/features/experiments/builder_screen.dart';
import 'package:trading_lab/features/experiments/queue_screen.dart';
import 'package:trading_lab/features/library/library_screen.dart';
import 'package:trading_lab/gen/lab/v1/common.pb.dart' as pb;
import 'package:trading_lab/gen/lab/v1/data.pb.dart';
import 'package:trading_lab/gen/lab/v1/experiment.pb.dart';
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/gen/lab/v1/library.pb.dart';
import 'package:trading_lab/gen/lab/v1/report.pb.dart' show ParamSpec;
import 'package:trading_lab/l10n/app_localizations.dart';
import 'package:trading_lab/main.dart' show breakpoints;

/// Answers RPCs by method name and records every request, so screens run on
/// their real providers and clients.
class FakeTransport implements connect.Transport {
  FakeTransport(this.unaries, {this.streams = const {}});
  final Map<String, Object Function(Object)> unaries;
  final Map<String, Stream<Object> Function(Object)> streams;
  final calls = <String, List<Object>>{};

  String _name(connect.Spec spec) => spec.procedure.split('/').last;

  @override
  Future<connect.UnaryResponse<I, O>> unary<I extends Object, O extends Object>(
    connect.Spec<I, O> spec,
    I input, [
    connect.CallOptions? options,
  ]) async {
    final n = _name(spec);
    (calls[n] ??= []).add(input);
    final h = unaries[n];
    return connect.UnaryResponse(
      spec,
      connect.Headers(),
      h == null ? spec.outputFactory() : h(input) as O,
      connect.Headers(),
    );
  }

  @override
  Future<connect.StreamResponse<I, O>> stream<I extends Object, O extends Object>(
    connect.Spec<I, O> spec,
    Stream<I> input, [
    connect.CallOptions? options,
  ]) async {
    final n = _name(spec);
    final req = await input.first;
    (calls[n] ??= []).add(req);
    return connect.StreamResponse(spec, connect.Headers(), streams[n]!(req).cast<O>(), connect.Headers());
  }
}

Future<void> settle(WidgetTester t, [int frames = 20]) async {
  for (var i = 0; i < frames; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
}

Future<void> pumpAt(WidgetTester tester, String at, FakeTransport fake) async {
  tester.view.physicalSize = const Size(1440, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: at,
    routes: [
      GoRoute(
        path: '/library',
        builder: (_, _) => const Scaffold(body: LibraryScreen()),
      ),
      GoRoute(
        path: '/experiments/new',
        builder: (_, s) => Scaffold(body: BuilderScreen(algo: s.uri.queryParameters['algo'])),
      ),
      GoRoute(
        path: '/experiments/:id/queue',
        builder: (_, s) => Scaffold(body: ExperimentQueueScreen(id: s.pathParameters['id']!)),
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
}

pb.Metric ratio(String key, String units) => pb.Metric(
  key: key,
  value: pb.Decimal(units: units, scale: 6),
  unit: 'ratio',
  valid: true,
);

Int64 ms(DateTime t) => Int64(t.millisecondsSinceEpoch);

Dataset dataset(String id, String symbol, String tf) => Dataset(
  id: id,
  symbol: symbol,
  timeframe: tf,
  fromUnixMs: ms(DateTime.utc(2024)),
  toUnixMs: ms(DateTime.utc(2025)),
);

Algorithm trendEma({String state = 'research', List<String> next = const ['validation', 'retired']}) => Algorithm(
  id: 'trend-ema',
  family: 'trend',
  description: 'تقاطع میانگین متحرک',
  versions: [
    AlgorithmVersion(
      id: 'trend-ema@v1',
      version: 1,
      state: state,
      contentHash: 'abcdef0123456789',
      params: [
        ParamSpec(name: 'fast', default_2: 12, integer: true),
        ParamSpec(name: 'slow', default_2: 26, integer: true),
        ParamSpec(name: 'exposure', default_2: 1),
      ],
      nextStates: next,
    ),
  ],
);

void main() {
  test('parameter values: commas (Latin or Persian), positive, whole for integers', () {
    expect(parseValues('9, 12،15  12', true), [9, 12, 15]);
    expect(parseValues('', true), isEmpty, reason: 'empty keeps the default');
    expect(parseValues('1.5', true), isNull);
    expect(parseValues('0, 2', false), isNull);
    expect(parseValues('1.5, 2.5', false), [1.5, 2.5]);
    final v = trendEma().versions.first;
    expect(prefill(v, 'search'), {
      'fast': '9, 12, 15',
      'slow': '20, 26, 33',
    }, reason: 'exposure is sizing, not searched');
    expect(prefill(v, 'idea'), {'fast': '12, 18'});
    expect(prefill(v, 'quick'), isEmpty);
  });

  testWidgets('builder: six steps, one dataset per pair, estimate, locked definition', (tester) async {
    localRemove(draftKey);
    final fake = FakeTransport(
      {
        'ListDatasets': (_) => ListDatasetsResponse(
          datasets: [
            dataset('dddd4444', 'BTCUSDT', '1m'),
            dataset('aaaa1111', 'BTCUSDT', '1h'),
            dataset('bbbb2222', 'BTCUSDT', '1h'),
            dataset('cccc3333', 'ETHUSDT', '1h'),
          ],
        ),
        'ListAlgorithms': (_) => ListAlgorithmsResponse(algorithms: [trendEma()]),
        'Estimate': (_) => EstimateResponse(attempts: 18, candidates: 9, estimatedSeconds: Int64(120)),
        'CreateExperiment': (_) => CreateExperimentResponse(experimentId: 'exp_1'),
        'GetExperiment': (_) => GetExperimentResponse(
          summary: ExperimentSummary(id: 'exp_1', status: 'running'),
        ),
        'ListAttempts': (_) => ListAttemptsResponse(),
      },
      streams: {'WatchExperiment': (_) => Stream.value(WatchExperimentResponse(status: 'running'))},
    );
    await pumpAt(tester, '/experiments/new', fake);

    await tester.tap(find.text('یافتن بهترین تنظیمات').first); // the card, not the summary
    await settle(tester);
    expect(find.text('چه چیزی را می‌خواهید بسنجید؟'), findsOneWidget, reason: 'a template jumps to step 1');

    await tester.tap(find.text('بعدی'));
    await settle(tester);
    expect(find.text('ایده و نتیجه ردکننده را بنویسید.'), findsOneWidget, reason: 'cannot pass step 1 empty');

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'فیلتر روند');
    await tester.enterText(fields.at(1), 'روند سریع‌تر بهتر است');
    await tester.enterText(fields.at(2), 'بازده کمتر از معیار');
    expect(localGet(draftKey), contains('فیلتر روند'), reason: 'draft auto-saved');
    await tester.tap(find.text('بعدی'));
    await settle(tester);

    await tester.tap(find.text('1h'));
    await settle(tester);
    for (final id in ['ds:aaaa', 'ds:bbbb', 'ds:cccc']) {
      await tester.tap(find.textContaining(id));
      await settle(tester, 2);
    }
    await tester.tap(find.text('بعدی'));
    await settle(tester);

    await tester.tap(find.text('trend-ema@v1').first);
    await settle(tester);
    expect(find.text('9, 12, 15'), findsOneWidget, reason: 'search template suggests values around defaults');
    await tester.tap(find.text('بعدی'));
    await settle(tester);
    expect(find.textContaining('0.30%'), findsOneWidget, reason: 'round-trip cost: 2 × (10 + 5) bps');
    await tester.tap(find.text('بعدی'));
    await settle(tester);
    expect(find.text('18 اجرا · 9 نامزد'), findsOneWidget, reason: 'run count from Estimate');

    await tester.tap(find.text('ثبت و اجرا'));
    await settle(tester);
    final def = (fake.calls['CreateExperiment']!.single as CreateExperimentRequest).definition;
    expect(def.datasetIds, ['bbbb2222', 'cccc3333'], reason: 'the second BTCUSDT version replaced the first');
    expect(def.algorithmVersion, 'trend-ema@v1');
    expect(def.objective.metric, 'total_return');
    expect(
      [for (final c in def.constraints) '${c.metric} ${c.op} ${c.value}'],
      ['max_drawdown <= 0.25', 'closed_trades >= 10'],
    );
    expect(def.space['fast']!.values, [9, 12, 15]);
    expect(def.space.containsKey('exposure'), isFalse);
    expect((def.fee.units, def.fee.scale), ('1000', 6), reason: '10 bps exactly');
    expect((def.capital.units, def.capital.asset), ('1000000000000', 'USDT'));
    expect(def.search.maxWallSeconds, 3600);
    expect(find.byType(ExperimentQueueScreen), findsOneWidget, reason: 'opens the queue');
    expect(localGet(draftKey), isNull, reason: 'draft cleared once locked');
  });

  testWidgets('builder: a saved draft comes back', (tester) async {
    localSet(
      draftKey,
      jsonEncode({
        'f': {'name': 'پیش‌نویس من', 'tpl': 'quick'},
        'ds': <String>[],
        'vals': <String, String>{},
        'rolling': false,
        'step': 1,
        'reached': 1,
      }),
    );
    await pumpAt(tester, '/experiments/new', FakeTransport({}));
    expect(find.text('پیش‌نویس قبلی بازیابی شد.'), findsOneWidget);
    expect(find.text('پیش‌نویس من'), findsOneWidget);
    await tester.tap(find.text('شروع از نو'));
    await settle(tester);
    expect(localGet(draftKey), isNull);
    expect(find.text('چه کاری می‌خواهید انجام دهید؟'), findsOneWidget);
  });

  testWidgets('queue: progress, budget, rejected attempts, tabs, cancel behind a confirm', (tester) async {
    final counts = AttemptCounts(queued: 186, running: 2, done: 290, failed: 15, cancelled: 7, total: 500);
    final fake = FakeTransport(
      {
        'GetExperiment': (_) => GetExperimentResponse(
          summary: ExperimentSummary(
            id: 'exp_1',
            name: 'جست‌وجو',
            status: 'running',
            algorithmVersion: 'trend-ema@v1',
            counts: counts,
          ),
          definition: ExperimentDefinition(
            search: SearchPlan(mode: 'grid', seed: Int64(7)),
          ),
        ),
        'ListAttempts': (_) => ListAttemptsResponse(
          total: Int64(1),
          attempts: [
            AttemptRow(
              seq: 3,
              candidate: 2,
              params: {'slow': 20.0, 'fast': 9.0}.entries,
              symbol: 'BTCUSDT',
              status: 'done',
              totalReturn: ratio('total_return', '117000'),
              maxDrawdown: ratio('max_drawdown', '241000'),
              hasEligibility: true,
              violations: ['max_drawdown <= 0.25'],
              cache: 'miss',
              runs: 1,
            ),
          ],
        ),
      },
      streams: {
        'WatchExperiment': (_) => Stream.value(
          WatchExperimentResponse(
            status: 'running',
            counts: counts,
            elapsedSeconds: Int64(600),
            wallBudgetSeconds: Int64(3600),
            attemptBudget: 500,
            cacheHits: 4,
            cacheLooked: 10,
            researchSlots: 3,
            researchSlotsInUse: 2,
          ),
        ),
      },
    );
    await pumpAt(tester, '/experiments/exp_1/queue', fake);

    expect(find.text('312 / 500'), findsNWidgets(2), reason: 'progress line and attempts against the budget');
    expect(find.text('10 دقیقه / 1 ساعت'), findsOneWidget, reason: 'durations flow RTL as words');
    expect(find.text('2 / 3'), findsOneWidget, reason: 'research slots in use');
    expect(find.text('40%'), findsOneWidget, reason: 'cache hit rate');
    expect(find.text('fast=9 slow=20'), findsOneWidget);
    expect(find.text('+11.70 %'), findsOneWidget);
    expect(find.text('رد: max_drawdown <= 0.25'), findsOneWidget);

    await tester.tap(find.text('شکست').last); // the tab, after the legend
    await settle(tester);
    expect((fake.calls['ListAttempts']!.last as ListAttemptsRequest).status, 'failed', reason: 'filters server-side');

    await tester.tap(find.text('لغو آزمایش'));
    await settle(tester);
    expect(find.textContaining('همه تلاش‌های انجام‌شده ثبت می‌مانند'), findsOneWidget);
    expect(fake.calls['CancelExperiment'], isNull, reason: 'nothing happens before confirming');
    await tester.tap(find.text('تأیید'));
    await settle(tester);
    expect((fake.calls['CancelExperiment']!.single as CancelExperimentRequest).experimentId, 'exp_1');
  });

  testWidgets('library: family filter, lock note, lifecycle move behind a confirm', (tester) async {
    final fake = FakeTransport({
      'ListAlgorithms': (_) => ListAlgorithmsResponse(
        algorithms: [
          trendEma(state: 'active', next: ['stopped']),
          Algorithm(
            id: 'mean-rev-bands',
            family: 'mean_reversion',
            description: 'باند بولینگر',
            versions: [AlgorithmVersion(id: 'mean-rev-bands@v1', version: 1, state: 'research')],
          ),
        ],
      ),
      'ListLifecycleEvents': (_) => ListLifecycleEventsResponse(
        events: [LifecycleEvent(fromState: 'forward_test', toState: 'active', actor: 'user', note: 'تأیید دستی')],
      ),
    });
    await pumpAt(tester, '/library', fake);

    expect(find.textContaining('قواعد و پارامترهای نسخه فعال قفل‌اند'), findsOneWidget);
    expect(find.text('تأیید دستی'), findsOneWidget, reason: 'lifecycle history');

    await tester.tap(find.text('انتقال به «متوقف»'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'افت زیاد');
    await tester.tap(find.text('تأیید'));
    await settle(tester);
    final req = fake.calls['SetVersionState']!.single as SetVersionStateRequest;
    expect((req.versionId, req.state, req.note), ('trend-ema@v1', 'stopped', 'افت زیاد'));

    await tester.tap(find.text('بازگشت به میانگین').first); // the chip, not the card label
    await settle(tester);
    expect(find.text('trend-ema'), findsNothing, reason: 'filtered out');
    expect(find.text('mean-rev-bands'), findsWidgets);
  });
}
