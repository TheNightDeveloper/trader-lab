// This is a generated file - do not edit.
//
// Generated from lab/v1/market.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MarketScanState extends $pb.ProtobufEnum {
  static const MarketScanState MARKET_SCAN_STATE_UNSPECIFIED =
      MarketScanState._(
          0, _omitEnumNames ? '' : 'MARKET_SCAN_STATE_UNSPECIFIED');
  static const MarketScanState MARKET_SCAN_STATE_MATCH =
      MarketScanState._(1, _omitEnumNames ? '' : 'MARKET_SCAN_STATE_MATCH');
  static const MarketScanState MARKET_SCAN_STATE_NO_MATCH =
      MarketScanState._(2, _omitEnumNames ? '' : 'MARKET_SCAN_STATE_NO_MATCH');
  static const MarketScanState MARKET_SCAN_STATE_INCOMPLETE_DATA =
      MarketScanState._(
          3, _omitEnumNames ? '' : 'MARKET_SCAN_STATE_INCOMPLETE_DATA');

  static const $core.List<MarketScanState> values = <MarketScanState>[
    MARKET_SCAN_STATE_UNSPECIFIED,
    MARKET_SCAN_STATE_MATCH,
    MARKET_SCAN_STATE_NO_MATCH,
    MARKET_SCAN_STATE_INCOMPLETE_DATA,
  ];

  static final $core.List<MarketScanState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MarketScanState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MarketScanState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
