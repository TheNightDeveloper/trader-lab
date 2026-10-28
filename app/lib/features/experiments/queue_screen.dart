import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/report_widgets.dart';
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/common.pb.dart' as pb;
import '../../gen/lab/v1/experiment.pb.dart';
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';
import 'experiment_providers.dart';

const _live = {'running', 'paused', 'finalizing'};

int _finished(AttemptCounts c) => c.done + c.failed + c.cancelled;

/// done / failed / cancelled / running as one bar.
StackedBar _progress(AttemptCounts c, {double height = 10}) => StackedBar(
  height: height,
  total: c.total,
  segments: [
    (c.done, AppColors.positive),
    (c.failed, AppColors.negative),
    (c.cancelled, AppColors.textMuted),
    (c.running, AppColors.accent),
  ],
);

/// `/queue`: every experiment, newest first.
class QueueListScreen extends ConsumerStatefulWidget {
  const QueueListScreen({super.key});

  @override
  ConsumerState<QueueListScreen> createState() => _QueueListScreenState();
}

class _QueueListScreenState extends ConsumerState<QueueListScreen> {
  int _offset = 0;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    // Running experiments move; refresh the page while any is live.
    _poll = Timer.periodic(const Duration(seconds: 3), (_) {
      final r = ref.read(experimentsProvider(_offset)).value;
      if (r != null && r.experiments.any((e) => _live.contains(e.status))) ref.invalidate(experimentsProvider(_offset));
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final list = ref.watch(experimentsProvider(_offset));
    final cols = [l.qColName, l.qColStatus, l.qColProgress, l.qColCreated];
    final newButton = FilledButton.icon(
      onPressed: () => context.go(Dest.builder.path),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: Text(l.qNew),
    );
    return PageFrame(
      children: [
        PageHeader(title: Dest.queue.label(l), subtitle: Dest.queue.subtitle(l), actions: [newButton]),
        SectionCard(
          child: AsyncSection(
            value: list,
            onRetry: () => ref.invalidate(experimentsProvider(_offset)),
            skeleton: DataTableBox(
              columns: cols,
              rows: [
                for (var i = 0; i < 3; i++) [for (var j = 0; j < cols.length; j++) const Text('————')],
              ],
            ),
            isEmpty: (r) => r.experiments.isEmpty,
            empty: Column(
              children: [
                EmptyState(l.qListEmpty, icon: Icons.science_outlined),
                newButton,
              ],
            ),
            builder: (r) => DataTableBox(
              minWidth: 720,
              columns: cols,
              paging: Paging(
                offset: _offset,
                pageSize: experimentsPageSize,
                total: r.total.toInt(),
                onOffset: (o) => setState(() => _offset = o),
              ),
              rows: [
                for (final e in r.experiments)
                  [
                    InkWell(
                      onTap: () => context.go('/experiments/${e.id}/queue'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name, style: AppText.body.copyWith(color: AppColors.link, height: 1.4)),
                          Mono(
                            '${e.id} · ${e.algorithmVersion}',
                            style: AppText.mono.copyWith(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    StatusText(runStatus(l, e.status)),
                    SizedBox(
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _progress(e.counts, height: 6),
                          const SizedBox(height: AppSpace.xs),
                          Mono('${_finished(e.counts)} / ${e.counts.total}'),
                        ],
                      ),
                    ),
                    Mono(fmtDateTime(utcMs(e.createdUnixMs))),
                  ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// `/experiments/:id/queue`: live progress, budget, result and the attempt registry.
class ExperimentQueueScreen extends ConsumerStatefulWidget {
  const ExperimentQueueScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ExperimentQueueScreen> createState() => _ExperimentQueueScreenState();
}

class _ExperimentQueueScreenState extends ConsumerState<ExperimentQueueScreen> {
  String _tab = '';
  int _offset = 0;
  bool _busy = false;

  AttemptsQuery get _query => (id: widget.id, status: _tab, offset: _offset);

  Future<void> _act(String title, String? body, Future<void> Function() call) async {
    if (body != null && !await confirmAction(context, title: title, body: body)) return;
    setState(() => _busy = true);
    try {
      await call();
      ref.invalidate(experimentProvider(widget.id));
      ref.invalidate(experimentsProvider);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final exp = ref.watch(experimentProvider(widget.id));
    final watch = ref.watch(experimentWatchProvider(widget.id));
    ref.listen(experimentWatchProvider(widget.id), (prev, next) {
      final a = prev?.value, b = next.value;
      if (b == null) return;
      if (a == null || a.counts != b.counts) ref.invalidate(attemptsProvider(_query));
      if (a != null && a.status != b.status) {
        ref.invalidate(experimentProvider(widget.id));
        ref.invalidate(experimentsProvider);
      }
    });
    final w = watch.value;
    final summary = exp.value?.summary;
    final status = w?.status ?? summary?.status ?? '';
    final def = exp.value?.definition;

    return PageFrame(
      children: [
        PageHeader(
          title: Dest.queue.label(l),
          subtitle: summary == null
              ? null
              : '${summary.name} · ${summary.algorithmVersion} · ${def?.search.mode ?? ''} · seed ${def?.search.seed ?? ''}',
          actions: [
            if (status == 'running')
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _act(
                        l.qPause,
                        l.qPauseConfirm,
                        () => ref
                            .read(experimentClientProvider)
                            .pauseExperiment(PauseExperimentRequest(experimentId: widget.id)),
                      ),
                icon: const Icon(Icons.pause_rounded, size: 18),
                label: Text(l.qPause),
              ),
            if (status == 'paused')
              FilledButton.icon(
                onPressed: _busy
                    ? null
                    : () => _act(
                        l.qResume,
                        null,
                        () => ref
                            .read(experimentClientProvider)
                            .resumeExperiment(ResumeExperimentRequest(experimentId: widget.id)),
                      ),
                icon: const Icon(Icons.play_arrow_rounded, size: 18),
                label: Text(l.qResume),
              ),
            if (status == 'running' || status == 'paused')
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.negativeText),
                onPressed: _busy
                    ? null
                    : () => _act(
                        l.qCancel,
                        l.qCancelConfirm,
                        () => ref
                            .read(experimentClientProvider)
                            .cancelExperiment(CancelExperimentRequest(experimentId: widget.id)),
                      ),
                icon: const Icon(Icons.stop_rounded, size: 18),
                label: Text(l.qCancel),
              ),
          ],
        ),
        if (exp.hasError) ErrorBox(error: exp.error!, onRetry: () => ref.invalidate(experimentProvider(widget.id))),
        if (w != null) ...[
          _ProgressCard(w),
          _Budget(w),
        ] else if (!exp.hasError)
          AsyncSection(
            value: watch,
            onRetry: () => ref.invalidate(experimentWatchProvider(widget.id)),
            skeleton: const SectionCard(child: SizedBox(height: 120)),
            builder: (_) => const SizedBox.shrink(),
          ),
        if (exp.value case final e? when e.hasResult() || e.error.isNotEmpty) _ResultCard(e),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabChoiceChips<String>(
                options: [
                  ('', l.qTabAll),
                  for (final s in ['queued', 'running', 'done', 'failed', 'cancelled']) (s, runStatus(l, s).$1),
                ],
                selected: {_tab},
                onChanged: (v) => setState(() {
                  _tab = v.first;
                  _offset = 0;
                }),
              ),
              const SizedBox(height: AppSpace.md),
              _Attempts(query: _query, onOffset: (o) => setState(() => _offset = o)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard(this.w);
  final WatchExperimentResponse w;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final c = w.counts;
    final done = _finished(c);
    final left = c.total - done;
    // Rough: average time per finished attempt so far × attempts left.
    final eta = done == 0 || left == 0 ? null : (w.elapsedSeconds.toInt() * left / done).round();
    Widget legend(String status, int n) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusText(runStatus(l, status)),
        const SizedBox(width: AppSpace.xs),
        Mono('$n'),
      ],
    );
    return SectionCard(
      title: l.qProgress,
      trailing: StatusText(runStatus(l, w.status)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpace.lg,
            runSpacing: AppSpace.sm,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Mono('$done / ${c.total}', style: AppText.mono.copyWith(fontSize: 16)),
                  const SizedBox(width: AppSpace.sm),
                  Text(l.qAttempts, style: AppText.body),
                ],
              ),
              if (eta != null && _live.contains(w.status))
                Text('${l.qRemaining}: ${humanDuration(l, eta < 60 ? 60 : eta)}', style: AppText.label),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          _progress(c, height: 12),
          const SizedBox(height: AppSpace.md),
          Wrap(
            spacing: AppSpace.lg,
            runSpacing: AppSpace.sm,
            children: [
              legend('done', c.done),
              legend('failed', c.failed),
              legend('cancelled', c.cancelled),
              legend('running', c.running),
              legend('queued', c.queued),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Text(l.qAllRecorded, style: AppText.caption),
        ],
      ),
    );
  }
}

class _Budget extends StatelessWidget {
  const _Budget(this.w);
  final WatchExperimentResponse w;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    // words: Persian text (durations) that must flow RTL, not a mono LTR number.
    Widget stat(String label, String value, int n, int of, Color color, {bool words = false}) => StatCard(
      label: label,
      value: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          words
              ? Text(value, style: AppText.body.copyWith(fontSize: 15, height: 1.4))
              : Mono(value, style: AppText.mono.copyWith(fontSize: 15)),
          const SizedBox(height: AppSpace.sm),
          StackedBar(height: 6, total: of, segments: [(n, color)]),
        ],
      ),
    );
    final elapsed = w.elapsedSeconds.toInt(), wall = w.wallBudgetSeconds.toInt();
    final cachePct = w.cacheLooked == 0 ? 0 : (100 * w.cacheHits / w.cacheLooked).round();
    final best = w.hasBestObjective() ? formatMetric(l, w.bestObjective) : null;
    return StatGrid(
      minWidth: 220,
      children: [
        stat(
          l.qBudgetAttempts,
          '${_finished(w.counts)} / ${w.attemptBudget}',
          _finished(w.counts),
          w.attemptBudget,
          AppColors.accent,
        ),
        stat(
          l.qBudgetTime,
          '${humanDuration(l, elapsed)} / ${humanDuration(l, wall)}',
          elapsed,
          wall,
          AppColors.accent,
          words: true,
        ),
        stat(
          l.qBudgetCpu,
          '${w.researchSlotsInUse} / ${w.researchSlots}',
          w.researchSlotsInUse,
          w.researchSlots,
          AppColors.warning,
        ),
        stat(l.qCacheRate, '$cachePct%', w.cacheHits, w.cacheLooked, AppColors.positive),
        StatCard(
          label: l.qBest,
          value: best == null
              ? const Mono('—')
              : Mono(
                  best.unit == null ? best.text : '${best.text} ${best.unit}',
                  style: AppText.mono.copyWith(fontSize: 15, color: signColor(best.sign)),
                ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard(this.e);
  final GetExperimentResponse e;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final r = e.result;
    final chosen = e.hasResult() && r.chosen > 0;
    return SectionCard(
      title: l.qResult,
      tone: chosen ? CardTone.positive : CardTone.normal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (e.error.isNotEmpty) WarningBanner(e.error),
          if (chosen) ...[
            Text(l.qChosen(r.chosen), style: AppText.sectionTitle),
            const SizedBox(height: AppSpace.xs),
            Mono(fmtParams(Map.of(r.params))),
            if (r.hasObjective()) MetricTile(r.objective),
            Text(l.qChosenNote(r.eligibleCandidates, r.candidates, r.attempts), style: AppText.caption),
            if (r.reportIds.isNotEmpty) ...[
              const SizedBox(height: AppSpace.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: FilledButton.icon(
                  onPressed: () => context.go('/reports/${r.reportIds.first}'),
                  icon: const Icon(Icons.assessment_outlined, size: 18),
                  label: Text(l.qOpenReport),
                ),
              ),
            ],
          ] else if (e.hasResult()) ...[
            Text(l.qNone, style: AppText.sectionTitle),
            if (r.reason.isNotEmpty) Text(r.reason, style: AppText.body.copyWith(color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }
}

class _Attempts extends ConsumerWidget {
  const _Attempts({required this.query, required this.onOffset});
  final AttemptsQuery query;
  final ValueChanged<int> onOffset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final page = ref.watch(attemptsProvider(query));
    final cols = [
      '#',
      l.qColParams,
      l.qColPair,
      l.qColStatus,
      l.qColReturn,
      l.qColDd,
      l.qColTrades,
      l.qColConstraints,
      l.qColCache,
    ];
    Widget metric(pb.Metric m) {
      final t = formatMetric(l, m);
      return Mono(
        t.unit == null ? t.text : '${t.text} ${t.unit}',
        style: AppText.mono.copyWith(color: m.key == 'max_drawdown' ? null : signColor(t.sign)),
      );
    }

    return AsyncSection(
      value: page,
      onRetry: () => ref.invalidate(attemptsProvider(query)),
      skeleton: DataTableBox(
        columns: cols,
        rows: [
          for (var i = 0; i < 4; i++) [for (var j = 0; j < cols.length; j++) const Text('———')],
        ],
      ),
      isEmpty: (r) => r.attempts.isEmpty,
      empty: EmptyState(l.qEmpty),
      builder: (r) => DataTableBox(
        minWidth: 1000,
        columns: cols,
        paging: Paging(offset: query.offset, pageSize: attemptsPageSize, total: r.total.toInt(), onOffset: onOffset),
        rows: [
          for (final a in r.attempts)
            [
              Mono('${a.seq}'),
              Mono(fmtParams(Map.of(a.params))),
              Mono(a.symbol),
              a.failure.isEmpty
                  ? StatusText(runStatus(l, a.status))
                  : Tooltip(message: a.failure, child: StatusText(runStatus(l, a.status))),
              a.hasTotalReturn() ? metric(a.totalReturn) : const Mono('—'),
              a.hasMaxDrawdown() ? metric(a.maxDrawdown) : const Mono('—'),
              a.hasTrades() ? metric(a.trades) : const Mono('—'),
              !a.hasEligibility
                  ? const Mono('—')
                  : a.eligible
                  ? Text(l.qEligible, style: AppText.body.copyWith(color: AppColors.positive, height: 1.4))
                  : Text(
                      l.qRejected(a.violations.join('، ')),
                      style: AppText.body.copyWith(color: AppColors.negativeText, height: 1.4),
                    ),
              Tooltip(message: l.qRuns(a.runs), child: Mono(a.cache.isEmpty ? '—' : a.cache)),
            ],
        ],
      ),
    );
  }
}
