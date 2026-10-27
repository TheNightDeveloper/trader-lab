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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
