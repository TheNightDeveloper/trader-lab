import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/tokens.dart';

/// Experiment / attempt status → (label, color). Unknown statuses show as is.
(String, Color) runStatus(L10n l, String s) => switch (s) {
  'queued' => (l.st_queued, AppColors.textMuted),
  'running' => (l.st_running, AppColors.accent),
  'paused' => (l.st_paused, AppColors.warning),
  'finalizing' => (l.st_finalizing, AppColors.accent),
  'done' => (l.st_done, AppColors.positive),
  'cancelled' => (l.st_cancelled, AppColors.textMuted),
  'failed' => (l.st_failed, AppColors.negativeText),
  _ => (s, AppColors.textMuted),
};

/// Algorithm version lifecycle state → (label, color).
(String, Color) lifecycleState(L10n l, String s) => switch (s) {
  'research' => (l.lc_research, AppColors.warning),
  'validation' => (l.lc_validation, AppColors.warning),
  'forward_test' => (l.lc_forward_test, AppColors.accent),
  'active' => (l.lc_active, AppColors.positive),
  'stopped' => (l.lc_stopped, AppColors.textMuted),
  'retired' => (l.lc_retired, AppColors.textMuted),
  _ => (s, AppColors.textMuted),
};

/// A status as dot + text: color is never the only cue.
class StatusText extends StatelessWidget {
  const StatusText(this.status, {super.key});
  final (String, Color) status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = status;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(label, style: AppText.body.copyWith(color: color, height: 1.4)),
        ),
      ],
    );
  }
}

/// Horizontal bar of colored segments, each a fraction of [total]; animates on change.
class StackedBar extends StatelessWidget {
  const StackedBar({super.key, required this.segments, required this.total, this.height = 10});
  final List<(int, Color)> segments;
  final int total;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height / 2),
    child: Container(
      height: height,
      color: AppColors.inputBg,
      child: LayoutBuilder(
        builder: (context, box) => Row(
          children: [
            for (final (n, c) in segments)
              AnimatedContainer(
                duration: AppMotion.of(context, AppMotion.slow),
                curve: AppMotion.curve,
                width: total <= 0 ? 0 : box.maxWidth * (n / total).clamp(0, 1),
                color: c,
              ),
          ],
        ),
      ),
    ),
  );
}

/// Asks before an action that changes recorded state. Returns true on confirm.
Future<bool> confirmAction(BuildContext context, {required String title, required String body, Widget? extra}) async {
  final l = L10n.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surfaceRaised,
      title: Text(title, style: AppText.sectionTitle),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(body, style: AppText.body),
            if (extra != null) ...[const SizedBox(height: AppSpace.md), extra],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.confirm)),
      ],
    ),
  );
  return ok ?? false;
}
