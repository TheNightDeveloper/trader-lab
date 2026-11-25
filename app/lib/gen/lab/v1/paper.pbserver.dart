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

import 'paper.pb.dart' as $4;
import 'paper.pbjson.dart';

export 'paper.pb.dart';

abstract class PaperServiceBase extends $pb.GeneratedService {
  $async.Future<$4.GetPaperAccountResponse> getPaperAccount(
      $pb.ServerContext ctx, $4.GetPaperAccountRequest request);
  $async.Future<$4.InitializePaperAccountResponse> initializePaperAccount(
      $pb.ServerContext ctx, $4.InitializePaperAccountRequest request);
  $async.Future<$4.PreviewPaperPlanResponse> previewPaperPlan(
      $pb.ServerContext ctx, $4.PreviewPaperPlanRequest request);
  $async.Future<$4.GetPaperPlanResponse> getPaperPlan(
      $pb.ServerContext ctx, $4.GetPaperPlanRequest request);
  $async.Future<$4.ConfirmPaperPlanResponse> confirmPaperPlan(
      $pb.ServerContext ctx, $4.ConfirmPaperPlanRequest request);
  $async.Future<$4.GetPaperReceiptResponse> getPaperReceipt(
      $pb.ServerContext ctx, $4.GetPaperReceiptRequest request);
  $async.Future<$4.ListPaperJournalResponse> listPaperJournal(
      $pb.ServerContext ctx, $4.ListPaperJournalRequest request);
  $async.Future<$4.GetPaperReplayResponse> getPaperReplay(
      $pb.ServerContext ctx, $4.GetPaperReplayRequest request);
  $async.Future<$4.CancelPaperEntryResponse> cancelPaperEntry(
      $pb.ServerContext ctx, $4.CancelPaperEntryRequest request);
  $async.Future<$4.ReducePaperPositionResponse> reducePaperPosition(
      $pb.ServerContext ctx, $4.ReducePaperPositionRequest request);
  $async.Future<$4.SetPaperEntryPauseResponse> setPaperEntryPause(
      $pb.ServerContext ctx, $4.SetPaperEntryPauseRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetPaperAccount':
        return $4.GetPaperAccountRequest();
      case 'InitializePaperAccount':
        return $4.InitializePaperAccountRequest();
      case 'PreviewPaperPlan':
        return $4.PreviewPaperPlanRequest();
      case 'GetPaperPlan':
        return $4.GetPaperPlanRequest();
      case 'ConfirmPaperPlan':
        return $4.ConfirmPaperPlanRequest();
      case 'GetPaperReceipt':
        return $4.GetPaperReceiptRequest();
      case 'ListPaperJournal':
        return $4.ListPaperJournalRequest();
      case 'GetPaperReplay':
        return $4.GetPaperReplayRequest();
      case 'CancelPaperEntry':
        return $4.CancelPaperEntryRequest();
      case 'ReducePaperPosition':
        return $4.ReducePaperPositionRequest();
      case 'SetPaperEntryPause':
        return $4.SetPaperEntryPauseRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetPaperAccount':
        return getPaperAccount(ctx, request as $4.GetPaperAccountRequest);
      case 'InitializePaperAccount':
        return initializePaperAccount(
            ctx, request as $4.InitializePaperAccountRequest);
      case 'PreviewPaperPlan':
        return previewPaperPlan(ctx, request as $4.PreviewPaperPlanRequest);
      case 'GetPaperPlan':
        return getPaperPlan(ctx, request as $4.GetPaperPlanRequest);
      case 'ConfirmPaperPlan':
        return confirmPaperPlan(ctx, request as $4.ConfirmPaperPlanRequest);
      case 'GetPaperReceipt':
        return getPaperReceipt(ctx, request as $4.GetPaperReceiptRequest);
      case 'ListPaperJournal':
        return listPaperJournal(ctx, request as $4.ListPaperJournalRequest);
      case 'GetPaperReplay':
        return getPaperReplay(ctx, request as $4.GetPaperReplayRequest);
      case 'CancelPaperEntry':
        return cancelPaperEntry(ctx, request as $4.CancelPaperEntryRequest);
      case 'ReducePaperPosition':
        return reducePaperPosition(
            ctx, request as $4.ReducePaperPositionRequest);
      case 'SetPaperEntryPause':
        return setPaperEntryPause(ctx, request as $4.SetPaperEntryPauseRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PaperServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => PaperServiceBase$messageJson;
}
