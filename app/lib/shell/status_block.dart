import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../core/api/engine.dart';
import '../core/money.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/num.dart';
import '../core/widgets/status.dart';
import '../core/widgets/workspace_status.dart';
import '../gen/lab/v1/health.pb.dart';
import '../l10n/app_localizations.dart';

/// Sidebar details from the last heartbeat, with connection and feed status kept distinct.
class StatusBlock extends ConsumerWidget {
  const StatusBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final async = ref.watch(engineStatusProvider);
    final status = async.value;
    final accountingAsset = status?.accountingAsset ?? '';
    return Skeletonizer(
      enabled: status == null && !async.hasError,
      effect: const ShimmerEffect(baseColor: AppColors.surfaceRaised, highlightColor: AppColors.borderStrong),
      child: Container(
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          color: AppColors.statusPanelBg,
          border: Border.all(color: AppColors.sidebarBorder),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusRow(l.statusEngine, _EngineStatus(workers: status?.workers, disconnected: async.hasError)),
            _StatusRow(l.statusLive, FreshnessBadge(live: status?.live, disconnected: async.hasError)),
            _StatusRow(l.statusAccounting, Mono(accountingAsset.isEmpty ? '—' : accountingAsset)),
            const Divider(height: AppSpace.lg, color: AppColors.sidebarBorder),
            Text(l.statusFx, style: AppText.caption),
            _DisplayRateStatus(rate: status?.displayRate),
          ],
        ),
      ),
    );
  }
}

class _EngineStatus extends StatelessWidget {
  const _EngineStatus({required this.workers, required this.disconnected});

  final Workers? workers;
  final bool disconnected;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return StatusText(switch (workers?.state) {
      _ when disconnected => (l.statusEngineDown, AppColors.negativeText),
      WorkerState.WORKER_STATE_RUNNING => (
        '${l.statusEngineRunning} · ${l.statusWorkers(workers!.count)}',
        AppColors.positive,
      ),
      WorkerState.WORKER_STATE_PAUSED => (l.statusEnginePaused, AppColors.warning),
      _ => (l.statusEngineUnknown, AppColors.textMuted),
    });
  }
}

class _DisplayRateStatus extends StatelessWidget {
  const _DisplayRateStatus({required this.rate});

  final DisplayRate? rate;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final value = rate;
    if (value == null || !value.hasTomanPerUsdt()) {
      return Text(l.statusFxNone, style: AppText.caption);
    }

    final amount = formatDecimal(moneyValue(value.tomanPerUsdt), fractionDigits: 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Keep the equation as one LTR span within the RTL sidebar.
        Mono('1 USDT = $amount TOMAN', style: AppText.mono.copyWith(fontSize: 12)),
        Text(
          '${value.source == 'manual' ? l.statusFxManual : value.source} · ${value.asOfDate}',
          style: AppText.caption,
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow(this.label, this.value);

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: Text(label, style: AppText.caption)),
        const SizedBox(width: AppSpace.sm),
        Expanded(
          child: Align(alignment: AlignmentDirectional.centerEnd, child: value),
        ),
      ],
    ),
  );
}
