// This is a generated file - do not edit.
//
// Generated from lab/v1/paper.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'paper.pb.dart' as $3;
import 'paper.pbjson.dart';

export 'paper.pb.dart';

abstract class PaperServiceBase extends $pb.GeneratedService {
  $async.Future<$3.GetPaperAccountResponse> getPaperAccount(
      $pb.ServerContext ctx, $3.GetPaperAccountRequest request);
  $async.Future<$3.InitializePaperAccountResponse> initializePaperAccount(
      $pb.ServerContext ctx, $3.InitializePaperAccountRequest request);
  $async.Future<$3.PreviewPaperPlanResponse> previewPaperPlan(
      $pb.ServerContext ctx, $3.PreviewPaperPlanRequest request);
  $async.Future<$3.GetPaperPlanResponse> getPaperPlan(
      $pb.ServerContext ctx, $3.GetPaperPlanRequest request);
  $async.Future<$3.ConfirmPaperPlanResponse> confirmPaperPlan(
      $pb.ServerContext ctx, $3.ConfirmPaperPlanRequest request);
  $async.Future<$3.GetPaperReceiptResponse> getPaperReceipt(
      $pb.ServerContext ctx, $3.GetPaperReceiptRequest request);
  $async.Future<$3.CancelPaperEntryResponse> cancelPaperEntry(
      $pb.ServerContext ctx, $3.CancelPaperEntryRequest request);
  $async.Future<$3.ReducePaperPositionResponse> reducePaperPosition(
      $pb.ServerContext ctx, $3.ReducePaperPositionRequest request);
  $async.Future<$3.SetPaperEntryPauseResponse> setPaperEntryPause(
      $pb.ServerContext ctx, $3.SetPaperEntryPauseRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetPaperAccount':
        return $3.GetPaperAccountRequest();
      case 'InitializePaperAccount':
        return $3.InitializePaperAccountRequest();
      case 'PreviewPaperPlan':
        return $3.PreviewPaperPlanRequest();
      case 'GetPaperPlan':
        return $3.GetPaperPlanRequest();
      case 'ConfirmPaperPlan':
        return $3.ConfirmPaperPlanRequest();
      case 'GetPaperReceipt':
        return $3.GetPaperReceiptRequest();
      case 'CancelPaperEntry':
        return $3.CancelPaperEntryRequest();
      case 'ReducePaperPosition':
        return $3.ReducePaperPositionRequest();
      case 'SetPaperEntryPause':
        return $3.SetPaperEntryPauseRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetPaperAccount':
        return getPaperAccount(ctx, request as $3.GetPaperAccountRequest);
      case 'InitializePaperAccount':
        return initializePaperAccount(
            ctx, request as $3.InitializePaperAccountRequest);
      case 'PreviewPaperPlan':
        return previewPaperPlan(ctx, request as $3.PreviewPaperPlanRequest);
      case 'GetPaperPlan':
        return getPaperPlan(ctx, request as $3.GetPaperPlanRequest);
      case 'ConfirmPaperPlan':
        return confirmPaperPlan(ctx, request as $3.ConfirmPaperPlanRequest);
      case 'GetPaperReceipt':
        return getPaperReceipt(ctx, request as $3.GetPaperReceiptRequest);
      case 'CancelPaperEntry':
        return cancelPaperEntry(ctx, request as $3.CancelPaperEntryRequest);
      case 'ReducePaperPosition':
        return reducePaperPosition(
            ctx, request as $3.ReducePaperPositionRequest);
      case 'SetPaperEntryPause':
        return setPaperEntryPause(ctx, request as $3.SetPaperEntryPauseRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PaperServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => PaperServiceBase$messageJson;
}
