// This is a generated file - do not edit.
//
// Generated from lab/v1/fx.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'fx.pb.dart' as $1;
import 'fx.pbjson.dart';

export 'fx.pb.dart';

abstract class FxServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ListRatesResponse> listRates($pb.ServerContext ctx, $1.ListRatesRequest request);
  $async.Future<$1.AddRateResponse> addRate($pb.ServerContext ctx, $1.AddRateRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListRates':
        return $1.ListRatesRequest();
      case 'AddRate':
        return $1.AddRateRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall(
      $pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListRates':
        return listRates(ctx, request as $1.ListRatesRequest);
      case 'AddRate':
        return addRate(ctx, request as $1.AddRateRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => FxServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => FxServiceBase$messageJson;
}
