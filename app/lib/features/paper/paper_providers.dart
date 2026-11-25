import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/engine.dart';
import '../../gen/lab/v1/paper.connect.client.dart';
import '../../gen/lab/v1/paper.pb.dart';

final paperClientProvider = Provider((ref) => PaperServiceClient(ref.watch(transportProvider)));

final paperAccountProvider = StreamProvider.autoDispose<GetPaperAccountResponse>((ref) {
  final client = ref.watch(paperClientProvider);
  return _pollPaper(ref, (signal) => client.getPaperAccount(GetPaperAccountRequest(), signal: signal));
}, retry: reconnectForever);

final paperPlanProvider = StreamProvider.autoDispose.family<GetPaperPlanResponse, String>((ref, hash) {
  final client = ref.watch(paperClientProvider);
  return _pollPaper(ref, (signal) => client.getPaperPlan(GetPaperPlanRequest(planHash: hash), signal: signal));
}, retry: reconnectForever);

// The chart is an immutable read, so plan status polling only refreshes restrictions and receipts.
final paperPlanContextProvider = FutureProvider.autoDispose.family<GetPaperPlanContextResponse, String>((ref, hash) {
  final signal = CancelableSignal();
  ref.onDispose(signal.cancel);
  return ref
      .watch(paperClientProvider)
      .getPaperPlanContext(
        GetPaperPlanContextRequest(planHash: hash),
        signal: TimeoutSignal(const Duration(seconds: 5), parent: signal),
      );
}, retry: apiRetry);

final paperReceiptProvider = StreamProvider.autoDispose.family<GetPaperReceiptResponse, Int64>((ref, id) {
  final client = ref.watch(paperClientProvider);
  return _pollPaper(ref, (signal) => client.getPaperReceipt(GetPaperReceiptRequest(receiptId: id), signal: signal));
}, retry: reconnectForever);

final paperJournalProvider = StreamProvider.autoDispose.family<ListPaperJournalResponse, Int64>((ref, before) {
  final client = ref.watch(paperClientProvider);
  return _pollPaper(
    ref,
    (signal) => client.listPaperJournal(ListPaperJournalRequest(beforeReceiptId: before), signal: signal),
  );
}, retry: reconnectForever);

final paperReplayProvider = StreamProvider.autoDispose.family<GetPaperReplayResponse, (Int64, Int64)>((ref, key) {
  final (id, cursor) = key;
  final client = ref.watch(paperClientProvider);
  return _pollPaper(
    ref,
    (signal) => client.getPaperReplay(
      GetPaperReplayRequest(receiptId: id, cursor: cursor),
      signal: signal,
    ),
  );
}, retry: reconnectForever);

/// Revalidation is server-owned. Keep the last complete view if a poll fails.
Stream<T> _pollPaper<T>(Ref ref, Future<T> Function(AbortSignal) read) async* {
  final signal = CancelableSignal();
  ref.onDispose(signal.cancel);
  const interval = Duration(seconds: 5);
  while (ref.mounted) {
    yield await read(TimeoutSignal(interval, parent: signal));
    await Future<void>.delayed(interval);
  }
}
