import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/shadow.connect.client.dart';
import '../../gen/lab/v1/shadow.pb.dart';
import '../../l10n/app_localizations.dart';
import '../library/rule_draft_dialog.dart' show ruleVersionPath;
import '../page_frame.dart';
import 'shadow_start_dialog.dart';

final _snapshot = StreamProvider.autoDispose
    .family<GetShadowSnapshotResponse, Int64?>((ref, id) async* {
      final client = ShadowServiceClient(ref.watch(transportProvider));
      final signal = CancelableSignal();
      ref.onDispose(signal.cancel);
      while (ref.mounted) {
        yield await client.getShadowSnapshot(
          GetShadowSnapshotRequest(deploymentId: id),
          signal: TimeoutSignal(const Duration(seconds: 8), parent: signal),
        );
        await Future<void>.delayed(const Duration(seconds: 12));
      }
    }, retry: reconnectForever);

class ShadowScreen extends ConsumerStatefulWidget {
  const ShadowScreen({super.key, this.id});

  final Int64? id;

  @override
  ConsumerState<ShadowScreen> createState() => _ShadowScreenState();
}

class _ShadowScreenState extends ConsumerState<ShadowScreen> {
  bool _stopping = false;
  Object? _error;

  Future<void> _start(List<String> symbols) async {
    final id = await showDialog<Int64>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ShadowStartDialog(symbols: symbols),
    );
    if (mounted && id != null) context.go('/shadow/$id');
  }

  Future<void> _stop(Int64 id) async {
    final l = L10n.of(context);
    if (!await confirmAction(
          context,
          title: l.shadowStop,
          body: l.shadowStopConfirm,
        ) ||
        !mounted) {
      return;
    }
    setState(() {
      _stopping = true;
      _error = null;
    });
    try {
      await ShadowServiceClient(ref.read(transportProvider))
          .stopShadowDeployment(
            StopShadowDeploymentRequest(deploymentId: id),
            signal: TimeoutSignal(const Duration(seconds: 12)),
          );
      if (mounted) ref.invalidate(_snapshot(widget.id));
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _stopping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final provider = _snapshot(widget.id);
    final value = ref.watch(provider);
    final data = value.value;
    final d = data?.hasSelected() == true ? data!.selected : null;
    final active =
        data?.deployments.any(
          (row) => row.state == ShadowState.SHADOW_STATE_ACTIVE,
        ) ??
        false;
    final canStart =
        data?.assistantEnabled == true &&
        data!.symbols.isNotEmpty &&
        !active &&
        !value.hasError;
    return PageFrame(
      children: [
        PageHeader(
          title: l.navShadow,
          subtitle: l.screenShadowSub,
          actions: [
            FilledButton(
              onPressed: canStart ? () => _start(data.symbols) : null,
              child: Text(l.shadowStart),
            ),
          ],
        ),
        if (data == null)
          AsyncSection(
            value: value,
            onRetry: () => ref.invalidate(provider),
            skeleton: Text(l.shadowLoading),
            builder: (_) => const SizedBox.shrink(),
          )
        else ...[
          if (value.hasError) WarningBanner(l.marketDisconnected),
          if (_error case final error?) WarningBanner(errorText(error)),
          if (!active && !data.assistantEnabled)
            WarningBanner(l.shadowProviderUnavailable),
          if (d == null)
            SectionCard(child: EmptyState(l.shadowEmpty))
          else ...[
            if (data.deployments.length > 1)
              Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.sm,
                children: [
                  for (final row in data.deployments)
                    ChoiceChip(
                      label: Mono('${row.symbol} · ${row.id}'),
                      selected: d.id == row.id,
                      onSelected: (_) => context.go('/shadow/${row.id}'),
                    ),
                ],
              ),
            _FrozenAssumptions(
              deployment: d,
              onStop:
                  !value.hasError &&
                      d.state == ShadowState.SHADOW_STATE_ACTIVE &&
                      !_stopping
                  ? () => _stop(d.id)
                  : null,
            ),
            if (data.hasBaseline() && data.hasAi())
              _ShadowResults(snapshot: data)
            else
              SectionCard(
                child: Text(
                  d.state == ShadowState.SHADOW_STATE_ACTIVE
                      ? l.shadowAwaiting
                      : l.shadowCommonHours(0),
                ),
              ),
            if (data.observations.isNotEmpty)
              _Observations(observations: data.observations),
          ],
        ],
      ],
    );
  }
}

class _FrozenAssumptions extends StatelessWidget {
  const _FrozenAssumptions({required this.deployment, required this.onStop});

  final ShadowDeployment deployment;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final d = deployment;
    return SectionCard(
      title: l.shadowAssumptions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.xs,
            children: [
              Mono(d.symbol),
              Text(_shadowState(l, d.state)),
              TextButton(
                onPressed: () => context.go(ruleVersionPath(d.ruleVersionId)),
                child: Text(l.marketOpportunityRule),
              ),
              TextButton(
                onPressed: () =>
                    context.go('/reports/${Uri.encodeComponent(d.reportId)}'),
                child: Text(l.marketOpportunityReport),
              ),
              if (onStop != null)
                OutlinedButton(onPressed: onStop, child: Text(l.shadowStop)),
            ],
          ),
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.xs,
            children: [
              Text(l.shadowRegisteredAt),
              Mono('${_utc(d.registeredAtUnixMs)} UTC'),
            ],
          ),
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.xs,
            children: [
              Text(l.shadowWindow),
              Mono('${_utc(d.startAtUnixMs)} → ${_utc(d.endAtUnixMs)} UTC'),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.xs,
            children: [
              Text(l.newCapital),
              Num(moneyValue(d.capital), unit: d.capital.asset),
              Text(l.newFeeBps),
              Num(fractionToBps(d.feeRate), unit: l.bps),
              Text(l.newSlipBps),
              Num(fractionToBps(d.slippageRate), unit: l.bps),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Text(l.shadowFillAssumption, style: AppText.caption),
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.xs,
            children: [
              Mono(d.fillModel),
              Mono(d.aiModel),
              Mono(d.aiPromptVersion),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShadowResults extends StatelessWidget {
  const _ShadowResults({required this.snapshot});

  final GetShadowSnapshotResponse snapshot;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final a = snapshot.baseline;
    final b = snapshot.ai;
    return SectionCard(
      title: l.shadowResults,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.shadowCommonHours(snapshot.sampledHours),
            style: AppText.caption,
          ),
          const SizedBox(height: AppSpace.sm),
          DataTableBox(
            minWidth: 390,
            columns: [l.compareMetric, l.shadowBaseline, l.shadowAi],
            rows: [
              [
                Text(l.shadowEntries),
                Mono('${a.entries}'),
                Mono('${b.entries}'),
              ],
              for (final metric in a.metrics)
                [
                  Text(metric.label),
                  _ShadowMetric(value: formatMetric(l, metric)),
                  if (metricOf(b.metrics, metric.key) case final other?)
                    _ShadowMetric(value: formatMetric(l, other))
                  else
                    const Text('—'),
                ],
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Text(
            l.shadowUsage(
              snapshot.inputTokens.toString(),
              snapshot.outputTokens.toString(),
            ),
            style: AppText.caption,
          ),
        ],
      ),
    );
  }
}

class _ShadowMetric extends StatelessWidget {
  const _ShadowMetric({required this.value});

  final MetricText value;

  @override
  Widget build(BuildContext context) =>
      Mono([value.text, ?value.unit].join(' '));
}

class _Observations extends StatelessWidget {
  const _Observations({required this.observations});

  final List<ShadowObservation> observations;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SectionCard(
      title: l.shadowObservations,
      child: DataTableBox(
        minWidth: 860,
        columns: [
          l.marketClosedAt,
          l.marketObservedAt,
          l.shadowDecisionAt,
          l.marketOpportunityPrice,
          l.shadowAi,
          l.shadowGateAt,
        ],
        rows: [
          for (final item in observations)
            [
              Mono('${_utc(item.candleClosedAtUnixMs)} UTC'),
              Mono('${_utc(item.observedAtUnixMs)} UTC'),
              Mono('${_utc(item.decisionAtUnixMs)} UTC'),
              Num(
                moneyValue(item.referenceClose),
                unit: item.referenceClose.asset,
              ),
              Text(_shadowGate(l, item.gate)),
              if (item.gateResolvedAtUnixMs > Int64.ZERO)
                Mono('${_utc(item.gateResolvedAtUnixMs)} UTC')
              else
                const Text('—'),
            ],
        ],
      ),
    );
  }
}

String _utc(Int64 t) => fmtDateTime(utcMs(t));

String _shadowState(L10n l, ShadowState state) => switch (state) {
  ShadowState.SHADOW_STATE_ACTIVE => l.shadowActive,
  ShadowState.SHADOW_STATE_COMPLETE => l.shadowComplete,
  ShadowState.SHADOW_STATE_STOPPED => l.shadowStopped,
  ShadowState.SHADOW_STATE_GAP => l.shadowGap,
  ShadowState.SHADOW_STATE_BUILD_CHANGED => l.shadowBuildChanged,
  _ => l.invalid,
};

String _shadowGate(L10n l, ShadowGate gate) => switch (gate) {
  ShadowGate.SHADOW_GATE_NO_SIGNAL => l.shadowNoSignal,
  ShadowGate.SHADOW_GATE_PENDING => l.shadowPending,
  ShadowGate.SHADOW_GATE_ALLOW => l.shadowAllow,
  ShadowGate.SHADOW_GATE_BLOCK => l.shadowBlock,
  ShadowGate.SHADOW_GATE_UNAVAILABLE => l.shadowGateUnavailable,
  _ => l.invalid,
};
