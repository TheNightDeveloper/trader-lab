import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/assistant.connect.client.dart';
import '../../gen/lab/v1/assistant.pb.dart';
import '../../l10n/app_localizations.dart';
import '../library/rule_draft_dialog.dart' show ruleVersionPath;

/// The card starts a paid request only from an explicit user action.
class OpportunityAssistant extends ConsumerStatefulWidget {
  const OpportunityAssistant({
    super.key,
    required this.opportunityId,
    required this.connected,
  });

  final Int64 opportunityId;
  final bool connected;

  @override
  ConsumerState<OpportunityAssistant> createState() =>
      _OpportunityAssistantState();
}

class _OpportunityAssistantState extends ConsumerState<OpportunityAssistant> {
  CancelableSignal? _request;
  ExplainOpportunityResponse? _explanation;
  Code? _error;

  @override
  void dispose() {
    _request?.cancel();
    super.dispose();
  }

  Future<void> _explain() async {
    final request = CancelableSignal();
    setState(() {
      _request = request;
      _error = null;
    });
    final client = AssistantServiceClient(ref.read(transportProvider));
    try {
      final result = await client.explainOpportunity(
        ExplainOpportunityRequest(opportunityId: widget.opportunityId),
        signal: TimeoutSignal(const Duration(seconds: 17), parent: request),
      );
      if (!mounted || _request != request) return;
      setState(() => _explanation = result);
    } on Object catch (error) {
      if (!mounted || _request != request) return;
      setState(
        () => _error = error is ConnectException ? error.code : Code.unknown,
      );
    } finally {
      // A canceled reply must not replace the state of a newer request.
      if (mounted && _request == request) setState(() => _request = null);
    }
  }

  void _cancel() {
    _request?.cancel();
    setState(() => _request = null);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final explanation = _explanation;
    final error = _error;
    final pending = _request != null;
    return SectionCard(
      title: l.assistantOpportunityTitle,
      child: explanation != null
          ? _ExplanationEvidence(explanation: explanation)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pending)
                  Wrap(
                    spacing: AppSpace.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Semantics(
                        liveRegion: true,
                        child: Text(l.assistantOpportunityLoading),
                      ),
                      TextButton(
                        onPressed: _cancel,
                        child: Text(l.assistantOpportunityCancel),
                      ),
                    ],
                  )
                else ...[
                  if (error != null) WarningBanner(_assistantError(l, error)),
                  if (error == null)
                    Text(
                      l.assistantOpportunityProvider,
                      style: AppText.caption,
                    ),
                  if (error != Code.failedPrecondition &&
                      error != Code.unimplemented)
                    OutlinedButton(
                      onPressed: widget.connected ? _explain : null,
                      child: Text(
                        error == null
                            ? l.assistantOpportunityRequest
                            : l.assistantOpportunityRetry,
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}

String _assistantError(L10n l, Code code) => switch (code) {
  Code.resourceExhausted => l.assistantOpportunityQuota,
  Code.aborted => l.assistantOpportunityInProgress,
  Code.failedPrecondition ||
  Code.unimplemented => l.assistantOpportunityDisabled,
  _ => l.assistantOpportunityFailed,
};

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
        Wrap(
          spacing: AppSpace.sm,
          runSpacing: AppSpace.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Mono(explanation.model, style: AppText.caption),
            if (explanation.cached)
              Text(l.assistantOpportunityCached, style: AppText.caption),
            Text(
              l.assistantOpportunityTokens(
                explanation.inputTokens,
                explanation.outputTokens,
              ),
              style: AppText.caption,
            ),
          ],
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
