// This is a generated file - do not edit.
//
// Generated from lab/v1/report.proto.

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

@$core.Deprecated('Use paramSpecDescriptor instead')
const ParamSpec$json = {
  '1': 'ParamSpec',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'default', '3': 2, '4': 1, '5': 1, '10': 'default'},
    {'1': 'integer', '3': 3, '4': 1, '5': 8, '10': 'integer'},
  ],
};

/// Descriptor for `ParamSpec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paramSpecDescriptor =
    $convert.base64Decode('CglQYXJhbVNwZWMSEgoEbmFtZRgBIAEoCVIEbmFtZRIYCgdkZWZhdWx0GAIgASgBUgdkZWZhdW'
        'x0EhgKB2ludGVnZXIYAyABKAhSB2ludGVnZXI=');

@$core.Deprecated('Use strategyInfoDescriptor instead')
const StrategyInfo$json = {
  '1': 'StrategyInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'params', '3': 2, '4': 3, '5': 11, '6': '.lab.v1.ParamSpec', '10': 'params'},
  ],
};

/// Descriptor for `StrategyInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List strategyInfoDescriptor =
    $convert.base64Decode('CgxTdHJhdGVneUluZm8SEgoEbmFtZRgBIAEoCVIEbmFtZRIpCgZwYXJhbXMYAiADKAsyES5sYW'
        'IudjEuUGFyYW1TcGVjUgZwYXJhbXM=');

@$core.Deprecated('Use listStrategiesRequestDescriptor instead')
const ListStrategiesRequest$json = {
  '1': 'ListStrategiesRequest',
};

/// Descriptor for `ListStrategiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStrategiesRequestDescriptor = $convert.base64Decode('ChVMaXN0U3RyYXRlZ2llc1JlcXVlc3Q=');

@$core.Deprecated('Use listStrategiesResponseDescriptor instead')
const ListStrategiesResponse$json = {
  '1': 'ListStrategiesResponse',
  '2': [
    {'1': 'strategies', '3': 1, '4': 3, '5': 11, '6': '.lab.v1.StrategyInfo', '10': 'strategies'},
  ],
};

/// Descriptor for `ListStrategiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStrategiesResponseDescriptor =
    $convert.base64Decode('ChZMaXN0U3RyYXRlZ2llc1Jlc3BvbnNlEjQKCnN0cmF0ZWdpZXMYASADKAsyFC5sYWIudjEuU3'
        'RyYXRlZ3lJbmZvUgpzdHJhdGVnaWVz');

@$core.Deprecated('Use reportSpecDescriptor instead')
const ReportSpec$json = {
  '1': 'ReportSpec',
  '2': [
    {'1': 'dataset_ids', '3': 1, '4': 3, '5': 9, '10': 'datasetIds'},
    {'1': 'timeframe', '3': 2, '4': 1, '5': 9, '10': 'timeframe'},
    {'1': 'strategy', '3': 3, '4': 1, '5': 9, '10': 'strategy'},
    {'1': 'params', '3': 4, '4': 3, '5': 11, '6': '.lab.v1.ReportSpec.ParamsEntry', '10': 'params'},
    {'1': 'capital', '3': 5, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'capital'},
    {'1': 'fee', '3': 6, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'fee'},
    {'1': 'slippage', '3': 7, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'slippage'},
    {'1': 'sizing', '3': 8, '4': 1, '5': 9, '10': 'sizing'},
    {'1': 'fixed_usdt', '3': 9, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'fixedUsdt'},
    {'1': 'latency_bars', '3': 10, '4': 1, '5': 5, '10': 'latencyBars'},
    {'1': 'folds', '3': 11, '4': 1, '5': 5, '10': 'folds'},
    {'1': 'rolling', '3': 12, '4': 1, '5': 8, '10': 'rolling'},
    {'1': 'holdout', '3': 13, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'holdout'},
    {'1': 'embargo_seconds', '3': 14, '4': 1, '5': 3, '10': 'embargoSeconds'},
    {'1': 'engine_version', '3': 15, '4': 1, '5': 9, '10': 'engineVersion'},
  ],
  '3': [ReportSpec_ParamsEntry$json],
};

@$core.Deprecated('Use reportSpecDescriptor instead')
const ReportSpec_ParamsEntry$json = {
  '1': 'ParamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ReportSpec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportSpecDescriptor =
    $convert.base64Decode('CgpSZXBvcnRTcGVjEh8KC2RhdGFzZXRfaWRzGAEgAygJUgpkYXRhc2V0SWRzEhwKCXRpbWVmcm'
        'FtZRgCIAEoCVIJdGltZWZyYW1lEhoKCHN0cmF0ZWd5GAMgASgJUghzdHJhdGVneRI2CgZwYXJh'
        'bXMYBCADKAsyHi5sYWIudjEuUmVwb3J0U3BlYy5QYXJhbXNFbnRyeVIGcGFyYW1zEicKB2NhcG'
        'l0YWwYBSABKAsyDS5sYWIudjEuTW9uZXlSB2NhcGl0YWwSIQoDZmVlGAYgASgLMg8ubGFiLnYx'
        'LkRlY2ltYWxSA2ZlZRIrCghzbGlwcGFnZRgHIAEoCzIPLmxhYi52MS5EZWNpbWFsUghzbGlwcG'
        'FnZRIWCgZzaXppbmcYCCABKAlSBnNpemluZxIsCgpmaXhlZF91c2R0GAkgASgLMg0ubGFiLnYx'
        'Lk1vbmV5UglmaXhlZFVzZHQSIQoMbGF0ZW5jeV9iYXJzGAogASgFUgtsYXRlbmN5QmFycxIUCg'
        'Vmb2xkcxgLIAEoBVIFZm9sZHMSGAoHcm9sbGluZxgMIAEoCFIHcm9sbGluZxIpCgdob2xkb3V0'
        'GA0gASgLMg8ubGFiLnYxLkRlY2ltYWxSB2hvbGRvdXQSJwoPZW1iYXJnb19zZWNvbmRzGA4gAS'
        'gDUg5lbWJhcmdvU2Vjb25kcxIlCg5lbmdpbmVfdmVyc2lvbhgPIAEoCVINZW5naW5lVmVyc2lv'
        'bho5CgtQYXJhbXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdW'
        'U6AjgB');

@$core.Deprecated('Use createReportRequestDescriptor instead')
const CreateReportRequest$json = {
  '1': 'CreateReportRequest',
  '2': [
    {'1': 'spec', '3': 1, '4': 1, '5': 11, '6': '.lab.v1.ReportSpec', '10': 'spec'},
  ],
};

/// Descriptor for `CreateReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createReportRequestDescriptor =
    $convert.base64Decode('ChNDcmVhdGVSZXBvcnRSZXF1ZXN0EiYKBHNwZWMYASABKAsyEi5sYWIudjEuUmVwb3J0U3BlY1'
        'IEc3BlYw==');

@$core.Deprecated('Use createReportResponseDescriptor instead')
const CreateReportResponse$json = {
  '1': 'CreateReportResponse',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
  ],
};

/// Descriptor for `CreateReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createReportResponseDescriptor =
    $convert.base64Decode('ChRDcmVhdGVSZXBvcnRSZXNwb25zZRIbCglyZXBvcnRfaWQYASABKAlSCHJlcG9ydElk');

@$core.Deprecated('Use reportListItemDescriptor instead')
const ReportListItem$json = {
  '1': 'ReportListItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'created_unix_ms', '3': 3, '4': 1, '5': 3, '10': 'createdUnixMs'},
    {'1': 'net', '3': 4, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'net'},
    {'1': 'total_return', '3': 5, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'totalReturn'},
    {'1': 'closed_trades', '3': 6, '4': 1, '5': 5, '10': 'closedTrades'},
    {'1': 'verdict', '3': 7, '4': 1, '5': 9, '10': 'verdict'},
    {'1': 'tone', '3': 8, '4': 1, '5': 9, '10': 'tone'},
    {'1': 'holdout_views', '3': 9, '4': 1, '5': 5, '10': 'holdoutViews'},
  ],
};

/// Descriptor for `ReportListItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportListItemDescriptor =
    $convert.base64Decode('Cg5SZXBvcnRMaXN0SXRlbRIOCgJpZBgBIAEoCVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEi'
        'YKD2NyZWF0ZWRfdW5peF9tcxgDIAEoA1INY3JlYXRlZFVuaXhNcxIfCgNuZXQYBCABKAsyDS5s'
        'YWIudjEuTW9uZXlSA25ldBIyCgx0b3RhbF9yZXR1cm4YBSABKAsyDy5sYWIudjEuRGVjaW1hbF'
        'ILdG90YWxSZXR1cm4SIwoNY2xvc2VkX3RyYWRlcxgGIAEoBVIMY2xvc2VkVHJhZGVzEhgKB3Zl'
        'cmRpY3QYByABKAlSB3ZlcmRpY3QSEgoEdG9uZRgIIAEoCVIEdG9uZRIjCg1ob2xkb3V0X3ZpZX'
        'dzGAkgASgFUgxob2xkb3V0Vmlld3M=');

@$core.Deprecated('Use listReportsRequestDescriptor instead')
const ListReportsRequest$json = {
  '1': 'ListReportsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListReportsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReportsRequestDescriptor =
    $convert.base64Decode('ChJMaXN0UmVwb3J0c1JlcXVlc3QSGwoJcGFnZV9zaXplGAEgASgFUghwYWdlU2l6ZRIWCgZvZm'
        'ZzZXQYAiABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listReportsResponseDescriptor instead')
const ListReportsResponse$json = {
  '1': 'ListReportsResponse',
  '2': [
    {'1': 'reports', '3': 1, '4': 3, '5': 11, '6': '.lab.v1.ReportListItem', '10': 'reports'},
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListReportsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReportsResponseDescriptor =
    $convert.base64Decode('ChNMaXN0UmVwb3J0c1Jlc3BvbnNlEjAKB3JlcG9ydHMYASADKAsyFi5sYWIudjEuUmVwb3J0TG'
        'lzdEl0ZW1SB3JlcG9ydHMSFAoFdG90YWwYAiABKANSBXRvdGFs');

@$core.Deprecated('Use windowDescriptor instead')
const Window$json = {
  '1': 'Window',
  '2': [
    {'1': 'from_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'fromUnixMs'},
    {'1': 'to_unix_ms', '3': 2, '4': 1, '5': 3, '10': 'toUnixMs'},
  ],
};

/// Descriptor for `Window`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List windowDescriptor =
    $convert.base64Decode('CgZXaW5kb3cSIAoMZnJvbV91bml4X21zGAEgASgDUgpmcm9tVW5peE1zEhwKCnRvX3VuaXhfbX'
        'MYAiABKANSCHRvVW5peE1z');

@$core.Deprecated('Use runViewDescriptor instead')
const RunView$json = {
  '1': 'RunView',
  '2': [
    {'1': 'window', '3': 1, '4': 1, '5': 11, '6': '.lab.v1.Window', '10': 'window'},
    {'1': 'metrics', '3': 2, '4': 3, '5': 11, '6': '.lab.v1.Metric', '10': 'metrics'},
    {'1': 'equity', '3': 3, '4': 3, '5': 11, '6': '.lab.v1.EquityPoint', '10': 'equity'},
    {'1': 'ambiguous_bars', '3': 4, '4': 1, '5': 5, '10': 'ambiguousBars'},
  ],
};

/// Descriptor for `RunView`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runViewDescriptor =
    $convert.base64Decode('CgdSdW5WaWV3EiYKBndpbmRvdxgBIAEoCzIOLmxhYi52MS5XaW5kb3dSBndpbmRvdxIoCgdtZX'
        'RyaWNzGAIgAygLMg4ubGFiLnYxLk1ldHJpY1IHbWV0cmljcxIrCgZlcXVpdHkYAyADKAsyEy5s'
        'YWIudjEuRXF1aXR5UG9pbnRSBmVxdWl0eRIlCg5hbWJpZ3VvdXNfYmFycxgEIAEoBVINYW1iaW'
        'd1b3VzQmFycw==');

@$core.Deprecated('Use foldViewDescriptor instead')
const FoldView$json = {
  '1': 'FoldView',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
    {'1': 'train', '3': 2, '4': 1, '5': 11, '6': '.lab.v1.Window', '10': 'train'},
    {'1': 'test', '3': 3, '4': 1, '5': 11, '6': '.lab.v1.Window', '10': 'test'},
    {'1': 'metrics', '3': 4, '4': 3, '5': 11, '6': '.lab.v1.Metric', '10': 'metrics'},
  ],
};

/// Descriptor for `FoldView`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List foldViewDescriptor =
    $convert.base64Decode('CghGb2xkVmlldxIUCgVpbmRleBgBIAEoBVIFaW5kZXgSJAoFdHJhaW4YAiABKAsyDi5sYWIudj'
        'EuV2luZG93UgV0cmFpbhIiCgR0ZXN0GAMgASgLMg4ubGFiLnYxLldpbmRvd1IEdGVzdBIoCgdt'
        'ZXRyaWNzGAQgAygLMg4ubGFiLnYxLk1ldHJpY1IHbWV0cmljcw==');

@$core.Deprecated('Use stressViewDescriptor instead')
const StressView$json = {
  '1': 'StressView',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'metrics', '3': 2, '4': 3, '5': 11, '6': '.lab.v1.Metric', '10': 'metrics'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `StressView`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stressViewDescriptor =
    $convert.base64Decode('CgpTdHJlc3NWaWV3EhAKA2tleRgBIAEoCVIDa2V5EigKB21ldHJpY3MYAiADKAsyDi5sYWIudj'
        'EuTWV0cmljUgdtZXRyaWNzEhQKBWVycm9yGAMgASgJUgVlcnJvcg==');

@$core.Deprecated('Use gridCellDescriptor instead')
const GridCell$json = {
  '1': 'GridCell',
  '2': [
    {'1': 'total_return', '3': 1, '4': 1, '5': 11, '6': '.lab.v1.Metric', '10': 'totalReturn'},
    {'1': 'center', '3': 2, '4': 1, '5': 8, '10': 'center'},
    {'1': 'invalid', '3': 3, '4': 1, '5': 9, '10': 'invalid'},
  ],
};

/// Descriptor for `GridCell`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gridCellDescriptor =
    $convert.base64Decode('CghHcmlkQ2VsbBIxCgx0b3RhbF9yZXR1cm4YASABKAsyDi5sYWIudjEuTWV0cmljUgt0b3RhbF'
        'JldHVybhIWCgZjZW50ZXIYAiABKAhSBmNlbnRlchIYCgdpbnZhbGlkGAMgASgJUgdpbnZhbGlk');

@$core.Deprecated('Use gridRowDescriptor instead')
const GridRow$json = {
  '1': 'GridRow',
  '2': [
    {'1': 'cells', '3': 1, '4': 3, '5': 11, '6': '.lab.v1.GridCell', '10': 'cells'},
  ],
};

/// Descriptor for `GridRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gridRowDescriptor =
    $convert.base64Decode('CgdHcmlkUm93EiYKBWNlbGxzGAEgAygLMhAubGFiLnYxLkdyaWRDZWxsUgVjZWxscw==');

@$core.Deprecated('Use gridDescriptor instead')
const Grid$json = {
  '1': 'Grid',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 9, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 9, '10': 'y'},
    {'1': 'xs', '3': 3, '4': 3, '5': 1, '10': 'xs'},
    {'1': 'ys', '3': 4, '4': 3, '5': 1, '10': 'ys'},
    {'1': 'rows', '3': 5, '4': 3, '5': 11, '6': '.lab.v1.GridRow', '10': 'rows'},
  ],
};

/// Descriptor for `Grid`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gridDescriptor =
    $convert.base64Decode('CgRHcmlkEgwKAXgYASABKAlSAXgSDAoBeRgCIAEoCVIBeRIOCgJ4cxgDIAMoAVICeHMSDgoCeX'
        'MYBCADKAFSAnlzEiMKBHJvd3MYBSADKAsyDy5sYWIudjEuR3JpZFJvd1IEcm93cw==');

@$core.Deprecated('Use badgeDescriptor instead')
const Badge$json = {
  '1': 'Badge',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'tone', '3': 3, '4': 1, '5': 9, '10': 'tone'},
  ],
};

/// Descriptor for `Badge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List badgeDescriptor =
    $convert.base64Decode('CgVCYWRnZRISCgRraW5kGAEgASgJUgRraW5kEhIKBHRleHQYAiABKAlSBHRleHQSEgoEdG9uZR'
        'gDIAEoCVIEdG9uZQ==');

@$core.Deprecated('Use summaryDescriptor instead')
const Summary$json = {
  '1': 'Summary',
  '2': [
    {'1': 'verdict', '3': 1, '4': 1, '5': 9, '10': 'verdict'},
    {'1': 'tone', '3': 2, '4': 1, '5': 9, '10': 'tone'},
    {'1': 'sentence', '3': 3, '4': 1, '5': 9, '10': 'sentence'},
    {'1': 'badges', '3': 4, '4': 3, '5': 11, '6': '.lab.v1.Badge', '10': 'badges'},
  ],
};

/// Descriptor for `Summary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List summaryDescriptor =
    $convert.base64Decode('CgdTdW1tYXJ5EhgKB3ZlcmRpY3QYASABKAlSB3ZlcmRpY3QSEgoEdG9uZRgCIAEoCVIEdG9uZR'
        'IaCghzZW50ZW5jZRgDIAEoCVIIc2VudGVuY2USJQoGYmFkZ2VzGAQgAygLMg0ubGFiLnYxLkJh'
        'ZGdlUgZiYWRnZXM=');

@$core.Deprecated('Use benchmarkDescriptor instead')
const Benchmark$json = {
  '1': 'Benchmark',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'equity', '3': 2, '4': 3, '5': 11, '6': '.lab.v1.EquityPoint', '10': 'equity'},
    {'1': 'total_return', '3': 3, '4': 1, '5': 11, '6': '.lab.v1.Metric', '10': 'totalReturn'},
  ],
};

/// Descriptor for `Benchmark`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List benchmarkDescriptor =
    $convert.base64Decode('CglCZW5jaG1hcmsSEAoDa2V5GAEgASgJUgNrZXkSKwoGZXF1aXR5GAIgAygLMhMubGFiLnYxLk'
        'VxdWl0eVBvaW50UgZlcXVpdHkSMQoMdG90YWxfcmV0dXJuGAMgASgLMg4ubGFiLnYxLk1ldHJp'
        'Y1ILdG90YWxSZXR1cm4=');

@$core.Deprecated('Use metricGroupDescriptor instead')
const MetricGroup$json = {
  '1': 'MetricGroup',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
  ],
};

/// Descriptor for `MetricGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metricGroupDescriptor =
    $convert.base64Decode('CgtNZXRyaWNHcm91cBIQCgNrZXkYASABKAlSA2tleRIUCgVsYWJlbBgCIAEoCVIFbGFiZWw=');

@$core.Deprecated('Use reportDescriptor instead')
const Report$json = {
  '1': 'Report',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'created_unix_ms', '3': 3, '4': 1, '5': 3, '10': 'createdUnixMs'},
    {'1': 'spec', '3': 4, '4': 1, '5': 11, '6': '.lab.v1.ReportSpec', '10': 'spec'},
    {'1': 'range', '3': 5, '4': 1, '5': 11, '6': '.lab.v1.Window', '10': 'range'},
    {'1': 'oos_window', '3': 6, '4': 1, '5': 11, '6': '.lab.v1.Window', '10': 'oosWindow'},
    {'1': 'holdout_window', '3': 7, '4': 1, '5': 11, '6': '.lab.v1.Window', '10': 'holdoutWindow'},
    {'1': 'summary', '3': 8, '4': 1, '5': 11, '6': '.lab.v1.Summary', '10': 'summary'},
    {'1': 'oos', '3': 9, '4': 1, '5': 11, '6': '.lab.v1.RunView', '10': 'oos'},
    {'1': 'folds', '3': 10, '4': 3, '5': 11, '6': '.lab.v1.FoldView', '10': 'folds'},
    {'1': 'stress', '3': 11, '4': 3, '5': 11, '6': '.lab.v1.StressView', '10': 'stress'},
    {'1': 'grid', '3': 12, '4': 1, '5': 11, '6': '.lab.v1.Grid', '10': 'grid'},
    {'1': 'benchmarks', '3': 13, '4': 3, '5': 11, '6': '.lab.v1.Benchmark', '10': 'benchmarks'},
    {'1': 'break_even_fee', '3': 14, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'breakEvenFee'},
    {'1': 'holdout_views', '3': 15, '4': 1, '5': 5, '10': 'holdoutViews'},
    {'1': 'groups', '3': 16, '4': 3, '5': 11, '6': '.lab.v1.MetricGroup', '10': 'groups'},
    {'1': 'final_equity_toman', '3': 17, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'finalEquityToman'},
    {'1': 'net_toman', '3': 18, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'netToman'},
  ],
};

/// Descriptor for `Report`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportDescriptor =
    $convert.base64Decode('CgZSZXBvcnQSDgoCaWQYASABKAlSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRImCg9jcmVhdG'
        'VkX3VuaXhfbXMYAyABKANSDWNyZWF0ZWRVbml4TXMSJgoEc3BlYxgEIAEoCzISLmxhYi52MS5S'
        'ZXBvcnRTcGVjUgRzcGVjEiQKBXJhbmdlGAUgASgLMg4ubGFiLnYxLldpbmRvd1IFcmFuZ2USLQ'
        'oKb29zX3dpbmRvdxgGIAEoCzIOLmxhYi52MS5XaW5kb3dSCW9vc1dpbmRvdxI1Cg5ob2xkb3V0'
        'X3dpbmRvdxgHIAEoCzIOLmxhYi52MS5XaW5kb3dSDWhvbGRvdXRXaW5kb3cSKQoHc3VtbWFyeR'
        'gIIAEoCzIPLmxhYi52MS5TdW1tYXJ5UgdzdW1tYXJ5EiEKA29vcxgJIAEoCzIPLmxhYi52MS5S'
        'dW5WaWV3UgNvb3MSJgoFZm9sZHMYCiADKAsyEC5sYWIudjEuRm9sZFZpZXdSBWZvbGRzEioKBn'
        'N0cmVzcxgLIAMoCzISLmxhYi52MS5TdHJlc3NWaWV3UgZzdHJlc3MSIAoEZ3JpZBgMIAEoCzIM'
        'LmxhYi52MS5HcmlkUgRncmlkEjEKCmJlbmNobWFya3MYDSADKAsyES5sYWIudjEuQmVuY2htYX'
        'JrUgpiZW5jaG1hcmtzEjUKDmJyZWFrX2V2ZW5fZmVlGA4gASgLMg8ubGFiLnYxLkRlY2ltYWxS'
        'DGJyZWFrRXZlbkZlZRIjCg1ob2xkb3V0X3ZpZXdzGA8gASgFUgxob2xkb3V0Vmlld3MSKwoGZ3'
        'JvdXBzGBAgAygLMhMubGFiLnYxLk1ldHJpY0dyb3VwUgZncm91cHMSOwoSZmluYWxfZXF1aXR5'
        'X3RvbWFuGBEgASgLMg0ubGFiLnYxLk1vbmV5UhBmaW5hbEVxdWl0eVRvbWFuEioKCW5ldF90b2'
        '1hbhgSIAEoCzINLmxhYi52MS5Nb25leVIIbmV0VG9tYW4=');

@$core.Deprecated('Use getReportRequestDescriptor instead')
const GetReportRequest$json = {
  '1': 'GetReportRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'fx_rate_id', '3': 2, '4': 1, '5': 3, '10': 'fxRateId'},
  ],
};

/// Descriptor for `GetReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReportRequestDescriptor =
    $convert.base64Decode('ChBHZXRSZXBvcnRSZXF1ZXN0EhsKCXJlcG9ydF9pZBgBIAEoCVIIcmVwb3J0SWQSHAoKZnhfcm'
        'F0ZV9pZBgCIAEoA1IIZnhSYXRlSWQ=');

@$core.Deprecated('Use getReportResponseDescriptor instead')
const GetReportResponse$json = {
  '1': 'GetReportResponse',
  '2': [
    {'1': 'report', '3': 1, '4': 1, '5': 11, '6': '.lab.v1.Report', '10': 'report'},
  ],
};

/// Descriptor for `GetReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReportResponseDescriptor =
    $convert.base64Decode('ChFHZXRSZXBvcnRSZXNwb25zZRImCgZyZXBvcnQYASABKAsyDi5sYWIudjEuUmVwb3J0UgZyZX'
        'BvcnQ=');

@$core.Deprecated('Use viewHoldoutRequestDescriptor instead')
const ViewHoldoutRequest$json = {
  '1': 'ViewHoldoutRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
  ],
};

/// Descriptor for `ViewHoldoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List viewHoldoutRequestDescriptor =
    $convert.base64Decode('ChJWaWV3SG9sZG91dFJlcXVlc3QSGwoJcmVwb3J0X2lkGAEgASgJUghyZXBvcnRJZA==');

@$core.Deprecated('Use viewHoldoutResponseDescriptor instead')
const ViewHoldoutResponse$json = {
  '1': 'ViewHoldoutResponse',
  '2': [
    {'1': 'holdout', '3': 1, '4': 1, '5': 11, '6': '.lab.v1.RunView', '10': 'holdout'},
    {'1': 'views', '3': 2, '4': 1, '5': 5, '10': 'views'},
  ],
};

/// Descriptor for `ViewHoldoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List viewHoldoutResponseDescriptor =
    $convert.base64Decode('ChNWaWV3SG9sZG91dFJlc3BvbnNlEikKB2hvbGRvdXQYASABKAsyDy5sYWIudjEuUnVuVmlld1'
        'IHaG9sZG91dBIUCgV2aWV3cxgCIAEoBVIFdmlld3M=');

@$core.Deprecated('Use tradeRowDescriptor instead')
const TradeRow$json = {
  '1': 'TradeRow',
  '2': [
    {'1': 'seq', '3': 1, '4': 1, '5': 5, '10': 'seq'},
    {'1': 'instrument', '3': 2, '4': 1, '5': 9, '10': 'instrument'},
    {'1': 'opened_unix_ms', '3': 3, '4': 1, '5': 3, '10': 'openedUnixMs'},
    {'1': 'closed_unix_ms', '3': 4, '4': 1, '5': 3, '10': 'closedUnixMs'},
    {'1': 'qty', '3': 5, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'qty'},
    {'1': 'entry_ref', '3': 6, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'entryRef'},
    {'1': 'exit_ref', '3': 7, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'exitRef'},
    {'1': 'gross', '3': 8, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'gross'},
    {'1': 'slippage', '3': 9, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'slippage'},
    {'1': 'fees', '3': 10, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'fees'},
    {'1': 'net', '3': 11, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'net'},
    {'1': 'exit_reason', '3': 12, '4': 1, '5': 9, '10': 'exitReason'},
    {'1': 'ambiguous_bars', '3': 13, '4': 1, '5': 5, '10': 'ambiguousBars'},
    {'1': 'open_qty', '3': 14, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'openQty'},
    {'1': 'mark_value', '3': 15, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'markValue'},
  ],
};

/// Descriptor for `TradeRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tradeRowDescriptor =
    $convert.base64Decode('CghUcmFkZVJvdxIQCgNzZXEYASABKAVSA3NlcRIeCgppbnN0cnVtZW50GAIgASgJUgppbnN0cn'
        'VtZW50EiQKDm9wZW5lZF91bml4X21zGAMgASgDUgxvcGVuZWRVbml4TXMSJAoOY2xvc2VkX3Vu'
        'aXhfbXMYBCABKANSDGNsb3NlZFVuaXhNcxIhCgNxdHkYBSABKAsyDy5sYWIudjEuRGVjaW1hbF'
        'IDcXR5EioKCWVudHJ5X3JlZhgGIAEoCzINLmxhYi52MS5Nb25leVIIZW50cnlSZWYSKAoIZXhp'
        'dF9yZWYYByABKAsyDS5sYWIudjEuTW9uZXlSB2V4aXRSZWYSIwoFZ3Jvc3MYCCABKAsyDS5sYW'
        'IudjEuTW9uZXlSBWdyb3NzEikKCHNsaXBwYWdlGAkgASgLMg0ubGFiLnYxLk1vbmV5UghzbGlw'
        'cGFnZRIhCgRmZWVzGAogASgLMg0ubGFiLnYxLk1vbmV5UgRmZWVzEh8KA25ldBgLIAEoCzINLm'
        'xhYi52MS5Nb25leVIDbmV0Eh8KC2V4aXRfcmVhc29uGAwgASgJUgpleGl0UmVhc29uEiUKDmFt'
        'YmlndW91c19iYXJzGA0gASgFUg1hbWJpZ3VvdXNCYXJzEioKCG9wZW5fcXR5GA4gASgLMg8ubG'
        'FiLnYxLkRlY2ltYWxSB29wZW5RdHkSLAoKbWFya192YWx1ZRgPIAEoCzINLmxhYi52MS5Nb25l'
        'eVIJbWFya1ZhbHVl');

@$core.Deprecated('Use listTradesRequestDescriptor instead')
const ListTradesRequest$json = {
  '1': 'ListTradesRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListTradesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTradesRequestDescriptor =
    $convert.base64Decode('ChFMaXN0VHJhZGVzUmVxdWVzdBIbCglyZXBvcnRfaWQYASABKAlSCHJlcG9ydElkEhsKCXBhZ2'
        'Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSFgoGb2Zmc2V0GAMgASgFUgZvZmZzZXQ=');

@$core.Deprecated('Use listTradesResponseDescriptor instead')
const ListTradesResponse$json = {
  '1': 'ListTradesResponse',
  '2': [
    {'1': 'trades', '3': 1, '4': 3, '5': 11, '6': '.lab.v1.TradeRow', '10': 'trades'},
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListTradesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTradesResponseDescriptor =
    $convert.base64Decode('ChJMaXN0VHJhZGVzUmVzcG9uc2USKAoGdHJhZGVzGAEgAygLMhAubGFiLnYxLlRyYWRlUm93Ug'
        'Z0cmFkZXMSFAoFdG90YWwYAiABKANSBXRvdGFs');

@$core.Deprecated('Use decisionRowDescriptor instead')
const DecisionRow$json = {
  '1': 'DecisionRow',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'at_unix_ms', '3': 2, '4': 1, '5': 3, '10': 'atUnixMs'},
    {'1': 'input_symbol', '3': 3, '4': 1, '5': 9, '10': 'inputSymbol'},
    {'1': 'input_bar_open_unix_ms', '3': 4, '4': 1, '5': 3, '10': 'inputBarOpenUnixMs'},
    {'1': 'instrument', '3': 5, '4': 1, '5': 9, '10': 'instrument'},
    {'1': 'target', '3': 6, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'target'},
    {'1': 'stop_loss', '3': 7, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'stopLoss'},
    {'1': 'take_profit', '3': 8, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'takeProfit'},
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'model_id', '3': 10, '4': 1, '5': 9, '10': 'modelId'},
    {'1': 'recipe_version', '3': 11, '4': 1, '5': 9, '10': 'recipeVersion'},
    {'1': 'outcome', '3': 12, '4': 1, '5': 9, '10': 'outcome'},
    {'1': 'detail', '3': 13, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `DecisionRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decisionRowDescriptor =
    $convert.base64Decode('CgtEZWNpc2lvblJvdxIOCgJpZBgBIAEoBVICaWQSHAoKYXRfdW5peF9tcxgCIAEoA1IIYXRVbm'
        'l4TXMSIQoMaW5wdXRfc3ltYm9sGAMgASgJUgtpbnB1dFN5bWJvbBIyChZpbnB1dF9iYXJfb3Bl'
        'bl91bml4X21zGAQgASgDUhJpbnB1dEJhck9wZW5Vbml4TXMSHgoKaW5zdHJ1bWVudBgFIAEoCV'
        'IKaW5zdHJ1bWVudBInCgZ0YXJnZXQYBiABKAsyDy5sYWIudjEuRGVjaW1hbFIGdGFyZ2V0EiwK'
        'CXN0b3BfbG9zcxgHIAEoCzIPLmxhYi52MS5EZWNpbWFsUghzdG9wTG9zcxIwCgt0YWtlX3Byb2'
        'ZpdBgIIAEoCzIPLmxhYi52MS5EZWNpbWFsUgp0YWtlUHJvZml0EhYKBnJlYXNvbhgJIAEoCVIG'
        'cmVhc29uEhkKCG1vZGVsX2lkGAogASgJUgdtb2RlbElkEiUKDnJlY2lwZV92ZXJzaW9uGAsgAS'
        'gJUg1yZWNpcGVWZXJzaW9uEhgKB291dGNvbWUYDCABKAlSB291dGNvbWUSFgoGZGV0YWlsGA0g'
        'ASgJUgZkZXRhaWw=');

@$core.Deprecated('Use listDecisionsRequestDescriptor instead')
const ListDecisionsRequest$json = {
  '1': 'ListDecisionsRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListDecisionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDecisionsRequestDescriptor =
    $convert.base64Decode('ChRMaXN0RGVjaXNpb25zUmVxdWVzdBIbCglyZXBvcnRfaWQYASABKAlSCHJlcG9ydElkEhsKCX'
        'BhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSFgoGb2Zmc2V0GAMgASgFUgZvZmZzZXQ=');

@$core.Deprecated('Use listDecisionsResponseDescriptor instead')
const ListDecisionsResponse$json = {
  '1': 'ListDecisionsResponse',
  '2': [
    {'1': 'decisions', '3': 1, '4': 3, '5': 11, '6': '.lab.v1.DecisionRow', '10': 'decisions'},
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListDecisionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDecisionsResponseDescriptor =
    $convert.base64Decode('ChVMaXN0RGVjaXNpb25zUmVzcG9uc2USMQoJZGVjaXNpb25zGAEgAygLMhMubGFiLnYxLkRlY2'
        'lzaW9uUm93UglkZWNpc2lvbnMSFAoFdG90YWwYAiABKANSBXRvdGFs');

@$core.Deprecated('Use assumptionDescriptor instead')
const Assumption$json = {
  '1': 'Assumption',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'values', '3': 3, '4': 3, '5': 9, '10': 'values'},
    {'1': 'differs', '3': 4, '4': 1, '5': 8, '10': 'differs'},
    {'1': 'blocking', '3': 5, '4': 1, '5': 8, '10': 'blocking'},
  ],
};

/// Descriptor for `Assumption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assumptionDescriptor =
    $convert.base64Decode('CgpBc3N1bXB0aW9uEhAKA2tleRgBIAEoCVIDa2V5EhQKBWxhYmVsGAIgASgJUgVsYWJlbBIWCg'
        'Z2YWx1ZXMYAyADKAlSBnZhbHVlcxIYCgdkaWZmZXJzGAQgASgIUgdkaWZmZXJzEhoKCGJsb2Nr'
        'aW5nGAUgASgIUghibG9ja2luZw==');

@$core.Deprecated('Use compareRequestDescriptor instead')
const CompareRequest$json = {
  '1': 'CompareRequest',
  '2': [
    {'1': 'report_ids', '3': 1, '4': 3, '5': 9, '10': 'reportIds'},
  ],
};

/// Descriptor for `CompareRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareRequestDescriptor =
    $convert.base64Decode('Cg5Db21wYXJlUmVxdWVzdBIdCgpyZXBvcnRfaWRzGAEgAygJUglyZXBvcnRJZHM=');

@$core.Deprecated('Use compareColumnDescriptor instead')
const CompareColumn$json = {
  '1': 'CompareColumn',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'eligible', '3': 3, '4': 1, '5': 8, '10': 'eligible'},
    {'1': 'reasons', '3': 4, '4': 3, '5': 9, '10': 'reasons'},
    {'1': 'metrics', '3': 5, '4': 3, '5': 11, '6': '.lab.v1.Metric', '10': 'metrics'},
    {'1': 'equity', '3': 6, '4': 3, '5': 11, '6': '.lab.v1.EquityPoint', '10': 'equity'},
  ],
};

/// Descriptor for `CompareColumn`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareColumnDescriptor =
    $convert.base64Decode('Cg1Db21wYXJlQ29sdW1uEhsKCXJlcG9ydF9pZBgBIAEoCVIIcmVwb3J0SWQSFAoFdGl0bGUYAi'
        'ABKAlSBXRpdGxlEhoKCGVsaWdpYmxlGAMgASgIUghlbGlnaWJsZRIYCgdyZWFzb25zGAQgAygJ'
        'UgdyZWFzb25zEigKB21ldHJpY3MYBSADKAsyDi5sYWIudjEuTWV0cmljUgdtZXRyaWNzEisKBm'
        'VxdWl0eRgGIAMoCzITLmxhYi52MS5FcXVpdHlQb2ludFIGZXF1aXR5');

@$core.Deprecated('Use compareResponseDescriptor instead')
const CompareResponse$json = {
  '1': 'CompareResponse',
  '2': [
    {'1': 'assumptions', '3': 1, '4': 3, '5': 11, '6': '.lab.v1.Assumption', '10': 'assumptions'},
    {'1': 'columns', '3': 2, '4': 3, '5': 11, '6': '.lab.v1.CompareColumn', '10': 'columns'},
    {'1': 'conclusion', '3': 3, '4': 1, '5': 9, '10': 'conclusion'},
  ],
};

/// Descriptor for `CompareResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareResponseDescriptor =
    $convert.base64Decode('Cg9Db21wYXJlUmVzcG9uc2USNAoLYXNzdW1wdGlvbnMYASADKAsyEi5sYWIudjEuQXNzdW1wdG'
        'lvblILYXNzdW1wdGlvbnMSLwoHY29sdW1ucxgCIAMoCzIVLmxhYi52MS5Db21wYXJlQ29sdW1u'
        'Ugdjb2x1bW5zEh4KCmNvbmNsdXNpb24YAyABKAlSCmNvbmNsdXNpb24=');

@$core.Deprecated('Use exportRequestDescriptor instead')
const ExportRequest$json = {
  '1': 'ExportRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'fx_rate_id', '3': 3, '4': 1, '5': 3, '10': 'fxRateId'},
  ],
};

/// Descriptor for `ExportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportRequestDescriptor =
    $convert.base64Decode('Cg1FeHBvcnRSZXF1ZXN0EhsKCXJlcG9ydF9pZBgBIAEoCVIIcmVwb3J0SWQSEgoEa2luZBgCIA'
        'EoCVIEa2luZBIcCgpmeF9yYXRlX2lkGAMgASgDUghmeFJhdGVJZA==');

@$core.Deprecated('Use exportResponseDescriptor instead')
const ExportResponse$json = {
  '1': 'ExportResponse',
  '2': [
    {'1': 'filename', '3': 1, '4': 1, '5': 9, '10': 'filename'},
    {'1': 'mime', '3': 2, '4': 1, '5': 9, '10': 'mime'},
    {'1': 'content', '3': 3, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `ExportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportResponseDescriptor =
    $convert.base64Decode('Cg5FeHBvcnRSZXNwb25zZRIaCghmaWxlbmFtZRgBIAEoCVIIZmlsZW5hbWUSEgoEbWltZRgCIA'
        'EoCVIEbWltZRIYCgdjb250ZW50GAMgASgMUgdjb250ZW50');

@$core.Deprecated('Use reproduceRequestDescriptor instead')
const ReproduceRequest$json = {
  '1': 'ReproduceRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
  ],
};

/// Descriptor for `ReproduceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reproduceRequestDescriptor =
    $convert.base64Decode('ChBSZXByb2R1Y2VSZXF1ZXN0EhsKCXJlcG9ydF9pZBgBIAEoCVIIcmVwb3J0SWQ=');

@$core.Deprecated('Use reproduceResponseDescriptor instead')
const ReproduceResponse$json = {
  '1': 'ReproduceResponse',
  '2': [
    {'1': 'identical', '3': 1, '4': 1, '5': 8, '10': 'identical'},
  ],
};

/// Descriptor for `ReproduceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reproduceResponseDescriptor =
    $convert.base64Decode('ChFSZXByb2R1Y2VSZXNwb25zZRIcCglpZGVudGljYWwYASABKAhSCWlkZW50aWNhbA==');

const $core.Map<$core.String, $core.dynamic> ReportServiceBase$json = {
  '1': 'ReportService',
  '2': [
    {'1': 'ListStrategies', '2': '.lab.v1.ListStrategiesRequest', '3': '.lab.v1.ListStrategiesResponse'},
    {'1': 'CreateReport', '2': '.lab.v1.CreateReportRequest', '3': '.lab.v1.CreateReportResponse'},
    {'1': 'ListReports', '2': '.lab.v1.ListReportsRequest', '3': '.lab.v1.ListReportsResponse'},
    {'1': 'GetReport', '2': '.lab.v1.GetReportRequest', '3': '.lab.v1.GetReportResponse'},
    {'1': 'ViewHoldout', '2': '.lab.v1.ViewHoldoutRequest', '3': '.lab.v1.ViewHoldoutResponse'},
    {'1': 'ListTrades', '2': '.lab.v1.ListTradesRequest', '3': '.lab.v1.ListTradesResponse'},
    {'1': 'ListDecisions', '2': '.lab.v1.ListDecisionsRequest', '3': '.lab.v1.ListDecisionsResponse'},
    {'1': 'Compare', '2': '.lab.v1.CompareRequest', '3': '.lab.v1.CompareResponse'},
    {'1': 'Export', '2': '.lab.v1.ExportRequest', '3': '.lab.v1.ExportResponse'},
    {'1': 'Reproduce', '2': '.lab.v1.ReproduceRequest', '3': '.lab.v1.ReproduceResponse'},
  ],
};

@$core.Deprecated('Use reportServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ReportServiceBase$messageJson = {
  '.lab.v1.ListStrategiesRequest': ListStrategiesRequest$json,
  '.lab.v1.ListStrategiesResponse': ListStrategiesResponse$json,
  '.lab.v1.StrategyInfo': StrategyInfo$json,
  '.lab.v1.ParamSpec': ParamSpec$json,
  '.lab.v1.CreateReportRequest': CreateReportRequest$json,
  '.lab.v1.ReportSpec': ReportSpec$json,
  '.lab.v1.ReportSpec.ParamsEntry': ReportSpec_ParamsEntry$json,
  '.lab.v1.Money': $0.Money$json,
  '.lab.v1.Decimal': $0.Decimal$json,
  '.lab.v1.CreateReportResponse': CreateReportResponse$json,
  '.lab.v1.ListReportsRequest': ListReportsRequest$json,
  '.lab.v1.ListReportsResponse': ListReportsResponse$json,
  '.lab.v1.ReportListItem': ReportListItem$json,
  '.lab.v1.GetReportRequest': GetReportRequest$json,
  '.lab.v1.GetReportResponse': GetReportResponse$json,
  '.lab.v1.Report': Report$json,
  '.lab.v1.Window': Window$json,
  '.lab.v1.Summary': Summary$json,
  '.lab.v1.Badge': Badge$json,
  '.lab.v1.RunView': RunView$json,
  '.lab.v1.Metric': $0.Metric$json,
  '.lab.v1.EquityPoint': $0.EquityPoint$json,
  '.lab.v1.FoldView': FoldView$json,
  '.lab.v1.StressView': StressView$json,
  '.lab.v1.Grid': Grid$json,
  '.lab.v1.GridRow': GridRow$json,
  '.lab.v1.GridCell': GridCell$json,
  '.lab.v1.Benchmark': Benchmark$json,
  '.lab.v1.MetricGroup': MetricGroup$json,
  '.lab.v1.ViewHoldoutRequest': ViewHoldoutRequest$json,
  '.lab.v1.ViewHoldoutResponse': ViewHoldoutResponse$json,
  '.lab.v1.ListTradesRequest': ListTradesRequest$json,
  '.lab.v1.ListTradesResponse': ListTradesResponse$json,
  '.lab.v1.TradeRow': TradeRow$json,
  '.lab.v1.ListDecisionsRequest': ListDecisionsRequest$json,
  '.lab.v1.ListDecisionsResponse': ListDecisionsResponse$json,
  '.lab.v1.DecisionRow': DecisionRow$json,
  '.lab.v1.CompareRequest': CompareRequest$json,
  '.lab.v1.CompareResponse': CompareResponse$json,
  '.lab.v1.Assumption': Assumption$json,
  '.lab.v1.CompareColumn': CompareColumn$json,
  '.lab.v1.ExportRequest': ExportRequest$json,
  '.lab.v1.ExportResponse': ExportResponse$json,
  '.lab.v1.ReproduceRequest': ReproduceRequest$json,
  '.lab.v1.ReproduceResponse': ReproduceResponse$json,
};

/// Descriptor for `ReportService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List reportServiceDescriptor =
    $convert.base64Decode('Cg1SZXBvcnRTZXJ2aWNlEk8KDkxpc3RTdHJhdGVnaWVzEh0ubGFiLnYxLkxpc3RTdHJhdGVnaW'
        'VzUmVxdWVzdBoeLmxhYi52MS5MaXN0U3RyYXRlZ2llc1Jlc3BvbnNlEkkKDENyZWF0ZVJlcG9y'
        'dBIbLmxhYi52MS5DcmVhdGVSZXBvcnRSZXF1ZXN0GhwubGFiLnYxLkNyZWF0ZVJlcG9ydFJlc3'
        'BvbnNlEkYKC0xpc3RSZXBvcnRzEhoubGFiLnYxLkxpc3RSZXBvcnRzUmVxdWVzdBobLmxhYi52'
        'MS5MaXN0UmVwb3J0c1Jlc3BvbnNlEkAKCUdldFJlcG9ydBIYLmxhYi52MS5HZXRSZXBvcnRSZX'
        'F1ZXN0GhkubGFiLnYxLkdldFJlcG9ydFJlc3BvbnNlEkYKC1ZpZXdIb2xkb3V0EhoubGFiLnYx'
        'LlZpZXdIb2xkb3V0UmVxdWVzdBobLmxhYi52MS5WaWV3SG9sZG91dFJlc3BvbnNlEkMKCkxpc3'
        'RUcmFkZXMSGS5sYWIudjEuTGlzdFRyYWRlc1JlcXVlc3QaGi5sYWIudjEuTGlzdFRyYWRlc1Jl'
        'c3BvbnNlEkwKDUxpc3REZWNpc2lvbnMSHC5sYWIudjEuTGlzdERlY2lzaW9uc1JlcXVlc3QaHS'
        '5sYWIudjEuTGlzdERlY2lzaW9uc1Jlc3BvbnNlEjoKB0NvbXBhcmUSFi5sYWIudjEuQ29tcGFy'
        'ZVJlcXVlc3QaFy5sYWIudjEuQ29tcGFyZVJlc3BvbnNlEjcKBkV4cG9ydBIVLmxhYi52MS5FeH'
        'BvcnRSZXF1ZXN0GhYubGFiLnYxLkV4cG9ydFJlc3BvbnNlEkAKCVJlcHJvZHVjZRIYLmxhYi52'
        'MS5SZXByb2R1Y2VSZXF1ZXN0GhkubGFiLnYxLlJlcHJvZHVjZVJlc3BvbnNl');
