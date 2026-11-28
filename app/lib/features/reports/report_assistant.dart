import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/assistant.pb.dart';
import '../../l10n/app_localizations.dart';
import '../assistant/assistant_request_card.dart';

class ReportAssistant extends StatelessWidget {
  const ReportAssistant({
    super.key,
    required this.reportIds,
    this.labels = const [],
  });

  final List<String> reportIds;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return AssistantRequestCard<ReviewReportsResponse>(
      // A changed selection must cancel a pending result for the old baseline.
      key: ValueKey(jsonEncode(reportIds)),
      title: reportIds.length == 1
          ? l.assistantResearchTitle
          : l.assistantResearchCompareTitle,
      disclosure: l.assistantResearchProvider,
      request: (client, signal) => client.reviewReports(
        ReviewReportsRequest(reportIds: reportIds),
        signal: signal,
      ),
      result: (reply) => _ResearchEvidence(reply: reply, labels: labels),
    );
  }
}

class _ResearchEvidence extends StatelessWidget {
  const _ResearchEvidence({required this.reply, required this.labels});

  final ReviewReportsResponse reply;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final message = switch (reply.focus) {
      ResearchFocus.RESEARCH_FOCUS_ASSUMPTIONS =>
        l.assistantResearchAssumptions,
      ResearchFocus.RESEARCH_FOCUS_RETURN => l.assistantResearchReturn,
      ResearchFocus.RESEARCH_FOCUS_DRAWDOWN => l.assistantResearchDrawdown,
      ResearchFocus.RESEARCH_FOCUS_SAMPLE => l.assistantResearchSample,
      _ => l.assistantOpportunityFailed,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(liveRegion: true, child: Text(message, style: AppText.body)),
        if (reply.hasMinimumClosedTrades()) ...[
          const SizedBox(height: AppSpace.sm),
          WarningBanner(l.assistantResearchThin(reply.minimumClosedTrades)),
        ],
        ExpansionTile(
          title: Text(l.assistantResearchSources),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, source) in reply.references.indexed)
              _ReportReference(
                source: source,
                label: i < labels.length ? labels[i] : '',
                link: reply.references.length > 1,
                assumptions: [
                  for (final a in reply.blockingAssumptions)
                    (a.label, a.values[i]),
                ],
              ),
          ],
        ),
        if (reply.model.isNotEmpty)
          AssistantUsage(
            model: reply.model,
            cached: reply.cached,
            input: reply.inputTokens,
            output: reply.outputTokens,
          ),
      ],
    );
  }
}

class _ReportReference extends StatelessWidget {
  const _ReportReference({
    required this.source,
    required this.label,
    required this.link,
    required this.assumptions,
  });

  final ResearchReference source;
  final String label;
  final bool link;
  final List<(String, String)> assumptions;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final metric = source.hasMetric() ? formatMetric(l, source.metric) : null;
    final window = source.oosWindow;
    final title = label.isEmpty ? source.title : '$label · ${source.title}';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (link)
            TextButton(
              onPressed: () => context.go(
                '/reports/${Uri.encodeComponent(source.reportId)}',
              ),
              child: Text(title),
            )
          else
            Text(title, style: AppText.label),
          Wrap(
            spacing: AppSpace.sm,
            children: [
              Text(l.assistantResearchOos),
              Mono(
                '${fmtDateTime(utcMs(window.fromUnixMs))} → ${fmtDateTime(utcMs(window.toUnixMs))} UTC',
              ),
            ],
          ),
          if (metric != null)
            Wrap(
              spacing: AppSpace.sm,
              children: [
                Text(source.metric.label),
                Mono([metric.text, ?metric.unit].join(' ')),
              ],
            )
          else if (assumptions.isEmpty)
            Text(l.assistantResearchMissingMetric, style: AppText.caption),
          for (final (name, value) in assumptions)
            Wrap(spacing: AppSpace.sm, children: [Text(name), Mono(value)]),
        ],
      ),
    );
  }
}
