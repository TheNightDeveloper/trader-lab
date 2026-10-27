import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/api/engine.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/layout.dart';
import '../l10n/app_localizations.dart';
import 'sidebar.dart';

/// Sidebar + content. ≥600 px: fixed sidebar (on the right, RTL). Narrower: drawer.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});
  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    final content = Column(
      children: [
        const _StaleBanner(),
        Expanded(child: child),
      ],
    );
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: AppSize.sidebarWidth,
              child: AppSidebar(location: location),
            ),
            Expanded(child: content),
          ],
        ),
      );
    }
    final l = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sidebarBg,
        surfaceTintColor: Colors.transparent,
        title: Text(l.appTitle, style: AppText.sectionTitle),
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: l.openMenu,
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        width: AppSize.sidebarWidth + AppSpace.xxl,
        backgroundColor: AppColors.sidebarBg,
        shape: const RoundedRectangleBorder(),
        child: AppSidebar(location: location, onNavigate: () => Navigator.of(context).pop()),
      ),
      body: content,
    );
  }
}

/// Shown while the engine is unreachable; the last known data stays visible below.
class _StaleBanner extends ConsumerWidget {
  const _StaleBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final down = ref.watch(engineStatusProvider.select((s) => s.hasError));
    return AnimatedSize(
      duration: AppMotion.of(context, AppMotion.normal),
      curve: AppMotion.curve,
      child: down
          ? Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.page, AppSpace.lg, AppSpace.page, 0),
              child: WarningBanner(L10n.of(context).engineUnreachable, icon: Icons.cloud_off_rounded)
                  .animate()
                  .fadeIn(duration: AppMotion.of(context, AppMotion.normal))
                  .slideY(begin: -0.3, curve: AppMotion.curve),
            )
          : const SizedBox(width: double.infinity),
    );
  }
}
