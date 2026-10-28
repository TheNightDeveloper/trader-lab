import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/core/theme/tokens.dart';
import 'package:trading_lab/features/learning/learning_screen.dart';
import 'package:trading_lab/gen/lab/v1/common.pb.dart' as pb;
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/gen/lab/v1/learning.pb.dart';
import 'package:trading_lab/l10n/app_localizations.dart';
import 'package:trading_lab/main.dart' show breakpoints;

import 'fake_transport.dart';

pb.Decimal frac(String units) => pb.Decimal(units: units, scale: 6);
pb.Metric ratio(String key, String units) => pb.Metric(
  key: key,
  value: pb.Decimal(units: units, scale: 6),
  unit: 'ratio',
  valid: true,
);

LearningConfig config() => LearningConfig(
  algorithmId: 'ridge-h4',
  symbols: ['BTCUSDT'],
  timeframe: '1h',
  lookbackDays: 180,
  enabled: true,
  hourUtc: 3,
  minFreshBars: 168,
  folds: 4,
  maxCandidates: 30,
  cpuMinutes: 45,
  maxBars: Int64(2000000),
  seed: Int64(42),
  capital: pb.Money(units: '1000000000000', scale: 8, asset: 'USDT'),
  fee: frac('1000'),
  slippage: frac('500'),
  gate: LearningGate(
    maxDrawdown: frac('200000'),
    minForwardTrades: 20,
    forwardDays: 14,
    minImprovement: frac('10000'),
    maxDdDegradation: frac('10000'),
    minWalkWins: 3,
  ),
);

Cycle cycle({required bool ready}) => Cycle(
  id: Int64(42),
  algorithmId: 'ridge-h4',
  trigger: 'schedule',
  state: ready ? 'decision' : 'forward_test',
  outcome: ready ? 'recommended' : '',
  reason: ready ? 'همه شرط‌های دروازه برقرار است' : '',
  forwardDays: ready ? 14 : 9,
  forwardDaysTarget: 14,
  candidates: 22,
  canApprove: ready,
  steps: [
    for (final k in ['collect', 'labels', 'generate', 'train', 'walk_forward'])
      CycleStep(key: k, status: 'done', meta: k == 'generate' ? '22 candidates' : ''),
    CycleStep(key: 'forward_test', status: ready ? 'done' : 'waiting', meta: ready ? '14 / 14 d' : '9 / 14 d'),
    CycleStep(key: 'decision', status: ready ? 'waiting' : 'pending'),
  ],
  gate: [
    GateItem(key: 'improvement', status: 'pass', text: 'بازده خالص پیشرو ≥ قهرمان + 1.00 واحد درصد'),
    GateItem(key: 'days', status: ready ? 'pass' : 'pending', text: 'حداقل 14 روز آزمون پیشرو'),
  ],
  champion: Contender(
    versionId: 'ridge-h4@v7',
    modelId: 'm_7c21',
    active: true,
    forward: [ratio('total_return', '19000')],
  ),
  challenger: Contender(modelId: 'm_9a04', change: '+ret_72', seq: 5, forward: [ratio('total_return', '30000')]),
  usage: CycleUsage(
    cpuSeconds: Int64(1080),
    cpuBudgetSeconds: Int64(2700),
    candidates: 22,
    maxCandidates: 30,
    bars: Int64(4368),
    maxBars: Int64(2000000),
  ),
);

FakeTransport fake({required bool ready}) => FakeTransport({
  'GetLearning': (_) => GetLearningResponse(
    config: config(),
    current: cycle(ready: ready),
    active: ActiveModel(algorithmId: 'ridge-h4', versionId: 'ridge-h4@v7', modelId: 'm_7c21'),
    canRollback: true,
    learningAlgorithms: ['ridge-h4', 'logit-dir-h1'],
  ),
  'ListCycles': (_) => ListCyclesResponse(
    total: Int64(2),
    cycles: [
      cycle(ready: ready),
      Cycle(id: Int64(41), trigger: 'manual', state: 'done', outcome: 'not_better', candidates: 18),
    ],
  ),
  'ListModels': (_) => ListModelsResponse(
    models: [
      ModelInfo(id: 'm_9a04', status: 'challenger', recipeHash: 'abcdef0123', seed: Int64(42)),
      ModelInfo(id: 'm_7c21', versionId: 'ridge-h4@v7', status: 'active', recipeHash: '0123abcdef', seed: Int64(42)),
    ],
  ),
});

Future<void> pumpLearning(WidgetTester tester, FakeTransport f) async {
  tester.view.physicalSize = const Size(1440, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: apiRetry,
      overrides: [
        transportProvider.overrideWithValue(f),
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
        home: const Scaffold(body: LearningScreen()),
      ),
    ),
  );
  await settle(tester);
}

ButtonStyleButton button(WidgetTester t, String text) =>
    t.widget<ButtonStyleButton>(find.ancestor(of: find.text(text), matching: find.bySubtype<ButtonStyleButton>()));

void main() {
  testWidgets('approval waits for the gate, and only goes through after a confirm', (tester) async {
    final waiting = fake(ready: false);
    await pumpLearning(tester, waiting);
    expect(find.textContaining('بازآموزی روزانه 03:00 UTC'), findsOneWidget);
    expect(find.text('روز 9 از 14'), findsOneWidget);
    expect(find.text('در انتظار'), findsOneWidget, reason: 'a pending gate item is labelled, not only colored');
    expect(button(tester, 'تأیید ارتقا (پس از دروازه)').onPressed, isNull, reason: 'gate not passed yet');
    expect(button(tester, 'اجرای چرخه اکنون').onPressed, isNull, reason: 'one open cycle at a time');
    expect(find.text('+3.00 %'), findsNWidgets(2), reason: 'challenger forward return: card and history');
    expect(find.text('نامزد بهتر نیست'), findsOneWidget, reason: 'history');

    final ready = fake(ready: true);
    await pumpLearning(tester, ready);
    expect(find.text('منتظر شما'), findsOneWidget);
    await tester.tap(find.text('تأیید ارتقا (پس از دروازه)'));
    await settle(tester);
    expect(
      find.textContaining('«ridge-h4@v7» کنار می‌رود'),
      findsOneWidget,
      reason: 'the confirm restates what changes',
    );
    expect(find.textContaining('+ret_72'), findsWidgets);
    expect(ready.calls['ApproveCycle'], isNull);
    await tester.tap(find.text('تأیید'));
    await settle(tester);
    expect((ready.calls['ApproveCycle']!.single as ApproveCycleRequest).cycleId, Int64(42));

    await tester.tap(find.text('بازگشت به مدل پیشین'));
    await settle(tester);
    expect(find.textContaining('به جفت پیش از آخرین ارتقا برمی‌گردند'), findsOneWidget);
    await tester.tap(find.text('انصراف'));
    await settle(tester);
    expect(ready.calls['Rollback'], isNull, reason: 'cancelled: nothing changes');
  });

  testWidgets('config: the gate is validated and saved for the next cycle', (tester) async {
    final f = fake(ready: false);
    await pumpLearning(tester, f);
    await tester.tap(find.text('تنظیم زمان‌بندی و بودجه'));
    await settle(tester);
    final wins = find.widgetWithText(TextFormField, 'حداقل برد در گام‌ها');
    await tester.enterText(wins, '9');
    await tester.tap(find.text('ذخیره'));
    await settle(tester);
    expect(find.text('عدد معتبر وارد کنید.'), findsOneWidget, reason: 'more wins than folds');
    expect(f.calls['SaveConfig'], isNull);

    await tester.enterText(wins, '2');
    await tester.enterText(find.widgetWithText(TextFormField, 'سقف افت سرمایه'), '15');
    await tester.tap(find.text('ذخیره'));
    await settle(tester);
    final g = (f.calls['SaveConfig']!.single as SaveConfigRequest).config.gate;
    expect((g.minWalkWins, g.maxDrawdown.units, g.maxDrawdown.scale), (2, '150000', 6));
    expect(find.text('تنظیمات ذخیره شد؛ از چرخه بعد اعمال می‌شود.'), findsOneWidget);
  });

  testWidgets('a skipped cycle with nothing else yet renders and says why', (tester) async {
    final f = FakeTransport({
      'GetLearning': (_) => GetLearningResponse(
        config: config(),
        current: Cycle(
          id: Int64(1),
          trigger: 'manual',
          state: 'done',
          outcome: 'skipped',
          reason: 'پرش: داده تازه ناکافی — 24 از 168 کندل لازم',
          steps: [
            CycleStep(key: 'collect', status: 'done', meta: '+24 bars'),
            for (final k in ['labels', 'generate', 'train', 'walk_forward', 'forward_test', 'decision'])
              CycleStep(key: k, status: 'skipped'),
          ],
          champion: Contender(versionId: 'ridge-h4@v1'),
          usage: CycleUsage(cpuBudgetSeconds: Int64(2700), maxCandidates: 30, bars: Int64(24), maxBars: Int64(2000000)),
        ),
        active: ActiveModel(algorithmId: 'ridge-h4'),
        learningAlgorithms: ['ridge-h4'],
      ),
      'ListCycles': (_) => ListCyclesResponse(total: Int64(1), cycles: [Cycle(id: Int64(1), state: 'done', outcome: 'skipped')]),
      'ListModels': (_) => ListModelsResponse(),
    });
    await pumpLearning(tester, f);
    expect(tester.takeException(), isNull);
    expect(find.textContaining('داده تازه ناکافی'), findsWidgets);
    expect(find.text('+24 bars'), findsOneWidget);
  });
}
