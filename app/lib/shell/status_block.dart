import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../core/api/engine.dart';
import '../core/money.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/num.dart';
import '../gen/lab/v1/health.pb.dart';
import '../l10n/app_localizations.dart';

/// Sidebar engine status, fed by HealthService.Watch. Status is always text plus
/// color, never color alone.
class StatusBlock extends ConsumerWidget {
  const StatusBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final async = ref.watch(engineStatusProvider);
    final s = async.value; // last known status, kept while disconnected
    final down = async.hasError;

    return Skeletonizer(
      enabled: s == null && !down,
      effect: const ShimmerEffect(baseColor: AppColors.surfaceRaised, highlightColor: AppColors.borderStrong),
      child: AnimatedOpacity(
        opacity: down && s != null ? 0.6 : 1,
        duration: AppMotion.of(context, AppMotion.normal),
        child: Container(
          padding: const EdgeInsets.all(AppSpace.md),
          decoration: BoxDecoration(
            color: AppColors.statusPanelBg,
            border: Border.all(color: AppColors.sidebarBorder),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: DefaultTextStyle(
            style: AppText.caption.copyWith(color: AppColors.textPrimary, height: 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Row(
                  l.statusMode,
                  Text(
                    l.statusModeResearch,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                _Row(l.statusAccounting, Mono(s?.accountingAsset ?? 'USDT', style: _mono)),
                _Row(l.statusLive, _live(context, l, s?.live, down)),
                _Row(l.statusEngine, _engine(context, l, s?.workers, down)),
                const Divider(height: 18, color: AppColors.sidebarBorder),
                Text(l.statusFx, style: AppText.caption),
                const SizedBox(height: 3),
                _swap(context, _fx(l, s?.displayRate)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static final _mono = AppText.mono.copyWith(fontSize: 12);

  Widget _live(BuildContext context, L10n l, LiveData? live, bool down) {
    final (text, color, pulse) = switch (live?.state) {
      _ when down => (l.statusLiveOff, AppColors.textMuted, false),
      LiveState.LIVE_STATE_FRESH => (l.statusLiveFresh, AppColors.positive, true),
      LiveState.LIVE_STATE_STALE => (l.statusLiveStale, AppColors.warning, false),
      LiveState.LIVE_STATE_RECONNECTING => (l.statusLiveReconnecting, AppColors.warning, true),
      _ => (l.statusLiveOff, AppColors.textMuted, false),
    };
    final age = live != null && live.state != LiveState.LIVE_STATE_OFF && !down;
    return _swap(
      context,
      _DotLine(
        key: ValueKey('$text$age'),
        dot: _Dot(color: color, pulse: pulse),
        text: TextSpan(
          text: text,
          style: TextStyle(color: color),
          children: [
            if (age) ...[
              const TextSpan(text: ' · '),
              // Latin digits + unit; bidi keeps "4s" intact inside the RTL line.
              TextSpan(
                text: '${live.lastBarAgeSeconds}s',
                style: _mono.copyWith(color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _engine(BuildContext context, L10n l, Workers? w, bool down) {
    final (text, color) = switch (w?.state) {
      _ when down => (l.statusEngineDown, AppColors.negativeText),
      WorkerState.WORKER_STATE_PAUSED => (l.statusEnginePaused, AppColors.warning),
      _ => (l.statusEngineRunning, AppColors.positive),
    };
    return _swap(
      context,
      _DotLine(
        key: ValueKey('$text${w?.count}'),
        dot: _Dot(color: color, pulse: !down),
        text: TextSpan(
          text: down || w == null ? text : '$text · ${l.statusWorkers(w.count)}',
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  Widget _fx(L10n l, DisplayRate? r) {
    if (r == null || !r.hasTomanPerUsdt()) {
      return Text(l.statusFxNone, key: const ValueKey('none'), style: AppText.caption);
    }
    return Wrap(
      key: ValueKey(r.rateId),
      children: [
        Num(moneyValue(r.tomanPerUsdt), fractionDigits: 0, unit: 'TOMAN', style: _mono),
        Mono(' / 1 USDT', style: _mono.copyWith(color: AppColors.textMuted)),
        Text(' · ${l.statusFxManual}', style: AppText.caption),
      ],
    );
  }

  /// Cross-fades a value when it changes.
  Widget _swap(BuildContext context, Widget child) => AnimatedSwitcher(
    duration: AppMotion.of(context, AppMotion.normal),
    layoutBuilder: (current, previous) =>
        Stack(alignment: AlignmentDirectional.centerStart, children: [...previous, ?current]),
    child: child,
  );
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.caption),
        const SizedBox(width: AppSpace.sm),
        // Values wrap rather than overflow or truncate on narrow sidebars.
        Expanded(
          child: Align(alignment: AlignmentDirectional.centerEnd, child: value),
        ),
      ],
    ),
  );
}

class _DotLine extends StatelessWidget {
  const _DotLine({super.key, required this.dot, required this.text});
  final Widget dot;
  final TextSpan text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      dot,
      const SizedBox(width: 6),
      Flexible(child: Text.rich(text, textAlign: TextAlign.end)),
    ],
  );
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.pulse});
  final Color color;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    if (!pulse || AppMotion.of(context, AppMotion.slow) == Duration.zero) return dot;
    return dot
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(begin: 1, end: 0.35, duration: 1200.ms, curve: Curves.easeInOut)
        .scaleXY(begin: 1, end: 0.8, duration: 1200.ms, curve: Curves.easeInOut);
  }
}
