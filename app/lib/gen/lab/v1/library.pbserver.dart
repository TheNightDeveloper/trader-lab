// This is a generated file - do not edit.
//
// Generated from lab/v1/library.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'library.pb.dart' as $4;
import 'library.pbjson.dart';

export 'library.pb.dart';

abstract class LibraryServiceBase extends $pb.GeneratedService {
  $async.Future<$4.ListAlgorithmsResponse> listAlgorithms(
      $pb.ServerContext ctx, $4.ListAlgorithmsRequest request);
  $async.Future<$4.SetVersionStateResponse> setVersionState(
      $pb.ServerContext ctx, $4.SetVersionStateRequest request);
  $async.Future<$4.ListLifecycleEventsResponse> listLifecycleEvents(
      $pb.ServerContext ctx, $4.ListLifecycleEventsRequest request);
  $async.Future<$4.ListRuleVersionsResponse> listRuleVersions(
      $pb.ServerContext ctx, $4.ListRuleVersionsRequest request);
  $async.Future<$4.GetRuleVersionResponse> getRuleVersion(
      $pb.ServerContext ctx, $4.GetRuleVersionRequest request);
  $async.Future<$4.SaveRuleVersionResponse> saveRuleVersion(
      $pb.ServerContext ctx, $4.SaveRuleVersionRequest request);
  $async.Future<$4.ComposeRuleVersionsResponse> composeRuleVersions(
      $pb.ServerContext ctx, $4.ComposeRuleVersionsRequest request);
  $async.Future<$4.ListRuleTemplatesResponse> listRuleTemplates(
      $pb.ServerContext ctx, $4.ListRuleTemplatesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListAlgorithms':
        return $4.ListAlgorithmsRequest();
      case 'SetVersionState':
        return $4.SetVersionStateRequest();
      case 'ListLifecycleEvents':
        return $4.ListLifecycleEventsRequest();
      case 'ListRuleVersions':
        return $4.ListRuleVersionsRequest();
      case 'GetRuleVersion':
        return $4.GetRuleVersionRequest();
      case 'SaveRuleVersion':
        return $4.SaveRuleVersionRequest();
      case 'ComposeRuleVersions':
        return $4.ComposeRuleVersionsRequest();
      case 'ListRuleTemplates':
        return $4.ListRuleTemplatesRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListAlgorithms':
        return listAlgorithms(ctx, request as $4.ListAlgorithmsRequest);
      case 'SetVersionState':
        return setVersionState(ctx, request as $4.SetVersionStateRequest);
      case 'ListLifecycleEvents':
        return listLifecycleEvents(
            ctx, request as $4.ListLifecycleEventsRequest);
      case 'ListRuleVersions':
        return listRuleVersions(ctx, request as $4.ListRuleVersionsRequest);
      case 'GetRuleVersion':
        return getRuleVersion(ctx, request as $4.GetRuleVersionRequest);
      case 'SaveRuleVersion':
        return saveRuleVersion(ctx, request as $4.SaveRuleVersionRequest);
      case 'ComposeRuleVersions':
        return composeRuleVersions(
            ctx, request as $4.ComposeRuleVersionsRequest);
      case 'ListRuleTemplates':
        return listRuleTemplates(ctx, request as $4.ListRuleTemplatesRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LibraryServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => LibraryServiceBase$messageJson;
}
