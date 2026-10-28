// This is a generated file - do not edit.
//
// Generated from lab/v1/learning.proto.

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

class LearningGate extends $pb.GeneratedMessage {
  factory LearningGate({
    $0.Decimal? maxDrawdown,
    $core.int? minForwardTrades,
    $core.int? forwardDays,
    $0.Decimal? minImprovement,
    $0.Decimal? maxDdDegradation,
    $core.int? minWalkWins,
  }) {
    final result = LearningGate._();
    if (maxDrawdown != null) result.maxDrawdown = maxDrawdown;
    if (minForwardTrades != null) result.minForwardTrades = minForwardTrades;
    if (forwardDays != null) result.forwardDays = forwardDays;
    if (minImprovement != null) result.minImprovement = minImprovement;
    if (maxDdDegradation != null) result.maxDdDegradation = maxDdDegradation;
    if (minWalkWins != null) result.minWalkWins = minWalkWins;
    return result;
  }

  LearningGate._();

  factory LearningGate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LearningGate()..mergeFromBuffer(data, registry);
  factory LearningGate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LearningGate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LearningGate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: LearningGate.$_createMessage)
    ..aOM<$0.Decimal>(1, _omitFieldNames ? '' : 'maxDrawdown',
        subBuilder: $0.Decimal.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'minForwardTrades')
    ..aI(3, _omitFieldNames ? '' : 'forwardDays')
    ..aOM<$0.Decimal>(4, _omitFieldNames ? '' : 'minImprovement',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(5, _omitFieldNames ? '' : 'maxDdDegradation',
        subBuilder: $0.Decimal.$_createMessage)
    ..aI(6, _omitFieldNames ? '' : 'minWalkWins')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LearningGate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LearningGate copyWith(void Function(LearningGate) updates) =>
      super.copyWith((message) => updates(message as LearningGate))
          as LearningGate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LearningGate() / LearningGate.new instead')
  static LearningGate create() => LearningGate._();
  static $pb.GeneratedMessage $_createMessage() => LearningGate._();
  @$core.override
  LearningGate createEmptyInstance() => LearningGate._();
  @$core.pragma('dart2js:noInline')
  static LearningGate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LearningGate>(
          LearningGate.$_createMessage);
  static LearningGate? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Decimal get maxDrawdown => $_getN(0);
  @$pb.TagNumber(1)
  set maxDrawdown($0.Decimal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxDrawdown() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxDrawdown() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Decimal ensureMaxDrawdown() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get minForwardTrades => $_getIZ(1);
  @$pb.TagNumber(2)
  set minForwardTrades($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinForwardTrades() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinForwardTrades() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get forwardDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set forwardDays($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasForwardDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearForwardDays() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Decimal get minImprovement => $_getN(3);
  @$pb.TagNumber(4)
  set minImprovement($0.Decimal value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMinImprovement() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinImprovement() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Decimal ensureMinImprovement() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Decimal get maxDdDegradation => $_getN(4);
  @$pb.TagNumber(5)
  set maxDdDegradation($0.Decimal value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxDdDegradation() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxDdDegradation() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Decimal ensureMaxDdDegradation() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get minWalkWins => $_getIZ(5);
  @$pb.TagNumber(6)
  set minWalkWins($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinWalkWins() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinWalkWins() => $_clearField(6);
}

class LearningConfig extends $pb.GeneratedMessage {
  factory LearningConfig({
    $core.String? algorithmId,
    $core.Iterable<$core.String>? symbols,
    $core.String? timeframe,
    $core.int? lookbackDays,
    $core.bool? enabled,
    $core.int? hourUtc,
    $core.int? minFreshBars,
    $core.int? folds,
    $core.int? maxCandidates,
    $core.int? cpuMinutes,
    $fixnum.Int64? maxBars,
    $fixnum.Int64? seed,
    $0.Money? capital,
    $0.Decimal? fee,
    $0.Decimal? slippage,
    LearningGate? gate,
  }) {
    final result = LearningConfig._();
    if (algorithmId != null) result.algorithmId = algorithmId;
    if (symbols != null) result.symbols.addAll(symbols);
    if (timeframe != null) result.timeframe = timeframe;
    if (lookbackDays != null) result.lookbackDays = lookbackDays;
    if (enabled != null) result.enabled = enabled;
    if (hourUtc != null) result.hourUtc = hourUtc;
    if (minFreshBars != null) result.minFreshBars = minFreshBars;
    if (folds != null) result.folds = folds;
    if (maxCandidates != null) result.maxCandidates = maxCandidates;
    if (cpuMinutes != null) result.cpuMinutes = cpuMinutes;
    if (maxBars != null) result.maxBars = maxBars;
    if (seed != null) result.seed = seed;
    if (capital != null) result.capital = capital;
    if (fee != null) result.fee = fee;
    if (slippage != null) result.slippage = slippage;
    if (gate != null) result.gate = gate;
    return result;
  }

  LearningConfig._();

  factory LearningConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LearningConfig()..mergeFromBuffer(data, registry);
  factory LearningConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LearningConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LearningConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: LearningConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'algorithmId')
    ..pPS(2, _omitFieldNames ? '' : 'symbols')
    ..aOS(3, _omitFieldNames ? '' : 'timeframe')
    ..aI(4, _omitFieldNames ? '' : 'lookbackDays')
    ..aOB(5, _omitFieldNames ? '' : 'enabled')
    ..aI(6, _omitFieldNames ? '' : 'hourUtc')
    ..aI(7, _omitFieldNames ? '' : 'minFreshBars')
    ..aI(8, _omitFieldNames ? '' : 'folds')
    ..aI(9, _omitFieldNames ? '' : 'maxCandidates')
    ..aI(10, _omitFieldNames ? '' : 'cpuMinutes')
    ..aInt64(11, _omitFieldNames ? '' : 'maxBars')
    ..a<$fixnum.Int64>(12, _omitFieldNames ? '' : 'seed', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.Money>(13, _omitFieldNames ? '' : 'capital',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(14, _omitFieldNames ? '' : 'fee',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(15, _omitFieldNames ? '' : 'slippage',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<LearningGate>(16, _omitFieldNames ? '' : 'gate',
        subBuilder: LearningGate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LearningConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LearningConfig copyWith(void Function(LearningConfig) updates) =>
      super.copyWith((message) => updates(message as LearningConfig))
          as LearningConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LearningConfig() / LearningConfig.new instead')
  static LearningConfig create() => LearningConfig._();
  static $pb.GeneratedMessage $_createMessage() => LearningConfig._();
  @$core.override
  LearningConfig createEmptyInstance() => LearningConfig._();
  @$core.pragma('dart2js:noInline')
  static LearningConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LearningConfig>(
          LearningConfig.$_createMessage);
  static LearningConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get algorithmId => $_getSZ(0);
  @$pb.TagNumber(1)
  set algorithmId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlgorithmId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlgorithmId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get symbols => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get timeframe => $_getSZ(2);
  @$pb.TagNumber(3)
  set timeframe($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeframe() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeframe() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get lookbackDays => $_getIZ(3);
  @$pb.TagNumber(4)
  set lookbackDays($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLookbackDays() => $_has(3);
  @$pb.TagNumber(4)
  void clearLookbackDays() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get enabled => $_getBF(4);
  @$pb.TagNumber(5)
  set enabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnabled() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get hourUtc => $_getIZ(5);
  @$pb.TagNumber(6)
  set hourUtc($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHourUtc() => $_has(5);
  @$pb.TagNumber(6)
  void clearHourUtc() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get minFreshBars => $_getIZ(6);
  @$pb.TagNumber(7)
  set minFreshBars($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMinFreshBars() => $_has(6);
  @$pb.TagNumber(7)
  void clearMinFreshBars() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get folds => $_getIZ(7);
  @$pb.TagNumber(8)
  set folds($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFolds() => $_has(7);
  @$pb.TagNumber(8)
  void clearFolds() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get maxCandidates => $_getIZ(8);
  @$pb.TagNumber(9)
  set maxCandidates($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMaxCandidates() => $_has(8);
  @$pb.TagNumber(9)
  void clearMaxCandidates() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get cpuMinutes => $_getIZ(9);
  @$pb.TagNumber(10)
  set cpuMinutes($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCpuMinutes() => $_has(9);
  @$pb.TagNumber(10)
  void clearCpuMinutes() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get maxBars => $_getI64(10);
  @$pb.TagNumber(11)
  set maxBars($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMaxBars() => $_has(10);
  @$pb.TagNumber(11)
  void clearMaxBars() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get seed => $_getI64(11);
  @$pb.TagNumber(12)
  set seed($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSeed() => $_has(11);
  @$pb.TagNumber(12)
  void clearSeed() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Money get capital => $_getN(12);
  @$pb.TagNumber(13)
  set capital($0.Money value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCapital() => $_has(12);
  @$pb.TagNumber(13)
  void clearCapital() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Money ensureCapital() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Decimal get fee => $_getN(13);
  @$pb.TagNumber(14)
  set fee($0.Decimal value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasFee() => $_has(13);
  @$pb.TagNumber(14)
  void clearFee() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Decimal ensureFee() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Decimal get slippage => $_getN(14);
  @$pb.TagNumber(15)
  set slippage($0.Decimal value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSlippage() => $_has(14);
  @$pb.TagNumber(15)
  void clearSlippage() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Decimal ensureSlippage() => $_ensure(14);

  @$pb.TagNumber(16)
  LearningGate get gate => $_getN(15);
  @$pb.TagNumber(16)
  set gate(LearningGate value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGate() => $_has(15);
  @$pb.TagNumber(16)
  void clearGate() => $_clearField(16);
  @$pb.TagNumber(16)
  LearningGate ensureGate() => $_ensure(15);
}

class CycleStep extends $pb.GeneratedMessage {
  factory CycleStep({
    $core.String? key,
    $core.String? status,
    $core.String? meta,
  }) {
    final result = CycleStep._();
    if (key != null) result.key = key;
    if (status != null) result.status = status;
    if (meta != null) result.meta = meta;
    return result;
  }

  CycleStep._();

  factory CycleStep.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CycleStep()..mergeFromBuffer(data, registry);
  factory CycleStep.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CycleStep()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CycleStep',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CycleStep.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'meta')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CycleStep clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CycleStep copyWith(void Function(CycleStep) updates) =>
      super.copyWith((message) => updates(message as CycleStep)) as CycleStep;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CycleStep() / CycleStep.new instead')
  static CycleStep create() => CycleStep._();
  static $pb.GeneratedMessage $_createMessage() => CycleStep._();
  @$core.override
  CycleStep createEmptyInstance() => CycleStep._();
  @$core.pragma('dart2js:noInline')
  static CycleStep getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CycleStep>(CycleStep.$_createMessage);
  static CycleStep? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get meta => $_getSZ(2);
  @$pb.TagNumber(3)
  set meta($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMeta() => $_has(2);
  @$pb.TagNumber(3)
  void clearMeta() => $_clearField(3);
}

class GateItem extends $pb.GeneratedMessage {
  factory GateItem({
    $core.String? key,
    $core.String? status,
    $core.String? text,
  }) {
    final result = GateItem._();
    if (key != null) result.key = key;
    if (status != null) result.status = status;
    if (text != null) result.text = text;
    return result;
  }

  GateItem._();

  factory GateItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GateItem()..mergeFromBuffer(data, registry);
  factory GateItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GateItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GateItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GateItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GateItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GateItem copyWith(void Function(GateItem) updates) =>
      super.copyWith((message) => updates(message as GateItem)) as GateItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GateItem() / GateItem.new instead')
  static GateItem create() => GateItem._();
  static $pb.GeneratedMessage $_createMessage() => GateItem._();
  @$core.override
  GateItem createEmptyInstance() => GateItem._();
  @$core.pragma('dart2js:noInline')
  static GateItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GateItem>(GateItem.$_createMessage);
  static GateItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);
}

class Contender extends $pb.GeneratedMessage {
  factory Contender({
    $core.String? versionId,
    $core.String? modelId,
    $core.bool? active,
    $core.String? change,
    $core.int? seq,
    $core.Iterable<$0.Metric>? walk,
    $core.Iterable<$0.Metric>? forward,
  }) {
    final result = Contender._();
    if (versionId != null) result.versionId = versionId;
    if (modelId != null) result.modelId = modelId;
    if (active != null) result.active = active;
    if (change != null) result.change = change;
    if (seq != null) result.seq = seq;
    if (walk != null) result.walk.addAll(walk);
    if (forward != null) result.forward.addAll(forward);
    return result;
  }

  Contender._();

  factory Contender.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Contender()..mergeFromBuffer(data, registry);
  factory Contender.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Contender()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Contender',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Contender.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'versionId')
    ..aOS(2, _omitFieldNames ? '' : 'modelId')
    ..aOB(3, _omitFieldNames ? '' : 'active')
    ..aOS(4, _omitFieldNames ? '' : 'change')
    ..aI(5, _omitFieldNames ? '' : 'seq')
    ..pPM<$0.Metric>(6, _omitFieldNames ? '' : 'walk',
        subBuilder: $0.Metric.$_createMessage)
    ..pPM<$0.Metric>(7, _omitFieldNames ? '' : 'forward',
        subBuilder: $0.Metric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Contender clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Contender copyWith(void Function(Contender) updates) =>
      super.copyWith((message) => updates(message as Contender)) as Contender;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Contender() / Contender.new instead')
  static Contender create() => Contender._();
  static $pb.GeneratedMessage $_createMessage() => Contender._();
  @$core.override
  Contender createEmptyInstance() => Contender._();
  @$core.pragma('dart2js:noInline')
  static Contender getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Contender>(Contender.$_createMessage);
  static Contender? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get versionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set versionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get modelId => $_getSZ(1);
  @$pb.TagNumber(2)
  set modelId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModelId() => $_has(1);
  @$pb.TagNumber(2)
  void clearModelId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get active => $_getBF(2);
  @$pb.TagNumber(3)
  set active($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActive() => $_has(2);
  @$pb.TagNumber(3)
  void clearActive() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get change => $_getSZ(3);
  @$pb.TagNumber(4)
  set change($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChange() => $_has(3);
  @$pb.TagNumber(4)
  void clearChange() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get seq => $_getIZ(4);
  @$pb.TagNumber(5)
  set seq($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSeq() => $_has(4);
  @$pb.TagNumber(5)
  void clearSeq() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$0.Metric> get walk => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$0.Metric> get forward => $_getList(6);
}

class CycleUsage extends $pb.GeneratedMessage {
  factory CycleUsage({
    $fixnum.Int64? cpuSeconds,
    $fixnum.Int64? cpuBudgetSeconds,
    $core.int? candidates,
    $core.int? maxCandidates,
    $fixnum.Int64? bars,
    $fixnum.Int64? maxBars,
  }) {
    final result = CycleUsage._();
    if (cpuSeconds != null) result.cpuSeconds = cpuSeconds;
    if (cpuBudgetSeconds != null) result.cpuBudgetSeconds = cpuBudgetSeconds;
    if (candidates != null) result.candidates = candidates;
    if (maxCandidates != null) result.maxCandidates = maxCandidates;
    if (bars != null) result.bars = bars;
    if (maxBars != null) result.maxBars = maxBars;
    return result;
  }

  CycleUsage._();

  factory CycleUsage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CycleUsage()..mergeFromBuffer(data, registry);
  factory CycleUsage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CycleUsage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CycleUsage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CycleUsage.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'cpuSeconds')
    ..aInt64(2, _omitFieldNames ? '' : 'cpuBudgetSeconds')
    ..aI(3, _omitFieldNames ? '' : 'candidates')
    ..aI(4, _omitFieldNames ? '' : 'maxCandidates')
    ..aInt64(5, _omitFieldNames ? '' : 'bars')
    ..aInt64(6, _omitFieldNames ? '' : 'maxBars')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CycleUsage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CycleUsage copyWith(void Function(CycleUsage) updates) =>
      super.copyWith((message) => updates(message as CycleUsage)) as CycleUsage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CycleUsage() / CycleUsage.new instead')
  static CycleUsage create() => CycleUsage._();
  static $pb.GeneratedMessage $_createMessage() => CycleUsage._();
  @$core.override
  CycleUsage createEmptyInstance() => CycleUsage._();
  @$core.pragma('dart2js:noInline')
  static CycleUsage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CycleUsage>(CycleUsage.$_createMessage);
  static CycleUsage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cpuSeconds => $_getI64(0);
  @$pb.TagNumber(1)
  set cpuSeconds($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCpuSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearCpuSeconds() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cpuBudgetSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set cpuBudgetSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCpuBudgetSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearCpuBudgetSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get candidates => $_getIZ(2);
  @$pb.TagNumber(3)
  set candidates($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCandidates() => $_has(2);
  @$pb.TagNumber(3)
  void clearCandidates() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxCandidates => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxCandidates($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxCandidates() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxCandidates() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get bars => $_getI64(4);
  @$pb.TagNumber(5)
  set bars($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBars() => $_has(4);
  @$pb.TagNumber(5)
  void clearBars() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get maxBars => $_getI64(5);
  @$pb.TagNumber(6)
  set maxBars($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxBars() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxBars() => $_clearField(6);
}

class Cycle extends $pb.GeneratedMessage {
  factory Cycle({
    $fixnum.Int64? id,
    $core.String? algorithmId,
    $core.String? trigger,
    $core.String? state,
    $core.String? outcome,
    $core.String? reason,
    $fixnum.Int64? startedUnixMs,
    $fixnum.Int64? finishedUnixMs,
    $fixnum.Int64? freezeUnixMs,
    $core.int? forwardDays,
    $core.int? forwardDaysTarget,
    $core.Iterable<CycleStep>? steps,
    $core.Iterable<GateItem>? gate,
    Contender? champion,
    Contender? challenger,
    CycleUsage? usage,
    $core.int? candidates,
    $core.int? eligible,
    $core.int? walkWins,
    $core.int? walkFolds,
    $core.bool? canApprove,
  }) {
    final result = Cycle._();
    if (id != null) result.id = id;
    if (algorithmId != null) result.algorithmId = algorithmId;
    if (trigger != null) result.trigger = trigger;
    if (state != null) result.state = state;
    if (outcome != null) result.outcome = outcome;
    if (reason != null) result.reason = reason;
    if (startedUnixMs != null) result.startedUnixMs = startedUnixMs;
    if (finishedUnixMs != null) result.finishedUnixMs = finishedUnixMs;
    if (freezeUnixMs != null) result.freezeUnixMs = freezeUnixMs;
    if (forwardDays != null) result.forwardDays = forwardDays;
    if (forwardDaysTarget != null) result.forwardDaysTarget = forwardDaysTarget;
    if (steps != null) result.steps.addAll(steps);
    if (gate != null) result.gate.addAll(gate);
    if (champion != null) result.champion = champion;
    if (challenger != null) result.challenger = challenger;
    if (usage != null) result.usage = usage;
    if (candidates != null) result.candidates = candidates;
    if (eligible != null) result.eligible = eligible;
    if (walkWins != null) result.walkWins = walkWins;
    if (walkFolds != null) result.walkFolds = walkFolds;
    if (canApprove != null) result.canApprove = canApprove;
    return result;
  }

  Cycle._();

  factory Cycle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Cycle()..mergeFromBuffer(data, registry);
  factory Cycle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Cycle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Cycle',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Cycle.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'algorithmId')
    ..aOS(3, _omitFieldNames ? '' : 'trigger')
    ..aOS(4, _omitFieldNames ? '' : 'state')
    ..aOS(5, _omitFieldNames ? '' : 'outcome')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aInt64(7, _omitFieldNames ? '' : 'startedUnixMs')
    ..aInt64(8, _omitFieldNames ? '' : 'finishedUnixMs')
    ..aInt64(9, _omitFieldNames ? '' : 'freezeUnixMs')
    ..aI(10, _omitFieldNames ? '' : 'forwardDays')
    ..aI(11, _omitFieldNames ? '' : 'forwardDaysTarget')
    ..pPM<CycleStep>(12, _omitFieldNames ? '' : 'steps',
        subBuilder: CycleStep.$_createMessage)
    ..pPM<GateItem>(13, _omitFieldNames ? '' : 'gate',
        subBuilder: GateItem.$_createMessage)
    ..aOM<Contender>(14, _omitFieldNames ? '' : 'champion',
        subBuilder: Contender.$_createMessage)
    ..aOM<Contender>(15, _omitFieldNames ? '' : 'challenger',
        subBuilder: Contender.$_createMessage)
    ..aOM<CycleUsage>(16, _omitFieldNames ? '' : 'usage',
        subBuilder: CycleUsage.$_createMessage)
    ..aI(17, _omitFieldNames ? '' : 'candidates')
    ..aI(18, _omitFieldNames ? '' : 'eligible')
    ..aI(19, _omitFieldNames ? '' : 'walkWins')
    ..aI(20, _omitFieldNames ? '' : 'walkFolds')
    ..aOB(21, _omitFieldNames ? '' : 'canApprove')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cycle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cycle copyWith(void Function(Cycle) updates) =>
      super.copyWith((message) => updates(message as Cycle)) as Cycle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Cycle() / Cycle.new instead')
  static Cycle create() => Cycle._();
  static $pb.GeneratedMessage $_createMessage() => Cycle._();
  @$core.override
  Cycle createEmptyInstance() => Cycle._();
  @$core.pragma('dart2js:noInline')
  static Cycle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Cycle>(Cycle.$_createMessage);
  static Cycle? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get algorithmId => $_getSZ(1);
  @$pb.TagNumber(2)
  set algorithmId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlgorithmId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlgorithmId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trigger => $_getSZ(2);
  @$pb.TagNumber(3)
  set trigger($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrigger() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrigger() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get state => $_getSZ(3);
  @$pb.TagNumber(4)
  set state($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get outcome => $_getSZ(4);
  @$pb.TagNumber(5)
  set outcome($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOutcome() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutcome() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get startedUnixMs => $_getI64(6);
  @$pb.TagNumber(7)
  set startedUnixMs($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStartedUnixMs() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartedUnixMs() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get finishedUnixMs => $_getI64(7);
  @$pb.TagNumber(8)
  set finishedUnixMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFinishedUnixMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearFinishedUnixMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get freezeUnixMs => $_getI64(8);
  @$pb.TagNumber(9)
  set freezeUnixMs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFreezeUnixMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearFreezeUnixMs() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get forwardDays => $_getIZ(9);
  @$pb.TagNumber(10)
  set forwardDays($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasForwardDays() => $_has(9);
  @$pb.TagNumber(10)
  void clearForwardDays() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get forwardDaysTarget => $_getIZ(10);
  @$pb.TagNumber(11)
  set forwardDaysTarget($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasForwardDaysTarget() => $_has(10);
  @$pb.TagNumber(11)
  void clearForwardDaysTarget() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<CycleStep> get steps => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbList<GateItem> get gate => $_getList(12);

  @$pb.TagNumber(14)
  Contender get champion => $_getN(13);
  @$pb.TagNumber(14)
  set champion(Contender value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasChampion() => $_has(13);
  @$pb.TagNumber(14)
  void clearChampion() => $_clearField(14);
  @$pb.TagNumber(14)
  Contender ensureChampion() => $_ensure(13);

  @$pb.TagNumber(15)
  Contender get challenger => $_getN(14);
  @$pb.TagNumber(15)
  set challenger(Contender value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasChallenger() => $_has(14);
  @$pb.TagNumber(15)
  void clearChallenger() => $_clearField(15);
  @$pb.TagNumber(15)
  Contender ensureChallenger() => $_ensure(14);

  @$pb.TagNumber(16)
  CycleUsage get usage => $_getN(15);
  @$pb.TagNumber(16)
  set usage(CycleUsage value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasUsage() => $_has(15);
  @$pb.TagNumber(16)
  void clearUsage() => $_clearField(16);
  @$pb.TagNumber(16)
  CycleUsage ensureUsage() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.int get candidates => $_getIZ(16);
  @$pb.TagNumber(17)
  set candidates($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCandidates() => $_has(16);
  @$pb.TagNumber(17)
  void clearCandidates() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get eligible => $_getIZ(17);
  @$pb.TagNumber(18)
  set eligible($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasEligible() => $_has(17);
  @$pb.TagNumber(18)
  void clearEligible() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.int get walkWins => $_getIZ(18);
  @$pb.TagNumber(19)
  set walkWins($core.int value) => $_setSignedInt32(18, value);
  @$pb.TagNumber(19)
  $core.bool hasWalkWins() => $_has(18);
  @$pb.TagNumber(19)
  void clearWalkWins() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.int get walkFolds => $_getIZ(19);
  @$pb.TagNumber(20)
  set walkFolds($core.int value) => $_setSignedInt32(19, value);
  @$pb.TagNumber(20)
  $core.bool hasWalkFolds() => $_has(19);
  @$pb.TagNumber(20)
  void clearWalkFolds() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.bool get canApprove => $_getBF(20);
  @$pb.TagNumber(21)
  set canApprove($core.bool value) => $_setBool(20, value);
  @$pb.TagNumber(21)
  $core.bool hasCanApprove() => $_has(20);
  @$pb.TagNumber(21)
  void clearCanApprove() => $_clearField(21);
}

class ActiveModel extends $pb.GeneratedMessage {
  factory ActiveModel({
    $core.String? algorithmId,
    $core.String? versionId,
    $core.String? modelId,
    $fixnum.Int64? modelAsOfUnixMs,
  }) {
    final result = ActiveModel._();
    if (algorithmId != null) result.algorithmId = algorithmId;
    if (versionId != null) result.versionId = versionId;
    if (modelId != null) result.modelId = modelId;
    if (modelAsOfUnixMs != null) result.modelAsOfUnixMs = modelAsOfUnixMs;
    return result;
  }

  ActiveModel._();

  factory ActiveModel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActiveModel()..mergeFromBuffer(data, registry);
  factory ActiveModel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActiveModel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActiveModel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ActiveModel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'algorithmId')
    ..aOS(2, _omitFieldNames ? '' : 'versionId')
    ..aOS(3, _omitFieldNames ? '' : 'modelId')
    ..aInt64(4, _omitFieldNames ? '' : 'modelAsOfUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActiveModel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActiveModel copyWith(void Function(ActiveModel) updates) =>
      super.copyWith((message) => updates(message as ActiveModel))
          as ActiveModel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActiveModel() / ActiveModel.new instead')
  static ActiveModel create() => ActiveModel._();
  static $pb.GeneratedMessage $_createMessage() => ActiveModel._();
  @$core.override
  ActiveModel createEmptyInstance() => ActiveModel._();
  @$core.pragma('dart2js:noInline')
  static ActiveModel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActiveModel>(
          ActiveModel.$_createMessage);
  static ActiveModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get algorithmId => $_getSZ(0);
  @$pb.TagNumber(1)
  set algorithmId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlgorithmId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlgorithmId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get versionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set versionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get modelId => $_getSZ(2);
  @$pb.TagNumber(3)
  set modelId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasModelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearModelId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get modelAsOfUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set modelAsOfUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModelAsOfUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearModelAsOfUnixMs() => $_clearField(4);
}

class GetLearningRequest extends $pb.GeneratedMessage {
  factory GetLearningRequest() => GetLearningRequest._();

  GetLearningRequest._();

  factory GetLearningRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLearningRequest()..mergeFromBuffer(data, registry);
  factory GetLearningRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLearningRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLearningRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetLearningRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLearningRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLearningRequest copyWith(void Function(GetLearningRequest) updates) =>
      super.copyWith((message) => updates(message as GetLearningRequest))
          as GetLearningRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetLearningRequest() / GetLearningRequest.new instead')
  static GetLearningRequest create() => GetLearningRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetLearningRequest._();
  @$core.override
  GetLearningRequest createEmptyInstance() => GetLearningRequest._();
  @$core.pragma('dart2js:noInline')
  static GetLearningRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLearningRequest>(
          GetLearningRequest.$_createMessage);
  static GetLearningRequest? _defaultInstance;
}

class GetLearningResponse extends $pb.GeneratedMessage {
  factory GetLearningResponse({
    LearningConfig? config,
    Cycle? current,
    ActiveModel? active,
    $core.bool? canRollback,
    $core.Iterable<$core.String>? learningAlgorithms,
  }) {
    final result = GetLearningResponse._();
    if (config != null) result.config = config;
    if (current != null) result.current = current;
    if (active != null) result.active = active;
    if (canRollback != null) result.canRollback = canRollback;
    if (learningAlgorithms != null)
      result.learningAlgorithms.addAll(learningAlgorithms);
    return result;
  }

  GetLearningResponse._();

  factory GetLearningResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLearningResponse()..mergeFromBuffer(data, registry);
  factory GetLearningResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLearningResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLearningResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetLearningResponse.$_createMessage)
    ..aOM<LearningConfig>(1, _omitFieldNames ? '' : 'config',
        subBuilder: LearningConfig.$_createMessage)
    ..aOM<Cycle>(2, _omitFieldNames ? '' : 'current',
        subBuilder: Cycle.$_createMessage)
    ..aOM<ActiveModel>(3, _omitFieldNames ? '' : 'active',
        subBuilder: ActiveModel.$_createMessage)
    ..aOB(4, _omitFieldNames ? '' : 'canRollback')
    ..pPS(5, _omitFieldNames ? '' : 'learningAlgorithms')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLearningResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLearningResponse copyWith(void Function(GetLearningResponse) updates) =>
      super.copyWith((message) => updates(message as GetLearningResponse))
          as GetLearningResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetLearningResponse() / GetLearningResponse.new instead')
  static GetLearningResponse create() => GetLearningResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetLearningResponse._();
  @$core.override
  GetLearningResponse createEmptyInstance() => GetLearningResponse._();
  @$core.pragma('dart2js:noInline')
  static GetLearningResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLearningResponse>(
          GetLearningResponse.$_createMessage);
  static GetLearningResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LearningConfig get config => $_getN(0);
  @$pb.TagNumber(1)
  set config(LearningConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfig() => $_clearField(1);
  @$pb.TagNumber(1)
  LearningConfig ensureConfig() => $_ensure(0);

  @$pb.TagNumber(2)
  Cycle get current => $_getN(1);
  @$pb.TagNumber(2)
  set current(Cycle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrent() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrent() => $_clearField(2);
  @$pb.TagNumber(2)
  Cycle ensureCurrent() => $_ensure(1);

  @$pb.TagNumber(3)
  ActiveModel get active => $_getN(2);
  @$pb.TagNumber(3)
  set active(ActiveModel value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasActive() => $_has(2);
  @$pb.TagNumber(3)
  void clearActive() => $_clearField(3);
  @$pb.TagNumber(3)
  ActiveModel ensureActive() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get canRollback => $_getBF(3);
  @$pb.TagNumber(4)
  set canRollback($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanRollback() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanRollback() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get learningAlgorithms => $_getList(4);
}

class SaveConfigRequest extends $pb.GeneratedMessage {
  factory SaveConfigRequest({
    LearningConfig? config,
  }) {
    final result = SaveConfigRequest._();
    if (config != null) result.config = config;
    return result;
  }

  SaveConfigRequest._();

  factory SaveConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveConfigRequest()..mergeFromBuffer(data, registry);
  factory SaveConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveConfigRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveConfigRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SaveConfigRequest.$_createMessage)
    ..aOM<LearningConfig>(1, _omitFieldNames ? '' : 'config',
        subBuilder: LearningConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveConfigRequest copyWith(void Function(SaveConfigRequest) updates) =>
      super.copyWith((message) => updates(message as SaveConfigRequest))
          as SaveConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SaveConfigRequest() / SaveConfigRequest.new instead')
  static SaveConfigRequest create() => SaveConfigRequest._();
  static $pb.GeneratedMessage $_createMessage() => SaveConfigRequest._();
  @$core.override
  SaveConfigRequest createEmptyInstance() => SaveConfigRequest._();
  @$core.pragma('dart2js:noInline')
  static SaveConfigRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveConfigRequest>(
          SaveConfigRequest.$_createMessage);
  static SaveConfigRequest? _defaultInstance;

  @$pb.TagNumber(1)
  LearningConfig get config => $_getN(0);
  @$pb.TagNumber(1)
  set config(LearningConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfig() => $_clearField(1);
  @$pb.TagNumber(1)
  LearningConfig ensureConfig() => $_ensure(0);
}

class SaveConfigResponse extends $pb.GeneratedMessage {
  factory SaveConfigResponse() => SaveConfigResponse._();

  SaveConfigResponse._();

  factory SaveConfigResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveConfigResponse()..mergeFromBuffer(data, registry);
  factory SaveConfigResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveConfigResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveConfigResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SaveConfigResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveConfigResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveConfigResponse copyWith(void Function(SaveConfigResponse) updates) =>
      super.copyWith((message) => updates(message as SaveConfigResponse))
          as SaveConfigResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SaveConfigResponse() / SaveConfigResponse.new instead')
  static SaveConfigResponse create() => SaveConfigResponse._();
  static $pb.GeneratedMessage $_createMessage() => SaveConfigResponse._();
  @$core.override
  SaveConfigResponse createEmptyInstance() => SaveConfigResponse._();
  @$core.pragma('dart2js:noInline')
  static SaveConfigResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveConfigResponse>(
          SaveConfigResponse.$_createMessage);
  static SaveConfigResponse? _defaultInstance;
}

class StartCycleRequest extends $pb.GeneratedMessage {
  factory StartCycleRequest() => StartCycleRequest._();

  StartCycleRequest._();

  factory StartCycleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartCycleRequest()..mergeFromBuffer(data, registry);
  factory StartCycleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartCycleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartCycleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StartCycleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCycleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCycleRequest copyWith(void Function(StartCycleRequest) updates) =>
      super.copyWith((message) => updates(message as StartCycleRequest))
          as StartCycleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StartCycleRequest() / StartCycleRequest.new instead')
  static StartCycleRequest create() => StartCycleRequest._();
  static $pb.GeneratedMessage $_createMessage() => StartCycleRequest._();
  @$core.override
  StartCycleRequest createEmptyInstance() => StartCycleRequest._();
  @$core.pragma('dart2js:noInline')
  static StartCycleRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartCycleRequest>(
          StartCycleRequest.$_createMessage);
  static StartCycleRequest? _defaultInstance;
}

class StartCycleResponse extends $pb.GeneratedMessage {
  factory StartCycleResponse({
    $fixnum.Int64? cycleId,
  }) {
    final result = StartCycleResponse._();
    if (cycleId != null) result.cycleId = cycleId;
    return result;
  }

  StartCycleResponse._();

  factory StartCycleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartCycleResponse()..mergeFromBuffer(data, registry);
  factory StartCycleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartCycleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartCycleResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: StartCycleResponse.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'cycleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCycleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCycleResponse copyWith(void Function(StartCycleResponse) updates) =>
      super.copyWith((message) => updates(message as StartCycleResponse))
          as StartCycleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StartCycleResponse() / StartCycleResponse.new instead')
  static StartCycleResponse create() => StartCycleResponse._();
  static $pb.GeneratedMessage $_createMessage() => StartCycleResponse._();
  @$core.override
  StartCycleResponse createEmptyInstance() => StartCycleResponse._();
  @$core.pragma('dart2js:noInline')
  static StartCycleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartCycleResponse>(
          StartCycleResponse.$_createMessage);
  static StartCycleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cycleId => $_getI64(0);
  @$pb.TagNumber(1)
  set cycleId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);
}

class ListCyclesRequest extends $pb.GeneratedMessage {
  factory ListCyclesRequest({
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = ListCyclesRequest._();
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListCyclesRequest._();

  factory ListCyclesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCyclesRequest()..mergeFromBuffer(data, registry);
  factory ListCyclesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCyclesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCyclesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListCyclesRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aI(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCyclesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCyclesRequest copyWith(void Function(ListCyclesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCyclesRequest))
          as ListCyclesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListCyclesRequest() / ListCyclesRequest.new instead')
  static ListCyclesRequest create() => ListCyclesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListCyclesRequest._();
  @$core.override
  ListCyclesRequest createEmptyInstance() => ListCyclesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCyclesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCyclesRequest>(
          ListCyclesRequest.$_createMessage);
  static ListCyclesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get offset => $_getIZ(1);
  @$pb.TagNumber(2)
  set offset($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

class ListCyclesResponse extends $pb.GeneratedMessage {
  factory ListCyclesResponse({
    $core.Iterable<Cycle>? cycles,
    $fixnum.Int64? total,
  }) {
    final result = ListCyclesResponse._();
    if (cycles != null) result.cycles.addAll(cycles);
    if (total != null) result.total = total;
    return result;
  }

  ListCyclesResponse._();

  factory ListCyclesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCyclesResponse()..mergeFromBuffer(data, registry);
  factory ListCyclesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCyclesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCyclesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListCyclesResponse.$_createMessage)
    ..pPM<Cycle>(1, _omitFieldNames ? '' : 'cycles',
        subBuilder: Cycle.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCyclesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCyclesResponse copyWith(void Function(ListCyclesResponse) updates) =>
      super.copyWith((message) => updates(message as ListCyclesResponse))
          as ListCyclesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListCyclesResponse() / ListCyclesResponse.new instead')
  static ListCyclesResponse create() => ListCyclesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListCyclesResponse._();
  @$core.override
  ListCyclesResponse createEmptyInstance() => ListCyclesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListCyclesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCyclesResponse>(
          ListCyclesResponse.$_createMessage);
  static ListCyclesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Cycle> get cycles => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class CycleCandidate extends $pb.GeneratedMessage {
  factory CycleCandidate({
    $core.int? seq,
    $core.String? change,
    $core.String? status,
    $core.String? failure,
    $0.Metric? totalReturn,
    $0.Metric? maxDrawdown,
    $core.int? wins,
    $core.bool? eligible,
    $core.String? why,
  }) {
    final result = CycleCandidate._();
    if (seq != null) result.seq = seq;
    if (change != null) result.change = change;
    if (status != null) result.status = status;
    if (failure != null) result.failure = failure;
    if (totalReturn != null) result.totalReturn = totalReturn;
    if (maxDrawdown != null) result.maxDrawdown = maxDrawdown;
    if (wins != null) result.wins = wins;
    if (eligible != null) result.eligible = eligible;
    if (why != null) result.why = why;
    return result;
  }

  CycleCandidate._();

  factory CycleCandidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CycleCandidate()..mergeFromBuffer(data, registry);
  factory CycleCandidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CycleCandidate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CycleCandidate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CycleCandidate.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seq')
    ..aOS(2, _omitFieldNames ? '' : 'change')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aOS(4, _omitFieldNames ? '' : 'failure')
    ..aOM<$0.Metric>(5, _omitFieldNames ? '' : 'totalReturn',
        subBuilder: $0.Metric.$_createMessage)
    ..aOM<$0.Metric>(6, _omitFieldNames ? '' : 'maxDrawdown',
        subBuilder: $0.Metric.$_createMessage)
    ..aI(7, _omitFieldNames ? '' : 'wins')
    ..aOB(8, _omitFieldNames ? '' : 'eligible')
    ..aOS(9, _omitFieldNames ? '' : 'why')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CycleCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CycleCandidate copyWith(void Function(CycleCandidate) updates) =>
      super.copyWith((message) => updates(message as CycleCandidate))
          as CycleCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CycleCandidate() / CycleCandidate.new instead')
  static CycleCandidate create() => CycleCandidate._();
  static $pb.GeneratedMessage $_createMessage() => CycleCandidate._();
  @$core.override
  CycleCandidate createEmptyInstance() => CycleCandidate._();
  @$core.pragma('dart2js:noInline')
  static CycleCandidate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CycleCandidate>(
          CycleCandidate.$_createMessage);
  static CycleCandidate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get change => $_getSZ(1);
  @$pb.TagNumber(2)
  set change($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChange() => $_has(1);
  @$pb.TagNumber(2)
  void clearChange() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get failure => $_getSZ(3);
  @$pb.TagNumber(4)
  set failure($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFailure() => $_has(3);
  @$pb.TagNumber(4)
  void clearFailure() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Metric get totalReturn => $_getN(4);
  @$pb.TagNumber(5)
  set totalReturn($0.Metric value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalReturn() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalReturn() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Metric ensureTotalReturn() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Metric get maxDrawdown => $_getN(5);
  @$pb.TagNumber(6)
  set maxDrawdown($0.Metric value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxDrawdown() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxDrawdown() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Metric ensureMaxDrawdown() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get wins => $_getIZ(6);
  @$pb.TagNumber(7)
  set wins($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWins() => $_has(6);
  @$pb.TagNumber(7)
  void clearWins() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get eligible => $_getBF(7);
  @$pb.TagNumber(8)
  set eligible($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEligible() => $_has(7);
  @$pb.TagNumber(8)
  void clearEligible() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get why => $_getSZ(8);
  @$pb.TagNumber(9)
  set why($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWhy() => $_has(8);
  @$pb.TagNumber(9)
  void clearWhy() => $_clearField(9);
}

class ListCandidatesRequest extends $pb.GeneratedMessage {
  factory ListCandidatesRequest({
    $fixnum.Int64? cycleId,
  }) {
    final result = ListCandidatesRequest._();
    if (cycleId != null) result.cycleId = cycleId;
    return result;
  }

  ListCandidatesRequest._();

  factory ListCandidatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCandidatesRequest()..mergeFromBuffer(data, registry);
  factory ListCandidatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCandidatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCandidatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListCandidatesRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'cycleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCandidatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCandidatesRequest copyWith(
          void Function(ListCandidatesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCandidatesRequest))
          as ListCandidatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCandidatesRequest() / ListCandidatesRequest.new instead')
  static ListCandidatesRequest create() => ListCandidatesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListCandidatesRequest._();
  @$core.override
  ListCandidatesRequest createEmptyInstance() => ListCandidatesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCandidatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCandidatesRequest>(
          ListCandidatesRequest.$_createMessage);
  static ListCandidatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cycleId => $_getI64(0);
  @$pb.TagNumber(1)
  set cycleId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);
}

class ListCandidatesResponse extends $pb.GeneratedMessage {
  factory ListCandidatesResponse({
    $core.Iterable<CycleCandidate>? candidates,
  }) {
    final result = ListCandidatesResponse._();
    if (candidates != null) result.candidates.addAll(candidates);
    return result;
  }

  ListCandidatesResponse._();

  factory ListCandidatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCandidatesResponse()..mergeFromBuffer(data, registry);
  factory ListCandidatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCandidatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCandidatesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListCandidatesResponse.$_createMessage)
    ..pPM<CycleCandidate>(1, _omitFieldNames ? '' : 'candidates',
        subBuilder: CycleCandidate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCandidatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCandidatesResponse copyWith(
          void Function(ListCandidatesResponse) updates) =>
      super.copyWith((message) => updates(message as ListCandidatesResponse))
          as ListCandidatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCandidatesResponse() / ListCandidatesResponse.new instead')
  static ListCandidatesResponse create() => ListCandidatesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListCandidatesResponse._();
  @$core.override
  ListCandidatesResponse createEmptyInstance() => ListCandidatesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListCandidatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCandidatesResponse>(
          ListCandidatesResponse.$_createMessage);
  static ListCandidatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CycleCandidate> get candidates => $_getList(0);
}

class ModelInfo extends $pb.GeneratedMessage {
  factory ModelInfo({
    $core.String? id,
    $core.String? versionId,
    $core.String? status,
    $fixnum.Int64? asOfUnixMs,
    $fixnum.Int64? trainFromUnixMs,
    $fixnum.Int64? trainToUnixMs,
    $fixnum.Int64? seed,
    $core.String? recipeHash,
    $core.int? samples,
    $core.String? parent,
    $fixnum.Int64? cycleId,
    $core.double? trainError,
  }) {
    final result = ModelInfo._();
    if (id != null) result.id = id;
    if (versionId != null) result.versionId = versionId;
    if (status != null) result.status = status;
    if (asOfUnixMs != null) result.asOfUnixMs = asOfUnixMs;
    if (trainFromUnixMs != null) result.trainFromUnixMs = trainFromUnixMs;
    if (trainToUnixMs != null) result.trainToUnixMs = trainToUnixMs;
    if (seed != null) result.seed = seed;
    if (recipeHash != null) result.recipeHash = recipeHash;
    if (samples != null) result.samples = samples;
    if (parent != null) result.parent = parent;
    if (cycleId != null) result.cycleId = cycleId;
    if (trainError != null) result.trainError = trainError;
    return result;
  }

  ModelInfo._();

  factory ModelInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModelInfo()..mergeFromBuffer(data, registry);
  factory ModelInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModelInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModelInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ModelInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'versionId')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aInt64(4, _omitFieldNames ? '' : 'asOfUnixMs')
    ..aInt64(5, _omitFieldNames ? '' : 'trainFromUnixMs')
    ..aInt64(6, _omitFieldNames ? '' : 'trainToUnixMs')
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'seed', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(8, _omitFieldNames ? '' : 'recipeHash')
    ..aI(9, _omitFieldNames ? '' : 'samples')
    ..aOS(10, _omitFieldNames ? '' : 'parent')
    ..aInt64(11, _omitFieldNames ? '' : 'cycleId')
    ..aD(12, _omitFieldNames ? '' : 'trainError')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModelInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModelInfo copyWith(void Function(ModelInfo) updates) =>
      super.copyWith((message) => updates(message as ModelInfo)) as ModelInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModelInfo() / ModelInfo.new instead')
  static ModelInfo create() => ModelInfo._();
  static $pb.GeneratedMessage $_createMessage() => ModelInfo._();
  @$core.override
  ModelInfo createEmptyInstance() => ModelInfo._();
  @$core.pragma('dart2js:noInline')
  static ModelInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModelInfo>(ModelInfo.$_createMessage);
  static ModelInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get versionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set versionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get asOfUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set asOfUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAsOfUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearAsOfUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get trainFromUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set trainFromUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTrainFromUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrainFromUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get trainToUnixMs => $_getI64(5);
  @$pb.TagNumber(6)
  set trainToUnixMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTrainToUnixMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearTrainToUnixMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get seed => $_getI64(6);
  @$pb.TagNumber(7)
  set seed($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSeed() => $_has(6);
  @$pb.TagNumber(7)
  void clearSeed() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get recipeHash => $_getSZ(7);
  @$pb.TagNumber(8)
  set recipeHash($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRecipeHash() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecipeHash() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get samples => $_getIZ(8);
  @$pb.TagNumber(9)
  set samples($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSamples() => $_has(8);
  @$pb.TagNumber(9)
  void clearSamples() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get parent => $_getSZ(9);
  @$pb.TagNumber(10)
  set parent($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasParent() => $_has(9);
  @$pb.TagNumber(10)
  void clearParent() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get cycleId => $_getI64(10);
  @$pb.TagNumber(11)
  set cycleId($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCycleId() => $_has(10);
  @$pb.TagNumber(11)
  void clearCycleId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get trainError => $_getN(11);
  @$pb.TagNumber(12)
  set trainError($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTrainError() => $_has(11);
  @$pb.TagNumber(12)
  void clearTrainError() => $_clearField(12);
}

class ListModelsRequest extends $pb.GeneratedMessage {
  factory ListModelsRequest() => ListModelsRequest._();

  ListModelsRequest._();

  factory ListModelsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListModelsRequest()..mergeFromBuffer(data, registry);
  factory ListModelsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListModelsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListModelsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListModelsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelsRequest copyWith(void Function(ListModelsRequest) updates) =>
      super.copyWith((message) => updates(message as ListModelsRequest))
          as ListModelsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListModelsRequest() / ListModelsRequest.new instead')
  static ListModelsRequest create() => ListModelsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListModelsRequest._();
  @$core.override
  ListModelsRequest createEmptyInstance() => ListModelsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListModelsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListModelsRequest>(
          ListModelsRequest.$_createMessage);
  static ListModelsRequest? _defaultInstance;
}

class ListModelsResponse extends $pb.GeneratedMessage {
  factory ListModelsResponse({
    $core.Iterable<ModelInfo>? models,
  }) {
    final result = ListModelsResponse._();
    if (models != null) result.models.addAll(models);
    return result;
  }

  ListModelsResponse._();

  factory ListModelsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListModelsResponse()..mergeFromBuffer(data, registry);
  factory ListModelsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListModelsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListModelsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListModelsResponse.$_createMessage)
    ..pPM<ModelInfo>(1, _omitFieldNames ? '' : 'models',
        subBuilder: ModelInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListModelsResponse copyWith(void Function(ListModelsResponse) updates) =>
      super.copyWith((message) => updates(message as ListModelsResponse))
          as ListModelsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListModelsResponse() / ListModelsResponse.new instead')
  static ListModelsResponse create() => ListModelsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListModelsResponse._();
  @$core.override
  ListModelsResponse createEmptyInstance() => ListModelsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListModelsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListModelsResponse>(
          ListModelsResponse.$_createMessage);
  static ListModelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ModelInfo> get models => $_getList(0);
}

class ApproveCycleRequest extends $pb.GeneratedMessage {
  factory ApproveCycleRequest({
    $fixnum.Int64? cycleId,
    $core.String? note,
  }) {
    final result = ApproveCycleRequest._();
    if (cycleId != null) result.cycleId = cycleId;
    if (note != null) result.note = note;
    return result;
  }

  ApproveCycleRequest._();

  factory ApproveCycleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApproveCycleRequest()..mergeFromBuffer(data, registry);
  factory ApproveCycleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApproveCycleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveCycleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ApproveCycleRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'cycleId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCycleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCycleRequest copyWith(void Function(ApproveCycleRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveCycleRequest))
          as ApproveCycleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ApproveCycleRequest() / ApproveCycleRequest.new instead')
  static ApproveCycleRequest create() => ApproveCycleRequest._();
  static $pb.GeneratedMessage $_createMessage() => ApproveCycleRequest._();
  @$core.override
  ApproveCycleRequest createEmptyInstance() => ApproveCycleRequest._();
  @$core.pragma('dart2js:noInline')
  static ApproveCycleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveCycleRequest>(
          ApproveCycleRequest.$_createMessage);
  static ApproveCycleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cycleId => $_getI64(0);
  @$pb.TagNumber(1)
  set cycleId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class ApproveCycleResponse extends $pb.GeneratedMessage {
  factory ApproveCycleResponse() => ApproveCycleResponse._();

  ApproveCycleResponse._();

  factory ApproveCycleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApproveCycleResponse()..mergeFromBuffer(data, registry);
  factory ApproveCycleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApproveCycleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveCycleResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ApproveCycleResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCycleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCycleResponse copyWith(void Function(ApproveCycleResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveCycleResponse))
          as ApproveCycleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ApproveCycleResponse() / ApproveCycleResponse.new instead')
  static ApproveCycleResponse create() => ApproveCycleResponse._();
  static $pb.GeneratedMessage $_createMessage() => ApproveCycleResponse._();
  @$core.override
  ApproveCycleResponse createEmptyInstance() => ApproveCycleResponse._();
  @$core.pragma('dart2js:noInline')
  static ApproveCycleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveCycleResponse>(
          ApproveCycleResponse.$_createMessage);
  static ApproveCycleResponse? _defaultInstance;
}

class RejectCycleRequest extends $pb.GeneratedMessage {
  factory RejectCycleRequest({
    $fixnum.Int64? cycleId,
    $core.String? note,
  }) {
    final result = RejectCycleRequest._();
    if (cycleId != null) result.cycleId = cycleId;
    if (note != null) result.note = note;
    return result;
  }

  RejectCycleRequest._();

  factory RejectCycleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RejectCycleRequest()..mergeFromBuffer(data, registry);
  factory RejectCycleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RejectCycleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectCycleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RejectCycleRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'cycleId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectCycleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectCycleRequest copyWith(void Function(RejectCycleRequest) updates) =>
      super.copyWith((message) => updates(message as RejectCycleRequest))
          as RejectCycleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RejectCycleRequest() / RejectCycleRequest.new instead')
  static RejectCycleRequest create() => RejectCycleRequest._();
  static $pb.GeneratedMessage $_createMessage() => RejectCycleRequest._();
  @$core.override
  RejectCycleRequest createEmptyInstance() => RejectCycleRequest._();
  @$core.pragma('dart2js:noInline')
  static RejectCycleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectCycleRequest>(
          RejectCycleRequest.$_createMessage);
  static RejectCycleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cycleId => $_getI64(0);
  @$pb.TagNumber(1)
  set cycleId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class RejectCycleResponse extends $pb.GeneratedMessage {
  factory RejectCycleResponse() => RejectCycleResponse._();

  RejectCycleResponse._();

  factory RejectCycleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RejectCycleResponse()..mergeFromBuffer(data, registry);
  factory RejectCycleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RejectCycleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectCycleResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RejectCycleResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectCycleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectCycleResponse copyWith(void Function(RejectCycleResponse) updates) =>
      super.copyWith((message) => updates(message as RejectCycleResponse))
          as RejectCycleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use RejectCycleResponse() / RejectCycleResponse.new instead')
  static RejectCycleResponse create() => RejectCycleResponse._();
  static $pb.GeneratedMessage $_createMessage() => RejectCycleResponse._();
  @$core.override
  RejectCycleResponse createEmptyInstance() => RejectCycleResponse._();
  @$core.pragma('dart2js:noInline')
  static RejectCycleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectCycleResponse>(
          RejectCycleResponse.$_createMessage);
  static RejectCycleResponse? _defaultInstance;
}

class RollbackRequest extends $pb.GeneratedMessage {
  factory RollbackRequest({
    $core.String? note,
  }) {
    final result = RollbackRequest._();
    if (note != null) result.note = note;
    return result;
  }

  RollbackRequest._();

  factory RollbackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RollbackRequest()..mergeFromBuffer(data, registry);
  factory RollbackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RollbackRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RollbackRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RollbackRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RollbackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RollbackRequest copyWith(void Function(RollbackRequest) updates) =>
      super.copyWith((message) => updates(message as RollbackRequest))
          as RollbackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RollbackRequest() / RollbackRequest.new instead')
  static RollbackRequest create() => RollbackRequest._();
  static $pb.GeneratedMessage $_createMessage() => RollbackRequest._();
  @$core.override
  RollbackRequest createEmptyInstance() => RollbackRequest._();
  @$core.pragma('dart2js:noInline')
  static RollbackRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RollbackRequest>(
          RollbackRequest.$_createMessage);
  static RollbackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get note => $_getSZ(0);
  @$pb.TagNumber(1)
  set note($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNote() => $_has(0);
  @$pb.TagNumber(1)
  void clearNote() => $_clearField(1);
}

class RollbackResponse extends $pb.GeneratedMessage {
  factory RollbackResponse() => RollbackResponse._();

  RollbackResponse._();

  factory RollbackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RollbackResponse()..mergeFromBuffer(data, registry);
  factory RollbackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RollbackResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RollbackResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: RollbackResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RollbackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RollbackResponse copyWith(void Function(RollbackResponse) updates) =>
      super.copyWith((message) => updates(message as RollbackResponse))
          as RollbackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RollbackResponse() / RollbackResponse.new instead')
  static RollbackResponse create() => RollbackResponse._();
  static $pb.GeneratedMessage $_createMessage() => RollbackResponse._();
  @$core.override
  RollbackResponse createEmptyInstance() => RollbackResponse._();
  @$core.pragma('dart2js:noInline')
  static RollbackResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RollbackResponse>(
          RollbackResponse.$_createMessage);
  static RollbackResponse? _defaultInstance;
}

/// LearningService: learning cycles, their gate, the model registry and the
/// user's promotion decisions. The loop recommends; only ApproveCycle and
/// Rollback (user actions) change the active version and model.
class LearningServiceApi {
  final $pb.RpcClient _client;

  LearningServiceApi(this._client);

  $async.Future<GetLearningResponse> getLearning(
          $pb.ClientContext? ctx, GetLearningRequest request) =>
      _client.invoke<GetLearningResponse>(ctx, 'LearningService', 'GetLearning',
          request, GetLearningResponse());
  $async.Future<SaveConfigResponse> saveConfig(
          $pb.ClientContext? ctx, SaveConfigRequest request) =>
      _client.invoke<SaveConfigResponse>(
          ctx, 'LearningService', 'SaveConfig', request, SaveConfigResponse());
  $async.Future<StartCycleResponse> startCycle(
          $pb.ClientContext? ctx, StartCycleRequest request) =>
      _client.invoke<StartCycleResponse>(
          ctx, 'LearningService', 'StartCycle', request, StartCycleResponse());
  $async.Future<ListCyclesResponse> listCycles(
          $pb.ClientContext? ctx, ListCyclesRequest request) =>
      _client.invoke<ListCyclesResponse>(
          ctx, 'LearningService', 'ListCycles', request, ListCyclesResponse());
  $async.Future<ListCandidatesResponse> listCandidates(
          $pb.ClientContext? ctx, ListCandidatesRequest request) =>
      _client.invoke<ListCandidatesResponse>(ctx, 'LearningService',
          'ListCandidates', request, ListCandidatesResponse());
  $async.Future<ListModelsResponse> listModels(
          $pb.ClientContext? ctx, ListModelsRequest request) =>
      _client.invoke<ListModelsResponse>(
          ctx, 'LearningService', 'ListModels', request, ListModelsResponse());
  $async.Future<ApproveCycleResponse> approveCycle(
          $pb.ClientContext? ctx, ApproveCycleRequest request) =>
      _client.invoke<ApproveCycleResponse>(ctx, 'LearningService',
          'ApproveCycle', request, ApproveCycleResponse());
  $async.Future<RejectCycleResponse> rejectCycle(
          $pb.ClientContext? ctx, RejectCycleRequest request) =>
      _client.invoke<RejectCycleResponse>(ctx, 'LearningService', 'RejectCycle',
          request, RejectCycleResponse());
  $async.Future<RollbackResponse> rollback(
          $pb.ClientContext? ctx, RollbackRequest request) =>
      _client.invoke<RollbackResponse>(
          ctx, 'LearningService', 'Rollback', request, RollbackResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
