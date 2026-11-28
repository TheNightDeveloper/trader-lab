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

import 'report.pb.dart' as $2;
import 'report.pbjson.dart';

export 'report.pb.dart';

abstract class ReportServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ListStrategiesResponse> listStrategies(
      $pb.ServerContext ctx, $2.ListStrategiesRequest request);
  $async.Future<$2.CreateReportResponse> createReport(
      $pb.ServerContext ctx, $2.CreateReportRequest request);
  $async.Future<$2.ListReportsResponse> listReports(
      $pb.ServerContext ctx, $2.ListReportsRequest request);
  $async.Future<$2.GetReportResponse> getReport(
      $pb.ServerContext ctx, $2.GetReportRequest request);
  $async.Future<$2.ViewHoldoutResponse> viewHoldout(
      $pb.ServerContext ctx, $2.ViewHoldoutRequest request);
  $async.Future<$2.ListTradesResponse> listTrades(
      $pb.ServerContext ctx, $2.ListTradesRequest request);
  $async.Future<$2.ListDecisionsResponse> listDecisions(
      $pb.ServerContext ctx, $2.ListDecisionsRequest request);
  $async.Future<$2.CompareResponse> compare(
      $pb.ServerContext ctx, $2.CompareRequest request);
  $async.Future<$2.ExportResponse> export(
      $pb.ServerContext ctx, $2.ExportRequest request);
  $async.Future<$2.ReproduceResponse> reproduce(
      $pb.ServerContext ctx, $2.ReproduceRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListStrategies':
        return $2.ListStrategiesRequest();
      case 'CreateReport':
        return $2.CreateReportRequest();
      case 'ListReports':
        return $2.ListReportsRequest();
      case 'GetReport':
        return $2.GetReportRequest();
      case 'ViewHoldout':
        return $2.ViewHoldoutRequest();
      case 'ListTrades':
        return $2.ListTradesRequest();
      case 'ListDecisions':
        return $2.ListDecisionsRequest();
      case 'Compare':
        return $2.CompareRequest();
      case 'Export':
        return $2.ExportRequest();
      case 'Reproduce':
        return $2.ReproduceRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListStrategies':
        return listStrategies(ctx, request as $2.ListStrategiesRequest);
      case 'CreateReport':
        return createReport(ctx, request as $2.CreateReportRequest);
      case 'ListReports':
        return listReports(ctx, request as $2.ListReportsRequest);
      case 'GetReport':
        return getReport(ctx, request as $2.GetReportRequest);
      case 'ViewHoldout':
        return viewHoldout(ctx, request as $2.ViewHoldoutRequest);
      case 'ListTrades':
        return listTrades(ctx, request as $2.ListTradesRequest);
      case 'ListDecisions':
        return listDecisions(ctx, request as $2.ListDecisionsRequest);
      case 'Compare':
        return compare(ctx, request as $2.CompareRequest);
      case 'Export':
        return export(ctx, request as $2.ExportRequest);
      case 'Reproduce':
        return reproduce(ctx, request as $2.ReproduceRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ReportServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ReportServiceBase$messageJson;
}
