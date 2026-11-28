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
import 'common.pb.dart' as $1;
import 'report.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'assistant.pbenum.dart';

class DraftStrategyRequest extends $pb.GeneratedMessage {
  factory DraftStrategyRequest({
    $core.String? description,
  }) {
    final result = DraftStrategyRequest._();
    if (description != null) result.description = description;
    return result;
  }

  DraftStrategyRequest._();

  factory DraftStrategyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DraftStrategyRequest()..mergeFromBuffer(data, registry);
  factory DraftStrategyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DraftStrategyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftStrategyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: DraftStrategyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftStrategyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftStrategyRequest copyWith(void Function(DraftStrategyRequest) updates) =>
      super.copyWith((message) => updates(message as DraftStrategyRequest))
          as DraftStrategyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DraftStrategyRequest() / DraftStrategyRequest.new instead')
  static DraftStrategyRequest create() => DraftStrategyRequest._();
  static $pb.GeneratedMessage $_createMessage() => DraftStrategyRequest._();
  @$core.override
  DraftStrategyRequest createEmptyInstance() => DraftStrategyRequest._();
  @$core.pragma('dart2js:noInline')
  static DraftStrategyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftStrategyRequest>(
          DraftStrategyRequest.$_createMessage);
  static DraftStrategyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get description => $_getSZ(0);
  @$pb.TagNumber(1)
  set description($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearDescription() => $_clearField(1);
}

class DraftStrategyResponse extends $pb.GeneratedMessage {
  factory DraftStrategyResponse({
    $core.String? definitionJson,
    $core.int? lookbackBars,
    $core.Iterable<DraftQuestion>? questions,
    $core.String? model,
    $core.int? inputTokens,
    $core.int? outputTokens,
  }) {
    final result = DraftStrategyResponse._();
    if (definitionJson != null) result.definitionJson = definitionJson;
    if (lookbackBars != null) result.lookbackBars = lookbackBars;
    if (questions != null) result.questions.addAll(questions);
    if (model != null) result.model = model;
    if (inputTokens != null) result.inputTokens = inputTokens;
    if (outputTokens != null) result.outputTokens = outputTokens;
    return result;
  }

  DraftStrategyResponse._();

  factory DraftStrategyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DraftStrategyResponse()..mergeFromBuffer(data, registry);
  factory DraftStrategyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DraftStrategyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DraftStrategyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: DraftStrategyResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'definitionJson')
    ..aI(2, _omitFieldNames ? '' : 'lookbackBars')
    ..pc<DraftQuestion>(
        3, _omitFieldNames ? '' : 'questions', $pb.PbFieldType.KE,
        valueOf: DraftQuestion.valueOf,
        enumValues: DraftQuestion.values,
        defaultEnumValue: DraftQuestion.DRAFT_QUESTION_UNSPECIFIED)
    ..aOS(4, _omitFieldNames ? '' : 'model')
    ..aI(5, _omitFieldNames ? '' : 'inputTokens')
    ..aI(6, _omitFieldNames ? '' : 'outputTokens')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftStrategyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DraftStrategyResponse copyWith(
          void Function(DraftStrategyResponse) updates) =>
      super.copyWith((message) => updates(message as DraftStrategyResponse))
          as DraftStrategyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DraftStrategyResponse() / DraftStrategyResponse.new instead')
  static DraftStrategyResponse create() => DraftStrategyResponse._();
  static $pb.GeneratedMessage $_createMessage() => DraftStrategyResponse._();
  @$core.override
  DraftStrategyResponse createEmptyInstance() => DraftStrategyResponse._();
  @$core.pragma('dart2js:noInline')
  static DraftStrategyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DraftStrategyResponse>(
          DraftStrategyResponse.$_createMessage);
  static DraftStrategyResponse? _defaultInstance;

  /// Canonical rules/v1 JSON is present only when the draft validates.
  @$pb.TagNumber(1)
  $core.String get definitionJson => $_getSZ(0);
  @$pb.TagNumber(1)
  set definitionJson($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDefinitionJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefinitionJson() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get lookbackBars => $_getIZ(1);
  @$pb.TagNumber(2)
  set lookbackBars($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLookbackBars() => $_has(1);
  @$pb.TagNumber(2)
  void clearLookbackBars() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<DraftQuestion> get questions => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get model => $_getSZ(3);
  @$pb.TagNumber(4)
  set model($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearModel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get inputTokens => $_getIZ(4);
  @$pb.TagNumber(5)
  set inputTokens($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInputTokens() => $_has(4);
  @$pb.TagNumber(5)
  void clearInputTokens() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get outputTokens => $_getIZ(5);
  @$pb.TagNumber(6)
  set outputTokens($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOutputTokens() => $_has(5);
  @$pb.TagNumber(6)
  void clearOutputTokens() => $_clearField(6);
}

class ReviewReportsRequest extends $pb.GeneratedMessage {
  factory ReviewReportsRequest({
    $core.Iterable<$core.String>? reportIds,
  }) {
    final result = ReviewReportsRequest._();
    if (reportIds != null) result.reportIds.addAll(reportIds);
    return result;
  }

  ReviewReportsRequest._();

  factory ReviewReportsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewReportsRequest()..mergeFromBuffer(data, registry);
  factory ReviewReportsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewReportsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewReportsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ReviewReportsRequest.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'reportIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewReportsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewReportsRequest copyWith(void Function(ReviewReportsRequest) updates) =>
      super.copyWith((message) => updates(message as ReviewReportsRequest))
          as ReviewReportsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReviewReportsRequest() / ReviewReportsRequest.new instead')
  static ReviewReportsRequest create() => ReviewReportsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReviewReportsRequest._();
  @$core.override
  ReviewReportsRequest createEmptyInstance() => ReviewReportsRequest._();
  @$core.pragma('dart2js:noInline')
  static ReviewReportsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewReportsRequest>(
          ReviewReportsRequest.$_createMessage);
  static ReviewReportsRequest? _defaultInstance;

  /// The first report is the baseline for the engine's comparability checks.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get reportIds => $_getList(0);
}

class ResearchReference extends $pb.GeneratedMessage {
  factory ResearchReference({
    $core.String? reportId,
    $core.String? title,
    $0.Window? oosWindow,
    $1.Metric? metric,
  }) {
    final result = ResearchReference._();
    if (reportId != null) result.reportId = reportId;
    if (title != null) result.title = title;
    if (oosWindow != null) result.oosWindow = oosWindow;
    if (metric != null) result.metric = metric;
    return result;
  }

  ResearchReference._();

  factory ResearchReference.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResearchReference()..mergeFromBuffer(data, registry);
  factory ResearchReference.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResearchReference()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResearchReference',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ResearchReference.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOM<$0.Window>(3, _omitFieldNames ? '' : 'oosWindow',
        subBuilder: $0.Window.$_createMessage)
    ..aOM<$1.Metric>(4, _omitFieldNames ? '' : 'metric',
        subBuilder: $1.Metric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResearchReference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResearchReference copyWith(void Function(ResearchReference) updates) =>
      super.copyWith((message) => updates(message as ResearchReference))
          as ResearchReference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ResearchReference() / ResearchReference.new instead')
  static ResearchReference create() => ResearchReference._();
  static $pb.GeneratedMessage $_createMessage() => ResearchReference._();
  @$core.override
  ResearchReference createEmptyInstance() => ResearchReference._();
  @$core.pragma('dart2js:noInline')
  static ResearchReference getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResearchReference>(
          ResearchReference.$_createMessage);
  static ResearchReference? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Window get oosWindow => $_getN(2);
  @$pb.TagNumber(3)
  set oosWindow($0.Window value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOosWindow() => $_has(2);
  @$pb.TagNumber(3)
  void clearOosWindow() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Window ensureOosWindow() => $_ensure(2);

  /// Only present for a metric focus and if that metric was recorded.
  @$pb.TagNumber(4)
  $1.Metric get metric => $_getN(3);
  @$pb.TagNumber(4)
  set metric($1.Metric value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMetric() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetric() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Metric ensureMetric() => $_ensure(3);
}

class ReviewReportsResponse extends $pb.GeneratedMessage {
  factory ReviewReportsResponse({
    ResearchFocus? focus,
    $core.Iterable<ResearchReference>? references,
    $core.Iterable<$0.Assumption>? blockingAssumptions,
    $core.int? minimumClosedTrades,
    $core.String? model,
    $core.int? inputTokens,
    $core.int? outputTokens,
    $core.bool? cached,
  }) {
    final result = ReviewReportsResponse._();
    if (focus != null) result.focus = focus;
    if (references != null) result.references.addAll(references);
    if (blockingAssumptions != null)
      result.blockingAssumptions.addAll(blockingAssumptions);
    if (minimumClosedTrades != null)
      result.minimumClosedTrades = minimumClosedTrades;
    if (model != null) result.model = model;
    if (inputTokens != null) result.inputTokens = inputTokens;
    if (outputTokens != null) result.outputTokens = outputTokens;
    if (cached != null) result.cached = cached;
    return result;
  }

  ReviewReportsResponse._();

  factory ReviewReportsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewReportsResponse()..mergeFromBuffer(data, registry);
  factory ReviewReportsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewReportsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewReportsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ReviewReportsResponse.$_createMessage)
    ..aE<ResearchFocus>(1, _omitFieldNames ? '' : 'focus',
        enumValues: ResearchFocus.values)
    ..pPM<ResearchReference>(2, _omitFieldNames ? '' : 'references',
        subBuilder: ResearchReference.$_createMessage)
    ..pPM<$0.Assumption>(3, _omitFieldNames ? '' : 'blockingAssumptions',
        subBuilder: $0.Assumption.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'minimumClosedTrades')
    ..aOS(5, _omitFieldNames ? '' : 'model')
    ..aI(6, _omitFieldNames ? '' : 'inputTokens')
    ..aI(7, _omitFieldNames ? '' : 'outputTokens')
    ..aOB(8, _omitFieldNames ? '' : 'cached')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewReportsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewReportsResponse copyWith(
          void Function(ReviewReportsResponse) updates) =>
      super.copyWith((message) => updates(message as ReviewReportsResponse))
          as ReviewReportsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReviewReportsResponse() / ReviewReportsResponse.new instead')
  static ReviewReportsResponse create() => ReviewReportsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ReviewReportsResponse._();
  @$core.override
  ReviewReportsResponse createEmptyInstance() => ReviewReportsResponse._();
  @$core.pragma('dart2js:noInline')
  static ReviewReportsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewReportsResponse>(
          ReviewReportsResponse.$_createMessage);
  static ReviewReportsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ResearchFocus get focus => $_getN(0);
  @$pb.TagNumber(1)
  set focus(ResearchFocus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFocus() => $_has(0);
  @$pb.TagNumber(1)
  void clearFocus() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ResearchReference> get references => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$0.Assumption> get blockingAssumptions => $_getList(2);

  /// Presence means at least one report falls short of the sample requirement.
  @$pb.TagNumber(4)
  $core.int get minimumClosedTrades => $_getIZ(3);
  @$pb.TagNumber(4)
  set minimumClosedTrades($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinimumClosedTrades() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinimumClosedTrades() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get model => $_getSZ(4);
  @$pb.TagNumber(5)
  set model($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasModel() => $_has(4);
  @$pb.TagNumber(5)
  void clearModel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get inputTokens => $_getIZ(5);
  @$pb.TagNumber(6)
  set inputTokens($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInputTokens() => $_has(5);
  @$pb.TagNumber(6)
  void clearInputTokens() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get outputTokens => $_getIZ(6);
  @$pb.TagNumber(7)
  set outputTokens($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOutputTokens() => $_has(6);
  @$pb.TagNumber(7)
  void clearOutputTokens() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get cached => $_getBF(7);
  @$pb.TagNumber(8)
  set cached($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCached() => $_has(7);
  @$pb.TagNumber(8)
  void clearCached() => $_clearField(8);
}

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
    $1.Money? referenceClose,
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
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'referenceClose',
        subBuilder: $1.Money.$_createMessage)
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
  $1.Money get referenceClose => $_getN(4);
  @$pb.TagNumber(5)
  set referenceClose($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReferenceClose() => $_has(4);
  @$pb.TagNumber(5)
  void clearReferenceClose() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureReferenceClose() => $_ensure(4);

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

  /// Review the out-of-sample evidence of one report or compare up to six reports.
  $async.Future<ReviewReportsResponse> reviewReports(
          $pb.ClientContext? ctx, ReviewReportsRequest request) =>
      _client.invoke<ReviewReportsResponse>(ctx, 'AssistantService',
          'ReviewReports', request, ReviewReportsResponse());

  /// Convert user text to an editable, validated draft or clarification questions.
  $async.Future<DraftStrategyResponse> draftStrategy(
          $pb.ClientContext? ctx, DraftStrategyRequest request) =>
      _client.invoke<DraftStrategyResponse>(ctx, 'AssistantService',
          'DraftStrategy', request, DraftStrategyResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
