// This is a generated file - do not edit.
//
// Generated from lab/v1/chart.proto.

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

@$core.Deprecated('Use getChartRequestDescriptor instead')
const GetChartRequest$json = {
  '1': 'GetChartRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'symbol', '3': 2, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'timeframe', '3': 3, '4': 1, '5': 9, '10': 'timeframe'},
    {'1': 'indicators', '3': 4, '4': 3, '5': 9, '10': 'indicators'},
    {'1': 'max_bars', '3': 5, '4': 1, '5': 5, '10': 'maxBars'},
  ],
};

/// Descriptor for `GetChartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChartRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRDaGFydFJlcXVlc3QSGwoJcmVwb3J0X2lkGAEgASgJUghyZXBvcnRJZBIWCgZzeW1ib2'
    'wYAiABKAlSBnN5bWJvbBIcCgl0aW1lZnJhbWUYAyABKAlSCXRpbWVmcmFtZRIeCgppbmRpY2F0'
    'b3JzGAQgAygJUgppbmRpY2F0b3JzEhkKCG1heF9iYXJzGAUgASgFUgdtYXhCYXJz');

@$core.Deprecated('Use chartBarDescriptor instead')
const ChartBar$json = {
  '1': 'ChartBar',
  '2': [
    {'1': 'open_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'openUnixMs'},
    {
      '1': 'open',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'open'
    },
    {
      '1': 'high',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'high'
    },
    {'1': 'low', '3': 4, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'low'},
    {
      '1': 'close',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'close'
    },
    {
      '1': 'volume',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'volume'
    },
  ],
};

/// Descriptor for `ChartBar`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartBarDescriptor = $convert.base64Decode(
    'CghDaGFydEJhchIgCgxvcGVuX3VuaXhfbXMYASABKANSCm9wZW5Vbml4TXMSIwoEb3BlbhgCIA'
    'EoCzIPLmxhYi52MS5EZWNpbWFsUgRvcGVuEiMKBGhpZ2gYAyABKAsyDy5sYWIudjEuRGVjaW1h'
    'bFIEaGlnaBIhCgNsb3cYBCABKAsyDy5sYWIudjEuRGVjaW1hbFIDbG93EiUKBWNsb3NlGAUgAS'
    'gLMg8ubGFiLnYxLkRlY2ltYWxSBWNsb3NlEicKBnZvbHVtZRgGIAEoCzIPLmxhYi52MS5EZWNp'
    'bWFsUgZ2b2x1bWU=');

@$core.Deprecated('Use indicatorLineDescriptor instead')
const IndicatorLine$json = {
  '1': 'IndicatorLine',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'values', '3': 2, '4': 3, '5': 9, '10': 'values'},
  ],
};

/// Descriptor for `IndicatorLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List indicatorLineDescriptor = $convert.base64Decode(
    'Cg1JbmRpY2F0b3JMaW5lEhIKBG5hbWUYASABKAlSBG5hbWUSFgoGdmFsdWVzGAIgAygJUgZ2YW'
    'x1ZXM=');

@$core.Deprecated('Use chartIndicatorDescriptor instead')
const ChartIndicator$json = {
  '1': 'ChartIndicator',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'pane', '3': 3, '4': 1, '5': 9, '10': 'pane'},
    {
      '1': 'lines',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.IndicatorLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `ChartIndicator`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartIndicatorDescriptor = $convert.base64Decode(
    'Cg5DaGFydEluZGljYXRvchIQCgNrZXkYASABKAlSA2tleRIUCgVsYWJlbBgCIAEoCVIFbGFiZW'
    'wSEgoEcGFuZRgDIAEoCVIEcGFuZRIrCgVsaW5lcxgEIAMoCzIVLmxhYi52MS5JbmRpY2F0b3JM'
    'aW5lUgVsaW5lcw==');

@$core.Deprecated('Use chartMarkerDescriptor instead')
const ChartMarker$json = {
  '1': 'ChartMarker',
  '2': [
    {'1': 'decision_id', '3': 1, '4': 1, '5': 5, '10': 'decisionId'},
    {'1': 'bar_open_unix_ms', '3': 2, '4': 1, '5': 3, '10': 'barOpenUnixMs'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {
      '1': 'price',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'price'
    },
    {'1': 'detail', '3': 5, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `ChartMarker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartMarkerDescriptor = $convert.base64Decode(
    'CgtDaGFydE1hcmtlchIfCgtkZWNpc2lvbl9pZBgBIAEoBVIKZGVjaXNpb25JZBInChBiYXJfb3'
    'Blbl91bml4X21zGAIgASgDUg1iYXJPcGVuVW5peE1zEhIKBGtpbmQYAyABKAlSBGtpbmQSJQoF'
    'cHJpY2UYBCABKAsyDy5sYWIudjEuRGVjaW1hbFIFcHJpY2USFgoGZGV0YWlsGAUgASgJUgZkZX'
    'RhaWw=');

@$core.Deprecated('Use getChartResponseDescriptor instead')
const GetChartResponse$json = {
  '1': 'GetChartResponse',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'timeframe', '3': 2, '4': 1, '5': 9, '10': 'timeframe'},
    {'1': 'price_precision', '3': 3, '4': 1, '5': 5, '10': 'pricePrecision'},
    {
      '1': 'bars',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ChartBar',
      '10': 'bars'
    },
    {
      '1': 'indicators',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ChartIndicator',
      '10': 'indicators'
    },
    {
      '1': 'markers',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ChartMarker',
      '10': 'markers'
    },
    {'1': 'report_title', '3': 7, '4': 1, '5': 9, '10': 'reportTitle'},
    {'1': 'symbols', '3': 8, '4': 3, '5': 9, '10': 'symbols'},
    {'1': 'total_bars', '3': 9, '4': 1, '5': 5, '10': 'totalBars'},
  ],
};

/// Descriptor for `GetChartResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChartResponseDescriptor = $convert.base64Decode(
    'ChBHZXRDaGFydFJlc3BvbnNlEhYKBnN5bWJvbBgBIAEoCVIGc3ltYm9sEhwKCXRpbWVmcmFtZR'
    'gCIAEoCVIJdGltZWZyYW1lEicKD3ByaWNlX3ByZWNpc2lvbhgDIAEoBVIOcHJpY2VQcmVjaXNp'
    'b24SJAoEYmFycxgEIAMoCzIQLmxhYi52MS5DaGFydEJhclIEYmFycxI2CgppbmRpY2F0b3JzGA'
    'UgAygLMhYubGFiLnYxLkNoYXJ0SW5kaWNhdG9yUgppbmRpY2F0b3JzEi0KB21hcmtlcnMYBiAD'
    'KAsyEy5sYWIudjEuQ2hhcnRNYXJrZXJSB21hcmtlcnMSIQoMcmVwb3J0X3RpdGxlGAcgASgJUg'
    'tyZXBvcnRUaXRsZRIYCgdzeW1ib2xzGAggAygJUgdzeW1ib2xzEh0KCnRvdGFsX2JhcnMYCSAB'
    'KAVSCXRvdGFsQmFycw==');

@$core.Deprecated('Use getDecisionRequestDescriptor instead')
const GetDecisionRequest$json = {
  '1': 'GetDecisionRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'decision_id', '3': 2, '4': 1, '5': 5, '10': 'decisionId'},
  ],
};

/// Descriptor for `GetDecisionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDecisionRequestDescriptor = $convert.base64Decode(
    'ChJHZXREZWNpc2lvblJlcXVlc3QSGwoJcmVwb3J0X2lkGAEgASgJUghyZXBvcnRJZBIfCgtkZW'
    'Npc2lvbl9pZBgCIAEoBVIKZGVjaXNpb25JZA==');

@$core.Deprecated('Use getDecisionResponseDescriptor instead')
const GetDecisionResponse$json = {
  '1': 'GetDecisionResponse',
  '2': [
    {
      '1': 'decision',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.DecisionRow',
      '10': 'decision'
    },
    {
      '1': 'ref_price',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'refPrice'
    },
  ],
};

/// Descriptor for `GetDecisionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDecisionResponseDescriptor = $convert.base64Decode(
    'ChNHZXREZWNpc2lvblJlc3BvbnNlEi8KCGRlY2lzaW9uGAEgASgLMhMubGFiLnYxLkRlY2lzaW'
    '9uUm93UghkZWNpc2lvbhIqCglyZWZfcHJpY2UYAiABKAsyDS5sYWIudjEuTW9uZXlSCHJlZlBy'
    'aWNl');

const $core.Map<$core.String, $core.dynamic> ChartServiceBase$json = {
  '1': 'ChartService',
  '2': [
    {
      '1': 'GetChart',
      '2': '.lab.v1.GetChartRequest',
      '3': '.lab.v1.GetChartResponse'
    },
    {
      '1': 'GetDecision',
      '2': '.lab.v1.GetDecisionRequest',
      '3': '.lab.v1.GetDecisionResponse'
    },
  ],
};

@$core.Deprecated('Use chartServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ChartServiceBase$messageJson = {
  '.lab.v1.GetChartRequest': GetChartRequest$json,
  '.lab.v1.GetChartResponse': GetChartResponse$json,
  '.lab.v1.ChartBar': ChartBar$json,
  '.lab.v1.Decimal': $0.Decimal$json,
  '.lab.v1.ChartIndicator': ChartIndicator$json,
  '.lab.v1.IndicatorLine': IndicatorLine$json,
  '.lab.v1.ChartMarker': ChartMarker$json,
  '.lab.v1.GetDecisionRequest': GetDecisionRequest$json,
  '.lab.v1.GetDecisionResponse': GetDecisionResponse$json,
  '.lab.v1.DecisionRow': $1.DecisionRow$json,
  '.lab.v1.Money': $0.Money$json,
};

/// Descriptor for `ChartService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List chartServiceDescriptor = $convert.base64Decode(
    'CgxDaGFydFNlcnZpY2USPQoIR2V0Q2hhcnQSFy5sYWIudjEuR2V0Q2hhcnRSZXF1ZXN0GhgubG'
    'FiLnYxLkdldENoYXJ0UmVzcG9uc2USRgoLR2V0RGVjaXNpb24SGi5sYWIudjEuR2V0RGVjaXNp'
    'b25SZXF1ZXN0GhsubGFiLnYxLkdldERlY2lzaW9uUmVzcG9uc2U=');
