//
//  Generated code. Do not modify.
//  source: lab/v1/shadow.proto
//

import "package:connectrpc/connect.dart" as connect;
import "shadow.pb.dart" as labv1shadow;

abstract final class ShadowService {
  /// Fully-qualified name of the ShadowService service.
  static const name = 'lab.v1.ShadowService';

  static const startShadowDeployment = connect.Spec(
    '/$name/StartShadowDeployment',
    connect.StreamType.unary,
    labv1shadow.StartShadowDeploymentRequest.new,
    labv1shadow.StartShadowDeploymentResponse.new,
  );

  static const stopShadowDeployment = connect.Spec(
    '/$name/StopShadowDeployment',
    connect.StreamType.unary,
    labv1shadow.StopShadowDeploymentRequest.new,
    labv1shadow.StopShadowDeploymentResponse.new,
  );

  static const getShadowSnapshot = connect.Spec(
    '/$name/GetShadowSnapshot',
    connect.StreamType.unary,
    labv1shadow.GetShadowSnapshotRequest.new,
    labv1shadow.GetShadowSnapshotResponse.new,
  );

  /// Record one immutable decision while the observed signal's cutoff is still open.
  static const setShadowUserDecision = connect.Spec(
    '/$name/SetShadowUserDecision',
    connect.StreamType.unary,
    labv1shadow.SetShadowUserDecisionRequest.new,
    labv1shadow.SetShadowUserDecisionResponse.new,
  );
}
