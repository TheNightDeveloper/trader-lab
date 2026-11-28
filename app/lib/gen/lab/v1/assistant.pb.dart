// This is a generated file - do not edit.
//
// Generated from lab/v1/assistant.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'assistant.pbenum.dart';
import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'assistant.pbenum.dart';

class ExplainOpportunityRequest extends $pb.GeneratedMessage {
  factory ExplainOpportunityRequest({
    $fixnum.Int64? opportunityId,
  }) {
    final result = ExplainOpportunityRequest._();
    if (opportunityId != null) result.opportunityId = opportunityId;
    return result;
  }

  ExplainOpportunityRequest._();

  factory ExplainOpportunityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExplainOpportunityRequest()..mergeFromBuffer(data, registry);
  factory ExplainOpportunityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExplainOpportunityRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExplainOpportunityRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ExplainOpportunityRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'opportunityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExplainOpportunityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExplainOpportunityRequest copyWith(
          void Function(ExplainOpportunityRequest) updates) =>
      super.copyWith((message) => updates(message as ExplainOpportunityRequest))
          as ExplainOpportunityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExplainOpportunityRequest() / ExplainOpportunityRequest.new instead')
  static ExplainOpportunityRequest create() => ExplainOpportunityRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExplainOpportunityRequest._();
  @$core.override
  ExplainOpportunityRequest createEmptyInstance() =>
      ExplainOpportunityRequest._();
  @$core.pragma('dart2js:noInline')
  static ExplainOpportunityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExplainOpportunityRequest>(
          ExplainOpportunityRequest.$_createMessage);
  static ExplainOpportunityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get opportunityId => $_getI64(0);
  @$pb.TagNumber(1)
  set opportunityId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunityId() => $_clearField(1);
}

class ExplainOpportunityResponse extends $pb.GeneratedMessage {
  factory ExplainOpportunityResponse({
    ExplanationFocus? focus,
    $fixnum.Int64? ruleVersionId,
    $core.String? reportId,
    $core.String? reason,
    $0.Money? referenceClose,
    $fixnum.Int64? candleClosedAtUnixMs,
    $fixnum.Int64? expiresAtUnixMs,
    $core.String? model,
    $core.int? inputTokens,
    $core.int? outputTokens,
    $core.bool? cached,
  }) {
    final result = ExplainOpportunityResponse._();
    if (focus != null) result.focus = focus;
    if (ruleVersionId != null) result.ruleVersionId = ruleVersionId;
    if (reportId != null) result.reportId = reportId;
    if (reason != null) result.reason = reason;
    if (referenceClose != null) result.referenceClose = referenceClose;
    if (candleClosedAtUnixMs != null)
      result.candleClosedAtUnixMs = candleClosedAtUnixMs;
    if (expiresAtUnixMs != null) result.expiresAtUnixMs = expiresAtUnixMs;
    if (model != null) result.model = model;
    if (inputTokens != null) result.inputTokens = inputTokens;
    if (outputTokens != null) result.outputTokens = outputTokens;
    if (cached != null) result.cached = cached;
    return result;
  }

  ExplainOpportunityResponse._();

  factory ExplainOpportunityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExplainOpportunityResponse()..mergeFromBuffer(data, registry);
  factory ExplainOpportunityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExplainOpportunityResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExplainOpportunityResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ExplainOpportunityResponse.$_createMessage)
    ..aE<ExplanationFocus>(1, _omitFieldNames ? '' : 'focus',
        enumValues: ExplanationFocus.values)
    ..aInt64(2, _omitFieldNames ? '' : 'ruleVersionId')
    ..aOS(3, _omitFieldNames ? '' : 'reportId')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Money>(5, _omitFieldNames ? '' : 'referenceClose',
        subBuilder: $0.Money.$_createMessage)
    ..aInt64(6, _omitFieldNames ? '' : 'candleClosedAtUnixMs')
    ..aInt64(7, _omitFieldNames ? '' : 'expiresAtUnixMs')
    ..aOS(8, _omitFieldNames ? '' : 'model')
    ..aI(9, _omitFieldNames ? '' : 'inputTokens')
    ..aI(10, _omitFieldNames ? '' : 'outputTokens')
    ..aOB(11, _omitFieldNames ? '' : 'cached')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExplainOpportunityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExplainOpportunityResponse copyWith(
          void Function(ExplainOpportunityResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ExplainOpportunityResponse))
          as ExplainOpportunityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExplainOpportunityResponse() / ExplainOpportunityResponse.new instead')
  static ExplainOpportunityResponse create() => ExplainOpportunityResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExplainOpportunityResponse._();
  @$core.override
  ExplainOpportunityResponse createEmptyInstance() =>
      ExplainOpportunityResponse._();
  @$core.pragma('dart2js:noInline')
  static ExplainOpportunityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExplainOpportunityResponse>(
          ExplainOpportunityResponse.$_createMessage);
  static ExplainOpportunityResponse? _defaultInstance;

  /// The model selects a focus. The following references come from the engine.
  @$pb.TagNumber(1)
  ExplanationFocus get focus => $_getN(0);
  @$pb.TagNumber(1)
  set focus(ExplanationFocus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFocus() => $_has(0);
  @$pb.TagNumber(1)
  void clearFocus() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get ruleVersionId => $_getI64(1);
  @$pb.TagNumber(2)
  set ruleVersionId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRuleVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRuleVersionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reportId => $_getSZ(2);
  @$pb.TagNumber(3)
  set reportId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReportId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReportId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Money get referenceClose => $_getN(4);
  @$pb.TagNumber(5)
  set referenceClose($0.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReferenceClose() => $_has(4);
  @$pb.TagNumber(5)
  void clearReferenceClose() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Money ensureReferenceClose() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get candleClosedAtUnixMs => $_getI64(5);
  @$pb.TagNumber(6)
  set candleClosedAtUnixMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCandleClosedAtUnixMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearCandleClosedAtUnixMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get expiresAtUnixMs => $_getI64(6);
  @$pb.TagNumber(7)
  set expiresAtUnixMs($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExpiresAtUnixMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpiresAtUnixMs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get model => $_getSZ(7);
  @$pb.TagNumber(8)
  set model($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasModel() => $_has(7);
  @$pb.TagNumber(8)
  void clearModel() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get inputTokens => $_getIZ(8);
  @$pb.TagNumber(9)
  set inputTokens($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasInputTokens() => $_has(8);
  @$pb.TagNumber(9)
  void clearInputTokens() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get outputTokens => $_getIZ(9);
  @$pb.TagNumber(10)
  set outputTokens($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOutputTokens() => $_has(9);
  @$pb.TagNumber(10)
  void clearOutputTokens() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get cached => $_getBF(10);
  @$pb.TagNumber(11)
  set cached($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCached() => $_has(10);
  @$pb.TagNumber(11)
  void clearCached() => $_clearField(11);
}

class AssistantServiceApi {
  final $pb.RpcClient _client;

  AssistantServiceApi(this._client);

  /// Explain a saved engine observation. This can spend assistant budget.
  $async.Future<ExplainOpportunityResponse> explainOpportunity(
          $pb.ClientContext? ctx, ExplainOpportunityRequest request) =>
      _client.invoke<ExplainOpportunityResponse>(ctx, 'AssistantService',
          'ExplainOpportunity', request, ExplainOpportunityResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
