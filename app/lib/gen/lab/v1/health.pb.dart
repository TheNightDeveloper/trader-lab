// This is a generated file - do not edit.
//
// Generated from lab/v1/health.proto.

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
import 'health.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'health.pbenum.dart';

class WatchRequest extends $pb.GeneratedMessage {
  factory WatchRequest() => WatchRequest._();

  WatchRequest._();

  factory WatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchRequest()..mergeFromBuffer(data, registry);
  factory WatchRequest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WatchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: WatchRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRequest copyWith(void Function(WatchRequest) updates) =>
      super.copyWith((message) => updates(message as WatchRequest)) as WatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WatchRequest() / WatchRequest.new instead')
  static WatchRequest create() => WatchRequest._();
  static $pb.GeneratedMessage $_createMessage() => WatchRequest._();
  @$core.override
  WatchRequest createEmptyInstance() => WatchRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchRequest>(WatchRequest.$_createMessage);
  static WatchRequest? _defaultInstance;
}

class WatchResponse extends $pb.GeneratedMessage {
  factory WatchResponse({
    EngineStatus? status,
  }) {
    final result = WatchResponse._();
    if (status != null) result.status = status;
    return result;
  }

  WatchResponse._();

  factory WatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchResponse()..mergeFromBuffer(data, registry);
  factory WatchResponse.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WatchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: WatchResponse.$_createMessage)
    ..aOM<EngineStatus>(1, _omitFieldNames ? '' : 'status', subBuilder: EngineStatus.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchResponse copyWith(void Function(WatchResponse) updates) =>
      super.copyWith((message) => updates(message as WatchResponse)) as WatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WatchResponse() / WatchResponse.new instead')
  static WatchResponse create() => WatchResponse._();
  static $pb.GeneratedMessage $_createMessage() => WatchResponse._();
  @$core.override
  WatchResponse createEmptyInstance() => WatchResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchResponse>(WatchResponse.$_createMessage);
  static WatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EngineStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(EngineStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  EngineStatus ensureStatus() => $_ensure(0);
}

class EngineStatus extends $pb.GeneratedMessage {
  factory EngineStatus({
    $core.String? version,
    RunMode? mode,
    $core.String? accountingAsset,
    LiveData? live,
    Workers? workers,
    DisplayRate? displayRate,
    $fixnum.Int64? serverTimeUnixMs,
  }) {
    final result = EngineStatus._();
    if (version != null) result.version = version;
    if (mode != null) result.mode = mode;
    if (accountingAsset != null) result.accountingAsset = accountingAsset;
    if (live != null) result.live = live;
    if (workers != null) result.workers = workers;
    if (displayRate != null) result.displayRate = displayRate;
    if (serverTimeUnixMs != null) result.serverTimeUnixMs = serverTimeUnixMs;
    return result;
  }

  EngineStatus._();

  factory EngineStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngineStatus()..mergeFromBuffer(data, registry);
  factory EngineStatus.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngineStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EngineStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: EngineStatus.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aE<RunMode>(2, _omitFieldNames ? '' : 'mode', enumValues: RunMode.values)
    ..aOS(3, _omitFieldNames ? '' : 'accountingAsset')
    ..aOM<LiveData>(4, _omitFieldNames ? '' : 'live', subBuilder: LiveData.$_createMessage)
    ..aOM<Workers>(5, _omitFieldNames ? '' : 'workers', subBuilder: Workers.$_createMessage)
    ..aOM<DisplayRate>(6, _omitFieldNames ? '' : 'displayRate', subBuilder: DisplayRate.$_createMessage)
    ..aInt64(7, _omitFieldNames ? '' : 'serverTimeUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngineStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngineStatus copyWith(void Function(EngineStatus) updates) =>
      super.copyWith((message) => updates(message as EngineStatus)) as EngineStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EngineStatus() / EngineStatus.new instead')
  static EngineStatus create() => EngineStatus._();
  static $pb.GeneratedMessage $_createMessage() => EngineStatus._();
  @$core.override
  EngineStatus createEmptyInstance() => EngineStatus._();
  @$core.pragma('dart2js:noInline')
  static EngineStatus getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EngineStatus>(EngineStatus.$_createMessage);
  static EngineStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  RunMode get mode => $_getN(1);
  @$pb.TagNumber(2)
  set mode(RunMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get accountingAsset => $_getSZ(2);
  @$pb.TagNumber(3)
  set accountingAsset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccountingAsset() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountingAsset() => $_clearField(3);

  @$pb.TagNumber(4)
  LiveData get live => $_getN(3);
  @$pb.TagNumber(4)
  set live(LiveData value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLive() => $_has(3);
  @$pb.TagNumber(4)
  void clearLive() => $_clearField(4);
  @$pb.TagNumber(4)
  LiveData ensureLive() => $_ensure(3);

  @$pb.TagNumber(5)
  Workers get workers => $_getN(4);
  @$pb.TagNumber(5)
  set workers(Workers value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasWorkers() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorkers() => $_clearField(5);
  @$pb.TagNumber(5)
  Workers ensureWorkers() => $_ensure(4);

  @$pb.TagNumber(6)
  DisplayRate get displayRate => $_getN(5);
  @$pb.TagNumber(6)
  set displayRate(DisplayRate value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDisplayRate() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayRate() => $_clearField(6);
  @$pb.TagNumber(6)
  DisplayRate ensureDisplayRate() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get serverTimeUnixMs => $_getI64(6);
  @$pb.TagNumber(7)
  set serverTimeUnixMs($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasServerTimeUnixMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearServerTimeUnixMs() => $_clearField(7);
}

class LiveData extends $pb.GeneratedMessage {
  factory LiveData({
    LiveState? state,
    $fixnum.Int64? lastBarAgeSeconds,
  }) {
    final result = LiveData._();
    if (state != null) result.state = state;
    if (lastBarAgeSeconds != null) result.lastBarAgeSeconds = lastBarAgeSeconds;
    return result;
  }

  LiveData._();

  factory LiveData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveData()..mergeFromBuffer(data, registry);
  factory LiveData.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LiveData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'), createEmptyInstance: LiveData.$_createMessage)
    ..aE<LiveState>(1, _omitFieldNames ? '' : 'state', enumValues: LiveState.values)
    ..aInt64(2, _omitFieldNames ? '' : 'lastBarAgeSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveData copyWith(void Function(LiveData) updates) =>
      super.copyWith((message) => updates(message as LiveData)) as LiveData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LiveData() / LiveData.new instead')
  static LiveData create() => LiveData._();
  static $pb.GeneratedMessage $_createMessage() => LiveData._();
  @$core.override
  LiveData createEmptyInstance() => LiveData._();
  @$core.pragma('dart2js:noInline')
  static LiveData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LiveData>(LiveData.$_createMessage);
  static LiveData? _defaultInstance;

  @$pb.TagNumber(1)
  LiveState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(LiveState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lastBarAgeSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set lastBarAgeSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastBarAgeSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastBarAgeSeconds() => $_clearField(2);
}

class Workers extends $pb.GeneratedMessage {
  factory Workers({
    WorkerState? state,
    $core.int? count,
    $core.int? busy,
  }) {
    final result = Workers._();
    if (state != null) result.state = state;
    if (count != null) result.count = count;
    if (busy != null) result.busy = busy;
    return result;
  }

  Workers._();

  factory Workers.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Workers()..mergeFromBuffer(data, registry);
  factory Workers.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Workers()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Workers',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'), createEmptyInstance: Workers.$_createMessage)
    ..aE<WorkerState>(1, _omitFieldNames ? '' : 'state', enumValues: WorkerState.values)
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aI(3, _omitFieldNames ? '' : 'busy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Workers clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Workers copyWith(void Function(Workers) updates) =>
      super.copyWith((message) => updates(message as Workers)) as Workers;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Workers() / Workers.new instead')
  static Workers create() => Workers._();
  static $pb.GeneratedMessage $_createMessage() => Workers._();
  @$core.override
  Workers createEmptyInstance() => Workers._();
  @$core.pragma('dart2js:noInline')
  static Workers getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Workers>(Workers.$_createMessage);
  static Workers? _defaultInstance;

  @$pb.TagNumber(1)
  WorkerState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(WorkerState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get busy => $_getIZ(2);
  @$pb.TagNumber(3)
  set busy($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBusy() => $_has(2);
  @$pb.TagNumber(3)
  void clearBusy() => $_clearField(3);
}

class DisplayRate extends $pb.GeneratedMessage {
  factory DisplayRate({
    $core.String? rateId,
    $0.Money? tomanPerUsdt,
    $core.String? asOfDate,
    $core.String? source,
  }) {
    final result = DisplayRate._();
    if (rateId != null) result.rateId = rateId;
    if (tomanPerUsdt != null) result.tomanPerUsdt = tomanPerUsdt;
    if (asOfDate != null) result.asOfDate = asOfDate;
    if (source != null) result.source = source;
    return result;
  }

  DisplayRate._();

  factory DisplayRate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DisplayRate()..mergeFromBuffer(data, registry);
  factory DisplayRate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DisplayRate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisplayRate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: DisplayRate.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'rateId')
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'tomanPerUsdt', subBuilder: $0.Money.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'asOfDate')
    ..aOS(4, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisplayRate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisplayRate copyWith(void Function(DisplayRate) updates) =>
      super.copyWith((message) => updates(message as DisplayRate)) as DisplayRate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DisplayRate() / DisplayRate.new instead')
  static DisplayRate create() => DisplayRate._();
  static $pb.GeneratedMessage $_createMessage() => DisplayRate._();
  @$core.override
  DisplayRate createEmptyInstance() => DisplayRate._();
  @$core.pragma('dart2js:noInline')
  static DisplayRate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisplayRate>(DisplayRate.$_createMessage);
  static DisplayRate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Money get tomanPerUsdt => $_getN(1);
  @$pb.TagNumber(2)
  set tomanPerUsdt($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTomanPerUsdt() => $_has(1);
  @$pb.TagNumber(2)
  void clearTomanPerUsdt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensureTomanPerUsdt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get asOfDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set asOfDate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAsOfDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearAsOfDate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get source => $_getSZ(3);
  @$pb.TagNumber(4)
  set source($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);
}

/// HealthService feeds the sidebar status block.
class HealthServiceApi {
  final $pb.RpcClient _client;

  HealthServiceApi(this._client);

  /// Sends the current status immediately, then on every change or heartbeat.
  $async.Future<WatchResponse> watch($pb.ClientContext? ctx, WatchRequest request) =>
      _client.invoke<WatchResponse>(ctx, 'HealthService', 'Watch', request, WatchResponse());
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
