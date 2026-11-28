// This is a generated file - do not edit.
//
// Generated from lab/v1/shadow.proto.

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

@$core.Deprecated('Use shadowStateDescriptor instead')
const ShadowState$json = {
  '1': 'ShadowState',
  '2': [
    {'1': 'SHADOW_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SHADOW_STATE_ACTIVE', '2': 1},
    {'1': 'SHADOW_STATE_COMPLETE', '2': 2},
    {'1': 'SHADOW_STATE_STOPPED', '2': 3},
    {'1': 'SHADOW_STATE_GAP', '2': 4},
    {'1': 'SHADOW_STATE_BUILD_CHANGED', '2': 5},
  ],
};

/// Descriptor for `ShadowState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List shadowStateDescriptor = $convert.base64Decode(
    'CgtTaGFkb3dTdGF0ZRIcChhTSEFET1dfU1RBVEVfVU5TUEVDSUZJRUQQABIXChNTSEFET1dfU1'
    'RBVEVfQUNUSVZFEAESGQoVU0hBRE9XX1NUQVRFX0NPTVBMRVRFEAISGAoUU0hBRE9XX1NUQVRF'
    'X1NUT1BQRUQQAxIUChBTSEFET1dfU1RBVEVfR0FQEAQSHgoaU0hBRE9XX1NUQVRFX0JVSUxEX0'
    'NIQU5HRUQQBQ==');

@$core.Deprecated('Use shadowGateDescriptor instead')
const ShadowGate$json = {
  '1': 'ShadowGate',
  '2': [
    {'1': 'SHADOW_GATE_UNSPECIFIED', '2': 0},
    {'1': 'SHADOW_GATE_NO_SIGNAL', '2': 1},
    {'1': 'SHADOW_GATE_PENDING', '2': 2},
    {'1': 'SHADOW_GATE_ALLOW', '2': 3},
    {'1': 'SHADOW_GATE_BLOCK', '2': 4},
    {'1': 'SHADOW_GATE_UNAVAILABLE', '2': 5},
  ],
};

/// Descriptor for `ShadowGate`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List shadowGateDescriptor = $convert.base64Decode(
    'CgpTaGFkb3dHYXRlEhsKF1NIQURPV19HQVRFX1VOU1BFQ0lGSUVEEAASGQoVU0hBRE9XX0dBVE'
    'VfTk9fU0lHTkFMEAESFwoTU0hBRE9XX0dBVEVfUEVORElORxACEhUKEVNIQURPV19HQVRFX0FM'
    'TE9XEAMSFQoRU0hBRE9XX0dBVEVfQkxPQ0sQBBIbChdTSEFET1dfR0FURV9VTkFWQUlMQUJMRR'
    'AF');

@$core.Deprecated('Use startShadowDeploymentRequestDescriptor instead')
const StartShadowDeploymentRequest$json = {
  '1': 'StartShadowDeploymentRequest',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'rule_version_id', '3': 2, '4': 1, '5': 3, '10': 'ruleVersionId'},
  ],
};

/// Descriptor for `StartShadowDeploymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startShadowDeploymentRequestDescriptor =
    $convert.base64Decode(
        'ChxTdGFydFNoYWRvd0RlcGxveW1lbnRSZXF1ZXN0EhYKBnN5bWJvbBgBIAEoCVIGc3ltYm9sEi'
        'YKD3J1bGVfdmVyc2lvbl9pZBgCIAEoA1INcnVsZVZlcnNpb25JZA==');

@$core.Deprecated('Use startShadowDeploymentResponseDescriptor instead')
const StartShadowDeploymentResponse$json = {
  '1': 'StartShadowDeploymentResponse',
  '2': [
    {'1': 'deployment_id', '3': 1, '4': 1, '5': 3, '10': 'deploymentId'},
  ],
};

/// Descriptor for `StartShadowDeploymentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startShadowDeploymentResponseDescriptor =
    $convert.base64Decode(
        'Ch1TdGFydFNoYWRvd0RlcGxveW1lbnRSZXNwb25zZRIjCg1kZXBsb3ltZW50X2lkGAEgASgDUg'
        'xkZXBsb3ltZW50SWQ=');

@$core.Deprecated('Use stopShadowDeploymentRequestDescriptor instead')
const StopShadowDeploymentRequest$json = {
  '1': 'StopShadowDeploymentRequest',
  '2': [
    {'1': 'deployment_id', '3': 1, '4': 1, '5': 3, '10': 'deploymentId'},
  ],
};

/// Descriptor for `StopShadowDeploymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopShadowDeploymentRequestDescriptor =
    $convert.base64Decode(
        'ChtTdG9wU2hhZG93RGVwbG95bWVudFJlcXVlc3QSIwoNZGVwbG95bWVudF9pZBgBIAEoA1IMZG'
        'VwbG95bWVudElk');

@$core.Deprecated('Use stopShadowDeploymentResponseDescriptor instead')
const StopShadowDeploymentResponse$json = {
  '1': 'StopShadowDeploymentResponse',
};

/// Descriptor for `StopShadowDeploymentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopShadowDeploymentResponseDescriptor =
    $convert.base64Decode('ChxTdG9wU2hhZG93RGVwbG95bWVudFJlc3BvbnNl');

@$core.Deprecated('Use getShadowSnapshotRequestDescriptor instead')
const GetShadowSnapshotRequest$json = {
  '1': 'GetShadowSnapshotRequest',
  '2': [
    {'1': 'deployment_id', '3': 1, '4': 1, '5': 3, '10': 'deploymentId'},
  ],
};

/// Descriptor for `GetShadowSnapshotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShadowSnapshotRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRTaGFkb3dTbmFwc2hvdFJlcXVlc3QSIwoNZGVwbG95bWVudF9pZBgBIAEoA1IMZGVwbG'
        '95bWVudElk');

@$core.Deprecated('Use shadowDeploymentDescriptor instead')
const ShadowDeployment$json = {
  '1': 'ShadowDeployment',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'symbol', '3': 2, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'rule_version_id', '3': 3, '4': 1, '5': 3, '10': 'ruleVersionId'},
    {'1': 'report_id', '3': 4, '4': 1, '5': 9, '10': 'reportId'},
    {
      '1': 'registered_at_unix_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'registeredAtUnixMs'
    },
    {'1': 'start_at_unix_ms', '3': 6, '4': 1, '5': 3, '10': 'startAtUnixMs'},
    {'1': 'end_at_unix_ms', '3': 7, '4': 1, '5': 3, '10': 'endAtUnixMs'},
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.ShadowState',
      '10': 'state'
    },
    {
      '1': 'capital',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'capital'
    },
    {
      '1': 'fee_rate',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'feeRate'
    },
    {
      '1': 'slippage_rate',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'slippageRate'
    },
    {'1': 'fill_model', '3': 12, '4': 1, '5': 9, '10': 'fillModel'},
    {'1': 'ai_model', '3': 13, '4': 1, '5': 9, '10': 'aiModel'},
    {
      '1': 'ai_prompt_version',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'aiPromptVersion'
    },
    {
      '1': 'rule_content_hash',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'ruleContentHash'
    },
    {'1': 'engine_build', '3': 16, '4': 1, '5': 9, '10': 'engineBuild'},
  ],
};

/// Descriptor for `ShadowDeployment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowDeploymentDescriptor = $convert.base64Decode(
    'ChBTaGFkb3dEZXBsb3ltZW50Eg4KAmlkGAEgASgDUgJpZBIWCgZzeW1ib2wYAiABKAlSBnN5bW'
    'JvbBImCg9ydWxlX3ZlcnNpb25faWQYAyABKANSDXJ1bGVWZXJzaW9uSWQSGwoJcmVwb3J0X2lk'
    'GAQgASgJUghyZXBvcnRJZBIxChVyZWdpc3RlcmVkX2F0X3VuaXhfbXMYBSABKANSEnJlZ2lzdG'
    'VyZWRBdFVuaXhNcxInChBzdGFydF9hdF91bml4X21zGAYgASgDUg1zdGFydEF0VW5peE1zEiMK'
    'DmVuZF9hdF91bml4X21zGAcgASgDUgtlbmRBdFVuaXhNcxIpCgVzdGF0ZRgIIAEoDjITLmxhYi'
    '52MS5TaGFkb3dTdGF0ZVIFc3RhdGUSJwoHY2FwaXRhbBgJIAEoCzINLmxhYi52MS5Nb25leVIH'
    'Y2FwaXRhbBIqCghmZWVfcmF0ZRgKIAEoCzIPLmxhYi52MS5EZWNpbWFsUgdmZWVSYXRlEjQKDX'
    'NsaXBwYWdlX3JhdGUYCyABKAsyDy5sYWIudjEuRGVjaW1hbFIMc2xpcHBhZ2VSYXRlEh0KCmZp'
    'bGxfbW9kZWwYDCABKAlSCWZpbGxNb2RlbBIZCghhaV9tb2RlbBgNIAEoCVIHYWlNb2RlbBIqCh'
    'FhaV9wcm9tcHRfdmVyc2lvbhgOIAEoCVIPYWlQcm9tcHRWZXJzaW9uEioKEXJ1bGVfY29udGVu'
    'dF9oYXNoGA8gASgJUg9ydWxlQ29udGVudEhhc2gSIQoMZW5naW5lX2J1aWxkGBAgASgJUgtlbm'
    'dpbmVCdWlsZA==');

@$core.Deprecated('Use shadowObservationDescriptor instead')
const ShadowObservation$json = {
  '1': 'ShadowObservation',
  '2': [
    {
      '1': 'candle_closed_at_unix_ms',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'candleClosedAtUnixMs'
    },
    {
      '1': 'observed_at_unix_ms',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'observedAtUnixMs'
    },
    {
      '1': 'decision_at_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'decisionAtUnixMs'
    },
    {
      '1': 'gate',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.ShadowGate',
      '10': 'gate'
    },
    {
      '1': 'reference_close',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'referenceClose'
    },
    {
      '1': 'gate_resolved_at_unix_ms',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'gateResolvedAtUnixMs'
    },
  ],
};

/// Descriptor for `ShadowObservation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowObservationDescriptor = $convert.base64Decode(
    'ChFTaGFkb3dPYnNlcnZhdGlvbhI2ChhjYW5kbGVfY2xvc2VkX2F0X3VuaXhfbXMYASABKANSFG'
    'NhbmRsZUNsb3NlZEF0VW5peE1zEi0KE29ic2VydmVkX2F0X3VuaXhfbXMYAiABKANSEG9ic2Vy'
    'dmVkQXRVbml4TXMSLQoTZGVjaXNpb25fYXRfdW5peF9tcxgDIAEoA1IQZGVjaXNpb25BdFVuaX'
    'hNcxImCgRnYXRlGAQgASgOMhIubGFiLnYxLlNoYWRvd0dhdGVSBGdhdGUSNgoPcmVmZXJlbmNl'
    'X2Nsb3NlGAUgASgLMg0ubGFiLnYxLk1vbmV5Ug5yZWZlcmVuY2VDbG9zZRI2ChhnYXRlX3Jlc2'
    '9sdmVkX2F0X3VuaXhfbXMYBiABKANSFGdhdGVSZXNvbHZlZEF0VW5peE1z');

@$core.Deprecated('Use shadowTrackDescriptor instead')
const ShadowTrack$json = {
  '1': 'ShadowTrack',
  '2': [
    {
      '1': 'metrics',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'metrics'
    },
    {'1': 'entries', '3': 2, '4': 1, '5': 5, '10': 'entries'},
  ],
};

/// Descriptor for `ShadowTrack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowTrackDescriptor = $convert.base64Decode(
    'CgtTaGFkb3dUcmFjaxIoCgdtZXRyaWNzGAEgAygLMg4ubGFiLnYxLk1ldHJpY1IHbWV0cmljcx'
    'IYCgdlbnRyaWVzGAIgASgFUgdlbnRyaWVz');

@$core.Deprecated('Use getShadowSnapshotResponseDescriptor instead')
const GetShadowSnapshotResponse$json = {
  '1': 'GetShadowSnapshotResponse',
  '2': [
    {
      '1': 'deployments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ShadowDeployment',
      '10': 'deployments'
    },
    {
      '1': 'selected',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowDeployment',
      '10': 'selected'
    },
    {
      '1': 'observations',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ShadowObservation',
      '10': 'observations'
    },
    {
      '1': 'baseline',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowTrack',
      '10': 'baseline'
    },
    {
      '1': 'ai',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowTrack',
      '10': 'ai'
    },
    {'1': 'sampled_hours', '3': 6, '4': 1, '5': 5, '10': 'sampledHours'},
    {'1': 'input_tokens', '3': 7, '4': 1, '5': 3, '10': 'inputTokens'},
    {'1': 'output_tokens', '3': 8, '4': 1, '5': 3, '10': 'outputTokens'},
    {'1': 'symbols', '3': 9, '4': 3, '5': 9, '10': 'symbols'},
    {
      '1': 'assistant_enabled',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'assistantEnabled'
    },
  ],
};

/// Descriptor for `GetShadowSnapshotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShadowSnapshotResponseDescriptor = $convert.base64Decode(
    'ChlHZXRTaGFkb3dTbmFwc2hvdFJlc3BvbnNlEjoKC2RlcGxveW1lbnRzGAEgAygLMhgubGFiLn'
    'YxLlNoYWRvd0RlcGxveW1lbnRSC2RlcGxveW1lbnRzEjQKCHNlbGVjdGVkGAIgASgLMhgubGFi'
    'LnYxLlNoYWRvd0RlcGxveW1lbnRSCHNlbGVjdGVkEj0KDG9ic2VydmF0aW9ucxgDIAMoCzIZLm'
    'xhYi52MS5TaGFkb3dPYnNlcnZhdGlvblIMb2JzZXJ2YXRpb25zEi8KCGJhc2VsaW5lGAQgASgL'
    'MhMubGFiLnYxLlNoYWRvd1RyYWNrUghiYXNlbGluZRIjCgJhaRgFIAEoCzITLmxhYi52MS5TaG'
    'Fkb3dUcmFja1ICYWkSIwoNc2FtcGxlZF9ob3VycxgGIAEoBVIMc2FtcGxlZEhvdXJzEiEKDGlu'
    'cHV0X3Rva2VucxgHIAEoA1ILaW5wdXRUb2tlbnMSIwoNb3V0cHV0X3Rva2VucxgIIAEoA1IMb3'
    'V0cHV0VG9rZW5zEhgKB3N5bWJvbHMYCSADKAlSB3N5bWJvbHMSKwoRYXNzaXN0YW50X2VuYWJs'
    'ZWQYCiABKAhSEGFzc2lzdGFudEVuYWJsZWQ=');

const $core.Map<$core.String, $core.dynamic> ShadowServiceBase$json = {
  '1': 'ShadowService',
  '2': [
    {
      '1': 'StartShadowDeployment',
      '2': '.lab.v1.StartShadowDeploymentRequest',
      '3': '.lab.v1.StartShadowDeploymentResponse'
    },
    {
      '1': 'StopShadowDeployment',
      '2': '.lab.v1.StopShadowDeploymentRequest',
      '3': '.lab.v1.StopShadowDeploymentResponse'
    },
    {
      '1': 'GetShadowSnapshot',
      '2': '.lab.v1.GetShadowSnapshotRequest',
      '3': '.lab.v1.GetShadowSnapshotResponse'
    },
  ],
};

@$core.Deprecated('Use shadowServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ShadowServiceBase$messageJson = {
  '.lab.v1.StartShadowDeploymentRequest': StartShadowDeploymentRequest$json,
  '.lab.v1.StartShadowDeploymentResponse': StartShadowDeploymentResponse$json,
  '.lab.v1.StopShadowDeploymentRequest': StopShadowDeploymentRequest$json,
  '.lab.v1.StopShadowDeploymentResponse': StopShadowDeploymentResponse$json,
  '.lab.v1.GetShadowSnapshotRequest': GetShadowSnapshotRequest$json,
  '.lab.v1.GetShadowSnapshotResponse': GetShadowSnapshotResponse$json,
  '.lab.v1.ShadowDeployment': ShadowDeployment$json,
  '.lab.v1.Money': $0.Money$json,
  '.lab.v1.Decimal': $0.Decimal$json,
  '.lab.v1.ShadowObservation': ShadowObservation$json,
  '.lab.v1.ShadowTrack': ShadowTrack$json,
  '.lab.v1.Metric': $0.Metric$json,
};

/// Descriptor for `ShadowService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List shadowServiceDescriptor = $convert.base64Decode(
    'Cg1TaGFkb3dTZXJ2aWNlEmQKFVN0YXJ0U2hhZG93RGVwbG95bWVudBIkLmxhYi52MS5TdGFydF'
    'NoYWRvd0RlcGxveW1lbnRSZXF1ZXN0GiUubGFiLnYxLlN0YXJ0U2hhZG93RGVwbG95bWVudFJl'
    'c3BvbnNlEmEKFFN0b3BTaGFkb3dEZXBsb3ltZW50EiMubGFiLnYxLlN0b3BTaGFkb3dEZXBsb3'
    'ltZW50UmVxdWVzdBokLmxhYi52MS5TdG9wU2hhZG93RGVwbG95bWVudFJlc3BvbnNlElgKEUdl'
    'dFNoYWRvd1NuYXBzaG90EiAubGFiLnYxLkdldFNoYWRvd1NuYXBzaG90UmVxdWVzdBohLmxhYi'
    '52MS5HZXRTaGFkb3dTbmFwc2hvdFJlc3BvbnNl');
