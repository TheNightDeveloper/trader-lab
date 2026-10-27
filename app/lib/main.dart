import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app/router.dart';
import 'core/theme/tokens.dart';
import 'l10n/app_localizations.dart';

void main() {
  usePathUrlStrategy(); // /reports/42, not /#/reports/42; the engine serves index.html for both
  runApp(ProviderScope(child: LabApp(router: buildRouter())));
}

/// docs/UI_SPEC.md §4: <600 mobile (drawer), 600–1199 tablet, ≥1200 desktop.
const breakpoints = [
  Breakpoint(start: 0, end: AppSize.mobileBreakpoint - 1, name: MOBILE),
  Breakpoint(start: AppSize.mobileBreakpoint, end: AppSize.desktopBreakpoint - 1, name: TABLET),
  Breakpoint(start: AppSize.desktopBreakpoint, end: double.infinity, name: DESKTOP),
];

class LabApp extends StatelessWidget {
  const LabApp({super.key, required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    onGenerateTitle: (context) => L10n.of(context).appTitle,
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    locale: const Locale('fa'),
    supportedLocales: L10n.supportedLocales,
    localizationsDelegates: const [
      L10n.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    // Locale fa already implies RTL; this makes it explicit and locale-proof.
    builder: (context, child) => ResponsiveBreakpoints.builder(
      breakpoints: breakpoints,
      child: Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
    routerConfig: router,
  );
}
