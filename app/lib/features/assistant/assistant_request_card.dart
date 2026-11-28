import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/assistant.connect.client.dart';
import '../../l10n/app_localizations.dart';

/// Handles the shared lifecycle of an explicit, potentially paid assistant request.
class AssistantRequestCard<T extends Object> extends ConsumerStatefulWidget {
  const AssistantRequestCard({
    super.key,
    required this.title,
    required this.disclosure,
    required this.request,
    required this.result,
    this.connected = true,
  });

  final String title;
  final String disclosure;
  final Future<T> Function(AssistantServiceClient client, AbortSignal signal)
  request;
  final Widget Function(T reply) result;
  final bool connected;

  @override
  ConsumerState<AssistantRequestCard<T>> createState() =>
      _AssistantRequestCardState<T>();
}

class _AssistantRequestCardState<T extends Object>
    extends ConsumerState<AssistantRequestCard<T>> {
  CancelableSignal? _request;
  T? _reply;
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
      final reply = await widget.request(
        client,
        TimeoutSignal(const Duration(seconds: 17), parent: request),
      );
      if (!mounted || _request != request) return;
      setState(() => _reply = reply);
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
    final reply = _reply;
    final error = _error;
    final pending = _request != null;
    return SectionCard(
      title: widget.title,
      child: reply != null
          ? widget.result(reply)
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
                    Text(widget.disclosure, style: AppText.caption),
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
  Code.failedPrecondition || Code.unimplemented => l.assistantUnavailable,
  _ => l.assistantOpportunityFailed,
};

class AssistantUsage extends StatelessWidget {
  const AssistantUsage({
    super.key,
    required this.model,
    required this.cached,
    required this.input,
    required this.output,
  });

  final String model;
  final bool cached;
  final int input;
  final int output;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Wrap(
      spacing: AppSpace.sm,
      runSpacing: AppSpace.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Mono(model, style: AppText.caption),
        if (cached) Text(l.assistantOpportunityCached, style: AppText.caption),
        Text(
          l.assistantOpportunityTokens(input, output),
          style: AppText.caption,
        ),
      ],
    );
  }
}
