import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';

import '../../core/api/engine.dart';
import '../../gen/lab/v1/data.pb.dart';

const pageSize = 20;

/// Shared picker cache; imports invalidate it along with the paged Data screen.
// shortcut: existing pickers need all versions; replace with server search for large catalogs.
final allDatasetsProvider = FutureProvider<ListDatasetsResponse>((ref) async {
  final client = ref.watch(dataClientProvider);
  final signal = CancelableSignal();
  ref.onDispose(signal.cancel);
  final result = ListDatasetsResponse();
  while (true) {
    final page = await client.listDatasets(
      ListDatasetsRequest(pageSize: 200, offset: result.datasets.length),
      signal: signal,
    );
    result.total = page.total;
    result.datasets.addAll(page.datasets);
    if (page.datasets.isEmpty || result.datasets.length >= page.total.toInt()) return result;
  }
});

final overviewProvider = FutureProvider<GetOverviewResponse>(
  (ref) => ref.watch(dataClientProvider).getOverview(GetOverviewRequest()),
);

/// Execution requires affirmative server permission; Data keeps every version.
final researchDatasetsProvider = FutureProvider<ListDatasetsResponse>((ref) async {
  final overviewFuture = ref.watch(overviewProvider.future);
  final datasetsFuture = ref.watch(allDatasetsProvider.future);
  final overview = await overviewFuture;
  final all = await datasetsFuture;
  final allowed = overview.researchCapabilities.where((c) => c.supported).map((c) => c.symbol).toSet();
  final datasets = all.datasets.where((d) => allowed.contains(d.symbol)).toList();
  return ListDatasetsResponse(datasets: datasets, total: Int64(datasets.length));
});

final datasetsProvider = FutureProvider.family<ListDatasetsResponse, int>(
  (ref, offset) => ref.watch(dataClientProvider).listDatasets(ListDatasetsRequest(pageSize: pageSize, offset: offset)),
);

final coverageProvider = FutureProvider<GetCoverageResponse>(
  (ref) => ref.watch(dataClientProvider).getCoverage(GetCoverageRequest()),
);

final issuesProvider = FutureProvider.family<ListQualityIssuesResponse, int>(
  (ref, offset) =>
      ref.watch(dataClientProvider).listQualityIssues(ListQualityIssuesRequest(pageSize: pageSize, offset: offset)),
);

class ImportState {
  const ImportState({this.running = false, this.progress = const {}, this.created = const [], this.error});
  final bool running;
  final Map<String, ImportProgress> progress; // by symbol
  final List<Dataset> created;
  final Object? error;
}

/// Runs DataService.Import and keeps its streamed progress for the form.
class ImportController extends Notifier<ImportState> {
  @override
  ImportState build() => const ImportState();

  Future<void> run(ImportRequest req) async {
    if (state.running) return;
    state = const ImportState(running: true);
    try {
      await for (final ev in ref.read(dataClientProvider).import(req)) {
        if (ev.hasProgress()) {
          state = ImportState(
            running: true,
            progress: {...state.progress, ev.progress.symbol: ev.progress},
            created: state.created,
          );
        } else if (ev.hasDataset()) {
          state = ImportState(running: true, progress: state.progress, created: [...state.created, ev.dataset]);
        }
      }
      state = ImportState(progress: state.progress, created: state.created);
    } catch (e) {
      state = ImportState(progress: state.progress, created: state.created, error: e);
    } finally {
      // New bars, issues and versions: refresh every view that shows them.
      ref
        ..invalidate(allDatasetsProvider)
        ..invalidate(datasetsProvider)
        ..invalidate(coverageProvider)
        ..invalidate(issuesProvider)
        ..invalidate(overviewProvider);
    }
  }
}

final importProvider = NotifierProvider<ImportController, ImportState>(ImportController.new);
