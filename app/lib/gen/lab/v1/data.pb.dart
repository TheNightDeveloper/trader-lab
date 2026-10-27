// This is a generated file - do not edit.
//
// Generated from lab/v1/data.proto.

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

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetOverviewRequest extends $pb.GeneratedMessage {
  factory GetOverviewRequest() => GetOverviewRequest._();

  GetOverviewRequest._();

  factory GetOverviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOverviewRequest()..mergeFromBuffer(data, registry);
  factory GetOverviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOverviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOverviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetOverviewRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverviewRequest copyWith(void Function(GetOverviewRequest) updates) =>
      super.copyWith((message) => updates(message as GetOverviewRequest))
          as GetOverviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetOverviewRequest() / GetOverviewRequest.new instead')
  static GetOverviewRequest create() => GetOverviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOverviewRequest._();
  @$core.override
  GetOverviewRequest createEmptyInstance() => GetOverviewRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOverviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOverviewRequest>(
          GetOverviewRequest.$_createMessage);
  static GetOverviewRequest? _defaultInstance;
}

class GetOverviewResponse extends $pb.GeneratedMessage {
  factory GetOverviewResponse({
    $core.int? liveSymbols,
    $core.String? liveSource,
    $core.int? outagesToday,
    $fixnum.Int64? outageSecondsToday,
    $fixnum.Int64? storageBytes,
    $core.Iterable<$core.String>? symbols,
  }) {
    final result = GetOverviewResponse._();
    if (liveSymbols != null) result.liveSymbols = liveSymbols;
    if (liveSource != null) result.liveSource = liveSource;
    if (outagesToday != null) result.outagesToday = outagesToday;
    if (outageSecondsToday != null)
      result.outageSecondsToday = outageSecondsToday;
    if (storageBytes != null) result.storageBytes = storageBytes;
    if (symbols != null) result.symbols.addAll(symbols);
    return result;
  }

  GetOverviewResponse._();

  factory GetOverviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOverviewResponse()..mergeFromBuffer(data, registry);
  factory GetOverviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOverviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOverviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetOverviewResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'liveSymbols')
    ..aOS(2, _omitFieldNames ? '' : 'liveSource')
    ..aI(3, _omitFieldNames ? '' : 'outagesToday')
    ..aInt64(4, _omitFieldNames ? '' : 'outageSecondsToday')
    ..aInt64(5, _omitFieldNames ? '' : 'storageBytes')
    ..pPS(6, _omitFieldNames ? '' : 'symbols')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverviewResponse copyWith(void Function(GetOverviewResponse) updates) =>
      super.copyWith((message) => updates(message as GetOverviewResponse))
          as GetOverviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetOverviewResponse() / GetOverviewResponse.new instead')
  static GetOverviewResponse create() => GetOverviewResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetOverviewResponse._();
  @$core.override
  GetOverviewResponse createEmptyInstance() => GetOverviewResponse._();
  @$core.pragma('dart2js:noInline')
  static GetOverviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOverviewResponse>(
          GetOverviewResponse.$_createMessage);
  static GetOverviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get liveSymbols => $_getIZ(0);
  @$pb.TagNumber(1)
  set liveSymbols($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLiveSymbols() => $_has(0);
  @$pb.TagNumber(1)
  void clearLiveSymbols() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get liveSource => $_getSZ(1);
  @$pb.TagNumber(2)
  set liveSource($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLiveSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearLiveSource() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get outagesToday => $_getIZ(2);
  @$pb.TagNumber(3)
  set outagesToday($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOutagesToday() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutagesToday() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get outageSecondsToday => $_getI64(3);
  @$pb.TagNumber(4)
  set outageSecondsToday($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutageSecondsToday() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutageSecondsToday() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get storageBytes => $_getI64(4);
  @$pb.TagNumber(5)
  set storageBytes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStorageBytes() => $_has(4);
  @$pb.TagNumber(5)
  void clearStorageBytes() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get symbols => $_getList(5);
}

class Dataset extends $pb.GeneratedMessage {
  factory Dataset({
    $core.String? id,
    $core.String? symbol,
    $core.String? timeframe,
    $fixnum.Int64? fromUnixMs,
    $fixnum.Int64? toUnixMs,
    $core.String? gapPolicy,
    $core.int? barCount,
    $core.int? gaps,
    $core.int? filled,
    $fixnum.Int64? createdUnixMs,
    $core.int? experiments,
  }) {
    final result = Dataset._();
    if (id != null) result.id = id;
    if (symbol != null) result.symbol = symbol;
    if (timeframe != null) result.timeframe = timeframe;
    if (fromUnixMs != null) result.fromUnixMs = fromUnixMs;
    if (toUnixMs != null) result.toUnixMs = toUnixMs;
    if (gapPolicy != null) result.gapPolicy = gapPolicy;
    if (barCount != null) result.barCount = barCount;
    if (gaps != null) result.gaps = gaps;
    if (filled != null) result.filled = filled;
    if (createdUnixMs != null) result.createdUnixMs = createdUnixMs;
    if (experiments != null) result.experiments = experiments;
    return result;
  }

  Dataset._();

  factory Dataset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Dataset()..mergeFromBuffer(data, registry);
  factory Dataset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Dataset()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Dataset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Dataset.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'symbol')
    ..aOS(3, _omitFieldNames ? '' : 'timeframe')
    ..aInt64(4, _omitFieldNames ? '' : 'fromUnixMs')
    ..aInt64(5, _omitFieldNames ? '' : 'toUnixMs')
    ..aOS(6, _omitFieldNames ? '' : 'gapPolicy')
    ..aI(7, _omitFieldNames ? '' : 'barCount')
    ..aI(8, _omitFieldNames ? '' : 'gaps')
    ..aI(9, _omitFieldNames ? '' : 'filled')
    ..aInt64(10, _omitFieldNames ? '' : 'createdUnixMs')
    ..aI(11, _omitFieldNames ? '' : 'experiments')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dataset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dataset copyWith(void Function(Dataset) updates) =>
      super.copyWith((message) => updates(message as Dataset)) as Dataset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Dataset() / Dataset.new instead')
  static Dataset create() => Dataset._();
  static $pb.GeneratedMessage $_createMessage() => Dataset._();
  @$core.override
  Dataset createEmptyInstance() => Dataset._();
  @$core.pragma('dart2js:noInline')
  static Dataset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Dataset>(Dataset.$_createMessage);
  static Dataset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
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
  $core.String get timeframe => $_getSZ(2);
  @$pb.TagNumber(3)
  set timeframe($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeframe() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeframe() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get fromUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set fromUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFromUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearFromUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get toUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set toUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasToUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearToUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get gapPolicy => $_getSZ(5);
  @$pb.TagNumber(6)
  set gapPolicy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGapPolicy() => $_has(5);
  @$pb.TagNumber(6)
  void clearGapPolicy() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get barCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set barCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBarCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearBarCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get gaps => $_getIZ(7);
  @$pb.TagNumber(8)
  set gaps($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGaps() => $_has(7);
  @$pb.TagNumber(8)
  void clearGaps() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get filled => $_getIZ(8);
  @$pb.TagNumber(9)
  set filled($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFilled() => $_has(8);
  @$pb.TagNumber(9)
  void clearFilled() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createdUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set createdUnixMs($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedUnixMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get experiments => $_getIZ(10);
  @$pb.TagNumber(11)
  set experiments($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExperiments() => $_has(10);
  @$pb.TagNumber(11)
  void clearExperiments() => $_clearField(11);
}

class ListDatasetsRequest extends $pb.GeneratedMessage {
  factory ListDatasetsRequest({
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = ListDatasetsRequest._();
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListDatasetsRequest._();

  factory ListDatasetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDatasetsRequest()..mergeFromBuffer(data, registry);
  factory ListDatasetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDatasetsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDatasetsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListDatasetsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aI(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDatasetsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDatasetsRequest copyWith(void Function(ListDatasetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDatasetsRequest))
          as ListDatasetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListDatasetsRequest() / ListDatasetsRequest.new instead')
  static ListDatasetsRequest create() => ListDatasetsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListDatasetsRequest._();
  @$core.override
  ListDatasetsRequest createEmptyInstance() => ListDatasetsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListDatasetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDatasetsRequest>(
          ListDatasetsRequest.$_createMessage);
  static ListDatasetsRequest? _defaultInstance;

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

class ListDatasetsResponse extends $pb.GeneratedMessage {
  factory ListDatasetsResponse({
    $core.Iterable<Dataset>? datasets,
    $fixnum.Int64? total,
  }) {
    final result = ListDatasetsResponse._();
    if (datasets != null) result.datasets.addAll(datasets);
    if (total != null) result.total = total;
    return result;
  }

  ListDatasetsResponse._();

  factory ListDatasetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDatasetsResponse()..mergeFromBuffer(data, registry);
  factory ListDatasetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDatasetsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDatasetsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListDatasetsResponse.$_createMessage)
    ..pPM<Dataset>(1, _omitFieldNames ? '' : 'datasets',
        subBuilder: Dataset.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDatasetsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDatasetsResponse copyWith(void Function(ListDatasetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListDatasetsResponse))
          as ListDatasetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListDatasetsResponse() / ListDatasetsResponse.new instead')
  static ListDatasetsResponse create() => ListDatasetsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListDatasetsResponse._();
  @$core.override
  ListDatasetsResponse createEmptyInstance() => ListDatasetsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListDatasetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDatasetsResponse>(
          ListDatasetsResponse.$_createMessage);
  static ListDatasetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Dataset> get datasets => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetCoverageRequest extends $pb.GeneratedMessage {
  factory GetCoverageRequest() => GetCoverageRequest._();

  GetCoverageRequest._();

  factory GetCoverageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCoverageRequest()..mergeFromBuffer(data, registry);
  factory GetCoverageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCoverageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCoverageRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetCoverageRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCoverageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCoverageRequest copyWith(void Function(GetCoverageRequest) updates) =>
      super.copyWith((message) => updates(message as GetCoverageRequest))
          as GetCoverageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetCoverageRequest() / GetCoverageRequest.new instead')
  static GetCoverageRequest create() => GetCoverageRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCoverageRequest._();
  @$core.override
  GetCoverageRequest createEmptyInstance() => GetCoverageRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCoverageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCoverageRequest>(
          GetCoverageRequest.$_createMessage);
  static GetCoverageRequest? _defaultInstance;
}

class Coverage extends $pb.GeneratedMessage {
  factory Coverage({
    $core.String? symbol,
    $fixnum.Int64? firstOpenUnixMs,
    $fixnum.Int64? lastOpenUnixMs,
    $fixnum.Int64? bars,
    $core.Iterable<TimeRange>? problems,
    $core.Iterable<TimeRange>? segments,
  }) {
    final result = Coverage._();
    if (symbol != null) result.symbol = symbol;
    if (firstOpenUnixMs != null) result.firstOpenUnixMs = firstOpenUnixMs;
    if (lastOpenUnixMs != null) result.lastOpenUnixMs = lastOpenUnixMs;
    if (bars != null) result.bars = bars;
    if (problems != null) result.problems.addAll(problems);
    if (segments != null) result.segments.addAll(segments);
    return result;
  }

  Coverage._();

  factory Coverage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Coverage()..mergeFromBuffer(data, registry);
  factory Coverage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Coverage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Coverage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Coverage.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aInt64(2, _omitFieldNames ? '' : 'firstOpenUnixMs')
    ..aInt64(3, _omitFieldNames ? '' : 'lastOpenUnixMs')
    ..aInt64(4, _omitFieldNames ? '' : 'bars')
    ..pPM<TimeRange>(5, _omitFieldNames ? '' : 'problems',
        subBuilder: TimeRange.$_createMessage)
    ..pPM<TimeRange>(6, _omitFieldNames ? '' : 'segments',
        subBuilder: TimeRange.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coverage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coverage copyWith(void Function(Coverage) updates) =>
      super.copyWith((message) => updates(message as Coverage)) as Coverage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Coverage() / Coverage.new instead')
  static Coverage create() => Coverage._();
  static $pb.GeneratedMessage $_createMessage() => Coverage._();
  @$core.override
  Coverage createEmptyInstance() => Coverage._();
  @$core.pragma('dart2js:noInline')
  static Coverage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Coverage>(Coverage.$_createMessage);
  static Coverage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get firstOpenUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set firstOpenUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFirstOpenUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearFirstOpenUnixMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get lastOpenUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set lastOpenUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastOpenUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastOpenUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get bars => $_getI64(3);
  @$pb.TagNumber(4)
  set bars($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBars() => $_has(3);
  @$pb.TagNumber(4)
  void clearBars() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<TimeRange> get problems => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<TimeRange> get segments => $_getList(5);
}

class TimeRange extends $pb.GeneratedMessage {
  factory TimeRange({
    $fixnum.Int64? fromUnixMs,
    $fixnum.Int64? untilUnixMs,
  }) {
    final result = TimeRange._();
    if (fromUnixMs != null) result.fromUnixMs = fromUnixMs;
    if (untilUnixMs != null) result.untilUnixMs = untilUnixMs;
    return result;
  }

  TimeRange._();

  factory TimeRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TimeRange()..mergeFromBuffer(data, registry);
  factory TimeRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TimeRange()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimeRange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: TimeRange.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'fromUnixMs')
    ..aInt64(2, _omitFieldNames ? '' : 'untilUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeRange copyWith(void Function(TimeRange) updates) =>
      super.copyWith((message) => updates(message as TimeRange)) as TimeRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TimeRange() / TimeRange.new instead')
  static TimeRange create() => TimeRange._();
  static $pb.GeneratedMessage $_createMessage() => TimeRange._();
  @$core.override
  TimeRange createEmptyInstance() => TimeRange._();
  @$core.pragma('dart2js:noInline')
  static TimeRange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TimeRange>(TimeRange.$_createMessage);
  static TimeRange? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fromUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set fromUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get untilUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set untilUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUntilUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearUntilUnixMs() => $_clearField(2);
}

class GetCoverageResponse extends $pb.GeneratedMessage {
  factory GetCoverageResponse({
    $core.Iterable<Coverage>? coverage,
  }) {
    final result = GetCoverageResponse._();
    if (coverage != null) result.coverage.addAll(coverage);
    return result;
  }

  GetCoverageResponse._();

  factory GetCoverageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCoverageResponse()..mergeFromBuffer(data, registry);
  factory GetCoverageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCoverageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCoverageResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetCoverageResponse.$_createMessage)
    ..pPM<Coverage>(1, _omitFieldNames ? '' : 'coverage',
        subBuilder: Coverage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCoverageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCoverageResponse copyWith(void Function(GetCoverageResponse) updates) =>
      super.copyWith((message) => updates(message as GetCoverageResponse))
          as GetCoverageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetCoverageResponse() / GetCoverageResponse.new instead')
  static GetCoverageResponse create() => GetCoverageResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetCoverageResponse._();
  @$core.override
  GetCoverageResponse createEmptyInstance() => GetCoverageResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCoverageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCoverageResponse>(
          GetCoverageResponse.$_createMessage);
  static GetCoverageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Coverage> get coverage => $_getList(0);
}

class QualityIssue extends $pb.GeneratedMessage {
  factory QualityIssue({
    $fixnum.Int64? id,
    $core.String? symbol,
    $core.String? kind,
    $fixnum.Int64? atUnixMs,
    $fixnum.Int64? untilUnixMs,
    $core.String? detail,
  }) {
    final result = QualityIssue._();
    if (id != null) result.id = id;
    if (symbol != null) result.symbol = symbol;
    if (kind != null) result.kind = kind;
    if (atUnixMs != null) result.atUnixMs = atUnixMs;
    if (untilUnixMs != null) result.untilUnixMs = untilUnixMs;
    if (detail != null) result.detail = detail;
    return result;
  }

  QualityIssue._();

  factory QualityIssue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QualityIssue()..mergeFromBuffer(data, registry);
  factory QualityIssue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QualityIssue()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QualityIssue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: QualityIssue.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'symbol')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aInt64(4, _omitFieldNames ? '' : 'atUnixMs')
    ..aInt64(5, _omitFieldNames ? '' : 'untilUnixMs')
    ..aOS(6, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityIssue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QualityIssue copyWith(void Function(QualityIssue) updates) =>
      super.copyWith((message) => updates(message as QualityIssue))
          as QualityIssue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QualityIssue() / QualityIssue.new instead')
  static QualityIssue create() => QualityIssue._();
  static $pb.GeneratedMessage $_createMessage() => QualityIssue._();
  @$core.override
  QualityIssue createEmptyInstance() => QualityIssue._();
  @$core.pragma('dart2js:noInline')
  static QualityIssue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QualityIssue>(
          QualityIssue.$_createMessage);
  static QualityIssue? _defaultInstance;

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
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get atUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set atUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAtUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearAtUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get untilUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set untilUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUntilUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearUntilUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get detail => $_getSZ(5);
  @$pb.TagNumber(6)
  set detail($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDetail() => $_has(5);
  @$pb.TagNumber(6)
  void clearDetail() => $_clearField(6);
}

class ListQualityIssuesRequest extends $pb.GeneratedMessage {
  factory ListQualityIssuesRequest({
    $core.String? symbol,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = ListQualityIssuesRequest._();
    if (symbol != null) result.symbol = symbol;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListQualityIssuesRequest._();

  factory ListQualityIssuesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListQualityIssuesRequest()..mergeFromBuffer(data, registry);
  factory ListQualityIssuesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListQualityIssuesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListQualityIssuesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListQualityIssuesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aI(3, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityIssuesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityIssuesRequest copyWith(
          void Function(ListQualityIssuesRequest) updates) =>
      super.copyWith((message) => updates(message as ListQualityIssuesRequest))
          as ListQualityIssuesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListQualityIssuesRequest() / ListQualityIssuesRequest.new instead')
  static ListQualityIssuesRequest create() => ListQualityIssuesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListQualityIssuesRequest._();
  @$core.override
  ListQualityIssuesRequest createEmptyInstance() =>
      ListQualityIssuesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListQualityIssuesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListQualityIssuesRequest>(
          ListQualityIssuesRequest.$_createMessage);
  static ListQualityIssuesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

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

class ListQualityIssuesResponse extends $pb.GeneratedMessage {
  factory ListQualityIssuesResponse({
    $core.Iterable<QualityIssue>? issues,
    $fixnum.Int64? total,
  }) {
    final result = ListQualityIssuesResponse._();
    if (issues != null) result.issues.addAll(issues);
    if (total != null) result.total = total;
    return result;
  }

  ListQualityIssuesResponse._();

  factory ListQualityIssuesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListQualityIssuesResponse()..mergeFromBuffer(data, registry);
  factory ListQualityIssuesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListQualityIssuesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListQualityIssuesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListQualityIssuesResponse.$_createMessage)
    ..pPM<QualityIssue>(1, _omitFieldNames ? '' : 'issues',
        subBuilder: QualityIssue.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityIssuesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQualityIssuesResponse copyWith(
          void Function(ListQualityIssuesResponse) updates) =>
      super.copyWith((message) => updates(message as ListQualityIssuesResponse))
          as ListQualityIssuesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListQualityIssuesResponse() / ListQualityIssuesResponse.new instead')
  static ListQualityIssuesResponse create() => ListQualityIssuesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListQualityIssuesResponse._();
  @$core.override
  ListQualityIssuesResponse createEmptyInstance() =>
      ListQualityIssuesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListQualityIssuesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListQualityIssuesResponse>(
          ListQualityIssuesResponse.$_createMessage);
  static ListQualityIssuesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<QualityIssue> get issues => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class ImportRequest extends $pb.GeneratedMessage {
  factory ImportRequest({
    $core.Iterable<$core.String>? symbols,
    $core.String? fromDate,
    $core.String? toDate,
    $core.String? timeframe,
    $core.String? gapPolicy,
  }) {
    final result = ImportRequest._();
    if (symbols != null) result.symbols.addAll(symbols);
    if (fromDate != null) result.fromDate = fromDate;
    if (toDate != null) result.toDate = toDate;
    if (timeframe != null) result.timeframe = timeframe;
    if (gapPolicy != null) result.gapPolicy = gapPolicy;
    return result;
  }

  ImportRequest._();

  factory ImportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportRequest()..mergeFromBuffer(data, registry);
  factory ImportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ImportRequest.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'symbols')
    ..aOS(2, _omitFieldNames ? '' : 'fromDate')
    ..aOS(3, _omitFieldNames ? '' : 'toDate')
    ..aOS(4, _omitFieldNames ? '' : 'timeframe')
    ..aOS(5, _omitFieldNames ? '' : 'gapPolicy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportRequest copyWith(void Function(ImportRequest) updates) =>
      super.copyWith((message) => updates(message as ImportRequest))
          as ImportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImportRequest() / ImportRequest.new instead')
  static ImportRequest create() => ImportRequest._();
  static $pb.GeneratedMessage $_createMessage() => ImportRequest._();
  @$core.override
  ImportRequest createEmptyInstance() => ImportRequest._();
  @$core.pragma('dart2js:noInline')
  static ImportRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportRequest>(
          ImportRequest.$_createMessage);
  static ImportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get symbols => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get fromDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromDate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get toDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set toDate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearToDate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get timeframe => $_getSZ(3);
  @$pb.TagNumber(4)
  set timeframe($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimeframe() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeframe() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get gapPolicy => $_getSZ(4);
  @$pb.TagNumber(5)
  set gapPolicy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGapPolicy() => $_has(4);
  @$pb.TagNumber(5)
  void clearGapPolicy() => $_clearField(5);
}

enum ImportResponse_Event { progress, dataset, notSet }

class ImportResponse extends $pb.GeneratedMessage {
  factory ImportResponse({
    ImportProgress? progress,
    Dataset? dataset,
  }) {
    final result = ImportResponse._();
    if (progress != null) result.progress = progress;
    if (dataset != null) result.dataset = dataset;
    return result;
  }

  ImportResponse._();

  factory ImportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportResponse()..mergeFromBuffer(data, registry);
  factory ImportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportResponse()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ImportResponse_Event>
      _ImportResponse_EventByTag = {
    1: ImportResponse_Event.progress,
    2: ImportResponse_Event.dataset,
    0: ImportResponse_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ImportResponse.$_createMessage)
    ..oo(0, [1, 2])
    ..aOM<ImportProgress>(1, _omitFieldNames ? '' : 'progress',
        subBuilder: ImportProgress.$_createMessage)
    ..aOM<Dataset>(2, _omitFieldNames ? '' : 'dataset',
        subBuilder: Dataset.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportResponse copyWith(void Function(ImportResponse) updates) =>
      super.copyWith((message) => updates(message as ImportResponse))
          as ImportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImportResponse() / ImportResponse.new instead')
  static ImportResponse create() => ImportResponse._();
  static $pb.GeneratedMessage $_createMessage() => ImportResponse._();
  @$core.override
  ImportResponse createEmptyInstance() => ImportResponse._();
  @$core.pragma('dart2js:noInline')
  static ImportResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportResponse>(
          ImportResponse.$_createMessage);
  static ImportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  ImportResponse_Event whichEvent() =>
      _ImportResponse_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ImportProgress get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(ImportProgress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => $_clearField(1);
  @$pb.TagNumber(1)
  ImportProgress ensureProgress() => $_ensure(0);

  @$pb.TagNumber(2)
  Dataset get dataset => $_getN(1);
  @$pb.TagNumber(2)
  set dataset(Dataset value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDataset() => $_has(1);
  @$pb.TagNumber(2)
  void clearDataset() => $_clearField(2);
  @$pb.TagNumber(2)
  Dataset ensureDataset() => $_ensure(1);
}

class ImportProgress extends $pb.GeneratedMessage {
  factory ImportProgress({
    $core.String? symbol,
    $core.String? file,
    $core.int? filesDone,
    $core.int? filesTotal,
    $core.int? rows,
    $core.int? inserted,
    $core.int? corrections,
    $core.int? missing,
  }) {
    final result = ImportProgress._();
    if (symbol != null) result.symbol = symbol;
    if (file != null) result.file = file;
    if (filesDone != null) result.filesDone = filesDone;
    if (filesTotal != null) result.filesTotal = filesTotal;
    if (rows != null) result.rows = rows;
    if (inserted != null) result.inserted = inserted;
    if (corrections != null) result.corrections = corrections;
    if (missing != null) result.missing = missing;
    return result;
  }

  ImportProgress._();

  factory ImportProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportProgress()..mergeFromBuffer(data, registry);
  factory ImportProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImportProgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportProgress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ImportProgress.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aOS(2, _omitFieldNames ? '' : 'file')
    ..aI(3, _omitFieldNames ? '' : 'filesDone')
    ..aI(4, _omitFieldNames ? '' : 'filesTotal')
    ..aI(5, _omitFieldNames ? '' : 'rows')
    ..aI(6, _omitFieldNames ? '' : 'inserted')
    ..aI(7, _omitFieldNames ? '' : 'corrections')
    ..aI(8, _omitFieldNames ? '' : 'missing')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportProgress copyWith(void Function(ImportProgress) updates) =>
      super.copyWith((message) => updates(message as ImportProgress))
          as ImportProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImportProgress() / ImportProgress.new instead')
  static ImportProgress create() => ImportProgress._();
  static $pb.GeneratedMessage $_createMessage() => ImportProgress._();
  @$core.override
  ImportProgress createEmptyInstance() => ImportProgress._();
  @$core.pragma('dart2js:noInline')
  static ImportProgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportProgress>(
          ImportProgress.$_createMessage);
  static ImportProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get file => $_getSZ(1);
  @$pb.TagNumber(2)
  set file($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get filesDone => $_getIZ(2);
  @$pb.TagNumber(3)
  set filesDone($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilesDone() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilesDone() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get filesTotal => $_getIZ(3);
  @$pb.TagNumber(4)
  set filesTotal($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFilesTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearFilesTotal() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get rows => $_getIZ(4);
  @$pb.TagNumber(5)
  set rows($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRows() => $_has(4);
  @$pb.TagNumber(5)
  void clearRows() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get inserted => $_getIZ(5);
  @$pb.TagNumber(6)
  set inserted($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInserted() => $_has(5);
  @$pb.TagNumber(6)
  void clearInserted() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get corrections => $_getIZ(6);
  @$pb.TagNumber(7)
  set corrections($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCorrections() => $_has(6);
  @$pb.TagNumber(7)
  void clearCorrections() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get missing => $_getIZ(7);
  @$pb.TagNumber(8)
  set missing($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMissing() => $_has(7);
  @$pb.TagNumber(8)
  void clearMissing() => $_clearField(8);
}

/// DataService: datasets, coverage, quality issues, live feed, archive import.
class DataServiceApi {
  final $pb.RpcClient _client;

  DataServiceApi(this._client);

  $async.Future<GetOverviewResponse> getOverview(
          $pb.ClientContext? ctx, GetOverviewRequest request) =>
      _client.invoke<GetOverviewResponse>(
          ctx, 'DataService', 'GetOverview', request, GetOverviewResponse());
  $async.Future<ListDatasetsResponse> listDatasets(
          $pb.ClientContext? ctx, ListDatasetsRequest request) =>
      _client.invoke<ListDatasetsResponse>(
          ctx, 'DataService', 'ListDatasets', request, ListDatasetsResponse());
  $async.Future<GetCoverageResponse> getCoverage(
          $pb.ClientContext? ctx, GetCoverageRequest request) =>
      _client.invoke<GetCoverageResponse>(
          ctx, 'DataService', 'GetCoverage', request, GetCoverageResponse());
  $async.Future<ListQualityIssuesResponse> listQualityIssues(
          $pb.ClientContext? ctx, ListQualityIssuesRequest request) =>
      _client.invoke<ListQualityIssuesResponse>(ctx, 'DataService',
          'ListQualityIssues', request, ListQualityIssuesResponse());

  /// Imports archive files for each symbol, then creates one dataset version per
  /// symbol. Streams progress; the stream ends after the last dataset.
  $async.Future<ImportResponse> import(
          $pb.ClientContext? ctx, ImportRequest request) =>
      _client.invoke<ImportResponse>(
          ctx, 'DataService', 'Import', request, ImportResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
