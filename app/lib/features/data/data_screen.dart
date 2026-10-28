import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/data.pb.dart';
import '../../gen/lab/v1/health.pbenum.dart';
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';
import 'coverage_timeline.dart';
import 'data_providers.dart';
import 'import_form.dart';

class DataScreen extends ConsumerStatefulWidget {
  const DataScreen({super.key, this.now});
  final DateTime? now; // injectable for tests

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends ConsumerState<DataScreen> {
  int _datasetsOffset = 0, _issuesOffset = 0;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final overview = ref.watch(overviewProvider);
    final List<String> symbols = overview.value?.symbols ?? const [];
    return LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= 1100;
        final main = [_datasets(l), _coverage(l), _issues(l)];
        final aside = SectionCard(
          title: l.dataImport,
          child: symbols.isEmpty
              ? AsyncSection(
                  value: overview,
                  onRetry: () => ref.invalidate(overviewProvider),
                  skeleton: const SizedBox(height: 320),
                  builder: (_) => const SizedBox.shrink(),
                )
              : ImportForm(symbols: symbols, today: widget.now),
        );
        return PageFrame(
          children: [
            PageHeader(title: Dest.data.label(l), subtitle: l.dataSubtitle),
            _stats(l, overview),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Column(children: _gapped(main))),
                  const SizedBox(width: 18),
                  SizedBox(width: 340, child: aside),
                ],
              )
            else
              Column(children: _gapped([...main, aside])),
          ],
        );
      },
    );
  }

  List<Widget> _gapped(List<Widget> ws) => [
    for (final (i, w) in ws.indexed) ...[if (i > 0) const SizedBox(height: 18), w],
  ];

  Widget _stats(L10n l, AsyncValue<GetOverviewResponse> overview) {
    final health = ref.watch(engineStatusProvider).value;
    final live = health?.live;
    final liveOn = live != null && live.state != LiveState.LIVE_STATE_OFF;
    return AsyncSection(
      value: overview,
      onRetry: () => ref.invalidate(overviewProvider),
      skeleton: StatGrid(
        children: [for (var i = 0; i < 4; i++) const StatCard(label: '—————', value: Text('—————'))],
      ),
      builder: (o) => StatGrid(
        children: [
          StatCard(
            label: l.dataLiveStream,
            value: Text(o.liveSymbols > 0 ? l.dataLiveStreamValue(o.liveSymbols, 'REST') : l.dataLiveOff),
            tone: o.liveSymbols > 0 ? AppColors.positive : AppColors.textMuted,
          ),
          StatCard(
            label: l.dataLastBarAge,
            value: Text(liveOn ? l.dataSeconds(live.lastBarAgeSeconds.toInt()) : '—'),
            tone: switch (live?.state) {
              LiveState.LIVE_STATE_FRESH => AppColors.positive,
              LiveState.LIVE_STATE_STALE || LiveState.LIVE_STATE_RECONNECTING => AppColors.warning,
              _ => AppColors.textMuted,
            },
          ),
          StatCard(
            label: l.dataOutagesToday,
            value: Text(l.dataOutagesValue(o.outagesToday, (o.outageSecondsToday.toInt() / 60).ceil())),
            tone: o.outagesToday > 0 ? AppColors.warning : AppColors.textPrimary,
          ),
          StatCard(
            label: l.dataStorage,
            value: Mono(fmtBytes(o.storageBytes), style: AppText.statValue.copyWith(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _datasets(L10n l) {
    final v = ref.watch(datasetsProvider(_datasetsOffset));
    return SectionCard(
      title: l.dataDatasets,
      child: AsyncSection(
        value: v,
        onRetry: () => ref.invalidate(datasetsProvider(_datasetsOffset)),
        skeleton: DataTableBox(
          columns: _datasetCols(l),
          rows: [
            for (var i = 0; i < 3; i++) [for (var j = 0; j < 6; j++) const Text('————')],
          ],
        ),
        isEmpty: (r) => r.datasets.isEmpty,
        empty: EmptyState(l.dataDatasetsEmpty, icon: Icons.dataset_outlined),
        builder: (r) => DataTableBox(
          minWidth: 700,
          columns: _datasetCols(l),
          paging: Paging(
            offset: _datasetsOffset,
            pageSize: pageSize,
            total: r.total.toInt(),
            onOffset: (o) => setState(() => _datasetsOffset = o),
          ),
          rows: [
            for (final d in r.datasets)
              [
                Tooltip(
                  message: d.id,
                  child: Mono(shortHash(d.id), style: AppText.mono.copyWith(color: AppColors.link)),
                ),
                Mono(d.symbol),
                Mono(d.timeframe),
                Mono(
                  '${fmtDate(utcMs(d.fromUnixMs))} → ${fmtDate(utcMs(d.toUnixMs).subtract(const Duration(milliseconds: 1)))}',
                ),
                _quality(l, d),
                Mono('${d.experiments}'),
              ],
          ],
        ),
      ),
    );
  }

  List<String> _datasetCols(L10n l) => [
    l.dataColVersion,
    l.dataColPair,
    l.dataColTimeframe,
    l.dataColRange,
    l.dataColQuality,
    l.dataColExperiments,
  ];

  Widget _quality(L10n l, Dataset d) {
    final ok = d.gaps == 0;
    final text = [
      if (ok) l.dataQualityOk else l.dataQualityGaps(d.gaps),
      if (d.filled > 0) l.dataQualityFilled(d.filled),
    ].join(' · ');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          ok ? Icons.check_circle_outline : Icons.warning_amber_rounded,
          size: 16,
          color: ok ? AppColors.positive : AppColors.warning,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: AppText.body.copyWith(height: 1.4, color: ok ? AppColors.positive : AppColors.warningText),
          ),
        ),
      ],
    );
  }

  Widget _coverage(L10n l) {
    final v = ref.watch(coverageProvider);
    return SectionCard(
      title: l.dataCoverage,
      trailing: Text(l.dataCoverageLegend, style: AppText.caption),
      child: AsyncSection(
        value: v,
        onRetry: () => ref.invalidate(coverageProvider),
        skeleton: const SizedBox(height: 100),
        isEmpty: (r) => r.coverage.isEmpty,
        empty: EmptyState(l.dataCoverageEmpty, icon: Icons.timeline_outlined),
        builder: (r) => CoverageTimeline(coverage: r.coverage, now: widget.now ?? DateTime.now().toUtc()),
      ),
    );
  }

  Widget _issues(L10n l) {
    final v = ref.watch(issuesProvider(_issuesOffset));
    return SectionCard(
      title: l.dataIssues,
      child: AsyncSection(
        value: v,
        onRetry: () => ref.invalidate(issuesProvider(_issuesOffset)),
        skeleton: Column(
          children: [
            for (var i = 0; i < 3; i++) const Padding(padding: EdgeInsets.all(10), child: Text('—————————————')),
          ],
        ),
        isEmpty: (r) => r.issues.isEmpty,
        empty: EmptyState(l.dataIssuesEmpty, icon: Icons.verified_outlined),
        builder: (r) => DataTableBox(
          minWidth: 560,
          columns: [l.dataColQuality, l.dataColPair, l.dataColRange, ''],
          paging: Paging(
            offset: _issuesOffset,
            pageSize: pageSize,
            total: r.total.toInt(),
            onOffset: (o) => setState(() => _issuesOffset = o),
          ),
          rows: [
            for (final i in r.issues)
              [
                IssueBadge(i.kind),
                Mono(i.symbol),
                Mono(
                  i.untilUnixMs == 0
                      ? fmtDateTime(utcMs(i.atUnixMs))
                      : '${fmtDateTime(utcMs(i.atUnixMs))} → ${fmtDateTime(utcMs(i.untilUnixMs))}',
                ),
                Text(i.detail, style: AppText.caption),
              ],
          ],
        ),
      ),
    );
  }
}

/// Issue kind as text + color (never color alone).
class IssueBadge extends StatelessWidget {
  const IssueBadge(this.kind, {super.key});
  final String kind;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final (label, color) = issueKind(l, kind);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppText.body.copyWith(height: 1.4, color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/// A quality issue kind → (Persian label, color).
(String, Color) issueKind(L10n l, String kind) => switch (kind) {
  'gap' => (l.issueGap, AppColors.warning),
  'out_of_order' => (l.issueOutOfOrder, AppColors.warning),
  'duplicate' => (l.issueDuplicate, AppColors.warning),
  'bad_price' => (l.issueBadPrice, AppColors.negative),
  'zero_volume' => (l.issueZeroVolume, AppColors.textMuted),
  'correction' => (l.issueCorrection, AppColors.negative),
  'outage' => (l.issueOutage, AppColors.warning),
  _ => (kind, AppColors.textMuted),
};
