// This is a generated file - do not edit.
//
// Generated from lab/v1/pnl.proto.

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
import 'report.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class RecalculateRequest extends $pb.GeneratedMessage {
  factory RecalculateRequest({
    $core.String? reportId,
    $0.Money? capital,
    $0.Decimal? positionSize,
    $0.Decimal? fee,
    $0.Decimal? slippage,
    $fixnum.Int64? fxRateId,
  }) {
    final result = RecalculateRequest._();
    if (reportId != null) result.reportId = reportId;
    if (capital != null) result.capital = capital;
    if (positionSize != null) result.positionSize = positionSize;
    if (fee != null) result.fee = fee;
    if (slippage != null) result.slippage = slippage;
    if (fxRateId != null) result.fxRateId = fxRateId;
    return result;
  }

  RecalculateRequest._();

  factory RecalculateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecalculateRequest()..mergeFromBuffer(data, registry);
  factory RecalculateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecalculateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RecalculateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RecalculateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'capital', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(3, _omitFieldNames ? '' : 'positionSize', subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(4, _omitFieldNames ? '' : 'fee', subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(5, _omitFieldNames ? '' : 'slippage', subBuilder: $0.Decimal.$_createMessage)
    ..aInt64(6, _omitFieldNames ? '' : 'fxRateId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecalculateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecalculateRequest copyWith(void Function(RecalculateRequest) updates) =>
      super.copyWith((message) => updates(message as RecalculateRequest)) as RecalculateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecalculateRequest() / RecalculateRequest.new instead')
  static RecalculateRequest create() => RecalculateRequest._();
  static $pb.GeneratedMessage $_createMessage() => RecalculateRequest._();
  @$core.override
  RecalculateRequest createEmptyInstance() => RecalculateRequest._();
  @$core.pragma('dart2js:noInline')
  static RecalculateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecalculateRequest>(RecalculateRequest.$_createMessage);
  static RecalculateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  /// Unset fields keep the setting of the report.
  @$pb.TagNumber(2)
  $0.Money get capital => $_getN(1);
  @$pb.TagNumber(2)
  set capital($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCapital() => $_has(1);
  @$pb.TagNumber(2)
  void clearCapital() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensureCapital() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Decimal get positionSize => $_getN(2);
  @$pb.TagNumber(3)
  set positionSize($0.Decimal value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPositionSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPositionSize() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Decimal ensurePositionSize() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Decimal get fee => $_getN(3);
  @$pb.TagNumber(4)
  set fee($0.Decimal value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearFee() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Decimal ensureFee() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Decimal get slippage => $_getN(4);
  @$pb.TagNumber(5)
  set slippage($0.Decimal value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSlippage() => $_has(4);
  @$pb.TagNumber(5)
  void clearSlippage() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Decimal ensureSlippage() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get fxRateId => $_getI64(5);
  @$pb.TagNumber(6)
  set fxRateId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFxRateId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFxRateId() => $_clearField(6);
}

class Waterfall extends $pb.GeneratedMessage {
  factory Waterfall({
    $0.Money? gross,
    $0.Money? fees,
    $0.Money? slippage,
    $0.Money? net,
  }) {
    final result = Waterfall._();
    if (gross != null) result.gross = gross;
    if (fees != null) result.fees = fees;
    if (slippage != null) result.slippage = slippage;
    if (net != null) result.net = net;
    return result;
  }

  Waterfall._();

  factory Waterfall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Waterfall()..mergeFromBuffer(data, registry);
  factory Waterfall.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Waterfall()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Waterfall',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'), createEmptyInstance: Waterfall.$_createMessage)
    ..aOM<$0.Money>(1, _omitFieldNames ? '' : 'gross', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'fees', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'slippage', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'net', subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Waterfall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Waterfall copyWith(void Function(Waterfall) updates) =>
      super.copyWith((message) => updates(message as Waterfall)) as Waterfall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Waterfall() / Waterfall.new instead')
  static Waterfall create() => Waterfall._();
  static $pb.GeneratedMessage $_createMessage() => Waterfall._();
  @$core.override
  Waterfall createEmptyInstance() => Waterfall._();
  @$core.pragma('dart2js:noInline')
  static Waterfall getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Waterfall>(Waterfall.$_createMessage);
  static Waterfall? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Money get gross => $_getN(0);
  @$pb.TagNumber(1)
  set gross($0.Money value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGross() => $_has(0);
  @$pb.TagNumber(1)
  void clearGross() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Money ensureGross() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Money get fees => $_getN(1);
  @$pb.TagNumber(2)
  set fees($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFees() => $_has(1);
  @$pb.TagNumber(2)
  void clearFees() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensureFees() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Money get slippage => $_getN(2);
  @$pb.TagNumber(3)
  set slippage($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSlippage() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlippage() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureSlippage() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Money get net => $_getN(3);
  @$pb.TagNumber(4)
  set net($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNet() => $_has(3);
  @$pb.TagNumber(4)
  void clearNet() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureNet() => $_ensure(3);
}

class RecalculateResponse extends $pb.GeneratedMessage {
  factory RecalculateResponse({
    $0.Money? capital,
    $0.Decimal? positionSize,
    $0.Decimal? fee,
    $0.Decimal? slippage,
    Waterfall? waterfall,
    $core.Iterable<$0.Metric>? metrics,
    $core.Iterable<$0.EquityPoint>? equity,
    $core.Iterable<$1.TradeRow>? trades,
    $0.Decimal? breakEvenFee,
    $core.String? verdict,
    $core.String? tone,
    $core.String? sentence,
    $0.Money? originalNet,
    $0.Money? netToman,
    $0.Money? finalEquityToman,
  }) {
    final result = RecalculateResponse._();
    if (capital != null) result.capital = capital;
    if (positionSize != null) result.positionSize = positionSize;
    if (fee != null) result.fee = fee;
    if (slippage != null) result.slippage = slippage;
    if (waterfall != null) result.waterfall = waterfall;
    if (metrics != null) result.metrics.addAll(metrics);
    if (equity != null) result.equity.addAll(equity);
    if (trades != null) result.trades.addAll(trades);
    if (breakEvenFee != null) result.breakEvenFee = breakEvenFee;
    if (verdict != null) result.verdict = verdict;
    if (tone != null) result.tone = tone;
    if (sentence != null) result.sentence = sentence;
    if (originalNet != null) result.originalNet = originalNet;
    if (netToman != null) result.netToman = netToman;
    if (finalEquityToman != null) result.finalEquityToman = finalEquityToman;
    return result;
  }

  RecalculateResponse._();

  factory RecalculateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecalculateResponse()..mergeFromBuffer(data, registry);
  factory RecalculateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecalculateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RecalculateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RecalculateResponse.$_createMessage)
    ..aOM<$0.Money>(1, _omitFieldNames ? '' : 'capital', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(2, _omitFieldNames ? '' : 'positionSize', subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(3, _omitFieldNames ? '' : 'fee', subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(4, _omitFieldNames ? '' : 'slippage', subBuilder: $0.Decimal.$_createMessage)
    ..aOM<Waterfall>(5, _omitFieldNames ? '' : 'waterfall', subBuilder: Waterfall.$_createMessage)
    ..pPM<$0.Metric>(6, _omitFieldNames ? '' : 'metrics', subBuilder: $0.Metric.$_createMessage)
    ..pPM<$0.EquityPoint>(7, _omitFieldNames ? '' : 'equity', subBuilder: $0.EquityPoint.$_createMessage)
    ..pPM<$1.TradeRow>(8, _omitFieldNames ? '' : 'trades', subBuilder: $1.TradeRow.$_createMessage)
    ..aOM<$0.Decimal>(9, _omitFieldNames ? '' : 'breakEvenFee', subBuilder: $0.Decimal.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'verdict')
    ..aOS(11, _omitFieldNames ? '' : 'tone')
    ..aOS(12, _omitFieldNames ? '' : 'sentence')
    ..aOM<$0.Money>(13, _omitFieldNames ? '' : 'originalNet', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(14, _omitFieldNames ? '' : 'netToman', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(15, _omitFieldNames ? '' : 'finalEquityToman', subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecalculateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecalculateResponse copyWith(void Function(RecalculateResponse) updates) =>
      super.copyWith((message) => updates(message as RecalculateResponse)) as RecalculateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecalculateResponse() / RecalculateResponse.new instead')
  static RecalculateResponse create() => RecalculateResponse._();
  static $pb.GeneratedMessage $_createMessage() => RecalculateResponse._();
  @$core.override
  RecalculateResponse createEmptyInstance() => RecalculateResponse._();
  @$core.pragma('dart2js:noInline')
  static RecalculateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecalculateResponse>(RecalculateResponse.$_createMessage);
  static RecalculateResponse? _defaultInstance;

  /// Settings actually used (defaults filled in), so the UI can reset to them.
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
  $0.Decimal get positionSize => $_getN(1);
  @$pb.TagNumber(2)
  set positionSize($0.Decimal value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPositionSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPositionSize() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Decimal ensurePositionSize() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Decimal get fee => $_getN(2);
  @$pb.TagNumber(3)
  set fee($0.Decimal value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFee() => $_has(2);
  @$pb.TagNumber(3)
  void clearFee() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Decimal ensureFee() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Decimal get slippage => $_getN(3);
  @$pb.TagNumber(4)
  set slippage($0.Decimal value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSlippage() => $_has(3);
  @$pb.TagNumber(4)
  void clearSlippage() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Decimal ensureSlippage() => $_ensure(3);

  @$pb.TagNumber(5)
  Waterfall get waterfall => $_getN(4);
  @$pb.TagNumber(5)
  set waterfall(Waterfall value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasWaterfall() => $_has(4);
  @$pb.TagNumber(5)
  void clearWaterfall() => $_clearField(5);
  @$pb.TagNumber(5)
  Waterfall ensureWaterfall() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<$0.Metric> get metrics => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$0.EquityPoint> get equity => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$1.TradeRow> get trades => $_getList(7);

  @$pb.TagNumber(9)
  $0.Decimal get breakEvenFee => $_getN(8);
  @$pb.TagNumber(9)
  set breakEvenFee($0.Decimal value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasBreakEvenFee() => $_has(8);
  @$pb.TagNumber(9)
  void clearBreakEvenFee() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Decimal ensureBreakEvenFee() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get verdict => $_getSZ(9);
  @$pb.TagNumber(10)
  set verdict($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVerdict() => $_has(9);
  @$pb.TagNumber(10)
  void clearVerdict() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get tone => $_getSZ(10);
  @$pb.TagNumber(11)
  set tone($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTone() => $_has(10);
  @$pb.TagNumber(11)
  void clearTone() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get sentence => $_getSZ(11);
  @$pb.TagNumber(12)
  set sentence($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSentence() => $_has(11);
  @$pb.TagNumber(12)
  void clearSentence() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Money get originalNet => $_getN(12);
  @$pb.TagNumber(13)
  set originalNet($0.Money value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOriginalNet() => $_has(12);
  @$pb.TagNumber(13)
  void clearOriginalNet() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Money ensureOriginalNet() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Money get netToman => $_getN(13);
  @$pb.TagNumber(14)
  set netToman($0.Money value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasNetToman() => $_has(13);
  @$pb.TagNumber(14)
  void clearNetToman() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Money ensureNetToman() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Money get finalEquityToman => $_getN(14);
  @$pb.TagNumber(15)
  set finalEquityToman($0.Money value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasFinalEquityToman() => $_has(14);
  @$pb.TagNumber(15)
  void clearFinalEquityToman() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Money ensureFinalEquityToman() => $_ensure(14);
}

class CalculateTradeRequest extends $pb.GeneratedMessage {
  factory CalculateTradeRequest({
    $0.Money? entry,
    $0.Money? exit,
    $0.Money? amount,
    $0.Decimal? fee,
    $0.Decimal? slippage,
    $fixnum.Int64? fxRateId,
  }) {
    final result = CalculateTradeRequest._();
    if (entry != null) result.entry = entry;
    if (exit != null) result.exit = exit;
    if (amount != null) result.amount = amount;
    if (fee != null) result.fee = fee;
    if (slippage != null) result.slippage = slippage;
    if (fxRateId != null) result.fxRateId = fxRateId;
    return result;
  }

  CalculateTradeRequest._();

  factory CalculateTradeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalculateTradeRequest()..mergeFromBuffer(data, registry);
  factory CalculateTradeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalculateTradeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateTradeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CalculateTradeRequest.$_createMessage)
    ..aOM<$0.Money>(1, _omitFieldNames ? '' : 'entry', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'exit', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'amount', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(4, _omitFieldNames ? '' : 'fee', subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(5, _omitFieldNames ? '' : 'slippage', subBuilder: $0.Decimal.$_createMessage)
    ..aInt64(6, _omitFieldNames ? '' : 'fxRateId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateTradeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateTradeRequest copyWith(void Function(CalculateTradeRequest) updates) =>
      super.copyWith((message) => updates(message as CalculateTradeRequest)) as CalculateTradeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CalculateTradeRequest() / CalculateTradeRequest.new instead')
  static CalculateTradeRequest create() => CalculateTradeRequest._();
  static $pb.GeneratedMessage $_createMessage() => CalculateTradeRequest._();
  @$core.override
  CalculateTradeRequest createEmptyInstance() => CalculateTradeRequest._();
  @$core.pragma('dart2js:noInline')
  static CalculateTradeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculateTradeRequest>(CalculateTradeRequest.$_createMessage);
  static CalculateTradeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Money get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry($0.Money value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Money ensureEntry() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Money get exit => $_getN(1);
  @$pb.TagNumber(2)
  set exit($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasExit() => $_has(1);
  @$pb.TagNumber(2)
  void clearExit() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensureExit() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Money get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureAmount() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Decimal get fee => $_getN(3);
  @$pb.TagNumber(4)
  set fee($0.Decimal value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFee() => $_has(3);
  @$pb.TagNumber(4)
  void clearFee() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Decimal ensureFee() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Decimal get slippage => $_getN(4);
  @$pb.TagNumber(5)
  set slippage($0.Decimal value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSlippage() => $_has(4);
  @$pb.TagNumber(5)
  void clearSlippage() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Decimal ensureSlippage() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get fxRateId => $_getI64(5);
  @$pb.TagNumber(6)
  set fxRateId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFxRateId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFxRateId() => $_clearField(6);
}

class TradeLeg extends $pb.GeneratedMessage {
  factory TradeLeg({
    $0.Money? refPrice,
    $0.Money? price,
    $0.Money? refValue,
    $0.Money? value,
    $0.Money? slippage,
    $0.Money? fee,
  }) {
    final result = TradeLeg._();
    if (refPrice != null) result.refPrice = refPrice;
    if (price != null) result.price = price;
    if (refValue != null) result.refValue = refValue;
    if (value != null) result.value = value;
    if (slippage != null) result.slippage = slippage;
    if (fee != null) result.fee = fee;
    return result;
  }

  TradeLeg._();

  factory TradeLeg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TradeLeg()..mergeFromBuffer(data, registry);
  factory TradeLeg.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TradeLeg()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TradeLeg',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'), createEmptyInstance: TradeLeg.$_createMessage)
    ..aOM<$0.Money>(1, _omitFieldNames ? '' : 'refPrice', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'price', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(3, _omitFieldNames ? '' : 'refValue', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(4, _omitFieldNames ? '' : 'value', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(5, _omitFieldNames ? '' : 'slippage', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Money>(6, _omitFieldNames ? '' : 'fee', subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TradeLeg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TradeLeg copyWith(void Function(TradeLeg) updates) =>
      super.copyWith((message) => updates(message as TradeLeg)) as TradeLeg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TradeLeg() / TradeLeg.new instead')
  static TradeLeg create() => TradeLeg._();
  static $pb.GeneratedMessage $_createMessage() => TradeLeg._();
  @$core.override
  TradeLeg createEmptyInstance() => TradeLeg._();
  @$core.pragma('dart2js:noInline')
  static TradeLeg getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TradeLeg>(TradeLeg.$_createMessage);
  static TradeLeg? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Money get refPrice => $_getN(0);
  @$pb.TagNumber(1)
  set refPrice($0.Money value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRefPrice() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefPrice() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Money ensureRefPrice() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Money get price => $_getN(1);
  @$pb.TagNumber(2)
  set price($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrice() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensurePrice() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Money get refValue => $_getN(2);
  @$pb.TagNumber(3)
  set refValue($0.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRefValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefValue() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Money ensureRefValue() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Money get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($0.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Money ensureValue() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Money get slippage => $_getN(4);
  @$pb.TagNumber(5)
  set slippage($0.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSlippage() => $_has(4);
  @$pb.TagNumber(5)
  void clearSlippage() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Money ensureSlippage() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Money get fee => $_getN(5);
  @$pb.TagNumber(6)
  set fee($0.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFee() => $_has(5);
  @$pb.TagNumber(6)
  void clearFee() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Money ensureFee() => $_ensure(5);
}

class CalculateTradeResponse extends $pb.GeneratedMessage {
  factory CalculateTradeResponse({
    $0.Decimal? qty,
    TradeLeg? buy,
    TradeLeg? sell,
    Waterfall? waterfall,
    $0.Money? cost,
    $0.Decimal? return_6,
    $0.Money? breakEvenExit,
    $core.String? verdict,
    $core.String? tone,
    $core.String? sentence,
    $0.Money? netToman,
  }) {
    final result = CalculateTradeResponse._();
    if (qty != null) result.qty = qty;
    if (buy != null) result.buy = buy;
    if (sell != null) result.sell = sell;
    if (waterfall != null) result.waterfall = waterfall;
    if (cost != null) result.cost = cost;
    if (return_6 != null) result.return_6 = return_6;
    if (breakEvenExit != null) result.breakEvenExit = breakEvenExit;
    if (verdict != null) result.verdict = verdict;
    if (tone != null) result.tone = tone;
    if (sentence != null) result.sentence = sentence;
    if (netToman != null) result.netToman = netToman;
    return result;
  }

  CalculateTradeResponse._();

  factory CalculateTradeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalculateTradeResponse()..mergeFromBuffer(data, registry);
  factory CalculateTradeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalculateTradeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateTradeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CalculateTradeResponse.$_createMessage)
    ..aOM<$0.Decimal>(1, _omitFieldNames ? '' : 'qty', subBuilder: $0.Decimal.$_createMessage)
    ..aOM<TradeLeg>(2, _omitFieldNames ? '' : 'buy', subBuilder: TradeLeg.$_createMessage)
    ..aOM<TradeLeg>(3, _omitFieldNames ? '' : 'sell', subBuilder: TradeLeg.$_createMessage)
    ..aOM<Waterfall>(4, _omitFieldNames ? '' : 'waterfall', subBuilder: Waterfall.$_createMessage)
    ..aOM<$0.Money>(5, _omitFieldNames ? '' : 'cost', subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(6, _omitFieldNames ? '' : 'return', subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Money>(7, _omitFieldNames ? '' : 'breakEvenExit', subBuilder: $0.Money.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'verdict')
    ..aOS(9, _omitFieldNames ? '' : 'tone')
    ..aOS(10, _omitFieldNames ? '' : 'sentence')
    ..aOM<$0.Money>(11, _omitFieldNames ? '' : 'netToman', subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateTradeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculateTradeResponse copyWith(void Function(CalculateTradeResponse) updates) =>
      super.copyWith((message) => updates(message as CalculateTradeResponse)) as CalculateTradeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CalculateTradeResponse() / CalculateTradeResponse.new instead')
  static CalculateTradeResponse create() => CalculateTradeResponse._();
  static $pb.GeneratedMessage $_createMessage() => CalculateTradeResponse._();
  @$core.override
  CalculateTradeResponse createEmptyInstance() => CalculateTradeResponse._();
  @$core.pragma('dart2js:noInline')
  static CalculateTradeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculateTradeResponse>(CalculateTradeResponse.$_createMessage);
  static CalculateTradeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Decimal get qty => $_getN(0);
  @$pb.TagNumber(1)
  set qty($0.Decimal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasQty() => $_has(0);
  @$pb.TagNumber(1)
  void clearQty() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Decimal ensureQty() => $_ensure(0);

  @$pb.TagNumber(2)
  TradeLeg get buy => $_getN(1);
  @$pb.TagNumber(2)
  set buy(TradeLeg value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBuy() => $_has(1);
  @$pb.TagNumber(2)
  void clearBuy() => $_clearField(2);
  @$pb.TagNumber(2)
  TradeLeg ensureBuy() => $_ensure(1);

  @$pb.TagNumber(3)
  TradeLeg get sell => $_getN(2);
  @$pb.TagNumber(3)
  set sell(TradeLeg value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSell() => $_has(2);
  @$pb.TagNumber(3)
  void clearSell() => $_clearField(3);
  @$pb.TagNumber(3)
  TradeLeg ensureSell() => $_ensure(2);

  @$pb.TagNumber(4)
  Waterfall get waterfall => $_getN(3);
  @$pb.TagNumber(4)
  set waterfall(Waterfall value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWaterfall() => $_has(3);
  @$pb.TagNumber(4)
  void clearWaterfall() => $_clearField(4);
  @$pb.TagNumber(4)
  Waterfall ensureWaterfall() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Money get cost => $_getN(4);
  @$pb.TagNumber(5)
  set cost($0.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCost() => $_has(4);
  @$pb.TagNumber(5)
  void clearCost() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Money ensureCost() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Decimal get return_6 => $_getN(5);
  @$pb.TagNumber(6)
  set return_6($0.Decimal value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReturn_6() => $_has(5);
  @$pb.TagNumber(6)
  void clearReturn_6() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Decimal ensureReturn_6() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Money get breakEvenExit => $_getN(6);
  @$pb.TagNumber(7)
  set breakEvenExit($0.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBreakEvenExit() => $_has(6);
  @$pb.TagNumber(7)
  void clearBreakEvenExit() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Money ensureBreakEvenExit() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get verdict => $_getSZ(7);
  @$pb.TagNumber(8)
  set verdict($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVerdict() => $_has(7);
  @$pb.TagNumber(8)
  void clearVerdict() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get tone => $_getSZ(8);
  @$pb.TagNumber(9)
  set tone($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTone() => $_has(8);
  @$pb.TagNumber(9)
  void clearTone() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get sentence => $_getSZ(9);
  @$pb.TagNumber(10)
  set sentence($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSentence() => $_has(9);
  @$pb.TagNumber(10)
  void clearSentence() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Money get netToman => $_getN(10);
  @$pb.TagNumber(11)
  set netToman($0.Money value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasNetToman() => $_has(10);
  @$pb.TagNumber(11)
  void clearNetToman() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Money ensureNetToman() => $_ensure(10);
}

/// PnlService: what-if on a recorded run, and a single-trade calculator. Both use
/// the simulator math; the UI never computes P&L.
class PnlServiceApi {
  final $pb.RpcClient _client;

  PnlServiceApi(this._client);

  $async.Future<RecalculateResponse> recalculate($pb.ClientContext? ctx, RecalculateRequest request) =>
      _client.invoke<RecalculateResponse>(ctx, 'PnlService', 'Recalculate', request, RecalculateResponse());
  $async.Future<CalculateTradeResponse> calculateTrade($pb.ClientContext? ctx, CalculateTradeRequest request) =>
      _client.invoke<CalculateTradeResponse>(ctx, 'PnlService', 'CalculateTrade', request, CalculateTradeResponse());
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
