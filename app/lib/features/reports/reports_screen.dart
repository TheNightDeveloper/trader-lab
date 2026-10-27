import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/nav.dart';
import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/report_widgets.dart';
import '../../l10n/app_localizations.dart';
import '../placeholder_screen.dart';
import 'new_report_form.dart';
import 'report_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _offset = 0;
  bool _showForm = false;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final selected = ref.watch(compareSelectionProvider);
    final list = ref.watch(reportsProvider(_offset));
    final cols = [
      l.reportsSelect,
      l.reportsColTitle,
      l.reportsColCreated,
      l.reportsColNet,
      l.reportsColReturn,
      l.reportsColTrades,
      l.reportsColVerdict,
      l.reportsColHoldout,
    ];
    return PageFrame(
      children: [
        PageHeader(
          title: Dest.reports.label(l),
          subtitle: Dest.reports.subtitle(l),
          actions: [
            if (selected.length >= 2)
              OutlinedButton.icon(
                onPressed: () => context.go('/compare?ids=${selected.join(',')}'),
                icon: const Icon(Icons.compare_arrows_rounded, size: 18),
                label: Text(l.reportsCompareSelected(selected.length)),
              ),
            FilledButton.icon(
              onPressed: () => setState(() => _showForm = !_showForm),
              icon: Icon(_showForm ? Icons.close_rounded : Icons.add_rounded, size: 18),
              label: Text(l.reportsNew),
            ),
          ],
        ),
        AnimatedSize(
          duration: AppMotion.of(context, AppMotion.normal),
          curve: AppMotion.curve,
          child: _showForm
              ? SectionCard(title: l.reportsNew, child: const NewReportForm())
              : const SizedBox(width: double.infinity),
        ),
        SectionCard(
          child: AsyncSection(
            value: list,
            onRetry: () => ref.invalidate(reportsProvider(_offset)),
            skeleton: DataTableBox(
              columns: cols,
              rows: [
                for (var i = 0; i < 3; i++) [for (var j = 0; j < cols.length; j++) const Text('————')],
              ],
            ),
            isEmpty: (r) => r.reports.isEmpty,
            empty: EmptyState(l.reportsEmpty, icon: Icons.assessment_outlined),
            builder: (r) => DataTableBox(
              minWidth: 900,
              columns: cols,
              paging: Paging(
                offset: _offset,
                pageSize: reportsPageSize,
                total: r.total.toInt(),
                onOffset: (o) => setState(() => _offset = o),
              ),
              rows: [
                for (final rep in r.reports)
                  [
                    Checkbox(
                      value: selected.contains(rep.id),
                      onChanged: (_) => ref.read(compareSelectionProvider.notifier).toggle(rep.id),
                      semanticLabel: l.reportsSelect,
                    ),
                    InkWell(
                      onTap: () => context.go('/reports/${rep.id}'),
                      child: Text(rep.title, style: AppText.body.copyWith(color: AppColors.link, height: 1.4)),
                    ),
                    Mono(fmtDateTime(utcMs(rep.createdUnixMs))),
                    moneyNum(rep.net),
                    Num(fractionToPct(rep.totalReturn), signed: true, fractionDigits: 2, unit: '%'),
                    Mono('${rep.closedTrades}'),
                    Text(rep.verdict, style: AppText.body.copyWith(color: toneColor(rep.tone), height: 1.4)),
                    rep.holdoutViews > 0
                        ? Text(
                            l.reportHoldoutViews(rep.holdoutViews),
                            style: AppText.caption.copyWith(color: AppColors.warningText),
                          )
                        : const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textMuted),
                  ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
