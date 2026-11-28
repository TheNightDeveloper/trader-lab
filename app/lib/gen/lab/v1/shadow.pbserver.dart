// This is a generated file - do not edit.
//
// Generated from lab/v1/shadow.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'shadow.pb.dart' as $1;
import 'shadow.pbjson.dart';

export 'shadow.pb.dart';

abstract class ShadowServiceBase extends $pb.GeneratedService {
  $async.Future<$1.StartShadowDeploymentResponse> startShadowDeployment(
      $pb.ServerContext ctx, $1.StartShadowDeploymentRequest request);
  $async.Future<$1.StopShadowDeploymentResponse> stopShadowDeployment(
      $pb.ServerContext ctx, $1.StopShadowDeploymentRequest request);
  $async.Future<$1.GetShadowSnapshotResponse> getShadowSnapshot(
      $pb.ServerContext ctx, $1.GetShadowSnapshotRequest request);
  $async.Future<$1.SetShadowUserDecisionResponse> setShadowUserDecision(
      $pb.ServerContext ctx, $1.SetShadowUserDecisionRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'StartShadowDeployment':
        return $1.StartShadowDeploymentRequest();
      case 'StopShadowDeployment':
        return $1.StopShadowDeploymentRequest();
      case 'GetShadowSnapshot':
        return $1.GetShadowSnapshotRequest();
      case 'SetShadowUserDecision':
        return $1.SetShadowUserDecisionRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'StartShadowDeployment':
        return startShadowDeployment(
            ctx, request as $1.StartShadowDeploymentRequest);
      case 'StopShadowDeployment':
        return stopShadowDeployment(
            ctx, request as $1.StopShadowDeploymentRequest);
      case 'GetShadowSnapshot':
        return getShadowSnapshot(ctx, request as $1.GetShadowSnapshotRequest);
      case 'SetShadowUserDecision':
        return setShadowUserDecision(
            ctx, request as $1.SetShadowUserDecisionRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ShadowServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ShadowServiceBase$messageJson;
}
