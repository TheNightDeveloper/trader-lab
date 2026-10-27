// This is a generated file - do not edit.
//
// Generated from lab/v1/health.proto.

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

@$core.Deprecated('Use runModeDescriptor instead')
const RunMode$json = {
  '1': 'RunMode',
  '2': [
    {'1': 'RUN_MODE_UNSPECIFIED', '2': 0},
    {'1': 'RUN_MODE_RESEARCH', '2': 1},
  ],
};

/// Descriptor for `RunMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List runModeDescriptor =
    $convert.base64Decode('CgdSdW5Nb2RlEhgKFFJVTl9NT0RFX1VOU1BFQ0lGSUVEEAASFQoRUlVOX01PREVfUkVTRUFSQ0'
        'gQAQ==');

@$core.Deprecated('Use liveStateDescriptor instead')
const LiveState$json = {
  '1': 'LiveState',
  '2': [
    {'1': 'LIVE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'LIVE_STATE_OFF', '2': 1},
    {'1': 'LIVE_STATE_FRESH', '2': 2},
    {'1': 'LIVE_STATE_STALE', '2': 3},
    {'1': 'LIVE_STATE_RECONNECTING', '2': 4},
  ],
};

/// Descriptor for `LiveState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List liveStateDescriptor =
    $convert.base64Decode('CglMaXZlU3RhdGUSGgoWTElWRV9TVEFURV9VTlNQRUNJRklFRBAAEhIKDkxJVkVfU1RBVEVfT0'
        'ZGEAESFAoQTElWRV9TVEFURV9GUkVTSBACEhQKEExJVkVfU1RBVEVfU1RBTEUQAxIbChdMSVZF'
        'X1NUQVRFX1JFQ09OTkVDVElORxAE');

@$core.Deprecated('Use workerStateDescriptor instead')
const WorkerState$json = {
  '1': 'WorkerState',
  '2': [
    {'1': 'WORKER_STATE_UNSPECIFIED', '2': 0},
    {'1': 'WORKER_STATE_RUNNING', '2': 1},
    {'1': 'WORKER_STATE_PAUSED', '2': 2},
  ],
};

/// Descriptor for `WorkerState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workerStateDescriptor =
    $convert.base64Decode('CgtXb3JrZXJTdGF0ZRIcChhXT1JLRVJfU1RBVEVfVU5TUEVDSUZJRUQQABIYChRXT1JLRVJfU1'
        'RBVEVfUlVOTklORxABEhcKE1dPUktFUl9TVEFURV9QQVVTRUQQAg==');

@$core.Deprecated('Use watchRequestDescriptor instead')
const WatchRequest$json = {
  '1': 'WatchRequest',
};

/// Descriptor for `WatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRequestDescriptor = $convert.base64Decode('CgxXYXRjaFJlcXVlc3Q=');

@$core.Deprecated('Use watchResponseDescriptor instead')
const WatchResponse$json = {
  '1': 'WatchResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.lab.v1.EngineStatus', '10': 'status'},
  ],
};

/// Descriptor for `WatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchResponseDescriptor =
    $convert.base64Decode('Cg1XYXRjaFJlc3BvbnNlEiwKBnN0YXR1cxgBIAEoCzIULmxhYi52MS5FbmdpbmVTdGF0dXNSBn'
        'N0YXR1cw==');

@$core.Deprecated('Use engineStatusDescriptor instead')
const EngineStatus$json = {
  '1': 'EngineStatus',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    {'1': 'mode', '3': 2, '4': 1, '5': 14, '6': '.lab.v1.RunMode', '10': 'mode'},
    {'1': 'accounting_asset', '3': 3, '4': 1, '5': 9, '10': 'accountingAsset'},
    {'1': 'live', '3': 4, '4': 1, '5': 11, '6': '.lab.v1.LiveData', '10': 'live'},
    {'1': 'workers', '3': 5, '4': 1, '5': 11, '6': '.lab.v1.Workers', '10': 'workers'},
    {'1': 'display_rate', '3': 6, '4': 1, '5': 11, '6': '.lab.v1.DisplayRate', '10': 'displayRate'},
    {'1': 'server_time_unix_ms', '3': 7, '4': 1, '5': 3, '10': 'serverTimeUnixMs'},
  ],
};

/// Descriptor for `EngineStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List engineStatusDescriptor =
    $convert.base64Decode('CgxFbmdpbmVTdGF0dXMSGAoHdmVyc2lvbhgBIAEoCVIHdmVyc2lvbhIjCgRtb2RlGAIgASgOMg'
        '8ubGFiLnYxLlJ1bk1vZGVSBG1vZGUSKQoQYWNjb3VudGluZ19hc3NldBgDIAEoCVIPYWNjb3Vu'
        'dGluZ0Fzc2V0EiQKBGxpdmUYBCABKAsyEC5sYWIudjEuTGl2ZURhdGFSBGxpdmUSKQoHd29ya2'
        'VycxgFIAEoCzIPLmxhYi52MS5Xb3JrZXJzUgd3b3JrZXJzEjYKDGRpc3BsYXlfcmF0ZRgGIAEo'
        'CzITLmxhYi52MS5EaXNwbGF5UmF0ZVILZGlzcGxheVJhdGUSLQoTc2VydmVyX3RpbWVfdW5peF'
        '9tcxgHIAEoA1IQc2VydmVyVGltZVVuaXhNcw==');

@$core.Deprecated('Use liveDataDescriptor instead')
const LiveData$json = {
  '1': 'LiveData',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.lab.v1.LiveState', '10': 'state'},
    {'1': 'last_bar_age_seconds', '3': 2, '4': 1, '5': 3, '10': 'lastBarAgeSeconds'},
  ],
};

/// Descriptor for `LiveData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveDataDescriptor =
    $convert.base64Decode('CghMaXZlRGF0YRInCgVzdGF0ZRgBIAEoDjIRLmxhYi52MS5MaXZlU3RhdGVSBXN0YXRlEi8KFG'
        'xhc3RfYmFyX2FnZV9zZWNvbmRzGAIgASgDUhFsYXN0QmFyQWdlU2Vjb25kcw==');

@$core.Deprecated('Use workersDescriptor instead')
const Workers$json = {
  '1': 'Workers',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.lab.v1.WorkerState', '10': 'state'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
    {'1': 'busy', '3': 3, '4': 1, '5': 5, '10': 'busy'},
  ],
};

/// Descriptor for `Workers`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workersDescriptor =
    $convert.base64Decode('CgdXb3JrZXJzEikKBXN0YXRlGAEgASgOMhMubGFiLnYxLldvcmtlclN0YXRlUgVzdGF0ZRIUCg'
        'Vjb3VudBgCIAEoBVIFY291bnQSEgoEYnVzeRgDIAEoBVIEYnVzeQ==');

@$core.Deprecated('Use displayRateDescriptor instead')
const DisplayRate$json = {
  '1': 'DisplayRate',
  '2': [
    {'1': 'rate_id', '3': 1, '4': 1, '5': 9, '10': 'rateId'},
    {'1': 'toman_per_usdt', '3': 2, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'tomanPerUsdt'},
    {'1': 'as_of_date', '3': 3, '4': 1, '5': 9, '10': 'asOfDate'},
    {'1': 'source', '3': 4, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `DisplayRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List displayRateDescriptor =
    $convert.base64Decode('CgtEaXNwbGF5UmF0ZRIXCgdyYXRlX2lkGAEgASgJUgZyYXRlSWQSMwoOdG9tYW5fcGVyX3VzZH'
        'QYAiABKAsyDS5sYWIudjEuTW9uZXlSDHRvbWFuUGVyVXNkdBIcCgphc19vZl9kYXRlGAMgASgJ'
        'Ughhc09mRGF0ZRIWCgZzb3VyY2UYBCABKAlSBnNvdXJjZQ==');

const $core.Map<$core.String, $core.dynamic> HealthServiceBase$json = {
  '1': 'HealthService',
  '2': [
    {'1': 'Watch', '2': '.lab.v1.WatchRequest', '3': '.lab.v1.WatchResponse', '6': true},
  ],
};

@$core.Deprecated('Use healthServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> HealthServiceBase$messageJson = {
  '.lab.v1.WatchRequest': WatchRequest$json,
  '.lab.v1.WatchResponse': WatchResponse$json,
  '.lab.v1.EngineStatus': EngineStatus$json,
  '.lab.v1.LiveData': LiveData$json,
  '.lab.v1.Workers': Workers$json,
  '.lab.v1.DisplayRate': DisplayRate$json,
  '.lab.v1.Money': $0.Money$json,
};

/// Descriptor for `HealthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List healthServiceDescriptor =
    $convert.base64Decode('Cg1IZWFsdGhTZXJ2aWNlEjYKBVdhdGNoEhQubGFiLnYxLldhdGNoUmVxdWVzdBoVLmxhYi52MS'
        '5XYXRjaFJlc3BvbnNlMAE=');
