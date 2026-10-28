import 'dart:async';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/validate.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/report_widgets.dart';
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/common.pb.dart' as pb;
import '../../gen/lab/v1/learning.pb.dart';
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';

const cyclesPageSize = 10;

final learningProvider = FutureProvider<GetLearningResponse>(
  (ref) => ref.watch(learningClientProvider).getLearning(GetLearningRequest()),
);

final cyclesProvider = FutureProvider.family<ListCyclesResponse, int>(
  (ref, offset) =>
      ref.watch(learningClientProvider).listCycles(ListCyclesRequest(pageSize: cyclesPageSize, offset: offset)),
);

final modelsProvider = FutureProvider<ListModelsResponse>(
  (ref) => ref.watch(learningClientProvider).listModels(ListModelsRequest()),
);

final candidatesProvider = FutureProvider.family<ListCandidatesResponse, Int64>(
  (ref, id) => ref.watch(learningClientProvider).listCandidates(ListCandidatesRequest(cycleId: id)),
);

const _running = {'collect', 'labels', 'generate', 'train', 'walk_forward'};

String stepLabel(L10n l, String k) => switch (k) {
  'collect' => l.ls_collect,
  'labels' => l.ls_labels,
  'generate' => l.ls_generate,
  'train' => l.ls_train,
  'walk_forward' => l.ls_walk_forward,
  'forward_test' => l.ls_forward_test,
  'decision' => l.ls_decision,
  _ => k,
};

/// Step status → (label, color); the decision step waits for the user.
(String, Color) stepStatus(L10n l, CycleStep s) => switch (s.status) {
  'done' => (l.lst_done, AppColors.positive),
  'running' => (l.lst_running, AppColors.accent),
  'waiting' when s.key == 'decision' => (l.lst_waiting_you, AppColors.warning),
  'waiting' => (l.lst_waiting, AppColors.accent),
  'skipped' => (l.lst_skipped, AppColors.textMuted),
  _ => (l.lst_pending, AppColors.textMuted),
};

(String, Color) outcome(L10n l, String o) => switch (o) {
  'skipped' => (l.lo_skipped, AppColors.warning),
  'failed' => (l.lo_failed, AppColors.negativeText),
  'not_better' => (l.lo_not_better, AppColors.textMuted),
  'gate_failed' => (l.lo_gate_failed, AppColors.textMuted),
  'recommended' => (l.lo_recommended, AppColors.accent),
  'approved' => (l.lo_approved, AppColors.positive),
  'rejected' => (l.lo_rejected, AppColors.textMuted),
  _ => (l.lo_running, AppColors.accent),
};

Widget metricText(L10n l, pb.Metric? m, {bool tone = true}) {
  if (m == null) return const Mono('—');
  final t = formatMetric(l, m);
  return Mono(
    t.unit == null ? t.text : '${t.text} ${t.unit}',
    style: AppText.mono.copyWith(color: tone ? signColor(t.sign) : null),
  );
}

/// Side by side when wide (flex weights), stacked when narrow.
class _Columns extends StatelessWidget {
  const _Columns(this.children, {this.flex});
  final List<Widget> children;
  final List<int>? flex;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => box.maxWidth < 1000
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, c) in children.indexed) ...[if (i > 0) const SizedBox(height: AppSpace.lg), c],
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, c) in children.indexed) ...[
                if (i > 0) const SizedBox(width: AppSpace.lg),
                Expanded(flex: flex?[i] ?? 1, child: c),
              ],
            ],
          ),
  );
}

class LearningScreen extends ConsumerStatefulWidget {
  const LearningScreen({super.key});

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen> {
  Timer? _poll;
  int _offset = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // A running cycle moves step by step; refresh while one runs.
    _poll = Timer.periodic(const Duration(seconds: 3), (_) {
      final cur = ref.read(learningProvider).value?.current;
      if (cur != null && _running.contains(cur.state)) _refresh();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  void _refresh() {
    ref.invalidate(learningProvider);
    ref.invalidate(cyclesProvider);
    ref.invalidate(modelsProvider);
  }

  static Future<String?> _quiet(Future<Object?> f) async {
    await f;
    return null;
  }

  /// Runs a user action; a returned message is shown when it succeeds.
  Future<void> _act(Future<String?> Function() call) async {
    setState(() => _busy = true);
    try {
      final done = await call();
      _refresh();
      if (done != null && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final st = ref.watch(learningProvider);
    final r = st.value;
    final cfg = r?.config;
    final open = r != null && r.hasCurrent() && r.current.state != 'done';
    final client = ref.read(learningClientProvider);
    return PageFrame(
      children: [
        PageHeader(
          title: Dest.learning.label(l),
          subtitle: cfg == null
              ? Dest.learning.subtitle(l)
              : cfg.enabled
              ? l.lSubtitle('${two(cfg.hourUtc)}:00', cfg.minFreshBars)
              : l.lSubtitleOff,
          actions: [
            OutlinedButton.icon(
              onPressed: r == null ? null : () => _configure(r),
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: Text(l.lConfig),
            ),
            FilledButton.icon(
              onPressed: r == null || open || _busy
                  ? null
                  : () => _act(() async {
                      final s = await client.startCycle(StartCycleRequest());
                      return l.lStarted(s.cycleId.toInt());
                    }),
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: Text(l.lRunNow),
            ),
          ],
        ),
        AsyncSection(
          value: st,
          onRetry: _refresh,
          skeleton: const SectionCard(child: SizedBox(height: 160)),
          builder: (r) => !r.hasCurrent()
              ? SectionCard(child: EmptyState(l.lHistoryEmpty, icon: Icons.autorenew_rounded))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CycleCard(r.current),
                    const SizedBox(height: AppSpace.lg),
                    _Columns([
                      _ContenderCard(r.current.champion, active: r.active, champion: true),
                      _ContenderCard(r.current.hasChallenger() ? r.current.challenger : null, champion: false),
                      _GateCard(
                        r.current,
                        busy: _busy,
                        onApprove: () async {
                          final c = r.current;
                          final ok = await confirmAction(
                            context,
                            title: l.lApprove,
                            body: l.lApproveConfirm(
                              r.active.versionId.isEmpty ? l.lNone : r.active.versionId,
                              c.challenger.change,
                              c.challenger.modelId,
                            ),
                          );
                          if (ok) await _act(() => _quiet(client.approveCycle(ApproveCycleRequest(cycleId: c.id))));
                        },
                        onReject: () async {
                          final ok = await confirmAction(context, title: l.lReject, body: l.lRejectConfirm);
                          if (!ok) return;
                          await _act(() => _quiet(client.rejectCycle(RejectCycleRequest(cycleId: r.current.id))));
                        },
                      ),
                    ]),
                    const SizedBox(height: AppSpace.lg),
                    _Candidates(r.current),
                  ],
                ),
        ),
        _Columns(
          flex: const [3, 2],
          [
            _History(offset: _offset, onOffset: (o) => setState(() => _offset = o)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Models(
                  canRollback: r?.canRollback ?? false,
                  onRollback: () async {
                    final ok = await confirmAction(context, title: l.lRollback, body: l.lRollbackConfirm);
                    if (ok) await _act(() => _quiet(client.rollback(RollbackRequest())));
                  },
                ),
                if (r != null && r.hasCurrent()) ...[const SizedBox(height: AppSpace.lg), _Budget(r.current.usage)],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _configure(GetLearningResponse r) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfigDialog(r.config, r.learningAlgorithms),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context).lcSaved)));
    }
  }
}

class _CycleCard extends StatelessWidget {
  const _CycleCard(this.c);
  final Cycle c;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final current = c.steps.where((s) => s.status == 'running' || s.status == 'waiting').firstOrNull;
    final (oText, oColor) = outcome(l, c.outcome);
    return SectionCard(
      title: '${l.lCurrent} #${c.id}',
      trailing: Wrap(
        spacing: AppSpace.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (current != null) Text(l.lStage(stepLabel(l, current.key)), style: AppText.label),
          if (current?.key == 'forward_test')
            Text(l.lForwardDay(c.forwardDays, c.forwardDaysTarget), style: AppText.label),
          StatusText((oText, oColor)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, box) {
              const gap = AppSpace.sm;
              final cols = max(1, min(c.steps.length, ((box.maxWidth + gap) / (120 + gap)).floor()));
              final w = (box.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final (i, s) in c.steps.indexed)
                    SizedBox(width: w, child: StepTile(s))
                        .animate(delay: AppMotion.of(context, AppMotion.stagger) * i)
                        .fadeIn(duration: AppMotion.of(context, AppMotion.normal)),
                ],
              );
            },
          ),
          if (c.reason.isNotEmpty) ...[
            const SizedBox(height: AppSpace.md),
            Text(c.reason, style: AppText.body.copyWith(color: oColor)),
          ],
        ],
      ),
    );
  }
}

class StepTile extends StatelessWidget {
  const StepTile(this.s, {super.key});
  final CycleStep s;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final (label, color) = stepStatus(l, s);
    final live = s.status == 'running' || s.status == 'waiting';
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.normal),
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: live ? AppColors.accentStrongBg : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: live ? AppColors.accentBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.caption.copyWith(color: color)),
          Text(stepLabel(l, s.key), style: AppText.body.copyWith(fontWeight: FontWeight.w700, height: 1.5)),
          Mono(s.meta.isEmpty ? '—' : s.meta, style: AppText.mono.copyWith(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _ContenderCard extends StatelessWidget {
  const _ContenderCard(this.c, {required this.champion, this.active});
  final Contender? c;
  final bool champion;
  final ActiveModel? active;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final c = this.c;
    final role = champion
        ? (c?.active ?? false)
              ? l.lChampion
              : l.lChampionBaseline
        : l.lChallenger;
    if (c == null) {
      return SectionCard(title: role, child: EmptyState(l.lNoChallenger));
    }
    final fwd = c.forward.isNotEmpty;
    final ms = fwd ? c.forward : c.walk;
    Widget row(String k, Widget v) => Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(k, style: AppText.label)),
          v,
        ],
      ),
    );
    return SectionCard(
      title: role,
      tone: champion ? CardTone.normal : CardTone.positive,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Mono(
            champion ? c.versionId : c.modelId,
            style: AppText.mono.copyWith(
              fontWeight: FontWeight.w700,
              color: champion ? AppColors.positive : AppColors.accent,
            ),
          ),
          const SizedBox(height: AppSpace.xs),
          if (!champion || c.modelId.isNotEmpty)
            Text(
              champion
                  ? c.active && active != null && active!.modelId.isNotEmpty
                        ? l.lModelSince(c.modelId, fmtDate(utcMs(active!.modelAsOfUnixMs)))
                        : l.lBaselineDesc
                  : l.lChange(c.change, c.seq),
              style: AppText.caption,
            ),
          const SizedBox(height: AppSpace.sm),
          row(fwd ? l.lFwdReturn : l.lWalkReturn, metricText(l, metricOf(ms, 'total_return'))),
          row(l.lMaxDd, metricText(l, metricOf(ms, 'max_drawdown'), tone: false)),
          row(l.lTrades, metricText(l, metricOf(ms, 'trades'), tone: false)),
          row(l.lFees, metricText(l, metricOf(ms, 'fees'))),
        ],
      ),
    );
  }
}

class _GateCard extends StatelessWidget {
  const _GateCard(this.c, {required this.onApprove, required this.onReject, required this.busy});
  final Cycle c;
  final VoidCallback onApprove, onReject;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final allPass = c.gate.isNotEmpty && c.gate.every((g) => g.status == 'pass');
    return SectionCard(
      title: l.lGate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (c.gate.isEmpty) Text(l.lGateEmpty, style: AppText.caption),
          for (final g in c.gate)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Pill(g.status),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(child: Text(g.text, style: AppText.body.copyWith(fontSize: 13, height: 1.7))),
                ],
              ),
            ),
          const SizedBox(height: AppSpace.md),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              // The engine decides when approval is possible; the UI never guesses.
              FilledButton.icon(
                onPressed: c.canApprove && allPass && !busy ? onApprove : null,
                icon: const Icon(Icons.verified_outlined, size: 18),
                label: Text(l.lApprove),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.negativeText),
                onPressed: c.canApprove && !busy ? onReject : null,
                child: Text(l.lReject),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.status);
  final String status;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final (text, color) = switch (status) {
      'pass' => (l.gPass, AppColors.positive),
      'fail' => (l.gFail, AppColors.negative),
      _ => (l.gPending, AppColors.warning),
    };
    return Container(
      constraints: const BoxConstraints(minWidth: 64),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(
        text,
        style: AppText.caption.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Every candidate of the cycle, with why it was or was not eligible.
class _Candidates extends ConsumerStatefulWidget {
  const _Candidates(this.c);
  final Cycle c;

  @override
  ConsumerState<_Candidates> createState() => _CandidatesState();
}

class _CandidatesState extends ConsumerState<_Candidates> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    if (widget.c.candidates == 0) return const SizedBox.shrink();
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => setState(() => _open = !_open),
              icon: AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: AppMotion.of(context, AppMotion.fast),
                child: const Icon(Icons.expand_more_rounded),
              ),
              label: Text(l.lCandidates(widget.c.candidates)),
            ),
          ),
          AnimatedSize(
            duration: AppMotion.of(context, AppMotion.normal),
            curve: AppMotion.curve,
            alignment: AlignmentDirectional.topStart,
            child: !_open
                ? const SizedBox(width: double.infinity)
                : _table(l, ref.watch(candidatesProvider(Int64(widget.c.id.toInt())))),
          ),
        ],
      ),
    );
  }

  Widget _table(L10n l, AsyncValue<ListCandidatesResponse> v) {
    final cols = ['#', l.cChange, l.qColStatus, l.lWalkReturn, l.lMaxDd, l.cWins, l.qColConstraints];
    return AsyncSection(
      value: v,
      onRetry: () => ref.invalidate(candidatesProvider(widget.c.id)),
      skeleton: const SizedBox(height: 120),
      builder: (r) => DataTableBox(
        minWidth: 860,
        columns: cols,
        rows: [
          for (final c in r.candidates)
            [
              Mono('${c.seq}'),
              Mono(c.change),
              c.failure.isEmpty
                  ? StatusText(runStatus(l, c.status))
                  : Tooltip(message: c.failure, child: StatusText(runStatus(l, c.status))),
              metricText(l, c.hasTotalReturn() ? c.totalReturn : null),
              metricText(l, c.hasMaxDrawdown() ? c.maxDrawdown : null, tone: false),
              Mono('${c.wins}'),
              c.status != 'done'
                  ? const Mono('—')
                  : c.eligible
                  ? Text(l.qEligible, style: AppText.body.copyWith(color: AppColors.positive, height: 1.4))
                  : Text(c.why, style: AppText.body.copyWith(color: AppColors.textMuted, height: 1.4)),
            ],
        ],
      ),
    );
  }
}

class _History extends ConsumerWidget {
  const _History({required this.offset, required this.onOffset});
  final int offset;
  final ValueChanged<int> onOffset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final v = ref.watch(cyclesProvider(offset));
    final cols = [l.hCycle, l.hTrigger, l.hCands, l.hBest, l.hDecision];
    return SectionCard(
      title: l.lHistory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AsyncSection(
            value: v,
            onRetry: () => ref.invalidate(cyclesProvider(offset)),
            skeleton: const SizedBox(height: 160),
            isEmpty: (r) => r.cycles.isEmpty,
            empty: EmptyState(l.lHistoryEmpty),
            builder: (r) => DataTableBox(
              minWidth: 560,
              columns: cols,
              paging: Paging(offset: offset, pageSize: cyclesPageSize, total: r.total.toInt(), onOffset: onOffset),
              rows: [
                for (final c in r.cycles)
                  [
                    Mono('#${c.id}'),
                    Text(c.trigger == 'schedule' ? l.trig_schedule : l.trig_manual, style: AppText.body),
                    Mono('${c.candidates}'),
                    metricText(l, c.hasChallenger() ? metricOf(c.challenger.forward, 'total_return') : null),
                    Tooltip(message: c.reason, child: StatusText(outcome(l, c.outcome))),
                  ],
              ],
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          Text(l.lHistoryNote, style: AppText.caption),
        ],
      ),
    );
  }
}

class _Models extends ConsumerWidget {
  const _Models({required this.canRollback, required this.onRollback});
  final bool canRollback;
  final VoidCallback onRollback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final v = ref.watch(modelsProvider);
    return SectionCard(
      title: l.lModels,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AsyncSection(
            value: v,
            onRetry: () => ref.invalidate(modelsProvider),
            skeleton: const SizedBox(height: 120),
            isEmpty: (r) => r.models.isEmpty,
            empty: EmptyState(l.lModelsEmpty, icon: Icons.memory_rounded),
            builder: (r) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final m in r.models.take(8))
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpace.sm),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Mono(
                                m.versionId.isEmpty ? m.id : '${m.id} · ${m.versionId}',
                                style: AppText.mono.copyWith(fontSize: 13),
                              ),
                            ),
                            StatusText(switch (m.status) {
                              'active' => (l.ms_active, AppColors.positive),
                              'challenger' => (l.ms_challenger, AppColors.accent),
                              'baseline' => (l.ms_baseline, AppColors.warning),
                              _ => (l.ms_archived, AppColors.textMuted),
                            }),
                          ],
                        ),
                        Mono(
                          'train ≤ ${fmtDate(utcMs(m.asOfUnixMs))} · seed ${m.seed} · sha ${shortHash(m.recipeHash, prefix: '')}',
                          style: AppText.mono.copyWith(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (canRollback)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: onRollback,
                icon: const Icon(Icons.undo_rounded, size: 18),
                label: Text(l.lRollback),
              ),
            ),
        ],
      ),
    );
  }
}

class _Budget extends StatelessWidget {
  const _Budget(this.u);
  final CycleUsage u;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    Widget row(String k, String v, int n, int of, {bool words = false}) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(k, style: AppText.label)),
              words ? Text(v, style: AppText.body.copyWith(height: 1.4)) : Mono(v),
            ],
          ),
          const SizedBox(height: AppSpace.xs),
          StackedBar(height: 6, total: of, segments: [(n, n > of ? AppColors.negative : AppColors.accent)]),
        ],
      ),
    );
    String count(Int64 v) => formatDecimal(Decimal.parse(v.toString()));
    final cpu = u.cpuSeconds.toInt(), cpuMax = u.cpuBudgetSeconds.toInt();
    return SectionCard(
      title: l.lBudget,
      child: Column(
        children: [
          row(l.bCpu, '${humanDuration(l, cpu)} / ${humanDuration(l, cpuMax)}', cpu, cpuMax, words: true),
          row(l.bBars, '${count(u.bars)} / ${count(u.maxBars)}', u.bars.toInt(), u.maxBars.toInt()),
          row(l.bCands, '${u.candidates} / ${u.maxCandidates}', u.candidates, u.maxCandidates),
        ],
      ),
    );
  }
}

/// Schedule, budgets and the gate. Saved settings apply from the next cycle: a
/// running cycle keeps the gate it was registered with.
class _ConfigDialog extends ConsumerStatefulWidget {
  const _ConfigDialog(this.cfg, this.algorithms);
  final LearningConfig cfg;
  final List<String> algorithms;

  @override
  ConsumerState<_ConfigDialog> createState() => _ConfigDialogState();
}

class _ConfigDialogState extends ConsumerState<_ConfigDialog> {
  late final Map<String, String> f;
  late String _alg = widget.cfg.algorithmId;
  late bool _enabled = widget.cfg.enabled;
  bool _tried = false, _saving = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    final c = widget.cfg, g = c.gate;
    String pct(pb.Decimal d) => fractionToPct(d).toString();
    f = {
      'hour': '${c.hourUtc}',
      'lookback': '${c.lookbackDays}',
      'fresh': '${c.minFreshBars}',
      'folds': '${c.folds}',
      'cands': '${c.maxCandidates}',
      'cpu': '${c.cpuMinutes}',
      'bars': '${c.maxBars}',
      'maxDd': pct(g.maxDrawdown),
      'trades': '${g.minForwardTrades}',
      'days': '${g.forwardDays}',
      'improve': pct(g.minImprovement),
      'ddDeg': pct(g.maxDdDegradation),
      'wins': '${g.minWalkWins}',
    };
  }

  Map<String, String? Function(String)> _rules(L10n l) => {
    'hour': (s) => vInt(l, s, 0, 23),
    'lookback': (s) => vInt(l, s, 7, 3650),
    'fresh': (s) => vInt(l, s, 1, 1000000),
    'folds': (s) => vInt(l, s, 1, 12),
    'cands': (s) => vInt(l, s, 1, 200),
    'cpu': (s) => vInt(l, s, 1, 1440),
    'bars': (s) => vInt(l, s, 1000, 100000000),
    'maxDd': (s) => vPositive(l, s),
    'trades': (s) => vInt(l, s, 0, 100000),
    'days': (s) => vInt(l, s, 1, 365),
    'improve': (s) => vNonNegative(l, s),
    'ddDeg': (s) => vNonNegative(l, s),
    'wins': (s) => vInt(l, s, 0, int.tryParse(f['folds']!.trim()) ?? 12),
  };

  Future<void> _save(L10n l) async {
    final rules = _rules(l);
    if (rules.entries.any((e) => e.value(f[e.key]!) != null)) return setState(() => _tried = true);
    final c = widget.cfg.deepCopy()
      ..algorithmId = _alg
      ..enabled = _enabled
      ..hourUtc = int.parse(f['hour']!.trim())
      ..lookbackDays = int.parse(f['lookback']!.trim())
      ..minFreshBars = int.parse(f['fresh']!.trim())
      ..folds = int.parse(f['folds']!.trim())
      ..maxCandidates = int.parse(f['cands']!.trim())
      ..cpuMinutes = int.parse(f['cpu']!.trim())
      ..maxBars = Int64.parseInt(f['bars']!.trim());
    c.gate
      ..maxDrawdown = pctOut(Decimal.parse(f['maxDd']!.trim()))
      ..minForwardTrades = int.parse(f['trades']!.trim())
      ..forwardDays = int.parse(f['days']!.trim())
      ..minImprovement = pctOut(Decimal.parse(f['improve']!.trim()))
      ..maxDdDegradation = pctOut(Decimal.parse(f['ddDeg']!.trim()))
      ..minWalkWins = int.parse(f['wins']!.trim());
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(learningClientProvider).saveConfig(SaveConfigRequest(config: c));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final rules = _rules(l);
    Widget field(String k, String label, {String? unit}) => SizedBox(
      width: 190,
      child: TextFormField(
        initialValue: f[k],
        textDirection: TextDirection.ltr,
        style: AppText.mono,
        onChanged: (v) => setState(() => f[k] = v),
        decoration: InputDecoration(
          labelText: label,
          suffix: unitSuffix(unit),
          errorText: _tried ? rules[k]!(f[k]!) : null,
        ),
      ),
    );
    Widget group(List<Widget> c) => Wrap(spacing: AppSpace.md, runSpacing: AppSpace.md, children: c);
    return AlertDialog(
      backgroundColor: AppColors.surfaceRaised,
      title: Text(L10n.of(context).lConfig, style: AppText.sectionTitle),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.lcAlgorithm, style: AppText.label),
              const SizedBox(height: AppSpace.sm),
              LabChoiceChips<String>(
                ltr: true,
                options: [for (final a in widget.algorithms) (a, a)],
                selected: {_alg},
                onChanged: (v) => setState(() => _alg = v.first),
              ),
              SwitchListTile(
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
                title: Text(l.lcEnabled, style: AppText.body),
                contentPadding: EdgeInsets.zero,
              ),
              group([
                field('hour', l.lcHour),
                field('lookback', l.lcLookback),
                field('fresh', l.lcFresh),
                field('folds', l.lcFolds),
                field('cands', l.lcCands),
                field('cpu', l.lcCpu, unit: l.minutes),
                field('bars', l.lcBars),
              ]),
              const SizedBox(height: AppSpace.lg),
              Text(l.lcGate, style: AppText.sectionTitle),
              const SizedBox(height: AppSpace.md),
              group([
                field('maxDd', l.lcMaxDd, unit: '%'),
                field('trades', l.lcTrades),
                field('days', l.lcFwdDays),
                field('improve', l.lcImprove, unit: l.lcPoints),
                field('ddDeg', l.lcDdDeg, unit: l.lcPoints),
                field('wins', l.lcWins),
              ]),
              if (_error != null) ...[
                const SizedBox(height: AppSpace.md),
                Text(errorText(_error!), style: AppText.body.copyWith(color: AppColors.negativeText)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
        FilledButton(onPressed: _saving ? null : () => _save(l), child: Text(l.save)),
      ],
    );
  }
}
