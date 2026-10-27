import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/engine.dart';
import '../../gen/lab/v1/experiment.pb.dart';
import '../../gen/lab/v1/library.pb.dart';

const experimentsPageSize = 20;
const attemptsPageSize = 20;

final experimentsProvider = FutureProvider.family<ListExperimentsResponse, int>(
  (ref, offset) => ref
      .watch(experimentClientProvider)
      .listExperiments(ListExperimentsRequest(pageSize: experimentsPageSize, offset: offset)),
);

final experimentProvider = FutureProvider.family<GetExperimentResponse, String>(
  (ref, id) => ref.watch(experimentClientProvider).getExperiment(GetExperimentRequest(experimentId: id)),
);

/// Progress every second until the experiment ends; then the last value stays.
final experimentWatchProvider = StreamProvider.family<WatchExperimentResponse, String>(
  (ref, id) => ref.watch(experimentClientProvider).watchExperiment(WatchExperimentRequest(experimentId: id)),
  retry: reconnectForever,
);

typedef AttemptsQuery = ({String id, String status, int offset});

final attemptsProvider = FutureProvider.family<ListAttemptsResponse, AttemptsQuery>(
  (ref, q) => ref
      .watch(experimentClientProvider)
      .listAttempts(
        ListAttemptsRequest(experimentId: q.id, status: q.status, pageSize: attemptsPageSize, offset: q.offset),
      ),
);

final algorithmsProvider = FutureProvider<ListAlgorithmsResponse>(
  (ref) => ref.watch(libraryClientProvider).listAlgorithms(ListAlgorithmsRequest()),
);

final lifecycleEventsProvider = FutureProvider.family<ListLifecycleEventsResponse, String>(
  (ref, versionId) =>
      ref.watch(libraryClientProvider).listLifecycleEvents(ListLifecycleEventsRequest(versionId: versionId)),
);

/// The version new experiments use: the newest one that is not retired.
AlgorithmVersion? usableVersion(Algorithm a) => a.versions.where((v) => v.state != 'retired').firstOrNull;
