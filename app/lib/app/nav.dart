import '../l10n/app_localizations.dart';

/// One sidebar destination. [milestone] is the plan milestone that builds the screen.
class NavDest {
  const NavDest(this.path, this.label, this.subtitle, this.milestone);
  final String path;
  final String Function(L10n) label;
  final String Function(L10n) subtitle;
  final String milestone;

  /// True when [location] is this destination or one of its sub-routes.
  bool matches(String location) => path == '/' ? location == '/' : location == path || location.startsWith('$path/');
}

sealed class NavEntry {
  const NavEntry();
}

class NavLink extends NavEntry {
  const NavLink(this.dest);
  final NavDest dest;
}

class NavHeader extends NavEntry {
  const NavHeader(this.label);
  final String Function(L10n) label;
}

/// Phase 2 item: shown disabled with a badge, never navigable.
class NavSoon extends NavEntry {
  const NavSoon(this.label);
  final String Function(L10n) label;
}

abstract final class Dest {
  static final home = NavDest('/', (l) => l.navHome, (l) => l.screenHomeSub, 'M6');
  static final library = NavDest('/library', (l) => l.navLibrary, (l) => l.screenLibrarySub, 'M4');
  static final builder = NavDest('/experiments/new', (l) => l.navBuilder, (l) => l.screenBuilderSub, 'M4');
  static final queue = NavDest('/queue', (l) => l.navQueue, (l) => l.screenQueueSub, 'M4');
  static final reports = NavDest('/reports', (l) => l.navReports, (l) => l.screenReportsSub, 'M3');
  static final compare = NavDest('/compare', (l) => l.navCompare, (l) => l.screenCompareSub, 'M3');
  static final pnl = NavDest('/pnl', (l) => l.navPnl, (l) => l.screenPnlSub, 'M3');
  static final learning = NavDest('/learning', (l) => l.navLearning, (l) => l.screenLearningSub, 'M5');
  static final chart = NavDest('/chart', (l) => l.navChart, (l) => l.screenChartSub, 'M6');
  static final data = NavDest('/data', (l) => l.navData, (l) => l.screenDataSub, 'M1');
  static final settings = NavDest('/settings', (l) => l.navSettings, (l) => l.screenSettingsSub, 'M1');

  static final all = [home, library, builder, queue, reports, compare, pnl, learning, chart, data, settings];

  /// Sidebar order and grouping, from design/screens/Sidebar.dc.html.
  static final sidebar = <NavEntry>[
    NavLink(home),
    NavHeader((l) => l.navGroupResearch),
    NavLink(library),
    NavLink(builder),
    NavLink(queue),
    NavLink(reports),
    NavLink(compare),
    NavLink(pnl),
    NavHeader((l) => l.navGroupLearning),
    NavLink(learning),
    NavLink(chart),
    NavLink(data),
    NavHeader((l) => l.navGroupLater),
    NavSoon((l) => l.navPaper),
    NavSoon((l) => l.navRisk),
    NavSoon((l) => l.navJournal),
    NavSoon((l) => l.navMarket),
    NavHeader((l) => l.navGroupSystem),
    NavLink(settings),
  ];

  /// Destination for a location; the longest matching path wins.
  static NavDest? of(String location) {
    NavDest? best;
    for (final d in all) {
      if (d.matches(location) && (best == null || d.path.length > best.path.length)) best = d;
    }
    // `/experiments/:id/queue` belongs to the queue, not the builder.
    if (location.startsWith('/experiments/') && location.endsWith('/queue')) return queue;
    return best;
  }
}
