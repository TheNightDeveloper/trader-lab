import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/engine.dart';
import '../../core/download.dart';
import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/charts.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/report_widgets.dart';
import '../../gen/lab/v1/common.pb.dart' as pb;
import '../../gen/lab/v1/report.pb.dart';
import '../../l10n/app_localizations.dart';
import '../placeholder_screen.dart';
import 'report_providers.dart';

List<(DateTime, double)> equityPoints(List<pb.EquityPoint> pts) => [
  for (final p in pts) (utcMs(p.tUnixMs), moneyValue(p.equity).toDouble()),
]; // drawing only

String axisUsdt(double v) => formatDecimal(Decimal.parse(v.toStringAsFixed(0)));

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final rep = ref.watch(reportProvider(id));
    return AsyncSection(
      value: rep,
      onRetry: () => ref.invalidate(reportProvider(id)),
      skeleton: PageFrame(
        children: [
          PageHeader(title: l.reportTitle, subtitle: '—————'),
          const SectionCard(child: SizedBox(height: 200)),
        ],
      ),
      builder: (r) => _ReportBody(r: r),
    );
  }
}

class _ReportBody extends ConsumerWidget {
  const _ReportBody({required this.r});
  final Report r;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 1100;
    final params = (r.spec.params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
        .map((e) => '${e.key}=${_param(e.value)}')
        .join(', ');
    Widget pair(Widget a, Widget b, {int fa = 3, int fb = 2}) => wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: fa, child: a),
              const SizedBox(width: 18),
              Expanded(flex: fb, child: b),
            ],
          )
        : Column(children: [a, const SizedBox(height: 18), b]);

    return PageFrame(
      children: [
        PageHeader(
          title: r.title,
          subtitle: '${r.spec.strategy} · $params',
          actions: [_Actions(r: r)],
        ),
        Wrap(
          spacing: AppSpace.sm,
          runSpacing: AppSpace.sm,
          children: [
            BadgeChip(l.badgeDatasets(r.spec.datasetIds.map(shortHash).join(', '))),
            if (r.spec.engineVersion.isNotEmpty) BadgeChip(l.badgeEngine(r.spec.engineVersion)),
            if (r.holdoutViews > 0) BadgeChip(l.reportHoldoutViews(r.holdoutViews), tone: 'warning'),
            for (final b in r.summary.badges) BadgeChip(b.text, tone: b.tone),
          ],
        ),
        pair(_Summary(r: r), _Waterfall(r: r)),
        SectionCard(
          title: l.reportEquity,
          trailing: Text('USDT', style: AppText.caption),
          child: _Equity(r: r),
        ),
        _MetricGroups(r: r),
        pair(_Folds(r: r), _Sensitivity(r: r)),
        _Holdout(r: r),
        _Trades(id: r.id),
      ],
    );
  }

  static String _param(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}

class _Actions extends ConsumerStatefulWidget {
  const _Actions({required this.r});
  final Report r;

  @override
  ConsumerState<_Actions> createState() => _ActionsState();
}

class _ActionsState extends ConsumerState<_Actions> {
  bool _reproducing = false;

  Future<void> _export(String kind) async {
    final rate = ref.read(displayRateIdProvider);
    final res = await ref
        .read(reportClientProvider)
        .export(ExportRequest(reportId: widget.r.id, kind: kind, fxRateId: rate == 0 ? null : Int64(rate)));
    saveFile(res.filename, res.mime, res.content);
  }

  Future<void> _reproduce(L10n l) async {
    setState(() => _reproducing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final res = await ref.read(reportClientProvider).reproduce(ReproduceRequest(reportId: widget.r.id));
      messenger.showSnackBar(SnackBar(content: Text(res.identical ? l.reportReproduceOk : l.reportReproduceFail)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(e))));
    } finally {
      if (mounted) setState(() => _reproducing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final inCompare = ref.watch(compareSelectionProvider).contains(widget.r.id);
    return Wrap(
      spacing: AppSpace.sm,
      runSpacing: AppSpace.sm,
      children: [
        OutlinedButton.icon(
          onPressed: () => _export('trades_csv'),
          icon: const Icon(Icons.table_view_outlined, size: 18),
          label: Text(l.reportExportCsv),
        ),
        OutlinedButton.icon(
          onPressed: () => _export('metrics_csv'),
          icon: const Icon(Icons.insights_outlined, size: 18),
          label: Text(l.reportExportMetrics),
        ),
        OutlinedButton.icon(
          onPressed: () => _export('spec_json'),
          icon: const Icon(Icons.data_object_rounded, size: 18),
          label: Text(l.reportExportJson),
        ),
        OutlinedButton.icon(
          onPressed: _reproducing ? null : () => _reproduce(l),
          icon: _reproducing
              ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.replay_rounded, size: 18),
          label: Text(l.reportReproduce),
        ),
        OutlinedButton.icon(
          onPressed: () => ref.read(compareSelectionProvider.notifier).toggle(widget.r.id),
          icon: Icon(inCompare ? Icons.check_rounded : Icons.compare_arrows_rounded, size: 18),
          label: Text(inCompare ? l.reportInCompare : l.reportAddCompare),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.r});
  final Report r;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VerdictCard(
          title: l.reportSummary,
          verdict: r.summary.verdict,
          tone: r.summary.tone,
          sentence: r.summary.sentence,
        ),
        const SizedBox(height: AppSpace.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => context.go('/pnl?report=${r.id}'),
            icon: const Icon(Icons.calculate_outlined, size: 18),
            label: Text(l.reportOpenPnl),
          ),
        ),
      ],
    );
  }
}

class _Waterfall extends ConsumerWidget {
  const _Waterfall({required this.r});
  final Report r;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final ms = r.oos.metrics;
    Decimal usdt(String k) => metricOf(ms, k) == null ? Decimal.zero : decValue(metricOf(ms, k)!.value);
    final rate = ref.watch(engineStatusProvider.select((s) => s.value?.displayRate));
    final net = usdt('net_pnl');
    return SectionCard(
      title: l.reportWaterfall,
      trailing: Text('USDT', style: AppText.caption),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WaterfallBars(
            rows: [
              WaterfallRow(
                metricOf(ms, 'gross_pnl')!.label,
                usdt('gross_pnl'),
                AppColors.positive.withValues(alpha: 0.8),
              ),
              WaterfallRow(metricOf(ms, 'fees')!.label, -usdt('fees'), AppColors.negative.withValues(alpha: 0.85)),
              WaterfallRow(
                metricOf(ms, 'slippage')!.label,
                -usdt('slippage'),
                AppColors.negative.withValues(alpha: 0.6),
              ),
              WaterfallRow(metricOf(ms, 'net_pnl')!.label, net, AppColors.accent),
            ],
          ),
          const Divider(height: 24, color: AppColors.divider),
          _kv(l.reportFinalEquity, Num(usdt('final_equity'), fractionDigits: 2, unit: 'USDT')),
          _kv(
            l.reportToman,
            r.hasFinalEquityToman()
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      moneyNum(r.finalEquityToman, signed: false, digits: 0),
                      if (rate != null) Text(l.reportTomanRate(rate.rateId, rate.asOfDate), style: AppText.caption),
                    ],
                  )
                : Text(l.reportTomanNone, style: AppText.caption),
          ),
          _kv(
            l.reportBreakEven,
            r.hasBreakEvenFee()
                ? Num(fractionToBps(r.breakEvenFee), fractionDigits: 1, unit: 'bps')
                : Text(l.reportBreakEvenNone, style: AppText.caption),
          ),
        ],
      ),
    );
  }

  static Widget _kv(String k, Widget v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(k, style: AppText.label)),
        const SizedBox(width: AppSpace.sm),
        Flexible(child: Align(alignment: AlignmentDirectional.centerEnd, child: v)),
      ],
    ),
  );
}

class _Equity extends StatelessWidget {
  const _Equity({required this.r});
  final Report r;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final bench = {for (final b in r.benchmarks) b.key: b};
    return EquityChart(
      height: 280,
      format: axisUsdt,
      series: [
        ChartSeries(
          label: l.reportCandidate,
          points: equityPoints(r.oos.equity),
          color: AppColors.series[0],
          width: 2.4,
        ),
        if (bench['buy_and_hold'] != null)
          ChartSeries(
            label: l.benchBuyAndHold,
            points: equityPoints(bench['buy_and_hold']!.equity),
            color: AppColors.series[1],
            dashed: true,
          ),
        if (bench['hold_cash'] != null)
          ChartSeries(
            label: l.benchHoldCash,
            points: equityPoints(bench['hold_cash']!.equity),
            color: AppColors.textMuted,
            dashed: true,
            width: 1.4,
          ),
      ],
      regions: [
        ChartRegion(
          utcMs(r.range.fromUnixMs),
          utcMs(r.oosWindow.fromUnixMs),
          l.regionInSample,
          AppColors.surfaceRaised,
        ),
        ChartRegion(utcMs(r.oosWindow.fromUnixMs), utcMs(r.oosWindow.toUnixMs), l.regionOos, AppColors.surface),
        ChartRegion(
          utcMs(r.holdoutWindow.fromUnixMs),
          utcMs(r.holdoutWindow.toUnixMs),
          l.regionHoldout,
          AppColors.warningBg,
        ),
      ],
    );
  }
}

class _MetricGroups extends StatelessWidget {
  const _MetricGroups({required this.r});
  final Report r;

  @override
  Widget build(BuildContext context) => StatGrid(
    minWidth: 260,
    children: [
      for (final g in r.groups)
        SectionCard(
          title: g.label,
          child: Column(children: [for (final m in r.oos.metrics.where((m) => m.group == g.key)) MetricTile(m)]),
        ),
    ],
  );
}

class _Folds extends StatelessWidget {
  const _Folds({required this.r});
  final Report r;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final stressLabel = {
      'fee_x2': l.stress_fee_x2,
      'slippage_x3': l.stress_slippage_x3,
      'latency_plus_1': l.stress_latency_plus_1,
    };
    Widget val(List<pb.Metric> ms, String key) {
      final m = metricOf(ms, key);
      if (m == null) return const Text('—');
      final t = formatMetric(l, m);
      return m.valid
          ? Mono(
              t.unit == null ? t.text : '${t.text}${t.unit == '%' ? '%' : ' ${t.unit}'}',
              style: AppText.mono.copyWith(color: signColor(t.sign)),
            )
          : Tooltip(
              message: m.invalid,
              child: Text(t.text, style: AppText.caption.copyWith(color: AppColors.warningText)),
            );
    }

    return SectionCard(
      title: l.reportFolds,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataTableBox(
            minWidth: 560,
            columns: [l.foldStep, l.foldTrainUntil, l.foldTest, l.foldReturn, l.foldDrawdown, l.foldTrades],
            rows: [
              for (final f in r.folds)
                [
                  Mono('WF${f.index}'),
                  Mono(fmtDate(utcMs(f.train.toUnixMs))),
                  Mono(
                    '${fmtDate(utcMs(f.test.fromUnixMs))} → ${fmtDate(utcMs(f.test.toUnixMs).subtract(const Duration(milliseconds: 1)))}',
                  ),
                  val(f.metrics, 'total_return'),
                  val(f.metrics, 'max_drawdown'),
                  val(f.metrics, 'trades'),
                ],
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Text(l.reportStress, style: AppText.sectionTitle.copyWith(fontSize: 14)),
          const SizedBox(height: AppSpace.sm),
          StatGrid(
            minWidth: 150,
            children: [
              for (final s in r.stress)
                StatCard(
                  label: stressLabel[s.key] ?? s.key,
                  value: s.error.isNotEmpty ? Text(l.invalid) : val(s.metrics, 'total_return'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sensitivity extends StatelessWidget {
  const _Sensitivity({required this.r});
  final Report r;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    if (!r.hasGrid()) {
      return SectionCard(
        title: l.reportSensitivity,
        child: Text(l.reportSensitivityNone, style: AppText.caption),
      );
    }
    final g = r.grid;
    String num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
    (int, int)? sel;
    final cells = [
      for (final (yi, row) in g.rows.indexed)
        [
          for (final (xi, c) in row.cells.indexed)
            () {
              if (c.center) sel = (xi, yi);
              if (c.invalid.isNotEmpty || !c.totalReturn.valid) return (value: null, text: '—');
              final pct = decValue(c.totalReturn.value) * Decimal.fromInt(100);
              return (value: pct.toDouble(), text: formatDecimal(pct, fractionDigits: 1, signed: true)); // colour only
            }(),
        ],
    ];
    return SectionCard(
      title: l.reportSensitivity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.reportSensitivityHelp(g.x, g.y.isEmpty ? '' : l.reportSensitivityY(g.y)), style: AppText.caption),
          const SizedBox(height: AppSpace.md),
          Heatmap(
            xs: [for (final x in g.xs) num(x)],
            ys: g.ys.isEmpty ? [''] : [for (final y in g.ys) num(y)],
            cells: cells,
            selected: sel,
          ),
        ],
      ),
    );
  }
}

class _Holdout extends ConsumerStatefulWidget {
  const _Holdout({required this.r});
  final Report r;

  @override
  ConsumerState<_Holdout> createState() => _HoldoutState();
}

class _HoldoutState extends ConsumerState<_Holdout> {
  RunView? _view;
  bool _loading = false;
  Object? _error;

  Future<void> _show(L10n l) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.reportHoldout),
        content: Text(l.reportHoldoutConfirm, style: AppText.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.confirm)),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _loading = true);
    try {
      final res = await ref.read(reportClientProvider).viewHoldout(ViewHoldoutRequest(reportId: widget.r.id));
      setState(() => _view = res.holdout);
      ref.invalidate(reportProvider(widget.r.id)); // view count badge
    } catch (e) {
      setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final v = _view;
    return SectionCard(
      title: l.reportHoldout,
      trailing: Mono(
        '${fmtDate(utcMs(widget.r.holdoutWindow.fromUnixMs))} → ${fmtDate(utcMs(widget.r.holdoutWindow.toUnixMs))}',
        style: AppText.caption,
      ),
      child: AnimatedSwitcher(
        duration: AppMotion.of(context, AppMotion.normal),
        child: v == null
            ? Column(
                key: const ValueKey('hidden'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                      const SizedBox(width: AppSpace.sm),
                      Expanded(
                        child: Text(
                          l.reportHoldoutHidden,
                          style: AppText.body.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.md),
                  OutlinedButton.icon(
                    onPressed: _loading ? null : () => _show(l),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: Text(l.reportHoldoutShow),
                  ),
                  if (_error != null)
                    Text(errorText(_error!), style: AppText.caption.copyWith(color: AppColors.negativeText)),
                ],
              )
            : Column(
                key: const ValueKey('shown'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EquityChart(
                    height: 200,
                    format: axisUsdt,
                    series: [
                      ChartSeries(label: l.regionHoldout, points: equityPoints(v.equity), color: AppColors.series[2]),
                    ],
                  ),
                  const SizedBox(height: AppSpace.md),
                  StatGrid(
                    minWidth: 220,
                    children: [
                      for (final k in ['net_pnl', 'total_return', 'max_drawdown', 'trades', 'win_rate'])
                        if (metricOf(v.metrics, k) != null) SectionCard(child: MetricTile(metricOf(v.metrics, k)!)),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _Trades extends ConsumerStatefulWidget {
  const _Trades({required this.id});
  final String id;

  @override
  ConsumerState<_Trades> createState() => _TradesState();
}

final _tradesProvider = FutureProvider.family<ListTradesResponse, (String, int)>(
  (ref, k) => ref.watch(reportClientProvider).listTrades(ListTradesRequest(reportId: k.$1, pageSize: 20, offset: k.$2)),
);

class _TradesState extends ConsumerState<_Trades> {
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final cols = ['#', l.dataColPair, l.tradeEntryExit, l.tradeGross, l.tradeCost, l.tradeNet];
    return SectionCard(
      title: l.reportTrades,
      child: AsyncSection(
        value: ref.watch(_tradesProvider((widget.id, _offset))),
        onRetry: () => ref.invalidate(_tradesProvider((widget.id, _offset))),
        skeleton: DataTableBox(
          columns: cols,
          rows: [
            for (var i = 0; i < 3; i++) [for (var j = 0; j < 6; j++) const Text('———')],
          ],
        ),
        builder: (res) => DataTableBox(
          minWidth: 720,
          columns: cols,
          paging: Paging(
            offset: _offset,
            pageSize: 20,
            total: res.total.toInt(),
            onOffset: (o) => setState(() => _offset = o),
          ),
          rows: [for (final t in res.trades) tradeRow(l, t)],
        ),
      ),
    );
  }
}

/// One trade row (shared with the calculator).
List<Widget> tradeRow(L10n l, TradeRow t) {
  final cost = moneyValue(t.fees) + moneyValue(t.slippage);
  return [
    Mono('${t.seq}'),
    Mono(t.instrument),
    Mono(
      '${fmtDateTime(utcMs(t.openedUnixMs))} → ${t.closedUnixMs == 0 ? l.tradeOpen : fmtDateTime(utcMs(t.closedUnixMs))}',
    ),
    moneyNum(t.gross),
    Num(-cost, signed: true, fractionDigits: 2, unit: 'USDT'),
    moneyNum(t.net),
  ];
}
