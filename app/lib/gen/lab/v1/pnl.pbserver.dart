// This is a generated file - do not edit.
//
// Generated from lab/v1/pnl.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'pnl.pb.dart' as $2;
import 'pnl.pbjson.dart';

export 'pnl.pb.dart';

abstract class PnlServiceBase extends $pb.GeneratedService {
  $async.Future<$2.RecalculateResponse> recalculate(
      $pb.ServerContext ctx, $2.RecalculateRequest request);
  $async.Future<$2.CalculateTradeResponse> calculateTrade(
      $pb.ServerContext ctx, $2.CalculateTradeRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Recalculate':
        return $2.RecalculateRequest();
      case 'CalculateTrade':
        return $2.CalculateTradeRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Recalculate':
        return recalculate(ctx, request as $2.RecalculateRequest);
      case 'CalculateTrade':
        return calculateTrade(ctx, request as $2.CalculateTradeRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PnlServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => PnlServiceBase$messageJson;
}
