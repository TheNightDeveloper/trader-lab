import 'package:fixnum/fixnum.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/shadow.pb.dart';
import '../../l10n/app_localizations.dart';

class ShadowResults extends StatelessWidget {
  const ShadowResults({super.key, required this.snapshot});

  final GetShadowSnapshotResponse snapshot;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final base = snapshot.baseline;
    final alternatives = [snapshot.ai, if (snapshot.hasUser()) snapshot.user];
    final tracks = [base, ...alternatives];
    final labels = [
      l.shadowBaseline,
      l.shadowAi,
      if (snapshot.hasUser()) l.shadowUserTrack,
    ];
    final deltas = [for (final track in alternatives) track.attribution];
    return SectionCard(
      title: l.shadowResults,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.shadowCommonHours(snapshot.sampledHours),
            style: AppText.caption,
          ),
          Text(l.shadowComparisonHelp, style: AppText.caption),
          if (snapshot.hasMinimumClosedTrades()) ...[
            const SizedBox(height: AppSpace.sm),
            WarningBanner(l.shadowSmallSample(snapshot.minimumClosedTrades)),
          ],
          const SizedBox(height: AppSpace.sm),
          DataTableBox(
            minWidth: tracks.length == 3 ? 580 : 420,
            columns: [l.compareMetric, ...labels],
            rows: [
              [
                Text(l.shadowEntries),
                for (final track in tracks) Mono('${track.entries}'),
              ],
              for (final metric in base.metrics)
                [
                  Text(metric.label),
                  for (final track in tracks)
                    if (metricOf(track.metrics, metric.key) case final item?)
                      _ShadowMetric(value: formatMetric(l, item))
                    else
                      const Text('—'),
                ],
              [
                Text(l.shadowPnlDelta),
                const Text('—'),
                for (final delta in deltas)
                  if (delta.hasNetPnlDelta())
                    Num(
                      moneyValue(delta.netPnlDelta),
                      unit: delta.netPnlDelta.asset,
                      signed: true,
                    )
                  else
                    const Text('—'),
              ],
              [
                Text(l.shadowReturnDelta),
                const Text('—'),
                for (final delta in deltas)
                  if (delta.hasReturnDelta())
                    Num(
                      fractionToPct(delta.returnDelta),
                      unit: l.shadowPercentagePoints,
                      signed: true,
                      fractionDigits: 4,
                    )
                  else
                    const Text('—'),
              ],
              [
                Text(l.shadowSharedEntries),
                const Text('—'),
                for (final delta in deltas) Mono('${delta.sharedEntries}'),
              ],
              [
                Text(l.shadowBaselineOnlyEntries),
                const Text('—'),
                for (final delta in deltas)
                  Mono('${delta.baselineOnlyEntries}'),
              ],
              [
                Text(l.shadowTrackOnlyEntries),
                const Text('—'),
                for (final delta in deltas) Mono('${delta.trackOnlyEntries}'),
              ],
            ],
          ),
          if (base.periods.isNotEmpty)
            _ShadowPeriods(tracks: tracks, labels: labels),
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

class _ShadowPeriods extends StatelessWidget {
  const _ShadowPeriods({required this.tracks, required this.labels});

  final List<ShadowTrack> tracks;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return ExpansionTile(
      title: Text(l.shadowDailyPnl),
      children: [
        DataTableBox(
          minWidth: 530,
          columns: [l.shadowPeriodStart, l.shadowPeriodHours, ...labels],
          rows: [
            for (final (i, period) in tracks.first.periods.indexed)
              [
                Mono('${_utc(period.fromUnixMs)} UTC'),
                Mono('${period.sampledHours}'),
                for (final track in tracks)
                  if (i < track.periods.length && track.periods[i].hasNetPnl())
                    Num(
                      moneyValue(track.periods[i].netPnl),
                      unit: track.periods[i].netPnl.asset,
                      signed: true,
                    )
                  else
                    const Text('—'),
              ],
          ],
        ),
      ],
    );
  }
}

class ShadowModelUsage extends StatelessWidget {
  const ShadowModelUsage({super.key, required this.snapshot});

  final GetShadowSnapshotResponse snapshot;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final selected = snapshot.selected;
    return SectionCard(
      title: l.shadowOperationalCost,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.shadowUsage(
              snapshot.inputTokens.toString(),
              snapshot.outputTokens.toString(),
            ),
          ),
          Text(
            l.shadowModelAttempts(snapshot.modelAttempts),
            style: AppText.caption,
          ),
          if (snapshot.hasEstimatedModelCost())
            Num(
              moneyValue(snapshot.estimatedModelCost),
              unit: snapshot.estimatedModelCost.asset,
            )
          else
            Text(l.shadowCostUnavailable),
          if (snapshot.missingModelUsage > 0)
            Text(
              l.shadowMissingUsage(snapshot.missingModelUsage),
              style: AppText.caption,
            ),
          if (selected.hasModelInputPerMillion() &&
              selected.hasModelOutputPerMillion())
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.xs,
              children: [
                Text(l.shadowInputRate),
                Num(
                  moneyValue(selected.modelInputPerMillion),
                  unit: selected.modelInputPerMillion.asset,
                ),
                Text(l.shadowOutputRate),
                Num(
                  moneyValue(selected.modelOutputPerMillion),
                  unit: selected.modelOutputPerMillion.asset,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ShadowObservations extends StatelessWidget {
  const ShadowObservations({super.key, required this.snapshot});

  final GetShadowSnapshotResponse snapshot;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final hasUser = snapshot.selected.userTrack;
    return SectionCard(
      title: l.shadowObservations,
      child: DataTableBox(
        minWidth: hasUser ? 1170 : 950,
        columns: [
          l.marketClosedAt,
          l.marketObservedAt,
          l.shadowDecisionAt,
          l.marketOpportunityPrice,
          l.shadowAi,
          l.shadowGateAt,
          if (hasUser) l.shadowUserDecisionTitle,
          l.shadowExecutionEvidence,
        ],
        rows: [
          for (final row in snapshot.observations)
            [
              Mono('${_utc(row.candleClosedAtUnixMs)} UTC'),
              Mono('${_utc(row.observedAtUnixMs)} UTC'),
              Mono('${_utc(row.decisionAtUnixMs)} UTC'),
              Num(
                moneyValue(row.referenceClose),
                unit: row.referenceClose.asset,
              ),
              Text(_shadowGate(l, row.gate)),
              if (row.gateResolvedAtUnixMs > Int64.ZERO)
                Mono('${_utc(row.gateResolvedAtUnixMs)} UTC')
              else
                const Text('—'),
              if (hasUser)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_shadowUserGate(l, row.userDecision)),
                    if (row.userDecidedAtUnixMs > Int64.ZERO)
                      Mono('${_utc(row.userDecidedAtUnixMs)} UTC'),
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (row.hasBaselineEntry())
                    _ShadowEntry(
                      label: l.shadowBaseline,
                      entry: row.baselineEntry,
                    ),
                  if (row.hasAiEntry())
                    _ShadowEntry(label: l.shadowAi, entry: row.aiEntry),
                  if (row.hasUserEntry())
                    _ShadowEntry(
                      label: l.shadowUserTrack,
                      entry: row.userEntry,
                    ),
                  if (!row.hasBaselineEntry() &&
                      !row.hasAiEntry() &&
                      !row.hasUserEntry())
                    const Text('—'),
                ],
              ),
            ],
        ],
      ),
    );
  }
}

class _ShadowEntry extends StatelessWidget {
  const _ShadowEntry({required this.label, required this.entry});

  final String label;
  final ShadowEntryEvidence entry;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpace.sm,
    children: [
      Text(label),
      if (entry.filledAtUnixMs > Int64.ZERO)
        Mono('${_utc(entry.filledAtUnixMs)} UTC')
      else
        Text(L10n.of(context).shadowUnfilled),
    ],
  );
}

String _utc(Int64 unixMs) {
  final utc = utcMs(unixMs);
  return '${fmtDateTime(utc)}:${two(utc.second)}';
}

String shadowStateLabel(L10n l, ShadowState state) => switch (state) {
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

String _shadowUserGate(L10n l, ShadowUserDecision decision) =>
    switch (decision) {
      ShadowUserDecision.SHADOW_USER_DECISION_OPEN => l.shadowUserOpen,
      ShadowUserDecision.SHADOW_USER_DECISION_ALLOW => l.shadowAllow,
      ShadowUserDecision.SHADOW_USER_DECISION_SKIP => l.shadowBlock,
      ShadowUserDecision.SHADOW_USER_DECISION_UNANSWERED =>
        l.shadowUserUnanswered,
      _ => '—',
    };
