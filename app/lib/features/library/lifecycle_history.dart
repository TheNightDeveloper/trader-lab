import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/audit.pb.dart';
import '../../gen/lab/v1/library.pb.dart';
import '../../l10n/app_localizations.dart';

typedef LifecycleHistoryPage = ({String versionId, Int64? before});

final lifecycleEventsProvider = FutureProvider.autoDispose.family<ListLifecycleEventsResponse, LifecycleHistoryPage>(
  (ref, page) => ref
      .watch(libraryClientProvider)
      .listLifecycleEvents(
        ListLifecycleEventsRequest(
          versionId: page.versionId,
          pageSize: 20,
          before: page.before == null ? null : AuditCursor(strategyVersionId: page.versionId, sequence: page.before),
        ),
      ),
);

/// Shows one audit page. Returning to a newer page reuses its exclusive bound.
class LifecycleHistory extends ConsumerStatefulWidget {
  const LifecycleHistory({super.key, required this.versionId});

  final String versionId;

  @override
  ConsumerState<LifecycleHistory> createState() => _LifecycleHistoryState();
}

class _LifecycleHistoryState extends ConsumerState<LifecycleHistory> {
  List<Int64?> _bounds = const [null];

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final provider = lifecycleEventsProvider((versionId: widget.versionId, before: _bounds.last));
    final history = ref.watch(provider);
    final page = history.value;
    final older = page != null && page.hasNextCursor() ? page.nextCursor.sequence : null;
    final hasNewer = _bounds.length > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.libHistory, style: AppText.sectionTitle),
        const SizedBox(height: AppSpace.sm),
        AsyncSection(
          value: history,
          onRetry: () => ref.invalidate(provider),
          skeleton: const SizedBox(height: 60),
          builder: (r) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (final event in r.events) _EventRow(event)],
          ),
        ),
        if (hasNewer || older != null)
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              OutlinedButton(
                onPressed: hasNewer ? () => setState(() => _bounds = _bounds.sublist(0, _bounds.length - 1)) : null,
                child: Text(l.libHistoryNewer),
              ),
              OutlinedButton(
                onPressed: older == null || history.isLoading
                    ? null
                    : () => setState(() => _bounds = [..._bounds, older]),
                child: Text(l.libHistoryOlder),
              ),
            ],
          ),
      ],
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow(this.event);

  final LifecycleEvent event;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    // Legacy engines return the actor and timestamp directly on LifecycleEvent.
    final actor = event.hasAudit()
        ? switch (event.audit.actor) {
            AuditActor.AUDIT_ACTOR_USER => l.actorUser,
            AuditActor.AUDIT_ACTOR_SYSTEM => l.actorSystem,
            _ => l.actorUnknown,
          }
        : switch (event.actor) {
            'user' => l.actorUser,
            'system' => l.actorSystem,
            _ => l.actorUnknown,
          };
    final at = event.hasAudit() ? event.audit.recordedAtUnixMs : event.atUnixMs;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (event.fromState.isNotEmpty) ...[
                Text(lifecycleState(l, event.fromState).$1, style: AppText.caption),
                const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textMuted),
              ],
              StatusText(lifecycleState(l, event.toState)),
              Text(actor, style: AppText.caption),
              Mono(fmtDateTime(utcMs(at)), style: AppText.mono.copyWith(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
          if (event.note.isNotEmpty) Text(event.note, style: AppText.caption),
        ],
      ),
    );
  }
}
