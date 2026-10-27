import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/tokens.dart';
import '../features/chart/chart_screen.dart';
import '../features/placeholder_screen.dart';
import '../shell/app_shell.dart';
import 'nav.dart';

/// Material fade-through between screens; instant when reduced motion is on.
Page<void> _page(BuildContext context, GoRouterState state, Widget child) => CustomTransitionPage(
  key: state.pageKey,
  transitionDuration: AppMotion.of(context, AppMotion.slow),
  reverseTransitionDuration: AppMotion.of(context, AppMotion.normal),
  transitionsBuilder: (context, animation, secondary, child) =>
      FadeThroughTransition(animation: animation, secondaryAnimation: secondary, fillColor: AppColors.bg, child: child),
  child: child,
);

GoRoute _placeholder(NavDest d, {String? path}) => GoRoute(
  path: path ?? d.path,
  pageBuilder: (context, state) => _page(context, state, PlaceholderScreen(dest: d)),
);

GoRouter buildRouter({String initialLocation = '/'}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(location: state.uri.path, child: child),
      routes: [
        _placeholder(Dest.home),
        _placeholder(Dest.library),
        _placeholder(Dest.builder),
        _placeholder(Dest.queue),
        _placeholder(Dest.queue, path: '/experiments/:id/queue'),
        _placeholder(Dest.reports),
        _placeholder(Dest.reports, path: '/reports/:id'),
        _placeholder(Dest.compare),
        _placeholder(Dest.pnl),
        _placeholder(Dest.learning),
        GoRoute(path: Dest.chart.path, pageBuilder: (context, state) => _page(context, state, const ChartScreen())),
        _placeholder(Dest.data),
        _placeholder(Dest.settings),
      ],
    ),
  ],
);
