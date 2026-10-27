// This is a generated file - do not edit.
//
// Generated from lab/v1/experiment.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'experiment.pb.dart' as $1;
import 'experiment.pbjson.dart';

export 'experiment.pb.dart';

abstract class ExperimentServiceBase extends $pb.GeneratedService {
  $async.Future<$1.EstimateResponse> estimate(
      $pb.ServerContext ctx, $1.EstimateRequest request);
  $async.Future<$1.CreateExperimentResponse> createExperiment(
      $pb.ServerContext ctx, $1.CreateExperimentRequest request);
  $async.Future<$1.ListExperimentsResponse> listExperiments(
      $pb.ServerContext ctx, $1.ListExperimentsRequest request);
  $async.Future<$1.GetExperimentResponse> getExperiment(
      $pb.ServerContext ctx, $1.GetExperimentRequest request);
  $async.Future<$1.WatchExperimentResponse> watchExperiment(
      $pb.ServerContext ctx, $1.WatchExperimentRequest request);
  $async.Future<$1.ListAttemptsResponse> listAttempts(
      $pb.ServerContext ctx, $1.ListAttemptsRequest request);
  $async.Future<$1.PauseExperimentResponse> pauseExperiment(
      $pb.ServerContext ctx, $1.PauseExperimentRequest request);
  $async.Future<$1.ResumeExperimentResponse> resumeExperiment(
      $pb.ServerContext ctx, $1.ResumeExperimentRequest request);
  $async.Future<$1.CancelExperimentResponse> cancelExperiment(
      $pb.ServerContext ctx, $1.CancelExperimentRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Estimate':
        return $1.EstimateRequest();
      case 'CreateExperiment':
        return $1.CreateExperimentRequest();
      case 'ListExperiments':
        return $1.ListExperimentsRequest();
      case 'GetExperiment':
        return $1.GetExperimentRequest();
      case 'WatchExperiment':
        return $1.WatchExperimentRequest();
      case 'ListAttempts':
        return $1.ListAttemptsRequest();
      case 'PauseExperiment':
        return $1.PauseExperimentRequest();
      case 'ResumeExperiment':
        return $1.ResumeExperimentRequest();
      case 'CancelExperiment':
        return $1.CancelExperimentRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Estimate':
        return estimate(ctx, request as $1.EstimateRequest);
      case 'CreateExperiment':
        return createExperiment(ctx, request as $1.CreateExperimentRequest);
      case 'ListExperiments':
        return listExperiments(ctx, request as $1.ListExperimentsRequest);
      case 'GetExperiment':
        return getExperiment(ctx, request as $1.GetExperimentRequest);
      case 'WatchExperiment':
        return watchExperiment(ctx, request as $1.WatchExperimentRequest);
      case 'ListAttempts':
        return listAttempts(ctx, request as $1.ListAttemptsRequest);
      case 'PauseExperiment':
        return pauseExperiment(ctx, request as $1.PauseExperimentRequest);
      case 'ResumeExperiment':
        return resumeExperiment(ctx, request as $1.ResumeExperimentRequest);
      case 'CancelExperiment':
        return cancelExperiment(ctx, request as $1.CancelExperimentRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      ExperimentServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ExperimentServiceBase$messageJson;
}
