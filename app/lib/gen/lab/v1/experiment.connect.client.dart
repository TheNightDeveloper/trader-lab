//
//  Generated code. Do not modify.
//  source: lab/v1/experiment.proto
//

import "package:connectrpc/connect.dart" as connect;
import "experiment.pb.dart" as labv1experiment;
import "experiment.connect.spec.dart" as specs;

/// ExperimentService: pre-registered experiments, the attempt registry and the
/// research queue. Every attempt is recorded, failed and cancelled ones too.
extension type ExperimentServiceClient (connect.Transport _transport) {
  /// Validates a definition and counts its attempts without starting anything.
  Future<labv1experiment.EstimateResponse> estimate(
    labv1experiment.EstimateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExperimentService.estimate,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Locks the definition and queues every attempt.
  Future<labv1experiment.CreateExperimentResponse> createExperiment(
    labv1experiment.CreateExperimentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExperimentService.createExperiment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1experiment.ListExperimentsResponse> listExperiments(
    labv1experiment.ListExperimentsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExperimentService.listExperiments,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1experiment.GetExperimentResponse> getExperiment(
    labv1experiment.GetExperimentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExperimentService.getExperiment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Progress now, then every second until the experiment ends.
  Stream<labv1experiment.WatchExperimentResponse> watchExperiment(
    labv1experiment.WatchExperimentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.ExperimentService.watchExperiment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1experiment.ListAttemptsResponse> listAttempts(
    labv1experiment.ListAttemptsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExperimentService.listAttempts,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1experiment.PauseExperimentResponse> pauseExperiment(
    labv1experiment.PauseExperimentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExperimentService.pauseExperiment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1experiment.ResumeExperimentResponse> resumeExperiment(
    labv1experiment.ResumeExperimentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExperimentService.resumeExperiment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1experiment.CancelExperimentResponse> cancelExperiment(
    labv1experiment.CancelExperimentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExperimentService.cancelExperiment,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
