// This is a generated file - do not edit.
//
// Generated from lab/v1/library.proto.

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

import 'audit.pbjson.dart' as $2;
import 'common.pbjson.dart' as $1;
import 'report.pbjson.dart' as $0;
import 'workspace.pbjson.dart' as $3;

@$core.Deprecated('Use algorithmVersionDescriptor instead')
const AlgorithmVersion$json = {
  '1': 'AlgorithmVersion',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'state', '3': 3, '4': 1, '5': 9, '10': 'state'},
    {'1': 'content_hash', '3': 4, '4': 1, '5': 9, '10': 'contentHash'},
    {
      '1': 'params',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ParamSpec',
      '10': 'params'
    },
    {'1': 'created_unix_ms', '3': 6, '4': 1, '5': 3, '10': 'createdUnixMs'},
    {'1': 'next_states', '3': 7, '4': 3, '5': 9, '10': 'nextStates'},
    {
      '1': 'recipe',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.RecipeItem',
      '10': 'recipe'
    },
  ],
};

/// Descriptor for `AlgorithmVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List algorithmVersionDescriptor = $convert.base64Decode(
    'ChBBbGdvcml0aG1WZXJzaW9uEg4KAmlkGAEgASgJUgJpZBIYCgd2ZXJzaW9uGAIgASgFUgd2ZX'
    'JzaW9uEhQKBXN0YXRlGAMgASgJUgVzdGF0ZRIhCgxjb250ZW50X2hhc2gYBCABKAlSC2NvbnRl'
    'bnRIYXNoEikKBnBhcmFtcxgFIAMoCzIRLmxhYi52MS5QYXJhbVNwZWNSBnBhcmFtcxImCg9jcm'
    'VhdGVkX3VuaXhfbXMYBiABKANSDWNyZWF0ZWRVbml4TXMSHwoLbmV4dF9zdGF0ZXMYByADKAlS'
    'Cm5leHRTdGF0ZXMSKgoGcmVjaXBlGAggAygLMhIubGFiLnYxLlJlY2lwZUl0ZW1SBnJlY2lwZQ'
    '==');

@$core.Deprecated('Use recipeItemDescriptor instead')
const RecipeItem$json = {
  '1': 'RecipeItem',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `RecipeItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeItemDescriptor = $convert.base64Decode(
    'CgpSZWNpcGVJdGVtEhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZQ==');

@$core.Deprecated('Use latestReportDescriptor instead')
const LatestReport$json = {
  '1': 'LatestReport',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {
      '1': 'total_return',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'totalReturn'
    },
    {'1': 'created_unix_ms', '3': 3, '4': 1, '5': 3, '10': 'createdUnixMs'},
  ],
};

/// Descriptor for `LatestReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latestReportDescriptor = $convert.base64Decode(
    'CgxMYXRlc3RSZXBvcnQSGwoJcmVwb3J0X2lkGAEgASgJUghyZXBvcnRJZBIyCgx0b3RhbF9yZX'
    'R1cm4YAiABKAsyDy5sYWIudjEuRGVjaW1hbFILdG90YWxSZXR1cm4SJgoPY3JlYXRlZF91bml4'
    'X21zGAMgASgDUg1jcmVhdGVkVW5peE1z');

@$core.Deprecated('Use algorithmDescriptor instead')
const Algorithm$json = {
  '1': 'Algorithm',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'family', '3': 2, '4': 1, '5': 9, '10': 'family'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'versions',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.AlgorithmVersion',
      '10': 'versions'
    },
    {
      '1': 'latest_report',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.LatestReport',
      '10': 'latestReport'
    },
    {'1': 'active_model', '3': 6, '4': 1, '5': 9, '10': 'activeModel'},
    {
      '1': 'lifecycle_revision',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'lifecycleRevision'
    },
  ],
};

/// Descriptor for `Algorithm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List algorithmDescriptor = $convert.base64Decode(
    'CglBbGdvcml0aG0SDgoCaWQYASABKAlSAmlkEhYKBmZhbWlseRgCIAEoCVIGZmFtaWx5EiAKC2'
    'Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhI0Cgh2ZXJzaW9ucxgEIAMoCzIYLmxhYi52'
    'MS5BbGdvcml0aG1WZXJzaW9uUgh2ZXJzaW9ucxI5Cg1sYXRlc3RfcmVwb3J0GAUgASgLMhQubG'
    'FiLnYxLkxhdGVzdFJlcG9ydFIMbGF0ZXN0UmVwb3J0EiEKDGFjdGl2ZV9tb2RlbBgGIAEoCVIL'
    'YWN0aXZlTW9kZWwSLQoSbGlmZWN5Y2xlX3JldmlzaW9uGAcgASgDUhFsaWZlY3ljbGVSZXZpc2'
    'lvbg==');

@$core.Deprecated('Use listAlgorithmsRequestDescriptor instead')
const ListAlgorithmsRequest$json = {
  '1': 'ListAlgorithmsRequest',
};

/// Descriptor for `ListAlgorithmsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlgorithmsRequestDescriptor =
    $convert.base64Decode('ChVMaXN0QWxnb3JpdGhtc1JlcXVlc3Q=');

@$core.Deprecated('Use listAlgorithmsResponseDescriptor instead')
const ListAlgorithmsResponse$json = {
  '1': 'ListAlgorithmsResponse',
  '2': [
    {
      '1': 'algorithms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Algorithm',
      '10': 'algorithms'
    },
  ],
};

/// Descriptor for `ListAlgorithmsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlgorithmsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0QWxnb3JpdGhtc1Jlc3BvbnNlEjEKCmFsZ29yaXRobXMYASADKAsyES5sYWIudjEuQW'
        'xnb3JpdGhtUgphbGdvcml0aG1z');

@$core.Deprecated('Use setVersionStateRequestDescriptor instead')
const SetVersionStateRequest$json = {
  '1': 'SetVersionStateRequest',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'state', '3': 2, '4': 1, '5': 9, '10': 'state'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'expected_revision',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'expectedRevision',
      '17': true
    },
  ],
  '8': [
    {'1': '_expected_revision'},
  ],
};

/// Descriptor for `SetVersionStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setVersionStateRequestDescriptor = $convert.base64Decode(
    'ChZTZXRWZXJzaW9uU3RhdGVSZXF1ZXN0Eh0KCnZlcnNpb25faWQYASABKAlSCXZlcnNpb25JZB'
    'IUCgVzdGF0ZRgCIAEoCVIFc3RhdGUSEgoEbm90ZRgDIAEoCVIEbm90ZRIwChFleHBlY3RlZF9y'
    'ZXZpc2lvbhgEIAEoA0gAUhBleHBlY3RlZFJldmlzaW9uiAEBQhQKEl9leHBlY3RlZF9yZXZpc2'
    'lvbg==');

@$core.Deprecated('Use setVersionStateResponseDescriptor instead')
const SetVersionStateResponse$json = {
  '1': 'SetVersionStateResponse',
};

/// Descriptor for `SetVersionStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setVersionStateResponseDescriptor =
    $convert.base64Decode('ChdTZXRWZXJzaW9uU3RhdGVSZXNwb25zZQ==');

@$core.Deprecated('Use lifecycleEventDescriptor instead')
const LifecycleEvent$json = {
  '1': 'LifecycleEvent',
  '2': [
    {'1': 'from_state', '3': 1, '4': 1, '5': 9, '10': 'fromState'},
    {'1': 'to_state', '3': 2, '4': 1, '5': 9, '10': 'toState'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'actor', '3': 4, '4': 1, '5': 9, '10': 'actor'},
    {'1': 'at_unix_ms', '3': 5, '4': 1, '5': 3, '10': 'atUnixMs'},
    {
      '1': 'audit',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AuditEvent',
      '10': 'audit'
    },
  ],
};

/// Descriptor for `LifecycleEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lifecycleEventDescriptor = $convert.base64Decode(
    'Cg5MaWZlY3ljbGVFdmVudBIdCgpmcm9tX3N0YXRlGAEgASgJUglmcm9tU3RhdGUSGQoIdG9fc3'
    'RhdGUYAiABKAlSB3RvU3RhdGUSEgoEbm90ZRgDIAEoCVIEbm90ZRIUCgVhY3RvchgEIAEoCVIF'
    'YWN0b3ISHAoKYXRfdW5peF9tcxgFIAEoA1IIYXRVbml4TXMSKAoFYXVkaXQYBiABKAsyEi5sYW'
    'IudjEuQXVkaXRFdmVudFIFYXVkaXQ=');

@$core.Deprecated('Use listLifecycleEventsRequestDescriptor instead')
const ListLifecycleEventsRequest$json = {
  '1': 'ListLifecycleEventsRequest',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'before',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AuditCursor',
      '10': 'before'
    },
  ],
};

/// Descriptor for `ListLifecycleEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLifecycleEventsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0TGlmZWN5Y2xlRXZlbnRzUmVxdWVzdBIdCgp2ZXJzaW9uX2lkGAEgASgJUgl2ZXJzaW'
        '9uSWQSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZRIrCgZiZWZvcmUYAyABKAsyEy5sYWIu'
        'djEuQXVkaXRDdXJzb3JSBmJlZm9yZQ==');

@$core.Deprecated('Use listLifecycleEventsResponseDescriptor instead')
const ListLifecycleEventsResponse$json = {
  '1': 'ListLifecycleEventsResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.LifecycleEvent',
      '10': 'events'
    },
    {
      '1': 'next_cursor',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AuditCursor',
      '10': 'nextCursor'
    },
  ],
};

/// Descriptor for `ListLifecycleEventsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLifecycleEventsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0TGlmZWN5Y2xlRXZlbnRzUmVzcG9uc2USLgoGZXZlbnRzGAEgAygLMhYubGFiLnYxLk'
        'xpZmVjeWNsZUV2ZW50UgZldmVudHMSNAoLbmV4dF9jdXJzb3IYAiABKAsyEy5sYWIudjEuQXVk'
        'aXRDdXJzb3JSCm5leHRDdXJzb3I=');

@$core.Deprecated('Use ruleVersionSummaryDescriptor instead')
const RuleVersionSummary$json = {
  '1': 'RuleVersionSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'content_hash', '3': 3, '4': 1, '5': 9, '10': 'contentHash'},
    {'1': 'parent_id', '3': 4, '4': 1, '5': 3, '10': 'parentId'},
    {'1': 'other_parent_id', '3': 5, '4': 1, '5': 3, '10': 'otherParentId'},
    {'1': 'template_key', '3': 6, '4': 1, '5': 9, '10': 'templateKey'},
    {'1': 'created_unix_ms', '3': 7, '4': 1, '5': 3, '10': 'createdUnixMs'},
  ],
};

/// Descriptor for `RuleVersionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ruleVersionSummaryDescriptor = $convert.base64Decode(
    'ChJSdWxlVmVyc2lvblN1bW1hcnkSDgoCaWQYASABKANSAmlkEhQKBXRpdGxlGAIgASgJUgV0aX'
    'RsZRIhCgxjb250ZW50X2hhc2gYAyABKAlSC2NvbnRlbnRIYXNoEhsKCXBhcmVudF9pZBgEIAEo'
    'A1IIcGFyZW50SWQSJgoPb3RoZXJfcGFyZW50X2lkGAUgASgDUg1vdGhlclBhcmVudElkEiEKDH'
    'RlbXBsYXRlX2tleRgGIAEoCVILdGVtcGxhdGVLZXkSJgoPY3JlYXRlZF91bml4X21zGAcgASgD'
    'Ug1jcmVhdGVkVW5peE1z');

@$core.Deprecated('Use listRuleVersionsRequestDescriptor instead')
const ListRuleVersionsRequest$json = {
  '1': 'ListRuleVersionsRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'before_id', '3': 3, '4': 1, '5': 3, '10': 'beforeId'},
  ],
};

/// Descriptor for `ListRuleVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRuleVersionsRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UnVsZVZlcnNpb25zUmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSGwoJcGFnZV'
        '9zaXplGAIgASgFUghwYWdlU2l6ZRIbCgliZWZvcmVfaWQYAyABKANSCGJlZm9yZUlk');

@$core.Deprecated('Use listRuleVersionsResponseDescriptor instead')
const ListRuleVersionsResponse$json = {
  '1': 'ListRuleVersionsResponse',
  '2': [
    {
      '1': 'versions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.RuleVersionSummary',
      '10': 'versions'
    },
    {'1': 'next_before_id', '3': 2, '4': 1, '5': 3, '10': 'nextBeforeId'},
  ],
};

/// Descriptor for `ListRuleVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRuleVersionsResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0UnVsZVZlcnNpb25zUmVzcG9uc2USNgoIdmVyc2lvbnMYASADKAsyGi5sYWIudjEuUn'
    'VsZVZlcnNpb25TdW1tYXJ5Ugh2ZXJzaW9ucxIkCg5uZXh0X2JlZm9yZV9pZBgCIAEoA1IMbmV4'
    'dEJlZm9yZUlk');

@$core.Deprecated('Use getRuleVersionRequestDescriptor instead')
const GetRuleVersionRequest$json = {
  '1': 'GetRuleVersionRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `GetRuleVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRuleVersionRequestDescriptor = $convert
    .base64Decode('ChVHZXRSdWxlVmVyc2lvblJlcXVlc3QSDgoCaWQYASABKANSAmlk');

@$core.Deprecated('Use getRuleVersionResponseDescriptor instead')
const GetRuleVersionResponse$json = {
  '1': 'GetRuleVersionResponse',
  '2': [
    {
      '1': 'version',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.RuleVersionSummary',
      '10': 'version'
    },
    {'1': 'definition_json', '3': 2, '4': 1, '5': 9, '10': 'definitionJson'},
  ],
};

/// Descriptor for `GetRuleVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRuleVersionResponseDescriptor = $convert.base64Decode(
    'ChZHZXRSdWxlVmVyc2lvblJlc3BvbnNlEjQKB3ZlcnNpb24YASABKAsyGi5sYWIudjEuUnVsZV'
    'ZlcnNpb25TdW1tYXJ5Ugd2ZXJzaW9uEicKD2RlZmluaXRpb25fanNvbhgCIAEoCVIOZGVmaW5p'
    'dGlvbkpzb24=');

@$core.Deprecated('Use saveRuleVersionRequestDescriptor instead')
const SaveRuleVersionRequest$json = {
  '1': 'SaveRuleVersionRequest',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'definition_json', '3': 2, '4': 1, '5': 9, '10': 'definitionJson'},
    {'1': 'parent_id', '3': 3, '4': 1, '5': 3, '10': 'parentId'},
    {'1': 'template_key', '3': 4, '4': 1, '5': 9, '10': 'templateKey'},
  ],
};

/// Descriptor for `SaveRuleVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveRuleVersionRequestDescriptor = $convert.base64Decode(
    'ChZTYXZlUnVsZVZlcnNpb25SZXF1ZXN0EhQKBXRpdGxlGAEgASgJUgV0aXRsZRInCg9kZWZpbm'
    'l0aW9uX2pzb24YAiABKAlSDmRlZmluaXRpb25Kc29uEhsKCXBhcmVudF9pZBgDIAEoA1IIcGFy'
    'ZW50SWQSIQoMdGVtcGxhdGVfa2V5GAQgASgJUgt0ZW1wbGF0ZUtleQ==');

@$core.Deprecated('Use saveRuleVersionResponseDescriptor instead')
const SaveRuleVersionResponse$json = {
  '1': 'SaveRuleVersionResponse',
  '2': [
    {
      '1': 'version',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.RuleVersionSummary',
      '10': 'version'
    },
  ],
};

/// Descriptor for `SaveRuleVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveRuleVersionResponseDescriptor =
    $convert.base64Decode(
        'ChdTYXZlUnVsZVZlcnNpb25SZXNwb25zZRI0Cgd2ZXJzaW9uGAEgASgLMhoubGFiLnYxLlJ1bG'
        'VWZXJzaW9uU3VtbWFyeVIHdmVyc2lvbg==');

@$core.Deprecated('Use composeRuleVersionsRequestDescriptor instead')
const ComposeRuleVersionsRequest$json = {
  '1': 'ComposeRuleVersionsRequest',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'first_id', '3': 2, '4': 1, '5': 3, '10': 'firstId'},
    {'1': 'second_id', '3': 3, '4': 1, '5': 3, '10': 'secondId'},
    {'1': 'entry_mode', '3': 4, '4': 1, '5': 9, '10': 'entryMode'},
    {'1': 'exit_owner_id', '3': 5, '4': 1, '5': 3, '10': 'exitOwnerId'},
  ],
};

/// Descriptor for `ComposeRuleVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List composeRuleVersionsRequestDescriptor = $convert.base64Decode(
    'ChpDb21wb3NlUnVsZVZlcnNpb25zUmVxdWVzdBIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSGQoIZm'
    'lyc3RfaWQYAiABKANSB2ZpcnN0SWQSGwoJc2Vjb25kX2lkGAMgASgDUghzZWNvbmRJZBIdCgpl'
    'bnRyeV9tb2RlGAQgASgJUgllbnRyeU1vZGUSIgoNZXhpdF9vd25lcl9pZBgFIAEoA1ILZXhpdE'
    '93bmVySWQ=');

@$core.Deprecated('Use composeRuleVersionsResponseDescriptor instead')
const ComposeRuleVersionsResponse$json = {
  '1': 'ComposeRuleVersionsResponse',
  '2': [
    {
      '1': 'version',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.RuleVersionSummary',
      '10': 'version'
    },
  ],
};

/// Descriptor for `ComposeRuleVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List composeRuleVersionsResponseDescriptor =
    $convert.base64Decode(
        'ChtDb21wb3NlUnVsZVZlcnNpb25zUmVzcG9uc2USNAoHdmVyc2lvbhgBIAEoCzIaLmxhYi52MS'
        '5SdWxlVmVyc2lvblN1bW1hcnlSB3ZlcnNpb24=');

@$core.Deprecated('Use ruleTemplateDescriptor instead')
const RuleTemplate$json = {
  '1': 'RuleTemplate',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'definition_json', '3': 4, '4': 1, '5': 9, '10': 'definitionJson'},
  ],
};

/// Descriptor for `RuleTemplate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ruleTemplateDescriptor = $convert.base64Decode(
    'CgxSdWxlVGVtcGxhdGUSEAoDa2V5GAEgASgJUgNrZXkSFAoFdGl0bGUYAiABKAlSBXRpdGxlEi'
    'AKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhInCg9kZWZpbml0aW9uX2pzb24YBCAB'
    'KAlSDmRlZmluaXRpb25Kc29u');

@$core.Deprecated('Use listRuleTemplatesRequestDescriptor instead')
const ListRuleTemplatesRequest$json = {
  '1': 'ListRuleTemplatesRequest',
};

/// Descriptor for `ListRuleTemplatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRuleTemplatesRequestDescriptor =
    $convert.base64Decode('ChhMaXN0UnVsZVRlbXBsYXRlc1JlcXVlc3Q=');

@$core.Deprecated('Use listRuleTemplatesResponseDescriptor instead')
const ListRuleTemplatesResponse$json = {
  '1': 'ListRuleTemplatesResponse',
  '2': [
    {
      '1': 'templates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.RuleTemplate',
      '10': 'templates'
    },
  ],
};

/// Descriptor for `ListRuleTemplatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRuleTemplatesResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0UnVsZVRlbXBsYXRlc1Jlc3BvbnNlEjIKCXRlbXBsYXRlcxgBIAMoCzIULmxhYi52MS'
        '5SdWxlVGVtcGxhdGVSCXRlbXBsYXRlcw==');

const $core.Map<$core.String, $core.dynamic> LibraryServiceBase$json = {
  '1': 'LibraryService',
  '2': [
    {
      '1': 'ListAlgorithms',
      '2': '.lab.v1.ListAlgorithmsRequest',
      '3': '.lab.v1.ListAlgorithmsResponse'
    },
    {
      '1': 'SetVersionState',
      '2': '.lab.v1.SetVersionStateRequest',
      '3': '.lab.v1.SetVersionStateResponse'
    },
    {
      '1': 'ListLifecycleEvents',
      '2': '.lab.v1.ListLifecycleEventsRequest',
      '3': '.lab.v1.ListLifecycleEventsResponse'
    },
    {
      '1': 'ListRuleVersions',
      '2': '.lab.v1.ListRuleVersionsRequest',
      '3': '.lab.v1.ListRuleVersionsResponse'
    },
    {
      '1': 'GetRuleVersion',
      '2': '.lab.v1.GetRuleVersionRequest',
      '3': '.lab.v1.GetRuleVersionResponse'
    },
    {
      '1': 'SaveRuleVersion',
      '2': '.lab.v1.SaveRuleVersionRequest',
      '3': '.lab.v1.SaveRuleVersionResponse'
    },
    {
      '1': 'ComposeRuleVersions',
      '2': '.lab.v1.ComposeRuleVersionsRequest',
      '3': '.lab.v1.ComposeRuleVersionsResponse'
    },
    {
      '1': 'ListRuleTemplates',
      '2': '.lab.v1.ListRuleTemplatesRequest',
      '3': '.lab.v1.ListRuleTemplatesResponse'
    },
  ],
};

@$core.Deprecated('Use libraryServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    LibraryServiceBase$messageJson = {
  '.lab.v1.ListAlgorithmsRequest': ListAlgorithmsRequest$json,
  '.lab.v1.ListAlgorithmsResponse': ListAlgorithmsResponse$json,
  '.lab.v1.Algorithm': Algorithm$json,
  '.lab.v1.AlgorithmVersion': AlgorithmVersion$json,
  '.lab.v1.ParamSpec': $0.ParamSpec$json,
  '.lab.v1.RecipeItem': RecipeItem$json,
  '.lab.v1.LatestReport': LatestReport$json,
  '.lab.v1.Decimal': $1.Decimal$json,
  '.lab.v1.SetVersionStateRequest': SetVersionStateRequest$json,
  '.lab.v1.SetVersionStateResponse': SetVersionStateResponse$json,
  '.lab.v1.ListLifecycleEventsRequest': ListLifecycleEventsRequest$json,
  '.lab.v1.AuditCursor': $2.AuditCursor$json,
  '.lab.v1.AccountRef': $3.AccountRef$json,
  '.lab.v1.ListLifecycleEventsResponse': ListLifecycleEventsResponse$json,
  '.lab.v1.LifecycleEvent': LifecycleEvent$json,
  '.lab.v1.AuditEvent': $2.AuditEvent$json,
  '.lab.v1.ListRuleVersionsRequest': ListRuleVersionsRequest$json,
  '.lab.v1.ListRuleVersionsResponse': ListRuleVersionsResponse$json,
  '.lab.v1.RuleVersionSummary': RuleVersionSummary$json,
  '.lab.v1.GetRuleVersionRequest': GetRuleVersionRequest$json,
  '.lab.v1.GetRuleVersionResponse': GetRuleVersionResponse$json,
  '.lab.v1.SaveRuleVersionRequest': SaveRuleVersionRequest$json,
  '.lab.v1.SaveRuleVersionResponse': SaveRuleVersionResponse$json,
  '.lab.v1.ComposeRuleVersionsRequest': ComposeRuleVersionsRequest$json,
  '.lab.v1.ComposeRuleVersionsResponse': ComposeRuleVersionsResponse$json,
  '.lab.v1.ListRuleTemplatesRequest': ListRuleTemplatesRequest$json,
  '.lab.v1.ListRuleTemplatesResponse': ListRuleTemplatesResponse$json,
  '.lab.v1.RuleTemplate': RuleTemplate$json,
};

/// Descriptor for `LibraryService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List libraryServiceDescriptor = $convert.base64Decode(
    'Cg5MaWJyYXJ5U2VydmljZRJPCg5MaXN0QWxnb3JpdGhtcxIdLmxhYi52MS5MaXN0QWxnb3JpdG'
    'htc1JlcXVlc3QaHi5sYWIudjEuTGlzdEFsZ29yaXRobXNSZXNwb25zZRJSCg9TZXRWZXJzaW9u'
    'U3RhdGUSHi5sYWIudjEuU2V0VmVyc2lvblN0YXRlUmVxdWVzdBofLmxhYi52MS5TZXRWZXJzaW'
    '9uU3RhdGVSZXNwb25zZRJeChNMaXN0TGlmZWN5Y2xlRXZlbnRzEiIubGFiLnYxLkxpc3RMaWZl'
    'Y3ljbGVFdmVudHNSZXF1ZXN0GiMubGFiLnYxLkxpc3RMaWZlY3ljbGVFdmVudHNSZXNwb25zZR'
    'JVChBMaXN0UnVsZVZlcnNpb25zEh8ubGFiLnYxLkxpc3RSdWxlVmVyc2lvbnNSZXF1ZXN0GiAu'
    'bGFiLnYxLkxpc3RSdWxlVmVyc2lvbnNSZXNwb25zZRJPCg5HZXRSdWxlVmVyc2lvbhIdLmxhYi'
    '52MS5HZXRSdWxlVmVyc2lvblJlcXVlc3QaHi5sYWIudjEuR2V0UnVsZVZlcnNpb25SZXNwb25z'
    'ZRJSCg9TYXZlUnVsZVZlcnNpb24SHi5sYWIudjEuU2F2ZVJ1bGVWZXJzaW9uUmVxdWVzdBofLm'
    'xhYi52MS5TYXZlUnVsZVZlcnNpb25SZXNwb25zZRJeChNDb21wb3NlUnVsZVZlcnNpb25zEiIu'
    'bGFiLnYxLkNvbXBvc2VSdWxlVmVyc2lvbnNSZXF1ZXN0GiMubGFiLnYxLkNvbXBvc2VSdWxlVm'
    'Vyc2lvbnNSZXNwb25zZRJYChFMaXN0UnVsZVRlbXBsYXRlcxIgLmxhYi52MS5MaXN0UnVsZVRl'
    'bXBsYXRlc1JlcXVlc3QaIS5sYWIudjEuTGlzdFJ1bGVUZW1wbGF0ZXNSZXNwb25zZQ==');
