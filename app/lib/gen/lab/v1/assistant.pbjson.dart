// This is a generated file - do not edit.
//
// Generated from lab/v1/assistant.proto.

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

@$core.Deprecated('Use explanationFocusDescriptor instead')
const ExplanationFocus$json = {
  '1': 'ExplanationFocus',
  '2': [
    {'1': 'EXPLANATION_FOCUS_UNSPECIFIED', '2': 0},
    {'1': 'EXPLANATION_FOCUS_RULE', '2': 1},
    {'1': 'EXPLANATION_FOCUS_SNAPSHOT', '2': 2},
    {'1': 'EXPLANATION_FOCUS_REPORT', '2': 3},
  ],
};

/// Descriptor for `ExplanationFocus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List explanationFocusDescriptor = $convert.base64Decode(
    'ChBFeHBsYW5hdGlvbkZvY3VzEiEKHUVYUExBTkFUSU9OX0ZPQ1VTX1VOU1BFQ0lGSUVEEAASGg'
    'oWRVhQTEFOQVRJT05fRk9DVVNfUlVMRRABEh4KGkVYUExBTkFUSU9OX0ZPQ1VTX1NOQVBTSE9U'
    'EAISHAoYRVhQTEFOQVRJT05fRk9DVVNfUkVQT1JUEAM=');

@$core.Deprecated('Use explainOpportunityRequestDescriptor instead')
const ExplainOpportunityRequest$json = {
  '1': 'ExplainOpportunityRequest',
  '2': [
    {'1': 'opportunity_id', '3': 1, '4': 1, '5': 3, '10': 'opportunityId'},
  ],
};

/// Descriptor for `ExplainOpportunityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List explainOpportunityRequestDescriptor =
    $convert.base64Decode(
        'ChlFeHBsYWluT3Bwb3J0dW5pdHlSZXF1ZXN0EiUKDm9wcG9ydHVuaXR5X2lkGAEgASgDUg1vcH'
        'BvcnR1bml0eUlk');

@$core.Deprecated('Use explainOpportunityResponseDescriptor instead')
const ExplainOpportunityResponse$json = {
  '1': 'ExplainOpportunityResponse',
  '2': [
    {
      '1': 'focus',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.ExplanationFocus',
      '10': 'focus'
    },
    {'1': 'rule_version_id', '3': 2, '4': 1, '5': 3, '10': 'ruleVersionId'},
    {'1': 'report_id', '3': 3, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'reference_close',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'referenceClose'
    },
    {
      '1': 'candle_closed_at_unix_ms',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'candleClosedAtUnixMs'
    },
    {
      '1': 'expires_at_unix_ms',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'expiresAtUnixMs'
    },
    {'1': 'model', '3': 8, '4': 1, '5': 9, '10': 'model'},
    {'1': 'input_tokens', '3': 9, '4': 1, '5': 5, '10': 'inputTokens'},
    {'1': 'output_tokens', '3': 10, '4': 1, '5': 5, '10': 'outputTokens'},
    {'1': 'cached', '3': 11, '4': 1, '5': 8, '10': 'cached'},
  ],
};

/// Descriptor for `ExplainOpportunityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List explainOpportunityResponseDescriptor = $convert.base64Decode(
    'ChpFeHBsYWluT3Bwb3J0dW5pdHlSZXNwb25zZRIuCgVmb2N1cxgBIAEoDjIYLmxhYi52MS5FeH'
    'BsYW5hdGlvbkZvY3VzUgVmb2N1cxImCg9ydWxlX3ZlcnNpb25faWQYAiABKANSDXJ1bGVWZXJz'
    'aW9uSWQSGwoJcmVwb3J0X2lkGAMgASgJUghyZXBvcnRJZBIWCgZyZWFzb24YBCABKAlSBnJlYX'
    'NvbhI2Cg9yZWZlcmVuY2VfY2xvc2UYBSABKAsyDS5sYWIudjEuTW9uZXlSDnJlZmVyZW5jZUNs'
    'b3NlEjYKGGNhbmRsZV9jbG9zZWRfYXRfdW5peF9tcxgGIAEoA1IUY2FuZGxlQ2xvc2VkQXRVbm'
    'l4TXMSKwoSZXhwaXJlc19hdF91bml4X21zGAcgASgDUg9leHBpcmVzQXRVbml4TXMSFAoFbW9k'
    'ZWwYCCABKAlSBW1vZGVsEiEKDGlucHV0X3Rva2VucxgJIAEoBVILaW5wdXRUb2tlbnMSIwoNb3'
    'V0cHV0X3Rva2VucxgKIAEoBVIMb3V0cHV0VG9rZW5zEhYKBmNhY2hlZBgLIAEoCFIGY2FjaGVk');

const $core.Map<$core.String, $core.dynamic> AssistantServiceBase$json = {
  '1': 'AssistantService',
  '2': [
    {
      '1': 'ExplainOpportunity',
      '2': '.lab.v1.ExplainOpportunityRequest',
      '3': '.lab.v1.ExplainOpportunityResponse'
    },
  ],
};

@$core.Deprecated('Use assistantServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AssistantServiceBase$messageJson = {
  '.lab.v1.ExplainOpportunityRequest': ExplainOpportunityRequest$json,
  '.lab.v1.ExplainOpportunityResponse': ExplainOpportunityResponse$json,
  '.lab.v1.Money': $0.Money$json,
};

/// Descriptor for `AssistantService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List assistantServiceDescriptor = $convert.base64Decode(
    'ChBBc3Npc3RhbnRTZXJ2aWNlElsKEkV4cGxhaW5PcHBvcnR1bml0eRIhLmxhYi52MS5FeHBsYW'
    'luT3Bwb3J0dW5pdHlSZXF1ZXN0GiIubGFiLnYxLkV4cGxhaW5PcHBvcnR1bml0eVJlc3BvbnNl');
