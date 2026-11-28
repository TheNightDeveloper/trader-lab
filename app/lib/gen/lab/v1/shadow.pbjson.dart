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

@$core.Deprecated('Use shadowUserDecisionDescriptor instead')
const ShadowUserDecision$json = {
  '1': 'ShadowUserDecision',
  '2': [
    {'1': 'SHADOW_USER_DECISION_UNSPECIFIED', '2': 0},
    {'1': 'SHADOW_USER_DECISION_OPEN', '2': 1},
    {'1': 'SHADOW_USER_DECISION_ALLOW', '2': 2},
    {'1': 'SHADOW_USER_DECISION_SKIP', '2': 3},
    {'1': 'SHADOW_USER_DECISION_UNANSWERED', '2': 4},
  ],
};

/// Descriptor for `ShadowUserDecision`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List shadowUserDecisionDescriptor = $convert.base64Decode(
    'ChJTaGFkb3dVc2VyRGVjaXNpb24SJAogU0hBRE9XX1VTRVJfREVDSVNJT05fVU5TUEVDSUZJRU'
    'QQABIdChlTSEFET1dfVVNFUl9ERUNJU0lPTl9PUEVOEAESHgoaU0hBRE9XX1VTRVJfREVDSVNJ'
    'T05fQUxMT1cQAhIdChlTSEFET1dfVVNFUl9ERUNJU0lPTl9TS0lQEAMSIwofU0hBRE9XX1VTRV'
    'JfREVDSVNJT05fVU5BTlNXRVJFRBAE');

@$core.Deprecated('Use startShadowDeploymentRequestDescriptor instead')
const StartShadowDeploymentRequest$json = {
  '1': 'StartShadowDeploymentRequest',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'rule_version_id', '3': 2, '4': 1, '5': 3, '10': 'ruleVersionId'},
    {'1': 'user_track', '3': 3, '4': 1, '5': 8, '10': 'userTrack'},
  ],
};

/// Descriptor for `StartShadowDeploymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startShadowDeploymentRequestDescriptor =
    $convert.base64Decode(
        'ChxTdGFydFNoYWRvd0RlcGxveW1lbnRSZXF1ZXN0EhYKBnN5bWJvbBgBIAEoCVIGc3ltYm9sEi'
        'YKD3J1bGVfdmVyc2lvbl9pZBgCIAEoA1INcnVsZVZlcnNpb25JZBIdCgp1c2VyX3RyYWNrGAMg'
        'ASgIUgl1c2VyVHJhY2s=');

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

@$core.Deprecated('Use setShadowUserDecisionRequestDescriptor instead')
const SetShadowUserDecisionRequest$json = {
  '1': 'SetShadowUserDecisionRequest',
  '2': [
    {'1': 'deployment_id', '3': 1, '4': 1, '5': 3, '10': 'deploymentId'},
    {'1': 'observation_id', '3': 2, '4': 1, '5': 3, '10': 'observationId'},
    {'1': 'allow', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'allow', '17': true},
  ],
  '8': [
    {'1': '_allow'},
  ],
};

/// Descriptor for `SetShadowUserDecisionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setShadowUserDecisionRequestDescriptor =
    $convert.base64Decode(
        'ChxTZXRTaGFkb3dVc2VyRGVjaXNpb25SZXF1ZXN0EiMKDWRlcGxveW1lbnRfaWQYASABKANSDG'
        'RlcGxveW1lbnRJZBIlCg5vYnNlcnZhdGlvbl9pZBgCIAEoA1INb2JzZXJ2YXRpb25JZBIZCgVh'
        'bGxvdxgDIAEoCEgAUgVhbGxvd4gBAUIICgZfYWxsb3c=');

@$core.Deprecated('Use setShadowUserDecisionResponseDescriptor instead')
const SetShadowUserDecisionResponse$json = {
  '1': 'SetShadowUserDecisionResponse',
  '2': [
    {
      '1': 'decided_at_unix_ms',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'decidedAtUnixMs'
    },
  ],
};

/// Descriptor for `SetShadowUserDecisionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setShadowUserDecisionResponseDescriptor =
    $convert.base64Decode(
        'Ch1TZXRTaGFkb3dVc2VyRGVjaXNpb25SZXNwb25zZRIrChJkZWNpZGVkX2F0X3VuaXhfbXMYAS'
        'ABKANSD2RlY2lkZWRBdFVuaXhNcw==');

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
    {'1': 'user_track', '3': 17, '4': 1, '5': 8, '10': 'userTrack'},
    {
      '1': 'model_input_per_million',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'modelInputPerMillion'
    },
    {
      '1': 'model_output_per_million',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'modelOutputPerMillion'
    },
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
    'dpbmVCdWlsZBIdCgp1c2VyX3RyYWNrGBEgASgIUgl1c2VyVHJhY2sSRAoXbW9kZWxfaW5wdXRf'
    'cGVyX21pbGxpb24YEiABKAsyDS5sYWIudjEuTW9uZXlSFG1vZGVsSW5wdXRQZXJNaWxsaW9uEk'
    'YKGG1vZGVsX291dHB1dF9wZXJfbWlsbGlvbhgTIAEoCzINLmxhYi52MS5Nb25leVIVbW9kZWxP'
    'dXRwdXRQZXJNaWxsaW9u');

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
    {'1': 'id', '3': 7, '4': 1, '5': 3, '10': 'id'},
    {
      '1': 'user_decision',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.ShadowUserDecision',
      '10': 'userDecision'
    },
    {
      '1': 'user_decided_at_unix_ms',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'userDecidedAtUnixMs'
    },
    {
      '1': 'baseline_entry',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowEntryEvidence',
      '10': 'baselineEntry'
    },
    {
      '1': 'ai_entry',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowEntryEvidence',
      '10': 'aiEntry'
    },
    {
      '1': 'user_entry',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowEntryEvidence',
      '10': 'userEntry'
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
    '9sdmVkX2F0X3VuaXhfbXMYBiABKANSFGdhdGVSZXNvbHZlZEF0VW5peE1zEg4KAmlkGAcgASgD'
    'UgJpZBI/Cg11c2VyX2RlY2lzaW9uGAggASgOMhoubGFiLnYxLlNoYWRvd1VzZXJEZWNpc2lvbl'
    'IMdXNlckRlY2lzaW9uEjQKF3VzZXJfZGVjaWRlZF9hdF91bml4X21zGAkgASgDUhN1c2VyRGVj'
    'aWRlZEF0VW5peE1zEkIKDmJhc2VsaW5lX2VudHJ5GAogASgLMhsubGFiLnYxLlNoYWRvd0VudH'
    'J5RXZpZGVuY2VSDWJhc2VsaW5lRW50cnkSNgoIYWlfZW50cnkYCyABKAsyGy5sYWIudjEuU2hh'
    'ZG93RW50cnlFdmlkZW5jZVIHYWlFbnRyeRI6Cgp1c2VyX2VudHJ5GAwgASgLMhsubGFiLnYxLl'
    'NoYWRvd0VudHJ5RXZpZGVuY2VSCXVzZXJFbnRyeQ==');

@$core.Deprecated('Use shadowEntryEvidenceDescriptor instead')
const ShadowEntryEvidence$json = {
  '1': 'ShadowEntryEvidence',
  '2': [
    {'1': 'filled_at_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'filledAtUnixMs'},
  ],
};

/// Descriptor for `ShadowEntryEvidence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowEntryEvidenceDescriptor = $convert.base64Decode(
    'ChNTaGFkb3dFbnRyeUV2aWRlbmNlEikKEWZpbGxlZF9hdF91bml4X21zGAEgASgDUg5maWxsZW'
    'RBdFVuaXhNcw==');

@$core.Deprecated('Use shadowAttributionDescriptor instead')
const ShadowAttribution$json = {
  '1': 'ShadowAttribution',
  '2': [
    {
      '1': 'net_pnl_delta',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'netPnlDelta'
    },
    {
      '1': 'return_delta',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'returnDelta'
    },
    {'1': 'shared_entries', '3': 3, '4': 1, '5': 5, '10': 'sharedEntries'},
    {
      '1': 'baseline_only_entries',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'baselineOnlyEntries'
    },
    {
      '1': 'track_only_entries',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'trackOnlyEntries'
    },
  ],
};

/// Descriptor for `ShadowAttribution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowAttributionDescriptor = $convert.base64Decode(
    'ChFTaGFkb3dBdHRyaWJ1dGlvbhIxCg1uZXRfcG5sX2RlbHRhGAEgASgLMg0ubGFiLnYxLk1vbm'
    'V5UgtuZXRQbmxEZWx0YRIyCgxyZXR1cm5fZGVsdGEYAiABKAsyDy5sYWIudjEuRGVjaW1hbFIL'
    'cmV0dXJuRGVsdGESJQoOc2hhcmVkX2VudHJpZXMYAyABKAVSDXNoYXJlZEVudHJpZXMSMgoVYm'
    'FzZWxpbmVfb25seV9lbnRyaWVzGAQgASgFUhNiYXNlbGluZU9ubHlFbnRyaWVzEiwKEnRyYWNr'
    'X29ubHlfZW50cmllcxgFIAEoBVIQdHJhY2tPbmx5RW50cmllcw==');

@$core.Deprecated('Use shadowPeriodResultDescriptor instead')
const ShadowPeriodResult$json = {
  '1': 'ShadowPeriodResult',
  '2': [
    {'1': 'from_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'fromUnixMs'},
    {'1': 'sampled_hours', '3': 2, '4': 1, '5': 5, '10': 'sampledHours'},
    {
      '1': 'net_pnl',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'netPnl'
    },
  ],
};

/// Descriptor for `ShadowPeriodResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowPeriodResultDescriptor = $convert.base64Decode(
    'ChJTaGFkb3dQZXJpb2RSZXN1bHQSIAoMZnJvbV91bml4X21zGAEgASgDUgpmcm9tVW5peE1zEi'
    'MKDXNhbXBsZWRfaG91cnMYAiABKAVSDHNhbXBsZWRIb3VycxImCgduZXRfcG5sGAMgASgLMg0u'
    'bGFiLnYxLk1vbmV5UgZuZXRQbmw=');

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
    {
      '1': 'attribution',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowAttribution',
      '10': 'attribution'
    },
    {
      '1': 'periods',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ShadowPeriodResult',
      '10': 'periods'
    },
  ],
};

/// Descriptor for `ShadowTrack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowTrackDescriptor = $convert.base64Decode(
    'CgtTaGFkb3dUcmFjaxIoCgdtZXRyaWNzGAEgAygLMg4ubGFiLnYxLk1ldHJpY1IHbWV0cmljcx'
    'IYCgdlbnRyaWVzGAIgASgFUgdlbnRyaWVzEjsKC2F0dHJpYnV0aW9uGAMgASgLMhkubGFiLnYx'
    'LlNoYWRvd0F0dHJpYnV0aW9uUgthdHRyaWJ1dGlvbhI0CgdwZXJpb2RzGAQgAygLMhoubGFiLn'
    'YxLlNoYWRvd1BlcmlvZFJlc3VsdFIHcGVyaW9kcw==');

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
    {
      '1': 'user',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowTrack',
      '10': 'user'
    },
    {
      '1': 'estimated_model_cost',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'estimatedModelCost'
    },
    {'1': 'model_attempts', '3': 13, '4': 1, '5': 5, '10': 'modelAttempts'},
    {
      '1': 'missing_model_usage',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'missingModelUsage'
    },
    {
      '1': 'minimum_closed_trades',
      '3': 15,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'minimumClosedTrades',
      '17': true
    },
  ],
  '8': [
    {'1': '_minimum_closed_trades'},
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
    'ZWQYCiABKAhSEGFzc2lzdGFudEVuYWJsZWQSJwoEdXNlchgLIAEoCzITLmxhYi52MS5TaGFkb3'
    'dUcmFja1IEdXNlchI/ChRlc3RpbWF0ZWRfbW9kZWxfY29zdBgMIAEoCzINLmxhYi52MS5Nb25l'
    'eVISZXN0aW1hdGVkTW9kZWxDb3N0EiUKDm1vZGVsX2F0dGVtcHRzGA0gASgFUg1tb2RlbEF0dG'
    'VtcHRzEi4KE21pc3NpbmdfbW9kZWxfdXNhZ2UYDiABKAVSEW1pc3NpbmdNb2RlbFVzYWdlEjcK'
    'FW1pbmltdW1fY2xvc2VkX3RyYWRlcxgPIAEoBUgAUhNtaW5pbXVtQ2xvc2VkVHJhZGVziAEBQh'
    'gKFl9taW5pbXVtX2Nsb3NlZF90cmFkZXM=');

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
    {
      '1': 'SetShadowUserDecision',
      '2': '.lab.v1.SetShadowUserDecisionRequest',
      '3': '.lab.v1.SetShadowUserDecisionResponse'
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
  '.lab.v1.ShadowEntryEvidence': ShadowEntryEvidence$json,
  '.lab.v1.ShadowTrack': ShadowTrack$json,
  '.lab.v1.Metric': $0.Metric$json,
  '.lab.v1.ShadowAttribution': ShadowAttribution$json,
  '.lab.v1.ShadowPeriodResult': ShadowPeriodResult$json,
  '.lab.v1.SetShadowUserDecisionRequest': SetShadowUserDecisionRequest$json,
  '.lab.v1.SetShadowUserDecisionResponse': SetShadowUserDecisionResponse$json,
};

/// Descriptor for `ShadowService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List shadowServiceDescriptor = $convert.base64Decode(
    'Cg1TaGFkb3dTZXJ2aWNlEmQKFVN0YXJ0U2hhZG93RGVwbG95bWVudBIkLmxhYi52MS5TdGFydF'
    'NoYWRvd0RlcGxveW1lbnRSZXF1ZXN0GiUubGFiLnYxLlN0YXJ0U2hhZG93RGVwbG95bWVudFJl'
    'c3BvbnNlEmEKFFN0b3BTaGFkb3dEZXBsb3ltZW50EiMubGFiLnYxLlN0b3BTaGFkb3dEZXBsb3'
    'ltZW50UmVxdWVzdBokLmxhYi52MS5TdG9wU2hhZG93RGVwbG95bWVudFJlc3BvbnNlElgKEUdl'
    'dFNoYWRvd1NuYXBzaG90EiAubGFiLnYxLkdldFNoYWRvd1NuYXBzaG90UmVxdWVzdBohLmxhYi'
    '52MS5HZXRTaGFkb3dTbmFwc2hvdFJlc3BvbnNlEmQKFVNldFNoYWRvd1VzZXJEZWNpc2lvbhIk'
    'LmxhYi52MS5TZXRTaGFkb3dVc2VyRGVjaXNpb25SZXF1ZXN0GiUubGFiLnYxLlNldFNoYWRvd1'
    'VzZXJEZWNpc2lvblJlc3BvbnNl');
