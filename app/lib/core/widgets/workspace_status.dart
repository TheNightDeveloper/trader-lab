import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../gen/lab/v1/health.pb.dart';
import '../../gen/lab/v1/workspace.pbenum.dart';
import '../../l10n/app_localizations.dart';
import '../api/engine.dart';
import '../theme/tokens.dart';
import 'status.dart';

/// The header and its modal navigation drawer share the same confirmed environment.
class CurrentEnvironmentBadge extends ConsumerWidget {
  const CurrentEnvironmentBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => EnvironmentBadge(
    environment: ref.watch(engineStatusProvider.select((status) => workspaceEnvironment(status.value))),
  );
}

/// Persistent label for the environment last confirmed by the engine.
class EnvironmentBadge extends StatelessWidget {
  const EnvironmentBadge({super.key, required this.environment});

  final Environment environment;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final (label, foreground, background, border) = switch (environment) {
      Environment.ENVIRONMENT_RESEARCH => (
        l.statusModeResearch,
        AppColors.link,
        AppColors.accentSoftBg,
        AppColors.accentBorder,
      ),
      Environment.ENVIRONMENT_PAPER => (
        l.statusModePaper,
        AppColors.positive,
        AppColors.surface,
        AppColors.positiveBorder,
      ),
      Environment.ENVIRONMENT_LIVE => (
        l.statusModeLive,
        AppColors.warningText,
        AppColors.warningBg,
        AppColors.warningBorder,
      ),
      _ => (l.statusModeUnknown, AppColors.textSecondary, AppColors.surface, AppColors.borderStrong),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.xs),
        child: Text(
          label,
          style: AppText.caption.copyWith(color: foreground, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Shows feed freshness with the age supplied by the last server snapshot.
class FreshnessBadge extends StatelessWidget {
  const FreshnessBadge({super.key, required this.live, required this.disconnected});

  final LiveData? live;
  final bool disconnected;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final data = live;
    final (label, color) = switch (data?.state) {
      _ when disconnected => (l.statusLiveUnavailable, AppColors.warningText),
      LiveState.LIVE_STATE_OFF => (l.statusLiveOff, AppColors.textMuted),
      LiveState.LIVE_STATE_FRESH => (l.statusLiveFresh, AppColors.positive),
      LiveState.LIVE_STATE_STALE => (l.statusLiveStale, AppColors.warning),
      LiveState.LIVE_STATE_RECONNECTING => (l.statusLiveReconnecting, AppColors.warning),
      _ => (l.statusLiveUnknown, AppColors.textMuted),
    };
    // A nonzero age still works with legacy engines that lack the timestamp field.
    if (!disconnected && data != null && (data.hasLastBarClosedAtUnixMs() || data.lastBarAgeSeconds.toInt() > 0)) {
      return StatusText((l.statusBarAge(label, data.lastBarAgeSeconds.toInt()), color));
    }
    return StatusText((label, color));
  }
}
