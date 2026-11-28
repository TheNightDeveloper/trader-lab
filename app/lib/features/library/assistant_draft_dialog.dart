import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/assistant.pb.dart';
import '../../l10n/app_localizations.dart';
import '../assistant/assistant_request_card.dart';
import 'rule_editor.dart';

class AssistantDraftDialog extends StatefulWidget {
  const AssistantDraftDialog({super.key});

  @override
  State<AssistantDraftDialog> createState() => _AssistantDraftDialogState();
}

class _AssistantDraftDialogState extends State<AssistantDraftDialog> {
  String _description = '';
  int _revision = 0;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final description = _description.trim();
    return AlertDialog(
      title: Text(l.assistantDraftTitle),
      scrollable: true,
      content: SizedBox(
        width: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              maxLength: 1200,
              decoration: InputDecoration(
                labelText: l.assistantDraftDescription,
              ),
              onChanged: (text) => setState(() {
                _description = text;
                _revision++;
              }),
            ),
            Text(l.assistantDraftExample, style: AppText.caption),
            const SizedBox(height: AppSpace.md),
            AssistantRequestCard<DraftStrategyResponse>(
              // Editing discards a proposal for the old text and cancels its request.
              key: ValueKey(_revision),
              disclosure: l.assistantDraftDisclosure,
              requestLabel: l.assistantDraftSubmit,
              timeout: const Duration(seconds: 30),
              connected:
                  description.isNotEmpty && description.runes.length <= 1200,
              request: (client, signal) => client.draftStrategy(
                DraftStrategyRequest(description: description),
                signal: signal,
              ),
              result: (reply) => _DraftProposal(reply: reply),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
      ],
    );
  }
}

class _DraftProposal extends StatelessWidget {
  const _DraftProposal({required this.reply});

  final DraftStrategyResponse reply;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final definition = reply.definitionJson.isEmpty
        ? null
        : jsonDecode(reply.definitionJson) as RuleJson;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            definition == null
                ? l.assistantDraftNeedsDefinition
                : l.assistantDraftReady,
            style: AppText.sectionTitle,
          ),
        ),
        if (definition == null) ...[
          for (final question in reply.questions)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.sm),
              child: Text(_draftQuestion(l, question)),
            ),
        ] else ...[
          Text(
            l.assistantDraftEntry(
              describeRule(definition['entry'] as RuleJson),
            ),
          ),
          Text(
            l.assistantDraftExit(describeRule(definition['exit'] as RuleJson)),
          ),
          Wrap(
            spacing: AppSpace.sm,
            children: [
              Text(l.assistantDraftExposure),
              Num(
                Decimal.parse(definition['exposure'] as String) *
                    Decimal.fromInt(100),
                unit: '%',
              ),
            ],
          ),
          Text(
            l.assistantDraftData(
              ruleTimeframes[definition['base_timeframe']] ?? '',
              reply.lookbackBars,
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, reply.definitionJson),
            child: Text(l.assistantDraftOpenEditor),
          ),
        ],
        const SizedBox(height: AppSpace.sm),
        AssistantUsage(
          model: reply.model,
          cached: false,
          input: reply.inputTokens,
          output: reply.outputTokens,
        ),
      ],
    );
  }
}

String _draftQuestion(L10n l, DraftQuestion question) => switch (question) {
  DraftQuestion.DRAFT_QUESTION_ENTRY => l.assistantDraftAskEntry,
  DraftQuestion.DRAFT_QUESTION_EXIT => l.assistantDraftAskExit,
  DraftQuestion.DRAFT_QUESTION_EXPOSURE => l.assistantDraftAskExposure,
  DraftQuestion.DRAFT_QUESTION_TIMEFRAME => l.assistantDraftAskTimeframe,
  DraftQuestion.DRAFT_QUESTION_UNSUPPORTED => l.assistantDraftAskSupported,
  _ => l.assistantDraftAskParameters,
};
