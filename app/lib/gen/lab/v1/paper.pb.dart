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
import 'market.pb.dart' as $3;
import 'paper.pbenum.dart';
import 'workspace.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'paper.pbenum.dart';

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
    $core.Iterable<PaperReceipt>? recentReceipts,
    $core.Iterable<PaperPosition>? positions,
    PaperReconciliation? reconciliation,
  }) {
    final result = GetPaperAccountResponse._();
    if (paperAccount != null) result.paperAccount = paperAccount;
    if (recentReceipts != null) result.recentReceipts.addAll(recentReceipts);
    if (positions != null) result.positions.addAll(positions);
    if (reconciliation != null) result.reconciliation = reconciliation;
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
    ..pPM<PaperReceipt>(2, _omitFieldNames ? '' : 'recentReceipts',
        subBuilder: PaperReceipt.$_createMessage)
    ..pPM<PaperPosition>(3, _omitFieldNames ? '' : 'positions',
        subBuilder: PaperPosition.$_createMessage)
    ..aOM<PaperReconciliation>(4, _omitFieldNames ? '' : 'reconciliation',
        subBuilder: PaperReconciliation.$_createMessage)
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

  @$pb.TagNumber(2)
  $pb.PbList<PaperReceipt> get recentReceipts => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PaperPosition> get positions => $_getList(2);

  @$pb.TagNumber(4)
  PaperReconciliation get reconciliation => $_getN(3);
  @$pb.TagNumber(4)
  set reconciliation(PaperReconciliation value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReconciliation() => $_has(3);
  @$pb.TagNumber(4)
  void clearReconciliation() => $_clearField(4);
  @$pb.TagNumber(4)
  PaperReconciliation ensureReconciliation() => $_ensure(3);
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
    $core.bool? entriesPaused,
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
    if (entriesPaused != null) result.entriesPaused = entriesPaused;
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
    ..aOB(9, _omitFieldNames ? '' : 'entriesPaused')
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

  @$pb.TagNumber(9)
  $core.bool get entriesPaused => $_getBF(8);
  @$pb.TagNumber(9)
  set entriesPaused($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEntriesPaused() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntriesPaused() => $_clearField(9);
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
    PaperReceipt? receipt,
  }) {
    final result = GetPaperPlanResponse._();
    if (plan != null) result.plan = plan;
    if (restriction != null) result.restriction = restriction;
    if (receipt != null) result.receipt = receipt;
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
    ..aOM<PaperReceipt>(3, _omitFieldNames ? '' : 'receipt',
        subBuilder: PaperReceipt.$_createMessage)
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

  @$pb.TagNumber(3)
  PaperReceipt get receipt => $_getN(2);
  @$pb.TagNumber(3)
  set receipt(PaperReceipt value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReceipt() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceipt() => $_clearField(3);
  @$pb.TagNumber(3)
  PaperReceipt ensureReceipt() => $_ensure(2);
}

class ConfirmPaperPlanRequest extends $pb.GeneratedMessage {
  factory ConfirmPaperPlanRequest({
    $2.AccountRef? account,
    $core.String? planHash,
  }) {
    final result = ConfirmPaperPlanRequest._();
    if (account != null) result.account = account;
    if (planHash != null) result.planHash = planHash;
    return result;
  }

  ConfirmPaperPlanRequest._();

  factory ConfirmPaperPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmPaperPlanRequest()..mergeFromBuffer(data, registry);
  factory ConfirmPaperPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmPaperPlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmPaperPlanRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ConfirmPaperPlanRequest.$_createMessage)
    ..aOM<$2.AccountRef>(1, _omitFieldNames ? '' : 'account',
        subBuilder: $2.AccountRef.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'planHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmPaperPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmPaperPlanRequest copyWith(
          void Function(ConfirmPaperPlanRequest) updates) =>
      super.copyWith((message) => updates(message as ConfirmPaperPlanRequest))
          as ConfirmPaperPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConfirmPaperPlanRequest() / ConfirmPaperPlanRequest.new instead')
  static ConfirmPaperPlanRequest create() => ConfirmPaperPlanRequest._();
  static $pb.GeneratedMessage $_createMessage() => ConfirmPaperPlanRequest._();
  @$core.override
  ConfirmPaperPlanRequest createEmptyInstance() => ConfirmPaperPlanRequest._();
  @$core.pragma('dart2js:noInline')
  static ConfirmPaperPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmPaperPlanRequest>(
          ConfirmPaperPlanRequest.$_createMessage);
  static ConfirmPaperPlanRequest? _defaultInstance;

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
  $core.String get planHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set planHash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanHash() => $_clearField(2);
}

class ConfirmPaperPlanResponse extends $pb.GeneratedMessage {
  factory ConfirmPaperPlanResponse({
    PaperReceipt? receipt,
    PaperRestriction? restriction,
  }) {
    final result = ConfirmPaperPlanResponse._();
    if (receipt != null) result.receipt = receipt;
    if (restriction != null) result.restriction = restriction;
    return result;
  }

  ConfirmPaperPlanResponse._();

  factory ConfirmPaperPlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmPaperPlanResponse()..mergeFromBuffer(data, registry);
  factory ConfirmPaperPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmPaperPlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmPaperPlanResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ConfirmPaperPlanResponse.$_createMessage)
    ..aOM<PaperReceipt>(1, _omitFieldNames ? '' : 'receipt',
        subBuilder: PaperReceipt.$_createMessage)
    ..aOM<PaperRestriction>(2, _omitFieldNames ? '' : 'restriction',
        subBuilder: PaperRestriction.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmPaperPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmPaperPlanResponse copyWith(
          void Function(ConfirmPaperPlanResponse) updates) =>
      super.copyWith((message) => updates(message as ConfirmPaperPlanResponse))
          as ConfirmPaperPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConfirmPaperPlanResponse() / ConfirmPaperPlanResponse.new instead')
  static ConfirmPaperPlanResponse create() => ConfirmPaperPlanResponse._();
  static $pb.GeneratedMessage $_createMessage() => ConfirmPaperPlanResponse._();
  @$core.override
  ConfirmPaperPlanResponse createEmptyInstance() =>
      ConfirmPaperPlanResponse._();
  @$core.pragma('dart2js:noInline')
  static ConfirmPaperPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmPaperPlanResponse>(
          ConfirmPaperPlanResponse.$_createMessage);
  static ConfirmPaperPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperReceipt get receipt => $_getN(0);
  @$pb.TagNumber(1)
  set receipt(PaperReceipt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReceipt() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceipt() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperReceipt ensureReceipt() => $_ensure(0);

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

class GetPaperReceiptRequest extends $pb.GeneratedMessage {
  factory GetPaperReceiptRequest({
    $fixnum.Int64? receiptId,
  }) {
    final result = GetPaperReceiptRequest._();
    if (receiptId != null) result.receiptId = receiptId;
    return result;
  }

  GetPaperReceiptRequest._();

  factory GetPaperReceiptRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperReceiptRequest()..mergeFromBuffer(data, registry);
  factory GetPaperReceiptRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperReceiptRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaperReceiptRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetPaperReceiptRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'receiptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperReceiptRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperReceiptRequest copyWith(
          void Function(GetPaperReceiptRequest) updates) =>
      super.copyWith((message) => updates(message as GetPaperReceiptRequest))
          as GetPaperReceiptRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaperReceiptRequest() / GetPaperReceiptRequest.new instead')
  static GetPaperReceiptRequest create() => GetPaperReceiptRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPaperReceiptRequest._();
  @$core.override
  GetPaperReceiptRequest createEmptyInstance() => GetPaperReceiptRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPaperReceiptRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaperReceiptRequest>(
          GetPaperReceiptRequest.$_createMessage);
  static GetPaperReceiptRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get receiptId => $_getI64(0);
  @$pb.TagNumber(1)
  set receiptId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceiptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceiptId() => $_clearField(1);
}

class GetPaperReceiptResponse extends $pb.GeneratedMessage {
  factory GetPaperReceiptResponse({
    PaperReceipt? receipt,
    $core.Iterable<PaperExecutionEvent>? events,
    PaperReduction? reduction,
    PaperJournalNote? note,
  }) {
    final result = GetPaperReceiptResponse._();
    if (receipt != null) result.receipt = receipt;
    if (events != null) result.events.addAll(events);
    if (reduction != null) result.reduction = reduction;
    if (note != null) result.note = note;
    return result;
  }

  GetPaperReceiptResponse._();

  factory GetPaperReceiptResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperReceiptResponse()..mergeFromBuffer(data, registry);
  factory GetPaperReceiptResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperReceiptResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaperReceiptResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetPaperReceiptResponse.$_createMessage)
    ..aOM<PaperReceipt>(1, _omitFieldNames ? '' : 'receipt',
        subBuilder: PaperReceipt.$_createMessage)
    ..pPM<PaperExecutionEvent>(2, _omitFieldNames ? '' : 'events',
        subBuilder: PaperExecutionEvent.$_createMessage)
    ..aOM<PaperReduction>(3, _omitFieldNames ? '' : 'reduction',
        subBuilder: PaperReduction.$_createMessage)
    ..aOM<PaperJournalNote>(4, _omitFieldNames ? '' : 'note',
        subBuilder: PaperJournalNote.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperReceiptResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperReceiptResponse copyWith(
          void Function(GetPaperReceiptResponse) updates) =>
      super.copyWith((message) => updates(message as GetPaperReceiptResponse))
          as GetPaperReceiptResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaperReceiptResponse() / GetPaperReceiptResponse.new instead')
  static GetPaperReceiptResponse create() => GetPaperReceiptResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPaperReceiptResponse._();
  @$core.override
  GetPaperReceiptResponse createEmptyInstance() => GetPaperReceiptResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPaperReceiptResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaperReceiptResponse>(
          GetPaperReceiptResponse.$_createMessage);
  static GetPaperReceiptResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperReceipt get receipt => $_getN(0);
  @$pb.TagNumber(1)
  set receipt(PaperReceipt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReceipt() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceipt() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperReceipt ensureReceipt() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PaperExecutionEvent> get events => $_getList(1);

  @$pb.TagNumber(3)
  PaperReduction get reduction => $_getN(2);
  @$pb.TagNumber(3)
  set reduction(PaperReduction value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReduction() => $_has(2);
  @$pb.TagNumber(3)
  void clearReduction() => $_clearField(3);
  @$pb.TagNumber(3)
  PaperReduction ensureReduction() => $_ensure(2);

  @$pb.TagNumber(4)
  PaperJournalNote get note => $_getN(3);
  @$pb.TagNumber(4)
  set note(PaperJournalNote value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
  @$pb.TagNumber(4)
  PaperJournalNote ensureNote() => $_ensure(3);
}

class PaperJournalNote extends $pb.GeneratedMessage {
  factory PaperJournalNote({
    $core.String? text,
    $fixnum.Int64? revision,
    $fixnum.Int64? recordedAtUnixMs,
  }) {
    final result = PaperJournalNote._();
    if (text != null) result.text = text;
    if (revision != null) result.revision = revision;
    if (recordedAtUnixMs != null) result.recordedAtUnixMs = recordedAtUnixMs;
    return result;
  }

  PaperJournalNote._();

  factory PaperJournalNote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperJournalNote()..mergeFromBuffer(data, registry);
  factory PaperJournalNote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperJournalNote()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperJournalNote',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperJournalNote.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..aInt64(3, _omitFieldNames ? '' : 'recordedAtUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperJournalNote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperJournalNote copyWith(void Function(PaperJournalNote) updates) =>
      super.copyWith((message) => updates(message as PaperJournalNote))
          as PaperJournalNote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaperJournalNote() / PaperJournalNote.new instead')
  static PaperJournalNote create() => PaperJournalNote._();
  static $pb.GeneratedMessage $_createMessage() => PaperJournalNote._();
  @$core.override
  PaperJournalNote createEmptyInstance() => PaperJournalNote._();
  @$core.pragma('dart2js:noInline')
  static PaperJournalNote getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaperJournalNote>(
          PaperJournalNote.$_createMessage);
  static PaperJournalNote? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get recordedAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set recordedAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordedAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordedAtUnixMs() => $_clearField(3);
}

class SavePaperJournalNoteRequest extends $pb.GeneratedMessage {
  factory SavePaperJournalNoteRequest({
    $fixnum.Int64? receiptId,
    $core.String? text,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = SavePaperJournalNoteRequest._();
    if (receiptId != null) result.receiptId = receiptId;
    if (text != null) result.text = text;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  SavePaperJournalNoteRequest._();

  factory SavePaperJournalNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SavePaperJournalNoteRequest()..mergeFromBuffer(data, registry);
  factory SavePaperJournalNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SavePaperJournalNoteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SavePaperJournalNoteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SavePaperJournalNoteRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'receiptId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavePaperJournalNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavePaperJournalNoteRequest copyWith(
          void Function(SavePaperJournalNoteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SavePaperJournalNoteRequest))
          as SavePaperJournalNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SavePaperJournalNoteRequest() / SavePaperJournalNoteRequest.new instead')
  static SavePaperJournalNoteRequest create() =>
      SavePaperJournalNoteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SavePaperJournalNoteRequest._();
  @$core.override
  SavePaperJournalNoteRequest createEmptyInstance() =>
      SavePaperJournalNoteRequest._();
  @$core.pragma('dart2js:noInline')
  static SavePaperJournalNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SavePaperJournalNoteRequest>(
          SavePaperJournalNoteRequest.$_createMessage);
  static SavePaperJournalNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get receiptId => $_getI64(0);
  @$pb.TagNumber(1)
  set receiptId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceiptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceiptId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedRevision() => $_clearField(3);
}

class SavePaperJournalNoteResponse extends $pb.GeneratedMessage {
  factory SavePaperJournalNoteResponse({
    PaperJournalNote? note,
  }) {
    final result = SavePaperJournalNoteResponse._();
    if (note != null) result.note = note;
    return result;
  }

  SavePaperJournalNoteResponse._();

  factory SavePaperJournalNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SavePaperJournalNoteResponse()..mergeFromBuffer(data, registry);
  factory SavePaperJournalNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SavePaperJournalNoteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SavePaperJournalNoteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SavePaperJournalNoteResponse.$_createMessage)
    ..aOM<PaperJournalNote>(1, _omitFieldNames ? '' : 'note',
        subBuilder: PaperJournalNote.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavePaperJournalNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavePaperJournalNoteResponse copyWith(
          void Function(SavePaperJournalNoteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SavePaperJournalNoteResponse))
          as SavePaperJournalNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SavePaperJournalNoteResponse() / SavePaperJournalNoteResponse.new instead')
  static SavePaperJournalNoteResponse create() =>
      SavePaperJournalNoteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SavePaperJournalNoteResponse._();
  @$core.override
  SavePaperJournalNoteResponse createEmptyInstance() =>
      SavePaperJournalNoteResponse._();
  @$core.pragma('dart2js:noInline')
  static SavePaperJournalNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SavePaperJournalNoteResponse>(
          SavePaperJournalNoteResponse.$_createMessage);
  static SavePaperJournalNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperJournalNote get note => $_getN(0);
  @$pb.TagNumber(1)
  set note(PaperJournalNote value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNote() => $_has(0);
  @$pb.TagNumber(1)
  void clearNote() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperJournalNote ensureNote() => $_ensure(0);
}

class ListPaperJournalRequest extends $pb.GeneratedMessage {
  factory ListPaperJournalRequest({
    $fixnum.Int64? beforeReceiptId,
  }) {
    final result = ListPaperJournalRequest._();
    if (beforeReceiptId != null) result.beforeReceiptId = beforeReceiptId;
    return result;
  }

  ListPaperJournalRequest._();

  factory ListPaperJournalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPaperJournalRequest()..mergeFromBuffer(data, registry);
  factory ListPaperJournalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPaperJournalRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPaperJournalRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListPaperJournalRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'beforeReceiptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPaperJournalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPaperJournalRequest copyWith(
          void Function(ListPaperJournalRequest) updates) =>
      super.copyWith((message) => updates(message as ListPaperJournalRequest))
          as ListPaperJournalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPaperJournalRequest() / ListPaperJournalRequest.new instead')
  static ListPaperJournalRequest create() => ListPaperJournalRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPaperJournalRequest._();
  @$core.override
  ListPaperJournalRequest createEmptyInstance() => ListPaperJournalRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPaperJournalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPaperJournalRequest>(
          ListPaperJournalRequest.$_createMessage);
  static ListPaperJournalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get beforeReceiptId => $_getI64(0);
  @$pb.TagNumber(1)
  set beforeReceiptId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBeforeReceiptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBeforeReceiptId() => $_clearField(1);
}

class ListPaperJournalResponse extends $pb.GeneratedMessage {
  factory ListPaperJournalResponse({
    $core.Iterable<PaperJournalTrade>? trades,
    $fixnum.Int64? nextBeforeReceiptId,
  }) {
    final result = ListPaperJournalResponse._();
    if (trades != null) result.trades.addAll(trades);
    if (nextBeforeReceiptId != null)
      result.nextBeforeReceiptId = nextBeforeReceiptId;
    return result;
  }

  ListPaperJournalResponse._();

  factory ListPaperJournalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPaperJournalResponse()..mergeFromBuffer(data, registry);
  factory ListPaperJournalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPaperJournalResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPaperJournalResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListPaperJournalResponse.$_createMessage)
    ..pPM<PaperJournalTrade>(1, _omitFieldNames ? '' : 'trades',
        subBuilder: PaperJournalTrade.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextBeforeReceiptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPaperJournalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPaperJournalResponse copyWith(
          void Function(ListPaperJournalResponse) updates) =>
      super.copyWith((message) => updates(message as ListPaperJournalResponse))
          as ListPaperJournalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPaperJournalResponse() / ListPaperJournalResponse.new instead')
  static ListPaperJournalResponse create() => ListPaperJournalResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPaperJournalResponse._();
  @$core.override
  ListPaperJournalResponse createEmptyInstance() =>
      ListPaperJournalResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPaperJournalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPaperJournalResponse>(
          ListPaperJournalResponse.$_createMessage);
  static ListPaperJournalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PaperJournalTrade> get trades => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextBeforeReceiptId => $_getI64(1);
  @$pb.TagNumber(2)
  set nextBeforeReceiptId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextBeforeReceiptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextBeforeReceiptId() => $_clearField(2);
}

class PaperJournalTrade extends $pb.GeneratedMessage {
  factory PaperJournalTrade({
    PaperReceipt? receipt,
    $0.Money? openQuantity,
    $0.Money? feesPaid,
    $0.Money? realizedPnl,
  }) {
    final result = PaperJournalTrade._();
    if (receipt != null) result.receipt = receipt;
    if (openQuantity != null) result.openQuantity = openQuantity;
    if (feesPaid != null) result.feesPaid = feesPaid;
    if (realizedPnl != null) result.realizedPnl = realizedPnl;
    return result;
  }

  PaperJournalTrade._();

  factory PaperJournalTrade.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperJournalTrade()..mergeFromBuffer(data, registry);
  factory PaperJournalTrade.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperJournalTrade()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperJournalTrade',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperJournalTrade.$_createMessage)
    ..aOM<PaperReceipt>(1, _omitFieldNames ? '' : 'receipt',
        subBuilder: PaperReceipt.$_createMessage)
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'openQuantity',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'feesPaid',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'realizedPnl',
        subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperJournalTrade clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperJournalTrade copyWith(void Function(PaperJournalTrade) updates) =>
      super.copyWith((message) => updates(message as PaperJournalTrade))
          as PaperJournalTrade;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaperJournalTrade() / PaperJournalTrade.new instead')
  static PaperJournalTrade create() => PaperJournalTrade._();
  static $pb.GeneratedMessage $_createMessage() => PaperJournalTrade._();
  @$core.override
  PaperJournalTrade createEmptyInstance() => PaperJournalTrade._();
  @$core.pragma('dart2js:noInline')
  static PaperJournalTrade getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaperJournalTrade>(
          PaperJournalTrade.$_createMessage);
  static PaperJournalTrade? _defaultInstance;

  @$pb.TagNumber(1)
  PaperReceipt get receipt => $_getN(0);
  @$pb.TagNumber(1)
  set receipt(PaperReceipt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReceipt() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceipt() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperReceipt ensureReceipt() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Money get openQuantity => $_getN(1);
  @$pb.TagNumber(2)
  set openQuantity($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenQuantity() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensureOpenQuantity() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Money get feesPaid => $_getN(2);
  @$pb.TagNumber(3)
  set feesPaid($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFeesPaid() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeesPaid() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureFeesPaid() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Money get realizedPnl => $_getN(3);
  @$pb.TagNumber(4)
  set realizedPnl($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRealizedPnl() => $_has(3);
  @$pb.TagNumber(4)
  void clearRealizedPnl() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureRealizedPnl() => $_ensure(3);
}

class GetPaperReplayRequest extends $pb.GeneratedMessage {
  factory GetPaperReplayRequest({
    $fixnum.Int64? receiptId,
    $fixnum.Int64? cursor,
  }) {
    final result = GetPaperReplayRequest._();
    if (receiptId != null) result.receiptId = receiptId;
    if (cursor != null) result.cursor = cursor;
    return result;
  }

  GetPaperReplayRequest._();

  factory GetPaperReplayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperReplayRequest()..mergeFromBuffer(data, registry);
  factory GetPaperReplayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperReplayRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaperReplayRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetPaperReplayRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'receiptId')
    ..aInt64(2, _omitFieldNames ? '' : 'cursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperReplayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperReplayRequest copyWith(
          void Function(GetPaperReplayRequest) updates) =>
      super.copyWith((message) => updates(message as GetPaperReplayRequest))
          as GetPaperReplayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaperReplayRequest() / GetPaperReplayRequest.new instead')
  static GetPaperReplayRequest create() => GetPaperReplayRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPaperReplayRequest._();
  @$core.override
  GetPaperReplayRequest createEmptyInstance() => GetPaperReplayRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPaperReplayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaperReplayRequest>(
          GetPaperReplayRequest.$_createMessage);
  static GetPaperReplayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get receiptId => $_getI64(0);
  @$pb.TagNumber(1)
  set receiptId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceiptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceiptId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cursor => $_getI64(1);
  @$pb.TagNumber(2)
  set cursor($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);
}

enum GetPaperReplayResponse_Step { observation, plan, execution, notSet }

class GetPaperReplayResponse extends $pb.GeneratedMessage {
  factory GetPaperReplayResponse({
    $core.String? symbol,
    $fixnum.Int64? previousCursor,
    $fixnum.Int64? nextCursor,
    PaperReplayObservation? observation,
    PaperPlan? plan,
    PaperReplayExecution? execution,
  }) {
    final result = GetPaperReplayResponse._();
    if (symbol != null) result.symbol = symbol;
    if (previousCursor != null) result.previousCursor = previousCursor;
    if (nextCursor != null) result.nextCursor = nextCursor;
    if (observation != null) result.observation = observation;
    if (plan != null) result.plan = plan;
    if (execution != null) result.execution = execution;
    return result;
  }

  GetPaperReplayResponse._();

  factory GetPaperReplayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperReplayResponse()..mergeFromBuffer(data, registry);
  factory GetPaperReplayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaperReplayResponse()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, GetPaperReplayResponse_Step>
      _GetPaperReplayResponse_StepByTag = {
    4: GetPaperReplayResponse_Step.observation,
    5: GetPaperReplayResponse_Step.plan,
    6: GetPaperReplayResponse_Step.execution,
    0: GetPaperReplayResponse_Step.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaperReplayResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetPaperReplayResponse.$_createMessage)
    ..oo(0, [4, 5, 6])
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aInt64(2, _omitFieldNames ? '' : 'previousCursor')
    ..aInt64(3, _omitFieldNames ? '' : 'nextCursor')
    ..aOM<PaperReplayObservation>(4, _omitFieldNames ? '' : 'observation',
        subBuilder: PaperReplayObservation.$_createMessage)
    ..aOM<PaperPlan>(5, _omitFieldNames ? '' : 'plan',
        subBuilder: PaperPlan.$_createMessage)
    ..aOM<PaperReplayExecution>(6, _omitFieldNames ? '' : 'execution',
        subBuilder: PaperReplayExecution.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperReplayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaperReplayResponse copyWith(
          void Function(GetPaperReplayResponse) updates) =>
      super.copyWith((message) => updates(message as GetPaperReplayResponse))
          as GetPaperReplayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaperReplayResponse() / GetPaperReplayResponse.new instead')
  static GetPaperReplayResponse create() => GetPaperReplayResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPaperReplayResponse._();
  @$core.override
  GetPaperReplayResponse createEmptyInstance() => GetPaperReplayResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPaperReplayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaperReplayResponse>(
          GetPaperReplayResponse.$_createMessage);
  static GetPaperReplayResponse? _defaultInstance;

  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  GetPaperReplayResponse_Step whichStep() =>
      _GetPaperReplayResponse_StepByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  void clearStep() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get previousCursor => $_getI64(1);
  @$pb.TagNumber(2)
  set previousCursor($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPreviousCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreviousCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nextCursor => $_getI64(2);
  @$pb.TagNumber(3)
  set nextCursor($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextCursor() => $_clearField(3);

  @$pb.TagNumber(4)
  PaperReplayObservation get observation => $_getN(3);
  @$pb.TagNumber(4)
  set observation(PaperReplayObservation value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasObservation() => $_has(3);
  @$pb.TagNumber(4)
  void clearObservation() => $_clearField(4);
  @$pb.TagNumber(4)
  PaperReplayObservation ensureObservation() => $_ensure(3);

  @$pb.TagNumber(5)
  PaperPlan get plan => $_getN(4);
  @$pb.TagNumber(5)
  set plan(PaperPlan value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlan() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlan() => $_clearField(5);
  @$pb.TagNumber(5)
  PaperPlan ensurePlan() => $_ensure(4);

  @$pb.TagNumber(6)
  PaperReplayExecution get execution => $_getN(5);
  @$pb.TagNumber(6)
  set execution(PaperReplayExecution value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasExecution() => $_has(5);
  @$pb.TagNumber(6)
  void clearExecution() => $_clearField(6);
  @$pb.TagNumber(6)
  PaperReplayExecution ensureExecution() => $_ensure(5);
}

class PaperReplayObservation extends $pb.GeneratedMessage {
  factory PaperReplayObservation({
    $3.MarketOpportunity? opportunity,
    $core.String? snapshotSha256,
    $core.int? inputCandleCount,
    $fixnum.Int64? lastInputAvailableAtUnixMs,
    $0.Money? lastInputOpen,
    $0.Money? lastInputHigh,
    $0.Money? lastInputLow,
    $core.String? ruleSha256,
    $core.String? entryRuleJson,
  }) {
    final result = PaperReplayObservation._();
    if (opportunity != null) result.opportunity = opportunity;
    if (snapshotSha256 != null) result.snapshotSha256 = snapshotSha256;
    if (inputCandleCount != null) result.inputCandleCount = inputCandleCount;
    if (lastInputAvailableAtUnixMs != null)
      result.lastInputAvailableAtUnixMs = lastInputAvailableAtUnixMs;
    if (lastInputOpen != null) result.lastInputOpen = lastInputOpen;
    if (lastInputHigh != null) result.lastInputHigh = lastInputHigh;
    if (lastInputLow != null) result.lastInputLow = lastInputLow;
    if (ruleSha256 != null) result.ruleSha256 = ruleSha256;
    if (entryRuleJson != null) result.entryRuleJson = entryRuleJson;
    return result;
  }

  PaperReplayObservation._();

  factory PaperReplayObservation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReplayObservation()..mergeFromBuffer(data, registry);
  factory PaperReplayObservation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReplayObservation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperReplayObservation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperReplayObservation.$_createMessage)
    ..aOM<$3.MarketOpportunity>(1, _omitFieldNames ? '' : 'opportunity',
        subBuilder: $3.MarketOpportunity.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'snapshotSha256')
    ..aI(3, _omitFieldNames ? '' : 'inputCandleCount')
    ..aInt64(4, _omitFieldNames ? '' : 'lastInputAvailableAtUnixMs')
    ..aOM<$0.Money>(5, _omitFieldNames ? '' : 'lastInputOpen',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(6, _omitFieldNames ? '' : 'lastInputHigh',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(7, _omitFieldNames ? '' : 'lastInputLow',
        subBuilder: $0.Money.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'ruleSha256')
    ..aOS(9, _omitFieldNames ? '' : 'entryRuleJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReplayObservation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReplayObservation copyWith(
          void Function(PaperReplayObservation) updates) =>
      super.copyWith((message) => updates(message as PaperReplayObservation))
          as PaperReplayObservation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PaperReplayObservation() / PaperReplayObservation.new instead')
  static PaperReplayObservation create() => PaperReplayObservation._();
  static $pb.GeneratedMessage $_createMessage() => PaperReplayObservation._();
  @$core.override
  PaperReplayObservation createEmptyInstance() => PaperReplayObservation._();
  @$core.pragma('dart2js:noInline')
  static PaperReplayObservation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaperReplayObservation>(
          PaperReplayObservation.$_createMessage);
  static PaperReplayObservation? _defaultInstance;

  @$pb.TagNumber(1)
  $3.MarketOpportunity get opportunity => $_getN(0);
  @$pb.TagNumber(1)
  set opportunity($3.MarketOpportunity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunity() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.MarketOpportunity ensureOpportunity() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get snapshotSha256 => $_getSZ(1);
  @$pb.TagNumber(2)
  set snapshotSha256($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSnapshotSha256() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapshotSha256() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get inputCandleCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set inputCandleCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInputCandleCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearInputCandleCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get lastInputAvailableAtUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set lastInputAvailableAtUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLastInputAvailableAtUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastInputAvailableAtUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Money get lastInputOpen => $_getN(4);
  @$pb.TagNumber(5)
  set lastInputOpen($0.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastInputOpen() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastInputOpen() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Money ensureLastInputOpen() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Money get lastInputHigh => $_getN(5);
  @$pb.TagNumber(6)
  set lastInputHigh($0.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLastInputHigh() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastInputHigh() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Money ensureLastInputHigh() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Money get lastInputLow => $_getN(6);
  @$pb.TagNumber(7)
  set lastInputLow($0.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLastInputLow() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastInputLow() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Money ensureLastInputLow() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get ruleSha256 => $_getSZ(7);
  @$pb.TagNumber(8)
  set ruleSha256($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRuleSha256() => $_has(7);
  @$pb.TagNumber(8)
  void clearRuleSha256() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get entryRuleJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set entryRuleJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEntryRuleJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntryRuleJson() => $_clearField(9);
}

class PaperReplayExecution extends $pb.GeneratedMessage {
  factory PaperReplayExecution({
    PaperExecutionEvent? event,
    $3.MarketCandle? confirmationCandle,
  }) {
    final result = PaperReplayExecution._();
    if (event != null) result.event = event;
    if (confirmationCandle != null)
      result.confirmationCandle = confirmationCandle;
    return result;
  }

  PaperReplayExecution._();

  factory PaperReplayExecution.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReplayExecution()..mergeFromBuffer(data, registry);
  factory PaperReplayExecution.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReplayExecution()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperReplayExecution',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperReplayExecution.$_createMessage)
    ..aOM<PaperExecutionEvent>(1, _omitFieldNames ? '' : 'event',
        subBuilder: PaperExecutionEvent.$_createMessage)
    ..aOM<$3.MarketCandle>(2, _omitFieldNames ? '' : 'confirmationCandle',
        subBuilder: $3.MarketCandle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReplayExecution clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReplayExecution copyWith(void Function(PaperReplayExecution) updates) =>
      super.copyWith((message) => updates(message as PaperReplayExecution))
          as PaperReplayExecution;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PaperReplayExecution() / PaperReplayExecution.new instead')
  static PaperReplayExecution create() => PaperReplayExecution._();
  static $pb.GeneratedMessage $_createMessage() => PaperReplayExecution._();
  @$core.override
  PaperReplayExecution createEmptyInstance() => PaperReplayExecution._();
  @$core.pragma('dart2js:noInline')
  static PaperReplayExecution getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaperReplayExecution>(
          PaperReplayExecution.$_createMessage);
  static PaperReplayExecution? _defaultInstance;

  @$pb.TagNumber(1)
  PaperExecutionEvent get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(PaperExecutionEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperExecutionEvent ensureEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.MarketCandle get confirmationCandle => $_getN(1);
  @$pb.TagNumber(2)
  set confirmationCandle($3.MarketCandle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConfirmationCandle() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfirmationCandle() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.MarketCandle ensureConfirmationCandle() => $_ensure(1);
}

class CancelPaperEntryRequest extends $pb.GeneratedMessage {
  factory CancelPaperEntryRequest({
    $2.AccountRef? account,
    $fixnum.Int64? receiptId,
  }) {
    final result = CancelPaperEntryRequest._();
    if (account != null) result.account = account;
    if (receiptId != null) result.receiptId = receiptId;
    return result;
  }

  CancelPaperEntryRequest._();

  factory CancelPaperEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPaperEntryRequest()..mergeFromBuffer(data, registry);
  factory CancelPaperEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPaperEntryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelPaperEntryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CancelPaperEntryRequest.$_createMessage)
    ..aOM<$2.AccountRef>(1, _omitFieldNames ? '' : 'account',
        subBuilder: $2.AccountRef.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'receiptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPaperEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPaperEntryRequest copyWith(
          void Function(CancelPaperEntryRequest) updates) =>
      super.copyWith((message) => updates(message as CancelPaperEntryRequest))
          as CancelPaperEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelPaperEntryRequest() / CancelPaperEntryRequest.new instead')
  static CancelPaperEntryRequest create() => CancelPaperEntryRequest._();
  static $pb.GeneratedMessage $_createMessage() => CancelPaperEntryRequest._();
  @$core.override
  CancelPaperEntryRequest createEmptyInstance() => CancelPaperEntryRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelPaperEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelPaperEntryRequest>(
          CancelPaperEntryRequest.$_createMessage);
  static CancelPaperEntryRequest? _defaultInstance;

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
  $fixnum.Int64 get receiptId => $_getI64(1);
  @$pb.TagNumber(2)
  set receiptId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceiptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiptId() => $_clearField(2);
}

class CancelPaperEntryResponse extends $pb.GeneratedMessage {
  factory CancelPaperEntryResponse({
    PaperReceipt? receipt,
  }) {
    final result = CancelPaperEntryResponse._();
    if (receipt != null) result.receipt = receipt;
    return result;
  }

  CancelPaperEntryResponse._();

  factory CancelPaperEntryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPaperEntryResponse()..mergeFromBuffer(data, registry);
  factory CancelPaperEntryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPaperEntryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelPaperEntryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CancelPaperEntryResponse.$_createMessage)
    ..aOM<PaperReceipt>(1, _omitFieldNames ? '' : 'receipt',
        subBuilder: PaperReceipt.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPaperEntryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPaperEntryResponse copyWith(
          void Function(CancelPaperEntryResponse) updates) =>
      super.copyWith((message) => updates(message as CancelPaperEntryResponse))
          as CancelPaperEntryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelPaperEntryResponse() / CancelPaperEntryResponse.new instead')
  static CancelPaperEntryResponse create() => CancelPaperEntryResponse._();
  static $pb.GeneratedMessage $_createMessage() => CancelPaperEntryResponse._();
  @$core.override
  CancelPaperEntryResponse createEmptyInstance() =>
      CancelPaperEntryResponse._();
  @$core.pragma('dart2js:noInline')
  static CancelPaperEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelPaperEntryResponse>(
          CancelPaperEntryResponse.$_createMessage);
  static CancelPaperEntryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperReceipt get receipt => $_getN(0);
  @$pb.TagNumber(1)
  set receipt(PaperReceipt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReceipt() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceipt() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperReceipt ensureReceipt() => $_ensure(0);
}

class ReducePaperPositionRequest extends $pb.GeneratedMessage {
  factory ReducePaperPositionRequest({
    $2.AccountRef? account,
    $fixnum.Int64? receiptId,
    $fixnum.Int64? positionRevision,
    $0.Money? quantity,
  }) {
    final result = ReducePaperPositionRequest._();
    if (account != null) result.account = account;
    if (receiptId != null) result.receiptId = receiptId;
    if (positionRevision != null) result.positionRevision = positionRevision;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  ReducePaperPositionRequest._();

  factory ReducePaperPositionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReducePaperPositionRequest()..mergeFromBuffer(data, registry);
  factory ReducePaperPositionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReducePaperPositionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReducePaperPositionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ReducePaperPositionRequest.$_createMessage)
    ..aOM<$2.AccountRef>(1, _omitFieldNames ? '' : 'account',
        subBuilder: $2.AccountRef.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'receiptId')
    ..aInt64(3, _omitFieldNames ? '' : 'positionRevision')
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'quantity',
        subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReducePaperPositionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReducePaperPositionRequest copyWith(
          void Function(ReducePaperPositionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ReducePaperPositionRequest))
          as ReducePaperPositionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReducePaperPositionRequest() / ReducePaperPositionRequest.new instead')
  static ReducePaperPositionRequest create() => ReducePaperPositionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReducePaperPositionRequest._();
  @$core.override
  ReducePaperPositionRequest createEmptyInstance() =>
      ReducePaperPositionRequest._();
  @$core.pragma('dart2js:noInline')
  static ReducePaperPositionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReducePaperPositionRequest>(
          ReducePaperPositionRequest.$_createMessage);
  static ReducePaperPositionRequest? _defaultInstance;

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
  $fixnum.Int64 get receiptId => $_getI64(1);
  @$pb.TagNumber(2)
  set receiptId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceiptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get positionRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set positionRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPositionRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearPositionRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Money get quantity => $_getN(3);
  @$pb.TagNumber(4)
  set quantity($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureQuantity() => $_ensure(3);
}

class ReducePaperPositionResponse extends $pb.GeneratedMessage {
  factory ReducePaperPositionResponse({
    PaperReduction? reduction,
    PaperRestriction? restriction,
  }) {
    final result = ReducePaperPositionResponse._();
    if (reduction != null) result.reduction = reduction;
    if (restriction != null) result.restriction = restriction;
    return result;
  }

  ReducePaperPositionResponse._();

  factory ReducePaperPositionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReducePaperPositionResponse()..mergeFromBuffer(data, registry);
  factory ReducePaperPositionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReducePaperPositionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReducePaperPositionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ReducePaperPositionResponse.$_createMessage)
    ..aOM<PaperReduction>(1, _omitFieldNames ? '' : 'reduction',
        subBuilder: PaperReduction.$_createMessage)
    ..aOM<PaperRestriction>(2, _omitFieldNames ? '' : 'restriction',
        subBuilder: PaperRestriction.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReducePaperPositionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReducePaperPositionResponse copyWith(
          void Function(ReducePaperPositionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ReducePaperPositionResponse))
          as ReducePaperPositionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReducePaperPositionResponse() / ReducePaperPositionResponse.new instead')
  static ReducePaperPositionResponse create() =>
      ReducePaperPositionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReducePaperPositionResponse._();
  @$core.override
  ReducePaperPositionResponse createEmptyInstance() =>
      ReducePaperPositionResponse._();
  @$core.pragma('dart2js:noInline')
  static ReducePaperPositionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReducePaperPositionResponse>(
          ReducePaperPositionResponse.$_createMessage);
  static ReducePaperPositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaperReduction get reduction => $_getN(0);
  @$pb.TagNumber(1)
  set reduction(PaperReduction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReduction() => $_has(0);
  @$pb.TagNumber(1)
  void clearReduction() => $_clearField(1);
  @$pb.TagNumber(1)
  PaperReduction ensureReduction() => $_ensure(0);

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

class PaperReduction extends $pb.GeneratedMessage {
  factory PaperReduction({
    $fixnum.Int64? id,
    $fixnum.Int64? receiptId,
    PaperReductionState? state,
    $0.Money? quantity,
    $fixnum.Int64? requestedAtUnixMs,
    $fixnum.Int64? resultEventId,
  }) {
    final result = PaperReduction._();
    if (id != null) result.id = id;
    if (receiptId != null) result.receiptId = receiptId;
    if (state != null) result.state = state;
    if (quantity != null) result.quantity = quantity;
    if (requestedAtUnixMs != null) result.requestedAtUnixMs = requestedAtUnixMs;
    if (resultEventId != null) result.resultEventId = resultEventId;
    return result;
  }

  PaperReduction._();

  factory PaperReduction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReduction()..mergeFromBuffer(data, registry);
  factory PaperReduction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReduction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperReduction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperReduction.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'receiptId')
    ..aE<PaperReductionState>(3, _omitFieldNames ? '' : 'state',
        enumValues: PaperReductionState.values)
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'quantity',
        subBuilder: $0.Money.$_createMessage)
    ..aInt64(5, _omitFieldNames ? '' : 'requestedAtUnixMs')
    ..aInt64(6, _omitFieldNames ? '' : 'resultEventId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReduction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReduction copyWith(void Function(PaperReduction) updates) =>
      super.copyWith((message) => updates(message as PaperReduction))
          as PaperReduction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaperReduction() / PaperReduction.new instead')
  static PaperReduction create() => PaperReduction._();
  static $pb.GeneratedMessage $_createMessage() => PaperReduction._();
  @$core.override
  PaperReduction createEmptyInstance() => PaperReduction._();
  @$core.pragma('dart2js:noInline')
  static PaperReduction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaperReduction>(
          PaperReduction.$_createMessage);
  static PaperReduction? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receiptId => $_getI64(1);
  @$pb.TagNumber(2)
  set receiptId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceiptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiptId() => $_clearField(2);

  @$pb.TagNumber(3)
  PaperReductionState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(PaperReductionState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Money get quantity => $_getN(3);
  @$pb.TagNumber(4)
  set quantity($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureQuantity() => $_ensure(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get requestedAtUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set requestedAtUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRequestedAtUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequestedAtUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get resultEventId => $_getI64(5);
  @$pb.TagNumber(6)
  set resultEventId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResultEventId() => $_has(5);
  @$pb.TagNumber(6)
  void clearResultEventId() => $_clearField(6);
}

class PaperReconciliation extends $pb.GeneratedMessage {
  factory PaperReconciliation({
    $fixnum.Int64? checkedAtUnixMs,
    $fixnum.Int64? lastEventId,
    $core.bool? cashMatches,
    $core.bool? reservationsMatch,
    $core.bool? positionsMatch,
    $core.bool? eventsMatch,
  }) {
    final result = PaperReconciliation._();
    if (checkedAtUnixMs != null) result.checkedAtUnixMs = checkedAtUnixMs;
    if (lastEventId != null) result.lastEventId = lastEventId;
    if (cashMatches != null) result.cashMatches = cashMatches;
    if (reservationsMatch != null) result.reservationsMatch = reservationsMatch;
    if (positionsMatch != null) result.positionsMatch = positionsMatch;
    if (eventsMatch != null) result.eventsMatch = eventsMatch;
    return result;
  }

  PaperReconciliation._();

  factory PaperReconciliation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReconciliation()..mergeFromBuffer(data, registry);
  factory PaperReconciliation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReconciliation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperReconciliation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperReconciliation.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'checkedAtUnixMs')
    ..aInt64(2, _omitFieldNames ? '' : 'lastEventId')
    ..aOB(3, _omitFieldNames ? '' : 'cashMatches')
    ..aOB(4, _omitFieldNames ? '' : 'reservationsMatch')
    ..aOB(5, _omitFieldNames ? '' : 'positionsMatch')
    ..aOB(6, _omitFieldNames ? '' : 'eventsMatch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReconciliation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReconciliation copyWith(void Function(PaperReconciliation) updates) =>
      super.copyWith((message) => updates(message as PaperReconciliation))
          as PaperReconciliation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PaperReconciliation() / PaperReconciliation.new instead')
  static PaperReconciliation create() => PaperReconciliation._();
  static $pb.GeneratedMessage $_createMessage() => PaperReconciliation._();
  @$core.override
  PaperReconciliation createEmptyInstance() => PaperReconciliation._();
  @$core.pragma('dart2js:noInline')
  static PaperReconciliation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaperReconciliation>(
          PaperReconciliation.$_createMessage);
  static PaperReconciliation? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get checkedAtUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set checkedAtUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckedAtUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckedAtUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lastEventId => $_getI64(1);
  @$pb.TagNumber(2)
  set lastEventId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastEventId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastEventId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get cashMatches => $_getBF(2);
  @$pb.TagNumber(3)
  set cashMatches($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCashMatches() => $_has(2);
  @$pb.TagNumber(3)
  void clearCashMatches() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get reservationsMatch => $_getBF(3);
  @$pb.TagNumber(4)
  set reservationsMatch($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReservationsMatch() => $_has(3);
  @$pb.TagNumber(4)
  void clearReservationsMatch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get positionsMatch => $_getBF(4);
  @$pb.TagNumber(5)
  set positionsMatch($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPositionsMatch() => $_has(4);
  @$pb.TagNumber(5)
  void clearPositionsMatch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get eventsMatch => $_getBF(5);
  @$pb.TagNumber(6)
  set eventsMatch($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEventsMatch() => $_has(5);
  @$pb.TagNumber(6)
  void clearEventsMatch() => $_clearField(6);
}

class SetPaperEntryPauseRequest extends $pb.GeneratedMessage {
  factory SetPaperEntryPauseRequest({
    $2.AccountRef? account,
    $core.bool? paused,
  }) {
    final result = SetPaperEntryPauseRequest._();
    if (account != null) result.account = account;
    if (paused != null) result.paused = paused;
    return result;
  }

  SetPaperEntryPauseRequest._();

  factory SetPaperEntryPauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetPaperEntryPauseRequest()..mergeFromBuffer(data, registry);
  factory SetPaperEntryPauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetPaperEntryPauseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetPaperEntryPauseRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SetPaperEntryPauseRequest.$_createMessage)
    ..aOM<$2.AccountRef>(1, _omitFieldNames ? '' : 'account',
        subBuilder: $2.AccountRef.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'paused')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPaperEntryPauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPaperEntryPauseRequest copyWith(
          void Function(SetPaperEntryPauseRequest) updates) =>
      super.copyWith((message) => updates(message as SetPaperEntryPauseRequest))
          as SetPaperEntryPauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetPaperEntryPauseRequest() / SetPaperEntryPauseRequest.new instead')
  static SetPaperEntryPauseRequest create() => SetPaperEntryPauseRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetPaperEntryPauseRequest._();
  @$core.override
  SetPaperEntryPauseRequest createEmptyInstance() =>
      SetPaperEntryPauseRequest._();
  @$core.pragma('dart2js:noInline')
  static SetPaperEntryPauseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetPaperEntryPauseRequest>(
          SetPaperEntryPauseRequest.$_createMessage);
  static SetPaperEntryPauseRequest? _defaultInstance;

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
  $core.bool get paused => $_getBF(1);
  @$pb.TagNumber(2)
  set paused($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPaused() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaused() => $_clearField(2);
}

class SetPaperEntryPauseResponse extends $pb.GeneratedMessage {
  factory SetPaperEntryPauseResponse({
    $core.bool? paused,
  }) {
    final result = SetPaperEntryPauseResponse._();
    if (paused != null) result.paused = paused;
    return result;
  }

  SetPaperEntryPauseResponse._();

  factory SetPaperEntryPauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetPaperEntryPauseResponse()..mergeFromBuffer(data, registry);
  factory SetPaperEntryPauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetPaperEntryPauseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetPaperEntryPauseResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SetPaperEntryPauseResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'paused')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPaperEntryPauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetPaperEntryPauseResponse copyWith(
          void Function(SetPaperEntryPauseResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetPaperEntryPauseResponse))
          as SetPaperEntryPauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetPaperEntryPauseResponse() / SetPaperEntryPauseResponse.new instead')
  static SetPaperEntryPauseResponse create() => SetPaperEntryPauseResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetPaperEntryPauseResponse._();
  @$core.override
  SetPaperEntryPauseResponse createEmptyInstance() =>
      SetPaperEntryPauseResponse._();
  @$core.pragma('dart2js:noInline')
  static SetPaperEntryPauseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetPaperEntryPauseResponse>(
          SetPaperEntryPauseResponse.$_createMessage);
  static SetPaperEntryPauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get paused => $_getBF(0);
  @$pb.TagNumber(1)
  set paused($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPaused() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaused() => $_clearField(1);
}

class PaperReceipt extends $pb.GeneratedMessage {
  factory PaperReceipt({
    $fixnum.Int64? id,
    $2.AccountRef? account,
    $core.String? planHash,
    $core.String? symbol,
    PaperEntryState? state,
    $0.Money? requestedQuantity,
    $0.Money? filledQuantity,
    $0.Money? reservedCash,
    $fixnum.Int64? confirmedAtUnixMs,
    $fixnum.Int64? expiresAtUnixMs,
  }) {
    final result = PaperReceipt._();
    if (id != null) result.id = id;
    if (account != null) result.account = account;
    if (planHash != null) result.planHash = planHash;
    if (symbol != null) result.symbol = symbol;
    if (state != null) result.state = state;
    if (requestedQuantity != null) result.requestedQuantity = requestedQuantity;
    if (filledQuantity != null) result.filledQuantity = filledQuantity;
    if (reservedCash != null) result.reservedCash = reservedCash;
    if (confirmedAtUnixMs != null) result.confirmedAtUnixMs = confirmedAtUnixMs;
    if (expiresAtUnixMs != null) result.expiresAtUnixMs = expiresAtUnixMs;
    return result;
  }

  PaperReceipt._();

  factory PaperReceipt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReceipt()..mergeFromBuffer(data, registry);
  factory PaperReceipt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperReceipt()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperReceipt',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperReceipt.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOM<$2.AccountRef>(2, _omitFieldNames ? '' : 'account',
        subBuilder: $2.AccountRef.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'planHash')
    ..aOS(4, _omitFieldNames ? '' : 'symbol')
    ..aE<PaperEntryState>(5, _omitFieldNames ? '' : 'state',
        enumValues: PaperEntryState.values)
    ..aOM<$0.Money>(6, _omitFieldNames ? '' : 'requestedQuantity',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(7, _omitFieldNames ? '' : 'filledQuantity',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(8, _omitFieldNames ? '' : 'reservedCash',
        subBuilder: $0.Money.$_createMessage)
    ..aInt64(9, _omitFieldNames ? '' : 'confirmedAtUnixMs')
    ..aInt64(10, _omitFieldNames ? '' : 'expiresAtUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReceipt clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperReceipt copyWith(void Function(PaperReceipt) updates) =>
      super.copyWith((message) => updates(message as PaperReceipt))
          as PaperReceipt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaperReceipt() / PaperReceipt.new instead')
  static PaperReceipt create() => PaperReceipt._();
  static $pb.GeneratedMessage $_createMessage() => PaperReceipt._();
  @$core.override
  PaperReceipt createEmptyInstance() => PaperReceipt._();
  @$core.pragma('dart2js:noInline')
  static PaperReceipt getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaperReceipt>(
          PaperReceipt.$_createMessage);
  static PaperReceipt? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

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
  $core.String get planHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set planHash($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlanHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlanHash() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get symbol => $_getSZ(3);
  @$pb.TagNumber(4)
  set symbol($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSymbol() => $_has(3);
  @$pb.TagNumber(4)
  void clearSymbol() => $_clearField(4);

  @$pb.TagNumber(5)
  PaperEntryState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(PaperEntryState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Money get requestedQuantity => $_getN(5);
  @$pb.TagNumber(6)
  set requestedQuantity($0.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestedQuantity() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestedQuantity() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Money ensureRequestedQuantity() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Money get filledQuantity => $_getN(6);
  @$pb.TagNumber(7)
  set filledQuantity($0.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFilledQuantity() => $_has(6);
  @$pb.TagNumber(7)
  void clearFilledQuantity() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Money ensureFilledQuantity() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Money get reservedCash => $_getN(7);
  @$pb.TagNumber(8)
  set reservedCash($0.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReservedCash() => $_has(7);
  @$pb.TagNumber(8)
  void clearReservedCash() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Money ensureReservedCash() => $_ensure(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get confirmedAtUnixMs => $_getI64(8);
  @$pb.TagNumber(9)
  set confirmedAtUnixMs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConfirmedAtUnixMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfirmedAtUnixMs() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get expiresAtUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set expiresAtUnixMs($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExpiresAtUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearExpiresAtUnixMs() => $_clearField(10);
}

class PaperPosition extends $pb.GeneratedMessage {
  factory PaperPosition({
    $fixnum.Int64? receiptId,
    $core.String? symbol,
    $0.Money? quantity,
    $0.Money? costBasis,
    $1.MoneyReading? marketValue,
    $fixnum.Int64? revision,
    $0.Money? lot,
    PaperReduction? pendingReduction,
  }) {
    final result = PaperPosition._();
    if (receiptId != null) result.receiptId = receiptId;
    if (symbol != null) result.symbol = symbol;
    if (quantity != null) result.quantity = quantity;
    if (costBasis != null) result.costBasis = costBasis;
    if (marketValue != null) result.marketValue = marketValue;
    if (revision != null) result.revision = revision;
    if (lot != null) result.lot = lot;
    if (pendingReduction != null) result.pendingReduction = pendingReduction;
    return result;
  }

  PaperPosition._();

  factory PaperPosition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperPosition()..mergeFromBuffer(data, registry);
  factory PaperPosition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperPosition()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperPosition',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperPosition.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'receiptId')
    ..aOS(2, _omitFieldNames ? '' : 'symbol')
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'quantity',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'costBasis',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$1.MoneyReading>(5, _omitFieldNames ? '' : 'marketValue',
        subBuilder: $1.MoneyReading.$_createMessage)
    ..aInt64(6, _omitFieldNames ? '' : 'revision')
    ..aOM<$0.Money>(7, _omitFieldNames ? '' : 'lot',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<PaperReduction>(8, _omitFieldNames ? '' : 'pendingReduction',
        subBuilder: PaperReduction.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperPosition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperPosition copyWith(void Function(PaperPosition) updates) =>
      super.copyWith((message) => updates(message as PaperPosition))
          as PaperPosition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaperPosition() / PaperPosition.new instead')
  static PaperPosition create() => PaperPosition._();
  static $pb.GeneratedMessage $_createMessage() => PaperPosition._();
  @$core.override
  PaperPosition createEmptyInstance() => PaperPosition._();
  @$core.pragma('dart2js:noInline')
  static PaperPosition getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaperPosition>(
          PaperPosition.$_createMessage);
  static PaperPosition? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get receiptId => $_getI64(0);
  @$pb.TagNumber(1)
  set receiptId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceiptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceiptId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get symbol => $_getSZ(1);
  @$pb.TagNumber(2)
  set symbol($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSymbol() => $_has(1);
  @$pb.TagNumber(2)
  void clearSymbol() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Money get quantity => $_getN(2);
  @$pb.TagNumber(3)
  set quantity($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureQuantity() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Money get costBasis => $_getN(3);
  @$pb.TagNumber(4)
  set costBasis($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCostBasis() => $_has(3);
  @$pb.TagNumber(4)
  void clearCostBasis() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureCostBasis() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.MoneyReading get marketValue => $_getN(4);
  @$pb.TagNumber(5)
  set marketValue($1.MoneyReading value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMarketValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearMarketValue() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.MoneyReading ensureMarketValue() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get revision => $_getI64(5);
  @$pb.TagNumber(6)
  set revision($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearRevision() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Money get lot => $_getN(6);
  @$pb.TagNumber(7)
  set lot($0.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLot() => $_has(6);
  @$pb.TagNumber(7)
  void clearLot() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Money ensureLot() => $_ensure(6);

  @$pb.TagNumber(8)
  PaperReduction get pendingReduction => $_getN(7);
  @$pb.TagNumber(8)
  set pendingReduction(PaperReduction value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPendingReduction() => $_has(7);
  @$pb.TagNumber(8)
  void clearPendingReduction() => $_clearField(8);
  @$pb.TagNumber(8)
  PaperReduction ensurePendingReduction() => $_ensure(7);
}

class PaperExecutionEvent extends $pb.GeneratedMessage {
  factory PaperExecutionEvent({
    $fixnum.Int64? id,
    $core.String? kind,
    $fixnum.Int64? recordedAtUnixMs,
    $0.Money? quantity,
    $0.Money? referencePrice,
    $0.Money? fillPrice,
    $0.Money? fee,
    $0.Money? cash,
    $fixnum.Int64? candleOpenedAtUnixMs,
    $core.int? candleRevision,
    $0.Money? realizedPnl,
  }) {
    final result = PaperExecutionEvent._();
    if (id != null) result.id = id;
    if (kind != null) result.kind = kind;
    if (recordedAtUnixMs != null) result.recordedAtUnixMs = recordedAtUnixMs;
    if (quantity != null) result.quantity = quantity;
    if (referencePrice != null) result.referencePrice = referencePrice;
    if (fillPrice != null) result.fillPrice = fillPrice;
    if (fee != null) result.fee = fee;
    if (cash != null) result.cash = cash;
    if (candleOpenedAtUnixMs != null)
      result.candleOpenedAtUnixMs = candleOpenedAtUnixMs;
    if (candleRevision != null) result.candleRevision = candleRevision;
    if (realizedPnl != null) result.realizedPnl = realizedPnl;
    return result;
  }

  PaperExecutionEvent._();

  factory PaperExecutionEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperExecutionEvent()..mergeFromBuffer(data, registry);
  factory PaperExecutionEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaperExecutionEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaperExecutionEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PaperExecutionEvent.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aInt64(3, _omitFieldNames ? '' : 'recordedAtUnixMs')
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'quantity',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(5, _omitFieldNames ? '' : 'referencePrice',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(6, _omitFieldNames ? '' : 'fillPrice',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(7, _omitFieldNames ? '' : 'fee',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(8, _omitFieldNames ? '' : 'cash',
        subBuilder: $0.Money.$_createMessage)
    ..aInt64(9, _omitFieldNames ? '' : 'candleOpenedAtUnixMs')
    ..aI(10, _omitFieldNames ? '' : 'candleRevision')
    ..aOM<$0.Money>(11, _omitFieldNames ? '' : 'realizedPnl',
        subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperExecutionEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaperExecutionEvent copyWith(void Function(PaperExecutionEvent) updates) =>
      super.copyWith((message) => updates(message as PaperExecutionEvent))
          as PaperExecutionEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PaperExecutionEvent() / PaperExecutionEvent.new instead')
  static PaperExecutionEvent create() => PaperExecutionEvent._();
  static $pb.GeneratedMessage $_createMessage() => PaperExecutionEvent._();
  @$core.override
  PaperExecutionEvent createEmptyInstance() => PaperExecutionEvent._();
  @$core.pragma('dart2js:noInline')
  static PaperExecutionEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaperExecutionEvent>(
          PaperExecutionEvent.$_createMessage);
  static PaperExecutionEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get recordedAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set recordedAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordedAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordedAtUnixMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Money get quantity => $_getN(3);
  @$pb.TagNumber(4)
  set quantity($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureQuantity() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Money get referencePrice => $_getN(4);
  @$pb.TagNumber(5)
  set referencePrice($0.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReferencePrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearReferencePrice() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Money ensureReferencePrice() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Money get fillPrice => $_getN(5);
  @$pb.TagNumber(6)
  set fillPrice($0.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFillPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearFillPrice() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Money ensureFillPrice() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Money get fee => $_getN(6);
  @$pb.TagNumber(7)
  set fee($0.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFee() => $_has(6);
  @$pb.TagNumber(7)
  void clearFee() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Money ensureFee() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Money get cash => $_getN(7);
  @$pb.TagNumber(8)
  set cash($0.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCash() => $_has(7);
  @$pb.TagNumber(8)
  void clearCash() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Money ensureCash() => $_ensure(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get candleOpenedAtUnixMs => $_getI64(8);
  @$pb.TagNumber(9)
  set candleOpenedAtUnixMs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCandleOpenedAtUnixMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearCandleOpenedAtUnixMs() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get candleRevision => $_getIZ(9);
  @$pb.TagNumber(10)
  set candleRevision($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCandleRevision() => $_has(9);
  @$pb.TagNumber(10)
  void clearCandleRevision() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Money get realizedPnl => $_getN(10);
  @$pb.TagNumber(11)
  set realizedPnl($0.Money value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRealizedPnl() => $_has(10);
  @$pb.TagNumber(11)
  void clearRealizedPnl() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Money ensureRealizedPnl() => $_ensure(10);
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
  $async.Future<ConfirmPaperPlanResponse> confirmPaperPlan(
          $pb.ClientContext? ctx, ConfirmPaperPlanRequest request) =>
      _client.invoke<ConfirmPaperPlanResponse>(ctx, 'PaperService',
          'ConfirmPaperPlan', request, ConfirmPaperPlanResponse());
  $async.Future<GetPaperReceiptResponse> getPaperReceipt(
          $pb.ClientContext? ctx, GetPaperReceiptRequest request) =>
      _client.invoke<GetPaperReceiptResponse>(ctx, 'PaperService',
          'GetPaperReceipt', request, GetPaperReceiptResponse());
  $async.Future<ListPaperJournalResponse> listPaperJournal(
          $pb.ClientContext? ctx, ListPaperJournalRequest request) =>
      _client.invoke<ListPaperJournalResponse>(ctx, 'PaperService',
          'ListPaperJournal', request, ListPaperJournalResponse());
  $async.Future<GetPaperReplayResponse> getPaperReplay(
          $pb.ClientContext? ctx, GetPaperReplayRequest request) =>
      _client.invoke<GetPaperReplayResponse>(ctx, 'PaperService',
          'GetPaperReplay', request, GetPaperReplayResponse());
  $async.Future<SavePaperJournalNoteResponse> savePaperJournalNote(
          $pb.ClientContext? ctx, SavePaperJournalNoteRequest request) =>
      _client.invoke<SavePaperJournalNoteResponse>(ctx, 'PaperService',
          'SavePaperJournalNote', request, SavePaperJournalNoteResponse());
  $async.Future<CancelPaperEntryResponse> cancelPaperEntry(
          $pb.ClientContext? ctx, CancelPaperEntryRequest request) =>
      _client.invoke<CancelPaperEntryResponse>(ctx, 'PaperService',
          'CancelPaperEntry', request, CancelPaperEntryResponse());
  $async.Future<ReducePaperPositionResponse> reducePaperPosition(
          $pb.ClientContext? ctx, ReducePaperPositionRequest request) =>
      _client.invoke<ReducePaperPositionResponse>(ctx, 'PaperService',
          'ReducePaperPosition', request, ReducePaperPositionResponse());
  $async.Future<SetPaperEntryPauseResponse> setPaperEntryPause(
          $pb.ClientContext? ctx, SetPaperEntryPauseRequest request) =>
      _client.invoke<SetPaperEntryPauseResponse>(ctx, 'PaperService',
          'SetPaperEntryPause', request, SetPaperEntryPauseResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
