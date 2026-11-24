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

@$core.Deprecated('Use marketScanStateDescriptor instead')
const MarketScanState$json = {
  '1': 'MarketScanState',
  '2': [
    {'1': 'MARKET_SCAN_STATE_UNSPECIFIED', '2': 0},
    {'1': 'MARKET_SCAN_STATE_MATCH', '2': 1},
    {'1': 'MARKET_SCAN_STATE_NO_MATCH', '2': 2},
    {'1': 'MARKET_SCAN_STATE_INCOMPLETE_DATA', '2': 3},
  ],
};

/// Descriptor for `MarketScanState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List marketScanStateDescriptor = $convert.base64Decode(
    'Cg9NYXJrZXRTY2FuU3RhdGUSIQodTUFSS0VUX1NDQU5fU1RBVEVfVU5TUEVDSUZJRUQQABIbCh'
    'dNQVJLRVRfU0NBTl9TVEFURV9NQVRDSBABEh4KGk1BUktFVF9TQ0FOX1NUQVRFX05PX01BVENI'
    'EAISJQohTUFSS0VUX1NDQU5fU1RBVEVfSU5DT01QTEVURV9EQVRBEAM=');

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
    {
      '1': 'opportunities',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.MarketOpportunity',
      '10': 'opportunities'
    },
  ],
};

/// Descriptor for `GetMarketSnapshotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMarketSnapshotResponseDescriptor = $convert.base64Decode(
    'ChlHZXRNYXJrZXRTbmFwc2hvdFJlc3BvbnNlEi0KE29ic2VydmVkX2F0X3VuaXhfbXMYASABKA'
    'NSEG9ic2VydmVkQXRVbml4TXMSNgoMbWFya2V0X3dhdGNoGAIgAygLMhMubGFiLnYxLk1hcmtl'
    'dFdhdGNoUgttYXJrZXRXYXRjaBI/Cg1vcHBvcnR1bml0aWVzGAMgAygLMhkubGFiLnYxLk1hcm'
    'tldE9wcG9ydHVuaXR5Ug1vcHBvcnR1bml0aWVz');

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

@$core.Deprecated('Use scanMarketOpportunityRequestDescriptor instead')
const ScanMarketOpportunityRequest$json = {
  '1': 'ScanMarketOpportunityRequest',
  '2': [
    {'1': 'rule_version_id', '3': 1, '4': 1, '5': 3, '10': 'ruleVersionId'},
    {'1': 'symbol', '3': 2, '4': 1, '5': 9, '10': 'symbol'},
  ],
};

/// Descriptor for `ScanMarketOpportunityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanMarketOpportunityRequestDescriptor =
    $convert.base64Decode(
        'ChxTY2FuTWFya2V0T3Bwb3J0dW5pdHlSZXF1ZXN0EiYKD3J1bGVfdmVyc2lvbl9pZBgBIAEoA1'
        'INcnVsZVZlcnNpb25JZBIWCgZzeW1ib2wYAiABKAlSBnN5bWJvbA==');

@$core.Deprecated('Use scanMarketOpportunityResponseDescriptor instead')
const ScanMarketOpportunityResponse$json = {
  '1': 'ScanMarketOpportunityResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.MarketScanState',
      '10': 'state'
    },
    {
      '1': 'opportunity',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.MarketOpportunity',
      '10': 'opportunity'
    },
  ],
};

/// Descriptor for `ScanMarketOpportunityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanMarketOpportunityResponseDescriptor =
    $convert.base64Decode(
        'Ch1TY2FuTWFya2V0T3Bwb3J0dW5pdHlSZXNwb25zZRItCgVzdGF0ZRgBIAEoDjIXLmxhYi52MS'
        '5NYXJrZXRTY2FuU3RhdGVSBXN0YXRlEjsKC29wcG9ydHVuaXR5GAIgASgLMhkubGFiLnYxLk1h'
        'cmtldE9wcG9ydHVuaXR5UgtvcHBvcnR1bml0eQ==');

@$core.Deprecated('Use marketOpportunityDescriptor instead')
const MarketOpportunity$json = {
  '1': 'MarketOpportunity',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'symbol', '3': 2, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'rule_version_id', '3': 3, '4': 1, '5': 3, '10': 'ruleVersionId'},
    {'1': 'rule_title', '3': 4, '4': 1, '5': 9, '10': 'ruleTitle'},
    {'1': 'report_id', '3': 5, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'reference_close',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'referenceClose'
    },
    {
      '1': 'candle_closed_at_unix_ms',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'candleClosedAtUnixMs'
    },
    {
      '1': 'observed_at_unix_ms',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'observedAtUnixMs'
    },
    {
      '1': 'expires_at_unix_ms',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'expiresAtUnixMs'
    },
    {'1': 'current', '3': 11, '4': 1, '5': 8, '10': 'current'},
  ],
};

/// Descriptor for `MarketOpportunity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketOpportunityDescriptor = $convert.base64Decode(
    'ChFNYXJrZXRPcHBvcnR1bml0eRIOCgJpZBgBIAEoA1ICaWQSFgoGc3ltYm9sGAIgASgJUgZzeW'
    '1ib2wSJgoPcnVsZV92ZXJzaW9uX2lkGAMgASgDUg1ydWxlVmVyc2lvbklkEh0KCnJ1bGVfdGl0'
    'bGUYBCABKAlSCXJ1bGVUaXRsZRIbCglyZXBvcnRfaWQYBSABKAlSCHJlcG9ydElkEhYKBnJlYX'
    'NvbhgGIAEoCVIGcmVhc29uEjYKD3JlZmVyZW5jZV9jbG9zZRgHIAEoCzINLmxhYi52MS5Nb25l'
    'eVIOcmVmZXJlbmNlQ2xvc2USNgoYY2FuZGxlX2Nsb3NlZF9hdF91bml4X21zGAggASgDUhRjYW'
    '5kbGVDbG9zZWRBdFVuaXhNcxItChNvYnNlcnZlZF9hdF91bml4X21zGAkgASgDUhBvYnNlcnZl'
    'ZEF0VW5peE1zEisKEmV4cGlyZXNfYXRfdW5peF9tcxgKIAEoA1IPZXhwaXJlc0F0VW5peE1zEh'
    'gKB2N1cnJlbnQYCyABKAhSB2N1cnJlbnQ=');

const $core.Map<$core.String, $core.dynamic> MarketServiceBase$json = {
  '1': 'MarketService',
  '2': [
    {
      '1': 'GetMarketSnapshot',
      '2': '.lab.v1.GetMarketSnapshotRequest',
      '3': '.lab.v1.GetMarketSnapshotResponse'
    },
    {
      '1': 'ScanMarketOpportunity',
      '2': '.lab.v1.ScanMarketOpportunityRequest',
      '3': '.lab.v1.ScanMarketOpportunityResponse'
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
  '.lab.v1.MarketOpportunity': MarketOpportunity$json,
  '.lab.v1.ScanMarketOpportunityRequest': ScanMarketOpportunityRequest$json,
  '.lab.v1.ScanMarketOpportunityResponse': ScanMarketOpportunityResponse$json,
};

/// Descriptor for `MarketService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List marketServiceDescriptor = $convert.base64Decode(
    'Cg1NYXJrZXRTZXJ2aWNlElgKEUdldE1hcmtldFNuYXBzaG90EiAubGFiLnYxLkdldE1hcmtldF'
    'NuYXBzaG90UmVxdWVzdBohLmxhYi52MS5HZXRNYXJrZXRTbmFwc2hvdFJlc3BvbnNlEmQKFVNj'
    'YW5NYXJrZXRPcHBvcnR1bml0eRIkLmxhYi52MS5TY2FuTWFya2V0T3Bwb3J0dW5pdHlSZXF1ZX'
    'N0GiUubGFiLnYxLlNjYW5NYXJrZXRPcHBvcnR1bml0eVJlc3BvbnNl');
