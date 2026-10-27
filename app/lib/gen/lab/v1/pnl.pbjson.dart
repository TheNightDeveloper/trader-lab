// This is a generated file - do not edit.
//
// Generated from lab/v1/pnl.proto.

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

import 'common.pbjson.dart' as $0;
import 'report.pbjson.dart' as $1;

@$core.Deprecated('Use recalculateRequestDescriptor instead')
const RecalculateRequest$json = {
  '1': 'RecalculateRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {
      '1': 'capital',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'capital'
    },
    {
      '1': 'position_size',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'positionSize'
    },
    {'1': 'fee', '3': 4, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'fee'},
    {
      '1': 'slippage',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'slippage'
    },
    {'1': 'fx_rate_id', '3': 6, '4': 1, '5': 3, '10': 'fxRateId'},
  ],
};

/// Descriptor for `RecalculateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recalculateRequestDescriptor = $convert.base64Decode(
    'ChJSZWNhbGN1bGF0ZVJlcXVlc3QSGwoJcmVwb3J0X2lkGAEgASgJUghyZXBvcnRJZBInCgdjYX'
    'BpdGFsGAIgASgLMg0ubGFiLnYxLk1vbmV5UgdjYXBpdGFsEjQKDXBvc2l0aW9uX3NpemUYAyAB'
    'KAsyDy5sYWIudjEuRGVjaW1hbFIMcG9zaXRpb25TaXplEiEKA2ZlZRgEIAEoCzIPLmxhYi52MS'
    '5EZWNpbWFsUgNmZWUSKwoIc2xpcHBhZ2UYBSABKAsyDy5sYWIudjEuRGVjaW1hbFIIc2xpcHBh'
    'Z2USHAoKZnhfcmF0ZV9pZBgGIAEoA1IIZnhSYXRlSWQ=');

@$core.Deprecated('Use waterfallDescriptor instead')
const Waterfall$json = {
  '1': 'Waterfall',
  '2': [
    {
      '1': 'gross',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'gross'
    },
    {'1': 'fees', '3': 2, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'fees'},
    {
      '1': 'slippage',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'slippage'
    },
    {'1': 'net', '3': 4, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'net'},
  ],
};

/// Descriptor for `Waterfall`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waterfallDescriptor = $convert.base64Decode(
    'CglXYXRlcmZhbGwSIwoFZ3Jvc3MYASABKAsyDS5sYWIudjEuTW9uZXlSBWdyb3NzEiEKBGZlZX'
    'MYAiABKAsyDS5sYWIudjEuTW9uZXlSBGZlZXMSKQoIc2xpcHBhZ2UYAyABKAsyDS5sYWIudjEu'
    'TW9uZXlSCHNsaXBwYWdlEh8KA25ldBgEIAEoCzINLmxhYi52MS5Nb25leVIDbmV0');

@$core.Deprecated('Use recalculateResponseDescriptor instead')
const RecalculateResponse$json = {
  '1': 'RecalculateResponse',
  '2': [
    {
      '1': 'capital',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'capital'
    },
    {
      '1': 'position_size',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'positionSize'
    },
    {'1': 'fee', '3': 3, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'fee'},
    {
      '1': 'slippage',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'slippage'
    },
    {
      '1': 'waterfall',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Waterfall',
      '10': 'waterfall'
    },
    {
      '1': 'metrics',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'metrics'
    },
    {
      '1': 'equity',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.EquityPoint',
      '10': 'equity'
    },
    {
      '1': 'trades',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.TradeRow',
      '10': 'trades'
    },
    {
      '1': 'break_even_fee',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'breakEvenFee'
    },
    {'1': 'verdict', '3': 10, '4': 1, '5': 9, '10': 'verdict'},
    {'1': 'tone', '3': 11, '4': 1, '5': 9, '10': 'tone'},
    {'1': 'sentence', '3': 12, '4': 1, '5': 9, '10': 'sentence'},
    {
      '1': 'original_net',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'originalNet'
    },
    {
      '1': 'net_toman',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'netToman'
    },
    {
      '1': 'final_equity_toman',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'finalEquityToman'
    },
  ],
};

/// Descriptor for `RecalculateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recalculateResponseDescriptor = $convert.base64Decode(
    'ChNSZWNhbGN1bGF0ZVJlc3BvbnNlEicKB2NhcGl0YWwYASABKAsyDS5sYWIudjEuTW9uZXlSB2'
    'NhcGl0YWwSNAoNcG9zaXRpb25fc2l6ZRgCIAEoCzIPLmxhYi52MS5EZWNpbWFsUgxwb3NpdGlv'
    'blNpemUSIQoDZmVlGAMgASgLMg8ubGFiLnYxLkRlY2ltYWxSA2ZlZRIrCghzbGlwcGFnZRgEIA'
    'EoCzIPLmxhYi52MS5EZWNpbWFsUghzbGlwcGFnZRIvCgl3YXRlcmZhbGwYBSABKAsyES5sYWIu'
    'djEuV2F0ZXJmYWxsUgl3YXRlcmZhbGwSKAoHbWV0cmljcxgGIAMoCzIOLmxhYi52MS5NZXRyaW'
    'NSB21ldHJpY3MSKwoGZXF1aXR5GAcgAygLMhMubGFiLnYxLkVxdWl0eVBvaW50UgZlcXVpdHkS'
    'KAoGdHJhZGVzGAggAygLMhAubGFiLnYxLlRyYWRlUm93UgZ0cmFkZXMSNQoOYnJlYWtfZXZlbl'
    '9mZWUYCSABKAsyDy5sYWIudjEuRGVjaW1hbFIMYnJlYWtFdmVuRmVlEhgKB3ZlcmRpY3QYCiAB'
    'KAlSB3ZlcmRpY3QSEgoEdG9uZRgLIAEoCVIEdG9uZRIaCghzZW50ZW5jZRgMIAEoCVIIc2VudG'
    'VuY2USMAoMb3JpZ2luYWxfbmV0GA0gASgLMg0ubGFiLnYxLk1vbmV5UgtvcmlnaW5hbE5ldBIq'
    'CgluZXRfdG9tYW4YDiABKAsyDS5sYWIudjEuTW9uZXlSCG5ldFRvbWFuEjsKEmZpbmFsX2VxdW'
    'l0eV90b21hbhgPIAEoCzINLmxhYi52MS5Nb25leVIQZmluYWxFcXVpdHlUb21hbg==');

@$core.Deprecated('Use calculateTradeRequestDescriptor instead')
const CalculateTradeRequest$json = {
  '1': 'CalculateTradeRequest',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'entry'
    },
    {'1': 'exit', '3': 2, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'exit'},
    {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'amount'
    },
    {'1': 'fee', '3': 4, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'fee'},
    {
      '1': 'slippage',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'slippage'
    },
    {'1': 'fx_rate_id', '3': 6, '4': 1, '5': 3, '10': 'fxRateId'},
  ],
};

/// Descriptor for `CalculateTradeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateTradeRequestDescriptor = $convert.base64Decode(
    'ChVDYWxjdWxhdGVUcmFkZVJlcXVlc3QSIwoFZW50cnkYASABKAsyDS5sYWIudjEuTW9uZXlSBW'
    'VudHJ5EiEKBGV4aXQYAiABKAsyDS5sYWIudjEuTW9uZXlSBGV4aXQSJQoGYW1vdW50GAMgASgL'
    'Mg0ubGFiLnYxLk1vbmV5UgZhbW91bnQSIQoDZmVlGAQgASgLMg8ubGFiLnYxLkRlY2ltYWxSA2'
    'ZlZRIrCghzbGlwcGFnZRgFIAEoCzIPLmxhYi52MS5EZWNpbWFsUghzbGlwcGFnZRIcCgpmeF9y'
    'YXRlX2lkGAYgASgDUghmeFJhdGVJZA==');

@$core.Deprecated('Use tradeLegDescriptor instead')
const TradeLeg$json = {
  '1': 'TradeLeg',
  '2': [
    {
      '1': 'ref_price',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'refPrice'
    },
    {
      '1': 'price',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'price'
    },
    {
      '1': 'ref_value',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'refValue'
    },
    {
      '1': 'value',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'value'
    },
    {
      '1': 'slippage',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'slippage'
    },
    {'1': 'fee', '3': 6, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'fee'},
  ],
};

/// Descriptor for `TradeLeg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tradeLegDescriptor = $convert.base64Decode(
    'CghUcmFkZUxlZxIqCglyZWZfcHJpY2UYASABKAsyDS5sYWIudjEuTW9uZXlSCHJlZlByaWNlEi'
    'MKBXByaWNlGAIgASgLMg0ubGFiLnYxLk1vbmV5UgVwcmljZRIqCglyZWZfdmFsdWUYAyABKAsy'
    'DS5sYWIudjEuTW9uZXlSCHJlZlZhbHVlEiMKBXZhbHVlGAQgASgLMg0ubGFiLnYxLk1vbmV5Ug'
    'V2YWx1ZRIpCghzbGlwcGFnZRgFIAEoCzINLmxhYi52MS5Nb25leVIIc2xpcHBhZ2USHwoDZmVl'
    'GAYgASgLMg0ubGFiLnYxLk1vbmV5UgNmZWU=');

@$core.Deprecated('Use calculateTradeResponseDescriptor instead')
const CalculateTradeResponse$json = {
  '1': 'CalculateTradeResponse',
  '2': [
    {'1': 'qty', '3': 1, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'qty'},
    {'1': 'buy', '3': 2, '4': 1, '5': 11, '6': '.lab.v1.TradeLeg', '10': 'buy'},
    {
      '1': 'sell',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.TradeLeg',
      '10': 'sell'
    },
    {
      '1': 'waterfall',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Waterfall',
      '10': 'waterfall'
    },
    {'1': 'cost', '3': 5, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'cost'},
    {
      '1': 'return',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'return'
    },
    {
      '1': 'break_even_exit',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'breakEvenExit'
    },
    {'1': 'verdict', '3': 8, '4': 1, '5': 9, '10': 'verdict'},
    {'1': 'tone', '3': 9, '4': 1, '5': 9, '10': 'tone'},
    {'1': 'sentence', '3': 10, '4': 1, '5': 9, '10': 'sentence'},
    {
      '1': 'net_toman',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'netToman'
    },
  ],
};

/// Descriptor for `CalculateTradeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateTradeResponseDescriptor = $convert.base64Decode(
    'ChZDYWxjdWxhdGVUcmFkZVJlc3BvbnNlEiEKA3F0eRgBIAEoCzIPLmxhYi52MS5EZWNpbWFsUg'
    'NxdHkSIgoDYnV5GAIgASgLMhAubGFiLnYxLlRyYWRlTGVnUgNidXkSJAoEc2VsbBgDIAEoCzIQ'
    'LmxhYi52MS5UcmFkZUxlZ1IEc2VsbBIvCgl3YXRlcmZhbGwYBCABKAsyES5sYWIudjEuV2F0ZX'
    'JmYWxsUgl3YXRlcmZhbGwSIQoEY29zdBgFIAEoCzINLmxhYi52MS5Nb25leVIEY29zdBInCgZy'
    'ZXR1cm4YBiABKAsyDy5sYWIudjEuRGVjaW1hbFIGcmV0dXJuEjUKD2JyZWFrX2V2ZW5fZXhpdB'
    'gHIAEoCzINLmxhYi52MS5Nb25leVINYnJlYWtFdmVuRXhpdBIYCgd2ZXJkaWN0GAggASgJUgd2'
    'ZXJkaWN0EhIKBHRvbmUYCSABKAlSBHRvbmUSGgoIc2VudGVuY2UYCiABKAlSCHNlbnRlbmNlEi'
    'oKCW5ldF90b21hbhgLIAEoCzINLmxhYi52MS5Nb25leVIIbmV0VG9tYW4=');

const $core.Map<$core.String, $core.dynamic> PnlServiceBase$json = {
  '1': 'PnlService',
  '2': [
    {
      '1': 'Recalculate',
      '2': '.lab.v1.RecalculateRequest',
      '3': '.lab.v1.RecalculateResponse'
    },
    {
      '1': 'CalculateTrade',
      '2': '.lab.v1.CalculateTradeRequest',
      '3': '.lab.v1.CalculateTradeResponse'
    },
  ],
};

@$core.Deprecated('Use pnlServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    PnlServiceBase$messageJson = {
  '.lab.v1.RecalculateRequest': RecalculateRequest$json,
  '.lab.v1.Money': $0.Money$json,
  '.lab.v1.Decimal': $0.Decimal$json,
  '.lab.v1.RecalculateResponse': RecalculateResponse$json,
  '.lab.v1.Waterfall': Waterfall$json,
  '.lab.v1.Metric': $0.Metric$json,
  '.lab.v1.EquityPoint': $0.EquityPoint$json,
  '.lab.v1.TradeRow': $1.TradeRow$json,
  '.lab.v1.CalculateTradeRequest': CalculateTradeRequest$json,
  '.lab.v1.CalculateTradeResponse': CalculateTradeResponse$json,
  '.lab.v1.TradeLeg': TradeLeg$json,
};

/// Descriptor for `PnlService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List pnlServiceDescriptor = $convert.base64Decode(
    'CgpQbmxTZXJ2aWNlEkYKC1JlY2FsY3VsYXRlEhoubGFiLnYxLlJlY2FsY3VsYXRlUmVxdWVzdB'
    'obLmxhYi52MS5SZWNhbGN1bGF0ZVJlc3BvbnNlEk8KDkNhbGN1bGF0ZVRyYWRlEh0ubGFiLnYx'
    'LkNhbGN1bGF0ZVRyYWRlUmVxdWVzdBoeLmxhYi52MS5DYWxjdWxhdGVUcmFkZVJlc3BvbnNl');
