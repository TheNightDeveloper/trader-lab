import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../gen/lab/v1/health.connect.client.dart';
import '../../gen/lab/v1/health.pb.dart';
import 'http_client_io.dart' if (dart.library.js_interop) 'http_client_web.dart';

/// Engine origin. Same origin when the engine serves the app (`make run`);
/// `flutter run --dart-define=ENGINE_URL=http://127.0.0.1:8080` in development.
String engineBaseUrl() {
  const fromEnv = String.fromEnvironment('ENGINE_URL');
  return fromEnv.isNotEmpty ? fromEnv : Uri.base.origin;
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

/// 250 ms, 500 ms, 1 s, 2 s, then every 4 s.
Duration reconnectForever(int retryCount, Object _) =>
    Duration(milliseconds: 250 * (1 << (retryCount < 4 ? retryCount : 4)));
