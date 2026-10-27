//
//  Generated code. Do not modify.
//  source: lab/v1/health.proto
//

import "package:connectrpc/connect.dart" as connect;
import "health.pb.dart" as labv1health;
import "health.connect.spec.dart" as specs;

/// HealthService feeds the sidebar status block.
extension type HealthServiceClient(connect.Transport _transport) {
  /// Sends the current status immediately, then on every change or heartbeat.
  Stream<labv1health.WatchResponse> watch(
    labv1health.WatchRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.HealthService.watch,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
