// This is a generated file - do not edit.
//
// Generated from lab/v1/data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data.pb.dart' as $0;
import 'data.pbjson.dart';

export 'data.pb.dart';

abstract class DataServiceBase extends $pb.GeneratedService {
  $async.Future<$0.GetOverviewResponse> getOverview(
      $pb.ServerContext ctx, $0.GetOverviewRequest request);
  $async.Future<$0.ListDatasetsResponse> listDatasets(
      $pb.ServerContext ctx, $0.ListDatasetsRequest request);
  $async.Future<$0.GetCoverageResponse> getCoverage(
      $pb.ServerContext ctx, $0.GetCoverageRequest request);
  $async.Future<$0.ListQualityIssuesResponse> listQualityIssues(
      $pb.ServerContext ctx, $0.ListQualityIssuesRequest request);
  $async.Future<$0.ImportResponse> import(
      $pb.ServerContext ctx, $0.ImportRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetOverview':
        return $0.GetOverviewRequest();
      case 'ListDatasets':
        return $0.ListDatasetsRequest();
      case 'GetCoverage':
        return $0.GetCoverageRequest();
      case 'ListQualityIssues':
        return $0.ListQualityIssuesRequest();
      case 'Import':
        return $0.ImportRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetOverview':
        return getOverview(ctx, request as $0.GetOverviewRequest);
      case 'ListDatasets':
        return listDatasets(ctx, request as $0.ListDatasetsRequest);
      case 'GetCoverage':
        return getCoverage(ctx, request as $0.GetCoverageRequest);
      case 'ListQualityIssues':
        return listQualityIssues(ctx, request as $0.ListQualityIssuesRequest);
      case 'Import':
        return import(ctx, request as $0.ImportRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => DataServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => DataServiceBase$messageJson;
}
