// This is a generated file - do not edit.
//
// Generated from lab/v1/market.proto.

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

import 'common.pb.dart' as $1;
import 'health.pbenum.dart' as $2;
import 'workspace.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetMarketSnapshotRequest extends $pb.GeneratedMessage {
  factory GetMarketSnapshotRequest() => GetMarketSnapshotRequest._();

  GetMarketSnapshotRequest._();

  factory GetMarketSnapshotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMarketSnapshotRequest()..mergeFromBuffer(data, registry);
  factory GetMarketSnapshotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMarketSnapshotRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMarketSnapshotRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetMarketSnapshotRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMarketSnapshotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMarketSnapshotRequest copyWith(
          void Function(GetMarketSnapshotRequest) updates) =>
      super.copyWith((message) => updates(message as GetMarketSnapshotRequest))
          as GetMarketSnapshotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMarketSnapshotRequest() / GetMarketSnapshotRequest.new instead')
  static GetMarketSnapshotRequest create() => GetMarketSnapshotRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMarketSnapshotRequest._();
  @$core.override
  GetMarketSnapshotRequest createEmptyInstance() =>
      GetMarketSnapshotRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMarketSnapshotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMarketSnapshotRequest>(
          GetMarketSnapshotRequest.$_createMessage);
  static GetMarketSnapshotRequest? _defaultInstance;
}

class GetMarketSnapshotResponse extends $pb.GeneratedMessage {
  factory GetMarketSnapshotResponse({
    $fixnum.Int64? observedAtUnixMs,
    $core.Iterable<MarketWatch>? marketWatch,
  }) {
    final result = GetMarketSnapshotResponse._();
    if (observedAtUnixMs != null) result.observedAtUnixMs = observedAtUnixMs;
    if (marketWatch != null) result.marketWatch.addAll(marketWatch);
    return result;
  }

  GetMarketSnapshotResponse._();

  factory GetMarketSnapshotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMarketSnapshotResponse()..mergeFromBuffer(data, registry);
  factory GetMarketSnapshotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMarketSnapshotResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMarketSnapshotResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetMarketSnapshotResponse.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'observedAtUnixMs')
    ..pPM<MarketWatch>(2, _omitFieldNames ? '' : 'marketWatch',
        subBuilder: MarketWatch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMarketSnapshotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMarketSnapshotResponse copyWith(
          void Function(GetMarketSnapshotResponse) updates) =>
      super.copyWith((message) => updates(message as GetMarketSnapshotResponse))
          as GetMarketSnapshotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMarketSnapshotResponse() / GetMarketSnapshotResponse.new instead')
  static GetMarketSnapshotResponse create() => GetMarketSnapshotResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetMarketSnapshotResponse._();
  @$core.override
  GetMarketSnapshotResponse createEmptyInstance() =>
      GetMarketSnapshotResponse._();
  @$core.pragma('dart2js:noInline')
  static GetMarketSnapshotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMarketSnapshotResponse>(
          GetMarketSnapshotResponse.$_createMessage);
  static GetMarketSnapshotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get observedAtUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set observedAtUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservedAtUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservedAtUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<MarketWatch> get marketWatch => $_getList(1);
}

class MarketWatch extends $pb.GeneratedMessage {
  factory MarketWatch({
    $0.InstrumentKey? instrument,
    $2.LiveState? state,
    MarketCandle? candle,
  }) {
    final result = MarketWatch._();
    if (instrument != null) result.instrument = instrument;
    if (state != null) result.state = state;
    if (candle != null) result.candle = candle;
    return result;
  }

  MarketWatch._();

  factory MarketWatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarketWatch()..mergeFromBuffer(data, registry);
  factory MarketWatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarketWatch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarketWatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: MarketWatch.$_createMessage)
    ..aOM<$0.InstrumentKey>(1, _omitFieldNames ? '' : 'instrument',
        subBuilder: $0.InstrumentKey.$_createMessage)
    ..aE<$2.LiveState>(2, _omitFieldNames ? '' : 'state',
        enumValues: $2.LiveState.values)
    ..aOM<MarketCandle>(3, _omitFieldNames ? '' : 'candle',
        subBuilder: MarketCandle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketWatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketWatch copyWith(void Function(MarketWatch) updates) =>
      super.copyWith((message) => updates(message as MarketWatch))
          as MarketWatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MarketWatch() / MarketWatch.new instead')
  static MarketWatch create() => MarketWatch._();
  static $pb.GeneratedMessage $_createMessage() => MarketWatch._();
  @$core.override
  MarketWatch createEmptyInstance() => MarketWatch._();
  @$core.pragma('dart2js:noInline')
  static MarketWatch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarketWatch>(
          MarketWatch.$_createMessage);
  static MarketWatch? _defaultInstance;

  @$pb.TagNumber(1)
  $0.InstrumentKey get instrument => $_getN(0);
  @$pb.TagNumber(1)
  set instrument($0.InstrumentKey value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstrument() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstrument() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.InstrumentKey ensureInstrument() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.LiveState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state($2.LiveState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  MarketCandle get candle => $_getN(2);
  @$pb.TagNumber(3)
  set candle(MarketCandle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCandle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCandle() => $_clearField(3);
  @$pb.TagNumber(3)
  MarketCandle ensureCandle() => $_ensure(2);
}

/// Instrument symbol, open time and revision identify a stored 1m candle.
class MarketCandle extends $pb.GeneratedMessage {
  factory MarketCandle({
    $fixnum.Int64? openedAtUnixMs,
    $fixnum.Int64? closedAtUnixMs,
    $fixnum.Int64? availableAtUnixMs,
    $core.int? revision,
    $1.Money? close,
  }) {
    final result = MarketCandle._();
    if (openedAtUnixMs != null) result.openedAtUnixMs = openedAtUnixMs;
    if (closedAtUnixMs != null) result.closedAtUnixMs = closedAtUnixMs;
    if (availableAtUnixMs != null) result.availableAtUnixMs = availableAtUnixMs;
    if (revision != null) result.revision = revision;
    if (close != null) result.close = close;
    return result;
  }

  MarketCandle._();

  factory MarketCandle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarketCandle()..mergeFromBuffer(data, registry);
  factory MarketCandle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarketCandle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarketCandle',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: MarketCandle.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'openedAtUnixMs')
    ..aInt64(2, _omitFieldNames ? '' : 'closedAtUnixMs')
    ..aInt64(3, _omitFieldNames ? '' : 'availableAtUnixMs')
    ..aI(4, _omitFieldNames ? '' : 'revision')
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'close',
        subBuilder: $1.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketCandle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketCandle copyWith(void Function(MarketCandle) updates) =>
      super.copyWith((message) => updates(message as MarketCandle))
          as MarketCandle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MarketCandle() / MarketCandle.new instead')
  static MarketCandle create() => MarketCandle._();
  static $pb.GeneratedMessage $_createMessage() => MarketCandle._();
  @$core.override
  MarketCandle createEmptyInstance() => MarketCandle._();
  @$core.pragma('dart2js:noInline')
  static MarketCandle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarketCandle>(
          MarketCandle.$_createMessage);
  static MarketCandle? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get openedAtUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set openedAtUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpenedAtUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpenedAtUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get closedAtUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set closedAtUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClosedAtUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearClosedAtUnixMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get availableAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set availableAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvailableAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvailableAtUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get revision => $_getIZ(3);
  @$pb.TagNumber(4)
  set revision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Money get close => $_getN(4);
  @$pb.TagNumber(5)
  set close($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasClose() => $_has(4);
  @$pb.TagNumber(5)
  void clearClose() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureClose() => $_ensure(4);
}

class MarketServiceApi {
  final $pb.RpcClient _client;

  MarketServiceApi(this._client);

  /// Returns the configured spot USDT watchlist and its latest known observations.
  $async.Future<GetMarketSnapshotResponse> getMarketSnapshot(
          $pb.ClientContext? ctx, GetMarketSnapshotRequest request) =>
      _client.invoke<GetMarketSnapshotResponse>(ctx, 'MarketService',
          'GetMarketSnapshot', request, GetMarketSnapshotResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
