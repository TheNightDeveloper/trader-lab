import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/data.pb.dart';
import '../../gen/lab/v1/experiment.pb.dart' show ExperimentSummary;
import '../../gen/lab/v1/health.pb.dart';
import '../../l10n/app_localizations.dart';
import '../data/data_providers.dart';
import '../experiments/experiment_providers.dart';
import '../learning/learning_screen.dart';
import '../page_frame.dart';
import '../reports/report_providers.dart';

final _recentIssuesProvider = FutureProvider<ListQualityIssuesResponse>(
  (ref) => ref.watch(dataClientProvider).listQualityIssues(ListQualityIssuesRequest(pageSize: 3)),
);

/// `/`: engine status, the last learning cycle, recent experiments and alerts.
/// Every figure here comes from an engine API; the screen only arranges them.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final learning = ref.watch(learningProvider);
    final exps = ref.watch(experimentsProvider(0));
    final overview = ref.watch(overviewProvider);
    final issues = ref.watch(_recentIssuesProvider);
    final status = ref.watch(engineStatusProvider).value;
    final reports = ref.watch(reportsProvider(0)).value?.reports ?? const [];

    final lr = learning.value;
    final cfg = lr?.config;
    final open = (exps.value?.experiments ?? const <ExperimentSummary>[]).where(
      (e) => {'running', 'paused', 'finalizing'}.contains(e.status),
    );
    final running = open.fold<int>(0, (a, e) => a + e.counts.running);
    final queued = open.fold<int>(0, (a, e) => a + e.counts.queued);

    final stats = [
      StatCard(
        label: l.homeChampion,
        value: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lr == null || lr.active.versionId.isEmpty
                ? Text(l.homeChampionNone, style: AppText.body.copyWith(fontSize: 15))
                : Mono(lr.active.versionId, style: AppText.mono.copyWith(fontSize: 15)),
            Text(
              lr != null && lr.active.modelId.isNotEmpty
                  ? l.homeChampionModel(lr.active.modelId, fmtDate(utcMs(lr.active.modelAsOfUnixMs)))
                  : l.homeChampionNoModel,
              style: AppText.caption,
            ),
          ],
        ),
      ),
      StatCard(
        label: l.homeNextCycle,
        value: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cfg == null || !cfg.enabled
                ? Text(l.homeScheduleOff, style: AppText.body.copyWith(fontSize: 15))
                : Mono('${two(cfg.hourUtc)}:00 UTC', style: AppText.mono.copyWith(fontSize: 15)),
            if (cfg != null) Text(l.homeFresh(cfg.minFreshBars), style: AppText.caption),
          ],
        ),
      ),
      StatCard(
        label: l.homeQueue,
        value: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.homeQueueValue(running, queued), style: AppText.body.copyWith(fontSize: 15)),
            Text(l.homeQueueSub(open.length), style: AppText.caption),
          ],
        ),
      ),
      StatCard(
        label: l.homeData,
        value: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.homeDataValue(overview.value?.symbols.length ?? 0, issues.value?.total.toInt() ?? 0),
              style: AppText.body.copyWith(fontSize: 15),
            ),
            Text(
              status != null && status.live.state != LiveState.LIVE_STATE_OFF
                  ? l.homeDataLive(status.live.lastBarAgeSeconds.toInt())
                  : l.homeDataOff,
              style: AppText.caption,
            ),
          ],
        ),
      ),
    ];

    final alerts = <(String, Color, String)>[
      for (final i in issues.value?.issues ?? const <QualityIssue>[])
        (l.alertData, AppColors.warning, '${i.symbol} · ${i.kind} · ${fmtDateTime(utcMs(i.atUnixMs))} — ${i.detail}'),
      for (final r in reports.where((r) => r.holdoutViews > 0).take(2))
        (l.alertHoldout, AppColors.warning, l.alertHoldoutText(r.title, r.holdoutViews)),
      if (lr != null && lr.hasCurrent() && (lr.current.outcome == 'skipped' || lr.current.outcome == 'failed'))
        (l.alertEngine, AppColors.textMuted, '#${lr.current.id}: ${lr.current.reason}'),
    ];

    return PageFrame(
      children: [
        PageHeader(
          title: Dest.home.label(l),
          subtitle: Dest.home.subtitle(l),
          actions: [
            OutlinedButton.icon(
              onPressed: () => context.go(Dest.data.path),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(l.homeImport),
            ),
            FilledButton.icon(
              onPressed: () => context.go(Dest.builder.path),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l.homeNewExperiment),
            ),
          ],
        ),
        StatGrid(
          minWidth: 220,
          children: [
            for (final (i, s) in stats.indexed)
              s
                  .animate(delay: AppMotion.of(context, AppMotion.stagger) * i)
                  .fadeIn(duration: AppMotion.of(context, AppMotion.normal))
                  .slideY(begin: 0.1, curve: AppMotion.curve),
          ],
        ),
        SectionCard(
          title: l.homeLastCycle,
          trailing: TextButton(onPressed: () => context.go(Dest.learning.path), child: Text(l.homeCycleDetails)),
          child: AsyncSection(
            value: learning,
            onRetry: () => ref.invalidate(learningProvider),
            skeleton: const SizedBox(height: 120),
            isEmpty: (r) => !r.hasCurrent(),
            empty: EmptyState(l.homeNoCycle, icon: Icons.autorenew_rounded),
            builder: (r) {
              final c = r.current;
              final (oText, oColor) = outcome(l, c.outcome);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.homeCycleMeta(
                      c.id.toInt(),
                      c.trigger == 'schedule' ? l.trig_schedule : l.trig_manual,
                      '${fmtDateTime(utcMs(c.startedUnixMs))} UTC',
                    ),
                    style: AppText.label,
                  ),
                  const SizedBox(height: AppSpace.md),
                  LayoutBuilder(
                    builder: (context, box) {
                      const gap = AppSpace.sm;
                      final cols = max(1, min(c.steps.length, ((box.maxWidth + gap) / (120 + gap)).floor()));
                      final w = (box.maxWidth - gap * (cols - 1)) / cols;
                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [for (final s in c.steps) SizedBox(width: w, child: StepTile(s))],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpace.md),
                  Wrap(
                    spacing: AppSpace.md,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusText((oText, oColor)),
                      Text(c.reason, style: AppText.body.copyWith(color: AppColors.textSecondary)),
                      Text(l.homeCycleCands(c.candidates), style: AppText.caption),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        _Columns2(
          SectionCard(
            title: l.homeRecent,
            trailing: TextButton(onPressed: () => context.go(Dest.queue.path), child: Text(l.homeAllExperiments)),
            child: AsyncSection(
              value: exps,
              onRetry: () => ref.invalidate(experimentsProvider(0)),
              skeleton: const SizedBox(height: 160),
              isEmpty: (r) => r.experiments.isEmpty,
              empty: Column(
                children: [
                  EmptyState(l.homeNoExperiments, icon: Icons.science_outlined),
                  FilledButton(onPressed: () => context.go(Dest.builder.path), child: Text(l.homeNewExperiment)),
                ],
              ),
              builder: (r) => DataTableBox(
                minWidth: 560,
                columns: [l.qColName, l.qColStatus, l.qColProgress, l.qColCreated],
                rows: [
                  for (final e in r.experiments.take(5))
                    [
                      InkWell(
                        onTap: () => context.go('/experiments/${e.id}/queue'),
                        child: Text(e.name, style: AppText.body.copyWith(color: AppColors.link, height: 1.4)),
                      ),
                      StatusText(runStatus(l, e.status)),
                      Mono('${e.counts.done + e.counts.failed + e.counts.cancelled} / ${e.counts.total}'),
                      Mono(fmtDate(utcMs(e.createdUnixMs))),
                    ],
                ],
              ),
            ),
          ),
          SectionCard(
            title: l.homeAlerts,
            child: alerts.isEmpty
                ? EmptyState(l.homeNoAlerts, icon: Icons.check_circle_outline_rounded)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (kind, color, text) in alerts)
                        Container(
                          margin: const EdgeInsets.only(bottom: AppSpace.sm),
                          padding: const EdgeInsets.all(AppSpace.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceRaised,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StatusText((kind, color)),
                              Text(text, style: AppText.caption.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// 3:2 side by side when wide, stacked when narrow.
class _Columns2 extends StatelessWidget {
  const _Columns2(this.a, this.b);
  final Widget a, b;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => box.maxWidth < 1000
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              a,
              const SizedBox(height: AppSpace.lg),
              b,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: a),
              const SizedBox(width: AppSpace.lg),
              Expanded(flex: 2, child: b),
            ],
          ),
  );
}
