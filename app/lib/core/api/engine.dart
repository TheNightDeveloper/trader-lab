import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../gen/lab/v1/data.connect.client.dart';
import '../../gen/lab/v1/experiment.connect.client.dart';
import '../../gen/lab/v1/fx.connect.client.dart';
import '../../gen/lab/v1/health.connect.client.dart';
import '../../gen/lab/v1/library.connect.client.dart';
import '../../gen/lab/v1/pnl.connect.client.dart';
import '../../gen/lab/v1/report.connect.client.dart';
import '../../gen/lab/v1/health.pb.dart';
import 'http_client_io.dart' if (dart.library.js_interop) 'http_client_web.dart';

/// Engine origin. `--dart-define=ENGINE_URL=…` wins. A release build is served by
/// the engine itself (`make run`), so it uses the page's origin; a debug build runs
/// on Flutter's dev server (random port, 404 for API paths), so it calls the engine
/// on its default address. The engine allows CORS from loopback origins.
String engineBaseUrl() {
  const fromEnv = String.fromEnvironment('ENGINE_URL');
  if (fromEnv.isNotEmpty) return fromEnv;
  return kReleaseMode ? Uri.base.origin : 'http://127.0.0.1:8080';
}

final transportProvider = Provider<connect.Transport>(
  (ref) => protocol.Transport(baseUrl: engineBaseUrl(), codec: const ProtoCodec(), httpClient: platformHttpClient()),
);

/// Live engine status for the sidebar. When the stream fails or ends, the provider
/// errors (keeping the last value for the stale banner) and [reconnectForever]
/// reconnects. Riverpod's default retry gives up after 10 tries; the engine may be
/// down far longer than that.
final engineStatusProvider = StreamProvider<EngineStatus>((ref) async* {
  final client = HealthServiceClient(ref.watch(transportProvider));
  await for (final r in client.watch(WatchRequest())) {
    yield r.status;
  }
  throw const EngineDisconnected();
}, retry: reconnectForever);

class EngineDisconnected implements Exception {
  const EngineDisconnected();
  @override
  String toString() => 'health stream closed by engine';
}

/// App-wide retry for one-shot API calls: two quick retries, then show the error
/// with a retry button (Riverpod's default keeps retrying ~30 s while the screen
/// shows a skeleton). Streams like [engineStatusProvider] set their own.
Duration? apiRetry(int retryCount, Object _) => retryCount < 2 ? Duration(milliseconds: 300 * (retryCount + 1)) : null;

/// 250 ms, 500 ms, 1 s, 2 s, then every 4 s.
Duration reconnectForever(int retryCount, Object _) =>
    Duration(milliseconds: 250 * (1 << (retryCount < 4 ? retryCount : 4)));

final dataClientProvider = Provider((ref) => DataServiceClient(ref.watch(transportProvider)));
final fxClientProvider = Provider((ref) => FxServiceClient(ref.watch(transportProvider)));
final reportClientProvider = Provider((ref) => ReportServiceClient(ref.watch(transportProvider)));
final pnlClientProvider = Provider((ref) => PnlServiceClient(ref.watch(transportProvider)));
final experimentClientProvider = Provider((ref) => ExperimentServiceClient(ref.watch(transportProvider)));
final libraryClientProvider = Provider((ref) => LibraryServiceClient(ref.watch(transportProvider)));

/// The latest USDT/TOMAN display rate id from the health stream (0 = none).
final displayRateIdProvider = Provider<int>((ref) {
  final r = ref.watch(engineStatusProvider.select((s) => s.value?.displayRate));
  return r == null || r.rateId.isEmpty ? 0 : int.parse(r.rateId);
});
