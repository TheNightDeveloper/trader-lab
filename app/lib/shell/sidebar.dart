import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../app/nav.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/num.dart';
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
    final stagger = AppMotion.of(context, AppMotion.stagger);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
        border: BorderDirectional(end: BorderSide(color: AppColors.sidebarBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.appTitle, style: AppText.sectionTitle.copyWith(fontSize: 15)),
                    Mono(l.appSubtitle, style: AppText.mono.copyWith(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: AnimationLimiter(
                  child: ListView(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: AppMotion.of(context, AppMotion.slow),
                      delay: stagger,
                      childAnimationBuilder: (w) => SlideAnimation(
                        horizontalOffset: 16,
                        curve: AppMotion.curve,
                        child: FadeInAnimation(child: w),
                      ),
                      children: [
                        for (final e in Dest.sidebar)
                          switch (e) {
                            NavHeader(:final label) => _GroupHeader(label(l)),
                            NavSoon(:final label) => _SoonItem(label(l), badge: l.phase2),
                            NavLink(:final dest) => _NavItem(
                              label: dest.label(l),
                              selected: identical(dest, active),
                              onTap: () {
                                context.go(dest.path);
                                onNavigate?.call();
                              },
                            ),
                          },
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.md),
              const StatusBlock(),
            ],
          ),
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
    padding: const EdgeInsets.fromLTRB(10, 14, 10, 6),
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
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final d = AppMotion.of(context, AppMotion.fast);
    final sel = widget.selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Semantics(
        link: true,
        selected: sel,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(AppRadius.md),
              splashColor: AppColors.accentSoftBg,
              hoverColor: Colors.transparent, // hover is the animated fill below
              child: AnimatedContainer(
                duration: d,
                curve: AppMotion.curve,
                constraints: const BoxConstraints(minHeight: 40),
                decoration: BoxDecoration(
                  color: sel
                      ? AppColors.navActiveBg
                      : _hover
                      ? AppColors.surfaceRaised
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    // Active indicator grows in at the reading-start edge.
                    AnimatedContainer(
                      duration: AppMotion.of(context, AppMotion.normal),
                      curve: AppMotion.curve,
                      width: 3,
                      height: sel ? 18 : 0,
                      margin: const EdgeInsetsDirectional.only(start: 2),
                      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2)),
                    ),
                    Expanded(
                      child: AnimatedPadding(
                        duration: d,
                        curve: AppMotion.curve,
                        padding: EdgeInsetsDirectional.only(
                          start: _hover && !sel ? 11 : 7,
                          end: 12,
                          top: 10,
                          bottom: 10,
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: d,
                          style: AppText.body.copyWith(
                            height: 1.4,
                            color: sel || _hover ? AppColors.textPrimary : AppColors.textSecondary,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                          ),
                          child: Text(widget.label),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoonItem extends StatelessWidget {
  const _SoonItem(this.label, {required this.badge});
  final String label;
  final String badge;

  @override
  Widget build(BuildContext context) => Semantics(
    enabled: false,
    label: '$label، $badge',
    excludeSemantics: true,
    child: Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppText.body.copyWith(height: 1.4, color: AppColors.textMuted)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderStrong),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(badge, style: AppText.caption.copyWith(fontSize: 11, height: 1.5)),
          ),
        ],
      ),
    ),
  );
}
