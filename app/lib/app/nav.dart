import '../l10n/app_localizations.dart';

/// One sidebar destination.
class NavDest {
  const NavDest(this.path, this.label, this.subtitle);
  final String path;
  final String Function(L10n) label;
  final String Function(L10n) subtitle;

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
  static final home = NavDest('/', (l) => l.navHome, (l) => l.screenHomeSub);
  static final library = NavDest('/library', (l) => l.navLibrary, (l) => l.screenLibrarySub);
  static final builder = NavDest('/experiments/new', (l) => l.navBuilder, (l) => l.screenBuilderSub);
  static final queue = NavDest('/queue', (l) => l.navQueue, (l) => l.screenQueueSub);
  static final reports = NavDest('/reports', (l) => l.navReports, (l) => l.screenReportsSub);
  static final compare = NavDest('/compare', (l) => l.navCompare, (l) => l.screenCompareSub);
  static final pnl = NavDest('/pnl', (l) => l.navPnl, (l) => l.screenPnlSub);
  static final learning = NavDest('/learning', (l) => l.navLearning, (l) => l.screenLearningSub);
  static final chart = NavDest('/chart', (l) => l.navChart, (l) => l.screenChartSub);
  static final data = NavDest('/data', (l) => l.navData, (l) => l.screenDataSub);
  static final settings = NavDest('/settings', (l) => l.navSettings, (l) => l.screenSettingsSub);

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
