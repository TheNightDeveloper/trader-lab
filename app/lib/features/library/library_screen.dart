import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/library.pb.dart';
import '../../l10n/app_localizations.dart';
import '../experiments/experiment_providers.dart';
import '../placeholder_screen.dart';

const _families = ['trend', 'mean_reversion', 'learning', 'hybrid', 'benchmark'];

String familyLabel(L10n l, String f) => switch (f) {
  'trend' => l.fam_trend,
  'mean_reversion' => l.fam_mean_reversion,
  'learning' => l.fam_learning,
  'hybrid' => l.fam_hybrid,
  'benchmark' => l.fam_benchmark,
  _ => f,
};

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _family = 'all';
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final algs = ref.watch(algorithmsProvider);
    final all = algs.value?.algorithms ?? <Algorithm>[];
    final shown = all.where((a) => _family == 'all' || a.family == _family).toList();
    final sel = all.where((a) => a.id == _selected).firstOrNull ?? shown.firstOrNull;
    final version = sel == null ? null : usableVersion(sel);
    return PageFrame(
      children: [
        PageHeader(
          title: Dest.library.label(l),
          subtitle: Dest.library.subtitle(l),
          actions: [
            FilledButton.icon(
              onPressed: version == null ? null : () => context.go('/experiments/new?algo=${version.id}'),
              icon: const Icon(Icons.science_outlined, size: 18),
              label: Text(l.libExperiment),
            ),
          ],
        ),
        AsyncSection(
          value: algs,
          onRetry: () => ref.invalidate(algorithmsProvider),
          skeleton: Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.md,
            children: [for (var i = 0; i < 4; i++) const SizedBox(width: 300, height: 150, child: Card())],
          ),
          isEmpty: (r) => r.algorithms.isEmpty,
          empty: EmptyState(l.libNone, icon: Icons.menu_book_outlined),
          builder: (r) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabChoiceChips<String>(
                options: [
                  ('all', l.fam_all),
                  for (final f in _families)
                    if (r.algorithms.any((a) => a.family == f)) (f, familyLabel(l, f)),
                ],
                selected: {_family},
                onChanged: (v) => setState(() => _family = v.first),
              ),
              const SizedBox(height: AppSpace.lg),
              LayoutBuilder(
                builder: (context, box) {
                  final cards = Wrap(
                    spacing: AppSpace.md,
                    runSpacing: AppSpace.md,
                    children: [
                      for (final (i, a) in shown.indexed)
                        _AlgoCard(a, selected: a.id == sel?.id, onTap: () => setState(() => _selected = a.id))
                            .animate(delay: AppMotion.of(context, AppMotion.stagger) * i)
                            .fadeIn(duration: AppMotion.of(context, AppMotion.normal))
                            .scaleXY(begin: 0.97, curve: AppMotion.curve),
                    ],
                  );
                  final panel = sel == null ? const SizedBox.shrink() : _Detail(sel, key: ValueKey(sel.id));
                  if (box.maxWidth < 1000) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        cards,
                        const SizedBox(height: AppSpace.xl),
                        panel,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cards),
                      const SizedBox(width: AppSpace.xl),
                      SizedBox(width: 420, child: panel),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlgoCard extends StatelessWidget {
  const _AlgoCard(this.a, {required this.selected, required this.onTap});
  final Algorithm a;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final v = a.versions.firstOrNull;
    final latest = a.hasLatestReport() ? a.latestReport : null;
    return SizedBox(
      width: 300,
      child: Semantics(
        button: true,
        selected: selected,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: AnimatedContainer(
              duration: AppMotion.of(context, AppMotion.fast),
              padding: const EdgeInsets.all(AppSpace.lg),
              decoration: BoxDecoration(
                color: selected ? AppColors.accentStrongBg : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: selected ? AppColors.accent : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Mono(a.id, style: AppText.mono.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      if (v != null) StatusText(lifecycleState(l, v.state)),
                    ],
                  ),
                  const SizedBox(height: AppSpace.sm),
                  Text(a.description, style: AppText.caption, maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpace.md),
                  Wrap(
                    spacing: AppSpace.md,
                    runSpacing: AppSpace.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(familyLabel(l, a.family), style: AppText.label),
                      if (v != null) Mono('v${v.version}', style: AppText.mono.copyWith(color: AppColors.textMuted)),
                      Text(l.libLatest, style: AppText.label),
                      latest == null
                          ? const Mono('—')
                          : Num(fractionToPct(latest.totalReturn), signed: true, fractionDigits: 2, unit: '%'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail(this.a, {super.key});
  final Algorithm a;

  Future<void> _move(BuildContext context, WidgetRef ref, AlgorithmVersion v, String to) async {
    final l = L10n.of(context);
    var note = ''; // a plain variable: the dialog may still be closing after confirm
    final (fromLabel, _) = lifecycleState(l, v.state);
    final (toLabel, _) = lifecycleState(l, to);
    final ok = await confirmAction(
      context,
      title: l.libMoveTo(toLabel),
      body: l.libConfirm(v.id, fromLabel, toLabel) + (to == 'active' ? l.libConfirmActive : ''),
      extra: TextField(
        onChanged: (s) => note = s,
        decoration: InputDecoration(labelText: l.libNote),
      ),
    );
    if (!ok) return;
    try {
      await ref
          .read(libraryClientProvider)
          .setVersionState(SetVersionStateRequest(versionId: v.id, state: to, note: note.trim()));
      ref.invalidate(algorithmsProvider);
      ref.invalidate(lifecycleEventsProvider(v.id));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(e))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final current = a.versions.firstOrNull;
    final locked = a.versions.any((v) => v.state == 'active');
    final events = current == null ? null : ref.watch(lifecycleEventsProvider(current.id));
    Widget kv(String k, Widget v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        children: [
          Expanded(child: Text(k, style: AppText.label)),
          v,
        ],
      ),
    );
    return SectionCard(
      title: l.libSelected,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Mono(a.id, style: AppText.mono.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpace.xs),
          Text(a.description, style: AppText.body.copyWith(color: AppColors.textSecondary)),
          if (current != null) ...[
            const SizedBox(height: AppSpace.lg),
            Text(l.libRecipe, style: AppText.sectionTitle),
            const SizedBox(height: AppSpace.sm),
            for (final p in current.params) kv(p.name, Mono(fmtParam(p.default_2))),
            kv('hash', Mono(shortHash(current.contentHash, prefix: ''))),
          ],
          const SizedBox(height: AppSpace.lg),
          Text(l.libVersions, style: AppText.sectionTitle),
          const SizedBox(height: AppSpace.sm),
          for (final v in a.versions)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpace.sm),
              padding: const EdgeInsets.all(AppSpace.md),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Mono('v${v.version}', style: AppText.mono.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(width: AppSpace.md),
                      StatusText(lifecycleState(l, v.state)),
                      const Spacer(),
                      Mono(fmtDate(utcMs(v.createdUnixMs)), style: AppText.mono.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                  if (v.nextStates.isNotEmpty) ...[
                    const SizedBox(height: AppSpace.sm),
                    Wrap(
                      spacing: AppSpace.sm,
                      runSpacing: AppSpace.sm,
                      children: [
                        for (final s in v.nextStates)
                          OutlinedButton(
                            onPressed: () => _move(context, ref, v, s),
                            child: Text(l.libMoveTo(lifecycleState(l, s).$1)),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          if (locked) ...[
            const SizedBox(height: AppSpace.sm),
            WarningBanner(l.libLockNote, icon: Icons.lock_outline_rounded),
          ],
          if (events != null) ...[
            const SizedBox(height: AppSpace.lg),
            Text(l.libHistory, style: AppText.sectionTitle),
            const SizedBox(height: AppSpace.sm),
            AsyncSection(
              value: events,
              onRetry: () => ref.invalidate(lifecycleEventsProvider(current!.id)),
              skeleton: const SizedBox(height: 60),
              builder: (r) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final e in r.events)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: AppSpace.sm,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (e.fromState.isNotEmpty) ...[
                                Text(lifecycleState(l, e.fromState).$1, style: AppText.caption),
                                const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textMuted),
                              ],
                              StatusText(lifecycleState(l, e.toState)),
                              Text(e.actor == 'user' ? l.actorUser : l.actorSystem, style: AppText.caption),
                              Mono(
                                fmtDateTime(utcMs(e.atUnixMs)),
                                style: AppText.mono.copyWith(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          if (e.note.isNotEmpty) Text(e.note, style: AppText.caption),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
