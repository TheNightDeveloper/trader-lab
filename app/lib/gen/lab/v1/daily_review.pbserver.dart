// This is a generated file - do not edit.
//
// Generated from lab/v1/daily_review.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'daily_review.pb.dart' as $6;
import 'daily_review.pbjson.dart';

export 'daily_review.pb.dart';

abstract class DailyReviewServiceBase extends $pb.GeneratedService {
  $async.Future<$6.GetDailyReviewResponse> getDailyReview(
      $pb.ServerContext ctx, $6.GetDailyReviewRequest request);
  $async.Future<$6.GetDailyReviewStatusResponse> getDailyReviewStatus(
      $pb.ServerContext ctx, $6.GetDailyReviewStatusRequest request);
  $async.Future<$6.SetDailyReviewReminderResponse> setDailyReviewReminder(
      $pb.ServerContext ctx, $6.SetDailyReviewReminderRequest request);
  $async.Future<$6.MarkDailyReviewReadResponse> markDailyReviewRead(
      $pb.ServerContext ctx, $6.MarkDailyReviewReadRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetDailyReview':
        return $6.GetDailyReviewRequest();
      case 'GetDailyReviewStatus':
        return $6.GetDailyReviewStatusRequest();
      case 'SetDailyReviewReminder':
        return $6.SetDailyReviewReminderRequest();
      case 'MarkDailyReviewRead':
        return $6.MarkDailyReviewReadRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetDailyReview':
        return getDailyReview(ctx, request as $6.GetDailyReviewRequest);
      case 'GetDailyReviewStatus':
        return getDailyReviewStatus(
            ctx, request as $6.GetDailyReviewStatusRequest);
      case 'SetDailyReviewReminder':
        return setDailyReviewReminder(
            ctx, request as $6.SetDailyReviewReminderRequest);
      case 'MarkDailyReviewRead':
        return markDailyReviewRead(
            ctx, request as $6.MarkDailyReviewReadRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      DailyReviewServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => DailyReviewServiceBase$messageJson;
}
