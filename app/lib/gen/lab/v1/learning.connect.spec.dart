//
//  Generated code. Do not modify.
//  source: lab/v1/learning.proto
//

import "package:connectrpc/connect.dart" as connect;
import "learning.pb.dart" as labv1learning;

/// LearningService: learning cycles, their gate, the model registry and the
/// user's promotion decisions. The loop recommends; only ApproveCycle and
/// Rollback (user actions) change the active version and model.
abstract final class LearningService {
  /// Fully-qualified name of the LearningService service.
  static const name = 'lab.v1.LearningService';

  static const getLearning = connect.Spec(
    '/$name/GetLearning',
    connect.StreamType.unary,
    labv1learning.GetLearningRequest.new,
    labv1learning.GetLearningResponse.new,
  );

  static const saveConfig = connect.Spec(
    '/$name/SaveConfig',
    connect.StreamType.unary,
    labv1learning.SaveConfigRequest.new,
    labv1learning.SaveConfigResponse.new,
  );

  static const startCycle = connect.Spec(
    '/$name/StartCycle',
    connect.StreamType.unary,
    labv1learning.StartCycleRequest.new,
    labv1learning.StartCycleResponse.new,
  );

  static const listCycles = connect.Spec(
    '/$name/ListCycles',
    connect.StreamType.unary,
    labv1learning.ListCyclesRequest.new,
    labv1learning.ListCyclesResponse.new,
  );

  static const listCandidates = connect.Spec(
    '/$name/ListCandidates',
    connect.StreamType.unary,
    labv1learning.ListCandidatesRequest.new,
    labv1learning.ListCandidatesResponse.new,
  );

  static const listModels = connect.Spec(
    '/$name/ListModels',
    connect.StreamType.unary,
    labv1learning.ListModelsRequest.new,
    labv1learning.ListModelsResponse.new,
  );

  static const approveCycle = connect.Spec(
    '/$name/ApproveCycle',
    connect.StreamType.unary,
    labv1learning.ApproveCycleRequest.new,
    labv1learning.ApproveCycleResponse.new,
  );

  static const rejectCycle = connect.Spec(
    '/$name/RejectCycle',
    connect.StreamType.unary,
    labv1learning.RejectCycleRequest.new,
    labv1learning.RejectCycleResponse.new,
  );

  static const rollback = connect.Spec(
    '/$name/Rollback',
    connect.StreamType.unary,
    labv1learning.RollbackRequest.new,
    labv1learning.RollbackResponse.new,
  );
}
