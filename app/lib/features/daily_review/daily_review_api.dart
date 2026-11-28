import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/engine.dart';
import '../../gen/lab/v1/daily_review.connect.client.dart';
import '../../gen/lab/v1/daily_review.pb.dart';

final dailyReviewClientProvider = Provider(
  (ref) => DailyReviewServiceClient(ref.watch(transportProvider)),
);

final dailyReviewProvider = FutureProvider.autoDispose<GetDailyReviewResponse>((
  ref,
) {
  final signal = CancelableSignal();
  ref.onDispose(signal.cancel);
  return ref
      .watch(dailyReviewClientProvider)
      .getDailyReview(
        GetDailyReviewRequest(),
        signal: TimeoutSignal(const Duration(seconds: 10), parent: signal),
      );
}, retry: apiRetry);

final dailyReviewReminderProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  // Reuse the engine heartbeat for rollover and cross-tab acknowledgement.
  final bucket = ref.watch(
    engineStatusProvider.select((health) {
      final ms = health.value?.serverTimeUnixMs.toInt();
      return health.hasError || ms == null || ms <= 0 ? null : ms ~/ 30000;
    }),
  );
  if (bucket == null) return false;
  final signal = CancelableSignal();
  ref.onDispose(signal.cancel);
  final response = await ref
      .watch(dailyReviewClientProvider)
      .getDailyReviewStatus(
        GetDailyReviewStatusRequest(),
        signal: TimeoutSignal(const Duration(seconds: 5), parent: signal),
      );
  return response.status.reminderEnabled && !response.status.reviewedToday;
}, retry: (_, _) => null);
