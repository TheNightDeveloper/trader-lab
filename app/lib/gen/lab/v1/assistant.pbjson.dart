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

import 'common.pbjson.dart' as $1;
import 'report.pbjson.dart' as $0;

@$core.Deprecated('Use researchFocusDescriptor instead')
const ResearchFocus$json = {
  '1': 'ResearchFocus',
  '2': [
    {'1': 'RESEARCH_FOCUS_UNSPECIFIED', '2': 0},
    {'1': 'RESEARCH_FOCUS_ASSUMPTIONS', '2': 1},
    {'1': 'RESEARCH_FOCUS_RETURN', '2': 2},
    {'1': 'RESEARCH_FOCUS_DRAWDOWN', '2': 3},
    {'1': 'RESEARCH_FOCUS_SAMPLE', '2': 4},
  ],
};

/// Descriptor for `ResearchFocus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List researchFocusDescriptor = $convert.base64Decode(
    'Cg1SZXNlYXJjaEZvY3VzEh4KGlJFU0VBUkNIX0ZPQ1VTX1VOU1BFQ0lGSUVEEAASHgoaUkVTRU'
    'FSQ0hfRk9DVVNfQVNTVU1QVElPTlMQARIZChVSRVNFQVJDSF9GT0NVU19SRVRVUk4QAhIbChdS'
    'RVNFQVJDSF9GT0NVU19EUkFXRE9XThADEhkKFVJFU0VBUkNIX0ZPQ1VTX1NBTVBMRRAE');

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

@$core.Deprecated('Use reviewReportsRequestDescriptor instead')
const ReviewReportsRequest$json = {
  '1': 'ReviewReportsRequest',
  '2': [
    {'1': 'report_ids', '3': 1, '4': 3, '5': 9, '10': 'reportIds'},
  ],
};

/// Descriptor for `ReviewReportsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewReportsRequestDescriptor = $convert.base64Decode(
    'ChRSZXZpZXdSZXBvcnRzUmVxdWVzdBIdCgpyZXBvcnRfaWRzGAEgAygJUglyZXBvcnRJZHM=');

@$core.Deprecated('Use researchReferenceDescriptor instead')
const ResearchReference$json = {
  '1': 'ResearchReference',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'oos_window',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Window',
      '10': 'oosWindow'
    },
    {
      '1': 'metric',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'metric'
    },
  ],
};

/// Descriptor for `ResearchReference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List researchReferenceDescriptor = $convert.base64Decode(
    'ChFSZXNlYXJjaFJlZmVyZW5jZRIbCglyZXBvcnRfaWQYASABKAlSCHJlcG9ydElkEhQKBXRpdG'
    'xlGAIgASgJUgV0aXRsZRItCgpvb3Nfd2luZG93GAMgASgLMg4ubGFiLnYxLldpbmRvd1IJb29z'
    'V2luZG93EiYKBm1ldHJpYxgEIAEoCzIOLmxhYi52MS5NZXRyaWNSBm1ldHJpYw==');

@$core.Deprecated('Use reviewReportsResponseDescriptor instead')
const ReviewReportsResponse$json = {
  '1': 'ReviewReportsResponse',
  '2': [
    {
      '1': 'focus',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.ResearchFocus',
      '10': 'focus'
    },
    {
      '1': 'references',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ResearchReference',
      '10': 'references'
    },
    {
      '1': 'blocking_assumptions',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Assumption',
      '10': 'blockingAssumptions'
    },
    {
      '1': 'minimum_closed_trades',
      '3': 4,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'minimumClosedTrades',
      '17': true
    },
    {'1': 'model', '3': 5, '4': 1, '5': 9, '10': 'model'},
    {'1': 'input_tokens', '3': 6, '4': 1, '5': 5, '10': 'inputTokens'},
    {'1': 'output_tokens', '3': 7, '4': 1, '5': 5, '10': 'outputTokens'},
    {'1': 'cached', '3': 8, '4': 1, '5': 8, '10': 'cached'},
  ],
  '8': [
    {'1': '_minimum_closed_trades'},
  ],
};

/// Descriptor for `ReviewReportsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewReportsResponseDescriptor = $convert.base64Decode(
    'ChVSZXZpZXdSZXBvcnRzUmVzcG9uc2USKwoFZm9jdXMYASABKA4yFS5sYWIudjEuUmVzZWFyY2'
    'hGb2N1c1IFZm9jdXMSOQoKcmVmZXJlbmNlcxgCIAMoCzIZLmxhYi52MS5SZXNlYXJjaFJlZmVy'
    'ZW5jZVIKcmVmZXJlbmNlcxJFChRibG9ja2luZ19hc3N1bXB0aW9ucxgDIAMoCzISLmxhYi52MS'
    '5Bc3N1bXB0aW9uUhNibG9ja2luZ0Fzc3VtcHRpb25zEjcKFW1pbmltdW1fY2xvc2VkX3RyYWRl'
    'cxgEIAEoBUgAUhNtaW5pbXVtQ2xvc2VkVHJhZGVziAEBEhQKBW1vZGVsGAUgASgJUgVtb2RlbB'
    'IhCgxpbnB1dF90b2tlbnMYBiABKAVSC2lucHV0VG9rZW5zEiMKDW91dHB1dF90b2tlbnMYByAB'
    'KAVSDG91dHB1dFRva2VucxIWCgZjYWNoZWQYCCABKAhSBmNhY2hlZEIYChZfbWluaW11bV9jbG'
    '9zZWRfdHJhZGVz');

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
    {
      '1': 'ReviewReports',
      '2': '.lab.v1.ReviewReportsRequest',
      '3': '.lab.v1.ReviewReportsResponse'
    },
  ],
};

@$core.Deprecated('Use assistantServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AssistantServiceBase$messageJson = {
  '.lab.v1.ExplainOpportunityRequest': ExplainOpportunityRequest$json,
  '.lab.v1.ExplainOpportunityResponse': ExplainOpportunityResponse$json,
  '.lab.v1.Money': $1.Money$json,
  '.lab.v1.ReviewReportsRequest': ReviewReportsRequest$json,
  '.lab.v1.ReviewReportsResponse': ReviewReportsResponse$json,
  '.lab.v1.ResearchReference': ResearchReference$json,
  '.lab.v1.Window': $0.Window$json,
  '.lab.v1.Metric': $1.Metric$json,
  '.lab.v1.Decimal': $1.Decimal$json,
  '.lab.v1.Assumption': $0.Assumption$json,
};

/// Descriptor for `AssistantService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List assistantServiceDescriptor = $convert.base64Decode(
    'ChBBc3Npc3RhbnRTZXJ2aWNlElsKEkV4cGxhaW5PcHBvcnR1bml0eRIhLmxhYi52MS5FeHBsYW'
    'luT3Bwb3J0dW5pdHlSZXF1ZXN0GiIubGFiLnYxLkV4cGxhaW5PcHBvcnR1bml0eVJlc3BvbnNl'
    'EkwKDVJldmlld1JlcG9ydHMSHC5sYWIudjEuUmV2aWV3UmVwb3J0c1JlcXVlc3QaHS5sYWIudj'
    'EuUmV2aWV3UmVwb3J0c1Jlc3BvbnNl');
