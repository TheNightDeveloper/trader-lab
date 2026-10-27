import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/engine.dart';
import '../../gen/lab/v1/data.pb.dart';
import '../../gen/lab/v1/report.pb.dart';

const reportsPageSize = 20;

final reportsProvider = FutureProvider.family<ListReportsResponse, int>(
  (ref, offset) =>
      ref.watch(reportClientProvider).listReports(ListReportsRequest(pageSize: reportsPageSize, offset: offset)),
);

final strategiesProvider = FutureProvider<ListStrategiesResponse>(
  (ref) => ref.watch(reportClientProvider).listStrategies(ListStrategiesRequest()),
);

/// Every dataset version, for pickers (the Data screen pages them instead).
final allDatasetsProvider = FutureProvider<ListDatasetsResponse>(
  (ref) => ref.watch(dataClientProvider).listDatasets(ListDatasetsRequest(pageSize: 200)),
);

/// A report with Toman equivalents at the current display rate (if any).
final reportProvider = FutureProvider.family<Report, String>((ref, id) async {
  final rate = ref.watch(displayRateIdProvider);
  final res = await ref
      .watch(reportClientProvider)
      .getReport(GetReportRequest(reportId: id, fxRateId: rate == 0 ? null : Int64(rate)));
  return res.report;
});

final compareProvider = FutureProvider.family<CompareResponse, String>(
  (ref, ids) => ref.watch(reportClientProvider).compare(CompareRequest(reportIds: ids.split(','))),
);

/// Reports picked for comparison, in the order they were added (A, B, C…).
class CompareSelection extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  void toggle(String id) => state = state.contains(id) ? [...state.where((x) => x != id)] : [...state, id];
  void clear() => state = const [];
}

final compareSelectionProvider = NotifierProvider<CompareSelection, List<String>>(CompareSelection.new);
