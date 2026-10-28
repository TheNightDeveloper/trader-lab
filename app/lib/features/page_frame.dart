import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/theme/tokens.dart';

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
