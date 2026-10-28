// This is a generated file - do not edit.
//
// Generated from lab/v1/learning.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'learning.pb.dart' as $1;
import 'learning.pbjson.dart';

export 'learning.pb.dart';

abstract class LearningServiceBase extends $pb.GeneratedService {
  $async.Future<$1.GetLearningResponse> getLearning(
      $pb.ServerContext ctx, $1.GetLearningRequest request);
  $async.Future<$1.SaveConfigResponse> saveConfig(
      $pb.ServerContext ctx, $1.SaveConfigRequest request);
  $async.Future<$1.StartCycleResponse> startCycle(
      $pb.ServerContext ctx, $1.StartCycleRequest request);
  $async.Future<$1.ListCyclesResponse> listCycles(
      $pb.ServerContext ctx, $1.ListCyclesRequest request);
  $async.Future<$1.ListCandidatesResponse> listCandidates(
      $pb.ServerContext ctx, $1.ListCandidatesRequest request);
  $async.Future<$1.ListModelsResponse> listModels(
      $pb.ServerContext ctx, $1.ListModelsRequest request);
  $async.Future<$1.ApproveCycleResponse> approveCycle(
      $pb.ServerContext ctx, $1.ApproveCycleRequest request);
  $async.Future<$1.RejectCycleResponse> rejectCycle(
      $pb.ServerContext ctx, $1.RejectCycleRequest request);
  $async.Future<$1.RollbackResponse> rollback(
      $pb.ServerContext ctx, $1.RollbackRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetLearning':
        return $1.GetLearningRequest();
      case 'SaveConfig':
        return $1.SaveConfigRequest();
      case 'StartCycle':
        return $1.StartCycleRequest();
      case 'ListCycles':
        return $1.ListCyclesRequest();
      case 'ListCandidates':
        return $1.ListCandidatesRequest();
      case 'ListModels':
        return $1.ListModelsRequest();
      case 'ApproveCycle':
        return $1.ApproveCycleRequest();
      case 'RejectCycle':
        return $1.RejectCycleRequest();
      case 'Rollback':
        return $1.RollbackRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetLearning':
        return getLearning(ctx, request as $1.GetLearningRequest);
      case 'SaveConfig':
        return saveConfig(ctx, request as $1.SaveConfigRequest);
      case 'StartCycle':
        return startCycle(ctx, request as $1.StartCycleRequest);
      case 'ListCycles':
        return listCycles(ctx, request as $1.ListCyclesRequest);
      case 'ListCandidates':
        return listCandidates(ctx, request as $1.ListCandidatesRequest);
      case 'ListModels':
        return listModels(ctx, request as $1.ListModelsRequest);
      case 'ApproveCycle':
        return approveCycle(ctx, request as $1.ApproveCycleRequest);
      case 'RejectCycle':
        return rejectCycle(ctx, request as $1.RejectCycleRequest);
      case 'Rollback':
        return rollback(ctx, request as $1.RollbackRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LearningServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => LearningServiceBase$messageJson;
}
