// This is a generated file - do not edit.
//
// Generated from lab/v1/market.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'market.pb.dart' as $3;
import 'market.pbjson.dart';

export 'market.pb.dart';

abstract class MarketServiceBase extends $pb.GeneratedService {
  $async.Future<$3.GetMarketSnapshotResponse> getMarketSnapshot(
      $pb.ServerContext ctx, $3.GetMarketSnapshotRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetMarketSnapshot':
        return $3.GetMarketSnapshotRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetMarketSnapshot':
        return getMarketSnapshot(ctx, request as $3.GetMarketSnapshotRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => MarketServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => MarketServiceBase$messageJson;
}
