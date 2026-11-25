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

import 'paper.pb.dart' as $5;
import 'paper.pbjson.dart';

export 'paper.pb.dart';

abstract class PaperServiceBase extends $pb.GeneratedService {
  $async.Future<$5.GetPaperAccountResponse> getPaperAccount(
      $pb.ServerContext ctx, $5.GetPaperAccountRequest request);
  $async.Future<$5.InitializePaperAccountResponse> initializePaperAccount(
      $pb.ServerContext ctx, $5.InitializePaperAccountRequest request);
  $async.Future<$5.PreviewPaperPlanResponse> previewPaperPlan(
      $pb.ServerContext ctx, $5.PreviewPaperPlanRequest request);
  $async.Future<$5.GetPaperPlanResponse> getPaperPlan(
      $pb.ServerContext ctx, $5.GetPaperPlanRequest request);
  $async.Future<$5.GetPaperPlanContextResponse> getPaperPlanContext(
      $pb.ServerContext ctx, $5.GetPaperPlanContextRequest request);
  $async.Future<$5.ConfirmPaperPlanResponse> confirmPaperPlan(
      $pb.ServerContext ctx, $5.ConfirmPaperPlanRequest request);
  $async.Future<$5.GetPaperReceiptResponse> getPaperReceipt(
      $pb.ServerContext ctx, $5.GetPaperReceiptRequest request);
  $async.Future<$5.ListPaperJournalResponse> listPaperJournal(
      $pb.ServerContext ctx, $5.ListPaperJournalRequest request);
  $async.Future<$5.GetPaperReplayResponse> getPaperReplay(
      $pb.ServerContext ctx, $5.GetPaperReplayRequest request);
  $async.Future<$5.SavePaperJournalNoteResponse> savePaperJournalNote(
      $pb.ServerContext ctx, $5.SavePaperJournalNoteRequest request);
  $async.Future<$5.CancelPaperEntryResponse> cancelPaperEntry(
      $pb.ServerContext ctx, $5.CancelPaperEntryRequest request);
  $async.Future<$5.ReducePaperPositionResponse> reducePaperPosition(
      $pb.ServerContext ctx, $5.ReducePaperPositionRequest request);
  $async.Future<$5.SetPaperEntryPauseResponse> setPaperEntryPause(
      $pb.ServerContext ctx, $5.SetPaperEntryPauseRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetPaperAccount':
        return $5.GetPaperAccountRequest();
      case 'InitializePaperAccount':
        return $5.InitializePaperAccountRequest();
      case 'PreviewPaperPlan':
        return $5.PreviewPaperPlanRequest();
      case 'GetPaperPlan':
        return $5.GetPaperPlanRequest();
      case 'GetPaperPlanContext':
        return $5.GetPaperPlanContextRequest();
      case 'ConfirmPaperPlan':
        return $5.ConfirmPaperPlanRequest();
      case 'GetPaperReceipt':
        return $5.GetPaperReceiptRequest();
      case 'ListPaperJournal':
        return $5.ListPaperJournalRequest();
      case 'GetPaperReplay':
        return $5.GetPaperReplayRequest();
      case 'SavePaperJournalNote':
        return $5.SavePaperJournalNoteRequest();
      case 'CancelPaperEntry':
        return $5.CancelPaperEntryRequest();
      case 'ReducePaperPosition':
        return $5.ReducePaperPositionRequest();
      case 'SetPaperEntryPause':
        return $5.SetPaperEntryPauseRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetPaperAccount':
        return getPaperAccount(ctx, request as $5.GetPaperAccountRequest);
      case 'InitializePaperAccount':
        return initializePaperAccount(
            ctx, request as $5.InitializePaperAccountRequest);
      case 'PreviewPaperPlan':
        return previewPaperPlan(ctx, request as $5.PreviewPaperPlanRequest);
      case 'GetPaperPlan':
        return getPaperPlan(ctx, request as $5.GetPaperPlanRequest);
      case 'GetPaperPlanContext':
        return getPaperPlanContext(
            ctx, request as $5.GetPaperPlanContextRequest);
      case 'ConfirmPaperPlan':
        return confirmPaperPlan(ctx, request as $5.ConfirmPaperPlanRequest);
      case 'GetPaperReceipt':
        return getPaperReceipt(ctx, request as $5.GetPaperReceiptRequest);
      case 'ListPaperJournal':
        return listPaperJournal(ctx, request as $5.ListPaperJournalRequest);
      case 'GetPaperReplay':
        return getPaperReplay(ctx, request as $5.GetPaperReplayRequest);
      case 'SavePaperJournalNote':
        return savePaperJournalNote(
            ctx, request as $5.SavePaperJournalNoteRequest);
      case 'CancelPaperEntry':
        return cancelPaperEntry(ctx, request as $5.CancelPaperEntryRequest);
      case 'ReducePaperPosition':
        return reducePaperPosition(
            ctx, request as $5.ReducePaperPositionRequest);
      case 'SetPaperEntryPause':
        return setPaperEntryPause(ctx, request as $5.SetPaperEntryPauseRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PaperServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => PaperServiceBase$messageJson;
}
