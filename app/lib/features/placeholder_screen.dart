import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../app/nav.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/layout.dart';
import '../l10n/app_localizations.dart';

/// Page frame shared by every screen: max width, page padding, scroll, and a
/// staggered entrance for its sections.
class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final mobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final pad = mobile ? AppSpace.lg : AppSpace.page;
    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: MaxWidthBox(
        maxWidth: AppSize.pageMaxWidth,
        alignment: AlignmentDirectional.topStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, c) in children.indexed) ...[
              if (i > 0) const SizedBox(height: AppSpace.xl),
              c
                  .animate(delay: AppMotion.of(context, AppMotion.stagger) * (i * 2))
                  .fadeIn(duration: AppMotion.of(context, AppMotion.slow), curve: AppMotion.curve)
                  .slideY(begin: 0.04, duration: AppMotion.of(context, AppMotion.slow), curve: AppMotion.curve),
            ],
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.dest});
  final NavDest dest;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return PageFrame(
      children: [
        PageHeader(title: dest.label(l), subtitle: dest.subtitle(l)),
        SectionCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.xxl),
            child: Column(
              children: [
                Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.accentSoftBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentBorder),
                      ),
                      child: const Icon(Icons.construction_rounded, color: AppColors.accent),
                    )
                    .animate(delay: AppMotion.of(context, AppMotion.slow))
                    .scaleXY(begin: 0.6, duration: AppMotion.of(context, AppMotion.slow), curve: Curves.easeOutBack),
                const SizedBox(height: AppSpace.lg),
                Text(l.comingIn(dest.milestone), style: AppText.sectionTitle, textAlign: TextAlign.center),
                const SizedBox(height: AppSpace.xs),
                Text(l.comingInHint, style: AppText.caption, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
