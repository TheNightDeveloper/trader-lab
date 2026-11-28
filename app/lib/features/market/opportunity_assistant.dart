import 'package:fixnum/fixnum.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/assistant.pb.dart';
import '../../l10n/app_localizations.dart';
import '../assistant/assistant_request_card.dart';
import '../library/rule_draft_dialog.dart' show ruleVersionPath;

class OpportunityAssistant extends StatelessWidget {
  const OpportunityAssistant({
    super.key,
    required this.opportunityId,
    required this.connected,
  });

  final Int64 opportunityId;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return AssistantRequestCard<ExplainOpportunityResponse>(
      key: ValueKey(opportunityId),
      title: l.assistantOpportunityTitle,
      disclosure: l.assistantOpportunityProvider,
      connected: connected,
      request: (client, signal) => client.explainOpportunity(
        ExplainOpportunityRequest(opportunityId: opportunityId),
        signal: signal,
      ),
      result: (reply) => _ExplanationEvidence(explanation: reply),
    );
  }
}

class _ExplanationEvidence extends StatelessWidget {
  const _ExplanationEvidence({required this.explanation});

  final ExplainOpportunityResponse explanation;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final (message, source) = switch (explanation.focus) {
      ExplanationFocus.EXPLANATION_FOCUS_RULE => (
        l.assistantOpportunityRule,
        TextButton(
          onPressed: () =>
              context.go(ruleVersionPath(explanation.ruleVersionId)),
          child: Text(l.marketOpportunityRule),
        ),
      ),
      ExplanationFocus.EXPLANATION_FOCUS_SNAPSHOT => (
        l.assistantOpportunitySnapshot,
        _SnapshotEvidence(explanation),
      ),
      ExplanationFocus.EXPLANATION_FOCUS_REPORT => (
        l.assistantOpportunityReport,
        TextButton(
          onPressed: () => context.go(
            '/reports/${Uri.encodeComponent(explanation.reportId)}',
          ),
          child: Text(l.marketOpportunityReport),
        ),
      ),
      _ => (l.assistantOpportunityFailed, const SizedBox.shrink()),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(liveRegion: true, child: Text(message, style: AppText.body)),
        source,
        const SizedBox(height: AppSpace.sm),
        AssistantUsage(
          model: explanation.model,
          cached: explanation.cached,
          input: explanation.inputTokens,
          output: explanation.outputTokens,
        ),
      ],
    );
  }
}

class _SnapshotEvidence extends StatelessWidget {
  const _SnapshotEvidence(this.explanation);

  final ExplainOpportunityResponse explanation;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final close = explanation.referenceClose;
    // The timestamps describe the original observation even after it expires.
    return ExpansionTile(
      title: Text(l.assistantOpportunityOpenSnapshot),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpace.sm,
          children: [
            Text(l.marketOpportunityPrice),
            Num(moneyValue(close), unit: close.asset),
          ],
        ),
        Wrap(
          spacing: AppSpace.sm,
          children: [
            Text(l.marketClosedAt),
            Mono('${fmtDateTime(utcMs(explanation.candleClosedAtUnixMs))} UTC'),
          ],
        ),
        Wrap(
          spacing: AppSpace.sm,
          children: [
            Text(l.marketOpportunityExpires),
            Mono('${fmtDateTime(utcMs(explanation.expiresAtUnixMs))} UTC'),
          ],
        ),
      ],
    );
  }
}
