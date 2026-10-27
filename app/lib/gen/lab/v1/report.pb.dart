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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ParamSpec extends $pb.GeneratedMessage {
  factory ParamSpec({
    $core.String? name,
    $core.double? default_2,
    $core.bool? integer,
  }) {
    final result = ParamSpec._();
    if (name != null) result.name = name;
    if (default_2 != null) result.default_2 = default_2;
    if (integer != null) result.integer = integer;
    return result;
  }

  ParamSpec._();

  factory ParamSpec.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ParamSpec()..mergeFromBuffer(data, registry);
  factory ParamSpec.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ParamSpec()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParamSpec',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ParamSpec.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aD(2, _omitFieldNames ? '' : 'default')
    ..aOB(3, _omitFieldNames ? '' : 'integer')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParamSpec clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParamSpec copyWith(void Function(ParamSpec) updates) =>
      super.copyWith((message) => updates(message as ParamSpec)) as ParamSpec;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ParamSpec() / ParamSpec.new instead')
  static ParamSpec create() => ParamSpec._();
  static $pb.GeneratedMessage $_createMessage() => ParamSpec._();
  @$core.override
  ParamSpec createEmptyInstance() => ParamSpec._();
  @$core.pragma('dart2js:noInline')
  static ParamSpec getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParamSpec>(ParamSpec.$_createMessage);
  static ParamSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get default_2 => $_getN(1);
  @$pb.TagNumber(2)
  set default_2($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefault_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefault_2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get integer => $_getBF(2);
  @$pb.TagNumber(3)
  set integer($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInteger() => $_has(2);
  @$pb.TagNumber(3)
  void clearInteger() => $_clearField(3);
}

class StrategyInfo extends $pb.GeneratedMessage {
  factory StrategyInfo({
    $core.String? name,
    $core.Iterable<ParamSpec>? params,
  }) {
    final result = StrategyInfo._();
    if (name != null) result.name = name;
    if (params != null) result.params.addAll(params);
    return result;
  }

  StrategyInfo._();

  factory StrategyInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StrategyInfo()..mergeFromBuffer(data, registry);
  factory StrategyInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StrategyInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StrategyInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StrategyInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..pPM<ParamSpec>(2, _omitFieldNames ? '' : 'params',
        subBuilder: ParamSpec.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StrategyInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StrategyInfo copyWith(void Function(StrategyInfo) updates) =>
      super.copyWith((message) => updates(message as StrategyInfo))
          as StrategyInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StrategyInfo() / StrategyInfo.new instead')
  static StrategyInfo create() => StrategyInfo._();
  static $pb.GeneratedMessage $_createMessage() => StrategyInfo._();
  @$core.override
  StrategyInfo createEmptyInstance() => StrategyInfo._();
  @$core.pragma('dart2js:noInline')
  static StrategyInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StrategyInfo>(
          StrategyInfo.$_createMessage);
  static StrategyInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ParamSpec> get params => $_getList(1);
}

class ListStrategiesRequest extends $pb.GeneratedMessage {
  factory ListStrategiesRequest() => ListStrategiesRequest._();

  ListStrategiesRequest._();

  factory ListStrategiesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStrategiesRequest()..mergeFromBuffer(data, registry);
  factory ListStrategiesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStrategiesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStrategiesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListStrategiesRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStrategiesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStrategiesRequest copyWith(
          void Function(ListStrategiesRequest) updates) =>
      super.copyWith((message) => updates(message as ListStrategiesRequest))
          as ListStrategiesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListStrategiesRequest() / ListStrategiesRequest.new instead')
  static ListStrategiesRequest create() => ListStrategiesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListStrategiesRequest._();
  @$core.override
  ListStrategiesRequest createEmptyInstance() => ListStrategiesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListStrategiesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStrategiesRequest>(
          ListStrategiesRequest.$_createMessage);
  static ListStrategiesRequest? _defaultInstance;
}

class ListStrategiesResponse extends $pb.GeneratedMessage {
  factory ListStrategiesResponse({
    $core.Iterable<StrategyInfo>? strategies,
  }) {
    final result = ListStrategiesResponse._();
    if (strategies != null) result.strategies.addAll(strategies);
    return result;
  }

  ListStrategiesResponse._();

  factory ListStrategiesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStrategiesResponse()..mergeFromBuffer(data, registry);
  factory ListStrategiesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStrategiesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStrategiesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListStrategiesResponse.$_createMessage)
    ..pPM<StrategyInfo>(1, _omitFieldNames ? '' : 'strategies',
        subBuilder: StrategyInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStrategiesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStrategiesResponse copyWith(
          void Function(ListStrategiesResponse) updates) =>
      super.copyWith((message) => updates(message as ListStrategiesResponse))
          as ListStrategiesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListStrategiesResponse() / ListStrategiesResponse.new instead')
  static ListStrategiesResponse create() => ListStrategiesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListStrategiesResponse._();
  @$core.override
  ListStrategiesResponse createEmptyInstance() => ListStrategiesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListStrategiesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStrategiesResponse>(
          ListStrategiesResponse.$_createMessage);
  static ListStrategiesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StrategyInfo> get strategies => $_getList(0);
}

class ReportSpec extends $pb.GeneratedMessage {
  factory ReportSpec({
    $core.Iterable<$core.String>? datasetIds,
    $core.String? timeframe,
    $core.String? strategy,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? params,
    $0.Money? capital,
    $0.Decimal? fee,
    $0.Decimal? slippage,
    $core.String? sizing,
    $0.Money? fixedUsdt,
    $core.int? latencyBars,
    $core.int? folds,
    $core.bool? rolling,
    $0.Decimal? holdout,
    $fixnum.Int64? embargoSeconds,
    $core.String? engineVersion,
  }) {
    final result = ReportSpec._();
    if (datasetIds != null) result.datasetIds.addAll(datasetIds);
    if (timeframe != null) result.timeframe = timeframe;
    if (strategy != null) result.strategy = strategy;
    if (params != null) result.params.addEntries(params);
    if (capital != null) result.capital = capital;
    if (fee != null) result.fee = fee;
    if (slippage != null) result.slippage = slippage;
    if (sizing != null) result.sizing = sizing;
    if (fixedUsdt != null) result.fixedUsdt = fixedUsdt;
    if (latencyBars != null) result.latencyBars = latencyBars;
    if (folds != null) result.folds = folds;
    if (rolling != null) result.rolling = rolling;
    if (holdout != null) result.holdout = holdout;
    if (embargoSeconds != null) result.embargoSeconds = embargoSeconds;
    if (engineVersion != null) result.engineVersion = engineVersion;
    return result;
  }

  ReportSpec._();

  factory ReportSpec.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportSpec()..mergeFromBuffer(data, registry);
  factory ReportSpec.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportSpec()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportSpec',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ReportSpec.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'datasetIds')
    ..aOS(2, _omitFieldNames ? '' : 'timeframe')
    ..aOS(3, _omitFieldNames ? '' : 'strategy')
    ..m<$core.String, $core.double>(4, _omitFieldNames ? '' : 'params',
        entryClassName: 'ReportSpec.ParamsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('lab.v1'))
    ..aOM<$0.Money>(5, _omitFieldNames ? '' : 'capital',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(6, _omitFieldNames ? '' : 'fee',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(7, _omitFieldNames ? '' : 'slippage',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'sizing')
    ..aOM<$0.Money>(9, _omitFieldNames ? '' : 'fixedUsdt',
        subBuilder: $0.Money.$_createMessage)
    ..aI(10, _omitFieldNames ? '' : 'latencyBars')
    ..aI(11, _omitFieldNames ? '' : 'folds')
    ..aOB(12, _omitFieldNames ? '' : 'rolling')
    ..aOM<$0.Decimal>(13, _omitFieldNames ? '' : 'holdout',
        subBuilder: $0.Decimal.$_createMessage)
    ..aInt64(14, _omitFieldNames ? '' : 'embargoSeconds')
    ..aOS(15, _omitFieldNames ? '' : 'engineVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportSpec clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportSpec copyWith(void Function(ReportSpec) updates) =>
      super.copyWith((message) => updates(message as ReportSpec)) as ReportSpec;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReportSpec() / ReportSpec.new instead')
  static ReportSpec create() => ReportSpec._();
  static $pb.GeneratedMessage $_createMessage() => ReportSpec._();
  @$core.override
  ReportSpec createEmptyInstance() => ReportSpec._();
  @$core.pragma('dart2js:noInline')
  static ReportSpec getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportSpec>(ReportSpec.$_createMessage);
  static ReportSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get datasetIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get timeframe => $_getSZ(1);
  @$pb.TagNumber(2)
  set timeframe($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeframe() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeframe() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get strategy => $_getSZ(2);
  @$pb.TagNumber(3)
  set strategy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStrategy() => $_has(2);
  @$pb.TagNumber(3)
  void clearStrategy() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.double> get params => $_getMap(3);

  @$pb.TagNumber(5)
  $0.Money get capital => $_getN(4);
  @$pb.TagNumber(5)
  set capital($0.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCapital() => $_has(4);
  @$pb.TagNumber(5)
  void clearCapital() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Money ensureCapital() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Decimal get fee => $_getN(5);
  @$pb.TagNumber(6)
  set fee($0.Decimal value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFee() => $_has(5);
  @$pb.TagNumber(6)
  void clearFee() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Decimal ensureFee() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Decimal get slippage => $_getN(6);
  @$pb.TagNumber(7)
  set slippage($0.Decimal value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSlippage() => $_has(6);
  @$pb.TagNumber(7)
  void clearSlippage() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Decimal ensureSlippage() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get sizing => $_getSZ(7);
  @$pb.TagNumber(8)
  set sizing($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSizing() => $_has(7);
  @$pb.TagNumber(8)
  void clearSizing() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Money get fixedUsdt => $_getN(8);
  @$pb.TagNumber(9)
  set fixedUsdt($0.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasFixedUsdt() => $_has(8);
  @$pb.TagNumber(9)
  void clearFixedUsdt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Money ensureFixedUsdt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get latencyBars => $_getIZ(9);
  @$pb.TagNumber(10)
  set latencyBars($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLatencyBars() => $_has(9);
  @$pb.TagNumber(10)
  void clearLatencyBars() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get folds => $_getIZ(10);
  @$pb.TagNumber(11)
  set folds($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasFolds() => $_has(10);
  @$pb.TagNumber(11)
  void clearFolds() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get rolling => $_getBF(11);
  @$pb.TagNumber(12)
  set rolling($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRolling() => $_has(11);
  @$pb.TagNumber(12)
  void clearRolling() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Decimal get holdout => $_getN(12);
  @$pb.TagNumber(13)
  set holdout($0.Decimal value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasHoldout() => $_has(12);
  @$pb.TagNumber(13)
  void clearHoldout() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Decimal ensureHoldout() => $_ensure(12);

  @$pb.TagNumber(14)
  $fixnum.Int64 get embargoSeconds => $_getI64(13);
  @$pb.TagNumber(14)
  set embargoSeconds($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasEmbargoSeconds() => $_has(13);
  @$pb.TagNumber(14)
  void clearEmbargoSeconds() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get engineVersion => $_getSZ(14);
  @$pb.TagNumber(15)
  set engineVersion($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasEngineVersion() => $_has(14);
  @$pb.TagNumber(15)
  void clearEngineVersion() => $_clearField(15);
}

class CreateReportRequest extends $pb.GeneratedMessage {
  factory CreateReportRequest({
    ReportSpec? spec,
  }) {
    final result = CreateReportRequest._();
    if (spec != null) result.spec = spec;
    return result;
  }

  CreateReportRequest._();

  factory CreateReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateReportRequest()..mergeFromBuffer(data, registry);
  factory CreateReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CreateReportRequest.$_createMessage)
    ..aOM<ReportSpec>(1, _omitFieldNames ? '' : 'spec',
        subBuilder: ReportSpec.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReportRequest copyWith(void Function(CreateReportRequest) updates) =>
      super.copyWith((message) => updates(message as CreateReportRequest))
          as CreateReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CreateReportRequest() / CreateReportRequest.new instead')
  static CreateReportRequest create() => CreateReportRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateReportRequest._();
  @$core.override
  CreateReportRequest createEmptyInstance() => CreateReportRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateReportRequest>(
          CreateReportRequest.$_createMessage);
  static CreateReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ReportSpec get spec => $_getN(0);
  @$pb.TagNumber(1)
  set spec(ReportSpec value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSpec() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpec() => $_clearField(1);
  @$pb.TagNumber(1)
  ReportSpec ensureSpec() => $_ensure(0);
}

class CreateReportResponse extends $pb.GeneratedMessage {
  factory CreateReportResponse({
    $core.String? reportId,
  }) {
    final result = CreateReportResponse._();
    if (reportId != null) result.reportId = reportId;
    return result;
  }

  CreateReportResponse._();

  factory CreateReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateReportResponse()..mergeFromBuffer(data, registry);
  factory CreateReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CreateReportResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReportResponse copyWith(void Function(CreateReportResponse) updates) =>
      super.copyWith((message) => updates(message as CreateReportResponse))
          as CreateReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateReportResponse() / CreateReportResponse.new instead')
  static CreateReportResponse create() => CreateReportResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateReportResponse._();
  @$core.override
  CreateReportResponse createEmptyInstance() => CreateReportResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateReportResponse>(
          CreateReportResponse.$_createMessage);
  static CreateReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);
}

class ReportListItem extends $pb.GeneratedMessage {
  factory ReportListItem({
    $core.String? id,
    $core.String? title,
    $fixnum.Int64? createdUnixMs,
    $0.Money? net,
    $0.Decimal? totalReturn,
    $core.int? closedTrades,
    $core.String? verdict,
    $core.String? tone,
    $core.int? holdoutViews,
  }) {
    final result = ReportListItem._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (createdUnixMs != null) result.createdUnixMs = createdUnixMs;
    if (net != null) result.net = net;
    if (totalReturn != null) result.totalReturn = totalReturn;
    if (closedTrades != null) result.closedTrades = closedTrades;
    if (verdict != null) result.verdict = verdict;
    if (tone != null) result.tone = tone;
    if (holdoutViews != null) result.holdoutViews = holdoutViews;
    return result;
  }

  ReportListItem._();

  factory ReportListItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportListItem()..mergeFromBuffer(data, registry);
  factory ReportListItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportListItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportListItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ReportListItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aInt64(3, _omitFieldNames ? '' : 'createdUnixMs')
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'net',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(5, _omitFieldNames ? '' : 'totalReturn',
        subBuilder: $0.Decimal.$_createMessage)
    ..aI(6, _omitFieldNames ? '' : 'closedTrades')
    ..aOS(7, _omitFieldNames ? '' : 'verdict')
    ..aOS(8, _omitFieldNames ? '' : 'tone')
    ..aI(9, _omitFieldNames ? '' : 'holdoutViews')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportListItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportListItem copyWith(void Function(ReportListItem) updates) =>
      super.copyWith((message) => updates(message as ReportListItem))
          as ReportListItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReportListItem() / ReportListItem.new instead')
  static ReportListItem create() => ReportListItem._();
  static $pb.GeneratedMessage $_createMessage() => ReportListItem._();
  @$core.override
  ReportListItem createEmptyInstance() => ReportListItem._();
  @$core.pragma('dart2js:noInline')
  static ReportListItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportListItem>(
          ReportListItem.$_createMessage);
  static ReportListItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
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
  $fixnum.Int64 get createdUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set createdUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Money get net => $_getN(3);
  @$pb.TagNumber(4)
  set net($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNet() => $_has(3);
  @$pb.TagNumber(4)
  void clearNet() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureNet() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Decimal get totalReturn => $_getN(4);
  @$pb.TagNumber(5)
  set totalReturn($0.Decimal value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalReturn() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalReturn() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Decimal ensureTotalReturn() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get closedTrades => $_getIZ(5);
  @$pb.TagNumber(6)
  set closedTrades($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasClosedTrades() => $_has(5);
  @$pb.TagNumber(6)
  void clearClosedTrades() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get verdict => $_getSZ(6);
  @$pb.TagNumber(7)
  set verdict($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVerdict() => $_has(6);
  @$pb.TagNumber(7)
  void clearVerdict() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get tone => $_getSZ(7);
  @$pb.TagNumber(8)
  set tone($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTone() => $_has(7);
  @$pb.TagNumber(8)
  void clearTone() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get holdoutViews => $_getIZ(8);
  @$pb.TagNumber(9)
  set holdoutViews($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHoldoutViews() => $_has(8);
  @$pb.TagNumber(9)
  void clearHoldoutViews() => $_clearField(9);
}

class ListReportsRequest extends $pb.GeneratedMessage {
  factory ListReportsRequest({
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = ListReportsRequest._();
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListReportsRequest._();

  factory ListReportsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListReportsRequest()..mergeFromBuffer(data, registry);
  factory ListReportsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListReportsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReportsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListReportsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aI(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReportsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReportsRequest copyWith(void Function(ListReportsRequest) updates) =>
      super.copyWith((message) => updates(message as ListReportsRequest))
          as ListReportsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListReportsRequest() / ListReportsRequest.new instead')
  static ListReportsRequest create() => ListReportsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListReportsRequest._();
  @$core.override
  ListReportsRequest createEmptyInstance() => ListReportsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListReportsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReportsRequest>(
          ListReportsRequest.$_createMessage);
  static ListReportsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get offset => $_getIZ(1);
  @$pb.TagNumber(2)
  set offset($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

class ListReportsResponse extends $pb.GeneratedMessage {
  factory ListReportsResponse({
    $core.Iterable<ReportListItem>? reports,
    $fixnum.Int64? total,
  }) {
    final result = ListReportsResponse._();
    if (reports != null) result.reports.addAll(reports);
    if (total != null) result.total = total;
    return result;
  }

  ListReportsResponse._();

  factory ListReportsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListReportsResponse()..mergeFromBuffer(data, registry);
  factory ListReportsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListReportsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReportsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListReportsResponse.$_createMessage)
    ..pPM<ReportListItem>(1, _omitFieldNames ? '' : 'reports',
        subBuilder: ReportListItem.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReportsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReportsResponse copyWith(void Function(ListReportsResponse) updates) =>
      super.copyWith((message) => updates(message as ListReportsResponse))
          as ListReportsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListReportsResponse() / ListReportsResponse.new instead')
  static ListReportsResponse create() => ListReportsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListReportsResponse._();
  @$core.override
  ListReportsResponse createEmptyInstance() => ListReportsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListReportsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReportsResponse>(
          ListReportsResponse.$_createMessage);
  static ListReportsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReportListItem> get reports => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class Window extends $pb.GeneratedMessage {
  factory Window({
    $fixnum.Int64? fromUnixMs,
    $fixnum.Int64? toUnixMs,
  }) {
    final result = Window._();
    if (fromUnixMs != null) result.fromUnixMs = fromUnixMs;
    if (toUnixMs != null) result.toUnixMs = toUnixMs;
    return result;
  }

  Window._();

  factory Window.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Window()..mergeFromBuffer(data, registry);
  factory Window.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Window()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Window',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Window.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'fromUnixMs')
    ..aInt64(2, _omitFieldNames ? '' : 'toUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Window clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Window copyWith(void Function(Window) updates) =>
      super.copyWith((message) => updates(message as Window)) as Window;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Window() / Window.new instead')
  static Window create() => Window._();
  static $pb.GeneratedMessage $_createMessage() => Window._();
  @$core.override
  Window createEmptyInstance() => Window._();
  @$core.pragma('dart2js:noInline')
  static Window getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Window>(Window.$_createMessage);
  static Window? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fromUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set fromUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get toUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set toUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUnixMs() => $_clearField(2);
}

class RunView extends $pb.GeneratedMessage {
  factory RunView({
    Window? window,
    $core.Iterable<$0.Metric>? metrics,
    $core.Iterable<$0.EquityPoint>? equity,
    $core.int? ambiguousBars,
  }) {
    final result = RunView._();
    if (window != null) result.window = window;
    if (metrics != null) result.metrics.addAll(metrics);
    if (equity != null) result.equity.addAll(equity);
    if (ambiguousBars != null) result.ambiguousBars = ambiguousBars;
    return result;
  }

  RunView._();

  factory RunView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunView()..mergeFromBuffer(data, registry);
  factory RunView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunView()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunView',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RunView.$_createMessage)
    ..aOM<Window>(1, _omitFieldNames ? '' : 'window',
        subBuilder: Window.$_createMessage)
    ..pPM<$0.Metric>(2, _omitFieldNames ? '' : 'metrics',
        subBuilder: $0.Metric.$_createMessage)
    ..pPM<$0.EquityPoint>(3, _omitFieldNames ? '' : 'equity',
        subBuilder: $0.EquityPoint.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'ambiguousBars')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunView clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunView copyWith(void Function(RunView) updates) =>
      super.copyWith((message) => updates(message as RunView)) as RunView;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RunView() / RunView.new instead')
  static RunView create() => RunView._();
  static $pb.GeneratedMessage $_createMessage() => RunView._();
  @$core.override
  RunView createEmptyInstance() => RunView._();
  @$core.pragma('dart2js:noInline')
  static RunView getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunView>(RunView.$_createMessage);
  static RunView? _defaultInstance;

  @$pb.TagNumber(1)
  Window get window => $_getN(0);
  @$pb.TagNumber(1)
  set window(Window value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWindow() => $_has(0);
  @$pb.TagNumber(1)
  void clearWindow() => $_clearField(1);
  @$pb.TagNumber(1)
  Window ensureWindow() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$0.Metric> get metrics => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$0.EquityPoint> get equity => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get ambiguousBars => $_getIZ(3);
  @$pb.TagNumber(4)
  set ambiguousBars($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmbiguousBars() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmbiguousBars() => $_clearField(4);
}

class FoldView extends $pb.GeneratedMessage {
  factory FoldView({
    $core.int? index,
    Window? train,
    Window? test,
    $core.Iterable<$0.Metric>? metrics,
  }) {
    final result = FoldView._();
    if (index != null) result.index = index;
    if (train != null) result.train = train;
    if (test != null) result.test = test;
    if (metrics != null) result.metrics.addAll(metrics);
    return result;
  }

  FoldView._();

  factory FoldView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FoldView()..mergeFromBuffer(data, registry);
  factory FoldView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FoldView()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FoldView',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: FoldView.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'index')
    ..aOM<Window>(2, _omitFieldNames ? '' : 'train',
        subBuilder: Window.$_createMessage)
    ..aOM<Window>(3, _omitFieldNames ? '' : 'test',
        subBuilder: Window.$_createMessage)
    ..pPM<$0.Metric>(4, _omitFieldNames ? '' : 'metrics',
        subBuilder: $0.Metric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FoldView clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FoldView copyWith(void Function(FoldView) updates) =>
      super.copyWith((message) => updates(message as FoldView)) as FoldView;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FoldView() / FoldView.new instead')
  static FoldView create() => FoldView._();
  static $pb.GeneratedMessage $_createMessage() => FoldView._();
  @$core.override
  FoldView createEmptyInstance() => FoldView._();
  @$core.pragma('dart2js:noInline')
  static FoldView getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FoldView>(FoldView.$_createMessage);
  static FoldView? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  Window get train => $_getN(1);
  @$pb.TagNumber(2)
  set train(Window value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTrain() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrain() => $_clearField(2);
  @$pb.TagNumber(2)
  Window ensureTrain() => $_ensure(1);

  @$pb.TagNumber(3)
  Window get test => $_getN(2);
  @$pb.TagNumber(3)
  set test(Window value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTest() => $_has(2);
  @$pb.TagNumber(3)
  void clearTest() => $_clearField(3);
  @$pb.TagNumber(3)
  Window ensureTest() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<$0.Metric> get metrics => $_getList(3);
}

class StressView extends $pb.GeneratedMessage {
  factory StressView({
    $core.String? key,
    $core.Iterable<$0.Metric>? metrics,
    $core.String? error,
  }) {
    final result = StressView._();
    if (key != null) result.key = key;
    if (metrics != null) result.metrics.addAll(metrics);
    if (error != null) result.error = error;
    return result;
  }

  StressView._();

  factory StressView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StressView()..mergeFromBuffer(data, registry);
  factory StressView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StressView()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StressView',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StressView.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..pPM<$0.Metric>(2, _omitFieldNames ? '' : 'metrics',
        subBuilder: $0.Metric.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StressView clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StressView copyWith(void Function(StressView) updates) =>
      super.copyWith((message) => updates(message as StressView)) as StressView;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StressView() / StressView.new instead')
  static StressView create() => StressView._();
  static $pb.GeneratedMessage $_createMessage() => StressView._();
  @$core.override
  StressView createEmptyInstance() => StressView._();
  @$core.pragma('dart2js:noInline')
  static StressView getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StressView>(StressView.$_createMessage);
  static StressView? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$0.Metric> get metrics => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
}

class GridCell extends $pb.GeneratedMessage {
  factory GridCell({
    $0.Metric? totalReturn,
    $core.bool? center,
    $core.String? invalid,
  }) {
    final result = GridCell._();
    if (totalReturn != null) result.totalReturn = totalReturn;
    if (center != null) result.center = center;
    if (invalid != null) result.invalid = invalid;
    return result;
  }

  GridCell._();

  factory GridCell.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GridCell()..mergeFromBuffer(data, registry);
  factory GridCell.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GridCell()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GridCell',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GridCell.$_createMessage)
    ..aOM<$0.Metric>(1, _omitFieldNames ? '' : 'totalReturn',
        subBuilder: $0.Metric.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'center')
    ..aOS(3, _omitFieldNames ? '' : 'invalid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GridCell clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GridCell copyWith(void Function(GridCell) updates) =>
      super.copyWith((message) => updates(message as GridCell)) as GridCell;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GridCell() / GridCell.new instead')
  static GridCell create() => GridCell._();
  static $pb.GeneratedMessage $_createMessage() => GridCell._();
  @$core.override
  GridCell createEmptyInstance() => GridCell._();
  @$core.pragma('dart2js:noInline')
  static GridCell getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GridCell>(GridCell.$_createMessage);
  static GridCell? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Metric get totalReturn => $_getN(0);
  @$pb.TagNumber(1)
  set totalReturn($0.Metric value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalReturn() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalReturn() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Metric ensureTotalReturn() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get center => $_getBF(1);
  @$pb.TagNumber(2)
  set center($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCenter() => $_has(1);
  @$pb.TagNumber(2)
  void clearCenter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get invalid => $_getSZ(2);
  @$pb.TagNumber(3)
  set invalid($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInvalid() => $_has(2);
  @$pb.TagNumber(3)
  void clearInvalid() => $_clearField(3);
}

class GridRow extends $pb.GeneratedMessage {
  factory GridRow({
    $core.Iterable<GridCell>? cells,
  }) {
    final result = GridRow._();
    if (cells != null) result.cells.addAll(cells);
    return result;
  }

  GridRow._();

  factory GridRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GridRow()..mergeFromBuffer(data, registry);
  factory GridRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GridRow()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GridRow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GridRow.$_createMessage)
    ..pPM<GridCell>(1, _omitFieldNames ? '' : 'cells',
        subBuilder: GridCell.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GridRow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GridRow copyWith(void Function(GridRow) updates) =>
      super.copyWith((message) => updates(message as GridRow)) as GridRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GridRow() / GridRow.new instead')
  static GridRow create() => GridRow._();
  static $pb.GeneratedMessage $_createMessage() => GridRow._();
  @$core.override
  GridRow createEmptyInstance() => GridRow._();
  @$core.pragma('dart2js:noInline')
  static GridRow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GridRow>(GridRow.$_createMessage);
  static GridRow? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GridCell> get cells => $_getList(0);
}

class Grid extends $pb.GeneratedMessage {
  factory Grid({
    $core.String? x,
    $core.String? y,
    $core.Iterable<$core.double>? xs,
    $core.Iterable<$core.double>? ys,
    $core.Iterable<GridRow>? rows,
  }) {
    final result = Grid._();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    if (xs != null) result.xs.addAll(xs);
    if (ys != null) result.ys.addAll(ys);
    if (rows != null) result.rows.addAll(rows);
    return result;
  }

  Grid._();

  factory Grid.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Grid()..mergeFromBuffer(data, registry);
  factory Grid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Grid()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Grid',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Grid.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'x')
    ..aOS(2, _omitFieldNames ? '' : 'y')
    ..p<$core.double>(3, _omitFieldNames ? '' : 'xs', $pb.PbFieldType.KD)
    ..p<$core.double>(4, _omitFieldNames ? '' : 'ys', $pb.PbFieldType.KD)
    ..pPM<GridRow>(5, _omitFieldNames ? '' : 'rows',
        subBuilder: GridRow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Grid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Grid copyWith(void Function(Grid) updates) =>
      super.copyWith((message) => updates(message as Grid)) as Grid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Grid() / Grid.new instead')
  static Grid create() => Grid._();
  static $pb.GeneratedMessage $_createMessage() => Grid._();
  @$core.override
  Grid createEmptyInstance() => Grid._();
  @$core.pragma('dart2js:noInline')
  static Grid getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Grid>(Grid.$_createMessage);
  static Grid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get x => $_getSZ(0);
  @$pb.TagNumber(1)
  set x($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get y => $_getSZ(1);
  @$pb.TagNumber(2)
  set y($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.double> get xs => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.double> get ys => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<GridRow> get rows => $_getList(4);
}

class Badge extends $pb.GeneratedMessage {
  factory Badge({
    $core.String? kind,
    $core.String? text,
    $core.String? tone,
  }) {
    final result = Badge._();
    if (kind != null) result.kind = kind;
    if (text != null) result.text = text;
    if (tone != null) result.tone = tone;
    return result;
  }

  Badge._();

  factory Badge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Badge()..mergeFromBuffer(data, registry);
  factory Badge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Badge()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Badge',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Badge.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'kind')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'tone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Badge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Badge copyWith(void Function(Badge) updates) =>
      super.copyWith((message) => updates(message as Badge)) as Badge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Badge() / Badge.new instead')
  static Badge create() => Badge._();
  static $pb.GeneratedMessage $_createMessage() => Badge._();
  @$core.override
  Badge createEmptyInstance() => Badge._();
  @$core.pragma('dart2js:noInline')
  static Badge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Badge>(Badge.$_createMessage);
  static Badge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get kind => $_getSZ(0);
  @$pb.TagNumber(1)
  set kind($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get tone => $_getSZ(2);
  @$pb.TagNumber(3)
  set tone($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTone() => $_has(2);
  @$pb.TagNumber(3)
  void clearTone() => $_clearField(3);
}

class Summary extends $pb.GeneratedMessage {
  factory Summary({
    $core.String? verdict,
    $core.String? tone,
    $core.String? sentence,
    $core.Iterable<Badge>? badges,
  }) {
    final result = Summary._();
    if (verdict != null) result.verdict = verdict;
    if (tone != null) result.tone = tone;
    if (sentence != null) result.sentence = sentence;
    if (badges != null) result.badges.addAll(badges);
    return result;
  }

  Summary._();

  factory Summary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Summary()..mergeFromBuffer(data, registry);
  factory Summary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Summary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Summary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Summary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'verdict')
    ..aOS(2, _omitFieldNames ? '' : 'tone')
    ..aOS(3, _omitFieldNames ? '' : 'sentence')
    ..pPM<Badge>(4, _omitFieldNames ? '' : 'badges',
        subBuilder: Badge.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Summary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Summary copyWith(void Function(Summary) updates) =>
      super.copyWith((message) => updates(message as Summary)) as Summary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Summary() / Summary.new instead')
  static Summary create() => Summary._();
  static $pb.GeneratedMessage $_createMessage() => Summary._();
  @$core.override
  Summary createEmptyInstance() => Summary._();
  @$core.pragma('dart2js:noInline')
  static Summary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Summary>(Summary.$_createMessage);
  static Summary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get verdict => $_getSZ(0);
  @$pb.TagNumber(1)
  set verdict($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVerdict() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerdict() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tone => $_getSZ(1);
  @$pb.TagNumber(2)
  set tone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTone() => $_has(1);
  @$pb.TagNumber(2)
  void clearTone() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sentence => $_getSZ(2);
  @$pb.TagNumber(3)
  set sentence($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSentence() => $_has(2);
  @$pb.TagNumber(3)
  void clearSentence() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<Badge> get badges => $_getList(3);
}

class Benchmark extends $pb.GeneratedMessage {
  factory Benchmark({
    $core.String? key,
    $core.Iterable<$0.EquityPoint>? equity,
    $0.Metric? totalReturn,
  }) {
    final result = Benchmark._();
    if (key != null) result.key = key;
    if (equity != null) result.equity.addAll(equity);
    if (totalReturn != null) result.totalReturn = totalReturn;
    return result;
  }

  Benchmark._();

  factory Benchmark.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Benchmark()..mergeFromBuffer(data, registry);
  factory Benchmark.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Benchmark()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Benchmark',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Benchmark.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..pPM<$0.EquityPoint>(2, _omitFieldNames ? '' : 'equity',
        subBuilder: $0.EquityPoint.$_createMessage)
    ..aOM<$0.Metric>(3, _omitFieldNames ? '' : 'totalReturn',
        subBuilder: $0.Metric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Benchmark clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Benchmark copyWith(void Function(Benchmark) updates) =>
      super.copyWith((message) => updates(message as Benchmark)) as Benchmark;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Benchmark() / Benchmark.new instead')
  static Benchmark create() => Benchmark._();
  static $pb.GeneratedMessage $_createMessage() => Benchmark._();
  @$core.override
  Benchmark createEmptyInstance() => Benchmark._();
  @$core.pragma('dart2js:noInline')
  static Benchmark getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Benchmark>(Benchmark.$_createMessage);
  static Benchmark? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$0.EquityPoint> get equity => $_getList(1);

  @$pb.TagNumber(3)
  $0.Metric get totalReturn => $_getN(2);
  @$pb.TagNumber(3)
  set totalReturn($0.Metric value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalReturn() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalReturn() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Metric ensureTotalReturn() => $_ensure(2);
}

class MetricGroup extends $pb.GeneratedMessage {
  factory MetricGroup({
    $core.String? key,
    $core.String? label,
  }) {
    final result = MetricGroup._();
    if (key != null) result.key = key;
    if (label != null) result.label = label;
    return result;
  }

  MetricGroup._();

  factory MetricGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MetricGroup()..mergeFromBuffer(data, registry);
  factory MetricGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MetricGroup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetricGroup',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: MetricGroup.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetricGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetricGroup copyWith(void Function(MetricGroup) updates) =>
      super.copyWith((message) => updates(message as MetricGroup))
          as MetricGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MetricGroup() / MetricGroup.new instead')
  static MetricGroup create() => MetricGroup._();
  static $pb.GeneratedMessage $_createMessage() => MetricGroup._();
  @$core.override
  MetricGroup createEmptyInstance() => MetricGroup._();
  @$core.pragma('dart2js:noInline')
  static MetricGroup getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MetricGroup>(
          MetricGroup.$_createMessage);
  static MetricGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);
}

class Report extends $pb.GeneratedMessage {
  factory Report({
    $core.String? id,
    $core.String? title,
    $fixnum.Int64? createdUnixMs,
    ReportSpec? spec,
    Window? range,
    Window? oosWindow,
    Window? holdoutWindow,
    Summary? summary,
    RunView? oos,
    $core.Iterable<FoldView>? folds,
    $core.Iterable<StressView>? stress,
    Grid? grid,
    $core.Iterable<Benchmark>? benchmarks,
    $0.Decimal? breakEvenFee,
    $core.int? holdoutViews,
    $core.Iterable<MetricGroup>? groups,
    $0.Money? finalEquityToman,
    $0.Money? netToman,
  }) {
    final result = Report._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (createdUnixMs != null) result.createdUnixMs = createdUnixMs;
    if (spec != null) result.spec = spec;
    if (range != null) result.range = range;
    if (oosWindow != null) result.oosWindow = oosWindow;
    if (holdoutWindow != null) result.holdoutWindow = holdoutWindow;
    if (summary != null) result.summary = summary;
    if (oos != null) result.oos = oos;
    if (folds != null) result.folds.addAll(folds);
    if (stress != null) result.stress.addAll(stress);
    if (grid != null) result.grid = grid;
    if (benchmarks != null) result.benchmarks.addAll(benchmarks);
    if (breakEvenFee != null) result.breakEvenFee = breakEvenFee;
    if (holdoutViews != null) result.holdoutViews = holdoutViews;
    if (groups != null) result.groups.addAll(groups);
    if (finalEquityToman != null) result.finalEquityToman = finalEquityToman;
    if (netToman != null) result.netToman = netToman;
    return result;
  }

  Report._();

  factory Report.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Report()..mergeFromBuffer(data, registry);
  factory Report.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Report()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Report',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Report.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aInt64(3, _omitFieldNames ? '' : 'createdUnixMs')
    ..aOM<ReportSpec>(4, _omitFieldNames ? '' : 'spec',
        subBuilder: ReportSpec.$_createMessage)
    ..aOM<Window>(5, _omitFieldNames ? '' : 'range',
        subBuilder: Window.$_createMessage)
    ..aOM<Window>(6, _omitFieldNames ? '' : 'oosWindow',
        subBuilder: Window.$_createMessage)
    ..aOM<Window>(7, _omitFieldNames ? '' : 'holdoutWindow',
        subBuilder: Window.$_createMessage)
    ..aOM<Summary>(8, _omitFieldNames ? '' : 'summary',
        subBuilder: Summary.$_createMessage)
    ..aOM<RunView>(9, _omitFieldNames ? '' : 'oos',
        subBuilder: RunView.$_createMessage)
    ..pPM<FoldView>(10, _omitFieldNames ? '' : 'folds',
        subBuilder: FoldView.$_createMessage)
    ..pPM<StressView>(11, _omitFieldNames ? '' : 'stress',
        subBuilder: StressView.$_createMessage)
    ..aOM<Grid>(12, _omitFieldNames ? '' : 'grid',
        subBuilder: Grid.$_createMessage)
    ..pPM<Benchmark>(13, _omitFieldNames ? '' : 'benchmarks',
        subBuilder: Benchmark.$_createMessage)
    ..aOM<$0.Decimal>(14, _omitFieldNames ? '' : 'breakEvenFee',
        subBuilder: $0.Decimal.$_createMessage)
    ..aI(15, _omitFieldNames ? '' : 'holdoutViews')
    ..pPM<MetricGroup>(16, _omitFieldNames ? '' : 'groups',
        subBuilder: MetricGroup.$_createMessage)
    ..aOM<$0.Money>(17, _omitFieldNames ? '' : 'finalEquityToman',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(18, _omitFieldNames ? '' : 'netToman',
        subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report copyWith(void Function(Report) updates) =>
      super.copyWith((message) => updates(message as Report)) as Report;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Report() / Report.new instead')
  static Report create() => Report._();
  static $pb.GeneratedMessage $_createMessage() => Report._();
  @$core.override
  Report createEmptyInstance() => Report._();
  @$core.pragma('dart2js:noInline')
  static Report getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Report>(Report.$_createMessage);
  static Report? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
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
  $fixnum.Int64 get createdUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set createdUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  ReportSpec get spec => $_getN(3);
  @$pb.TagNumber(4)
  set spec(ReportSpec value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSpec() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpec() => $_clearField(4);
  @$pb.TagNumber(4)
  ReportSpec ensureSpec() => $_ensure(3);

  @$pb.TagNumber(5)
  Window get range => $_getN(4);
  @$pb.TagNumber(5)
  set range(Window value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRange() => $_has(4);
  @$pb.TagNumber(5)
  void clearRange() => $_clearField(5);
  @$pb.TagNumber(5)
  Window ensureRange() => $_ensure(4);

  @$pb.TagNumber(6)
  Window get oosWindow => $_getN(5);
  @$pb.TagNumber(6)
  set oosWindow(Window value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOosWindow() => $_has(5);
  @$pb.TagNumber(6)
  void clearOosWindow() => $_clearField(6);
  @$pb.TagNumber(6)
  Window ensureOosWindow() => $_ensure(5);

  @$pb.TagNumber(7)
  Window get holdoutWindow => $_getN(6);
  @$pb.TagNumber(7)
  set holdoutWindow(Window value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasHoldoutWindow() => $_has(6);
  @$pb.TagNumber(7)
  void clearHoldoutWindow() => $_clearField(7);
  @$pb.TagNumber(7)
  Window ensureHoldoutWindow() => $_ensure(6);

  @$pb.TagNumber(8)
  Summary get summary => $_getN(7);
  @$pb.TagNumber(8)
  set summary(Summary value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSummary() => $_has(7);
  @$pb.TagNumber(8)
  void clearSummary() => $_clearField(8);
  @$pb.TagNumber(8)
  Summary ensureSummary() => $_ensure(7);

  @$pb.TagNumber(9)
  RunView get oos => $_getN(8);
  @$pb.TagNumber(9)
  set oos(RunView value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasOos() => $_has(8);
  @$pb.TagNumber(9)
  void clearOos() => $_clearField(9);
  @$pb.TagNumber(9)
  RunView ensureOos() => $_ensure(8);

  @$pb.TagNumber(10)
  $pb.PbList<FoldView> get folds => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<StressView> get stress => $_getList(10);

  @$pb.TagNumber(12)
  Grid get grid => $_getN(11);
  @$pb.TagNumber(12)
  set grid(Grid value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasGrid() => $_has(11);
  @$pb.TagNumber(12)
  void clearGrid() => $_clearField(12);
  @$pb.TagNumber(12)
  Grid ensureGrid() => $_ensure(11);

  @$pb.TagNumber(13)
  $pb.PbList<Benchmark> get benchmarks => $_getList(12);

  @$pb.TagNumber(14)
  $0.Decimal get breakEvenFee => $_getN(13);
  @$pb.TagNumber(14)
  set breakEvenFee($0.Decimal value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasBreakEvenFee() => $_has(13);
  @$pb.TagNumber(14)
  void clearBreakEvenFee() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Decimal ensureBreakEvenFee() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.int get holdoutViews => $_getIZ(14);
  @$pb.TagNumber(15)
  set holdoutViews($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasHoldoutViews() => $_has(14);
  @$pb.TagNumber(15)
  void clearHoldoutViews() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<MetricGroup> get groups => $_getList(15);

  /// Display only, when GetReportRequest.fx_rate_id is set.
  @$pb.TagNumber(17)
  $0.Money get finalEquityToman => $_getN(16);
  @$pb.TagNumber(17)
  set finalEquityToman($0.Money value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasFinalEquityToman() => $_has(16);
  @$pb.TagNumber(17)
  void clearFinalEquityToman() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Money ensureFinalEquityToman() => $_ensure(16);

  @$pb.TagNumber(18)
  $0.Money get netToman => $_getN(17);
  @$pb.TagNumber(18)
  set netToman($0.Money value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasNetToman() => $_has(17);
  @$pb.TagNumber(18)
  void clearNetToman() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Money ensureNetToman() => $_ensure(17);
}

class GetReportRequest extends $pb.GeneratedMessage {
  factory GetReportRequest({
    $core.String? reportId,
    $fixnum.Int64? fxRateId,
  }) {
    final result = GetReportRequest._();
    if (reportId != null) result.reportId = reportId;
    if (fxRateId != null) result.fxRateId = fxRateId;
    return result;
  }

  GetReportRequest._();

  factory GetReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReportRequest()..mergeFromBuffer(data, registry);
  factory GetReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aInt64(2, _omitFieldNames ? '' : 'fxRateId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReportRequest copyWith(void Function(GetReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetReportRequest))
          as GetReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetReportRequest() / GetReportRequest.new instead')
  static GetReportRequest create() => GetReportRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetReportRequest._();
  @$core.override
  GetReportRequest createEmptyInstance() => GetReportRequest._();
  @$core.pragma('dart2js:noInline')
  static GetReportRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReportRequest>(
          GetReportRequest.$_createMessage);
  static GetReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fxRateId => $_getI64(1);
  @$pb.TagNumber(2)
  set fxRateId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFxRateId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFxRateId() => $_clearField(2);
}

class GetReportResponse extends $pb.GeneratedMessage {
  factory GetReportResponse({
    Report? report,
  }) {
    final result = GetReportResponse._();
    if (report != null) result.report = report;
    return result;
  }

  GetReportResponse._();

  factory GetReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReportResponse()..mergeFromBuffer(data, registry);
  factory GetReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetReportResponse.$_createMessage)
    ..aOM<Report>(1, _omitFieldNames ? '' : 'report',
        subBuilder: Report.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReportResponse copyWith(void Function(GetReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetReportResponse))
          as GetReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetReportResponse() / GetReportResponse.new instead')
  static GetReportResponse create() => GetReportResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetReportResponse._();
  @$core.override
  GetReportResponse createEmptyInstance() => GetReportResponse._();
  @$core.pragma('dart2js:noInline')
  static GetReportResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReportResponse>(
          GetReportResponse.$_createMessage);
  static GetReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Report get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(Report value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  Report ensureReport() => $_ensure(0);
}

class ViewHoldoutRequest extends $pb.GeneratedMessage {
  factory ViewHoldoutRequest({
    $core.String? reportId,
  }) {
    final result = ViewHoldoutRequest._();
    if (reportId != null) result.reportId = reportId;
    return result;
  }

  ViewHoldoutRequest._();

  factory ViewHoldoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewHoldoutRequest()..mergeFromBuffer(data, registry);
  factory ViewHoldoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewHoldoutRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewHoldoutRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ViewHoldoutRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewHoldoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewHoldoutRequest copyWith(void Function(ViewHoldoutRequest) updates) =>
      super.copyWith((message) => updates(message as ViewHoldoutRequest))
          as ViewHoldoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewHoldoutRequest() / ViewHoldoutRequest.new instead')
  static ViewHoldoutRequest create() => ViewHoldoutRequest._();
  static $pb.GeneratedMessage $_createMessage() => ViewHoldoutRequest._();
  @$core.override
  ViewHoldoutRequest createEmptyInstance() => ViewHoldoutRequest._();
  @$core.pragma('dart2js:noInline')
  static ViewHoldoutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ViewHoldoutRequest>(
          ViewHoldoutRequest.$_createMessage);
  static ViewHoldoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);
}

class ViewHoldoutResponse extends $pb.GeneratedMessage {
  factory ViewHoldoutResponse({
    RunView? holdout,
    $core.int? views,
  }) {
    final result = ViewHoldoutResponse._();
    if (holdout != null) result.holdout = holdout;
    if (views != null) result.views = views;
    return result;
  }

  ViewHoldoutResponse._();

  factory ViewHoldoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewHoldoutResponse()..mergeFromBuffer(data, registry);
  factory ViewHoldoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewHoldoutResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewHoldoutResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ViewHoldoutResponse.$_createMessage)
    ..aOM<RunView>(1, _omitFieldNames ? '' : 'holdout',
        subBuilder: RunView.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'views')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewHoldoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewHoldoutResponse copyWith(void Function(ViewHoldoutResponse) updates) =>
      super.copyWith((message) => updates(message as ViewHoldoutResponse))
          as ViewHoldoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ViewHoldoutResponse() / ViewHoldoutResponse.new instead')
  static ViewHoldoutResponse create() => ViewHoldoutResponse._();
  static $pb.GeneratedMessage $_createMessage() => ViewHoldoutResponse._();
  @$core.override
  ViewHoldoutResponse createEmptyInstance() => ViewHoldoutResponse._();
  @$core.pragma('dart2js:noInline')
  static ViewHoldoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ViewHoldoutResponse>(
          ViewHoldoutResponse.$_createMessage);
  static ViewHoldoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RunView get holdout => $_getN(0);
  @$pb.TagNumber(1)
  set holdout(RunView value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHoldout() => $_has(0);
  @$pb.TagNumber(1)
  void clearHoldout() => $_clearField(1);
  @$pb.TagNumber(1)
  RunView ensureHoldout() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get views => $_getIZ(1);
  @$pb.TagNumber(2)
  set views($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasViews() => $_has(1);
  @$pb.TagNumber(2)
  void clearViews() => $_clearField(2);
}

class TradeRow extends $pb.GeneratedMessage {
  factory TradeRow({
    $core.int? seq,
    $core.String? instrument,
    $fixnum.Int64? openedUnixMs,
    $fixnum.Int64? closedUnixMs,
    $0.Decimal? qty,
    $0.Money? entryRef,
    $0.Money? exitRef,
    $0.Money? gross,
    $0.Money? slippage,
    $0.Money? fees,
    $0.Money? net,
    $core.String? exitReason,
    $core.int? ambiguousBars,
    $0.Decimal? openQty,
    $0.Money? markValue,
  }) {
    final result = TradeRow._();
    if (seq != null) result.seq = seq;
    if (instrument != null) result.instrument = instrument;
    if (openedUnixMs != null) result.openedUnixMs = openedUnixMs;
    if (closedUnixMs != null) result.closedUnixMs = closedUnixMs;
    if (qty != null) result.qty = qty;
    if (entryRef != null) result.entryRef = entryRef;
    if (exitRef != null) result.exitRef = exitRef;
    if (gross != null) result.gross = gross;
    if (slippage != null) result.slippage = slippage;
    if (fees != null) result.fees = fees;
    if (net != null) result.net = net;
    if (exitReason != null) result.exitReason = exitReason;
    if (ambiguousBars != null) result.ambiguousBars = ambiguousBars;
    if (openQty != null) result.openQty = openQty;
    if (markValue != null) result.markValue = markValue;
    return result;
  }

  TradeRow._();

  factory TradeRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TradeRow()..mergeFromBuffer(data, registry);
  factory TradeRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TradeRow()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TradeRow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: TradeRow.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seq')
    ..aOS(2, _omitFieldNames ? '' : 'instrument')
    ..aInt64(3, _omitFieldNames ? '' : 'openedUnixMs')
    ..aInt64(4, _omitFieldNames ? '' : 'closedUnixMs')
    ..aOM<$0.Decimal>(5, _omitFieldNames ? '' : 'qty',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Money>(6, _omitFieldNames ? '' : 'entryRef',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(7, _omitFieldNames ? '' : 'exitRef',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(8, _omitFieldNames ? '' : 'gross',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(9, _omitFieldNames ? '' : 'slippage',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(10, _omitFieldNames ? '' : 'fees',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(11, _omitFieldNames ? '' : 'net',
        subBuilder: $0.Money.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'exitReason')
    ..aI(13, _omitFieldNames ? '' : 'ambiguousBars')
    ..aOM<$0.Decimal>(14, _omitFieldNames ? '' : 'openQty',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Money>(15, _omitFieldNames ? '' : 'markValue',
        subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TradeRow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TradeRow copyWith(void Function(TradeRow) updates) =>
      super.copyWith((message) => updates(message as TradeRow)) as TradeRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TradeRow() / TradeRow.new instead')
  static TradeRow create() => TradeRow._();
  static $pb.GeneratedMessage $_createMessage() => TradeRow._();
  @$core.override
  TradeRow createEmptyInstance() => TradeRow._();
  @$core.pragma('dart2js:noInline')
  static TradeRow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TradeRow>(TradeRow.$_createMessage);
  static TradeRow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get instrument => $_getSZ(1);
  @$pb.TagNumber(2)
  set instrument($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstrument() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstrument() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get openedUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set openedUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOpenedUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpenedUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get closedUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set closedUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClosedUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearClosedUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Decimal get qty => $_getN(4);
  @$pb.TagNumber(5)
  set qty($0.Decimal value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasQty() => $_has(4);
  @$pb.TagNumber(5)
  void clearQty() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Decimal ensureQty() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Money get entryRef => $_getN(5);
  @$pb.TagNumber(6)
  set entryRef($0.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEntryRef() => $_has(5);
  @$pb.TagNumber(6)
  void clearEntryRef() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Money ensureEntryRef() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Money get exitRef => $_getN(6);
  @$pb.TagNumber(7)
  set exitRef($0.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExitRef() => $_has(6);
  @$pb.TagNumber(7)
  void clearExitRef() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Money ensureExitRef() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Money get gross => $_getN(7);
  @$pb.TagNumber(8)
  set gross($0.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasGross() => $_has(7);
  @$pb.TagNumber(8)
  void clearGross() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Money ensureGross() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Money get slippage => $_getN(8);
  @$pb.TagNumber(9)
  set slippage($0.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSlippage() => $_has(8);
  @$pb.TagNumber(9)
  void clearSlippage() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Money ensureSlippage() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Money get fees => $_getN(9);
  @$pb.TagNumber(10)
  set fees($0.Money value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasFees() => $_has(9);
  @$pb.TagNumber(10)
  void clearFees() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Money ensureFees() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Money get net => $_getN(10);
  @$pb.TagNumber(11)
  set net($0.Money value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasNet() => $_has(10);
  @$pb.TagNumber(11)
  void clearNet() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Money ensureNet() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get exitReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set exitReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasExitReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearExitReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get ambiguousBars => $_getIZ(12);
  @$pb.TagNumber(13)
  set ambiguousBars($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAmbiguousBars() => $_has(12);
  @$pb.TagNumber(13)
  void clearAmbiguousBars() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Decimal get openQty => $_getN(13);
  @$pb.TagNumber(14)
  set openQty($0.Decimal value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasOpenQty() => $_has(13);
  @$pb.TagNumber(14)
  void clearOpenQty() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Decimal ensureOpenQty() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Money get markValue => $_getN(14);
  @$pb.TagNumber(15)
  set markValue($0.Money value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasMarkValue() => $_has(14);
  @$pb.TagNumber(15)
  void clearMarkValue() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Money ensureMarkValue() => $_ensure(14);
}

class ListTradesRequest extends $pb.GeneratedMessage {
  factory ListTradesRequest({
    $core.String? reportId,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = ListTradesRequest._();
    if (reportId != null) result.reportId = reportId;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListTradesRequest._();

  factory ListTradesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTradesRequest()..mergeFromBuffer(data, registry);
  factory ListTradesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTradesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTradesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListTradesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aI(3, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTradesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTradesRequest copyWith(void Function(ListTradesRequest) updates) =>
      super.copyWith((message) => updates(message as ListTradesRequest))
          as ListTradesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListTradesRequest() / ListTradesRequest.new instead')
  static ListTradesRequest create() => ListTradesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListTradesRequest._();
  @$core.override
  ListTradesRequest createEmptyInstance() => ListTradesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListTradesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTradesRequest>(
          ListTradesRequest.$_createMessage);
  static ListTradesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class ListTradesResponse extends $pb.GeneratedMessage {
  factory ListTradesResponse({
    $core.Iterable<TradeRow>? trades,
    $fixnum.Int64? total,
  }) {
    final result = ListTradesResponse._();
    if (trades != null) result.trades.addAll(trades);
    if (total != null) result.total = total;
    return result;
  }

  ListTradesResponse._();

  factory ListTradesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTradesResponse()..mergeFromBuffer(data, registry);
  factory ListTradesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTradesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTradesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListTradesResponse.$_createMessage)
    ..pPM<TradeRow>(1, _omitFieldNames ? '' : 'trades',
        subBuilder: TradeRow.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTradesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTradesResponse copyWith(void Function(ListTradesResponse) updates) =>
      super.copyWith((message) => updates(message as ListTradesResponse))
          as ListTradesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListTradesResponse() / ListTradesResponse.new instead')
  static ListTradesResponse create() => ListTradesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListTradesResponse._();
  @$core.override
  ListTradesResponse createEmptyInstance() => ListTradesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListTradesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTradesResponse>(
          ListTradesResponse.$_createMessage);
  static ListTradesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TradeRow> get trades => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class DecisionRow extends $pb.GeneratedMessage {
  factory DecisionRow({
    $core.int? id,
    $fixnum.Int64? atUnixMs,
    $core.String? inputSymbol,
    $fixnum.Int64? inputBarOpenUnixMs,
    $core.String? instrument,
    $0.Decimal? target,
    $0.Decimal? stopLoss,
    $0.Decimal? takeProfit,
    $core.String? reason,
    $core.String? modelId,
    $core.String? recipeVersion,
    $core.String? outcome,
    $core.String? detail,
  }) {
    final result = DecisionRow._();
    if (id != null) result.id = id;
    if (atUnixMs != null) result.atUnixMs = atUnixMs;
    if (inputSymbol != null) result.inputSymbol = inputSymbol;
    if (inputBarOpenUnixMs != null)
      result.inputBarOpenUnixMs = inputBarOpenUnixMs;
    if (instrument != null) result.instrument = instrument;
    if (target != null) result.target = target;
    if (stopLoss != null) result.stopLoss = stopLoss;
    if (takeProfit != null) result.takeProfit = takeProfit;
    if (reason != null) result.reason = reason;
    if (modelId != null) result.modelId = modelId;
    if (recipeVersion != null) result.recipeVersion = recipeVersion;
    if (outcome != null) result.outcome = outcome;
    if (detail != null) result.detail = detail;
    return result;
  }

  DecisionRow._();

  factory DecisionRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DecisionRow()..mergeFromBuffer(data, registry);
  factory DecisionRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DecisionRow()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecisionRow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: DecisionRow.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'atUnixMs')
    ..aOS(3, _omitFieldNames ? '' : 'inputSymbol')
    ..aInt64(4, _omitFieldNames ? '' : 'inputBarOpenUnixMs')
    ..aOS(5, _omitFieldNames ? '' : 'instrument')
    ..aOM<$0.Decimal>(6, _omitFieldNames ? '' : 'target',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(7, _omitFieldNames ? '' : 'stopLoss',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(8, _omitFieldNames ? '' : 'takeProfit',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..aOS(10, _omitFieldNames ? '' : 'modelId')
    ..aOS(11, _omitFieldNames ? '' : 'recipeVersion')
    ..aOS(12, _omitFieldNames ? '' : 'outcome')
    ..aOS(13, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecisionRow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecisionRow copyWith(void Function(DecisionRow) updates) =>
      super.copyWith((message) => updates(message as DecisionRow))
          as DecisionRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DecisionRow() / DecisionRow.new instead')
  static DecisionRow create() => DecisionRow._();
  static $pb.GeneratedMessage $_createMessage() => DecisionRow._();
  @$core.override
  DecisionRow createEmptyInstance() => DecisionRow._();
  @$core.pragma('dart2js:noInline')
  static DecisionRow getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DecisionRow>(
          DecisionRow.$_createMessage);
  static DecisionRow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get atUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set atUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAtUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearAtUnixMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get inputSymbol => $_getSZ(2);
  @$pb.TagNumber(3)
  set inputSymbol($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInputSymbol() => $_has(2);
  @$pb.TagNumber(3)
  void clearInputSymbol() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get inputBarOpenUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set inputBarOpenUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInputBarOpenUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearInputBarOpenUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get instrument => $_getSZ(4);
  @$pb.TagNumber(5)
  set instrument($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInstrument() => $_has(4);
  @$pb.TagNumber(5)
  void clearInstrument() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Decimal get target => $_getN(5);
  @$pb.TagNumber(6)
  set target($0.Decimal value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTarget() => $_has(5);
  @$pb.TagNumber(6)
  void clearTarget() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Decimal ensureTarget() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Decimal get stopLoss => $_getN(6);
  @$pb.TagNumber(7)
  set stopLoss($0.Decimal value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStopLoss() => $_has(6);
  @$pb.TagNumber(7)
  void clearStopLoss() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Decimal ensureStopLoss() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Decimal get takeProfit => $_getN(7);
  @$pb.TagNumber(8)
  set takeProfit($0.Decimal value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTakeProfit() => $_has(7);
  @$pb.TagNumber(8)
  void clearTakeProfit() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Decimal ensureTakeProfit() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get modelId => $_getSZ(9);
  @$pb.TagNumber(10)
  set modelId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasModelId() => $_has(9);
  @$pb.TagNumber(10)
  void clearModelId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get recipeVersion => $_getSZ(10);
  @$pb.TagNumber(11)
  set recipeVersion($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRecipeVersion() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecipeVersion() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get outcome => $_getSZ(11);
  @$pb.TagNumber(12)
  set outcome($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOutcome() => $_has(11);
  @$pb.TagNumber(12)
  void clearOutcome() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get detail => $_getSZ(12);
  @$pb.TagNumber(13)
  set detail($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDetail() => $_has(12);
  @$pb.TagNumber(13)
  void clearDetail() => $_clearField(13);
}

class ListDecisionsRequest extends $pb.GeneratedMessage {
  factory ListDecisionsRequest({
    $core.String? reportId,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = ListDecisionsRequest._();
    if (reportId != null) result.reportId = reportId;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListDecisionsRequest._();

  factory ListDecisionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDecisionsRequest()..mergeFromBuffer(data, registry);
  factory ListDecisionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDecisionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDecisionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListDecisionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aI(3, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDecisionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDecisionsRequest copyWith(void Function(ListDecisionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDecisionsRequest))
          as ListDecisionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListDecisionsRequest() / ListDecisionsRequest.new instead')
  static ListDecisionsRequest create() => ListDecisionsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListDecisionsRequest._();
  @$core.override
  ListDecisionsRequest createEmptyInstance() => ListDecisionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListDecisionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDecisionsRequest>(
          ListDecisionsRequest.$_createMessage);
  static ListDecisionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class ListDecisionsResponse extends $pb.GeneratedMessage {
  factory ListDecisionsResponse({
    $core.Iterable<DecisionRow>? decisions,
    $fixnum.Int64? total,
  }) {
    final result = ListDecisionsResponse._();
    if (decisions != null) result.decisions.addAll(decisions);
    if (total != null) result.total = total;
    return result;
  }

  ListDecisionsResponse._();

  factory ListDecisionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDecisionsResponse()..mergeFromBuffer(data, registry);
  factory ListDecisionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDecisionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDecisionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListDecisionsResponse.$_createMessage)
    ..pPM<DecisionRow>(1, _omitFieldNames ? '' : 'decisions',
        subBuilder: DecisionRow.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDecisionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDecisionsResponse copyWith(
          void Function(ListDecisionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListDecisionsResponse))
          as ListDecisionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListDecisionsResponse() / ListDecisionsResponse.new instead')
  static ListDecisionsResponse create() => ListDecisionsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListDecisionsResponse._();
  @$core.override
  ListDecisionsResponse createEmptyInstance() => ListDecisionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListDecisionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDecisionsResponse>(
          ListDecisionsResponse.$_createMessage);
  static ListDecisionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DecisionRow> get decisions => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class Assumption extends $pb.GeneratedMessage {
  factory Assumption({
    $core.String? key,
    $core.String? label,
    $core.Iterable<$core.String>? values,
    $core.bool? differs,
    $core.bool? blocking,
  }) {
    final result = Assumption._();
    if (key != null) result.key = key;
    if (label != null) result.label = label;
    if (values != null) result.values.addAll(values);
    if (differs != null) result.differs = differs;
    if (blocking != null) result.blocking = blocking;
    return result;
  }

  Assumption._();

  factory Assumption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Assumption()..mergeFromBuffer(data, registry);
  factory Assumption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Assumption()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Assumption',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Assumption.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..pPS(3, _omitFieldNames ? '' : 'values')
    ..aOB(4, _omitFieldNames ? '' : 'differs')
    ..aOB(5, _omitFieldNames ? '' : 'blocking')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Assumption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Assumption copyWith(void Function(Assumption) updates) =>
      super.copyWith((message) => updates(message as Assumption)) as Assumption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Assumption() / Assumption.new instead')
  static Assumption create() => Assumption._();
  static $pb.GeneratedMessage $_createMessage() => Assumption._();
  @$core.override
  Assumption createEmptyInstance() => Assumption._();
  @$core.pragma('dart2js:noInline')
  static Assumption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Assumption>(Assumption.$_createMessage);
  static Assumption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get values => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get differs => $_getBF(3);
  @$pb.TagNumber(4)
  set differs($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiffers() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiffers() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get blocking => $_getBF(4);
  @$pb.TagNumber(5)
  set blocking($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBlocking() => $_has(4);
  @$pb.TagNumber(5)
  void clearBlocking() => $_clearField(5);
}

class CompareRequest extends $pb.GeneratedMessage {
  factory CompareRequest({
    $core.Iterable<$core.String>? reportIds,
  }) {
    final result = CompareRequest._();
    if (reportIds != null) result.reportIds.addAll(reportIds);
    return result;
  }

  CompareRequest._();

  factory CompareRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareRequest()..mergeFromBuffer(data, registry);
  factory CompareRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CompareRequest.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'reportIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareRequest copyWith(void Function(CompareRequest) updates) =>
      super.copyWith((message) => updates(message as CompareRequest))
          as CompareRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CompareRequest() / CompareRequest.new instead')
  static CompareRequest create() => CompareRequest._();
  static $pb.GeneratedMessage $_createMessage() => CompareRequest._();
  @$core.override
  CompareRequest createEmptyInstance() => CompareRequest._();
  @$core.pragma('dart2js:noInline')
  static CompareRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CompareRequest>(
          CompareRequest.$_createMessage);
  static CompareRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get reportIds => $_getList(0);
}

class CompareColumn extends $pb.GeneratedMessage {
  factory CompareColumn({
    $core.String? reportId,
    $core.String? title,
    $core.bool? eligible,
    $core.Iterable<$core.String>? reasons,
    $core.Iterable<$0.Metric>? metrics,
    $core.Iterable<$0.EquityPoint>? equity,
  }) {
    final result = CompareColumn._();
    if (reportId != null) result.reportId = reportId;
    if (title != null) result.title = title;
    if (eligible != null) result.eligible = eligible;
    if (reasons != null) result.reasons.addAll(reasons);
    if (metrics != null) result.metrics.addAll(metrics);
    if (equity != null) result.equity.addAll(equity);
    return result;
  }

  CompareColumn._();

  factory CompareColumn.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareColumn()..mergeFromBuffer(data, registry);
  factory CompareColumn.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareColumn()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareColumn',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CompareColumn.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOB(3, _omitFieldNames ? '' : 'eligible')
    ..pPS(4, _omitFieldNames ? '' : 'reasons')
    ..pPM<$0.Metric>(5, _omitFieldNames ? '' : 'metrics',
        subBuilder: $0.Metric.$_createMessage)
    ..pPM<$0.EquityPoint>(6, _omitFieldNames ? '' : 'equity',
        subBuilder: $0.EquityPoint.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareColumn clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareColumn copyWith(void Function(CompareColumn) updates) =>
      super.copyWith((message) => updates(message as CompareColumn))
          as CompareColumn;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CompareColumn() / CompareColumn.new instead')
  static CompareColumn create() => CompareColumn._();
  static $pb.GeneratedMessage $_createMessage() => CompareColumn._();
  @$core.override
  CompareColumn createEmptyInstance() => CompareColumn._();
  @$core.pragma('dart2js:noInline')
  static CompareColumn getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CompareColumn>(
          CompareColumn.$_createMessage);
  static CompareColumn? _defaultInstance;

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
  $core.bool get eligible => $_getBF(2);
  @$pb.TagNumber(3)
  set eligible($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEligible() => $_has(2);
  @$pb.TagNumber(3)
  void clearEligible() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get reasons => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$0.Metric> get metrics => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$0.EquityPoint> get equity => $_getList(5);
}

class CompareResponse extends $pb.GeneratedMessage {
  factory CompareResponse({
    $core.Iterable<Assumption>? assumptions,
    $core.Iterable<CompareColumn>? columns,
    $core.String? conclusion,
  }) {
    final result = CompareResponse._();
    if (assumptions != null) result.assumptions.addAll(assumptions);
    if (columns != null) result.columns.addAll(columns);
    if (conclusion != null) result.conclusion = conclusion;
    return result;
  }

  CompareResponse._();

  factory CompareResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareResponse()..mergeFromBuffer(data, registry);
  factory CompareResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CompareResponse.$_createMessage)
    ..pPM<Assumption>(1, _omitFieldNames ? '' : 'assumptions',
        subBuilder: Assumption.$_createMessage)
    ..pPM<CompareColumn>(2, _omitFieldNames ? '' : 'columns',
        subBuilder: CompareColumn.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'conclusion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareResponse copyWith(void Function(CompareResponse) updates) =>
      super.copyWith((message) => updates(message as CompareResponse))
          as CompareResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CompareResponse() / CompareResponse.new instead')
  static CompareResponse create() => CompareResponse._();
  static $pb.GeneratedMessage $_createMessage() => CompareResponse._();
  @$core.override
  CompareResponse createEmptyInstance() => CompareResponse._();
  @$core.pragma('dart2js:noInline')
  static CompareResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CompareResponse>(
          CompareResponse.$_createMessage);
  static CompareResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Assumption> get assumptions => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<CompareColumn> get columns => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get conclusion => $_getSZ(2);
  @$pb.TagNumber(3)
  set conclusion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConclusion() => $_has(2);
  @$pb.TagNumber(3)
  void clearConclusion() => $_clearField(3);
}

class ExportRequest extends $pb.GeneratedMessage {
  factory ExportRequest({
    $core.String? reportId,
    $core.String? kind,
    $fixnum.Int64? fxRateId,
  }) {
    final result = ExportRequest._();
    if (reportId != null) result.reportId = reportId;
    if (kind != null) result.kind = kind;
    if (fxRateId != null) result.fxRateId = fxRateId;
    return result;
  }

  ExportRequest._();

  factory ExportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportRequest()..mergeFromBuffer(data, registry);
  factory ExportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ExportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aInt64(3, _omitFieldNames ? '' : 'fxRateId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportRequest copyWith(void Function(ExportRequest) updates) =>
      super.copyWith((message) => updates(message as ExportRequest))
          as ExportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExportRequest() / ExportRequest.new instead')
  static ExportRequest create() => ExportRequest._();
  static $pb.GeneratedMessage $_createMessage() => ExportRequest._();
  @$core.override
  ExportRequest createEmptyInstance() => ExportRequest._();
  @$core.pragma('dart2js:noInline')
  static ExportRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportRequest>(
          ExportRequest.$_createMessage);
  static ExportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fxRateId => $_getI64(2);
  @$pb.TagNumber(3)
  set fxRateId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFxRateId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFxRateId() => $_clearField(3);
}

class ExportResponse extends $pb.GeneratedMessage {
  factory ExportResponse({
    $core.String? filename,
    $core.String? mime,
    $core.List<$core.int>? content,
  }) {
    final result = ExportResponse._();
    if (filename != null) result.filename = filename;
    if (mime != null) result.mime = mime;
    if (content != null) result.content = content;
    return result;
  }

  ExportResponse._();

  factory ExportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportResponse()..mergeFromBuffer(data, registry);
  factory ExportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ExportResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'filename')
    ..aOS(2, _omitFieldNames ? '' : 'mime')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportResponse copyWith(void Function(ExportResponse) updates) =>
      super.copyWith((message) => updates(message as ExportResponse))
          as ExportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExportResponse() / ExportResponse.new instead')
  static ExportResponse create() => ExportResponse._();
  static $pb.GeneratedMessage $_createMessage() => ExportResponse._();
  @$core.override
  ExportResponse createEmptyInstance() => ExportResponse._();
  @$core.pragma('dart2js:noInline')
  static ExportResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportResponse>(
          ExportResponse.$_createMessage);
  static ExportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get filename => $_getSZ(0);
  @$pb.TagNumber(1)
  set filename($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFilename() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilename() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mime => $_getSZ(1);
  @$pb.TagNumber(2)
  set mime($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMime() => $_has(1);
  @$pb.TagNumber(2)
  void clearMime() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get content => $_getN(2);
  @$pb.TagNumber(3)
  set content($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);
}

class ReproduceRequest extends $pb.GeneratedMessage {
  factory ReproduceRequest({
    $core.String? reportId,
  }) {
    final result = ReproduceRequest._();
    if (reportId != null) result.reportId = reportId;
    return result;
  }

  ReproduceRequest._();

  factory ReproduceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReproduceRequest()..mergeFromBuffer(data, registry);
  factory ReproduceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReproduceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReproduceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ReproduceRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReproduceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReproduceRequest copyWith(void Function(ReproduceRequest) updates) =>
      super.copyWith((message) => updates(message as ReproduceRequest))
          as ReproduceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReproduceRequest() / ReproduceRequest.new instead')
  static ReproduceRequest create() => ReproduceRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReproduceRequest._();
  @$core.override
  ReproduceRequest createEmptyInstance() => ReproduceRequest._();
  @$core.pragma('dart2js:noInline')
  static ReproduceRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReproduceRequest>(
          ReproduceRequest.$_createMessage);
  static ReproduceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);
}

class ReproduceResponse extends $pb.GeneratedMessage {
  factory ReproduceResponse({
    $core.bool? identical,
  }) {
    final result = ReproduceResponse._();
    if (identical != null) result.identical = identical;
    return result;
  }

  ReproduceResponse._();

  factory ReproduceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReproduceResponse()..mergeFromBuffer(data, registry);
  factory ReproduceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReproduceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReproduceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ReproduceResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'identical')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReproduceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReproduceResponse copyWith(void Function(ReproduceResponse) updates) =>
      super.copyWith((message) => updates(message as ReproduceResponse))
          as ReproduceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReproduceResponse() / ReproduceResponse.new instead')
  static ReproduceResponse create() => ReproduceResponse._();
  static $pb.GeneratedMessage $_createMessage() => ReproduceResponse._();
  @$core.override
  ReproduceResponse createEmptyInstance() => ReproduceResponse._();
  @$core.pragma('dart2js:noInline')
  static ReproduceResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReproduceResponse>(
          ReproduceResponse.$_createMessage);
  static ReproduceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get identical => $_getBF(0);
  @$pb.TagNumber(1)
  set identical($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdentical() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentical() => $_clearField(1);
}

/// ReportService: evaluate a configuration, read reports, compare, export.
class ReportServiceApi {
  final $pb.RpcClient _client;

  ReportServiceApi(this._client);

  $async.Future<ListStrategiesResponse> listStrategies(
          $pb.ClientContext? ctx, ListStrategiesRequest request) =>
      _client.invoke<ListStrategiesResponse>(ctx, 'ReportService',
          'ListStrategies', request, ListStrategiesResponse());

  /// Runs the walk-forward evaluation synchronously (M4 moves this to the queue).
  $async.Future<CreateReportResponse> createReport(
          $pb.ClientContext? ctx, CreateReportRequest request) =>
      _client.invoke<CreateReportResponse>(ctx, 'ReportService', 'CreateReport',
          request, CreateReportResponse());
  $async.Future<ListReportsResponse> listReports(
          $pb.ClientContext? ctx, ListReportsRequest request) =>
      _client.invoke<ListReportsResponse>(
          ctx, 'ReportService', 'ListReports', request, ListReportsResponse());
  $async.Future<GetReportResponse> getReport(
          $pb.ClientContext? ctx, GetReportRequest request) =>
      _client.invoke<GetReportResponse>(
          ctx, 'ReportService', 'GetReport', request, GetReportResponse());

  /// Reveals the final holdout. Every call is logged and counted.
  $async.Future<ViewHoldoutResponse> viewHoldout(
          $pb.ClientContext? ctx, ViewHoldoutRequest request) =>
      _client.invoke<ViewHoldoutResponse>(
          ctx, 'ReportService', 'ViewHoldout', request, ViewHoldoutResponse());
  $async.Future<ListTradesResponse> listTrades(
          $pb.ClientContext? ctx, ListTradesRequest request) =>
      _client.invoke<ListTradesResponse>(
          ctx, 'ReportService', 'ListTrades', request, ListTradesResponse());
  $async.Future<ListDecisionsResponse> listDecisions(
          $pb.ClientContext? ctx, ListDecisionsRequest request) =>
      _client.invoke<ListDecisionsResponse>(ctx, 'ReportService',
          'ListDecisions', request, ListDecisionsResponse());
  $async.Future<CompareResponse> compare(
          $pb.ClientContext? ctx, CompareRequest request) =>
      _client.invoke<CompareResponse>(
          ctx, 'ReportService', 'Compare', request, CompareResponse());
  $async.Future<ExportResponse> export(
          $pb.ClientContext? ctx, ExportRequest request) =>
      _client.invoke<ExportResponse>(
          ctx, 'ReportService', 'Export', request, ExportResponse());

  /// Re-evaluates from the stored inputs and checks every number is identical.
  $async.Future<ReproduceResponse> reproduce(
          $pb.ClientContext? ctx, ReproduceRequest request) =>
      _client.invoke<ReproduceResponse>(
          ctx, 'ReportService', 'Reproduce', request, ReproduceResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
