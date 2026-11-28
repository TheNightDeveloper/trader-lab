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
import 'market.pbenum.dart';
import 'workspace.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'market.pbenum.dart';

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
    $core.Iterable<MarketOpportunity>? opportunities,
    $core.Iterable<MarketScanSubscription>? scanSubscriptions,
  }) {
    final result = GetMarketSnapshotResponse._();
    if (observedAtUnixMs != null) result.observedAtUnixMs = observedAtUnixMs;
    if (marketWatch != null) result.marketWatch.addAll(marketWatch);
    if (opportunities != null) result.opportunities.addAll(opportunities);
    if (scanSubscriptions != null)
      result.scanSubscriptions.addAll(scanSubscriptions);
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
    ..pPM<MarketOpportunity>(3, _omitFieldNames ? '' : 'opportunities',
        subBuilder: MarketOpportunity.$_createMessage)
    ..pPM<MarketScanSubscription>(4, _omitFieldNames ? '' : 'scanSubscriptions',
        subBuilder: MarketScanSubscription.$_createMessage)
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

  @$pb.TagNumber(3)
  $pb.PbList<MarketOpportunity> get opportunities => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<MarketScanSubscription> get scanSubscriptions => $_getList(3);
}

class SetMarketScanSubscriptionRequest extends $pb.GeneratedMessage {
  factory SetMarketScanSubscriptionRequest({
    $core.String? symbol,
    $fixnum.Int64? ruleVersionId,
    $core.bool? enabled,
  }) {
    final result = SetMarketScanSubscriptionRequest._();
    if (symbol != null) result.symbol = symbol;
    if (ruleVersionId != null) result.ruleVersionId = ruleVersionId;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  SetMarketScanSubscriptionRequest._();

  factory SetMarketScanSubscriptionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetMarketScanSubscriptionRequest()..mergeFromBuffer(data, registry);
  factory SetMarketScanSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetMarketScanSubscriptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetMarketScanSubscriptionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SetMarketScanSubscriptionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aInt64(2, _omitFieldNames ? '' : 'ruleVersionId')
    ..aOB(3, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetMarketScanSubscriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetMarketScanSubscriptionRequest copyWith(
          void Function(SetMarketScanSubscriptionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetMarketScanSubscriptionRequest))
          as SetMarketScanSubscriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetMarketScanSubscriptionRequest() / SetMarketScanSubscriptionRequest.new instead')
  static SetMarketScanSubscriptionRequest create() =>
      SetMarketScanSubscriptionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetMarketScanSubscriptionRequest._();
  @$core.override
  SetMarketScanSubscriptionRequest createEmptyInstance() =>
      SetMarketScanSubscriptionRequest._();
  @$core.pragma('dart2js:noInline')
  static SetMarketScanSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetMarketScanSubscriptionRequest>(
          SetMarketScanSubscriptionRequest.$_createMessage);
  static SetMarketScanSubscriptionRequest? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.bool get enabled => $_getBF(2);
  @$pb.TagNumber(3)
  set enabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnabled() => $_clearField(3);
}

class SetMarketScanSubscriptionResponse extends $pb.GeneratedMessage {
  factory SetMarketScanSubscriptionResponse() =>
      SetMarketScanSubscriptionResponse._();

  SetMarketScanSubscriptionResponse._();

  factory SetMarketScanSubscriptionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetMarketScanSubscriptionResponse()..mergeFromBuffer(data, registry);
  factory SetMarketScanSubscriptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetMarketScanSubscriptionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetMarketScanSubscriptionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SetMarketScanSubscriptionResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetMarketScanSubscriptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetMarketScanSubscriptionResponse copyWith(
          void Function(SetMarketScanSubscriptionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SetMarketScanSubscriptionResponse))
          as SetMarketScanSubscriptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetMarketScanSubscriptionResponse() / SetMarketScanSubscriptionResponse.new instead')
  static SetMarketScanSubscriptionResponse create() =>
      SetMarketScanSubscriptionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetMarketScanSubscriptionResponse._();
  @$core.override
  SetMarketScanSubscriptionResponse createEmptyInstance() =>
      SetMarketScanSubscriptionResponse._();
  @$core.pragma('dart2js:noInline')
  static SetMarketScanSubscriptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetMarketScanSubscriptionResponse>(
          SetMarketScanSubscriptionResponse.$_createMessage);
  static SetMarketScanSubscriptionResponse? _defaultInstance;
}

class MarketScanSubscription extends $pb.GeneratedMessage {
  factory MarketScanSubscription({
    $core.String? symbol,
    $fixnum.Int64? ruleVersionId,
    $core.String? ruleTitle,
    MarketScanState? lastState,
    $fixnum.Int64? lastCandleClosedAtUnixMs,
  }) {
    final result = MarketScanSubscription._();
    if (symbol != null) result.symbol = symbol;
    if (ruleVersionId != null) result.ruleVersionId = ruleVersionId;
    if (ruleTitle != null) result.ruleTitle = ruleTitle;
    if (lastState != null) result.lastState = lastState;
    if (lastCandleClosedAtUnixMs != null)
      result.lastCandleClosedAtUnixMs = lastCandleClosedAtUnixMs;
    return result;
  }

  MarketScanSubscription._();

  factory MarketScanSubscription.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarketScanSubscription()..mergeFromBuffer(data, registry);
  factory MarketScanSubscription.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarketScanSubscription()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarketScanSubscription',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: MarketScanSubscription.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aInt64(2, _omitFieldNames ? '' : 'ruleVersionId')
    ..aOS(3, _omitFieldNames ? '' : 'ruleTitle')
    ..aE<MarketScanState>(4, _omitFieldNames ? '' : 'lastState',
        enumValues: MarketScanState.values)
    ..aInt64(5, _omitFieldNames ? '' : 'lastCandleClosedAtUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketScanSubscription clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketScanSubscription copyWith(
          void Function(MarketScanSubscription) updates) =>
      super.copyWith((message) => updates(message as MarketScanSubscription))
          as MarketScanSubscription;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarketScanSubscription() / MarketScanSubscription.new instead')
  static MarketScanSubscription create() => MarketScanSubscription._();
  static $pb.GeneratedMessage $_createMessage() => MarketScanSubscription._();
  @$core.override
  MarketScanSubscription createEmptyInstance() => MarketScanSubscription._();
  @$core.pragma('dart2js:noInline')
  static MarketScanSubscription getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarketScanSubscription>(
          MarketScanSubscription.$_createMessage);
  static MarketScanSubscription? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get ruleTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set ruleTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRuleTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuleTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  MarketScanState get lastState => $_getN(3);
  @$pb.TagNumber(4)
  set lastState(MarketScanState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLastState() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastState() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get lastCandleClosedAtUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set lastCandleClosedAtUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLastCandleClosedAtUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastCandleClosedAtUnixMs() => $_clearField(5);
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

class ScanMarketOpportunityRequest extends $pb.GeneratedMessage {
  factory ScanMarketOpportunityRequest({
    $fixnum.Int64? ruleVersionId,
    $core.String? symbol,
  }) {
    final result = ScanMarketOpportunityRequest._();
    if (ruleVersionId != null) result.ruleVersionId = ruleVersionId;
    if (symbol != null) result.symbol = symbol;
    return result;
  }

  ScanMarketOpportunityRequest._();

  factory ScanMarketOpportunityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanMarketOpportunityRequest()..mergeFromBuffer(data, registry);
  factory ScanMarketOpportunityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanMarketOpportunityRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanMarketOpportunityRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ScanMarketOpportunityRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'ruleVersionId')
    ..aOS(2, _omitFieldNames ? '' : 'symbol')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanMarketOpportunityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanMarketOpportunityRequest copyWith(
          void Function(ScanMarketOpportunityRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScanMarketOpportunityRequest))
          as ScanMarketOpportunityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScanMarketOpportunityRequest() / ScanMarketOpportunityRequest.new instead')
  static ScanMarketOpportunityRequest create() =>
      ScanMarketOpportunityRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScanMarketOpportunityRequest._();
  @$core.override
  ScanMarketOpportunityRequest createEmptyInstance() =>
      ScanMarketOpportunityRequest._();
  @$core.pragma('dart2js:noInline')
  static ScanMarketOpportunityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanMarketOpportunityRequest>(
          ScanMarketOpportunityRequest.$_createMessage);
  static ScanMarketOpportunityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ruleVersionId => $_getI64(0);
  @$pb.TagNumber(1)
  set ruleVersionId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRuleVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRuleVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get symbol => $_getSZ(1);
  @$pb.TagNumber(2)
  set symbol($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSymbol() => $_has(1);
  @$pb.TagNumber(2)
  void clearSymbol() => $_clearField(2);
}

class ScanMarketOpportunityResponse extends $pb.GeneratedMessage {
  factory ScanMarketOpportunityResponse({
    MarketScanState? state,
    MarketOpportunity? opportunity,
  }) {
    final result = ScanMarketOpportunityResponse._();
    if (state != null) result.state = state;
    if (opportunity != null) result.opportunity = opportunity;
    return result;
  }

  ScanMarketOpportunityResponse._();

  factory ScanMarketOpportunityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanMarketOpportunityResponse()..mergeFromBuffer(data, registry);
  factory ScanMarketOpportunityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanMarketOpportunityResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanMarketOpportunityResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ScanMarketOpportunityResponse.$_createMessage)
    ..aE<MarketScanState>(1, _omitFieldNames ? '' : 'state',
        enumValues: MarketScanState.values)
    ..aOM<MarketOpportunity>(2, _omitFieldNames ? '' : 'opportunity',
        subBuilder: MarketOpportunity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanMarketOpportunityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanMarketOpportunityResponse copyWith(
          void Function(ScanMarketOpportunityResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScanMarketOpportunityResponse))
          as ScanMarketOpportunityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScanMarketOpportunityResponse() / ScanMarketOpportunityResponse.new instead')
  static ScanMarketOpportunityResponse create() =>
      ScanMarketOpportunityResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScanMarketOpportunityResponse._();
  @$core.override
  ScanMarketOpportunityResponse createEmptyInstance() =>
      ScanMarketOpportunityResponse._();
  @$core.pragma('dart2js:noInline')
  static ScanMarketOpportunityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanMarketOpportunityResponse>(
          ScanMarketOpportunityResponse.$_createMessage);
  static ScanMarketOpportunityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MarketScanState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(MarketScanState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  MarketOpportunity get opportunity => $_getN(1);
  @$pb.TagNumber(2)
  set opportunity(MarketOpportunity value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunity() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunity() => $_clearField(2);
  @$pb.TagNumber(2)
  MarketOpportunity ensureOpportunity() => $_ensure(1);
}

class MarketOpportunity extends $pb.GeneratedMessage {
  factory MarketOpportunity({
    $fixnum.Int64? id,
    $core.String? symbol,
    $fixnum.Int64? ruleVersionId,
    $core.String? ruleTitle,
    $core.String? reportId,
    $core.String? reason,
    $1.Money? referenceClose,
    $fixnum.Int64? candleClosedAtUnixMs,
    $fixnum.Int64? observedAtUnixMs,
    $fixnum.Int64? expiresAtUnixMs,
    $core.bool? current,
  }) {
    final result = MarketOpportunity._();
    if (id != null) result.id = id;
    if (symbol != null) result.symbol = symbol;
    if (ruleVersionId != null) result.ruleVersionId = ruleVersionId;
    if (ruleTitle != null) result.ruleTitle = ruleTitle;
    if (reportId != null) result.reportId = reportId;
    if (reason != null) result.reason = reason;
    if (referenceClose != null) result.referenceClose = referenceClose;
    if (candleClosedAtUnixMs != null)
      result.candleClosedAtUnixMs = candleClosedAtUnixMs;
    if (observedAtUnixMs != null) result.observedAtUnixMs = observedAtUnixMs;
    if (expiresAtUnixMs != null) result.expiresAtUnixMs = expiresAtUnixMs;
    if (current != null) result.current = current;
    return result;
  }

  MarketOpportunity._();

  factory MarketOpportunity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarketOpportunity()..mergeFromBuffer(data, registry);
  factory MarketOpportunity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarketOpportunity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarketOpportunity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: MarketOpportunity.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'symbol')
    ..aInt64(3, _omitFieldNames ? '' : 'ruleVersionId')
    ..aOS(4, _omitFieldNames ? '' : 'ruleTitle')
    ..aOS(5, _omitFieldNames ? '' : 'reportId')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'referenceClose',
        subBuilder: $1.Money.$_createMessage)
    ..aInt64(8, _omitFieldNames ? '' : 'candleClosedAtUnixMs')
    ..aInt64(9, _omitFieldNames ? '' : 'observedAtUnixMs')
    ..aInt64(10, _omitFieldNames ? '' : 'expiresAtUnixMs')
    ..aOB(11, _omitFieldNames ? '' : 'current')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketOpportunity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarketOpportunity copyWith(void Function(MarketOpportunity) updates) =>
      super.copyWith((message) => updates(message as MarketOpportunity))
          as MarketOpportunity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MarketOpportunity() / MarketOpportunity.new instead')
  static MarketOpportunity create() => MarketOpportunity._();
  static $pb.GeneratedMessage $_createMessage() => MarketOpportunity._();
  @$core.override
  MarketOpportunity createEmptyInstance() => MarketOpportunity._();
  @$core.pragma('dart2js:noInline')
  static MarketOpportunity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarketOpportunity>(
          MarketOpportunity.$_createMessage);
  static MarketOpportunity? _defaultInstance;

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
  $core.String get ruleTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set ruleTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRuleTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearRuleTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reportId => $_getSZ(4);
  @$pb.TagNumber(5)
  set reportId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReportId() => $_has(4);
  @$pb.TagNumber(5)
  void clearReportId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Money get referenceClose => $_getN(6);
  @$pb.TagNumber(7)
  set referenceClose($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReferenceClose() => $_has(6);
  @$pb.TagNumber(7)
  void clearReferenceClose() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureReferenceClose() => $_ensure(6);

  @$pb.TagNumber(8)
  $fixnum.Int64 get candleClosedAtUnixMs => $_getI64(7);
  @$pb.TagNumber(8)
  set candleClosedAtUnixMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCandleClosedAtUnixMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearCandleClosedAtUnixMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get observedAtUnixMs => $_getI64(8);
  @$pb.TagNumber(9)
  set observedAtUnixMs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasObservedAtUnixMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearObservedAtUnixMs() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get expiresAtUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set expiresAtUnixMs($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExpiresAtUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearExpiresAtUnixMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get current => $_getBF(10);
  @$pb.TagNumber(11)
  set current($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCurrent() => $_has(10);
  @$pb.TagNumber(11)
  void clearCurrent() => $_clearField(11);
}

class MarketServiceApi {
  final $pb.RpcClient _client;

  MarketServiceApi(this._client);

  /// Returns the configured spot USDT watchlist and its latest known observations.
  $async.Future<GetMarketSnapshotResponse> getMarketSnapshot(
          $pb.ClientContext? ctx, GetMarketSnapshotRequest request) =>
      _client.invoke<GetMarketSnapshotResponse>(ctx, 'MarketService',
          'GetMarketSnapshot', request, GetMarketSnapshotResponse());

  /// Observes a tested rule on the latest complete 1h candle and records a match.
  $async.Future<ScanMarketOpportunityResponse> scanMarketOpportunity(
          $pb.ClientContext? ctx, ScanMarketOpportunityRequest request) =>
      _client.invoke<ScanMarketOpportunityResponse>(ctx, 'MarketService',
          'ScanMarketOpportunity', request, ScanMarketOpportunityResponse());

  /// Enables an hourly scan for a tested version or pauses that exact subscription.
  $async.Future<SetMarketScanSubscriptionResponse> setMarketScanSubscription(
          $pb.ClientContext? ctx, SetMarketScanSubscriptionRequest request) =>
      _client.invoke<SetMarketScanSubscriptionResponse>(
          ctx,
          'MarketService',
          'SetMarketScanSubscription',
          request,
          SetMarketScanSubscriptionResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
