// This is a generated file - do not edit.
//
// Generated from lab/v1/paper.proto.

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

import 'account.pb.dart' as $1;
import 'common.pb.dart' as $0;
import 'workspace.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetPaperAccountRequest extends $pb.GeneratedMessage {
  factory GetPaperAccountRequest() => GetPaperAccountRequest._();

  GetPaperAccountRequest._();

  factory GetPaperAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperAccountRequest()..mergeFromBuffer(data, registry);
  factory GetPaperAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperAccountRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaperAccountRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetPaperAccountRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperAccountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperAccountRequest copyWith(
          void Function(GetPaperAccountRequest) updates) =>
      super.copyWith((message) => updates(message as GetPaperAccountRequest))
          as GetPaperAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaperAccountRequest() / GetPaperAccountRequest.new instead')
  static GetPaperAccountRequest create() => GetPaperAccountRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPaperAccountRequest._();
  @$core.override
  GetPaperAccountRequest createEmptyInstance() => GetPaperAccountRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPaperAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaperAccountRequest>(
          GetPaperAccountRequest.$_createMessage);
  static GetPaperAccountRequest? _defaultInstance;
}

class GetPaperAccountResponse extends $pb.GeneratedMessage {
  factory GetPaperAccountResponse({
    PaperAccount? paperAccount,
  }) {
    final result = GetPaperAccountResponse._();
    if (paperAccount != null) result.paperAccount = paperAccount;
    return result;
  }

  GetPaperAccountResponse._();

  factory GetPaperAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperAccountResponse()..mergeFromBuffer(data, registry);
  factory GetPaperAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperAccountResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaperAccountResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetPaperAccountResponse.$_createMessage)
    ..aOM<PaperAccount>(1, _omitFieldNames ? '' : 'paperAccount',
        subBuilder: PaperAccount.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperAccountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperAccountResponse copyWith(
          void Function(GetPaperAccountResponse) updates) =>
      super.copyWith((message) => updates(message as GetPaperAccountResponse))
          as GetPaperAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaperAccountResponse() / GetPaperAccountResponse.new instead')
  static GetPaperAccountResponse create() => GetPaperAccountResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPaperAccountResponse._();
  @$core.override
  GetPaperAccountResponse createEmptyInstance() => GetPaperAccountResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPaperAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaperAccountResponse>(
          GetPaperAccountResponse.$_createMessage);
  static GetPaperAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperAccount get paperAccount => $_getN(0);
  @$pb.TagNumber(1)
  set paperAccount(PaperAccount value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPaperAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaperAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperAccount ensurePaperAccount() => $_ensure(0);
}

class InitializePaperAccountRequest extends $pb.GeneratedMessage {
  factory InitializePaperAccountRequest({
    $0.Money? capital,
    $0.Money? maxLossPerTrade,
    $0.Money? maxOpenLoss,
    $0.Money? maxSpotExposure,
  }) {
    final result = InitializePaperAccountRequest._();
    if (capital != null) result.capital = capital;
    if (maxLossPerTrade != null) result.maxLossPerTrade = maxLossPerTrade;
    if (maxOpenLoss != null) result.maxOpenLoss = maxOpenLoss;
    if (maxSpotExposure != null) result.maxSpotExposure = maxSpotExposure;
    return result;
  }

  InitializePaperAccountRequest._();

  factory InitializePaperAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InitializePaperAccountRequest()..mergeFromBuffer(data, registry);
  factory InitializePaperAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InitializePaperAccountRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InitializePaperAccountRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: InitializePaperAccountRequest.$_createMessage)
    ..aOM<$0.Money>(1, _omitFieldNames ? '' : 'capital',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'maxLossPerTrade',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'maxOpenLoss',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'maxSpotExposure',
        subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitializePaperAccountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitializePaperAccountRequest copyWith(
          void Function(InitializePaperAccountRequest) updates) =>
      super.copyWith(
              (message) => updates(message as InitializePaperAccountRequest))
          as InitializePaperAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InitializePaperAccountRequest() / InitializePaperAccountRequest.new instead')
  static InitializePaperAccountRequest create() =>
      InitializePaperAccountRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      InitializePaperAccountRequest._();
  @$core.override
  InitializePaperAccountRequest createEmptyInstance() =>
      InitializePaperAccountRequest._();
  @$core.pragma('dart2js:noInline')
  static InitializePaperAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InitializePaperAccountRequest>(
          InitializePaperAccountRequest.$_createMessage);
  static InitializePaperAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Money get capital => $_getN(0);
  @$pb.TagNumber(1)
  set capital($0.Money value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCapital() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapital() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Money ensureCapital() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Money get maxLossPerTrade => $_getN(1);
  @$pb.TagNumber(2)
  set maxLossPerTrade($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxLossPerTrade() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxLossPerTrade() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensureMaxLossPerTrade() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Money get maxOpenLoss => $_getN(2);
  @$pb.TagNumber(3)
  set maxOpenLoss($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxOpenLoss() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxOpenLoss() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureMaxOpenLoss() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Money get maxSpotExposure => $_getN(3);
  @$pb.TagNumber(4)
  set maxSpotExposure($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxSpotExposure() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxSpotExposure() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureMaxSpotExposure() => $_ensure(3);
}

class InitializePaperAccountResponse extends $pb.GeneratedMessage {
  factory InitializePaperAccountResponse({
    PaperAccount? paperAccount,
  }) {
    final result = InitializePaperAccountResponse._();
    if (paperAccount != null) result.paperAccount = paperAccount;
    return result;
  }

  InitializePaperAccountResponse._();

  factory InitializePaperAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InitializePaperAccountResponse()..mergeFromBuffer(data, registry);
  factory InitializePaperAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InitializePaperAccountResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InitializePaperAccountResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: InitializePaperAccountResponse.$_createMessage)
    ..aOM<PaperAccount>(1, _omitFieldNames ? '' : 'paperAccount',
        subBuilder: PaperAccount.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitializePaperAccountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InitializePaperAccountResponse copyWith(
          void Function(InitializePaperAccountResponse) updates) =>
      super.copyWith(
              (message) => updates(message as InitializePaperAccountResponse))
          as InitializePaperAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InitializePaperAccountResponse() / InitializePaperAccountResponse.new instead')
  static InitializePaperAccountResponse create() =>
      InitializePaperAccountResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      InitializePaperAccountResponse._();
  @$core.override
  InitializePaperAccountResponse createEmptyInstance() =>
      InitializePaperAccountResponse._();
  @$core.pragma('dart2js:noInline')
  static InitializePaperAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InitializePaperAccountResponse>(
          InitializePaperAccountResponse.$_createMessage);
  static InitializePaperAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperAccount get paperAccount => $_getN(0);
  @$pb.TagNumber(1)
  set paperAccount(PaperAccount value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPaperAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaperAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperAccount ensurePaperAccount() => $_ensure(0);
}

class PaperAccount extends $pb.GeneratedMessage {
  factory PaperAccount({
    $1.AccountSnapshot? snapshot,
    $0.Money? initialCapital,
    $0.Money? reservedBalance,
    $0.Money? maxLossPerTrade,
    $0.Money? maxOpenLoss,
    $0.Money? maxSpotExposure,
    $0.Decimal? feeRate,
    $0.Decimal? slippageRate,
  }) {
    final result = PaperAccount._();
    if (snapshot != null) result.snapshot = snapshot;
    if (initialCapital != null) result.initialCapital = initialCapital;
    if (reservedBalance != null) result.reservedBalance = reservedBalance;
    if (maxLossPerTrade != null) result.maxLossPerTrade = maxLossPerTrade;
    if (maxOpenLoss != null) result.maxOpenLoss = maxOpenLoss;
    if (maxSpotExposure != null) result.maxSpotExposure = maxSpotExposure;
    if (feeRate != null) result.feeRate = feeRate;
    if (slippageRate != null) result.slippageRate = slippageRate;
    return result;
  }

  PaperAccount._();

  factory PaperAccount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperAccount()..mergeFromBuffer(data, registry);
  factory PaperAccount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperAccount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperAccount',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperAccount.$_createMessage)
    ..aOM<$1.AccountSnapshot>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: $1.AccountSnapshot.$_createMessage)
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'initialCapital',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'reservedBalance',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'maxLossPerTrade',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(5, _omitFieldNames ? '' : 'maxOpenLoss',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(6, _omitFieldNames ? '' : 'maxSpotExposure',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(7, _omitFieldNames ? '' : 'feeRate',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(8, _omitFieldNames ? '' : 'slippageRate',
        subBuilder: $0.Decimal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperAccount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperAccount copyWith(void Function(PaperAccount) updates) =>
      super.copyWith((message) => updates(message as PaperAccount))
          as PaperAccount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaperAccount() / PaperAccount.new instead')
  static PaperAccount create() => PaperAccount._();
  static $pb.GeneratedMessage $_createMessage() => PaperAccount._();
  @$core.override
  PaperAccount createEmptyInstance() => PaperAccount._();
  @$core.pragma('dart2js:noInline')
  static PaperAccount getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaperAccount>(
          PaperAccount.$_createMessage);
  static PaperAccount? _defaultInstance;

  @$pb.TagNumber(1)
  $1.AccountSnapshot get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot($1.AccountSnapshot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.AccountSnapshot ensureSnapshot() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Money get initialCapital => $_getN(1);
  @$pb.TagNumber(2)
  set initialCapital($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasInitialCapital() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitialCapital() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensureInitialCapital() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Money get reservedBalance => $_getN(2);
  @$pb.TagNumber(3)
  set reservedBalance($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReservedBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearReservedBalance() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureReservedBalance() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Money get maxLossPerTrade => $_getN(3);
  @$pb.TagNumber(4)
  set maxLossPerTrade($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxLossPerTrade() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxLossPerTrade() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureMaxLossPerTrade() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Money get maxOpenLoss => $_getN(4);
  @$pb.TagNumber(5)
  set maxOpenLoss($0.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxOpenLoss() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxOpenLoss() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Money ensureMaxOpenLoss() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Money get maxSpotExposure => $_getN(5);
  @$pb.TagNumber(6)
  set maxSpotExposure($0.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxSpotExposure() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxSpotExposure() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Money ensureMaxSpotExposure() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Decimal get feeRate => $_getN(6);
  @$pb.TagNumber(7)
  set feeRate($0.Decimal value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFeeRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearFeeRate() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Decimal ensureFeeRate() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Decimal get slippageRate => $_getN(7);
  @$pb.TagNumber(8)
  set slippageRate($0.Decimal value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSlippageRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearSlippageRate() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Decimal ensureSlippageRate() => $_ensure(7);
}

class PreviewPaperPlanRequest extends $pb.GeneratedMessage {
  factory PreviewPaperPlanRequest({
    $2.AccountRef? account,
    $fixnum.Int64? opportunityId,
    $0.Money? stop,
    $0.Money? takeProfit,
  }) {
    final result = PreviewPaperPlanRequest._();
    if (account != null) result.account = account;
    if (opportunityId != null) result.opportunityId = opportunityId;
    if (stop != null) result.stop = stop;
    if (takeProfit != null) result.takeProfit = takeProfit;
    return result;
  }

  PreviewPaperPlanRequest._();

  factory PreviewPaperPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewPaperPlanRequest()..mergeFromBuffer(data, registry);
  factory PreviewPaperPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewPaperPlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreviewPaperPlanRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PreviewPaperPlanRequest.$_createMessage)
    ..aOM<$2.AccountRef>(1, _omitFieldNames ? '' : 'account',
        subBuilder: $2.AccountRef.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'opportunityId')
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'stop',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'takeProfit',
        subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewPaperPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewPaperPlanRequest copyWith(
          void Function(PreviewPaperPlanRequest) updates) =>
      super.copyWith((message) => updates(message as PreviewPaperPlanRequest))
          as PreviewPaperPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PreviewPaperPlanRequest() / PreviewPaperPlanRequest.new instead')
  static PreviewPaperPlanRequest create() => PreviewPaperPlanRequest._();
  static $pb.GeneratedMessage $_createMessage() => PreviewPaperPlanRequest._();
  @$core.override
  PreviewPaperPlanRequest createEmptyInstance() => PreviewPaperPlanRequest._();
  @$core.pragma('dart2js:noInline')
  static PreviewPaperPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewPaperPlanRequest>(
          PreviewPaperPlanRequest.$_createMessage);
  static PreviewPaperPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.AccountRef get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($2.AccountRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.AccountRef ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get opportunityId => $_getI64(1);
  @$pb.TagNumber(2)
  set opportunityId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Money get stop => $_getN(2);
  @$pb.TagNumber(3)
  set stop($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStop() => $_has(2);
  @$pb.TagNumber(3)
  void clearStop() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureStop() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Money get takeProfit => $_getN(3);
  @$pb.TagNumber(4)
  set takeProfit($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTakeProfit() => $_has(3);
  @$pb.TagNumber(4)
  void clearTakeProfit() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureTakeProfit() => $_ensure(3);
}

class PreviewPaperPlanResponse extends $pb.GeneratedMessage {
  factory PreviewPaperPlanResponse({
    PaperPlan? plan,
    PaperRestriction? restriction,
  }) {
    final result = PreviewPaperPlanResponse._();
    if (plan != null) result.plan = plan;
    if (restriction != null) result.restriction = restriction;
    return result;
  }

  PreviewPaperPlanResponse._();

  factory PreviewPaperPlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewPaperPlanResponse()..mergeFromBuffer(data, registry);
  factory PreviewPaperPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewPaperPlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreviewPaperPlanResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PreviewPaperPlanResponse.$_createMessage)
    ..aOM<PaperPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: PaperPlan.$_createMessage)
    ..aOM<PaperRestriction>(2, _omitFieldNames ? '' : 'restriction',
        subBuilder: PaperRestriction.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewPaperPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewPaperPlanResponse copyWith(
          void Function(PreviewPaperPlanResponse) updates) =>
      super.copyWith((message) => updates(message as PreviewPaperPlanResponse))
          as PreviewPaperPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PreviewPaperPlanResponse() / PreviewPaperPlanResponse.new instead')
  static PreviewPaperPlanResponse create() => PreviewPaperPlanResponse._();
  static $pb.GeneratedMessage $_createMessage() => PreviewPaperPlanResponse._();
  @$core.override
  PreviewPaperPlanResponse createEmptyInstance() =>
      PreviewPaperPlanResponse._();
  @$core.pragma('dart2js:noInline')
  static PreviewPaperPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewPaperPlanResponse>(
          PreviewPaperPlanResponse.$_createMessage);
  static PreviewPaperPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(PaperPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperPlan ensurePlan() => $_ensure(0);

  @$pb.TagNumber(2)
  PaperRestriction get restriction => $_getN(1);
  @$pb.TagNumber(2)
  set restriction(PaperRestriction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRestriction() => $_has(1);
  @$pb.TagNumber(2)
  void clearRestriction() => $_clearField(2);
  @$pb.TagNumber(2)
  PaperRestriction ensureRestriction() => $_ensure(1);
}

class GetPaperPlanRequest extends $pb.GeneratedMessage {
  factory GetPaperPlanRequest({
    $core.String? planHash,
  }) {
    final result = GetPaperPlanRequest._();
    if (planHash != null) result.planHash = planHash;
    return result;
  }

  GetPaperPlanRequest._();

  factory GetPaperPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperPlanRequest()..mergeFromBuffer(data, registry);
  factory GetPaperPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperPlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaperPlanRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetPaperPlanRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'planHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperPlanRequest copyWith(void Function(GetPaperPlanRequest) updates) =>
      super.copyWith((message) => updates(message as GetPaperPlanRequest))
          as GetPaperPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetPaperPlanRequest() / GetPaperPlanRequest.new instead')
  static GetPaperPlanRequest create() => GetPaperPlanRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPaperPlanRequest._();
  @$core.override
  GetPaperPlanRequest createEmptyInstance() => GetPaperPlanRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPaperPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaperPlanRequest>(
          GetPaperPlanRequest.$_createMessage);
  static GetPaperPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set planHash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanHash() => $_clearField(1);
}

class GetPaperPlanResponse extends $pb.GeneratedMessage {
  factory GetPaperPlanResponse({
    PaperPlan? plan,
    PaperRestriction? restriction,
  }) {
    final result = GetPaperPlanResponse._();
    if (plan != null) result.plan = plan;
    if (restriction != null) result.restriction = restriction;
    return result;
  }

  GetPaperPlanResponse._();

  factory GetPaperPlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperPlanResponse()..mergeFromBuffer(data, registry);
  factory GetPaperPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperPlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaperPlanResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetPaperPlanResponse.$_createMessage)
    ..aOM<PaperPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: PaperPlan.$_createMessage)
    ..aOM<PaperRestriction>(2, _omitFieldNames ? '' : 'restriction',
        subBuilder: PaperRestriction.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperPlanResponse copyWith(void Function(GetPaperPlanResponse) updates) =>
      super.copyWith((message) => updates(message as GetPaperPlanResponse))
          as GetPaperPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaperPlanResponse() / GetPaperPlanResponse.new instead')
  static GetPaperPlanResponse create() => GetPaperPlanResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPaperPlanResponse._();
  @$core.override
  GetPaperPlanResponse createEmptyInstance() => GetPaperPlanResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPaperPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaperPlanResponse>(
          GetPaperPlanResponse.$_createMessage);
  static GetPaperPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(PaperPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperPlan ensurePlan() => $_ensure(0);

  @$pb.TagNumber(2)
  PaperRestriction get restriction => $_getN(1);
  @$pb.TagNumber(2)
  set restriction(PaperRestriction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRestriction() => $_has(1);
  @$pb.TagNumber(2)
  void clearRestriction() => $_clearField(2);
  @$pb.TagNumber(2)
  PaperRestriction ensureRestriction() => $_ensure(1);
}

class PaperRestriction extends $pb.GeneratedMessage {
  factory PaperRestriction({
    $core.String? code,
    $core.String? detail,
  }) {
    final result = PaperRestriction._();
    if (code != null) result.code = code;
    if (detail != null) result.detail = detail;
    return result;
  }

  PaperRestriction._();

  factory PaperRestriction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperRestriction()..mergeFromBuffer(data, registry);
  factory PaperRestriction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperRestriction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperRestriction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperRestriction.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperRestriction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperRestriction copyWith(void Function(PaperRestriction) updates) =>
      super.copyWith((message) => updates(message as PaperRestriction))
          as PaperRestriction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaperRestriction() / PaperRestriction.new instead')
  static PaperRestriction create() => PaperRestriction._();
  static $pb.GeneratedMessage $_createMessage() => PaperRestriction._();
  @$core.override
  PaperRestriction createEmptyInstance() => PaperRestriction._();
  @$core.pragma('dart2js:noInline')
  static PaperRestriction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaperRestriction>(
          PaperRestriction.$_createMessage);
  static PaperRestriction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);
}

class PaperPlan extends $pb.GeneratedMessage {
  factory PaperPlan({
    $core.String? planHash,
    $2.AccountRef? account,
    $fixnum.Int64? accountRevision,
    $1.RiskPolicyVersion? riskPolicy,
    $fixnum.Int64? opportunityId,
    $2.InstrumentKey? instrument,
    $fixnum.Int64? ruleVersionId,
    $core.String? reportId,
    $core.String? snapshotSha256,
    $fixnum.Int64? quotedAtUnixMs,
    $fixnum.Int64? expiresAtUnixMs,
    $0.Money? referencePrice,
    $0.Money? estimatedEntry,
    $0.Money? maxEntryPrice,
    $0.Money? stop,
    $0.Money? takeProfit,
    $0.Money? quantity,
    $0.Money? notional,
    $0.Money? requiredCash,
    $0.Money? plannedLoss,
    $0.Money? estimatedCost,
    $0.Decimal? feeRate,
    $0.Decimal? slippageRate,
    $core.String? fillModel,
    $fixnum.Int64? referenceCandleClosedAtUnixMs,
    $core.int? referenceCandleRevision,
  }) {
    final result = PaperPlan._();
    if (planHash != null) result.planHash = planHash;
    if (account != null) result.account = account;
    if (accountRevision != null) result.accountRevision = accountRevision;
    if (riskPolicy != null) result.riskPolicy = riskPolicy;
    if (opportunityId != null) result.opportunityId = opportunityId;
    if (instrument != null) result.instrument = instrument;
    if (ruleVersionId != null) result.ruleVersionId = ruleVersionId;
    if (reportId != null) result.reportId = reportId;
    if (snapshotSha256 != null) result.snapshotSha256 = snapshotSha256;
    if (quotedAtUnixMs != null) result.quotedAtUnixMs = quotedAtUnixMs;
    if (expiresAtUnixMs != null) result.expiresAtUnixMs = expiresAtUnixMs;
    if (referencePrice != null) result.referencePrice = referencePrice;
    if (estimatedEntry != null) result.estimatedEntry = estimatedEntry;
    if (maxEntryPrice != null) result.maxEntryPrice = maxEntryPrice;
    if (stop != null) result.stop = stop;
    if (takeProfit != null) result.takeProfit = takeProfit;
    if (quantity != null) result.quantity = quantity;
    if (notional != null) result.notional = notional;
    if (requiredCash != null) result.requiredCash = requiredCash;
    if (plannedLoss != null) result.plannedLoss = plannedLoss;
    if (estimatedCost != null) result.estimatedCost = estimatedCost;
    if (feeRate != null) result.feeRate = feeRate;
    if (slippageRate != null) result.slippageRate = slippageRate;
    if (fillModel != null) result.fillModel = fillModel;
    if (referenceCandleClosedAtUnixMs != null)
      result.referenceCandleClosedAtUnixMs = referenceCandleClosedAtUnixMs;
    if (referenceCandleRevision != null)
      result.referenceCandleRevision = referenceCandleRevision;
    return result;
  }

  PaperPlan._();

  factory PaperPlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperPlan()..mergeFromBuffer(data, registry);
  factory PaperPlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperPlan()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperPlan',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperPlan.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'planHash')
    ..aOM<$2.AccountRef>(2, _omitFieldNames ? '' : 'account',
        subBuilder: $2.AccountRef.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'accountRevision')
    ..aOM<$1.RiskPolicyVersion>(4, _omitFieldNames ? '' : 'riskPolicy',
        subBuilder: $1.RiskPolicyVersion.$_createMessage)
    ..aInt64(5, _omitFieldNames ? '' : 'opportunityId')
    ..aOM<$2.InstrumentKey>(6, _omitFieldNames ? '' : 'instrument',
        subBuilder: $2.InstrumentKey.$_createMessage)
    ..aInt64(7, _omitFieldNames ? '' : 'ruleVersionId')
    ..aOS(8, _omitFieldNames ? '' : 'reportId')
    ..aOS(9, _omitFieldNames ? '' : 'snapshotSha256')
    ..aInt64(10, _omitFieldNames ? '' : 'quotedAtUnixMs')
    ..aInt64(11, _omitFieldNames ? '' : 'expiresAtUnixMs')
    ..aOM<$0.Money>(12, _omitFieldNames ? '' : 'referencePrice',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(13, _omitFieldNames ? '' : 'estimatedEntry',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(14, _omitFieldNames ? '' : 'maxEntryPrice',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(15, _omitFieldNames ? '' : 'stop',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(16, _omitFieldNames ? '' : 'takeProfit',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(17, _omitFieldNames ? '' : 'quantity',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(18, _omitFieldNames ? '' : 'notional',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(19, _omitFieldNames ? '' : 'requiredCash',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(20, _omitFieldNames ? '' : 'plannedLoss',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(21, _omitFieldNames ? '' : 'estimatedCost',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(22, _omitFieldNames ? '' : 'feeRate',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(23, _omitFieldNames ? '' : 'slippageRate',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOS(24, _omitFieldNames ? '' : 'fillModel')
    ..aInt64(25, _omitFieldNames ? '' : 'referenceCandleClosedAtUnixMs')
    ..aI(26, _omitFieldNames ? '' : 'referenceCandleRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperPlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperPlan copyWith(void Function(PaperPlan) updates) =>
      super.copyWith((message) => updates(message as PaperPlan)) as PaperPlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaperPlan() / PaperPlan.new instead')
  static PaperPlan create() => PaperPlan._();
  static $pb.GeneratedMessage $_createMessage() => PaperPlan._();
  @$core.override
  PaperPlan createEmptyInstance() => PaperPlan._();
  @$core.pragma('dart2js:noInline')
  static PaperPlan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaperPlan>(PaperPlan.$_createMessage);
  static PaperPlan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set planHash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanHash() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.AccountRef get account => $_getN(1);
  @$pb.TagNumber(2)
  set account($2.AccountRef value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccount() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.AccountRef ensureAccount() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get accountRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set accountRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccountRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.RiskPolicyVersion get riskPolicy => $_getN(3);
  @$pb.TagNumber(4)
  set riskPolicy($1.RiskPolicyVersion value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRiskPolicy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRiskPolicy() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.RiskPolicyVersion ensureRiskPolicy() => $_ensure(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get opportunityId => $_getI64(4);
  @$pb.TagNumber(5)
  set opportunityId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOpportunityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOpportunityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.InstrumentKey get instrument => $_getN(5);
  @$pb.TagNumber(6)
  set instrument($2.InstrumentKey value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasInstrument() => $_has(5);
  @$pb.TagNumber(6)
  void clearInstrument() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.InstrumentKey ensureInstrument() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get ruleVersionId => $_getI64(6);
  @$pb.TagNumber(7)
  set ruleVersionId($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRuleVersionId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRuleVersionId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get reportId => $_getSZ(7);
  @$pb.TagNumber(8)
  set reportId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReportId() => $_has(7);
  @$pb.TagNumber(8)
  void clearReportId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get snapshotSha256 => $_getSZ(8);
  @$pb.TagNumber(9)
  set snapshotSha256($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSnapshotSha256() => $_has(8);
  @$pb.TagNumber(9)
  void clearSnapshotSha256() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get quotedAtUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set quotedAtUnixMs($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasQuotedAtUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearQuotedAtUnixMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get expiresAtUnixMs => $_getI64(10);
  @$pb.TagNumber(11)
  set expiresAtUnixMs($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExpiresAtUnixMs() => $_has(10);
  @$pb.TagNumber(11)
  void clearExpiresAtUnixMs() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Money get referencePrice => $_getN(11);
  @$pb.TagNumber(12)
  set referencePrice($0.Money value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReferencePrice() => $_has(11);
  @$pb.TagNumber(12)
  void clearReferencePrice() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Money ensureReferencePrice() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Money get estimatedEntry => $_getN(12);
  @$pb.TagNumber(13)
  set estimatedEntry($0.Money value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasEstimatedEntry() => $_has(12);
  @$pb.TagNumber(13)
  void clearEstimatedEntry() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Money ensureEstimatedEntry() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Money get maxEntryPrice => $_getN(13);
  @$pb.TagNumber(14)
  set maxEntryPrice($0.Money value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasMaxEntryPrice() => $_has(13);
  @$pb.TagNumber(14)
  void clearMaxEntryPrice() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Money ensureMaxEntryPrice() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Money get stop => $_getN(14);
  @$pb.TagNumber(15)
  set stop($0.Money value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasStop() => $_has(14);
  @$pb.TagNumber(15)
  void clearStop() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Money ensureStop() => $_ensure(14);

  @$pb.TagNumber(16)
  $0.Money get takeProfit => $_getN(15);
  @$pb.TagNumber(16)
  set takeProfit($0.Money value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasTakeProfit() => $_has(15);
  @$pb.TagNumber(16)
  void clearTakeProfit() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Money ensureTakeProfit() => $_ensure(15);

  @$pb.TagNumber(17)
  $0.Money get quantity => $_getN(16);
  @$pb.TagNumber(17)
  set quantity($0.Money value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasQuantity() => $_has(16);
  @$pb.TagNumber(17)
  void clearQuantity() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Money ensureQuantity() => $_ensure(16);

  @$pb.TagNumber(18)
  $0.Money get notional => $_getN(17);
  @$pb.TagNumber(18)
  set notional($0.Money value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasNotional() => $_has(17);
  @$pb.TagNumber(18)
  void clearNotional() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Money ensureNotional() => $_ensure(17);

  @$pb.TagNumber(19)
  $0.Money get requiredCash => $_getN(18);
  @$pb.TagNumber(19)
  set requiredCash($0.Money value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasRequiredCash() => $_has(18);
  @$pb.TagNumber(19)
  void clearRequiredCash() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Money ensureRequiredCash() => $_ensure(18);

  @$pb.TagNumber(20)
  $0.Money get plannedLoss => $_getN(19);
  @$pb.TagNumber(20)
  set plannedLoss($0.Money value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasPlannedLoss() => $_has(19);
  @$pb.TagNumber(20)
  void clearPlannedLoss() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Money ensurePlannedLoss() => $_ensure(19);

  @$pb.TagNumber(21)
  $0.Money get estimatedCost => $_getN(20);
  @$pb.TagNumber(21)
  set estimatedCost($0.Money value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasEstimatedCost() => $_has(20);
  @$pb.TagNumber(21)
  void clearEstimatedCost() => $_clearField(21);
  @$pb.TagNumber(21)
  $0.Money ensureEstimatedCost() => $_ensure(20);

  @$pb.TagNumber(22)
  $0.Decimal get feeRate => $_getN(21);
  @$pb.TagNumber(22)
  set feeRate($0.Decimal value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasFeeRate() => $_has(21);
  @$pb.TagNumber(22)
  void clearFeeRate() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Decimal ensureFeeRate() => $_ensure(21);

  @$pb.TagNumber(23)
  $0.Decimal get slippageRate => $_getN(22);
  @$pb.TagNumber(23)
  set slippageRate($0.Decimal value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasSlippageRate() => $_has(22);
  @$pb.TagNumber(23)
  void clearSlippageRate() => $_clearField(23);
  @$pb.TagNumber(23)
  $0.Decimal ensureSlippageRate() => $_ensure(22);

  @$pb.TagNumber(24)
  $core.String get fillModel => $_getSZ(23);
  @$pb.TagNumber(24)
  set fillModel($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasFillModel() => $_has(23);
  @$pb.TagNumber(24)
  void clearFillModel() => $_clearField(24);

  @$pb.TagNumber(25)
  $fixnum.Int64 get referenceCandleClosedAtUnixMs => $_getI64(24);
  @$pb.TagNumber(25)
  set referenceCandleClosedAtUnixMs($fixnum.Int64 value) =>
      $_setInt64(24, value);
  @$pb.TagNumber(25)
  $core.bool hasReferenceCandleClosedAtUnixMs() => $_has(24);
  @$pb.TagNumber(25)
  void clearReferenceCandleClosedAtUnixMs() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.int get referenceCandleRevision => $_getIZ(25);
  @$pb.TagNumber(26)
  set referenceCandleRevision($core.int value) => $_setSignedInt32(25, value);
  @$pb.TagNumber(26)
  $core.bool hasReferenceCandleRevision() => $_has(25);
  @$pb.TagNumber(26)
  void clearReferenceCandleRevision() => $_clearField(26);
}

/// PaperService only operates on local, simulated spot accounts.
class PaperServiceApi {
  final $pb.RpcClient _client;

  PaperServiceApi(this._client);

  $async.Future<GetPaperAccountResponse> getPaperAccount(
          $pb.ClientContext? ctx, GetPaperAccountRequest request) =>
      _client.invoke<GetPaperAccountResponse>(ctx, 'PaperService',
          'GetPaperAccount', request, GetPaperAccountResponse());
  $async.Future<InitializePaperAccountResponse> initializePaperAccount(
          $pb.ClientContext? ctx, InitializePaperAccountRequest request) =>
      _client.invoke<InitializePaperAccountResponse>(ctx, 'PaperService',
          'InitializePaperAccount', request, InitializePaperAccountResponse());
  $async.Future<PreviewPaperPlanResponse> previewPaperPlan(
          $pb.ClientContext? ctx, PreviewPaperPlanRequest request) =>
      _client.invoke<PreviewPaperPlanResponse>(ctx, 'PaperService',
          'PreviewPaperPlan', request, PreviewPaperPlanResponse());
  $async.Future<GetPaperPlanResponse> getPaperPlan(
          $pb.ClientContext? ctx, GetPaperPlanRequest request) =>
      _client.invoke<GetPaperPlanResponse>(
          ctx, 'PaperService', 'GetPaperPlan', request, GetPaperPlanResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
