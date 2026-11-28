import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectrpc/connect.dart';

import '../../core/api/engine.dart';
import '../../gen/lab/v1/data.pb.dart';

const pageSize = 20;

final overviewProvider = FutureProvider<GetOverviewResponse>(
  (ref) => ref.watch(dataClientProvider).getOverview(GetOverviewRequest()),
);

typedef DatasetPage = ({String query, String timeframe, int offset});

final researchDatasetPageProvider = FutureProvider.autoDispose.family<ListDatasetsResponse, DatasetPage>(
  (ref, page) => _researchCatalog(
    ref,
    ListDatasetsRequest(
      query: page.query,
      timeframe: page.timeframe,
      offset: page.offset,
      pageSize: pageSize,
      researchOnly: true,
    ),
  ),
);

// Resolve draft selections independently of the visible page.
final researchDatasetByIdProvider = FutureProvider.autoDispose.family<Dataset?, String>((ref, id) async {
  final result = await _researchCatalog(ref, ListDatasetsRequest(ids: [id], pageSize: 1, researchOnly: true));
  return result.datasets.where((d) => d.id == id).firstOrNull;
});

Future<ListDatasetsResponse> _researchCatalog(Ref ref, ListDatasetsRequest request) async {
  final client = ref.watch(dataClientProvider);
  final signal = CancelableSignal();
  ref.onDispose(signal.cancel);
  final overview = await ref.watch(overviewProvider.future);
  final allowed = overview.researchCapabilities.where((c) => c.supported).map((c) => c.symbol).toSet();
  if (allowed.isEmpty) return ListDatasetsResponse();
  final result = await client.listDatasets(request, signal: signal);
  // Older engines can ignore the new request fields. Permission stays affirmative.
  return ListDatasetsResponse(
    total: result.total,
    datasets: result.datasets.where(
      (d) => allowed.contains(d.symbol) && (request.timeframe.isEmpty || d.timeframe == request.timeframe),
    ),
  );
}

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
        ..invalidate(researchDatasetPageProvider)
        ..invalidate(researchDatasetByIdProvider)
        ..invalidate(datasetsProvider)
        ..invalidate(coverageProvider)
        ..invalidate(issuesProvider)
        ..invalidate(overviewProvider);
    }
  }
}

final importProvider = NotifierProvider<ImportController, ImportState>(ImportController.new);
