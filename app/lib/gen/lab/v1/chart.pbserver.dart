// This is a generated file - do not edit.
//
// Generated from lab/v1/chart.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'chart.pb.dart' as $2;
import 'chart.pbjson.dart';

export 'chart.pb.dart';

abstract class ChartServiceBase extends $pb.GeneratedService {
  $async.Future<$2.GetChartResponse> getChart(
      $pb.ServerContext ctx, $2.GetChartRequest request);
  $async.Future<$2.GetDecisionResponse> getDecision(
      $pb.ServerContext ctx, $2.GetDecisionRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetChart':
        return $2.GetChartRequest();
      case 'GetDecision':
        return $2.GetDecisionRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetChart':
        return getChart(ctx, request as $2.GetChartRequest);
      case 'GetDecision':
        return getDecision(ctx, request as $2.GetDecisionRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ChartServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ChartServiceBase$messageJson;
}
