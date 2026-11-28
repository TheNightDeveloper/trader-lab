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

import 'package:protobuf/protobuf.dart' as $pb;

class MoneyAvailability extends $pb.ProtobufEnum {
  static const MoneyAvailability MONEY_AVAILABILITY_UNSPECIFIED =
      MoneyAvailability._(
          0, _omitEnumNames ? '' : 'MONEY_AVAILABILITY_UNSPECIFIED');
  static const MoneyAvailability MONEY_AVAILABILITY_MISSING =
      MoneyAvailability._(
          1, _omitEnumNames ? '' : 'MONEY_AVAILABILITY_MISSING');
  static const MoneyAvailability MONEY_AVAILABILITY_INVALID =
      MoneyAvailability._(
          2, _omitEnumNames ? '' : 'MONEY_AVAILABILITY_INVALID');
  static const MoneyAvailability MONEY_AVAILABILITY_STALE =
      MoneyAvailability._(3, _omitEnumNames ? '' : 'MONEY_AVAILABILITY_STALE');

  static const $core.List<MoneyAvailability> values = <MoneyAvailability>[
    MONEY_AVAILABILITY_UNSPECIFIED,
    MONEY_AVAILABILITY_MISSING,
    MONEY_AVAILABILITY_INVALID,
    MONEY_AVAILABILITY_STALE,
  ];

  static final $core.List<MoneyAvailability?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MoneyAvailability? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MoneyAvailability._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
