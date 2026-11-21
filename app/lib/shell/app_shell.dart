import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/api/engine.dart';
import '../core/format.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/layout.dart';
import '../core/widgets/workspace_status.dart';
import '../l10n/app_localizations.dart';
import 'sidebar.dart';

/// Fixed RTL sidebar on desktop, drawer on narrower workspaces.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final docked = ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);
    return Scaffold(
      drawer: docked
          ? null
          : Drawer(
              width: AppSize.sidebarWidth + AppSpace.xxl,
              backgroundColor: AppColors.sidebarBg,
              shape: const RoundedRectangleBorder(),
              child: AppSidebar(location: location, onNavigate: () => Navigator.of(context).pop()),
            ),
      body: Row(
        children: [
          if (docked)
            SizedBox(
              width: AppSize.sidebarWidth,
              child: AppSidebar(location: location),
            ),
          Expanded(
            // A breakpoint change must preserve the current route subtree and its draft inputs.
            key: const ValueKey('workspace-content'),
            child: SafeArea(
              child: Column(
                children: [
                  _WorkspaceHeader(docked: docked),
                  const _StaleBanner(),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader({required this.docked});

  final bool docked;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
        border: Border(bottom: BorderSide(color: AppColors.sidebarBorder)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: docked ? AppSpace.page : AppSpace.sm, vertical: AppSpace.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!docked) ...[
              const _DrawerMenuButton(),
              Expanded(child: Text(l.appTitle, style: AppText.sectionTitle)),
              const SizedBox(width: AppSpace.sm),
            ],
            const Flexible(child: CurrentEnvironmentBadge()),
          ],
        ),
      ),
    );
  }
}

class _DrawerMenuButton extends StatelessWidget {
  const _DrawerMenuButton();

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: L10n.of(context).openMenu,
    icon: const Icon(Icons.menu_rounded),
    constraints: const BoxConstraints.tightFor(width: AppSize.minTouch, height: AppSize.minTouch),
    visualDensity: VisualDensity.standard,
    onPressed: Scaffold.of(context).openDrawer,
  );
}

/// Preserve the last snapshot during retries and announce how old its source is.
class _StaleBanner extends ConsumerWidget {
  const _StaleBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (down, lastSeen) = ref.watch(
      engineStatusProvider.select(
        (status) => (status.hasError, status.hasError ? status.value?.serverTimeUnixMs : null),
      ),
    );
    if (!down) return const SizedBox.shrink();

    final l = L10n.of(context);
    final message = lastSeen != null && lastSeen.toInt() > 0
        ? l.engineLastSeen('\u2066${fmtDateTime(utcMs(lastSeen))} UTC\u2069')
        : l.engineUnreachable;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.sm, AppSpace.lg, 0),
      child: WarningBanner(message, icon: Icons.cloud_off_rounded),
    );
  }
}
