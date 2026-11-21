// This is a generated file - do not edit.
//
// Generated from lab/v1/account.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'account.pbenum.dart';
import 'common.pb.dart' as $0;
import 'workspace.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'account.pbenum.dart';

enum MoneyReading_Result { value, unavailable, notSet }

/// MoneyReading preserves an exact zero separately from an unavailable valuation.
class MoneyReading extends $pb.GeneratedMessage {
  factory MoneyReading({
    $0.Money? value,
    UnavailableMoney? unavailable,
  }) {
    final result = MoneyReading._();
    if (value != null) result.value = value;
    if (unavailable != null) result.unavailable = unavailable;
    return result;
  }

  MoneyReading._();

  factory MoneyReading.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MoneyReading()..mergeFromBuffer(data, registry);
  factory MoneyReading.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MoneyReading()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, MoneyReading_Result>
      _MoneyReading_ResultByTag = {
    1: MoneyReading_Result.value,
    2: MoneyReading_Result.unavailable,
    0: MoneyReading_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoneyReading',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: MoneyReading.$_createMessage)
    ..oo(0, [1, 2])
    ..aOM<$0.Money>(1, _omitFieldNames ? '' : 'value',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<UnavailableMoney>(2, _omitFieldNames ? '' : 'unavailable',
        subBuilder: UnavailableMoney.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoneyReading clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoneyReading copyWith(void Function(MoneyReading) updates) =>
      super.copyWith((message) => updates(message as MoneyReading))
          as MoneyReading;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MoneyReading() / MoneyReading.new instead')
  static MoneyReading create() => MoneyReading._();
  static $pb.GeneratedMessage $_createMessage() => MoneyReading._();
  @$core.override
  MoneyReading createEmptyInstance() => MoneyReading._();
  @$core.pragma('dart2js:noInline')
  static MoneyReading getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoneyReading>(
          MoneyReading.$_createMessage);
  static MoneyReading? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  MoneyReading_Result whichResult() =>
      _MoneyReading_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.Money get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($0.Money value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Money ensureValue() => $_ensure(0);

  @$pb.TagNumber(2)
  UnavailableMoney get unavailable => $_getN(1);
  @$pb.TagNumber(2)
  set unavailable(UnavailableMoney value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUnavailable() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnavailable() => $_clearField(2);
  @$pb.TagNumber(2)
  UnavailableMoney ensureUnavailable() => $_ensure(1);
}

class UnavailableMoney extends $pb.GeneratedMessage {
  factory UnavailableMoney({
    MoneyAvailability? reason,
    $core.String? detail,
  }) {
    final result = UnavailableMoney._();
    if (reason != null) result.reason = reason;
    if (detail != null) result.detail = detail;
    return result;
  }

  UnavailableMoney._();

  factory UnavailableMoney.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnavailableMoney()..mergeFromBuffer(data, registry);
  factory UnavailableMoney.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnavailableMoney()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnavailableMoney',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: UnavailableMoney.$_createMessage)
    ..aE<MoneyAvailability>(1, _omitFieldNames ? '' : 'reason',
        enumValues: MoneyAvailability.values)
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnavailableMoney clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnavailableMoney copyWith(void Function(UnavailableMoney) updates) =>
      super.copyWith((message) => updates(message as UnavailableMoney))
          as UnavailableMoney;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UnavailableMoney() / UnavailableMoney.new instead')
  static UnavailableMoney create() => UnavailableMoney._();
  static $pb.GeneratedMessage $_createMessage() => UnavailableMoney._();
  @$core.override
  UnavailableMoney createEmptyInstance() => UnavailableMoney._();
  @$core.pragma('dart2js:noInline')
  static UnavailableMoney getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnavailableMoney>(
          UnavailableMoney.$_createMessage);
  static UnavailableMoney? _defaultInstance;

  @$pb.TagNumber(1)
  MoneyAvailability get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason(MoneyAvailability value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);
}

/// RiskPolicyVersion references the effective policy used for this snapshot.
class RiskPolicyVersion extends $pb.GeneratedMessage {
  factory RiskPolicyVersion({
    $core.String? policyId,
    $fixnum.Int64? revision,
    $fixnum.Int64? effectiveFromUnixMs,
  }) {
    final result = RiskPolicyVersion._();
    if (policyId != null) result.policyId = policyId;
    if (revision != null) result.revision = revision;
    if (effectiveFromUnixMs != null)
      result.effectiveFromUnixMs = effectiveFromUnixMs;
    return result;
  }

  RiskPolicyVersion._();

  factory RiskPolicyVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RiskPolicyVersion()..mergeFromBuffer(data, registry);
  factory RiskPolicyVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RiskPolicyVersion()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RiskPolicyVersion',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RiskPolicyVersion.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'policyId')
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..aInt64(3, _omitFieldNames ? '' : 'effectiveFromUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskPolicyVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskPolicyVersion copyWith(void Function(RiskPolicyVersion) updates) =>
      super.copyWith((message) => updates(message as RiskPolicyVersion))
          as RiskPolicyVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RiskPolicyVersion() / RiskPolicyVersion.new instead')
  static RiskPolicyVersion create() => RiskPolicyVersion._();
  static $pb.GeneratedMessage $_createMessage() => RiskPolicyVersion._();
  @$core.override
  RiskPolicyVersion createEmptyInstance() => RiskPolicyVersion._();
  @$core.pragma('dart2js:noInline')
  static RiskPolicyVersion getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RiskPolicyVersion>(
          RiskPolicyVersion.$_createMessage);
  static RiskPolicyVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get policyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set policyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get effectiveFromUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set effectiveFromUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEffectiveFromUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearEffectiveFromUnixMs() => $_clearField(3);
}

/// AccountSnapshot is a server-owned view keyed by account scope and revision.
/// Amounts are denominated in the accounting asset and carry their own availability.
class AccountSnapshot extends $pb.GeneratedMessage {
  factory AccountSnapshot({
    $1.AccountRef? account,
    $fixnum.Int64? revision,
    $fixnum.Int64? asOfUnixMs,
    $core.String? accountingAsset,
    MoneyReading? equity,
    MoneyReading? availableBalance,
    RiskPolicyVersion? riskPolicy,
  }) {
    final result = AccountSnapshot._();
    if (account != null) result.account = account;
    if (revision != null) result.revision = revision;
    if (asOfUnixMs != null) result.asOfUnixMs = asOfUnixMs;
    if (accountingAsset != null) result.accountingAsset = accountingAsset;
    if (equity != null) result.equity = equity;
    if (availableBalance != null) result.availableBalance = availableBalance;
    if (riskPolicy != null) result.riskPolicy = riskPolicy;
    return result;
  }

  AccountSnapshot._();

  factory AccountSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AccountSnapshot()..mergeFromBuffer(data, registry);
  factory AccountSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AccountSnapshot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountSnapshot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AccountSnapshot.$_createMessage)
    ..aOM<$1.AccountRef>(1, _omitFieldNames ? '' : 'account',
        subBuilder: $1.AccountRef.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..aInt64(3, _omitFieldNames ? '' : 'asOfUnixMs')
    ..aOS(4, _omitFieldNames ? '' : 'accountingAsset')
    ..aOM<MoneyReading>(5, _omitFieldNames ? '' : 'equity',
        subBuilder: MoneyReading.$_createMessage)
    ..aOM<MoneyReading>(6, _omitFieldNames ? '' : 'availableBalance',
        subBuilder: MoneyReading.$_createMessage)
    ..aOM<RiskPolicyVersion>(7, _omitFieldNames ? '' : 'riskPolicy',
        subBuilder: RiskPolicyVersion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountSnapshot copyWith(void Function(AccountSnapshot) updates) =>
      super.copyWith((message) => updates(message as AccountSnapshot))
          as AccountSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AccountSnapshot() / AccountSnapshot.new instead')
  static AccountSnapshot create() => AccountSnapshot._();
  static $pb.GeneratedMessage $_createMessage() => AccountSnapshot._();
  @$core.override
  AccountSnapshot createEmptyInstance() => AccountSnapshot._();
  @$core.pragma('dart2js:noInline')
  static AccountSnapshot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountSnapshot>(
          AccountSnapshot.$_createMessage);
  static AccountSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $1.AccountRef get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($1.AccountRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.AccountRef ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get asOfUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set asOfUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAsOfUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearAsOfUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get accountingAsset => $_getSZ(3);
  @$pb.TagNumber(4)
  set accountingAsset($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccountingAsset() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccountingAsset() => $_clearField(4);

  @$pb.TagNumber(5)
  MoneyReading get equity => $_getN(4);
  @$pb.TagNumber(5)
  set equity(MoneyReading value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEquity() => $_has(4);
  @$pb.TagNumber(5)
  void clearEquity() => $_clearField(5);
  @$pb.TagNumber(5)
  MoneyReading ensureEquity() => $_ensure(4);

  @$pb.TagNumber(6)
  MoneyReading get availableBalance => $_getN(5);
  @$pb.TagNumber(6)
  set availableBalance(MoneyReading value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAvailableBalance() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvailableBalance() => $_clearField(6);
  @$pb.TagNumber(6)
  MoneyReading ensureAvailableBalance() => $_ensure(5);

  @$pb.TagNumber(7)
  RiskPolicyVersion get riskPolicy => $_getN(6);
  @$pb.TagNumber(7)
  set riskPolicy(RiskPolicyVersion value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRiskPolicy() => $_has(6);
  @$pb.TagNumber(7)
  void clearRiskPolicy() => $_clearField(7);
  @$pb.TagNumber(7)
  RiskPolicyVersion ensureRiskPolicy() => $_ensure(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
