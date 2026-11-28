// This is a generated file - do not edit.
//
// Generated from lab/v1/daily_review.proto.

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

import 'common.pb.dart' as $3;
import 'market.pb.dart' as $1;
import 'paper.pb.dart' as $0;
import 'shadow.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetDailyReviewRequest extends $pb.GeneratedMessage {
  factory GetDailyReviewRequest() => GetDailyReviewRequest._();

  GetDailyReviewRequest._();

  factory GetDailyReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDailyReviewRequest()..mergeFromBuffer(data, registry);
  factory GetDailyReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDailyReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDailyReviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetDailyReviewRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReviewRequest copyWith(
          void Function(GetDailyReviewRequest) updates) =>
      super.copyWith((message) => updates(message as GetDailyReviewRequest))
          as GetDailyReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDailyReviewRequest() / GetDailyReviewRequest.new instead')
  static GetDailyReviewRequest create() => GetDailyReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetDailyReviewRequest._();
  @$core.override
  GetDailyReviewRequest createEmptyInstance() => GetDailyReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDailyReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDailyReviewRequest>(
          GetDailyReviewRequest.$_createMessage);
  static GetDailyReviewRequest? _defaultInstance;
}

class GetDailyReviewResponse extends $pb.GeneratedMessage {
  factory GetDailyReviewResponse({
    DailyReviewStatus? status,
    $fixnum.Int64? asOfUnixMs,
    $0.PaperAccount? paperAccount,
    $core.Iterable<$0.PaperPosition>? positions,
    $0.PaperReconciliation? reconciliation,
    $core.Iterable<DailyReviewExposure>? exposure,
    $core.Iterable<$1.MarketOpportunity>? openWindow,
    $core.Iterable<$1.MarketOpportunity>? expired,
    $fixnum.Int64? openWindowCount,
    $fixnum.Int64? expiredCount,
    $2.ShadowDeployment? shadow,
    $core.Iterable<DailyReviewEvent>? events,
    $core.String? shadowRuleTitle,
  }) {
    final result = GetDailyReviewResponse._();
    if (status != null) result.status = status;
    if (asOfUnixMs != null) result.asOfUnixMs = asOfUnixMs;
    if (paperAccount != null) result.paperAccount = paperAccount;
    if (positions != null) result.positions.addAll(positions);
    if (reconciliation != null) result.reconciliation = reconciliation;
    if (exposure != null) result.exposure.addAll(exposure);
    if (openWindow != null) result.openWindow.addAll(openWindow);
    if (expired != null) result.expired.addAll(expired);
    if (openWindowCount != null) result.openWindowCount = openWindowCount;
    if (expiredCount != null) result.expiredCount = expiredCount;
    if (shadow != null) result.shadow = shadow;
    if (events != null) result.events.addAll(events);
    if (shadowRuleTitle != null) result.shadowRuleTitle = shadowRuleTitle;
    return result;
  }

  GetDailyReviewResponse._();

  factory GetDailyReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDailyReviewResponse()..mergeFromBuffer(data, registry);
  factory GetDailyReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDailyReviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDailyReviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetDailyReviewResponse.$_createMessage)
    ..aOM<DailyReviewStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: DailyReviewStatus.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'asOfUnixMs')
    ..aOM<$0.PaperAccount>(3, _omitFieldNames ? '' : 'paperAccount',
        subBuilder: $0.PaperAccount.$_createMessage)
    ..pPM<$0.PaperPosition>(4, _omitFieldNames ? '' : 'positions',
        subBuilder: $0.PaperPosition.$_createMessage)
    ..aOM<$0.PaperReconciliation>(5, _omitFieldNames ? '' : 'reconciliation',
        subBuilder: $0.PaperReconciliation.$_createMessage)
    ..pPM<DailyReviewExposure>(6, _omitFieldNames ? '' : 'exposure',
        subBuilder: DailyReviewExposure.$_createMessage)
    ..pPM<$1.MarketOpportunity>(7, _omitFieldNames ? '' : 'openWindow',
        subBuilder: $1.MarketOpportunity.$_createMessage)
    ..pPM<$1.MarketOpportunity>(8, _omitFieldNames ? '' : 'expired',
        subBuilder: $1.MarketOpportunity.$_createMessage)
    ..aInt64(9, _omitFieldNames ? '' : 'openWindowCount')
    ..aInt64(10, _omitFieldNames ? '' : 'expiredCount')
    ..aOM<$2.ShadowDeployment>(11, _omitFieldNames ? '' : 'shadow',
        subBuilder: $2.ShadowDeployment.$_createMessage)
    ..pPM<DailyReviewEvent>(12, _omitFieldNames ? '' : 'events',
        subBuilder: DailyReviewEvent.$_createMessage)
    ..aOS(13, _omitFieldNames ? '' : 'shadowRuleTitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReviewResponse copyWith(
          void Function(GetDailyReviewResponse) updates) =>
      super.copyWith((message) => updates(message as GetDailyReviewResponse))
          as GetDailyReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDailyReviewResponse() / GetDailyReviewResponse.new instead')
  static GetDailyReviewResponse create() => GetDailyReviewResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetDailyReviewResponse._();
  @$core.override
  GetDailyReviewResponse createEmptyInstance() => GetDailyReviewResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDailyReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDailyReviewResponse>(
          GetDailyReviewResponse.$_createMessage);
  static GetDailyReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DailyReviewStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(DailyReviewStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  DailyReviewStatus ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get asOfUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set asOfUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAsOfUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsOfUnixMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.PaperAccount get paperAccount => $_getN(2);
  @$pb.TagNumber(3)
  set paperAccount($0.PaperAccount value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPaperAccount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaperAccount() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.PaperAccount ensurePaperAccount() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<$0.PaperPosition> get positions => $_getList(3);

  @$pb.TagNumber(5)
  $0.PaperReconciliation get reconciliation => $_getN(4);
  @$pb.TagNumber(5)
  set reconciliation($0.PaperReconciliation value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReconciliation() => $_has(4);
  @$pb.TagNumber(5)
  void clearReconciliation() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.PaperReconciliation ensureReconciliation() => $_ensure(4);

  /// Empty when an open position has no valid mark or the total mark is zero.
  @$pb.TagNumber(6)
  $pb.PbList<DailyReviewExposure> get exposure => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$1.MarketOpportunity> get openWindow => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$1.MarketOpportunity> get expired => $_getList(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get openWindowCount => $_getI64(8);
  @$pb.TagNumber(9)
  set openWindowCount($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOpenWindowCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearOpenWindowCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get expiredCount => $_getI64(9);
  @$pb.TagNumber(10)
  set expiredCount($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExpiredCount() => $_has(9);
  @$pb.TagNumber(10)
  void clearExpiredCount() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.ShadowDeployment get shadow => $_getN(10);
  @$pb.TagNumber(11)
  set shadow($2.ShadowDeployment value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasShadow() => $_has(10);
  @$pb.TagNumber(11)
  void clearShadow() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.ShadowDeployment ensureShadow() => $_ensure(10);

  @$pb.TagNumber(12)
  $pb.PbList<DailyReviewEvent> get events => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get shadowRuleTitle => $_getSZ(12);
  @$pb.TagNumber(13)
  set shadowRuleTitle($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasShadowRuleTitle() => $_has(12);
  @$pb.TagNumber(13)
  void clearShadowRuleTitle() => $_clearField(13);
}

class DailyReviewExposure extends $pb.GeneratedMessage {
  factory DailyReviewExposure({
    $core.String? symbol,
    $3.Money? marketValue,
    $3.Decimal? shareOfOpenValue,
  }) {
    final result = DailyReviewExposure._();
    if (symbol != null) result.symbol = symbol;
    if (marketValue != null) result.marketValue = marketValue;
    if (shareOfOpenValue != null) result.shareOfOpenValue = shareOfOpenValue;
    return result;
  }

  DailyReviewExposure._();

  factory DailyReviewExposure.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DailyReviewExposure()..mergeFromBuffer(data, registry);
  factory DailyReviewExposure.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DailyReviewExposure()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DailyReviewExposure',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: DailyReviewExposure.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aOM<$3.Money>(2, _omitFieldNames ? '' : 'marketValue',
        subBuilder: $3.Money.$_createMessage)
    ..aOM<$3.Decimal>(3, _omitFieldNames ? '' : 'shareOfOpenValue',
        subBuilder: $3.Decimal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReviewExposure clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReviewExposure copyWith(void Function(DailyReviewExposure) updates) =>
      super.copyWith((message) => updates(message as DailyReviewExposure))
          as DailyReviewExposure;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use DailyReviewExposure() / DailyReviewExposure.new instead')
  static DailyReviewExposure create() => DailyReviewExposure._();
  static $pb.GeneratedMessage $_createMessage() => DailyReviewExposure._();
  @$core.override
  DailyReviewExposure createEmptyInstance() => DailyReviewExposure._();
  @$core.pragma('dart2js:noInline')
  static DailyReviewExposure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DailyReviewExposure>(
          DailyReviewExposure.$_createMessage);
  static DailyReviewExposure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $3.Money get marketValue => $_getN(1);
  @$pb.TagNumber(2)
  set marketValue($3.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMarketValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearMarketValue() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.Money ensureMarketValue() => $_ensure(1);

  @$pb.TagNumber(3)
  $3.Decimal get shareOfOpenValue => $_getN(2);
  @$pb.TagNumber(3)
  set shareOfOpenValue($3.Decimal value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasShareOfOpenValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearShareOfOpenValue() => $_clearField(3);
  @$pb.TagNumber(3)
  $3.Decimal ensureShareOfOpenValue() => $_ensure(2);
}

class DailyReviewEvent extends $pb.GeneratedMessage {
  factory DailyReviewEvent({
    $core.String? symbol,
    $core.String? kind,
    $fixnum.Int64? detectedAtUnixMs,
    $core.String? detail,
  }) {
    final result = DailyReviewEvent._();
    if (symbol != null) result.symbol = symbol;
    if (kind != null) result.kind = kind;
    if (detectedAtUnixMs != null) result.detectedAtUnixMs = detectedAtUnixMs;
    if (detail != null) result.detail = detail;
    return result;
  }

  DailyReviewEvent._();

  factory DailyReviewEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DailyReviewEvent()..mergeFromBuffer(data, registry);
  factory DailyReviewEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DailyReviewEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DailyReviewEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: DailyReviewEvent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aInt64(3, _omitFieldNames ? '' : 'detectedAtUnixMs')
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReviewEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReviewEvent copyWith(void Function(DailyReviewEvent) updates) =>
      super.copyWith((message) => updates(message as DailyReviewEvent))
          as DailyReviewEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DailyReviewEvent() / DailyReviewEvent.new instead')
  static DailyReviewEvent create() => DailyReviewEvent._();
  static $pb.GeneratedMessage $_createMessage() => DailyReviewEvent._();
  @$core.override
  DailyReviewEvent createEmptyInstance() => DailyReviewEvent._();
  @$core.pragma('dart2js:noInline')
  static DailyReviewEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DailyReviewEvent>(
          DailyReviewEvent.$_createMessage);
  static DailyReviewEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get detectedAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set detectedAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDetectedAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetectedAtUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);
}

class DailyReviewStatus extends $pb.GeneratedMessage {
  factory DailyReviewStatus({
    $fixnum.Int64? dayStartUnixMs,
    $core.bool? reminderEnabled,
    $core.bool? reviewedToday,
  }) {
    final result = DailyReviewStatus._();
    if (dayStartUnixMs != null) result.dayStartUnixMs = dayStartUnixMs;
    if (reminderEnabled != null) result.reminderEnabled = reminderEnabled;
    if (reviewedToday != null) result.reviewedToday = reviewedToday;
    return result;
  }

  DailyReviewStatus._();

  factory DailyReviewStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DailyReviewStatus()..mergeFromBuffer(data, registry);
  factory DailyReviewStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DailyReviewStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DailyReviewStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: DailyReviewStatus.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'dayStartUnixMs')
    ..aOB(2, _omitFieldNames ? '' : 'reminderEnabled')
    ..aOB(3, _omitFieldNames ? '' : 'reviewedToday')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReviewStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReviewStatus copyWith(void Function(DailyReviewStatus) updates) =>
      super.copyWith((message) => updates(message as DailyReviewStatus))
          as DailyReviewStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DailyReviewStatus() / DailyReviewStatus.new instead')
  static DailyReviewStatus create() => DailyReviewStatus._();
  static $pb.GeneratedMessage $_createMessage() => DailyReviewStatus._();
  @$core.override
  DailyReviewStatus createEmptyInstance() => DailyReviewStatus._();
  @$core.pragma('dart2js:noInline')
  static DailyReviewStatus getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DailyReviewStatus>(
          DailyReviewStatus.$_createMessage);
  static DailyReviewStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get dayStartUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set dayStartUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDayStartUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearDayStartUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get reminderEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set reminderEnabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReminderEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearReminderEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get reviewedToday => $_getBF(2);
  @$pb.TagNumber(3)
  set reviewedToday($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReviewedToday() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewedToday() => $_clearField(3);
}

class GetDailyReviewStatusRequest extends $pb.GeneratedMessage {
  factory GetDailyReviewStatusRequest() => GetDailyReviewStatusRequest._();

  GetDailyReviewStatusRequest._();

  factory GetDailyReviewStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDailyReviewStatusRequest()..mergeFromBuffer(data, registry);
  factory GetDailyReviewStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDailyReviewStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDailyReviewStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetDailyReviewStatusRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReviewStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReviewStatusRequest copyWith(
          void Function(GetDailyReviewStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDailyReviewStatusRequest))
          as GetDailyReviewStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDailyReviewStatusRequest() / GetDailyReviewStatusRequest.new instead')
  static GetDailyReviewStatusRequest create() =>
      GetDailyReviewStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetDailyReviewStatusRequest._();
  @$core.override
  GetDailyReviewStatusRequest createEmptyInstance() =>
      GetDailyReviewStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDailyReviewStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDailyReviewStatusRequest>(
          GetDailyReviewStatusRequest.$_createMessage);
  static GetDailyReviewStatusRequest? _defaultInstance;
}

class GetDailyReviewStatusResponse extends $pb.GeneratedMessage {
  factory GetDailyReviewStatusResponse({
    DailyReviewStatus? status,
  }) {
    final result = GetDailyReviewStatusResponse._();
    if (status != null) result.status = status;
    return result;
  }

  GetDailyReviewStatusResponse._();

  factory GetDailyReviewStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDailyReviewStatusResponse()..mergeFromBuffer(data, registry);
  factory GetDailyReviewStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDailyReviewStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDailyReviewStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetDailyReviewStatusResponse.$_createMessage)
    ..aOM<DailyReviewStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: DailyReviewStatus.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReviewStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyReviewStatusResponse copyWith(
          void Function(GetDailyReviewStatusResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetDailyReviewStatusResponse))
          as GetDailyReviewStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDailyReviewStatusResponse() / GetDailyReviewStatusResponse.new instead')
  static GetDailyReviewStatusResponse create() =>
      GetDailyReviewStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetDailyReviewStatusResponse._();
  @$core.override
  GetDailyReviewStatusResponse createEmptyInstance() =>
      GetDailyReviewStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDailyReviewStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDailyReviewStatusResponse>(
          GetDailyReviewStatusResponse.$_createMessage);
  static GetDailyReviewStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DailyReviewStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(DailyReviewStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  DailyReviewStatus ensureStatus() => $_ensure(0);
}

class SetDailyReviewReminderRequest extends $pb.GeneratedMessage {
  factory SetDailyReviewReminderRequest({
    $core.bool? enabled,
  }) {
    final result = SetDailyReviewReminderRequest._();
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  SetDailyReviewReminderRequest._();

  factory SetDailyReviewReminderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDailyReviewReminderRequest()..mergeFromBuffer(data, registry);
  factory SetDailyReviewReminderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDailyReviewReminderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDailyReviewReminderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SetDailyReviewReminderRequest.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDailyReviewReminderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDailyReviewReminderRequest copyWith(
          void Function(SetDailyReviewReminderRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetDailyReviewReminderRequest))
          as SetDailyReviewReminderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetDailyReviewReminderRequest() / SetDailyReviewReminderRequest.new instead')
  static SetDailyReviewReminderRequest create() =>
      SetDailyReviewReminderRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetDailyReviewReminderRequest._();
  @$core.override
  SetDailyReviewReminderRequest createEmptyInstance() =>
      SetDailyReviewReminderRequest._();
  @$core.pragma('dart2js:noInline')
  static SetDailyReviewReminderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDailyReviewReminderRequest>(
          SetDailyReviewReminderRequest.$_createMessage);
  static SetDailyReviewReminderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);
}

class SetDailyReviewReminderResponse extends $pb.GeneratedMessage {
  factory SetDailyReviewReminderResponse({
    DailyReviewStatus? status,
  }) {
    final result = SetDailyReviewReminderResponse._();
    if (status != null) result.status = status;
    return result;
  }

  SetDailyReviewReminderResponse._();

  factory SetDailyReviewReminderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDailyReviewReminderResponse()..mergeFromBuffer(data, registry);
  factory SetDailyReviewReminderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDailyReviewReminderResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDailyReviewReminderResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SetDailyReviewReminderResponse.$_createMessage)
    ..aOM<DailyReviewStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: DailyReviewStatus.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDailyReviewReminderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDailyReviewReminderResponse copyWith(
          void Function(SetDailyReviewReminderResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetDailyReviewReminderResponse))
          as SetDailyReviewReminderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetDailyReviewReminderResponse() / SetDailyReviewReminderResponse.new instead')
  static SetDailyReviewReminderResponse create() =>
      SetDailyReviewReminderResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetDailyReviewReminderResponse._();
  @$core.override
  SetDailyReviewReminderResponse createEmptyInstance() =>
      SetDailyReviewReminderResponse._();
  @$core.pragma('dart2js:noInline')
  static SetDailyReviewReminderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDailyReviewReminderResponse>(
          SetDailyReviewReminderResponse.$_createMessage);
  static SetDailyReviewReminderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DailyReviewStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(DailyReviewStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  DailyReviewStatus ensureStatus() => $_ensure(0);
}

class MarkDailyReviewReadRequest extends $pb.GeneratedMessage {
  factory MarkDailyReviewReadRequest({
    $fixnum.Int64? dayStartUnixMs,
  }) {
    final result = MarkDailyReviewReadRequest._();
    if (dayStartUnixMs != null) result.dayStartUnixMs = dayStartUnixMs;
    return result;
  }

  MarkDailyReviewReadRequest._();

  factory MarkDailyReviewReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkDailyReviewReadRequest()..mergeFromBuffer(data, registry);
  factory MarkDailyReviewReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkDailyReviewReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkDailyReviewReadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: MarkDailyReviewReadRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'dayStartUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkDailyReviewReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkDailyReviewReadRequest copyWith(
          void Function(MarkDailyReviewReadRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MarkDailyReviewReadRequest))
          as MarkDailyReviewReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkDailyReviewReadRequest() / MarkDailyReviewReadRequest.new instead')
  static MarkDailyReviewReadRequest create() => MarkDailyReviewReadRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkDailyReviewReadRequest._();
  @$core.override
  MarkDailyReviewReadRequest createEmptyInstance() =>
      MarkDailyReviewReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkDailyReviewReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkDailyReviewReadRequest>(
          MarkDailyReviewReadRequest.$_createMessage);
  static MarkDailyReviewReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get dayStartUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set dayStartUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDayStartUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearDayStartUnixMs() => $_clearField(1);
}

class MarkDailyReviewReadResponse extends $pb.GeneratedMessage {
  factory MarkDailyReviewReadResponse({
    DailyReviewStatus? status,
  }) {
    final result = MarkDailyReviewReadResponse._();
    if (status != null) result.status = status;
    return result;
  }

  MarkDailyReviewReadResponse._();

  factory MarkDailyReviewReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkDailyReviewReadResponse()..mergeFromBuffer(data, registry);
  factory MarkDailyReviewReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkDailyReviewReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkDailyReviewReadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: MarkDailyReviewReadResponse.$_createMessage)
    ..aOM<DailyReviewStatus>(1, _omitFieldNames ? '' : 'status',
        subBuilder: DailyReviewStatus.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkDailyReviewReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkDailyReviewReadResponse copyWith(
          void Function(MarkDailyReviewReadResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MarkDailyReviewReadResponse))
          as MarkDailyReviewReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkDailyReviewReadResponse() / MarkDailyReviewReadResponse.new instead')
  static MarkDailyReviewReadResponse create() =>
      MarkDailyReviewReadResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkDailyReviewReadResponse._();
  @$core.override
  MarkDailyReviewReadResponse createEmptyInstance() =>
      MarkDailyReviewReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkDailyReviewReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkDailyReviewReadResponse>(
          MarkDailyReviewReadResponse.$_createMessage);
  static MarkDailyReviewReadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DailyReviewStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(DailyReviewStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  DailyReviewStatus ensureStatus() => $_ensure(0);
}

class DailyReviewServiceApi {
  final $pb.RpcClient _client;

  DailyReviewServiceApi(this._client);

  $async.Future<GetDailyReviewResponse> getDailyReview(
          $pb.ClientContext? ctx, GetDailyReviewRequest request) =>
      _client.invoke<GetDailyReviewResponse>(ctx, 'DailyReviewService',
          'GetDailyReview', request, GetDailyReviewResponse());
  $async.Future<GetDailyReviewStatusResponse> getDailyReviewStatus(
          $pb.ClientContext? ctx, GetDailyReviewStatusRequest request) =>
      _client.invoke<GetDailyReviewStatusResponse>(ctx, 'DailyReviewService',
          'GetDailyReviewStatus', request, GetDailyReviewStatusResponse());
  $async.Future<SetDailyReviewReminderResponse> setDailyReviewReminder(
          $pb.ClientContext? ctx, SetDailyReviewReminderRequest request) =>
      _client.invoke<SetDailyReviewReminderResponse>(ctx, 'DailyReviewService',
          'SetDailyReviewReminder', request, SetDailyReviewReminderResponse());
  $async.Future<MarkDailyReviewReadResponse> markDailyReviewRead(
          $pb.ClientContext? ctx, MarkDailyReviewReadRequest request) =>
      _client.invoke<MarkDailyReviewReadResponse>(ctx, 'DailyReviewService',
          'MarkDailyReviewRead', request, MarkDailyReviewReadResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
