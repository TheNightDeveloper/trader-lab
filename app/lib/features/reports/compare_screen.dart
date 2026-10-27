import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/nav.dart';
import '../../core/metric.dart';
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
import 'report_screen.dart';

String colLabel(int i) => String.fromCharCode(65 + i); // A, B, C…

class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key, required this.ids});
  final List<String> ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final header = PageHeader(
      title: Dest.compare.label(l),
      subtitle: l.compareSubtitle,
      actions: [
        TextButton.icon(
          onPressed: () {
            ref.read(compareSelectionProvider.notifier).clear();
            context.go('/reports');
          },
          icon: const Icon(Icons.clear_all_rounded, size: 18),
          label: Text(l.compareClear),
        ),
      ],
    );
    if (ids.length < 2) {
      return PageFrame(
        children: [
          header,
          SectionCard(child: EmptyState(l.compareEmpty, icon: Icons.compare_arrows_rounded)),
        ],
      );
    }
    final res = ref.watch(compareProvider(ids.join(',')));
    return AsyncSection(
      value: res,
      onRetry: () => ref.invalidate(compareProvider(ids.join(','))),
      skeleton: PageFrame(
        children: [
          header,
          const SectionCard(child: SizedBox(height: 240)),
        ],
      ),
      builder: (c) => PageFrame(children: [header, ..._body(context, l, c)]),
    );
  }

  List<Widget> _body(BuildContext context, L10n l, CompareResponse c) {
    final blocking = c.assumptions.where((a) => a.differs && a.blocking).toList();
    final cols = [l.compareAssumption, for (var i = 0; i < c.columns.length; i++) colLabel(i), ''];
    final colors = [...AppColors.series, AppColors.positive, AppColors.negative, AppColors.link];
    return [
      Wrap(
        spacing: AppSpace.sm,
        runSpacing: AppSpace.sm,
        children: [
          for (final (i, col) in c.columns.indexed)
            InkWell(
              onTap: () => context.go('/reports/${col.reportId}'),
              child: BadgeChip('${colLabel(i)} · ${col.title}', tone: col.eligible ? 'neutral' : 'warning'),
            ),
        ],
      ),
      if (blocking.isNotEmpty)
        WarningBanner(l.compareMismatch(blocking.length, blocking.map((a) => a.label).join('، '))),
      SectionCard(
        title: l.compareAssumptions,
        child: DataTableBox(
          minWidth: 640,
          columns: cols,
          rows: [
            for (final a in c.assumptions)
              [
                Text(a.label, style: AppText.body.copyWith(height: 1.4)),
                for (final v in a.values)
                  Container(
                    color: a.differs && a.blocking ? AppColors.warningBg : null,
                    padding: const EdgeInsets.all(2),
                    child: Mono(v, style: AppText.mono.copyWith(fontSize: 12)),
                  ),
                Text(
                  !a.differs ? l.compareSame : (a.blocking ? l.compareDiffers : l.compareNote),
                  style: AppText.caption.copyWith(
                    color: a.differs && a.blocking ? AppColors.warningText : AppColors.textMuted,
                  ),
                ),
              ],
          ],
        ),
      ),
      SectionCard(
        title: l.compareEquity,
        trailing: Text(l.compareEquityHelp, style: AppText.caption),
        child: EquityChart(
          height: 260,
          format: axisUsdt,
          series: [
            for (final (i, col) in c.columns.indexed)
              ChartSeries(
                label: colLabel(i),
                points: equityPoints(col.equity),
                color: colors[i % colors.length],
                dashed: i.isOdd,
              ),
          ],
        ),
      ),
      SectionCard(
        title: l.compareMetrics,
        child: DataTableBox(
          minWidth: 560,
          columns: [l.compareMetric, for (var i = 0; i < c.columns.length; i++) colLabel(i)],
          rows: [
            for (final key in ['total_return', 'net_pnl', 'max_drawdown', 'sharpe', 'trades', 'win_rate'])
              [
                Text(metricOf(c.columns.first.metrics, key)?.label ?? key, style: AppText.body.copyWith(height: 1.4)),
                for (final col in c.columns) _cell(l, metricOf(col.metrics, key)),
              ],
            [
              Text(l.compareTotalCost, style: AppText.body.copyWith(height: 1.4)),
              for (final col in c.columns)
                Num(-(_v(col, 'fees') + _v(col, 'slippage')), signed: true, fractionDigits: 2, unit: 'USDT'),
            ],
            [
              Text(l.compareEligible, style: AppText.body.copyWith(height: 1.4)),
              for (final col in c.columns)
                Tooltip(
                  message: col.reasons.join('\n'),
                  child: Text(
                    col.eligible ? l.compareYes : '${l.compareNo}: ${col.reasons.join('، ')}',
                    style: AppText.body.copyWith(
                      height: 1.4,
                      color: col.eligible ? AppColors.positive : AppColors.negativeText,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
      SectionCard(
        title: l.compareConclusion,
        child: Text(c.conclusion, style: AppText.body.copyWith(height: 2)),
      ),
    ];
  }

  static Decimal _v(CompareColumn col, String key) {
    final m = metricOf(col.metrics, key);
    return m == null ? Decimal.zero : decValue(m.value);
  }

  static Widget _cell(L10n l, pb.Metric? m) {
    if (m == null) return const Text('—');
    final t = formatMetric(l, m);
    if (!m.valid) {
      return Tooltip(
        message: m.invalid,
        child: Text(t.text, style: AppText.caption.copyWith(color: AppColors.warningText)),
      );
    }
    return Mono(
      t.unit == null ? t.text : '${t.text} ${t.unit}',
      style: AppText.mono.copyWith(color: signColor(t.sign)),
    );
  }
}
