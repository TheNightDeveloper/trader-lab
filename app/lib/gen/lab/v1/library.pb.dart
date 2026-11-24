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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'audit.pb.dart' as $2;
import 'common.pb.dart' as $1;
import 'report.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AlgorithmVersion extends $pb.GeneratedMessage {
  factory AlgorithmVersion({
    $core.String? id,
    $core.int? version,
    $core.String? state,
    $core.String? contentHash,
    $core.Iterable<$0.ParamSpec>? params,
    $fixnum.Int64? createdUnixMs,
    $core.Iterable<$core.String>? nextStates,
    $core.Iterable<RecipeItem>? recipe,
  }) {
    final result = AlgorithmVersion._();
    if (id != null) result.id = id;
    if (version != null) result.version = version;
    if (state != null) result.state = state;
    if (contentHash != null) result.contentHash = contentHash;
    if (params != null) result.params.addAll(params);
    if (createdUnixMs != null) result.createdUnixMs = createdUnixMs;
    if (nextStates != null) result.nextStates.addAll(nextStates);
    if (recipe != null) result.recipe.addAll(recipe);
    return result;
  }

  AlgorithmVersion._();

  factory AlgorithmVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AlgorithmVersion()..mergeFromBuffer(data, registry);
  factory AlgorithmVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AlgorithmVersion()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AlgorithmVersion',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AlgorithmVersion.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'state')
    ..aOS(4, _omitFieldNames ? '' : 'contentHash')
    ..pPM<$0.ParamSpec>(5, _omitFieldNames ? '' : 'params',
        subBuilder: $0.ParamSpec.$_createMessage)
    ..aInt64(6, _omitFieldNames ? '' : 'createdUnixMs')
    ..pPS(7, _omitFieldNames ? '' : 'nextStates')
    ..pPM<RecipeItem>(8, _omitFieldNames ? '' : 'recipe',
        subBuilder: RecipeItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlgorithmVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlgorithmVersion copyWith(void Function(AlgorithmVersion) updates) =>
      super.copyWith((message) => updates(message as AlgorithmVersion))
          as AlgorithmVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AlgorithmVersion() / AlgorithmVersion.new instead')
  static AlgorithmVersion create() => AlgorithmVersion._();
  static $pb.GeneratedMessage $_createMessage() => AlgorithmVersion._();
  @$core.override
  AlgorithmVersion createEmptyInstance() => AlgorithmVersion._();
  @$core.pragma('dart2js:noInline')
  static AlgorithmVersion getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AlgorithmVersion>(
          AlgorithmVersion.$_createMessage);
  static AlgorithmVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get state => $_getSZ(2);
  @$pb.TagNumber(3)
  set state($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentHash => $_getSZ(3);
  @$pb.TagNumber(4)
  set contentHash($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContentHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentHash() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$0.ParamSpec> get params => $_getList(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdUnixMs => $_getI64(5);
  @$pb.TagNumber(6)
  set createdUnixMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedUnixMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedUnixMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get nextStates => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<RecipeItem> get recipe => $_getList(7);
}

class RecipeItem extends $pb.GeneratedMessage {
  factory RecipeItem({
    $core.String? key,
    $core.String? value,
  }) {
    final result = RecipeItem._();
    if (key != null) result.key = key;
    if (value != null) result.value = value;
    return result;
  }

  RecipeItem._();

  factory RecipeItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeItem()..mergeFromBuffer(data, registry);
  factory RecipeItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RecipeItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeItem copyWith(void Function(RecipeItem) updates) =>
      super.copyWith((message) => updates(message as RecipeItem)) as RecipeItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecipeItem() / RecipeItem.new instead')
  static RecipeItem create() => RecipeItem._();
  static $pb.GeneratedMessage $_createMessage() => RecipeItem._();
  @$core.override
  RecipeItem createEmptyInstance() => RecipeItem._();
  @$core.pragma('dart2js:noInline')
  static RecipeItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeItem>(RecipeItem.$_createMessage);
  static RecipeItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class LatestReport extends $pb.GeneratedMessage {
  factory LatestReport({
    $core.String? reportId,
    $1.Decimal? totalReturn,
    $fixnum.Int64? createdUnixMs,
  }) {
    final result = LatestReport._();
    if (reportId != null) result.reportId = reportId;
    if (totalReturn != null) result.totalReturn = totalReturn;
    if (createdUnixMs != null) result.createdUnixMs = createdUnixMs;
    return result;
  }

  LatestReport._();

  factory LatestReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LatestReport()..mergeFromBuffer(data, registry);
  factory LatestReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LatestReport()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LatestReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: LatestReport.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aOM<$1.Decimal>(2, _omitFieldNames ? '' : 'totalReturn',
        subBuilder: $1.Decimal.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'createdUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestReport copyWith(void Function(LatestReport) updates) =>
      super.copyWith((message) => updates(message as LatestReport))
          as LatestReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LatestReport() / LatestReport.new instead')
  static LatestReport create() => LatestReport._();
  static $pb.GeneratedMessage $_createMessage() => LatestReport._();
  @$core.override
  LatestReport createEmptyInstance() => LatestReport._();
  @$core.pragma('dart2js:noInline')
  static LatestReport getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LatestReport>(
          LatestReport.$_createMessage);
  static LatestReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Decimal get totalReturn => $_getN(1);
  @$pb.TagNumber(2)
  set totalReturn($1.Decimal value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalReturn() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalReturn() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Decimal ensureTotalReturn() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createdUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set createdUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedUnixMs() => $_clearField(3);
}

class Algorithm extends $pb.GeneratedMessage {
  factory Algorithm({
    $core.String? id,
    $core.String? family,
    $core.String? description,
    $core.Iterable<AlgorithmVersion>? versions,
    LatestReport? latestReport,
    $core.String? activeModel,
    $fixnum.Int64? lifecycleRevision,
  }) {
    final result = Algorithm._();
    if (id != null) result.id = id;
    if (family != null) result.family = family;
    if (description != null) result.description = description;
    if (versions != null) result.versions.addAll(versions);
    if (latestReport != null) result.latestReport = latestReport;
    if (activeModel != null) result.activeModel = activeModel;
    if (lifecycleRevision != null) result.lifecycleRevision = lifecycleRevision;
    return result;
  }

  Algorithm._();

  factory Algorithm.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Algorithm()..mergeFromBuffer(data, registry);
  factory Algorithm.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Algorithm()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Algorithm',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Algorithm.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'family')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..pPM<AlgorithmVersion>(4, _omitFieldNames ? '' : 'versions',
        subBuilder: AlgorithmVersion.$_createMessage)
    ..aOM<LatestReport>(5, _omitFieldNames ? '' : 'latestReport',
        subBuilder: LatestReport.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'activeModel')
    ..aInt64(7, _omitFieldNames ? '' : 'lifecycleRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Algorithm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Algorithm copyWith(void Function(Algorithm) updates) =>
      super.copyWith((message) => updates(message as Algorithm)) as Algorithm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Algorithm() / Algorithm.new instead')
  static Algorithm create() => Algorithm._();
  static $pb.GeneratedMessage $_createMessage() => Algorithm._();
  @$core.override
  Algorithm createEmptyInstance() => Algorithm._();
  @$core.pragma('dart2js:noInline')
  static Algorithm getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Algorithm>(Algorithm.$_createMessage);
  static Algorithm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get family => $_getSZ(1);
  @$pb.TagNumber(2)
  set family($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFamily() => $_has(1);
  @$pb.TagNumber(2)
  void clearFamily() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<AlgorithmVersion> get versions => $_getList(3);

  @$pb.TagNumber(5)
  LatestReport get latestReport => $_getN(4);
  @$pb.TagNumber(5)
  set latestReport(LatestReport value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLatestReport() => $_has(4);
  @$pb.TagNumber(5)
  void clearLatestReport() => $_clearField(5);
  @$pb.TagNumber(5)
  LatestReport ensureLatestReport() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get activeModel => $_getSZ(5);
  @$pb.TagNumber(6)
  set activeModel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActiveModel() => $_has(5);
  @$pb.TagNumber(6)
  void clearActiveModel() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get lifecycleRevision => $_getI64(6);
  @$pb.TagNumber(7)
  set lifecycleRevision($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLifecycleRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearLifecycleRevision() => $_clearField(7);
}

class ListAlgorithmsRequest extends $pb.GeneratedMessage {
  factory ListAlgorithmsRequest() => ListAlgorithmsRequest._();

  ListAlgorithmsRequest._();

  factory ListAlgorithmsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAlgorithmsRequest()..mergeFromBuffer(data, registry);
  factory ListAlgorithmsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAlgorithmsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlgorithmsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListAlgorithmsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlgorithmsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlgorithmsRequest copyWith(
          void Function(ListAlgorithmsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAlgorithmsRequest))
          as ListAlgorithmsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAlgorithmsRequest() / ListAlgorithmsRequest.new instead')
  static ListAlgorithmsRequest create() => ListAlgorithmsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListAlgorithmsRequest._();
  @$core.override
  ListAlgorithmsRequest createEmptyInstance() => ListAlgorithmsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListAlgorithmsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlgorithmsRequest>(
          ListAlgorithmsRequest.$_createMessage);
  static ListAlgorithmsRequest? _defaultInstance;
}

class ListAlgorithmsResponse extends $pb.GeneratedMessage {
  factory ListAlgorithmsResponse({
    $core.Iterable<Algorithm>? algorithms,
  }) {
    final result = ListAlgorithmsResponse._();
    if (algorithms != null) result.algorithms.addAll(algorithms);
    return result;
  }

  ListAlgorithmsResponse._();

  factory ListAlgorithmsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAlgorithmsResponse()..mergeFromBuffer(data, registry);
  factory ListAlgorithmsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAlgorithmsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlgorithmsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListAlgorithmsResponse.$_createMessage)
    ..pPM<Algorithm>(1, _omitFieldNames ? '' : 'algorithms',
        subBuilder: Algorithm.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlgorithmsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlgorithmsResponse copyWith(
          void Function(ListAlgorithmsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAlgorithmsResponse))
          as ListAlgorithmsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAlgorithmsResponse() / ListAlgorithmsResponse.new instead')
  static ListAlgorithmsResponse create() => ListAlgorithmsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListAlgorithmsResponse._();
  @$core.override
  ListAlgorithmsResponse createEmptyInstance() => ListAlgorithmsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListAlgorithmsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlgorithmsResponse>(
          ListAlgorithmsResponse.$_createMessage);
  static ListAlgorithmsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Algorithm> get algorithms => $_getList(0);
}

class SetVersionStateRequest extends $pb.GeneratedMessage {
  factory SetVersionStateRequest({
    $core.String? versionId,
    $core.String? state,
    $core.String? note,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = SetVersionStateRequest._();
    if (versionId != null) result.versionId = versionId;
    if (state != null) result.state = state;
    if (note != null) result.note = note;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  SetVersionStateRequest._();

  factory SetVersionStateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetVersionStateRequest()..mergeFromBuffer(data, registry);
  factory SetVersionStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetVersionStateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetVersionStateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SetVersionStateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'versionId')
    ..aOS(2, _omitFieldNames ? '' : 'state')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVersionStateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVersionStateRequest copyWith(
          void Function(SetVersionStateRequest) updates) =>
      super.copyWith((message) => updates(message as SetVersionStateRequest))
          as SetVersionStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetVersionStateRequest() / SetVersionStateRequest.new instead')
  static SetVersionStateRequest create() => SetVersionStateRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetVersionStateRequest._();
  @$core.override
  SetVersionStateRequest createEmptyInstance() => SetVersionStateRequest._();
  @$core.pragma('dart2js:noInline')
  static SetVersionStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetVersionStateRequest>(
          SetVersionStateRequest.$_createMessage);
  static SetVersionStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get versionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set versionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get state => $_getSZ(1);
  @$pb.TagNumber(2)
  set state($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedRevision => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedRevision() => $_clearField(4);
}

class SetVersionStateResponse extends $pb.GeneratedMessage {
  factory SetVersionStateResponse() => SetVersionStateResponse._();

  SetVersionStateResponse._();

  factory SetVersionStateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetVersionStateResponse()..mergeFromBuffer(data, registry);
  factory SetVersionStateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetVersionStateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetVersionStateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SetVersionStateResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVersionStateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVersionStateResponse copyWith(
          void Function(SetVersionStateResponse) updates) =>
      super.copyWith((message) => updates(message as SetVersionStateResponse))
          as SetVersionStateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetVersionStateResponse() / SetVersionStateResponse.new instead')
  static SetVersionStateResponse create() => SetVersionStateResponse._();
  static $pb.GeneratedMessage $_createMessage() => SetVersionStateResponse._();
  @$core.override
  SetVersionStateResponse createEmptyInstance() => SetVersionStateResponse._();
  @$core.pragma('dart2js:noInline')
  static SetVersionStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetVersionStateResponse>(
          SetVersionStateResponse.$_createMessage);
  static SetVersionStateResponse? _defaultInstance;
}

class LifecycleEvent extends $pb.GeneratedMessage {
  factory LifecycleEvent({
    $core.String? fromState,
    $core.String? toState,
    $core.String? note,
    $core.String? actor,
    $fixnum.Int64? atUnixMs,
    $2.AuditEvent? audit,
  }) {
    final result = LifecycleEvent._();
    if (fromState != null) result.fromState = fromState;
    if (toState != null) result.toState = toState;
    if (note != null) result.note = note;
    if (actor != null) result.actor = actor;
    if (atUnixMs != null) result.atUnixMs = atUnixMs;
    if (audit != null) result.audit = audit;
    return result;
  }

  LifecycleEvent._();

  factory LifecycleEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LifecycleEvent()..mergeFromBuffer(data, registry);
  factory LifecycleEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LifecycleEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LifecycleEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: LifecycleEvent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'fromState')
    ..aOS(2, _omitFieldNames ? '' : 'toState')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aOS(4, _omitFieldNames ? '' : 'actor')
    ..aInt64(5, _omitFieldNames ? '' : 'atUnixMs')
    ..aOM<$2.AuditEvent>(6, _omitFieldNames ? '' : 'audit',
        subBuilder: $2.AuditEvent.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LifecycleEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LifecycleEvent copyWith(void Function(LifecycleEvent) updates) =>
      super.copyWith((message) => updates(message as LifecycleEvent))
          as LifecycleEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LifecycleEvent() / LifecycleEvent.new instead')
  static LifecycleEvent create() => LifecycleEvent._();
  static $pb.GeneratedMessage $_createMessage() => LifecycleEvent._();
  @$core.override
  LifecycleEvent createEmptyInstance() => LifecycleEvent._();
  @$core.pragma('dart2js:noInline')
  static LifecycleEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LifecycleEvent>(
          LifecycleEvent.$_createMessage);
  static LifecycleEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromState => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromState($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromState() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toState => $_getSZ(1);
  @$pb.TagNumber(2)
  set toState($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToState() => $_has(1);
  @$pb.TagNumber(2)
  void clearToState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get actor => $_getSZ(3);
  @$pb.TagNumber(4)
  set actor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActor() => $_has(3);
  @$pb.TagNumber(4)
  void clearActor() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get atUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set atUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAtUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearAtUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.AuditEvent get audit => $_getN(5);
  @$pb.TagNumber(6)
  set audit($2.AuditEvent value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAudit() => $_has(5);
  @$pb.TagNumber(6)
  void clearAudit() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.AuditEvent ensureAudit() => $_ensure(5);
}

class ListLifecycleEventsRequest extends $pb.GeneratedMessage {
  factory ListLifecycleEventsRequest({
    $core.String? versionId,
    $core.int? pageSize,
    $2.AuditCursor? before,
  }) {
    final result = ListLifecycleEventsRequest._();
    if (versionId != null) result.versionId = versionId;
    if (pageSize != null) result.pageSize = pageSize;
    if (before != null) result.before = before;
    return result;
  }

  ListLifecycleEventsRequest._();

  factory ListLifecycleEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListLifecycleEventsRequest()..mergeFromBuffer(data, registry);
  factory ListLifecycleEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListLifecycleEventsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLifecycleEventsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListLifecycleEventsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'versionId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOM<$2.AuditCursor>(3, _omitFieldNames ? '' : 'before',
        subBuilder: $2.AuditCursor.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLifecycleEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLifecycleEventsRequest copyWith(
          void Function(ListLifecycleEventsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListLifecycleEventsRequest))
          as ListLifecycleEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListLifecycleEventsRequest() / ListLifecycleEventsRequest.new instead')
  static ListLifecycleEventsRequest create() => ListLifecycleEventsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListLifecycleEventsRequest._();
  @$core.override
  ListLifecycleEventsRequest createEmptyInstance() =>
      ListLifecycleEventsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListLifecycleEventsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLifecycleEventsRequest>(
          ListLifecycleEventsRequest.$_createMessage);
  static ListLifecycleEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get versionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set versionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.AuditCursor get before => $_getN(2);
  @$pb.TagNumber(3)
  set before($2.AuditCursor value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBefore() => $_has(2);
  @$pb.TagNumber(3)
  void clearBefore() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.AuditCursor ensureBefore() => $_ensure(2);
}

class ListLifecycleEventsResponse extends $pb.GeneratedMessage {
  factory ListLifecycleEventsResponse({
    $core.Iterable<LifecycleEvent>? events,
    $2.AuditCursor? nextCursor,
  }) {
    final result = ListLifecycleEventsResponse._();
    if (events != null) result.events.addAll(events);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListLifecycleEventsResponse._();

  factory ListLifecycleEventsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListLifecycleEventsResponse()..mergeFromBuffer(data, registry);
  factory ListLifecycleEventsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListLifecycleEventsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLifecycleEventsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListLifecycleEventsResponse.$_createMessage)
    ..pPM<LifecycleEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: LifecycleEvent.$_createMessage)
    ..aOM<$2.AuditCursor>(2, _omitFieldNames ? '' : 'nextCursor',
        subBuilder: $2.AuditCursor.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLifecycleEventsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLifecycleEventsResponse copyWith(
          void Function(ListLifecycleEventsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListLifecycleEventsResponse))
          as ListLifecycleEventsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListLifecycleEventsResponse() / ListLifecycleEventsResponse.new instead')
  static ListLifecycleEventsResponse create() =>
      ListLifecycleEventsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListLifecycleEventsResponse._();
  @$core.override
  ListLifecycleEventsResponse createEmptyInstance() =>
      ListLifecycleEventsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListLifecycleEventsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLifecycleEventsResponse>(
          ListLifecycleEventsResponse.$_createMessage);
  static ListLifecycleEventsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LifecycleEvent> get events => $_getList(0);

  @$pb.TagNumber(2)
  $2.AuditCursor get nextCursor => $_getN(1);
  @$pb.TagNumber(2)
  set nextCursor($2.AuditCursor value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.AuditCursor ensureNextCursor() => $_ensure(1);
}

/// RuleVersionSummary describes an immutable research draft and its ancestry.
class RuleVersionSummary extends $pb.GeneratedMessage {
  factory RuleVersionSummary({
    $fixnum.Int64? id,
    $core.String? title,
    $core.String? contentHash,
    $fixnum.Int64? parentId,
    $fixnum.Int64? otherParentId,
    $core.String? templateKey,
    $fixnum.Int64? createdUnixMs,
  }) {
    final result = RuleVersionSummary._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (contentHash != null) result.contentHash = contentHash;
    if (parentId != null) result.parentId = parentId;
    if (otherParentId != null) result.otherParentId = otherParentId;
    if (templateKey != null) result.templateKey = templateKey;
    if (createdUnixMs != null) result.createdUnixMs = createdUnixMs;
    return result;
  }

  RuleVersionSummary._();

  factory RuleVersionSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RuleVersionSummary()..mergeFromBuffer(data, registry);
  factory RuleVersionSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RuleVersionSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuleVersionSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RuleVersionSummary.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'contentHash')
    ..aInt64(4, _omitFieldNames ? '' : 'parentId')
    ..aInt64(5, _omitFieldNames ? '' : 'otherParentId')
    ..aOS(6, _omitFieldNames ? '' : 'templateKey')
    ..aInt64(7, _omitFieldNames ? '' : 'createdUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuleVersionSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuleVersionSummary copyWith(void Function(RuleVersionSummary) updates) =>
      super.copyWith((message) => updates(message as RuleVersionSummary))
          as RuleVersionSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RuleVersionSummary() / RuleVersionSummary.new instead')
  static RuleVersionSummary create() => RuleVersionSummary._();
  static $pb.GeneratedMessage $_createMessage() => RuleVersionSummary._();
  @$core.override
  RuleVersionSummary createEmptyInstance() => RuleVersionSummary._();
  @$core.pragma('dart2js:noInline')
  static RuleVersionSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuleVersionSummary>(
          RuleVersionSummary.$_createMessage);
  static RuleVersionSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contentHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentHash($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentHash() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get parentId => $_getI64(3);
  @$pb.TagNumber(4)
  set parentId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get otherParentId => $_getI64(4);
  @$pb.TagNumber(5)
  set otherParentId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOtherParentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOtherParentId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get templateKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set templateKey($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTemplateKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearTemplateKey() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdUnixMs => $_getI64(6);
  @$pb.TagNumber(7)
  set createdUnixMs($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedUnixMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedUnixMs() => $_clearField(7);
}

class ListRuleVersionsRequest extends $pb.GeneratedMessage {
  factory ListRuleVersionsRequest({
    $core.String? query,
    $core.int? pageSize,
    $fixnum.Int64? beforeId,
  }) {
    final result = ListRuleVersionsRequest._();
    if (query != null) result.query = query;
    if (pageSize != null) result.pageSize = pageSize;
    if (beforeId != null) result.beforeId = beforeId;
    return result;
  }

  ListRuleVersionsRequest._();

  factory ListRuleVersionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRuleVersionsRequest()..mergeFromBuffer(data, registry);
  factory ListRuleVersionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRuleVersionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRuleVersionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListRuleVersionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aInt64(3, _omitFieldNames ? '' : 'beforeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRuleVersionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRuleVersionsRequest copyWith(
          void Function(ListRuleVersionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRuleVersionsRequest))
          as ListRuleVersionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListRuleVersionsRequest() / ListRuleVersionsRequest.new instead')
  static ListRuleVersionsRequest create() => ListRuleVersionsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListRuleVersionsRequest._();
  @$core.override
  ListRuleVersionsRequest createEmptyInstance() => ListRuleVersionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListRuleVersionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRuleVersionsRequest>(
          ListRuleVersionsRequest.$_createMessage);
  static ListRuleVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get beforeId => $_getI64(2);
  @$pb.TagNumber(3)
  set beforeId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBeforeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBeforeId() => $_clearField(3);
}

class ListRuleVersionsResponse extends $pb.GeneratedMessage {
  factory ListRuleVersionsResponse({
    $core.Iterable<RuleVersionSummary>? versions,
    $fixnum.Int64? nextBeforeId,
  }) {
    final result = ListRuleVersionsResponse._();
    if (versions != null) result.versions.addAll(versions);
    if (nextBeforeId != null) result.nextBeforeId = nextBeforeId;
    return result;
  }

  ListRuleVersionsResponse._();

  factory ListRuleVersionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRuleVersionsResponse()..mergeFromBuffer(data, registry);
  factory ListRuleVersionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRuleVersionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRuleVersionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListRuleVersionsResponse.$_createMessage)
    ..pPM<RuleVersionSummary>(1, _omitFieldNames ? '' : 'versions',
        subBuilder: RuleVersionSummary.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextBeforeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRuleVersionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRuleVersionsResponse copyWith(
          void Function(ListRuleVersionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRuleVersionsResponse))
          as ListRuleVersionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListRuleVersionsResponse() / ListRuleVersionsResponse.new instead')
  static ListRuleVersionsResponse create() => ListRuleVersionsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListRuleVersionsResponse._();
  @$core.override
  ListRuleVersionsResponse createEmptyInstance() =>
      ListRuleVersionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListRuleVersionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRuleVersionsResponse>(
          ListRuleVersionsResponse.$_createMessage);
  static ListRuleVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RuleVersionSummary> get versions => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextBeforeId => $_getI64(1);
  @$pb.TagNumber(2)
  set nextBeforeId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextBeforeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextBeforeId() => $_clearField(2);
}

class GetRuleVersionRequest extends $pb.GeneratedMessage {
  factory GetRuleVersionRequest({
    $fixnum.Int64? id,
  }) {
    final result = GetRuleVersionRequest._();
    if (id != null) result.id = id;
    return result;
  }

  GetRuleVersionRequest._();

  factory GetRuleVersionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRuleVersionRequest()..mergeFromBuffer(data, registry);
  factory GetRuleVersionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRuleVersionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRuleVersionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetRuleVersionRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRuleVersionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRuleVersionRequest copyWith(
          void Function(GetRuleVersionRequest) updates) =>
      super.copyWith((message) => updates(message as GetRuleVersionRequest))
          as GetRuleVersionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetRuleVersionRequest() / GetRuleVersionRequest.new instead')
  static GetRuleVersionRequest create() => GetRuleVersionRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetRuleVersionRequest._();
  @$core.override
  GetRuleVersionRequest createEmptyInstance() => GetRuleVersionRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRuleVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRuleVersionRequest>(
          GetRuleVersionRequest.$_createMessage);
  static GetRuleVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetRuleVersionResponse extends $pb.GeneratedMessage {
  factory GetRuleVersionResponse({
    RuleVersionSummary? version,
    $core.String? definitionJson,
  }) {
    final result = GetRuleVersionResponse._();
    if (version != null) result.version = version;
    if (definitionJson != null) result.definitionJson = definitionJson;
    return result;
  }

  GetRuleVersionResponse._();

  factory GetRuleVersionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRuleVersionResponse()..mergeFromBuffer(data, registry);
  factory GetRuleVersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRuleVersionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRuleVersionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetRuleVersionResponse.$_createMessage)
    ..aOM<RuleVersionSummary>(1, _omitFieldNames ? '' : 'version',
        subBuilder: RuleVersionSummary.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'definitionJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRuleVersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRuleVersionResponse copyWith(
          void Function(GetRuleVersionResponse) updates) =>
      super.copyWith((message) => updates(message as GetRuleVersionResponse))
          as GetRuleVersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetRuleVersionResponse() / GetRuleVersionResponse.new instead')
  static GetRuleVersionResponse create() => GetRuleVersionResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetRuleVersionResponse._();
  @$core.override
  GetRuleVersionResponse createEmptyInstance() => GetRuleVersionResponse._();
  @$core.pragma('dart2js:noInline')
  static GetRuleVersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRuleVersionResponse>(
          GetRuleVersionResponse.$_createMessage);
  static GetRuleVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RuleVersionSummary get version => $_getN(0);
  @$pb.TagNumber(1)
  set version(RuleVersionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  RuleVersionSummary ensureVersion() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get definitionJson => $_getSZ(1);
  @$pb.TagNumber(2)
  set definitionJson($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefinitionJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefinitionJson() => $_clearField(2);
}

class SaveRuleVersionRequest extends $pb.GeneratedMessage {
  factory SaveRuleVersionRequest({
    $core.String? title,
    $core.String? definitionJson,
    $fixnum.Int64? parentId,
    $core.String? templateKey,
  }) {
    final result = SaveRuleVersionRequest._();
    if (title != null) result.title = title;
    if (definitionJson != null) result.definitionJson = definitionJson;
    if (parentId != null) result.parentId = parentId;
    if (templateKey != null) result.templateKey = templateKey;
    return result;
  }

  SaveRuleVersionRequest._();

  factory SaveRuleVersionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveRuleVersionRequest()..mergeFromBuffer(data, registry);
  factory SaveRuleVersionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveRuleVersionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveRuleVersionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SaveRuleVersionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'definitionJson')
    ..aInt64(3, _omitFieldNames ? '' : 'parentId')
    ..aOS(4, _omitFieldNames ? '' : 'templateKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveRuleVersionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveRuleVersionRequest copyWith(
          void Function(SaveRuleVersionRequest) updates) =>
      super.copyWith((message) => updates(message as SaveRuleVersionRequest))
          as SaveRuleVersionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SaveRuleVersionRequest() / SaveRuleVersionRequest.new instead')
  static SaveRuleVersionRequest create() => SaveRuleVersionRequest._();
  static $pb.GeneratedMessage $_createMessage() => SaveRuleVersionRequest._();
  @$core.override
  SaveRuleVersionRequest createEmptyInstance() => SaveRuleVersionRequest._();
  @$core.pragma('dart2js:noInline')
  static SaveRuleVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveRuleVersionRequest>(
          SaveRuleVersionRequest.$_createMessage);
  static SaveRuleVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get definitionJson => $_getSZ(1);
  @$pb.TagNumber(2)
  set definitionJson($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefinitionJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefinitionJson() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get parentId => $_getI64(2);
  @$pb.TagNumber(3)
  set parentId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get templateKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set templateKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTemplateKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemplateKey() => $_clearField(4);
}

class SaveRuleVersionResponse extends $pb.GeneratedMessage {
  factory SaveRuleVersionResponse({
    RuleVersionSummary? version,
  }) {
    final result = SaveRuleVersionResponse._();
    if (version != null) result.version = version;
    return result;
  }

  SaveRuleVersionResponse._();

  factory SaveRuleVersionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveRuleVersionResponse()..mergeFromBuffer(data, registry);
  factory SaveRuleVersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveRuleVersionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveRuleVersionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SaveRuleVersionResponse.$_createMessage)
    ..aOM<RuleVersionSummary>(1, _omitFieldNames ? '' : 'version',
        subBuilder: RuleVersionSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveRuleVersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveRuleVersionResponse copyWith(
          void Function(SaveRuleVersionResponse) updates) =>
      super.copyWith((message) => updates(message as SaveRuleVersionResponse))
          as SaveRuleVersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SaveRuleVersionResponse() / SaveRuleVersionResponse.new instead')
  static SaveRuleVersionResponse create() => SaveRuleVersionResponse._();
  static $pb.GeneratedMessage $_createMessage() => SaveRuleVersionResponse._();
  @$core.override
  SaveRuleVersionResponse createEmptyInstance() => SaveRuleVersionResponse._();
  @$core.pragma('dart2js:noInline')
  static SaveRuleVersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveRuleVersionResponse>(
          SaveRuleVersionResponse.$_createMessage);
  static SaveRuleVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RuleVersionSummary get version => $_getN(0);
  @$pb.TagNumber(1)
  set version(RuleVersionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  RuleVersionSummary ensureVersion() => $_ensure(0);
}

class ComposeRuleVersionsRequest extends $pb.GeneratedMessage {
  factory ComposeRuleVersionsRequest({
    $core.String? title,
    $fixnum.Int64? firstId,
    $fixnum.Int64? secondId,
    $core.String? entryMode,
    $fixnum.Int64? exitOwnerId,
  }) {
    final result = ComposeRuleVersionsRequest._();
    if (title != null) result.title = title;
    if (firstId != null) result.firstId = firstId;
    if (secondId != null) result.secondId = secondId;
    if (entryMode != null) result.entryMode = entryMode;
    if (exitOwnerId != null) result.exitOwnerId = exitOwnerId;
    return result;
  }

  ComposeRuleVersionsRequest._();

  factory ComposeRuleVersionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ComposeRuleVersionsRequest()..mergeFromBuffer(data, registry);
  factory ComposeRuleVersionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ComposeRuleVersionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComposeRuleVersionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ComposeRuleVersionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aInt64(2, _omitFieldNames ? '' : 'firstId')
    ..aInt64(3, _omitFieldNames ? '' : 'secondId')
    ..aOS(4, _omitFieldNames ? '' : 'entryMode')
    ..aInt64(5, _omitFieldNames ? '' : 'exitOwnerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComposeRuleVersionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComposeRuleVersionsRequest copyWith(
          void Function(ComposeRuleVersionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ComposeRuleVersionsRequest))
          as ComposeRuleVersionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ComposeRuleVersionsRequest() / ComposeRuleVersionsRequest.new instead')
  static ComposeRuleVersionsRequest create() => ComposeRuleVersionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ComposeRuleVersionsRequest._();
  @$core.override
  ComposeRuleVersionsRequest createEmptyInstance() =>
      ComposeRuleVersionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ComposeRuleVersionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComposeRuleVersionsRequest>(
          ComposeRuleVersionsRequest.$_createMessage);
  static ComposeRuleVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get firstId => $_getI64(1);
  @$pb.TagNumber(2)
  set firstId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFirstId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFirstId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get secondId => $_getI64(2);
  @$pb.TagNumber(3)
  set secondId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSecondId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecondId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get entryMode => $_getSZ(3);
  @$pb.TagNumber(4)
  set entryMode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntryMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntryMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get exitOwnerId => $_getI64(4);
  @$pb.TagNumber(5)
  set exitOwnerId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExitOwnerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearExitOwnerId() => $_clearField(5);
}

class ComposeRuleVersionsResponse extends $pb.GeneratedMessage {
  factory ComposeRuleVersionsResponse({
    RuleVersionSummary? version,
  }) {
    final result = ComposeRuleVersionsResponse._();
    if (version != null) result.version = version;
    return result;
  }

  ComposeRuleVersionsResponse._();

  factory ComposeRuleVersionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ComposeRuleVersionsResponse()..mergeFromBuffer(data, registry);
  factory ComposeRuleVersionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ComposeRuleVersionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComposeRuleVersionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ComposeRuleVersionsResponse.$_createMessage)
    ..aOM<RuleVersionSummary>(1, _omitFieldNames ? '' : 'version',
        subBuilder: RuleVersionSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComposeRuleVersionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComposeRuleVersionsResponse copyWith(
          void Function(ComposeRuleVersionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ComposeRuleVersionsResponse))
          as ComposeRuleVersionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ComposeRuleVersionsResponse() / ComposeRuleVersionsResponse.new instead')
  static ComposeRuleVersionsResponse create() =>
      ComposeRuleVersionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ComposeRuleVersionsResponse._();
  @$core.override
  ComposeRuleVersionsResponse createEmptyInstance() =>
      ComposeRuleVersionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ComposeRuleVersionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComposeRuleVersionsResponse>(
          ComposeRuleVersionsResponse.$_createMessage);
  static ComposeRuleVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RuleVersionSummary get version => $_getN(0);
  @$pb.TagNumber(1)
  set version(RuleVersionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  RuleVersionSummary ensureVersion() => $_ensure(0);
}

class RuleTemplate extends $pb.GeneratedMessage {
  factory RuleTemplate({
    $core.String? key,
    $core.String? title,
    $core.String? description,
    $core.String? definitionJson,
  }) {
    final result = RuleTemplate._();
    if (key != null) result.key = key;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (definitionJson != null) result.definitionJson = definitionJson;
    return result;
  }

  RuleTemplate._();

  factory RuleTemplate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RuleTemplate()..mergeFromBuffer(data, registry);
  factory RuleTemplate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RuleTemplate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuleTemplate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RuleTemplate.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'definitionJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuleTemplate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuleTemplate copyWith(void Function(RuleTemplate) updates) =>
      super.copyWith((message) => updates(message as RuleTemplate))
          as RuleTemplate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RuleTemplate() / RuleTemplate.new instead')
  static RuleTemplate create() => RuleTemplate._();
  static $pb.GeneratedMessage $_createMessage() => RuleTemplate._();
  @$core.override
  RuleTemplate createEmptyInstance() => RuleTemplate._();
  @$core.pragma('dart2js:noInline')
  static RuleTemplate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RuleTemplate>(
          RuleTemplate.$_createMessage);
  static RuleTemplate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get definitionJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set definitionJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDefinitionJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearDefinitionJson() => $_clearField(4);
}

class ListRuleTemplatesRequest extends $pb.GeneratedMessage {
  factory ListRuleTemplatesRequest() => ListRuleTemplatesRequest._();

  ListRuleTemplatesRequest._();

  factory ListRuleTemplatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRuleTemplatesRequest()..mergeFromBuffer(data, registry);
  factory ListRuleTemplatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRuleTemplatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRuleTemplatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListRuleTemplatesRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRuleTemplatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRuleTemplatesRequest copyWith(
          void Function(ListRuleTemplatesRequest) updates) =>
      super.copyWith((message) => updates(message as ListRuleTemplatesRequest))
          as ListRuleTemplatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListRuleTemplatesRequest() / ListRuleTemplatesRequest.new instead')
  static ListRuleTemplatesRequest create() => ListRuleTemplatesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListRuleTemplatesRequest._();
  @$core.override
  ListRuleTemplatesRequest createEmptyInstance() =>
      ListRuleTemplatesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListRuleTemplatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRuleTemplatesRequest>(
          ListRuleTemplatesRequest.$_createMessage);
  static ListRuleTemplatesRequest? _defaultInstance;
}

class ListRuleTemplatesResponse extends $pb.GeneratedMessage {
  factory ListRuleTemplatesResponse({
    $core.Iterable<RuleTemplate>? templates,
  }) {
    final result = ListRuleTemplatesResponse._();
    if (templates != null) result.templates.addAll(templates);
    return result;
  }

  ListRuleTemplatesResponse._();

  factory ListRuleTemplatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRuleTemplatesResponse()..mergeFromBuffer(data, registry);
  factory ListRuleTemplatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRuleTemplatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRuleTemplatesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListRuleTemplatesResponse.$_createMessage)
    ..pPM<RuleTemplate>(1, _omitFieldNames ? '' : 'templates',
        subBuilder: RuleTemplate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRuleTemplatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRuleTemplatesResponse copyWith(
          void Function(ListRuleTemplatesResponse) updates) =>
      super.copyWith((message) => updates(message as ListRuleTemplatesResponse))
          as ListRuleTemplatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListRuleTemplatesResponse() / ListRuleTemplatesResponse.new instead')
  static ListRuleTemplatesResponse create() => ListRuleTemplatesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListRuleTemplatesResponse._();
  @$core.override
  ListRuleTemplatesResponse createEmptyInstance() =>
      ListRuleTemplatesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListRuleTemplatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRuleTemplatesResponse>(
          ListRuleTemplatesResponse.$_createMessage);
  static ListRuleTemplatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RuleTemplate> get templates => $_getList(0);
}

/// LibraryService: algorithms, their versions and lifecycle. Only a user action
/// moves a version to active.
class LibraryServiceApi {
  final $pb.RpcClient _client;

  LibraryServiceApi(this._client);

  $async.Future<ListAlgorithmsResponse> listAlgorithms(
          $pb.ClientContext? ctx, ListAlgorithmsRequest request) =>
      _client.invoke<ListAlgorithmsResponse>(ctx, 'LibraryService',
          'ListAlgorithms', request, ListAlgorithmsResponse());
  $async.Future<SetVersionStateResponse> setVersionState(
          $pb.ClientContext? ctx, SetVersionStateRequest request) =>
      _client.invoke<SetVersionStateResponse>(ctx, 'LibraryService',
          'SetVersionState', request, SetVersionStateResponse());
  $async.Future<ListLifecycleEventsResponse> listLifecycleEvents(
          $pb.ClientContext? ctx, ListLifecycleEventsRequest request) =>
      _client.invoke<ListLifecycleEventsResponse>(ctx, 'LibraryService',
          'ListLifecycleEvents', request, ListLifecycleEventsResponse());
  $async.Future<ListRuleVersionsResponse> listRuleVersions(
          $pb.ClientContext? ctx, ListRuleVersionsRequest request) =>
      _client.invoke<ListRuleVersionsResponse>(ctx, 'LibraryService',
          'ListRuleVersions', request, ListRuleVersionsResponse());
  $async.Future<GetRuleVersionResponse> getRuleVersion(
          $pb.ClientContext? ctx, GetRuleVersionRequest request) =>
      _client.invoke<GetRuleVersionResponse>(ctx, 'LibraryService',
          'GetRuleVersion', request, GetRuleVersionResponse());
  $async.Future<SaveRuleVersionResponse> saveRuleVersion(
          $pb.ClientContext? ctx, SaveRuleVersionRequest request) =>
      _client.invoke<SaveRuleVersionResponse>(ctx, 'LibraryService',
          'SaveRuleVersion', request, SaveRuleVersionResponse());
  $async.Future<ComposeRuleVersionsResponse> composeRuleVersions(
          $pb.ClientContext? ctx, ComposeRuleVersionsRequest request) =>
      _client.invoke<ComposeRuleVersionsResponse>(ctx, 'LibraryService',
          'ComposeRuleVersions', request, ComposeRuleVersionsResponse());
  $async.Future<ListRuleTemplatesResponse> listRuleTemplates(
          $pb.ClientContext? ctx, ListRuleTemplatesRequest request) =>
      _client.invoke<ListRuleTemplatesResponse>(ctx, 'LibraryService',
          'ListRuleTemplates', request, ListRuleTemplatesResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
