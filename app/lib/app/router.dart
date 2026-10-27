import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/tokens.dart';
import '../features/chart/chart_screen.dart';
import '../features/data/data_screen.dart';
import '../features/experiments/builder_screen.dart';
import '../features/experiments/queue_screen.dart';
import '../features/library/library_screen.dart';
import '../features/placeholder_screen.dart';
import '../features/pnl/pnl_screen.dart';
import '../features/reports/compare_screen.dart';
import '../features/reports/report_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/settings/settings_screen.dart';
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
        GoRoute(path: Dest.library.path, pageBuilder: (context, state) => _page(context, state, const LibraryScreen())),
        GoRoute(
          path: Dest.builder.path,
          pageBuilder: (context, state) =>
              _page(context, state, BuilderScreen(algo: state.uri.queryParameters['algo'])),
        ),
        GoRoute(path: Dest.queue.path, pageBuilder: (context, state) => _page(context, state, const QueueListScreen())),
        GoRoute(
          path: '/experiments/:id/queue',
          pageBuilder: (context, state) =>
              _page(context, state, ExperimentQueueScreen(id: state.pathParameters['id']!)),
        ),
        GoRoute(path: Dest.reports.path, pageBuilder: (context, state) => _page(context, state, const ReportsScreen())),
        GoRoute(
          path: '/reports/:id',
          pageBuilder: (context, state) => _page(context, state, ReportScreen(id: state.pathParameters['id']!)),
        ),
        GoRoute(
          path: Dest.compare.path,
          pageBuilder: (context, state) => _page(
            context,
            state,
            CompareScreen(ids: (state.uri.queryParameters['ids'] ?? '').split(',').where((s) => s.isNotEmpty).toList()),
          ),
        ),
        GoRoute(
          path: Dest.pnl.path,
          pageBuilder: (context, state) =>
              _page(context, state, PnlScreen(reportId: state.uri.queryParameters['report'])),
        ),
        _placeholder(Dest.learning),
        GoRoute(path: Dest.chart.path, pageBuilder: (context, state) => _page(context, state, const ChartScreen())),
        GoRoute(path: Dest.data.path, pageBuilder: (context, state) => _page(context, state, const DataScreen())),
        GoRoute(
          path: Dest.settings.path,
          pageBuilder: (context, state) => _page(context, state, const SettingsScreen()),
        ),
      ],
    ),
  ],
);
