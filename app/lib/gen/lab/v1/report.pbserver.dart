// This is a generated file - do not edit.
//
// Generated from lab/v1/report.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'report.pb.dart' as $1;
import 'report.pbjson.dart';

export 'report.pb.dart';

abstract class ReportServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ListStrategiesResponse> listStrategies(
      $pb.ServerContext ctx, $1.ListStrategiesRequest request);
  $async.Future<$1.CreateReportResponse> createReport(
      $pb.ServerContext ctx, $1.CreateReportRequest request);
  $async.Future<$1.ListReportsResponse> listReports(
      $pb.ServerContext ctx, $1.ListReportsRequest request);
  $async.Future<$1.GetReportResponse> getReport(
      $pb.ServerContext ctx, $1.GetReportRequest request);
  $async.Future<$1.ViewHoldoutResponse> viewHoldout(
      $pb.ServerContext ctx, $1.ViewHoldoutRequest request);
  $async.Future<$1.ListTradesResponse> listTrades(
      $pb.ServerContext ctx, $1.ListTradesRequest request);
  $async.Future<$1.ListDecisionsResponse> listDecisions(
      $pb.ServerContext ctx, $1.ListDecisionsRequest request);
  $async.Future<$1.CompareResponse> compare(
      $pb.ServerContext ctx, $1.CompareRequest request);
  $async.Future<$1.ExportResponse> export(
      $pb.ServerContext ctx, $1.ExportRequest request);
  $async.Future<$1.ReproduceResponse> reproduce(
      $pb.ServerContext ctx, $1.ReproduceRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListStrategies':
        return $1.ListStrategiesRequest();
      case 'CreateReport':
        return $1.CreateReportRequest();
      case 'ListReports':
        return $1.ListReportsRequest();
      case 'GetReport':
        return $1.GetReportRequest();
      case 'ViewHoldout':
        return $1.ViewHoldoutRequest();
      case 'ListTrades':
        return $1.ListTradesRequest();
      case 'ListDecisions':
        return $1.ListDecisionsRequest();
      case 'Compare':
        return $1.CompareRequest();
      case 'Export':
        return $1.ExportRequest();
      case 'Reproduce':
        return $1.ReproduceRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListStrategies':
        return listStrategies(ctx, request as $1.ListStrategiesRequest);
      case 'CreateReport':
        return createReport(ctx, request as $1.CreateReportRequest);
      case 'ListReports':
        return listReports(ctx, request as $1.ListReportsRequest);
      case 'GetReport':
        return getReport(ctx, request as $1.GetReportRequest);
      case 'ViewHoldout':
        return viewHoldout(ctx, request as $1.ViewHoldoutRequest);
      case 'ListTrades':
        return listTrades(ctx, request as $1.ListTradesRequest);
      case 'ListDecisions':
        return listDecisions(ctx, request as $1.ListDecisionsRequest);
      case 'Compare':
        return compare(ctx, request as $1.CompareRequest);
      case 'Export':
        return export(ctx, request as $1.ExportRequest);
      case 'Reproduce':
        return reproduce(ctx, request as $1.ReproduceRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ReportServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ReportServiceBase$messageJson;
}
