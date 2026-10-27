//
//  Generated code. Do not modify.
//  source: lab/v1/experiment.proto
//

import "package:connectrpc/connect.dart" as connect;
import "experiment.pb.dart" as labv1experiment;

/// ExperimentService: pre-registered experiments, the attempt registry and the
/// research queue. Every attempt is recorded, failed and cancelled ones too.
abstract final class ExperimentService {
  /// Fully-qualified name of the ExperimentService service.
  static const name = 'lab.v1.ExperimentService';

  /// Validates a definition and counts its attempts without starting anything.
  static const estimate = connect.Spec(
    '/$name/Estimate',
    connect.StreamType.unary,
    labv1experiment.EstimateRequest.new,
    labv1experiment.EstimateResponse.new,
  );

  /// Locks the definition and queues every attempt.
  static const createExperiment = connect.Spec(
    '/$name/CreateExperiment',
    connect.StreamType.unary,
    labv1experiment.CreateExperimentRequest.new,
    labv1experiment.CreateExperimentResponse.new,
  );

  static const listExperiments = connect.Spec(
    '/$name/ListExperiments',
    connect.StreamType.unary,
    labv1experiment.ListExperimentsRequest.new,
    labv1experiment.ListExperimentsResponse.new,
  );

  static const getExperiment = connect.Spec(
    '/$name/GetExperiment',
    connect.StreamType.unary,
    labv1experiment.GetExperimentRequest.new,
    labv1experiment.GetExperimentResponse.new,
  );

  /// Progress now, then every second until the experiment ends.
  static const watchExperiment = connect.Spec(
    '/$name/WatchExperiment',
    connect.StreamType.server,
    labv1experiment.WatchExperimentRequest.new,
    labv1experiment.WatchExperimentResponse.new,
  );

  static const listAttempts = connect.Spec(
    '/$name/ListAttempts',
    connect.StreamType.unary,
    labv1experiment.ListAttemptsRequest.new,
    labv1experiment.ListAttemptsResponse.new,
  );

  static const pauseExperiment = connect.Spec(
    '/$name/PauseExperiment',
    connect.StreamType.unary,
    labv1experiment.PauseExperimentRequest.new,
    labv1experiment.PauseExperimentResponse.new,
  );

  static const resumeExperiment = connect.Spec(
    '/$name/ResumeExperiment',
    connect.StreamType.unary,
    labv1experiment.ResumeExperimentRequest.new,
    labv1experiment.ResumeExperimentResponse.new,
  );

  static const cancelExperiment = connect.Spec(
    '/$name/CancelExperiment',
    connect.StreamType.unary,
    labv1experiment.CancelExperimentRequest.new,
    labv1experiment.CancelExperimentResponse.new,
  );
}
