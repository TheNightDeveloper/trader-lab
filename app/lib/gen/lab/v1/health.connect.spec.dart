//
//  Generated code. Do not modify.
//  source: lab/v1/health.proto
//

import "package:connectrpc/connect.dart" as connect;
import "health.pb.dart" as labv1health;

/// HealthService feeds the sidebar status block.
abstract final class HealthService {
  /// Fully-qualified name of the HealthService service.
  static const name = 'lab.v1.HealthService';

  /// Sends the current status immediately, then on every change or heartbeat.
  static const watch = connect.Spec(
    '/$name/Watch',
    connect.StreamType.server,
    labv1health.WatchRequest.new,
    labv1health.WatchResponse.new,
  );
}
