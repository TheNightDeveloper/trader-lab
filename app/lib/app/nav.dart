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
  static final market = NavDest('/market', (l) => l.navMarket, (l) => l.screenMarketSub);
  static final paper = NavDest('/paper', (l) => l.navPaper, (l) => l.screenPaperSub);
  static final settings = NavDest('/settings', (l) => l.navSettings, (l) => l.screenSettingsSub);

  static final all = [home, library, builder, queue, reports, compare, pnl, learning, chart, data, market, paper, settings];

  /// Published routes grouped by the tasks available in the research workspace.
  static final sidebar = <NavEntry>[
    NavLink(home),
    NavHeader((l) => l.navGroupResearch),
    NavLink(library),
    NavLink(builder),
    NavLink(queue),
    NavLink(reports),
    NavLink(compare),
    NavHeader((l) => l.navGroupLearning),
    NavLink(learning),
    NavHeader((l) => l.navGroupReview),
    NavLink(chart),
    NavLink(pnl),
    NavLink(market),
    NavLink(paper),
    NavHeader((l) => l.navGroupControl),
    NavLink(data),
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
