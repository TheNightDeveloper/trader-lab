import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/local_store.dart';
import '../../core/metric.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/candle_chart.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/report_widgets.dart';
import '../../gen/lab/v1/chart.pb.dart';
import '../../gen/lab/v1/report.pb.dart' show Report;
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';
import '../reports/report_providers.dart';

const layoutKey = 'lab.chart.layout.v1';
const _timeframes = ['1m', '15m', '1h', '4h', '1d'];

/// User-toggled indicators and their engine keys.
const indicatorKeys = {'MA': 'ma:20', 'EMA': 'ema:48', 'BB': 'bb:20:2', 'RSI': 'rsi:14', 'MACD': 'macd:12:26:9'};

typedef ChartQuery = ({String report, String symbol, String timeframe, String indicators});

final chartProvider = FutureProvider.family<GetChartResponse, ChartQuery>(
  (ref, q) => ref
      .watch(chartClientProvider)
      .getChart(
        GetChartRequest(
          reportId: q.report,
          symbol: q.symbol,
          timeframe: q.timeframe,
          indicators: q.indicators.isEmpty ? const [] : q.indicators.split(','),
          maxBars: 2000,
        ),
      ),
);

final decisionProvider = FutureProvider.family<GetDecisionResponse, ({String report, int id})>(
  (ref, q) => ref.watch(chartClientProvider).getDecision(GetDecisionRequest(reportId: q.report, decisionId: q.id)),
);

/// The strategy's own lines for a report: what its rules compare.
List<String> strategyLines(Report r) {
  final p = {for (final e in r.spec.params.entries) e.key: e.value};
  String n(String k) => fmtParam(p[k] ?? 0);
  return switch (r.spec.strategy) {
    'trend-ema' => ['ema:${n('fast')}', 'ema:${n('slow')}'],
    'mean-rev-bands' => ['bb:${n('period')}:${n('k')}'],
    _ => const [],
  };
}

Decimal? _dec(String s) => s.isEmpty ? null : Decimal.parse(s);

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key, this.report});

  /// Opened from a report: its run is the layer.
  final String? report;

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  String _report = '', _symbol = 'BTCUSDT', _tf = '1h';
  Set<String> _inds = {'EMA'};
  int? _sel;
  final _hover = ValueNotifier<CandleBar?>(null);

  @override
  void initState() {
    super.initState();
    final raw = localGet(layoutKey);
    if (raw != null) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        _report = j['report'] as String;
        _symbol = j['symbol'] as String;
        _tf = j['tf'] as String;
        _inds = {...(j['inds'] as List).cast<String>()};
      } catch (_) {
        localRemove(layoutKey);
      }
    }
    if (widget.report != null) _report = widget.report!;
  }

  @override
  void dispose() {
    _hover.dispose();
    super.dispose();
  }

  void _set(VoidCallback f) {
    setState(() {
      f();
      _sel = null;
    });
    localSet(layoutKey, jsonEncode({'report': _report, 'symbol': _symbol, 'tf': _tf, 'inds': _inds.toList()}));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final rep = _report.isEmpty ? null : ref.watch(reportProvider(_report)).value;
    final own = rep == null ? const <String>[] : strategyLines(rep);
    final keys = {...own, for (final k in _inds) indicatorKeys[k]!}.toList();
    final q = (report: _report, symbol: _symbol, timeframe: _tf, indicators: keys.join(','));
    final chart = ref.watch(chartProvider(q));
    final c = chart.value;
    final pair = c == null ? _symbol : '${c.symbol} ${c.timeframe}';
    final reports = ref.watch(reportsProvider(0)).value?.reports ?? const [];

    final marks = <ChartMark>[
      for (final (i, m) in (c?.markers ?? const <ChartMarker>[]).indexed)
        ChartMark(index: i, time: utcMs(m.barOpenUnixMs), kind: m.kind, price: decValue(m.price)),
    ];
    final selMarker = c != null && _sel != null && _sel! < c.markers.length ? c.markers[_sel!] : null;

    return PageFrame(
      children: [
        PageHeader(
          title: Dest.chart.label(l),
          subtitle: rep != null ? l.chartSub(rep.title, pair) : l.chartSubLive(pair),
        ),
        SectionCard(
          child: Wrap(
            spacing: AppSpace.xl,
            runSpacing: AppSpace.md,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              _labelled(
                l.chartSource,
                // Bounded and expanded: long report titles shrink with ellipsis
                // instead of pushing the row past a phone's width.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _report.isEmpty || reports.any((r) => r.id == _report) ? _report : null,
                    hint: Mono(_report),
                    dropdownColor: AppColors.surfaceRaised,
                    items: [
                      DropdownMenuItem(
                        value: '',
                        child: Text(l.chartNoSource, style: AppText.body),
                      ),
                      for (final r in reports)
                        DropdownMenuItem(
                          value: r.id,
                          child: Text(r.title, style: AppText.body, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    onChanged: (v) => _set(() => _report = v ?? ''),
                  ),
                ),
              ),
              _labelled(
                l.chartPair,
                LabChoiceChips<String>(
                  ltr: true,
                  options: [
                    for (final s in c?.symbols ?? [_symbol]) (s, s),
                  ],
                  selected: {c?.symbol ?? _symbol},
                  onChanged: (v) => _set(() => _symbol = v.first),
                ),
              ),
              if (_report.isEmpty)
                _labelled(
                  l.chartTimeframe,
                  LabChoiceChips<String>(
                    ltr: true,
                    options: [for (final t in _timeframes) (t, t)],
                    selected: {_tf},
                    onChanged: (v) => _set(() => _tf = v.first),
                  ),
                ),
              _labelled(
                l.chartIndicators,
                LabChoiceChips<String>(
                  multi: true,
                  ltr: true,
                  options: [for (final k in indicatorKeys.keys) (k, k)],
                  selected: _inds,
                  onChanged: (v) => _set(() => _inds = v),
                ),
              ),
              if (own.isNotEmpty) Text('${l.chartStrategyLines}: ${own.join(' · ')}', style: AppText.caption),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, box) {
            final chartCard = SectionCard(
              title: pair,
              trailing: c != null && c.totalBars > c.bars.length
                  ? Text(l.chartBarsCut(c.bars.length, c.totalBars), style: AppText.caption)
                  : null,
              child: AsyncSection(
                value: chart,
                onRetry: () => ref.invalidate(chartProvider(q)),
                skeleton: const SizedBox(height: 480),
                isEmpty: (r) => r.bars.isEmpty,
                empty: EmptyState(l.chartEmpty, icon: Icons.candlestick_chart_outlined),
                builder: (r) => _ChartBody(
                  r: r,
                  marks: marks,
                  selected: _sel,
                  hover: _hover,
                  onMark: (m) => setState(() => _sel = m.index),
                ),
              ),
            );
            final panel = _DecisionPanel(
              report: _report,
              marker: selMarker,
              index: _sel,
              count: marks.length,
              onGo: (i) => setState(() => _sel = i),
            );
            if (box.maxWidth < 1000) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  chartCard,
                  const SizedBox(height: AppSpace.lg),
                  panel,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: chartCard),
                const SizedBox(width: AppSpace.lg),
                SizedBox(width: 340, child: panel),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _labelled(String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: AppText.label),
      const SizedBox(height: AppSpace.xs),
      child,
    ],
  );
}

class _ChartBody extends StatelessWidget {
  const _ChartBody({
    required this.r,
    required this.marks,
    required this.selected,
    required this.hover,
    required this.onMark,
  });
  final GetChartResponse r;
  final List<ChartMark> marks;
  final int? selected;
  final ValueNotifier<CandleBar?> hover;
  final ValueChanged<ChartMark> onMark;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final bars = [
      for (final b in r.bars)
        CandleBar(
          utcMs(b.openUnixMs),
          decValue(b.open),
          decValue(b.high),
          decValue(b.low),
          decValue(b.close),
          decValue(b.volume),
        ),
    ];
    final inds = [
      for (final i in r.indicators)
        EngineIndicator(
          key: i.key,
          label: i.label,
          main: i.pane == 'main',
          lines: [
            for (final ln in i.lines) EngineLine(ln.name, [for (final v in ln.values) _dec(v)]),
          ],
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: SizedBox(
            height: 480,
            child: CandleChart(
              ticker: r.symbol,
              timeframe: r.timeframe,
              bars: bars,
              indicators: inds,
              marks: marks,
              selected: selected,
              onMarkTap: onMark,
              pricePrecision: r.pricePrecision,
              onCrosshair: (b) => hover.value = b,
            ),
          ),
        ),
        const SizedBox(height: AppSpace.md),
        ValueListenableBuilder(
          valueListenable: hover,
          builder: (context, b, _) => AnimatedSwitcher(
            duration: AppMotion.of(context, AppMotion.fast),
            child: b == null
                ? Text(l.chartCrosshairNone, key: const ValueKey(0), style: AppText.caption)
                : Wrap(
                    key: const ValueKey(1),
                    spacing: AppSpace.lg,
                    children: [
                      Text(l.chartCrosshair, style: AppText.caption),
                      Mono(fmtDateTime(b.time.toUtc())),
                      Num(b.open, unit: 'O', fractionDigits: r.pricePrecision),
                      Num(b.high, unit: 'H', fractionDigits: r.pricePrecision),
                      Num(b.low, unit: 'L', fractionDigits: r.pricePrecision),
                      Num(b.close, unit: 'C', fractionDigits: r.pricePrecision),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _DecisionPanel extends ConsumerWidget {
  const _DecisionPanel({
    required this.report,
    required this.marker,
    required this.index,
    required this.count,
    required this.onGo,
  });
  final String report;
  final ChartMarker? marker;
  final int? index;
  final int count;
  final ValueChanged<int> onGo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final m = marker;
    final (title, color) = switch (m?.kind) {
      'entry' => (l.mk_entry, AppColors.positive),
      'exit' => (l.mk_exit, AppColors.negativeText),
      'rejected' => (l.mk_rejected, AppColors.warning),
      _ => (l.chartDecision, AppColors.textPrimary),
    };
    Widget kv(String k, Widget v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(k, style: AppText.label)),
          Flexible(child: v),
        ],
      ),
    );
    Widget body;
    if (report.isEmpty || count == 0) {
      body = Text(l.chartNoMarks, style: AppText.caption);
    } else if (m == null) {
      body = Text(l.chartPick, style: AppText.caption);
    } else if (m.decisionId == 0) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          kv(l.dTime, Mono(fmtDateTime(utcMs(m.barOpenUnixMs)))),
          kv(l.dRef, Num(decValue(m.price), fractionDigits: 2)),
          kv(l.dDetail, Text(m.detail, style: AppText.body)),
        ],
      );
    } else {
      final d = ref.watch(decisionProvider((report: report, id: m.decisionId)));
      body = AsyncSection(
        value: d,
        onRetry: () => ref.invalidate(decisionProvider((report: report, id: m.decisionId))),
        skeleton: const SizedBox(height: 180),
        builder: (r) {
          final x = r.decision;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              kv(l.dTime, Mono('${fmtDateTime(utcMs(x.inputBarOpenUnixMs))} UTC')),
              if (r.hasRefPrice()) kv(l.dRef, moneyNum(r.refPrice, signed: false)),
              kv(
                l.dOutcome,
                Text(switch (x.outcome) {
                  'filled' => l.oc_filled,
                  'rejected' => l.oc_rejected,
                  'expired' => l.oc_expired,
                  _ => x.outcome,
                }, style: AppText.body),
              ),
              kv(l.dTarget, Num(fractionToPct(x.target), unit: '%', fractionDigits: 1)),
              if (x.modelId.isNotEmpty) kv(l.dModel, Mono(x.modelId)),
              if (x.recipeVersion.isNotEmpty) kv(l.dRecipe, Mono(x.recipeVersion)),
              if (x.detail.isNotEmpty) kv(l.dDetail, Text(x.detail, style: AppText.caption)),
              const SizedBox(height: AppSpace.sm),
              Text(x.reason, style: AppText.body.copyWith(color: AppColors.textSecondary)),
            ],
          );
        },
      );
    }
    return SectionCard(
      title: title,
      trailing: m == null
          ? null
          : Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (count > 0)
            Row(
              children: [
                IconButton(
                  tooltip: l.chartPrev,
                  onPressed: (index ?? count) > 0 ? () => onGo((index ?? count) - 1) : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
                Expanded(
                  child: Center(
                    child: Text(index == null ? '—' : l.chartMarkOf(index! + 1, count), style: AppText.label),
                  ),
                ),
                IconButton(
                  tooltip: l.chartNext,
                  onPressed: (index ?? -1) < count - 1 ? () => onGo((index ?? -1) + 1) : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
              ],
            ),
          AnimatedSwitcher(
            duration: AppMotion.of(context, AppMotion.normal),
            child: KeyedSubtree(key: ValueKey(index), child: body),
          ),
          const SizedBox(height: AppSpace.md),
          OutlinedButton(onPressed: null, child: Text(l.chartReplay)),
          if (report.isNotEmpty) ...[
            const SizedBox(height: AppSpace.sm),
            OutlinedButton.icon(
              onPressed: () => context.go('/reports/$report'),
              icon: const Icon(Icons.assessment_outlined, size: 18),
              label: Text(l.chartBack),
            ),
          ],
        ],
      ),
    );
  }
}
