// This is a generated file - do not edit.
//
// Generated from lab/v1/market.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'common.pbjson.dart' as $1;
import 'workspace.pbjson.dart' as $0;

@$core.Deprecated('Use getMarketSnapshotRequestDescriptor instead')
const GetMarketSnapshotRequest$json = {
  '1': 'GetMarketSnapshotRequest',
};

/// Descriptor for `GetMarketSnapshotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMarketSnapshotRequestDescriptor =
    $convert.base64Decode('ChhHZXRNYXJrZXRTbmFwc2hvdFJlcXVlc3Q=');

@$core.Deprecated('Use getMarketSnapshotResponseDescriptor instead')
const GetMarketSnapshotResponse$json = {
  '1': 'GetMarketSnapshotResponse',
  '2': [
    {
      '1': 'observed_at_unix_ms',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'observedAtUnixMs'
    },
    {
      '1': 'market_watch',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.MarketWatch',
      '10': 'marketWatch'
    },
  ],
};

/// Descriptor for `GetMarketSnapshotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMarketSnapshotResponseDescriptor = $convert.base64Decode(
    'ChlHZXRNYXJrZXRTbmFwc2hvdFJlc3BvbnNlEi0KE29ic2VydmVkX2F0X3VuaXhfbXMYASABKA'
    'NSEG9ic2VydmVkQXRVbml4TXMSNgoMbWFya2V0X3dhdGNoGAIgAygLMhMubGFiLnYxLk1hcmtl'
    'dFdhdGNoUgttYXJrZXRXYXRjaA==');

@$core.Deprecated('Use marketWatchDescriptor instead')
const MarketWatch$json = {
  '1': 'MarketWatch',
  '2': [
    {
      '1': 'instrument',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.InstrumentKey',
      '10': 'instrument'
    },
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.LiveState',
      '10': 'state'
    },
    {
      '1': 'candle',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.MarketCandle',
      '10': 'candle'
    },
  ],
};

/// Descriptor for `MarketWatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketWatchDescriptor = $convert.base64Decode(
    'CgtNYXJrZXRXYXRjaBI1CgppbnN0cnVtZW50GAEgASgLMhUubGFiLnYxLkluc3RydW1lbnRLZX'
    'lSCmluc3RydW1lbnQSJwoFc3RhdGUYAiABKA4yES5sYWIudjEuTGl2ZVN0YXRlUgVzdGF0ZRIs'
    'CgZjYW5kbGUYAyABKAsyFC5sYWIudjEuTWFya2V0Q2FuZGxlUgZjYW5kbGU=');

@$core.Deprecated('Use marketCandleDescriptor instead')
const MarketCandle$json = {
  '1': 'MarketCandle',
  '2': [
    {'1': 'opened_at_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'openedAtUnixMs'},
    {'1': 'closed_at_unix_ms', '3': 2, '4': 1, '5': 3, '10': 'closedAtUnixMs'},
    {
      '1': 'available_at_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'availableAtUnixMs'
    },
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'close',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'close'
    },
  ],
};

/// Descriptor for `MarketCandle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketCandleDescriptor = $convert.base64Decode(
    'CgxNYXJrZXRDYW5kbGUSKQoRb3BlbmVkX2F0X3VuaXhfbXMYASABKANSDm9wZW5lZEF0VW5peE'
    '1zEikKEWNsb3NlZF9hdF91bml4X21zGAIgASgDUg5jbG9zZWRBdFVuaXhNcxIvChRhdmFpbGFi'
    'bGVfYXRfdW5peF9tcxgDIAEoA1IRYXZhaWxhYmxlQXRVbml4TXMSGgoIcmV2aXNpb24YBCABKA'
    'VSCHJldmlzaW9uEiMKBWNsb3NlGAUgASgLMg0ubGFiLnYxLk1vbmV5UgVjbG9zZQ==');

const $core.Map<$core.String, $core.dynamic> MarketServiceBase$json = {
  '1': 'MarketService',
  '2': [
    {
      '1': 'GetMarketSnapshot',
      '2': '.lab.v1.GetMarketSnapshotRequest',
      '3': '.lab.v1.GetMarketSnapshotResponse'
    },
  ],
};

@$core.Deprecated('Use marketServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    MarketServiceBase$messageJson = {
  '.lab.v1.GetMarketSnapshotRequest': GetMarketSnapshotRequest$json,
  '.lab.v1.GetMarketSnapshotResponse': GetMarketSnapshotResponse$json,
  '.lab.v1.MarketWatch': MarketWatch$json,
  '.lab.v1.InstrumentKey': $0.InstrumentKey$json,
  '.lab.v1.MarketCandle': MarketCandle$json,
  '.lab.v1.Money': $1.Money$json,
};

/// Descriptor for `MarketService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List marketServiceDescriptor = $convert.base64Decode(
    'Cg1NYXJrZXRTZXJ2aWNlElgKEUdldE1hcmtldFNuYXBzaG90EiAubGFiLnYxLkdldE1hcmtldF'
    'NuYXBzaG90UmVxdWVzdBohLmxhYi52MS5HZXRNYXJrZXRTbmFwc2hvdFJlc3BvbnNl');
