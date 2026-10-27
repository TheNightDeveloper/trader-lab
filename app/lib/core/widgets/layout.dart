import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.subtitle, this.actions = const []});
  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    crossAxisAlignment: WrapCrossAlignment.end,
    spacing: AppSpace.lg,
    runSpacing: AppSpace.md,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(header: true, child: Text(title, style: AppText.pageTitle)),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpace.xs),
            Text(subtitle!, style: AppText.body.copyWith(color: AppColors.textMuted)),
          ],
        ],
      ),
      if (actions.isNotEmpty) Wrap(spacing: AppSpace.sm, runSpacing: AppSpace.sm, children: actions),
    ],
  );
}

/// Unit shown inside a numeric field with a gap from the value ("10000  USDT"),
/// instead of suffixText, which RTL layout glues to the LTR number.
Widget? unitSuffix(String? unit) => unit == null
    ? null
    : Padding(
        padding: const EdgeInsets.only(right: AppSpace.sm),
        child: Text(unit, style: AppText.label),
      );

enum CardTone { normal, positive, negative }

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, this.title, this.trailing, required this.child, this.tone = CardTone.normal});
  final String? title;
  final Widget? trailing;
  final Widget child;
  final CardTone tone;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: AppMotion.of(context, AppMotion.normal),
    curve: AppMotion.curve,
    padding: const EdgeInsets.all(AppSpace.lg + 2),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(
        color: switch (tone) {
          CardTone.normal => AppColors.border,
          CardTone.positive => AppColors.positiveBorder,
          CardTone.negative => AppColors.negativeBorder,
        },
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || trailing != null) ...[
          // Wrap: a long trailing note drops below the title on narrow screens.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpace.md,
            runSpacing: AppSpace.xs,
            children: [
              if (title != null) Text(title!, style: AppText.sectionTitle),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpace.md),
        ],
        child,
      ],
    ),
  );
}

class WarningBanner extends StatelessWidget {
  const WarningBanner(this.text, {super.key, this.icon = Icons.warning_amber_rounded});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.warning),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Text(text, style: AppText.body.copyWith(color: AppColors.warningText)),
          ),
        ],
      ),
    ),
  );
}
