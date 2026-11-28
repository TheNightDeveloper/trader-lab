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

import 'package:protobuf/protobuf.dart' as $pb;

class Environment extends $pb.ProtobufEnum {
  static const Environment ENVIRONMENT_UNSPECIFIED =
      Environment._(0, _omitEnumNames ? '' : 'ENVIRONMENT_UNSPECIFIED');
  static const Environment ENVIRONMENT_RESEARCH =
      Environment._(1, _omitEnumNames ? '' : 'ENVIRONMENT_RESEARCH');
  static const Environment ENVIRONMENT_PAPER =
      Environment._(2, _omitEnumNames ? '' : 'ENVIRONMENT_PAPER');
  static const Environment ENVIRONMENT_LIVE =
      Environment._(3, _omitEnumNames ? '' : 'ENVIRONMENT_LIVE');

  static const $core.List<Environment> values = <Environment>[
    ENVIRONMENT_UNSPECIFIED,
    ENVIRONMENT_RESEARCH,
    ENVIRONMENT_PAPER,
    ENVIRONMENT_LIVE,
  ];

  static final $core.List<Environment?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Environment? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Environment._(super.value, super.name);
}

class MarketProduct extends $pb.ProtobufEnum {
  static const MarketProduct MARKET_PRODUCT_UNSPECIFIED =
      MarketProduct._(0, _omitEnumNames ? '' : 'MARKET_PRODUCT_UNSPECIFIED');
  static const MarketProduct MARKET_PRODUCT_SPOT =
      MarketProduct._(1, _omitEnumNames ? '' : 'MARKET_PRODUCT_SPOT');
  static const MarketProduct MARKET_PRODUCT_PERPETUAL =
      MarketProduct._(2, _omitEnumNames ? '' : 'MARKET_PRODUCT_PERPETUAL');

  static const $core.List<MarketProduct> values = <MarketProduct>[
    MARKET_PRODUCT_UNSPECIFIED,
    MARKET_PRODUCT_SPOT,
    MARKET_PRODUCT_PERPETUAL,
  ];

  static final $core.List<MarketProduct?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static MarketProduct? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MarketProduct._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
