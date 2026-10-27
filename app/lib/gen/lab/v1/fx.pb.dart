// This is a generated file - do not edit.
//
// Generated from lab/v1/fx.proto.

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

class FxRate extends $pb.GeneratedMessage {
  factory FxRate({
    $fixnum.Int64? id,
    $core.String? date,
    $0.Money? tomanPerUsdt,
    $core.String? source,
    $fixnum.Int64? enteredUnixMs,
    $core.int? reports,
  }) {
    final result = FxRate._();
    if (id != null) result.id = id;
    if (date != null) result.date = date;
    if (tomanPerUsdt != null) result.tomanPerUsdt = tomanPerUsdt;
    if (source != null) result.source = source;
    if (enteredUnixMs != null) result.enteredUnixMs = enteredUnixMs;
    if (reports != null) result.reports = reports;
    return result;
  }

  FxRate._();

  factory FxRate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FxRate()..mergeFromBuffer(data, registry);
  factory FxRate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FxRate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FxRate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'), createEmptyInstance: FxRate.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'date')
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'tomanPerUsdt', subBuilder: $0.Money.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'source')
    ..aInt64(5, _omitFieldNames ? '' : 'enteredUnixMs')
    ..aI(6, _omitFieldNames ? '' : 'reports')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FxRate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FxRate copyWith(void Function(FxRate) updates) => super.copyWith((message) => updates(message as FxRate)) as FxRate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FxRate() / FxRate.new instead')
  static FxRate create() => FxRate._();
  static $pb.GeneratedMessage $_createMessage() => FxRate._();
  @$core.override
  FxRate createEmptyInstance() => FxRate._();
  @$core.pragma('dart2js:noInline')
  static FxRate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FxRate>(FxRate.$_createMessage);
  static FxRate? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get date => $_getSZ(1);
  @$pb.TagNumber(2)
  set date($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Money get tomanPerUsdt => $_getN(2);
  @$pb.TagNumber(3)
  set tomanPerUsdt($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTomanPerUsdt() => $_has(2);
  @$pb.TagNumber(3)
  void clearTomanPerUsdt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureTomanPerUsdt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get source => $_getSZ(3);
  @$pb.TagNumber(4)
  set source($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get enteredUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set enteredUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnteredUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnteredUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get reports => $_getIZ(5);
  @$pb.TagNumber(6)
  set reports($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReports() => $_has(5);
  @$pb.TagNumber(6)
  void clearReports() => $_clearField(6);
}

class ListRatesRequest extends $pb.GeneratedMessage {
  factory ListRatesRequest({
    $core.int? limit,
  }) {
    final result = ListRatesRequest._();
    if (limit != null) result.limit = limit;
    return result;
  }

  ListRatesRequest._();

  factory ListRatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRatesRequest()..mergeFromBuffer(data, registry);
  factory ListRatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListRatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListRatesRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRatesRequest copyWith(void Function(ListRatesRequest) updates) =>
      super.copyWith((message) => updates(message as ListRatesRequest)) as ListRatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListRatesRequest() / ListRatesRequest.new instead')
  static ListRatesRequest create() => ListRatesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListRatesRequest._();
  @$core.override
  ListRatesRequest createEmptyInstance() => ListRatesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListRatesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRatesRequest>(ListRatesRequest.$_createMessage);
  static ListRatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class ListRatesResponse extends $pb.GeneratedMessage {
  factory ListRatesResponse({
    $core.Iterable<FxRate>? rates,
  }) {
    final result = ListRatesResponse._();
    if (rates != null) result.rates.addAll(rates);
    return result;
  }

  ListRatesResponse._();

  factory ListRatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRatesResponse()..mergeFromBuffer(data, registry);
  factory ListRatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListRatesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListRatesResponse.$_createMessage)
    ..pPM<FxRate>(1, _omitFieldNames ? '' : 'rates', subBuilder: FxRate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRatesResponse copyWith(void Function(ListRatesResponse) updates) =>
      super.copyWith((message) => updates(message as ListRatesResponse)) as ListRatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListRatesResponse() / ListRatesResponse.new instead')
  static ListRatesResponse create() => ListRatesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListRatesResponse._();
  @$core.override
  ListRatesResponse createEmptyInstance() => ListRatesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListRatesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRatesResponse>(ListRatesResponse.$_createMessage);
  static ListRatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FxRate> get rates => $_getList(0);
}

class AddRateRequest extends $pb.GeneratedMessage {
  factory AddRateRequest({
    $core.String? date,
    $core.String? tomanPerUsdt,
    $core.String? source,
  }) {
    final result = AddRateRequest._();
    if (date != null) result.date = date;
    if (tomanPerUsdt != null) result.tomanPerUsdt = tomanPerUsdt;
    if (source != null) result.source = source;
    return result;
  }

  AddRateRequest._();

  factory AddRateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddRateRequest()..mergeFromBuffer(data, registry);
  factory AddRateRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddRateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddRateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AddRateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..aOS(2, _omitFieldNames ? '' : 'tomanPerUsdt')
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRateRequest copyWith(void Function(AddRateRequest) updates) =>
      super.copyWith((message) => updates(message as AddRateRequest)) as AddRateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AddRateRequest() / AddRateRequest.new instead')
  static AddRateRequest create() => AddRateRequest._();
  static $pb.GeneratedMessage $_createMessage() => AddRateRequest._();
  @$core.override
  AddRateRequest createEmptyInstance() => AddRateRequest._();
  @$core.pragma('dart2js:noInline')
  static AddRateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddRateRequest>(AddRateRequest.$_createMessage);
  static AddRateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tomanPerUsdt => $_getSZ(1);
  @$pb.TagNumber(2)
  set tomanPerUsdt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTomanPerUsdt() => $_has(1);
  @$pb.TagNumber(2)
  void clearTomanPerUsdt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);
}

class AddRateResponse extends $pb.GeneratedMessage {
  factory AddRateResponse({
    FxRate? rate,
  }) {
    final result = AddRateResponse._();
    if (rate != null) result.rate = rate;
    return result;
  }

  AddRateResponse._();

  factory AddRateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddRateResponse()..mergeFromBuffer(data, registry);
  factory AddRateResponse.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddRateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddRateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AddRateResponse.$_createMessage)
    ..aOM<FxRate>(1, _omitFieldNames ? '' : 'rate', subBuilder: FxRate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRateResponse copyWith(void Function(AddRateResponse) updates) =>
      super.copyWith((message) => updates(message as AddRateResponse)) as AddRateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AddRateResponse() / AddRateResponse.new instead')
  static AddRateResponse create() => AddRateResponse._();
  static $pb.GeneratedMessage $_createMessage() => AddRateResponse._();
  @$core.override
  AddRateResponse createEmptyInstance() => AddRateResponse._();
  @$core.pragma('dart2js:noInline')
  static AddRateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddRateResponse>(AddRateResponse.$_createMessage);
  static AddRateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FxRate get rate => $_getN(0);
  @$pb.TagNumber(1)
  set rate(FxRate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearRate() => $_clearField(1);
  @$pb.TagNumber(1)
  FxRate ensureRate() => $_ensure(0);
}

/// FxService: USDT/TOMAN display rates. Append-only; display and export only.
class FxServiceApi {
  final $pb.RpcClient _client;

  FxServiceApi(this._client);

  $async.Future<ListRatesResponse> listRates($pb.ClientContext? ctx, ListRatesRequest request) =>
      _client.invoke<ListRatesResponse>(ctx, 'FxService', 'ListRates', request, ListRatesResponse());
  $async.Future<AddRateResponse> addRate($pb.ClientContext? ctx, AddRateRequest request) =>
      _client.invoke<AddRateResponse>(ctx, 'FxService', 'AddRate', request, AddRateResponse());
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
