//
//  Generated code. Do not modify.
//  source: lab/v1/shadow.proto
//

import "package:connectrpc/connect.dart" as connect;
import "shadow.pb.dart" as labv1shadow;
import "shadow.connect.spec.dart" as specs;

extension type ShadowServiceClient (connect.Transport _transport) {
  Future<labv1shadow.StartShadowDeploymentResponse> startShadowDeployment(
    labv1shadow.StartShadowDeploymentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ShadowService.startShadowDeployment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1shadow.StopShadowDeploymentResponse> stopShadowDeployment(
    labv1shadow.StopShadowDeploymentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ShadowService.stopShadowDeployment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1shadow.GetShadowSnapshotResponse> getShadowSnapshot(
    labv1shadow.GetShadowSnapshotRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ShadowService.getShadowSnapshot,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Record one immutable decision while the observed signal's cutoff is still open.
  Future<labv1shadow.SetShadowUserDecisionResponse> setShadowUserDecision(
    labv1shadow.SetShadowUserDecisionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ShadowService.setShadowUserDecision,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
