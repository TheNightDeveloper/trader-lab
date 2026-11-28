// This is a generated file - do not edit.
//
// Generated from lab/v1/shadow.proto.

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

import 'common.pb.dart' as $0;
import 'shadow.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'shadow.pbenum.dart';

class StartShadowDeploymentRequest extends $pb.GeneratedMessage {
  factory StartShadowDeploymentRequest({
    $core.String? symbol,
    $fixnum.Int64? ruleVersionId,
  }) {
    final result = StartShadowDeploymentRequest._();
    if (symbol != null) result.symbol = symbol;
    if (ruleVersionId != null) result.ruleVersionId = ruleVersionId;
    return result;
  }

  StartShadowDeploymentRequest._();

  factory StartShadowDeploymentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartShadowDeploymentRequest()..mergeFromBuffer(data, registry);
  factory StartShadowDeploymentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartShadowDeploymentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartShadowDeploymentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StartShadowDeploymentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aInt64(2, _omitFieldNames ? '' : 'ruleVersionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartShadowDeploymentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartShadowDeploymentRequest copyWith(
          void Function(StartShadowDeploymentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartShadowDeploymentRequest))
          as StartShadowDeploymentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StartShadowDeploymentRequest() / StartShadowDeploymentRequest.new instead')
  static StartShadowDeploymentRequest create() =>
      StartShadowDeploymentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StartShadowDeploymentRequest._();
  @$core.override
  StartShadowDeploymentRequest createEmptyInstance() =>
      StartShadowDeploymentRequest._();
  @$core.pragma('dart2js:noInline')
  static StartShadowDeploymentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartShadowDeploymentRequest>(
          StartShadowDeploymentRequest.$_createMessage);
  static StartShadowDeploymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get ruleVersionId => $_getI64(1);
  @$pb.TagNumber(2)
  set ruleVersionId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRuleVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRuleVersionId() => $_clearField(2);
}

class StartShadowDeploymentResponse extends $pb.GeneratedMessage {
  factory StartShadowDeploymentResponse({
    $fixnum.Int64? deploymentId,
  }) {
    final result = StartShadowDeploymentResponse._();
    if (deploymentId != null) result.deploymentId = deploymentId;
    return result;
  }

  StartShadowDeploymentResponse._();

  factory StartShadowDeploymentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartShadowDeploymentResponse()..mergeFromBuffer(data, registry);
  factory StartShadowDeploymentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartShadowDeploymentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartShadowDeploymentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StartShadowDeploymentResponse.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'deploymentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartShadowDeploymentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartShadowDeploymentResponse copyWith(
          void Function(StartShadowDeploymentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StartShadowDeploymentResponse))
          as StartShadowDeploymentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StartShadowDeploymentResponse() / StartShadowDeploymentResponse.new instead')
  static StartShadowDeploymentResponse create() =>
      StartShadowDeploymentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StartShadowDeploymentResponse._();
  @$core.override
  StartShadowDeploymentResponse createEmptyInstance() =>
      StartShadowDeploymentResponse._();
  @$core.pragma('dart2js:noInline')
  static StartShadowDeploymentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartShadowDeploymentResponse>(
          StartShadowDeploymentResponse.$_createMessage);
  static StartShadowDeploymentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get deploymentId => $_getI64(0);
  @$pb.TagNumber(1)
  set deploymentId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeploymentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeploymentId() => $_clearField(1);
}

class StopShadowDeploymentRequest extends $pb.GeneratedMessage {
  factory StopShadowDeploymentRequest({
    $fixnum.Int64? deploymentId,
  }) {
    final result = StopShadowDeploymentRequest._();
    if (deploymentId != null) result.deploymentId = deploymentId;
    return result;
  }

  StopShadowDeploymentRequest._();

  factory StopShadowDeploymentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StopShadowDeploymentRequest()..mergeFromBuffer(data, registry);
  factory StopShadowDeploymentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StopShadowDeploymentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopShadowDeploymentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StopShadowDeploymentRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'deploymentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopShadowDeploymentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopShadowDeploymentRequest copyWith(
          void Function(StopShadowDeploymentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StopShadowDeploymentRequest))
          as StopShadowDeploymentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StopShadowDeploymentRequest() / StopShadowDeploymentRequest.new instead')
  static StopShadowDeploymentRequest create() =>
      StopShadowDeploymentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StopShadowDeploymentRequest._();
  @$core.override
  StopShadowDeploymentRequest createEmptyInstance() =>
      StopShadowDeploymentRequest._();
  @$core.pragma('dart2js:noInline')
  static StopShadowDeploymentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopShadowDeploymentRequest>(
          StopShadowDeploymentRequest.$_createMessage);
  static StopShadowDeploymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get deploymentId => $_getI64(0);
  @$pb.TagNumber(1)
  set deploymentId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeploymentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeploymentId() => $_clearField(1);
}

class StopShadowDeploymentResponse extends $pb.GeneratedMessage {
  factory StopShadowDeploymentResponse() => StopShadowDeploymentResponse._();

  StopShadowDeploymentResponse._();

  factory StopShadowDeploymentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StopShadowDeploymentResponse()..mergeFromBuffer(data, registry);
  factory StopShadowDeploymentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StopShadowDeploymentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopShadowDeploymentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StopShadowDeploymentResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopShadowDeploymentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopShadowDeploymentResponse copyWith(
          void Function(StopShadowDeploymentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StopShadowDeploymentResponse))
          as StopShadowDeploymentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StopShadowDeploymentResponse() / StopShadowDeploymentResponse.new instead')
  static StopShadowDeploymentResponse create() =>
      StopShadowDeploymentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StopShadowDeploymentResponse._();
  @$core.override
  StopShadowDeploymentResponse createEmptyInstance() =>
      StopShadowDeploymentResponse._();
  @$core.pragma('dart2js:noInline')
  static StopShadowDeploymentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopShadowDeploymentResponse>(
          StopShadowDeploymentResponse.$_createMessage);
  static StopShadowDeploymentResponse? _defaultInstance;
}

class GetShadowSnapshotRequest extends $pb.GeneratedMessage {
  factory GetShadowSnapshotRequest({
    $fixnum.Int64? deploymentId,
  }) {
    final result = GetShadowSnapshotRequest._();
    if (deploymentId != null) result.deploymentId = deploymentId;
    return result;
  }

  GetShadowSnapshotRequest._();

  factory GetShadowSnapshotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetShadowSnapshotRequest()..mergeFromBuffer(data, registry);
  factory GetShadowSnapshotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetShadowSnapshotRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetShadowSnapshotRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetShadowSnapshotRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'deploymentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShadowSnapshotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShadowSnapshotRequest copyWith(
          void Function(GetShadowSnapshotRequest) updates) =>
      super.copyWith((message) => updates(message as GetShadowSnapshotRequest))
          as GetShadowSnapshotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetShadowSnapshotRequest() / GetShadowSnapshotRequest.new instead')
  static GetShadowSnapshotRequest create() => GetShadowSnapshotRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetShadowSnapshotRequest._();
  @$core.override
  GetShadowSnapshotRequest createEmptyInstance() =>
      GetShadowSnapshotRequest._();
  @$core.pragma('dart2js:noInline')
  static GetShadowSnapshotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetShadowSnapshotRequest>(
          GetShadowSnapshotRequest.$_createMessage);
  static GetShadowSnapshotRequest? _defaultInstance;

  /// Zero selects the active deployment or, if none is active, the most recent one.
  @$pb.TagNumber(1)
  $fixnum.Int64 get deploymentId => $_getI64(0);
  @$pb.TagNumber(1)
  set deploymentId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeploymentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeploymentId() => $_clearField(1);
}

class ShadowDeployment extends $pb.GeneratedMessage {
  factory ShadowDeployment({
    $fixnum.Int64? id,
    $core.String? symbol,
    $fixnum.Int64? ruleVersionId,
    $core.String? reportId,
    $fixnum.Int64? registeredAtUnixMs,
    $fixnum.Int64? startAtUnixMs,
    $fixnum.Int64? endAtUnixMs,
    ShadowState? state,
    $0.Money? capital,
    $0.Decimal? feeRate,
    $0.Decimal? slippageRate,
    $core.String? fillModel,
    $core.String? aiModel,
    $core.String? aiPromptVersion,
    $core.String? ruleContentHash,
    $core.String? engineBuild,
  }) {
    final result = ShadowDeployment._();
    if (id != null) result.id = id;
    if (symbol != null) result.symbol = symbol;
    if (ruleVersionId != null) result.ruleVersionId = ruleVersionId;
    if (reportId != null) result.reportId = reportId;
    if (registeredAtUnixMs != null)
      result.registeredAtUnixMs = registeredAtUnixMs;
    if (startAtUnixMs != null) result.startAtUnixMs = startAtUnixMs;
    if (endAtUnixMs != null) result.endAtUnixMs = endAtUnixMs;
    if (state != null) result.state = state;
    if (capital != null) result.capital = capital;
    if (feeRate != null) result.feeRate = feeRate;
    if (slippageRate != null) result.slippageRate = slippageRate;
    if (fillModel != null) result.fillModel = fillModel;
    if (aiModel != null) result.aiModel = aiModel;
    if (aiPromptVersion != null) result.aiPromptVersion = aiPromptVersion;
    if (ruleContentHash != null) result.ruleContentHash = ruleContentHash;
    if (engineBuild != null) result.engineBuild = engineBuild;
    return result;
  }

  ShadowDeployment._();

  factory ShadowDeployment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShadowDeployment()..mergeFromBuffer(data, registry);
  factory ShadowDeployment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShadowDeployment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShadowDeployment',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ShadowDeployment.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'symbol')
    ..aInt64(3, _omitFieldNames ? '' : 'ruleVersionId')
    ..aOS(4, _omitFieldNames ? '' : 'reportId')
    ..aInt64(5, _omitFieldNames ? '' : 'registeredAtUnixMs')
    ..aInt64(6, _omitFieldNames ? '' : 'startAtUnixMs')
    ..aInt64(7, _omitFieldNames ? '' : 'endAtUnixMs')
    ..aE<ShadowState>(8, _omitFieldNames ? '' : 'state',
        enumValues: ShadowState.values)
    ..aOM<$0.Money>(9, _omitFieldNames ? '' : 'capital',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(10, _omitFieldNames ? '' : 'feeRate',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(11, _omitFieldNames ? '' : 'slippageRate',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'fillModel')
    ..aOS(13, _omitFieldNames ? '' : 'aiModel')
    ..aOS(14, _omitFieldNames ? '' : 'aiPromptVersion')
    ..aOS(15, _omitFieldNames ? '' : 'ruleContentHash')
    ..aOS(16, _omitFieldNames ? '' : 'engineBuild')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShadowDeployment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShadowDeployment copyWith(void Function(ShadowDeployment) updates) =>
      super.copyWith((message) => updates(message as ShadowDeployment))
          as ShadowDeployment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ShadowDeployment() / ShadowDeployment.new instead')
  static ShadowDeployment create() => ShadowDeployment._();
  static $pb.GeneratedMessage $_createMessage() => ShadowDeployment._();
  @$core.override
  ShadowDeployment createEmptyInstance() => ShadowDeployment._();
  @$core.pragma('dart2js:noInline')
  static ShadowDeployment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShadowDeployment>(
          ShadowDeployment.$_createMessage);
  static ShadowDeployment? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get symbol => $_getSZ(1);
  @$pb.TagNumber(2)
  set symbol($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSymbol() => $_has(1);
  @$pb.TagNumber(2)
  void clearSymbol() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get ruleVersionId => $_getI64(2);
  @$pb.TagNumber(3)
  set ruleVersionId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRuleVersionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuleVersionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reportId => $_getSZ(3);
  @$pb.TagNumber(4)
  set reportId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReportId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReportId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get registeredAtUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set registeredAtUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRegisteredAtUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearRegisteredAtUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get startAtUnixMs => $_getI64(5);
  @$pb.TagNumber(6)
  set startAtUnixMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStartAtUnixMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartAtUnixMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get endAtUnixMs => $_getI64(6);
  @$pb.TagNumber(7)
  set endAtUnixMs($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEndAtUnixMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearEndAtUnixMs() => $_clearField(7);

  @$pb.TagNumber(8)
  ShadowState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(ShadowState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Money get capital => $_getN(8);
  @$pb.TagNumber(9)
  set capital($0.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCapital() => $_has(8);
  @$pb.TagNumber(9)
  void clearCapital() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Money ensureCapital() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Decimal get feeRate => $_getN(9);
  @$pb.TagNumber(10)
  set feeRate($0.Decimal value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasFeeRate() => $_has(9);
  @$pb.TagNumber(10)
  void clearFeeRate() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Decimal ensureFeeRate() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Decimal get slippageRate => $_getN(10);
  @$pb.TagNumber(11)
  set slippageRate($0.Decimal value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasSlippageRate() => $_has(10);
  @$pb.TagNumber(11)
  void clearSlippageRate() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Decimal ensureSlippageRate() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get fillModel => $_getSZ(11);
  @$pb.TagNumber(12)
  set fillModel($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFillModel() => $_has(11);
  @$pb.TagNumber(12)
  void clearFillModel() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get aiModel => $_getSZ(12);
  @$pb.TagNumber(13)
  set aiModel($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAiModel() => $_has(12);
  @$pb.TagNumber(13)
  void clearAiModel() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get aiPromptVersion => $_getSZ(13);
  @$pb.TagNumber(14)
  set aiPromptVersion($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAiPromptVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearAiPromptVersion() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get ruleContentHash => $_getSZ(14);
  @$pb.TagNumber(15)
  set ruleContentHash($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRuleContentHash() => $_has(14);
  @$pb.TagNumber(15)
  void clearRuleContentHash() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get engineBuild => $_getSZ(15);
  @$pb.TagNumber(16)
  set engineBuild($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasEngineBuild() => $_has(15);
  @$pb.TagNumber(16)
  void clearEngineBuild() => $_clearField(16);
}

class ShadowObservation extends $pb.GeneratedMessage {
  factory ShadowObservation({
    $fixnum.Int64? candleClosedAtUnixMs,
    $fixnum.Int64? observedAtUnixMs,
    $fixnum.Int64? decisionAtUnixMs,
    ShadowGate? gate,
    $0.Money? referenceClose,
    $fixnum.Int64? gateResolvedAtUnixMs,
  }) {
    final result = ShadowObservation._();
    if (candleClosedAtUnixMs != null)
      result.candleClosedAtUnixMs = candleClosedAtUnixMs;
    if (observedAtUnixMs != null) result.observedAtUnixMs = observedAtUnixMs;
    if (decisionAtUnixMs != null) result.decisionAtUnixMs = decisionAtUnixMs;
    if (gate != null) result.gate = gate;
    if (referenceClose != null) result.referenceClose = referenceClose;
    if (gateResolvedAtUnixMs != null)
      result.gateResolvedAtUnixMs = gateResolvedAtUnixMs;
    return result;
  }

  ShadowObservation._();

  factory ShadowObservation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShadowObservation()..mergeFromBuffer(data, registry);
  factory ShadowObservation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShadowObservation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShadowObservation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ShadowObservation.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'candleClosedAtUnixMs')
    ..aInt64(2, _omitFieldNames ? '' : 'observedAtUnixMs')
    ..aInt64(3, _omitFieldNames ? '' : 'decisionAtUnixMs')
    ..aE<ShadowGate>(4, _omitFieldNames ? '' : 'gate',
        enumValues: ShadowGate.values)
    ..aOM<$0.Money>(5, _omitFieldNames ? '' : 'referenceClose',
        subBuilder: $0.Money.$_createMessage)
    ..aInt64(6, _omitFieldNames ? '' : 'gateResolvedAtUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShadowObservation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShadowObservation copyWith(void Function(ShadowObservation) updates) =>
      super.copyWith((message) => updates(message as ShadowObservation))
          as ShadowObservation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ShadowObservation() / ShadowObservation.new instead')
  static ShadowObservation create() => ShadowObservation._();
  static $pb.GeneratedMessage $_createMessage() => ShadowObservation._();
  @$core.override
  ShadowObservation createEmptyInstance() => ShadowObservation._();
  @$core.pragma('dart2js:noInline')
  static ShadowObservation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShadowObservation>(
          ShadowObservation.$_createMessage);
  static ShadowObservation? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get candleClosedAtUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set candleClosedAtUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCandleClosedAtUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandleClosedAtUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get observedAtUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set observedAtUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasObservedAtUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservedAtUnixMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get decisionAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set decisionAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDecisionAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearDecisionAtUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  ShadowGate get gate => $_getN(3);
  @$pb.TagNumber(4)
  set gate(ShadowGate value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasGate() => $_has(3);
  @$pb.TagNumber(4)
  void clearGate() => $_clearField(4);

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
  $fixnum.Int64 get gateResolvedAtUnixMs => $_getI64(5);
  @$pb.TagNumber(6)
  set gateResolvedAtUnixMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGateResolvedAtUnixMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearGateResolvedAtUnixMs() => $_clearField(6);
}

class ShadowTrack extends $pb.GeneratedMessage {
  factory ShadowTrack({
    $core.Iterable<$0.Metric>? metrics,
    $core.int? entries,
  }) {
    final result = ShadowTrack._();
    if (metrics != null) result.metrics.addAll(metrics);
    if (entries != null) result.entries = entries;
    return result;
  }

  ShadowTrack._();

  factory ShadowTrack.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShadowTrack()..mergeFromBuffer(data, registry);
  factory ShadowTrack.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShadowTrack()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShadowTrack',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ShadowTrack.$_createMessage)
    ..pPM<$0.Metric>(1, _omitFieldNames ? '' : 'metrics',
        subBuilder: $0.Metric.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'entries')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShadowTrack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShadowTrack copyWith(void Function(ShadowTrack) updates) =>
      super.copyWith((message) => updates(message as ShadowTrack))
          as ShadowTrack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ShadowTrack() / ShadowTrack.new instead')
  static ShadowTrack create() => ShadowTrack._();
  static $pb.GeneratedMessage $_createMessage() => ShadowTrack._();
  @$core.override
  ShadowTrack createEmptyInstance() => ShadowTrack._();
  @$core.pragma('dart2js:noInline')
  static ShadowTrack getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShadowTrack>(
          ShadowTrack.$_createMessage);
  static ShadowTrack? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.Metric> get metrics => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get entries => $_getIZ(1);
  @$pb.TagNumber(2)
  set entries($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEntries() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntries() => $_clearField(2);
}

class GetShadowSnapshotResponse extends $pb.GeneratedMessage {
  factory GetShadowSnapshotResponse({
    $core.Iterable<ShadowDeployment>? deployments,
    ShadowDeployment? selected,
    $core.Iterable<ShadowObservation>? observations,
    ShadowTrack? baseline,
    ShadowTrack? ai,
    $core.int? sampledHours,
    $fixnum.Int64? inputTokens,
    $fixnum.Int64? outputTokens,
    $core.Iterable<$core.String>? symbols,
    $core.bool? assistantEnabled,
  }) {
    final result = GetShadowSnapshotResponse._();
    if (deployments != null) result.deployments.addAll(deployments);
    if (selected != null) result.selected = selected;
    if (observations != null) result.observations.addAll(observations);
    if (baseline != null) result.baseline = baseline;
    if (ai != null) result.ai = ai;
    if (sampledHours != null) result.sampledHours = sampledHours;
    if (inputTokens != null) result.inputTokens = inputTokens;
    if (outputTokens != null) result.outputTokens = outputTokens;
    if (symbols != null) result.symbols.addAll(symbols);
    if (assistantEnabled != null) result.assistantEnabled = assistantEnabled;
    return result;
  }

  GetShadowSnapshotResponse._();

  factory GetShadowSnapshotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetShadowSnapshotResponse()..mergeFromBuffer(data, registry);
  factory GetShadowSnapshotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetShadowSnapshotResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetShadowSnapshotResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetShadowSnapshotResponse.$_createMessage)
    ..pPM<ShadowDeployment>(1, _omitFieldNames ? '' : 'deployments',
        subBuilder: ShadowDeployment.$_createMessage)
    ..aOM<ShadowDeployment>(2, _omitFieldNames ? '' : 'selected',
        subBuilder: ShadowDeployment.$_createMessage)
    ..pPM<ShadowObservation>(3, _omitFieldNames ? '' : 'observations',
        subBuilder: ShadowObservation.$_createMessage)
    ..aOM<ShadowTrack>(4, _omitFieldNames ? '' : 'baseline',
        subBuilder: ShadowTrack.$_createMessage)
    ..aOM<ShadowTrack>(5, _omitFieldNames ? '' : 'ai',
        subBuilder: ShadowTrack.$_createMessage)
    ..aI(6, _omitFieldNames ? '' : 'sampledHours')
    ..aInt64(7, _omitFieldNames ? '' : 'inputTokens')
    ..aInt64(8, _omitFieldNames ? '' : 'outputTokens')
    ..pPS(9, _omitFieldNames ? '' : 'symbols')
    ..aOB(10, _omitFieldNames ? '' : 'assistantEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShadowSnapshotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShadowSnapshotResponse copyWith(
          void Function(GetShadowSnapshotResponse) updates) =>
      super.copyWith((message) => updates(message as GetShadowSnapshotResponse))
          as GetShadowSnapshotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetShadowSnapshotResponse() / GetShadowSnapshotResponse.new instead')
  static GetShadowSnapshotResponse create() => GetShadowSnapshotResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetShadowSnapshotResponse._();
  @$core.override
  GetShadowSnapshotResponse createEmptyInstance() =>
      GetShadowSnapshotResponse._();
  @$core.pragma('dart2js:noInline')
  static GetShadowSnapshotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetShadowSnapshotResponse>(
          GetShadowSnapshotResponse.$_createMessage);
  static GetShadowSnapshotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ShadowDeployment> get deployments => $_getList(0);

  @$pb.TagNumber(2)
  ShadowDeployment get selected => $_getN(1);
  @$pb.TagNumber(2)
  set selected(ShadowDeployment value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSelected() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelected() => $_clearField(2);
  @$pb.TagNumber(2)
  ShadowDeployment ensureSelected() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<ShadowObservation> get observations => $_getList(2);

  @$pb.TagNumber(4)
  ShadowTrack get baseline => $_getN(3);
  @$pb.TagNumber(4)
  set baseline(ShadowTrack value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBaseline() => $_has(3);
  @$pb.TagNumber(4)
  void clearBaseline() => $_clearField(4);
  @$pb.TagNumber(4)
  ShadowTrack ensureBaseline() => $_ensure(3);

  @$pb.TagNumber(5)
  ShadowTrack get ai => $_getN(4);
  @$pb.TagNumber(5)
  set ai(ShadowTrack value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAi() => $_has(4);
  @$pb.TagNumber(5)
  void clearAi() => $_clearField(5);
  @$pb.TagNumber(5)
  ShadowTrack ensureAi() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get sampledHours => $_getIZ(5);
  @$pb.TagNumber(6)
  set sampledHours($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSampledHours() => $_has(5);
  @$pb.TagNumber(6)
  void clearSampledHours() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get inputTokens => $_getI64(6);
  @$pb.TagNumber(7)
  set inputTokens($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasInputTokens() => $_has(6);
  @$pb.TagNumber(7)
  void clearInputTokens() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get outputTokens => $_getI64(7);
  @$pb.TagNumber(8)
  set outputTokens($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOutputTokens() => $_has(7);
  @$pb.TagNumber(8)
  void clearOutputTokens() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get symbols => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get assistantEnabled => $_getBF(9);
  @$pb.TagNumber(10)
  set assistantEnabled($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAssistantEnabled() => $_has(9);
  @$pb.TagNumber(10)
  void clearAssistantEnabled() => $_clearField(10);
}

class ShadowServiceApi {
  final $pb.RpcClient _client;

  ShadowServiceApi(this._client);

  $async.Future<StartShadowDeploymentResponse> startShadowDeployment(
          $pb.ClientContext? ctx, StartShadowDeploymentRequest request) =>
      _client.invoke<StartShadowDeploymentResponse>(ctx, 'ShadowService',
          'StartShadowDeployment', request, StartShadowDeploymentResponse());
  $async.Future<StopShadowDeploymentResponse> stopShadowDeployment(
          $pb.ClientContext? ctx, StopShadowDeploymentRequest request) =>
      _client.invoke<StopShadowDeploymentResponse>(ctx, 'ShadowService',
          'StopShadowDeployment', request, StopShadowDeploymentResponse());
  $async.Future<GetShadowSnapshotResponse> getShadowSnapshot(
          $pb.ClientContext? ctx, GetShadowSnapshotRequest request) =>
      _client.invoke<GetShadowSnapshotResponse>(ctx, 'ShadowService',
          'GetShadowSnapshot', request, GetShadowSnapshotResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
