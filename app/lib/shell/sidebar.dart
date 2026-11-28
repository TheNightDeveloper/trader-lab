import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../app/nav.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/num.dart';
import '../core/widgets/workspace_status.dart';
import '../l10n/app_localizations.dart';
import 'status_block.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key, required this.location, this.onNavigate});

  final String location;
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final active = Dest.of(location);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
        border: BorderDirectional(end: BorderSide(color: AppColors.sidebarBorder)),
      ),
      // Keep every link and the status panel reachable at enlarged text sizes.
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.xl),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.sm, 0, AppSpace.sm, AppSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.appTitle, style: AppText.sectionTitle),
                  Mono(l.appSubtitle, style: AppText.mono.copyWith(fontSize: 11, color: AppColors.textMuted)),
                  if (onNavigate != null) ...[const SizedBox(height: AppSpace.sm), const CurrentEnvironmentBadge()],
                ],
              ),
            ),
            // Connection status stays above growing navigation on the docked sidebar.
            if (onNavigate == null) ...[const StatusBlock(), const SizedBox(height: AppSpace.sm)],
            for (final entry in Dest.sidebar)
              switch (entry) {
                NavHeader(:final label) => _GroupHeader(label(l)),
                NavLink(:final dest) => _NavItem(
                  label: dest.label(l),
                  selected: identical(dest, active),
                  onTap: () {
                    onNavigate?.call();
                    context.go(dest.path);
                  },
                ),
              },
            if (onNavigate != null) ...[const SizedBox(height: AppSpace.lg), const StatusBlock()],
          ],
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppSpace.md, AppSpace.md, AppSpace.md, AppSpace.xs),
    child: Semantics(header: true, child: Text(label, style: AppText.caption)),
  );
}

class _NavItem extends StatefulWidget {
  const _NavItem({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final radius = BorderRadius.circular(AppRadius.md);
    return Semantics(
      link: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.navActiveBg : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: _focused ? AppColors.accent : Colors.transparent, width: 2),
        ),
        child: InkWell(
          onTap: widget.onTap,
          onFocusChange: (focused) => setState(() => _focused = focused),
          borderRadius: radius,
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            constraints: const BoxConstraints(minHeight: AppSize.minTouch),
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
            child: Text(
              widget.label,
              style: AppText.body.copyWith(
                color: selected ? AppColors.link : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
