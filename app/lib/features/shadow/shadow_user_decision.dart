import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/shadow.connect.client.dart';
import '../../gen/lab/v1/shadow.pb.dart';
import '../../l10n/app_localizations.dart';

class ShadowUserDecisionCard extends ConsumerStatefulWidget {
  const ShadowUserDecisionCard({
    super.key,
    required this.deploymentId,
    required this.observation,
    required this.connected,
    required this.onRefresh,
  });

  final Int64 deploymentId;
  final ShadowObservation observation;
  final bool connected;
  final VoidCallback onRefresh;

  @override
  ConsumerState<ShadowUserDecisionCard> createState() =>
      _ShadowUserDecisionCardState();
}

class _ShadowUserDecisionCardState
    extends ConsumerState<ShadowUserDecisionCard> {
  bool _busy = false;
  bool _recorded = false;
  Object? _error;

  Future<void> _decide(bool allow) async {
    final l = L10n.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (!await confirmAction(
            context,
            title: allow ? l.shadowUserAllow : l.shadowUserSkip,
            body: l.shadowUserConfirm,
          ) ||
          !mounted) {
        return;
      }
      await ShadowServiceClient(ref.read(transportProvider))
          .setShadowUserDecision(
            SetShadowUserDecisionRequest(
              deploymentId: widget.deploymentId,
              observationId: widget.observation.id,
              allow: allow,
            ),
            signal: TimeoutSignal(const Duration(seconds: 8)),
          );
      if (mounted) {
        setState(() => _recorded = true);
        widget.onRefresh();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error);
        // Another tab may have saved the decision or the response may have been lost.
        widget.onRefresh();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final d = widget.observation;
    final enabled = widget.connected && !_busy && !_recorded;
    return SectionCard(
      title: l.shadowUserDecisionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.shadowUserDecisionHelp),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.xs,
            children: [
              Text(l.marketOpportunityPrice),
              Num(moneyValue(d.referenceClose), unit: d.referenceClose.asset),
              Text(l.shadowUserDeadline),
              Mono('${fmtDateTime(utcMs(d.decisionAtUnixMs))} UTC'),
            ],
          ),
          if (_error case final error?) WarningBanner(errorText(error)),
          if (_recorded)
            Semantics(liveRegion: true, child: Text(l.shadowUserRecorded))
          else
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.xs,
              children: [
                FilledButton(
                  onPressed: enabled ? () => _decide(true) : null,
                  child: Text(l.shadowUserAllow),
                ),
                OutlinedButton(
                  onPressed: enabled ? () => _decide(false) : null,
                  child: Text(l.shadowUserSkip),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
