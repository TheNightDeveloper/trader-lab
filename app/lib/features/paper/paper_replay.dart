import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/workspace_status.dart';
import '../../gen/lab/v1/paper.pb.dart';
import '../../gen/lab/v1/workspace.pbenum.dart';
import '../../l10n/app_localizations.dart';
import '../library/rule_editor.dart' show RuleJson, describeRule;
import '../market/market_opportunities.dart' show marketOpportunityReason;
import '../page_frame.dart';
import 'paper_entries.dart';
import 'paper_providers.dart';
import 'paper_screen.dart';

class PaperReplayScreen extends ConsumerWidget {
  const PaperReplayScreen({super.key, required this.id, required this.cursor});

  final Int64 id;
  final Int64 cursor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final provider = paperReplayProvider((id, cursor));
    final state = ref.watch(provider);
    final replay = state.value;
    final path = '/paper/receipts/$id/replay';
    return PageFrame(
      children: [
        PageHeader(
          title: l.paperReplayTitle,
          actions: [
            const EnvironmentBadge(environment: Environment.ENVIRONMENT_PAPER),
            TextButton(onPressed: () => context.go('/paper/journal'), child: Text(l.paperJournalTitle)),
            TextButton(onPressed: () => context.go('/paper/receipts/$id'), child: Text(l.paperViewReceipt)),
          ],
        ),
        if (replay != null) ...[
          if (state.hasError) WarningBanner(l.engineUnreachable),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Mono('${replay.symbol} · $id'),
              OutlinedButton(
                onPressed: replay.hasPreviousCursor()
                    ? () => context.go('$path?cursor=${replay.previousCursor}')
                    : null,
                child: Text(l.paperReplayPrevious),
              ),
              FilledButton(
                onPressed: replay.hasNextCursor() ? () => context.go('$path?cursor=${replay.nextCursor}') : null,
                child: Text(l.paperReplayNext),
              ),
            ],
          ),
          // The response carries a single step. Switching cursors also resets expanded evidence.
          KeyedSubtree(
            key: ValueKey(cursor),
            child: switch (replay.whichStep()) {
              GetPaperReplayResponse_Step.observation => _ReplayObservation(observation: replay.observation),
              GetPaperReplayResponse_Step.plan => PaperPlanSummary(plan: replay.plan),
              GetPaperReplayResponse_Step.execution => _ReplayExecution(execution: replay.execution),
              GetPaperReplayResponse_Step.notSet => Text(l.statusLiveUnavailable),
            },
          ),
        ] else
          AsyncSection(
            value: state,
            onRetry: () => ref.invalidate(provider),
            skeleton: Text(l.paperLoading),
            builder: (_) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}

class _ReplayObservation extends StatelessWidget {
  const _ReplayObservation({required this.observation});

  final PaperReplayObservation observation;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final opportunity = observation.opportunity;
    return SectionCard(
      title: l.paperReplayObservation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: AppSpace.sm, children: [Text(opportunity.ruleTitle), Mono('#${opportunity.ruleVersionId}')]),
          Text(marketOpportunityReason(l, opportunity.reason)),
          Text(describeRule(jsonDecode(observation.entryRuleJson) as RuleJson)),
          PaperTimeLine(label: l.paperReplayObservedAt, at: opportunity.observedAtUnixMs),
          PaperTimeLine(label: l.marketClosedAt, at: opportunity.candleClosedAtUnixMs),
          PaperTimeLine(label: l.marketAvailableAt, at: observation.lastInputAvailableAtUnixMs),
          PaperMoneyLine(label: l.marketOpportunityPrice, amount: opportunity.referenceClose),
          Wrap(
            spacing: AppSpace.sm,
            children: [Text(l.paperReplayInputs), Mono(observation.inputCandleCount.toString())],
          ),
          ExpansionTile(
            title: Text(l.paperReplayEntryRule),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: const EdgeInsets.all(AppSpace.md),
            children: [
              PaperMoneyLine(label: l.paperReplayInputOpen, amount: observation.lastInputOpen),
              PaperMoneyLine(label: l.paperReplayInputHigh, amount: observation.lastInputHigh),
              PaperMoneyLine(label: l.paperReplayInputLow, amount: observation.lastInputLow),
              Text(l.paperReplaySnapshotHash),
              SelectableText(observation.snapshotSha256, textDirection: TextDirection.ltr),
              Text(l.paperReplayRuleHash),
              SelectableText(observation.ruleSha256, textDirection: TextDirection.ltr),
              const SizedBox(height: AppSpace.sm),
              SelectableText(observation.entryRuleJson, textDirection: TextDirection.ltr),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReplayExecution extends StatelessWidget {
  const _ReplayExecution({required this.execution});

  final PaperReplayExecution execution;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final candle = execution.confirmationCandle;
    return SectionCard(
      title: l.paperReplayExecution,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PaperEventRow(event: execution.event, initiallyExpanded: true),
          if (execution.hasConfirmationCandle()) ...[
            PaperMoneyLine(label: l.paperReplayConfirmationPrice, amount: candle.close),
            PaperTimeLine(label: l.marketClosedAt, at: candle.closedAtUnixMs),
            PaperTimeLine(label: l.marketAvailableAt, at: candle.availableAtUnixMs),
            Wrap(spacing: AppSpace.sm, children: [Text(l.paperReplayRevision), Mono(candle.revision.toString())]),
          ] else if (execution.event.kind == 'accepted')
            Text(l.paperReplayConfirmationUnavailable),
        ],
      ),
    );
  }
}
