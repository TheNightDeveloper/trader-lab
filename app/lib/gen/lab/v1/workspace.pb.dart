// This is a generated file - do not edit.
//
// Generated from lab/v1/workspace.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;
import 'workspace.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'workspace.pbenum.dart';

/// InstrumentKey qualifies a venue symbol and pins the rules used to interpret it.
class InstrumentKey extends $pb.GeneratedMessage {
  factory InstrumentKey({
    $core.String? venue,
    MarketProduct? product,
    $core.String? symbol,
    $core.String? settlementAsset,
    $core.String? specRevision,
  }) {
    final result = InstrumentKey._();
    if (venue != null) result.venue = venue;
    if (product != null) result.product = product;
    if (symbol != null) result.symbol = symbol;
    if (settlementAsset != null) result.settlementAsset = settlementAsset;
    if (specRevision != null) result.specRevision = specRevision;
    return result;
  }

  InstrumentKey._();

  factory InstrumentKey.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InstrumentKey()..mergeFromBuffer(data, registry);
  factory InstrumentKey.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InstrumentKey()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InstrumentKey',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: InstrumentKey.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'venue')
    ..aE<MarketProduct>(2, _omitFieldNames ? '' : 'product',
        enumValues: MarketProduct.values)
    ..aOS(3, _omitFieldNames ? '' : 'symbol')
    ..aOS(4, _omitFieldNames ? '' : 'settlementAsset')
    ..aOS(5, _omitFieldNames ? '' : 'specRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstrumentKey clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstrumentKey copyWith(void Function(InstrumentKey) updates) =>
      super.copyWith((message) => updates(message as InstrumentKey))
          as InstrumentKey;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use InstrumentKey() / InstrumentKey.new instead')
  static InstrumentKey create() => InstrumentKey._();
  static $pb.GeneratedMessage $_createMessage() => InstrumentKey._();
  @$core.override
  InstrumentKey createEmptyInstance() => InstrumentKey._();
  @$core.pragma('dart2js:noInline')
  static InstrumentKey getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InstrumentKey>(
          InstrumentKey.$_createMessage);
  static InstrumentKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get venue => $_getSZ(0);
  @$pb.TagNumber(1)
  set venue($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVenue() => $_has(0);
  @$pb.TagNumber(1)
  void clearVenue() => $_clearField(1);

  @$pb.TagNumber(2)
  MarketProduct get product => $_getN(1);
  @$pb.TagNumber(2)
  set product(MarketProduct value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get symbol => $_getSZ(2);
  @$pb.TagNumber(3)
  set symbol($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSymbol() => $_has(2);
  @$pb.TagNumber(3)
  void clearSymbol() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get settlementAsset => $_getSZ(3);
  @$pb.TagNumber(4)
  set settlementAsset($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSettlementAsset() => $_has(3);
  @$pb.TagNumber(4)
  void clearSettlementAsset() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get specRevision => $_getSZ(4);
  @$pb.TagNumber(5)
  set specRevision($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpecRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpecRevision() => $_clearField(5);
}

/// AccountRef scopes account data. A reference grants no permission to act.
class AccountRef extends $pb.GeneratedMessage {
  factory AccountRef({
    Environment? environment,
    $core.String? accountId,
  }) {
    final result = AccountRef._();
    if (environment != null) result.environment = environment;
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  AccountRef._();

  factory AccountRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AccountRef()..mergeFromBuffer(data, registry);
  factory AccountRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AccountRef()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountRef',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AccountRef.$_createMessage)
    ..aE<Environment>(1, _omitFieldNames ? '' : 'environment',
        enumValues: Environment.values)
    ..aOS(2, _omitFieldNames ? '' : 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountRef copyWith(void Function(AccountRef) updates) =>
      super.copyWith((message) => updates(message as AccountRef)) as AccountRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AccountRef() / AccountRef.new instead')
  static AccountRef create() => AccountRef._();
  static $pb.GeneratedMessage $_createMessage() => AccountRef._();
  @$core.override
  AccountRef createEmptyInstance() => AccountRef._();
  @$core.pragma('dart2js:noInline')
  static AccountRef getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountRef>(AccountRef.$_createMessage);
  static AccountRef? _defaultInstance;

  @$pb.TagNumber(1)
  Environment get environment => $_getN(0);
  @$pb.TagNumber(1)
  set environment(Environment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEnvironment() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnvironment() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountId() => $_clearField(2);
}

/// Signal is a versioned strategy observation. It carries no order or account authority.
class Signal extends $pb.GeneratedMessage {
  factory Signal({
    $core.int? schemaVersion,
    $core.String? strategyVersionId,
    InstrumentKey? instrument,
    $fixnum.Int64? observedAtUnixMs,
    $fixnum.Int64? validUntilUnixMs,
    $0.Decimal? targetExposure,
    $core.String? reason,
  }) {
    final result = Signal._();
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (strategyVersionId != null) result.strategyVersionId = strategyVersionId;
    if (instrument != null) result.instrument = instrument;
    if (observedAtUnixMs != null) result.observedAtUnixMs = observedAtUnixMs;
    if (validUntilUnixMs != null) result.validUntilUnixMs = validUntilUnixMs;
    if (targetExposure != null) result.targetExposure = targetExposure;
    if (reason != null) result.reason = reason;
    return result;
  }

  Signal._();

  factory Signal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Signal()..mergeFromBuffer(data, registry);
  factory Signal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Signal()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Signal',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Signal.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'schemaVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'strategyVersionId')
    ..aOM<InstrumentKey>(3, _omitFieldNames ? '' : 'instrument',
        subBuilder: InstrumentKey.$_createMessage)
    ..aInt64(4, _omitFieldNames ? '' : 'observedAtUnixMs')
    ..aInt64(5, _omitFieldNames ? '' : 'validUntilUnixMs')
    ..aOM<$0.Decimal>(6, _omitFieldNames ? '' : 'targetExposure',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Signal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Signal copyWith(void Function(Signal) updates) =>
      super.copyWith((message) => updates(message as Signal)) as Signal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Signal() / Signal.new instead')
  static Signal create() => Signal._();
  static $pb.GeneratedMessage $_createMessage() => Signal._();
  @$core.override
  Signal createEmptyInstance() => Signal._();
  @$core.pragma('dart2js:noInline')
  static Signal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Signal>(Signal.$_createMessage);
  static Signal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schemaVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set schemaVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get strategyVersionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set strategyVersionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStrategyVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStrategyVersionId() => $_clearField(2);

  @$pb.TagNumber(3)
  InstrumentKey get instrument => $_getN(2);
  @$pb.TagNumber(3)
  set instrument(InstrumentKey value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasInstrument() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstrument() => $_clearField(3);
  @$pb.TagNumber(3)
  InstrumentKey ensureInstrument() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get observedAtUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set observedAtUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasObservedAtUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearObservedAtUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get validUntilUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set validUntilUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValidUntilUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearValidUntilUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Decimal get targetExposure => $_getN(5);
  @$pb.TagNumber(6)
  set targetExposure($0.Decimal value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetExposure() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetExposure() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Decimal ensureTargetExposure() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);
}

/// StrategyCapability describes where a strategy can be evaluated. Dataset checks still apply.
class StrategyCapability extends $pb.GeneratedMessage {
  factory StrategyCapability({
    $core.Iterable<MarketProduct>? products,
    $core.Iterable<Environment>? environments,
  }) {
    final result = StrategyCapability._();
    if (products != null) result.products.addAll(products);
    if (environments != null) result.environments.addAll(environments);
    return result;
  }

  StrategyCapability._();

  factory StrategyCapability.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StrategyCapability()..mergeFromBuffer(data, registry);
  factory StrategyCapability.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StrategyCapability()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StrategyCapability',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StrategyCapability.$_createMessage)
    ..pc<MarketProduct>(
        1, _omitFieldNames ? '' : 'products', $pb.PbFieldType.KE,
        valueOf: MarketProduct.valueOf,
        enumValues: MarketProduct.values,
        defaultEnumValue: MarketProduct.MARKET_PRODUCT_UNSPECIFIED)
    ..pc<Environment>(
        2, _omitFieldNames ? '' : 'environments', $pb.PbFieldType.KE,
        valueOf: Environment.valueOf,
        enumValues: Environment.values,
        defaultEnumValue: Environment.ENVIRONMENT_UNSPECIFIED)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StrategyCapability clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StrategyCapability copyWith(void Function(StrategyCapability) updates) =>
      super.copyWith((message) => updates(message as StrategyCapability))
          as StrategyCapability;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StrategyCapability() / StrategyCapability.new instead')
  static StrategyCapability create() => StrategyCapability._();
  static $pb.GeneratedMessage $_createMessage() => StrategyCapability._();
  @$core.override
  StrategyCapability createEmptyInstance() => StrategyCapability._();
  @$core.pragma('dart2js:noInline')
  static StrategyCapability getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StrategyCapability>(
          StrategyCapability.$_createMessage);
  static StrategyCapability? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MarketProduct> get products => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Environment> get environments => $_getList(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
