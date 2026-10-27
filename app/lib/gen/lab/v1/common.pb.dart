// This is a generated file - do not edit.
//
// Generated from lab/v1/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Fixed-point money. value = units × 10^-scale. Clients must parse units as an exact
/// decimal (Dart: package:decimal), never as a float or a web int.
class Money extends $pb.GeneratedMessage {
  factory Money({
    $core.String? units,
    $core.int? scale,
    $core.String? asset,
  }) {
    final result = Money._();
    if (units != null) result.units = units;
    if (scale != null) result.scale = scale;
    if (asset != null) result.asset = asset;
    return result;
  }

  Money._();

  factory Money.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Money()..mergeFromBuffer(data, registry);
  factory Money.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Money()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Money',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Money.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'units')
    ..aI(2, _omitFieldNames ? '' : 'scale')
    ..aOS(3, _omitFieldNames ? '' : 'asset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Money clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Money copyWith(void Function(Money) updates) =>
      super.copyWith((message) => updates(message as Money)) as Money;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Money() / Money.new instead')
  static Money create() => Money._();
  static $pb.GeneratedMessage $_createMessage() => Money._();
  @$core.override
  Money createEmptyInstance() => Money._();
  @$core.pragma('dart2js:noInline')
  static Money getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Money>(Money.$_createMessage);
  static Money? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get units => $_getSZ(0);
  @$pb.TagNumber(1)
  set units($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnits() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnits() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get scale => $_getIZ(1);
  @$pb.TagNumber(2)
  set scale($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScale() => $_has(1);
  @$pb.TagNumber(2)
  void clearScale() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get asset => $_getSZ(2);
  @$pb.TagNumber(3)
  set asset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAsset() => $_has(2);
  @$pb.TagNumber(3)
  void clearAsset() => $_clearField(3);
}

/// Exact fixed-point number that is not money (ratios, Sharpe): units × 10^-scale.
class Decimal extends $pb.GeneratedMessage {
  factory Decimal({
    $core.String? units,
    $core.int? scale,
  }) {
    final result = Decimal._();
    if (units != null) result.units = units;
    if (scale != null) result.scale = scale;
    return result;
  }

  Decimal._();

  factory Decimal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Decimal()..mergeFromBuffer(data, registry);
  factory Decimal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Decimal()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Decimal',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Decimal.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'units')
    ..aI(2, _omitFieldNames ? '' : 'scale')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Decimal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Decimal copyWith(void Function(Decimal) updates) =>
      super.copyWith((message) => updates(message as Decimal)) as Decimal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Decimal() / Decimal.new instead')
  static Decimal create() => Decimal._();
  static $pb.GeneratedMessage $_createMessage() => Decimal._();
  @$core.override
  Decimal createEmptyInstance() => Decimal._();
  @$core.pragma('dart2js:noInline')
  static Decimal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Decimal>(Decimal.$_createMessage);
  static Decimal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get units => $_getSZ(0);
  @$pb.TagNumber(1)
  set units($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnits() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnits() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get scale => $_getIZ(1);
  @$pb.TagNumber(2)
  set scale($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScale() => $_has(1);
  @$pb.TagNumber(2)
  void clearScale() => $_clearField(2);
}

/// A reported number with its validity: invalid metrics carry a reason, not a value.
class Metric extends $pb.GeneratedMessage {
  factory Metric({
    $core.String? key,
    $core.String? group,
    Decimal? value,
    $core.String? unit,
    $core.bool? valid,
    $core.String? invalid,
    $core.String? label,
    $core.String? definition,
  }) {
    final result = Metric._();
    if (key != null) result.key = key;
    if (group != null) result.group = group;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (valid != null) result.valid = valid;
    if (invalid != null) result.invalid = invalid;
    if (label != null) result.label = label;
    if (definition != null) result.definition = definition;
    return result;
  }

  Metric._();

  factory Metric.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Metric()..mergeFromBuffer(data, registry);
  factory Metric.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Metric()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Metric',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: Metric.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'group')
    ..aOM<Decimal>(3, _omitFieldNames ? '' : 'value',
        subBuilder: Decimal.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..aOB(5, _omitFieldNames ? '' : 'valid')
    ..aOS(6, _omitFieldNames ? '' : 'invalid')
    ..aOS(7, _omitFieldNames ? '' : 'label')
    ..aOS(8, _omitFieldNames ? '' : 'definition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metric clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metric copyWith(void Function(Metric) updates) =>
      super.copyWith((message) => updates(message as Metric)) as Metric;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Metric() / Metric.new instead')
  static Metric create() => Metric._();
  static $pb.GeneratedMessage $_createMessage() => Metric._();
  @$core.override
  Metric createEmptyInstance() => Metric._();
  @$core.pragma('dart2js:noInline')
  static Metric getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Metric>(Metric.$_createMessage);
  static Metric? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get group => $_getSZ(1);
  @$pb.TagNumber(2)
  set group($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGroup() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroup() => $_clearField(2);

  @$pb.TagNumber(3)
  Decimal get value => $_getN(2);
  @$pb.TagNumber(3)
  set value(Decimal value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);
  @$pb.TagNumber(3)
  Decimal ensureValue() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get valid => $_getBF(4);
  @$pb.TagNumber(5)
  set valid($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValid() => $_has(4);
  @$pb.TagNumber(5)
  void clearValid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get invalid => $_getSZ(5);
  @$pb.TagNumber(6)
  set invalid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInvalid() => $_has(5);
  @$pb.TagNumber(6)
  void clearInvalid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get label => $_getSZ(6);
  @$pb.TagNumber(7)
  set label($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLabel() => $_has(6);
  @$pb.TagNumber(7)
  void clearLabel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get definition => $_getSZ(7);
  @$pb.TagNumber(8)
  set definition($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDefinition() => $_has(7);
  @$pb.TagNumber(8)
  void clearDefinition() => $_clearField(8);
}

class EquityPoint extends $pb.GeneratedMessage {
  factory EquityPoint({
    $fixnum.Int64? tUnixMs,
    Money? equity,
  }) {
    final result = EquityPoint._();
    if (tUnixMs != null) result.tUnixMs = tUnixMs;
    if (equity != null) result.equity = equity;
    return result;
  }

  EquityPoint._();

  factory EquityPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EquityPoint()..mergeFromBuffer(data, registry);
  factory EquityPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EquityPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EquityPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: EquityPoint.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'tUnixMs')
    ..aOM<Money>(2, _omitFieldNames ? '' : 'equity',
        subBuilder: Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EquityPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EquityPoint copyWith(void Function(EquityPoint) updates) =>
      super.copyWith((message) => updates(message as EquityPoint))
          as EquityPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EquityPoint() / EquityPoint.new instead')
  static EquityPoint create() => EquityPoint._();
  static $pb.GeneratedMessage $_createMessage() => EquityPoint._();
  @$core.override
  EquityPoint createEmptyInstance() => EquityPoint._();
  @$core.pragma('dart2js:noInline')
  static EquityPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EquityPoint>(
          EquityPoint.$_createMessage);
  static EquityPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get tUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set tUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  Money get equity => $_getN(1);
  @$pb.TagNumber(2)
  set equity(Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEquity() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquity() => $_clearField(2);
  @$pb.TagNumber(2)
  Money ensureEquity() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
