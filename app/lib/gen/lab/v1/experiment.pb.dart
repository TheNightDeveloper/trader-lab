// This is a generated file - do not edit.
//
// Generated from lab/v1/experiment.proto.

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

class Objective extends $pb.GeneratedMessage {
  factory Objective({
    $core.String? metric,
    $core.bool? maximize,
  }) {
    final result = Objective._();
    if (metric != null) result.metric = metric;
    if (maximize != null) result.maximize = maximize;
    return result;
  }

  Objective._();

  factory Objective.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Objective()..mergeFromBuffer(data, registry);
  factory Objective.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Objective()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Objective',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Objective.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'metric')
    ..aOB(2, _omitFieldNames ? '' : 'maximize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Objective clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Objective copyWith(void Function(Objective) updates) =>
      super.copyWith((message) => updates(message as Objective)) as Objective;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Objective() / Objective.new instead')
  static Objective create() => Objective._();
  static $pb.GeneratedMessage $_createMessage() => Objective._();
  @$core.override
  Objective createEmptyInstance() => Objective._();
  @$core.pragma('dart2js:noInline')
  static Objective getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Objective>(Objective.$_createMessage);
  static Objective? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get metric => $_getSZ(0);
  @$pb.TagNumber(1)
  set metric($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMetric() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetric() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get maximize => $_getBF(1);
  @$pb.TagNumber(2)
  set maximize($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaximize() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaximize() => $_clearField(2);
}

class Constraint extends $pb.GeneratedMessage {
  factory Constraint({
    $core.String? metric,
    $core.String? op,
    $core.String? value,
  }) {
    final result = Constraint._();
    if (metric != null) result.metric = metric;
    if (op != null) result.op = op;
    if (value != null) result.value = value;
    return result;
  }

  Constraint._();

  factory Constraint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Constraint()..mergeFromBuffer(data, registry);
  factory Constraint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Constraint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Constraint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Constraint.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'metric')
    ..aOS(2, _omitFieldNames ? '' : 'op')
    ..aOS(3, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Constraint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Constraint copyWith(void Function(Constraint) updates) =>
      super.copyWith((message) => updates(message as Constraint)) as Constraint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Constraint() / Constraint.new instead')
  static Constraint create() => Constraint._();
  static $pb.GeneratedMessage $_createMessage() => Constraint._();
  @$core.override
  Constraint createEmptyInstance() => Constraint._();
  @$core.pragma('dart2js:noInline')
  static Constraint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Constraint>(Constraint.$_createMessage);
  static Constraint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get metric => $_getSZ(0);
  @$pb.TagNumber(1)
  set metric($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMetric() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetric() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get op => $_getSZ(1);
  @$pb.TagNumber(2)
  set op($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOp() => $_has(1);
  @$pb.TagNumber(2)
  void clearOp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get value => $_getSZ(2);
  @$pb.TagNumber(3)
  set value($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);
}

class ParamRange extends $pb.GeneratedMessage {
  factory ParamRange({
    $core.Iterable<$core.double>? values,
    $core.double? min,
    $core.double? max,
    $core.double? step,
  }) {
    final result = ParamRange._();
    if (values != null) result.values.addAll(values);
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    if (step != null) result.step = step;
    return result;
  }

  ParamRange._();

  factory ParamRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ParamRange()..mergeFromBuffer(data, registry);
  factory ParamRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ParamRange()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParamRange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ParamRange.$_createMessage)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KD)
    ..aD(2, _omitFieldNames ? '' : 'min')
    ..aD(3, _omitFieldNames ? '' : 'max')
    ..aD(4, _omitFieldNames ? '' : 'step')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParamRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParamRange copyWith(void Function(ParamRange) updates) =>
      super.copyWith((message) => updates(message as ParamRange)) as ParamRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ParamRange() / ParamRange.new instead')
  static ParamRange create() => ParamRange._();
  static $pb.GeneratedMessage $_createMessage() => ParamRange._();
  @$core.override
  ParamRange createEmptyInstance() => ParamRange._();
  @$core.pragma('dart2js:noInline')
  static ParamRange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParamRange>(ParamRange.$_createMessage);
  static ParamRange? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get values => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get min => $_getN(1);
  @$pb.TagNumber(2)
  set min($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMin() => $_has(1);
  @$pb.TagNumber(2)
  void clearMin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get max => $_getN(2);
  @$pb.TagNumber(3)
  set max($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMax() => $_has(2);
  @$pb.TagNumber(3)
  void clearMax() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get step => $_getN(3);
  @$pb.TagNumber(4)
  set step($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStep() => $_has(3);
  @$pb.TagNumber(4)
  void clearStep() => $_clearField(4);
}

class SearchPlan extends $pb.GeneratedMessage {
  factory SearchPlan({
    $core.String? mode,
    $fixnum.Int64? seed,
    $core.int? maxAttempts,
    $core.int? maxWallSeconds,
  }) {
    final result = SearchPlan._();
    if (mode != null) result.mode = mode;
    if (seed != null) result.seed = seed;
    if (maxAttempts != null) result.maxAttempts = maxAttempts;
    if (maxWallSeconds != null) result.maxWallSeconds = maxWallSeconds;
    return result;
  }

  SearchPlan._();

  factory SearchPlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchPlan()..mergeFromBuffer(data, registry);
  factory SearchPlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchPlan()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchPlan',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: SearchPlan.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'mode')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'seed', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'maxAttempts')
    ..aI(4, _omitFieldNames ? '' : 'maxWallSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchPlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchPlan copyWith(void Function(SearchPlan) updates) =>
      super.copyWith((message) => updates(message as SearchPlan)) as SearchPlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchPlan() / SearchPlan.new instead')
  static SearchPlan create() => SearchPlan._();
  static $pb.GeneratedMessage $_createMessage() => SearchPlan._();
  @$core.override
  SearchPlan createEmptyInstance() => SearchPlan._();
  @$core.pragma('dart2js:noInline')
  static SearchPlan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchPlan>(SearchPlan.$_createMessage);
  static SearchPlan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mode => $_getSZ(0);
  @$pb.TagNumber(1)
  set mode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seed => $_getI64(1);
  @$pb.TagNumber(2)
  set seed($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeed() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxAttempts => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxAttempts($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxAttempts() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxAttempts() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxWallSeconds => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxWallSeconds($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxWallSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxWallSeconds() => $_clearField(4);
}

class ExperimentDefinition extends $pb.GeneratedMessage {
  factory ExperimentDefinition({
    $core.String? name,
    $core.String? hypothesis,
    $core.String? falsifier,
    Objective? objective,
    $core.Iterable<Constraint>? constraints,
    $core.Iterable<$core.String>? datasetIds,
    $core.String? algorithmVersion,
    $core.Iterable<$core.MapEntry<$core.String, ParamRange>>? space,
    SearchPlan? search,
    $0.Money? capital,
    $0.Decimal? fee,
    $0.Decimal? slippage,
    $core.int? latencyBars,
    $core.int? folds,
    $core.bool? rolling,
    $0.Decimal? holdout,
  }) {
    final result = ExperimentDefinition._();
    if (name != null) result.name = name;
    if (hypothesis != null) result.hypothesis = hypothesis;
    if (falsifier != null) result.falsifier = falsifier;
    if (objective != null) result.objective = objective;
    if (constraints != null) result.constraints.addAll(constraints);
    if (datasetIds != null) result.datasetIds.addAll(datasetIds);
    if (algorithmVersion != null) result.algorithmVersion = algorithmVersion;
    if (space != null) result.space.addEntries(space);
    if (search != null) result.search = search;
    if (capital != null) result.capital = capital;
    if (fee != null) result.fee = fee;
    if (slippage != null) result.slippage = slippage;
    if (latencyBars != null) result.latencyBars = latencyBars;
    if (folds != null) result.folds = folds;
    if (rolling != null) result.rolling = rolling;
    if (holdout != null) result.holdout = holdout;
    return result;
  }

  ExperimentDefinition._();

  factory ExperimentDefinition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExperimentDefinition()..mergeFromBuffer(data, registry);
  factory ExperimentDefinition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExperimentDefinition()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExperimentDefinition',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ExperimentDefinition.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'hypothesis')
    ..aOS(3, _omitFieldNames ? '' : 'falsifier')
    ..aOM<Objective>(4, _omitFieldNames ? '' : 'objective',
        subBuilder: Objective.$_createMessage)
    ..pPM<Constraint>(5, _omitFieldNames ? '' : 'constraints',
        subBuilder: Constraint.$_createMessage)
    ..pPS(6, _omitFieldNames ? '' : 'datasetIds')
    ..aOS(7, _omitFieldNames ? '' : 'algorithmVersion')
    ..m<$core.String, ParamRange>(8, _omitFieldNames ? '' : 'space',
        entryClassName: 'ExperimentDefinition.SpaceEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: ParamRange.$_createMessage,
        valueDefaultOrMaker: ParamRange.getDefault,
        packageName: const $pb.PackageName('lab.v1'))
    ..aOM<SearchPlan>(9, _omitFieldNames ? '' : 'search',
        subBuilder: SearchPlan.$_createMessage)
    ..aOM<$0.Money>(10, _omitFieldNames ? '' : 'capital',
        subBuilder: $0.Money.$_createMessage)
    ..aOM<$0.Decimal>(11, _omitFieldNames ? '' : 'fee',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(12, _omitFieldNames ? '' : 'slippage',
        subBuilder: $0.Decimal.$_createMessage)
    ..aI(13, _omitFieldNames ? '' : 'latencyBars')
    ..aI(14, _omitFieldNames ? '' : 'folds')
    ..aOB(15, _omitFieldNames ? '' : 'rolling')
    ..aOM<$0.Decimal>(16, _omitFieldNames ? '' : 'holdout',
        subBuilder: $0.Decimal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExperimentDefinition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExperimentDefinition copyWith(void Function(ExperimentDefinition) updates) =>
      super.copyWith((message) => updates(message as ExperimentDefinition))
          as ExperimentDefinition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExperimentDefinition() / ExperimentDefinition.new instead')
  static ExperimentDefinition create() => ExperimentDefinition._();
  static $pb.GeneratedMessage $_createMessage() => ExperimentDefinition._();
  @$core.override
  ExperimentDefinition createEmptyInstance() => ExperimentDefinition._();
  @$core.pragma('dart2js:noInline')
  static ExperimentDefinition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExperimentDefinition>(
          ExperimentDefinition.$_createMessage);
  static ExperimentDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hypothesis => $_getSZ(1);
  @$pb.TagNumber(2)
  set hypothesis($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHypothesis() => $_has(1);
  @$pb.TagNumber(2)
  void clearHypothesis() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get falsifier => $_getSZ(2);
  @$pb.TagNumber(3)
  set falsifier($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFalsifier() => $_has(2);
  @$pb.TagNumber(3)
  void clearFalsifier() => $_clearField(3);

  @$pb.TagNumber(4)
  Objective get objective => $_getN(3);
  @$pb.TagNumber(4)
  set objective(Objective value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasObjective() => $_has(3);
  @$pb.TagNumber(4)
  void clearObjective() => $_clearField(4);
  @$pb.TagNumber(4)
  Objective ensureObjective() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<Constraint> get constraints => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get datasetIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get algorithmVersion => $_getSZ(6);
  @$pb.TagNumber(7)
  set algorithmVersion($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAlgorithmVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearAlgorithmVersion() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, ParamRange> get space => $_getMap(7);

  @$pb.TagNumber(9)
  SearchPlan get search => $_getN(8);
  @$pb.TagNumber(9)
  set search(SearchPlan value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSearch() => $_has(8);
  @$pb.TagNumber(9)
  void clearSearch() => $_clearField(9);
  @$pb.TagNumber(9)
  SearchPlan ensureSearch() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Money get capital => $_getN(9);
  @$pb.TagNumber(10)
  set capital($0.Money value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCapital() => $_has(9);
  @$pb.TagNumber(10)
  void clearCapital() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Money ensureCapital() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Decimal get fee => $_getN(10);
  @$pb.TagNumber(11)
  set fee($0.Decimal value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasFee() => $_has(10);
  @$pb.TagNumber(11)
  void clearFee() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Decimal ensureFee() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Decimal get slippage => $_getN(11);
  @$pb.TagNumber(12)
  set slippage($0.Decimal value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSlippage() => $_has(11);
  @$pb.TagNumber(12)
  void clearSlippage() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Decimal ensureSlippage() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.int get latencyBars => $_getIZ(12);
  @$pb.TagNumber(13)
  set latencyBars($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLatencyBars() => $_has(12);
  @$pb.TagNumber(13)
  void clearLatencyBars() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get folds => $_getIZ(13);
  @$pb.TagNumber(14)
  set folds($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFolds() => $_has(13);
  @$pb.TagNumber(14)
  void clearFolds() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get rolling => $_getBF(14);
  @$pb.TagNumber(15)
  set rolling($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRolling() => $_has(14);
  @$pb.TagNumber(15)
  void clearRolling() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Decimal get holdout => $_getN(15);
  @$pb.TagNumber(16)
  set holdout($0.Decimal value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasHoldout() => $_has(15);
  @$pb.TagNumber(16)
  void clearHoldout() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Decimal ensureHoldout() => $_ensure(15);
}

class EstimateRequest extends $pb.GeneratedMessage {
  factory EstimateRequest({
    ExperimentDefinition? definition,
  }) {
    final result = EstimateRequest._();
    if (definition != null) result.definition = definition;
    return result;
  }

  EstimateRequest._();

  factory EstimateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateRequest()..mergeFromBuffer(data, registry);
  factory EstimateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EstimateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: EstimateRequest.$_createMessage)
    ..aOM<ExperimentDefinition>(1, _omitFieldNames ? '' : 'definition',
        subBuilder: ExperimentDefinition.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateRequest copyWith(void Function(EstimateRequest) updates) =>
      super.copyWith((message) => updates(message as EstimateRequest))
          as EstimateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EstimateRequest() / EstimateRequest.new instead')
  static EstimateRequest create() => EstimateRequest._();
  static $pb.GeneratedMessage $_createMessage() => EstimateRequest._();
  @$core.override
  EstimateRequest createEmptyInstance() => EstimateRequest._();
  @$core.pragma('dart2js:noInline')
  static EstimateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EstimateRequest>(
          EstimateRequest.$_createMessage);
  static EstimateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ExperimentDefinition get definition => $_getN(0);
  @$pb.TagNumber(1)
  set definition(ExperimentDefinition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDefinition() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefinition() => $_clearField(1);
  @$pb.TagNumber(1)
  ExperimentDefinition ensureDefinition() => $_ensure(0);
}

class EstimateResponse extends $pb.GeneratedMessage {
  factory EstimateResponse({
    $core.int? candidates,
    $core.int? attempts,
    $fixnum.Int64? estimatedSeconds,
    $core.String? error,
  }) {
    final result = EstimateResponse._();
    if (candidates != null) result.candidates = candidates;
    if (attempts != null) result.attempts = attempts;
    if (estimatedSeconds != null) result.estimatedSeconds = estimatedSeconds;
    if (error != null) result.error = error;
    return result;
  }

  EstimateResponse._();

  factory EstimateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateResponse()..mergeFromBuffer(data, registry);
  factory EstimateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EstimateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: EstimateResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'candidates')
    ..aI(2, _omitFieldNames ? '' : 'attempts')
    ..aInt64(3, _omitFieldNames ? '' : 'estimatedSeconds')
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateResponse copyWith(void Function(EstimateResponse) updates) =>
      super.copyWith((message) => updates(message as EstimateResponse))
          as EstimateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EstimateResponse() / EstimateResponse.new instead')
  static EstimateResponse create() => EstimateResponse._();
  static $pb.GeneratedMessage $_createMessage() => EstimateResponse._();
  @$core.override
  EstimateResponse createEmptyInstance() => EstimateResponse._();
  @$core.pragma('dart2js:noInline')
  static EstimateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EstimateResponse>(
          EstimateResponse.$_createMessage);
  static EstimateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get candidates => $_getIZ(0);
  @$pb.TagNumber(1)
  set candidates($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCandidates() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidates() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get attempts => $_getIZ(1);
  @$pb.TagNumber(2)
  set attempts($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttempts() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttempts() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get estimatedSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set estimatedSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEstimatedSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearEstimatedSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get error => $_getSZ(3);
  @$pb.TagNumber(4)
  set error($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
}

class CreateExperimentRequest extends $pb.GeneratedMessage {
  factory CreateExperimentRequest({
    ExperimentDefinition? definition,
  }) {
    final result = CreateExperimentRequest._();
    if (definition != null) result.definition = definition;
    return result;
  }

  CreateExperimentRequest._();

  factory CreateExperimentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateExperimentRequest()..mergeFromBuffer(data, registry);
  factory CreateExperimentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateExperimentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateExperimentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CreateExperimentRequest.$_createMessage)
    ..aOM<ExperimentDefinition>(1, _omitFieldNames ? '' : 'definition',
        subBuilder: ExperimentDefinition.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateExperimentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateExperimentRequest copyWith(
          void Function(CreateExperimentRequest) updates) =>
      super.copyWith((message) => updates(message as CreateExperimentRequest))
          as CreateExperimentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateExperimentRequest() / CreateExperimentRequest.new instead')
  static CreateExperimentRequest create() => CreateExperimentRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateExperimentRequest._();
  @$core.override
  CreateExperimentRequest createEmptyInstance() => CreateExperimentRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateExperimentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateExperimentRequest>(
          CreateExperimentRequest.$_createMessage);
  static CreateExperimentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ExperimentDefinition get definition => $_getN(0);
  @$pb.TagNumber(1)
  set definition(ExperimentDefinition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDefinition() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefinition() => $_clearField(1);
  @$pb.TagNumber(1)
  ExperimentDefinition ensureDefinition() => $_ensure(0);
}

class CreateExperimentResponse extends $pb.GeneratedMessage {
  factory CreateExperimentResponse({
    $core.String? experimentId,
    $core.bool? alreadyExisted,
  }) {
    final result = CreateExperimentResponse._();
    if (experimentId != null) result.experimentId = experimentId;
    if (alreadyExisted != null) result.alreadyExisted = alreadyExisted;
    return result;
  }

  CreateExperimentResponse._();

  factory CreateExperimentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateExperimentResponse()..mergeFromBuffer(data, registry);
  factory CreateExperimentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateExperimentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateExperimentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CreateExperimentResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'experimentId')
    ..aOB(2, _omitFieldNames ? '' : 'alreadyExisted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateExperimentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateExperimentResponse copyWith(
          void Function(CreateExperimentResponse) updates) =>
      super.copyWith((message) => updates(message as CreateExperimentResponse))
          as CreateExperimentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateExperimentResponse() / CreateExperimentResponse.new instead')
  static CreateExperimentResponse create() => CreateExperimentResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateExperimentResponse._();
  @$core.override
  CreateExperimentResponse createEmptyInstance() =>
      CreateExperimentResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateExperimentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateExperimentResponse>(
          CreateExperimentResponse.$_createMessage);
  static CreateExperimentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get experimentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set experimentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExperimentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExperimentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get alreadyExisted => $_getBF(1);
  @$pb.TagNumber(2)
  set alreadyExisted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlreadyExisted() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlreadyExisted() => $_clearField(2);
}

class AttemptCounts extends $pb.GeneratedMessage {
  factory AttemptCounts({
    $core.int? queued,
    $core.int? running,
    $core.int? done,
    $core.int? failed,
    $core.int? cancelled,
    $core.int? total,
  }) {
    final result = AttemptCounts._();
    if (queued != null) result.queued = queued;
    if (running != null) result.running = running;
    if (done != null) result.done = done;
    if (failed != null) result.failed = failed;
    if (cancelled != null) result.cancelled = cancelled;
    if (total != null) result.total = total;
    return result;
  }

  AttemptCounts._();

  factory AttemptCounts.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttemptCounts()..mergeFromBuffer(data, registry);
  factory AttemptCounts.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttemptCounts()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttemptCounts',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AttemptCounts.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'queued')
    ..aI(2, _omitFieldNames ? '' : 'running')
    ..aI(3, _omitFieldNames ? '' : 'done')
    ..aI(4, _omitFieldNames ? '' : 'failed')
    ..aI(5, _omitFieldNames ? '' : 'cancelled')
    ..aI(6, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttemptCounts clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttemptCounts copyWith(void Function(AttemptCounts) updates) =>
      super.copyWith((message) => updates(message as AttemptCounts))
          as AttemptCounts;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AttemptCounts() / AttemptCounts.new instead')
  static AttemptCounts create() => AttemptCounts._();
  static $pb.GeneratedMessage $_createMessage() => AttemptCounts._();
  @$core.override
  AttemptCounts createEmptyInstance() => AttemptCounts._();
  @$core.pragma('dart2js:noInline')
  static AttemptCounts getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AttemptCounts>(
          AttemptCounts.$_createMessage);
  static AttemptCounts? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get queued => $_getIZ(0);
  @$pb.TagNumber(1)
  set queued($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQueued() => $_has(0);
  @$pb.TagNumber(1)
  void clearQueued() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get running => $_getIZ(1);
  @$pb.TagNumber(2)
  set running($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRunning() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunning() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get done => $_getIZ(2);
  @$pb.TagNumber(3)
  set done($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDone() => $_has(2);
  @$pb.TagNumber(3)
  void clearDone() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get failed => $_getIZ(3);
  @$pb.TagNumber(4)
  set failed($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFailed() => $_has(3);
  @$pb.TagNumber(4)
  void clearFailed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get cancelled => $_getIZ(4);
  @$pb.TagNumber(5)
  set cancelled($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCancelled() => $_has(4);
  @$pb.TagNumber(5)
  void clearCancelled() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get total => $_getIZ(5);
  @$pb.TagNumber(6)
  set total($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotal() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotal() => $_clearField(6);
}

class ExperimentResult extends $pb.GeneratedMessage {
  factory ExperimentResult({
    $core.int? chosen,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? params,
    $0.Metric? objective,
    $core.int? candidates,
    $core.int? eligibleCandidates,
    $core.int? attempts,
    $core.Iterable<$core.String>? reportIds,
    $core.String? reason,
  }) {
    final result = ExperimentResult._();
    if (chosen != null) result.chosen = chosen;
    if (params != null) result.params.addEntries(params);
    if (objective != null) result.objective = objective;
    if (candidates != null) result.candidates = candidates;
    if (eligibleCandidates != null)
      result.eligibleCandidates = eligibleCandidates;
    if (attempts != null) result.attempts = attempts;
    if (reportIds != null) result.reportIds.addAll(reportIds);
    if (reason != null) result.reason = reason;
    return result;
  }

  ExperimentResult._();

  factory ExperimentResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExperimentResult()..mergeFromBuffer(data, registry);
  factory ExperimentResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExperimentResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExperimentResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ExperimentResult.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'chosen')
    ..m<$core.String, $core.double>(2, _omitFieldNames ? '' : 'params',
        entryClassName: 'ExperimentResult.ParamsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('lab.v1'))
    ..aOM<$0.Metric>(3, _omitFieldNames ? '' : 'objective',
        subBuilder: $0.Metric.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'candidates')
    ..aI(5, _omitFieldNames ? '' : 'eligibleCandidates')
    ..aI(6, _omitFieldNames ? '' : 'attempts')
    ..pPS(7, _omitFieldNames ? '' : 'reportIds')
    ..aOS(8, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExperimentResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExperimentResult copyWith(void Function(ExperimentResult) updates) =>
      super.copyWith((message) => updates(message as ExperimentResult))
          as ExperimentResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExperimentResult() / ExperimentResult.new instead')
  static ExperimentResult create() => ExperimentResult._();
  static $pb.GeneratedMessage $_createMessage() => ExperimentResult._();
  @$core.override
  ExperimentResult createEmptyInstance() => ExperimentResult._();
  @$core.pragma('dart2js:noInline')
  static ExperimentResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExperimentResult>(
          ExperimentResult.$_createMessage);
  static ExperimentResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get chosen => $_getIZ(0);
  @$pb.TagNumber(1)
  set chosen($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChosen() => $_has(0);
  @$pb.TagNumber(1)
  void clearChosen() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.double> get params => $_getMap(1);

  @$pb.TagNumber(3)
  $0.Metric get objective => $_getN(2);
  @$pb.TagNumber(3)
  set objective($0.Metric value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasObjective() => $_has(2);
  @$pb.TagNumber(3)
  void clearObjective() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Metric ensureObjective() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get candidates => $_getIZ(3);
  @$pb.TagNumber(4)
  set candidates($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCandidates() => $_has(3);
  @$pb.TagNumber(4)
  void clearCandidates() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get eligibleCandidates => $_getIZ(4);
  @$pb.TagNumber(5)
  set eligibleCandidates($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEligibleCandidates() => $_has(4);
  @$pb.TagNumber(5)
  void clearEligibleCandidates() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get attempts => $_getIZ(5);
  @$pb.TagNumber(6)
  set attempts($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAttempts() => $_has(5);
  @$pb.TagNumber(6)
  void clearAttempts() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get reportIds => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get reason => $_getSZ(7);
  @$pb.TagNumber(8)
  set reason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearReason() => $_clearField(8);
}

class ExperimentSummary extends $pb.GeneratedMessage {
  factory ExperimentSummary({
    $core.String? id,
    $core.String? name,
    $core.String? status,
    $fixnum.Int64? createdUnixMs,
    $fixnum.Int64? finishedUnixMs,
    $core.String? algorithmVersion,
    AttemptCounts? counts,
  }) {
    final result = ExperimentSummary._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (status != null) result.status = status;
    if (createdUnixMs != null) result.createdUnixMs = createdUnixMs;
    if (finishedUnixMs != null) result.finishedUnixMs = finishedUnixMs;
    if (algorithmVersion != null) result.algorithmVersion = algorithmVersion;
    if (counts != null) result.counts = counts;
    return result;
  }

  ExperimentSummary._();

  factory ExperimentSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExperimentSummary()..mergeFromBuffer(data, registry);
  factory ExperimentSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExperimentSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExperimentSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ExperimentSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aInt64(4, _omitFieldNames ? '' : 'createdUnixMs')
    ..aInt64(5, _omitFieldNames ? '' : 'finishedUnixMs')
    ..aOS(6, _omitFieldNames ? '' : 'algorithmVersion')
    ..aOM<AttemptCounts>(7, _omitFieldNames ? '' : 'counts',
        subBuilder: AttemptCounts.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExperimentSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExperimentSummary copyWith(void Function(ExperimentSummary) updates) =>
      super.copyWith((message) => updates(message as ExperimentSummary))
          as ExperimentSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExperimentSummary() / ExperimentSummary.new instead')
  static ExperimentSummary create() => ExperimentSummary._();
  static $pb.GeneratedMessage $_createMessage() => ExperimentSummary._();
  @$core.override
  ExperimentSummary createEmptyInstance() => ExperimentSummary._();
  @$core.pragma('dart2js:noInline')
  static ExperimentSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExperimentSummary>(
          ExperimentSummary.$_createMessage);
  static ExperimentSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createdUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set createdUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get finishedUnixMs => $_getI64(4);
  @$pb.TagNumber(5)
  set finishedUnixMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFinishedUnixMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearFinishedUnixMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get algorithmVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set algorithmVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAlgorithmVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearAlgorithmVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  AttemptCounts get counts => $_getN(6);
  @$pb.TagNumber(7)
  set counts(AttemptCounts value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCounts() => $_has(6);
  @$pb.TagNumber(7)
  void clearCounts() => $_clearField(7);
  @$pb.TagNumber(7)
  AttemptCounts ensureCounts() => $_ensure(6);
}

class ListExperimentsRequest extends $pb.GeneratedMessage {
  factory ListExperimentsRequest({
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = ListExperimentsRequest._();
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListExperimentsRequest._();

  factory ListExperimentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExperimentsRequest()..mergeFromBuffer(data, registry);
  factory ListExperimentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExperimentsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExperimentsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListExperimentsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aI(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExperimentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExperimentsRequest copyWith(
          void Function(ListExperimentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListExperimentsRequest))
          as ListExperimentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListExperimentsRequest() / ListExperimentsRequest.new instead')
  static ListExperimentsRequest create() => ListExperimentsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListExperimentsRequest._();
  @$core.override
  ListExperimentsRequest createEmptyInstance() => ListExperimentsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListExperimentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExperimentsRequest>(
          ListExperimentsRequest.$_createMessage);
  static ListExperimentsRequest? _defaultInstance;

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

class ListExperimentsResponse extends $pb.GeneratedMessage {
  factory ListExperimentsResponse({
    $core.Iterable<ExperimentSummary>? experiments,
    $fixnum.Int64? total,
  }) {
    final result = ListExperimentsResponse._();
    if (experiments != null) result.experiments.addAll(experiments);
    if (total != null) result.total = total;
    return result;
  }

  ListExperimentsResponse._();

  factory ListExperimentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExperimentsResponse()..mergeFromBuffer(data, registry);
  factory ListExperimentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExperimentsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExperimentsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListExperimentsResponse.$_createMessage)
    ..pPM<ExperimentSummary>(1, _omitFieldNames ? '' : 'experiments',
        subBuilder: ExperimentSummary.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExperimentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExperimentsResponse copyWith(
          void Function(ListExperimentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListExperimentsResponse))
          as ListExperimentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListExperimentsResponse() / ListExperimentsResponse.new instead')
  static ListExperimentsResponse create() => ListExperimentsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListExperimentsResponse._();
  @$core.override
  ListExperimentsResponse createEmptyInstance() => ListExperimentsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListExperimentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExperimentsResponse>(
          ListExperimentsResponse.$_createMessage);
  static ListExperimentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ExperimentSummary> get experiments => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetExperimentRequest extends $pb.GeneratedMessage {
  factory GetExperimentRequest({
    $core.String? experimentId,
  }) {
    final result = GetExperimentRequest._();
    if (experimentId != null) result.experimentId = experimentId;
    return result;
  }

  GetExperimentRequest._();

  factory GetExperimentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExperimentRequest()..mergeFromBuffer(data, registry);
  factory GetExperimentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExperimentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExperimentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetExperimentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'experimentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExperimentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExperimentRequest copyWith(void Function(GetExperimentRequest) updates) =>
      super.copyWith((message) => updates(message as GetExperimentRequest))
          as GetExperimentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetExperimentRequest() / GetExperimentRequest.new instead')
  static GetExperimentRequest create() => GetExperimentRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetExperimentRequest._();
  @$core.override
  GetExperimentRequest createEmptyInstance() => GetExperimentRequest._();
  @$core.pragma('dart2js:noInline')
  static GetExperimentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExperimentRequest>(
          GetExperimentRequest.$_createMessage);
  static GetExperimentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get experimentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set experimentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExperimentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExperimentId() => $_clearField(1);
}

class GetExperimentResponse extends $pb.GeneratedMessage {
  factory GetExperimentResponse({
    ExperimentSummary? summary,
    ExperimentDefinition? definition,
    ExperimentResult? result,
    $core.String? error,
  }) {
    final result$ = GetExperimentResponse._();
    if (summary != null) result$.summary = summary;
    if (definition != null) result$.definition = definition;
    if (result != null) result$.result = result;
    if (error != null) result$.error = error;
    return result$;
  }

  GetExperimentResponse._();

  factory GetExperimentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExperimentResponse()..mergeFromBuffer(data, registry);
  factory GetExperimentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExperimentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExperimentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetExperimentResponse.$_createMessage)
    ..aOM<ExperimentSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: ExperimentSummary.$_createMessage)
    ..aOM<ExperimentDefinition>(2, _omitFieldNames ? '' : 'definition',
        subBuilder: ExperimentDefinition.$_createMessage)
    ..aOM<ExperimentResult>(3, _omitFieldNames ? '' : 'result',
        subBuilder: ExperimentResult.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExperimentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExperimentResponse copyWith(
          void Function(GetExperimentResponse) updates) =>
      super.copyWith((message) => updates(message as GetExperimentResponse))
          as GetExperimentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetExperimentResponse() / GetExperimentResponse.new instead')
  static GetExperimentResponse create() => GetExperimentResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetExperimentResponse._();
  @$core.override
  GetExperimentResponse createEmptyInstance() => GetExperimentResponse._();
  @$core.pragma('dart2js:noInline')
  static GetExperimentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExperimentResponse>(
          GetExperimentResponse.$_createMessage);
  static GetExperimentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ExperimentSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(ExperimentSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  ExperimentSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  ExperimentDefinition get definition => $_getN(1);
  @$pb.TagNumber(2)
  set definition(ExperimentDefinition value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDefinition() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefinition() => $_clearField(2);
  @$pb.TagNumber(2)
  ExperimentDefinition ensureDefinition() => $_ensure(1);

  @$pb.TagNumber(3)
  ExperimentResult get result => $_getN(2);
  @$pb.TagNumber(3)
  set result(ExperimentResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearResult() => $_clearField(3);
  @$pb.TagNumber(3)
  ExperimentResult ensureResult() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get error => $_getSZ(3);
  @$pb.TagNumber(4)
  set error($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
}

class WatchExperimentRequest extends $pb.GeneratedMessage {
  factory WatchExperimentRequest({
    $core.String? experimentId,
  }) {
    final result = WatchExperimentRequest._();
    if (experimentId != null) result.experimentId = experimentId;
    return result;
  }

  WatchExperimentRequest._();

  factory WatchExperimentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchExperimentRequest()..mergeFromBuffer(data, registry);
  factory WatchExperimentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchExperimentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchExperimentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: WatchExperimentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'experimentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchExperimentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchExperimentRequest copyWith(
          void Function(WatchExperimentRequest) updates) =>
      super.copyWith((message) => updates(message as WatchExperimentRequest))
          as WatchExperimentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchExperimentRequest() / WatchExperimentRequest.new instead')
  static WatchExperimentRequest create() => WatchExperimentRequest._();
  static $pb.GeneratedMessage $_createMessage() => WatchExperimentRequest._();
  @$core.override
  WatchExperimentRequest createEmptyInstance() => WatchExperimentRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchExperimentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchExperimentRequest>(
          WatchExperimentRequest.$_createMessage);
  static WatchExperimentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get experimentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set experimentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExperimentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExperimentId() => $_clearField(1);
}

class WatchExperimentResponse extends $pb.GeneratedMessage {
  factory WatchExperimentResponse({
    $core.String? status,
    AttemptCounts? counts,
    $fixnum.Int64? elapsedSeconds,
    $fixnum.Int64? wallBudgetSeconds,
    $core.int? attemptBudget,
    $core.int? cacheHits,
    $core.int? cacheLooked,
    $core.int? researchSlotsInUse,
    $core.int? researchSlots,
    $0.Metric? bestObjective,
  }) {
    final result = WatchExperimentResponse._();
    if (status != null) result.status = status;
    if (counts != null) result.counts = counts;
    if (elapsedSeconds != null) result.elapsedSeconds = elapsedSeconds;
    if (wallBudgetSeconds != null) result.wallBudgetSeconds = wallBudgetSeconds;
    if (attemptBudget != null) result.attemptBudget = attemptBudget;
    if (cacheHits != null) result.cacheHits = cacheHits;
    if (cacheLooked != null) result.cacheLooked = cacheLooked;
    if (researchSlotsInUse != null)
      result.researchSlotsInUse = researchSlotsInUse;
    if (researchSlots != null) result.researchSlots = researchSlots;
    if (bestObjective != null) result.bestObjective = bestObjective;
    return result;
  }

  WatchExperimentResponse._();

  factory WatchExperimentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchExperimentResponse()..mergeFromBuffer(data, registry);
  factory WatchExperimentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchExperimentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchExperimentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: WatchExperimentResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..aOM<AttemptCounts>(2, _omitFieldNames ? '' : 'counts',
        subBuilder: AttemptCounts.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'elapsedSeconds')
    ..aInt64(4, _omitFieldNames ? '' : 'wallBudgetSeconds')
    ..aI(5, _omitFieldNames ? '' : 'attemptBudget')
    ..aI(6, _omitFieldNames ? '' : 'cacheHits')
    ..aI(7, _omitFieldNames ? '' : 'cacheLooked')
    ..aI(8, _omitFieldNames ? '' : 'researchSlotsInUse')
    ..aI(9, _omitFieldNames ? '' : 'researchSlots')
    ..aOM<$0.Metric>(10, _omitFieldNames ? '' : 'bestObjective',
        subBuilder: $0.Metric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchExperimentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchExperimentResponse copyWith(
          void Function(WatchExperimentResponse) updates) =>
      super.copyWith((message) => updates(message as WatchExperimentResponse))
          as WatchExperimentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchExperimentResponse() / WatchExperimentResponse.new instead')
  static WatchExperimentResponse create() => WatchExperimentResponse._();
  static $pb.GeneratedMessage $_createMessage() => WatchExperimentResponse._();
  @$core.override
  WatchExperimentResponse createEmptyInstance() => WatchExperimentResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchExperimentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchExperimentResponse>(
          WatchExperimentResponse.$_createMessage);
  static WatchExperimentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  AttemptCounts get counts => $_getN(1);
  @$pb.TagNumber(2)
  set counts(AttemptCounts value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCounts() => $_has(1);
  @$pb.TagNumber(2)
  void clearCounts() => $_clearField(2);
  @$pb.TagNumber(2)
  AttemptCounts ensureCounts() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get elapsedSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set elapsedSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasElapsedSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearElapsedSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get wallBudgetSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set wallBudgetSeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWallBudgetSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearWallBudgetSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get attemptBudget => $_getIZ(4);
  @$pb.TagNumber(5)
  set attemptBudget($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAttemptBudget() => $_has(4);
  @$pb.TagNumber(5)
  void clearAttemptBudget() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get cacheHits => $_getIZ(5);
  @$pb.TagNumber(6)
  set cacheHits($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCacheHits() => $_has(5);
  @$pb.TagNumber(6)
  void clearCacheHits() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get cacheLooked => $_getIZ(6);
  @$pb.TagNumber(7)
  set cacheLooked($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCacheLooked() => $_has(6);
  @$pb.TagNumber(7)
  void clearCacheLooked() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get researchSlotsInUse => $_getIZ(7);
  @$pb.TagNumber(8)
  set researchSlotsInUse($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasResearchSlotsInUse() => $_has(7);
  @$pb.TagNumber(8)
  void clearResearchSlotsInUse() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get researchSlots => $_getIZ(8);
  @$pb.TagNumber(9)
  set researchSlots($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasResearchSlots() => $_has(8);
  @$pb.TagNumber(9)
  void clearResearchSlots() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Metric get bestObjective => $_getN(9);
  @$pb.TagNumber(10)
  set bestObjective($0.Metric value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasBestObjective() => $_has(9);
  @$pb.TagNumber(10)
  void clearBestObjective() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Metric ensureBestObjective() => $_ensure(9);
}

class AttemptRow extends $pb.GeneratedMessage {
  factory AttemptRow({
    $core.int? seq,
    $core.int? candidate,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? params,
    $core.String? symbol,
    $core.String? status,
    $core.String? failure,
    $0.Metric? totalReturn,
    $0.Metric? maxDrawdown,
    $0.Metric? trades,
    $core.bool? hasEligibility,
    $core.bool? eligible,
    $core.Iterable<$core.String>? violations,
    $core.String? cache,
    $core.int? runs,
  }) {
    final result = AttemptRow._();
    if (seq != null) result.seq = seq;
    if (candidate != null) result.candidate = candidate;
    if (params != null) result.params.addEntries(params);
    if (symbol != null) result.symbol = symbol;
    if (status != null) result.status = status;
    if (failure != null) result.failure = failure;
    if (totalReturn != null) result.totalReturn = totalReturn;
    if (maxDrawdown != null) result.maxDrawdown = maxDrawdown;
    if (trades != null) result.trades = trades;
    if (hasEligibility != null) result.hasEligibility = hasEligibility;
    if (eligible != null) result.eligible = eligible;
    if (violations != null) result.violations.addAll(violations);
    if (cache != null) result.cache = cache;
    if (runs != null) result.runs = runs;
    return result;
  }

  AttemptRow._();

  factory AttemptRow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttemptRow()..mergeFromBuffer(data, registry);
  factory AttemptRow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttemptRow()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttemptRow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AttemptRow.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seq')
    ..aI(2, _omitFieldNames ? '' : 'candidate')
    ..m<$core.String, $core.double>(3, _omitFieldNames ? '' : 'params',
        entryClassName: 'AttemptRow.ParamsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('lab.v1'))
    ..aOS(4, _omitFieldNames ? '' : 'symbol')
    ..aOS(5, _omitFieldNames ? '' : 'status')
    ..aOS(6, _omitFieldNames ? '' : 'failure')
    ..aOM<$0.Metric>(7, _omitFieldNames ? '' : 'totalReturn',
        subBuilder: $0.Metric.$_createMessage)
    ..aOM<$0.Metric>(8, _omitFieldNames ? '' : 'maxDrawdown',
        subBuilder: $0.Metric.$_createMessage)
    ..aOM<$0.Metric>(9, _omitFieldNames ? '' : 'trades',
        subBuilder: $0.Metric.$_createMessage)
    ..aOB(10, _omitFieldNames ? '' : 'hasEligibility')
    ..aOB(11, _omitFieldNames ? '' : 'eligible')
    ..pPS(12, _omitFieldNames ? '' : 'violations')
    ..aOS(13, _omitFieldNames ? '' : 'cache')
    ..aI(14, _omitFieldNames ? '' : 'runs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttemptRow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttemptRow copyWith(void Function(AttemptRow) updates) =>
      super.copyWith((message) => updates(message as AttemptRow)) as AttemptRow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AttemptRow() / AttemptRow.new instead')
  static AttemptRow create() => AttemptRow._();
  static $pb.GeneratedMessage $_createMessage() => AttemptRow._();
  @$core.override
  AttemptRow createEmptyInstance() => AttemptRow._();
  @$core.pragma('dart2js:noInline')
  static AttemptRow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttemptRow>(AttemptRow.$_createMessage);
  static AttemptRow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get candidate => $_getIZ(1);
  @$pb.TagNumber(2)
  set candidate($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCandidate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCandidate() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.double> get params => $_getMap(2);

  @$pb.TagNumber(4)
  $core.String get symbol => $_getSZ(3);
  @$pb.TagNumber(4)
  set symbol($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSymbol() => $_has(3);
  @$pb.TagNumber(4)
  void clearSymbol() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get status => $_getSZ(4);
  @$pb.TagNumber(5)
  set status($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get failure => $_getSZ(5);
  @$pb.TagNumber(6)
  set failure($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFailure() => $_has(5);
  @$pb.TagNumber(6)
  void clearFailure() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Metric get totalReturn => $_getN(6);
  @$pb.TagNumber(7)
  set totalReturn($0.Metric value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalReturn() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalReturn() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Metric ensureTotalReturn() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Metric get maxDrawdown => $_getN(7);
  @$pb.TagNumber(8)
  set maxDrawdown($0.Metric value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasMaxDrawdown() => $_has(7);
  @$pb.TagNumber(8)
  void clearMaxDrawdown() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Metric ensureMaxDrawdown() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Metric get trades => $_getN(8);
  @$pb.TagNumber(9)
  set trades($0.Metric value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTrades() => $_has(8);
  @$pb.TagNumber(9)
  void clearTrades() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Metric ensureTrades() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.bool get hasEligibility => $_getBF(9);
  @$pb.TagNumber(10)
  set hasEligibility($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHasEligibility() => $_has(9);
  @$pb.TagNumber(10)
  void clearHasEligibility() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get eligible => $_getBF(10);
  @$pb.TagNumber(11)
  set eligible($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEligible() => $_has(10);
  @$pb.TagNumber(11)
  void clearEligible() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get violations => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get cache => $_getSZ(12);
  @$pb.TagNumber(13)
  set cache($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCache() => $_has(12);
  @$pb.TagNumber(13)
  void clearCache() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get runs => $_getIZ(13);
  @$pb.TagNumber(14)
  set runs($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRuns() => $_has(13);
  @$pb.TagNumber(14)
  void clearRuns() => $_clearField(14);
}

class ListAttemptsRequest extends $pb.GeneratedMessage {
  factory ListAttemptsRequest({
    $core.String? experimentId,
    $core.String? status,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = ListAttemptsRequest._();
    if (experimentId != null) result.experimentId = experimentId;
    if (status != null) result.status = status;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListAttemptsRequest._();

  factory ListAttemptsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAttemptsRequest()..mergeFromBuffer(data, registry);
  factory ListAttemptsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAttemptsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAttemptsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListAttemptsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'experimentId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aI(4, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAttemptsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAttemptsRequest copyWith(void Function(ListAttemptsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAttemptsRequest))
          as ListAttemptsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListAttemptsRequest() / ListAttemptsRequest.new instead')
  static ListAttemptsRequest create() => ListAttemptsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListAttemptsRequest._();
  @$core.override
  ListAttemptsRequest createEmptyInstance() => ListAttemptsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListAttemptsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAttemptsRequest>(
          ListAttemptsRequest.$_createMessage);
  static ListAttemptsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get experimentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set experimentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExperimentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExperimentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class ListAttemptsResponse extends $pb.GeneratedMessage {
  factory ListAttemptsResponse({
    $core.Iterable<AttemptRow>? attempts,
    $fixnum.Int64? total,
  }) {
    final result = ListAttemptsResponse._();
    if (attempts != null) result.attempts.addAll(attempts);
    if (total != null) result.total = total;
    return result;
  }

  ListAttemptsResponse._();

  factory ListAttemptsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAttemptsResponse()..mergeFromBuffer(data, registry);
  factory ListAttemptsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAttemptsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAttemptsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ListAttemptsResponse.$_createMessage)
    ..pPM<AttemptRow>(1, _omitFieldNames ? '' : 'attempts',
        subBuilder: AttemptRow.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAttemptsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAttemptsResponse copyWith(void Function(ListAttemptsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAttemptsResponse))
          as ListAttemptsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAttemptsResponse() / ListAttemptsResponse.new instead')
  static ListAttemptsResponse create() => ListAttemptsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListAttemptsResponse._();
  @$core.override
  ListAttemptsResponse createEmptyInstance() => ListAttemptsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListAttemptsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAttemptsResponse>(
          ListAttemptsResponse.$_createMessage);
  static ListAttemptsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AttemptRow> get attempts => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class PauseExperimentRequest extends $pb.GeneratedMessage {
  factory PauseExperimentRequest({
    $core.String? experimentId,
  }) {
    final result = PauseExperimentRequest._();
    if (experimentId != null) result.experimentId = experimentId;
    return result;
  }

  PauseExperimentRequest._();

  factory PauseExperimentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseExperimentRequest()..mergeFromBuffer(data, registry);
  factory PauseExperimentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseExperimentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseExperimentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PauseExperimentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'experimentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseExperimentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseExperimentRequest copyWith(
          void Function(PauseExperimentRequest) updates) =>
      super.copyWith((message) => updates(message as PauseExperimentRequest))
          as PauseExperimentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PauseExperimentRequest() / PauseExperimentRequest.new instead')
  static PauseExperimentRequest create() => PauseExperimentRequest._();
  static $pb.GeneratedMessage $_createMessage() => PauseExperimentRequest._();
  @$core.override
  PauseExperimentRequest createEmptyInstance() => PauseExperimentRequest._();
  @$core.pragma('dart2js:noInline')
  static PauseExperimentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseExperimentRequest>(
          PauseExperimentRequest.$_createMessage);
  static PauseExperimentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get experimentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set experimentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExperimentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExperimentId() => $_clearField(1);
}

class PauseExperimentResponse extends $pb.GeneratedMessage {
  factory PauseExperimentResponse() => PauseExperimentResponse._();

  PauseExperimentResponse._();

  factory PauseExperimentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseExperimentResponse()..mergeFromBuffer(data, registry);
  factory PauseExperimentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseExperimentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseExperimentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: PauseExperimentResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseExperimentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseExperimentResponse copyWith(
          void Function(PauseExperimentResponse) updates) =>
      super.copyWith((message) => updates(message as PauseExperimentResponse))
          as PauseExperimentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PauseExperimentResponse() / PauseExperimentResponse.new instead')
  static PauseExperimentResponse create() => PauseExperimentResponse._();
  static $pb.GeneratedMessage $_createMessage() => PauseExperimentResponse._();
  @$core.override
  PauseExperimentResponse createEmptyInstance() => PauseExperimentResponse._();
  @$core.pragma('dart2js:noInline')
  static PauseExperimentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseExperimentResponse>(
          PauseExperimentResponse.$_createMessage);
  static PauseExperimentResponse? _defaultInstance;
}

class ResumeExperimentRequest extends $pb.GeneratedMessage {
  factory ResumeExperimentRequest({
    $core.String? experimentId,
  }) {
    final result = ResumeExperimentRequest._();
    if (experimentId != null) result.experimentId = experimentId;
    return result;
  }

  ResumeExperimentRequest._();

  factory ResumeExperimentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeExperimentRequest()..mergeFromBuffer(data, registry);
  factory ResumeExperimentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeExperimentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeExperimentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ResumeExperimentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'experimentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeExperimentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeExperimentRequest copyWith(
          void Function(ResumeExperimentRequest) updates) =>
      super.copyWith((message) => updates(message as ResumeExperimentRequest))
          as ResumeExperimentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResumeExperimentRequest() / ResumeExperimentRequest.new instead')
  static ResumeExperimentRequest create() => ResumeExperimentRequest._();
  static $pb.GeneratedMessage $_createMessage() => ResumeExperimentRequest._();
  @$core.override
  ResumeExperimentRequest createEmptyInstance() => ResumeExperimentRequest._();
  @$core.pragma('dart2js:noInline')
  static ResumeExperimentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeExperimentRequest>(
          ResumeExperimentRequest.$_createMessage);
  static ResumeExperimentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get experimentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set experimentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExperimentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExperimentId() => $_clearField(1);
}

class ResumeExperimentResponse extends $pb.GeneratedMessage {
  factory ResumeExperimentResponse() => ResumeExperimentResponse._();

  ResumeExperimentResponse._();

  factory ResumeExperimentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeExperimentResponse()..mergeFromBuffer(data, registry);
  factory ResumeExperimentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeExperimentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeExperimentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ResumeExperimentResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeExperimentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeExperimentResponse copyWith(
          void Function(ResumeExperimentResponse) updates) =>
      super.copyWith((message) => updates(message as ResumeExperimentResponse))
          as ResumeExperimentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResumeExperimentResponse() / ResumeExperimentResponse.new instead')
  static ResumeExperimentResponse create() => ResumeExperimentResponse._();
  static $pb.GeneratedMessage $_createMessage() => ResumeExperimentResponse._();
  @$core.override
  ResumeExperimentResponse createEmptyInstance() =>
      ResumeExperimentResponse._();
  @$core.pragma('dart2js:noInline')
  static ResumeExperimentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeExperimentResponse>(
          ResumeExperimentResponse.$_createMessage);
  static ResumeExperimentResponse? _defaultInstance;
}

class CancelExperimentRequest extends $pb.GeneratedMessage {
  factory CancelExperimentRequest({
    $core.String? experimentId,
  }) {
    final result = CancelExperimentRequest._();
    if (experimentId != null) result.experimentId = experimentId;
    return result;
  }

  CancelExperimentRequest._();

  factory CancelExperimentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelExperimentRequest()..mergeFromBuffer(data, registry);
  factory CancelExperimentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelExperimentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelExperimentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CancelExperimentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'experimentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelExperimentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelExperimentRequest copyWith(
          void Function(CancelExperimentRequest) updates) =>
      super.copyWith((message) => updates(message as CancelExperimentRequest))
          as CancelExperimentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelExperimentRequest() / CancelExperimentRequest.new instead')
  static CancelExperimentRequest create() => CancelExperimentRequest._();
  static $pb.GeneratedMessage $_createMessage() => CancelExperimentRequest._();
  @$core.override
  CancelExperimentRequest createEmptyInstance() => CancelExperimentRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelExperimentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelExperimentRequest>(
          CancelExperimentRequest.$_createMessage);
  static CancelExperimentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get experimentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set experimentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExperimentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExperimentId() => $_clearField(1);
}

class CancelExperimentResponse extends $pb.GeneratedMessage {
  factory CancelExperimentResponse() => CancelExperimentResponse._();

  CancelExperimentResponse._();

  factory CancelExperimentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelExperimentResponse()..mergeFromBuffer(data, registry);
  factory CancelExperimentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelExperimentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelExperimentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: CancelExperimentResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelExperimentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelExperimentResponse copyWith(
          void Function(CancelExperimentResponse) updates) =>
      super.copyWith((message) => updates(message as CancelExperimentResponse))
          as CancelExperimentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelExperimentResponse() / CancelExperimentResponse.new instead')
  static CancelExperimentResponse create() => CancelExperimentResponse._();
  static $pb.GeneratedMessage $_createMessage() => CancelExperimentResponse._();
  @$core.override
  CancelExperimentResponse createEmptyInstance() =>
      CancelExperimentResponse._();
  @$core.pragma('dart2js:noInline')
  static CancelExperimentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelExperimentResponse>(
          CancelExperimentResponse.$_createMessage);
  static CancelExperimentResponse? _defaultInstance;
}

/// ExperimentService: pre-registered experiments, the attempt registry and the
/// research queue. Every attempt is recorded, failed and cancelled ones too.
class ExperimentServiceApi {
  final $pb.RpcClient _client;

  ExperimentServiceApi(this._client);

  /// Validates a definition and counts its attempts without starting anything.
  $async.Future<EstimateResponse> estimate(
          $pb.ClientContext? ctx, EstimateRequest request) =>
      _client.invoke<EstimateResponse>(
          ctx, 'ExperimentService', 'Estimate', request, EstimateResponse());

  /// Locks the definition and queues every attempt.
  $async.Future<CreateExperimentResponse> createExperiment(
          $pb.ClientContext? ctx, CreateExperimentRequest request) =>
      _client.invoke<CreateExperimentResponse>(ctx, 'ExperimentService',
          'CreateExperiment', request, CreateExperimentResponse());
  $async.Future<ListExperimentsResponse> listExperiments(
          $pb.ClientContext? ctx, ListExperimentsRequest request) =>
      _client.invoke<ListExperimentsResponse>(ctx, 'ExperimentService',
          'ListExperiments', request, ListExperimentsResponse());
  $async.Future<GetExperimentResponse> getExperiment(
          $pb.ClientContext? ctx, GetExperimentRequest request) =>
      _client.invoke<GetExperimentResponse>(ctx, 'ExperimentService',
          'GetExperiment', request, GetExperimentResponse());

  /// Progress now, then every second until the experiment ends.
  $async.Future<WatchExperimentResponse> watchExperiment(
          $pb.ClientContext? ctx, WatchExperimentRequest request) =>
      _client.invoke<WatchExperimentResponse>(ctx, 'ExperimentService',
          'WatchExperiment', request, WatchExperimentResponse());
  $async.Future<ListAttemptsResponse> listAttempts(
          $pb.ClientContext? ctx, ListAttemptsRequest request) =>
      _client.invoke<ListAttemptsResponse>(ctx, 'ExperimentService',
          'ListAttempts', request, ListAttemptsResponse());
  $async.Future<PauseExperimentResponse> pauseExperiment(
          $pb.ClientContext? ctx, PauseExperimentRequest request) =>
      _client.invoke<PauseExperimentResponse>(ctx, 'ExperimentService',
          'PauseExperiment', request, PauseExperimentResponse());
  $async.Future<ResumeExperimentResponse> resumeExperiment(
          $pb.ClientContext? ctx, ResumeExperimentRequest request) =>
      _client.invoke<ResumeExperimentResponse>(ctx, 'ExperimentService',
          'ResumeExperiment', request, ResumeExperimentResponse());
  $async.Future<CancelExperimentResponse> cancelExperiment(
          $pb.ClientContext? ctx, CancelExperimentRequest request) =>
      _client.invoke<CancelExperimentResponse>(ctx, 'ExperimentService',
          'CancelExperiment', request, CancelExperimentResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
