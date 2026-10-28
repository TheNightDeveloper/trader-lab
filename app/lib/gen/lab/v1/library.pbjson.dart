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

import 'common.pbjson.dart' as $1;
import 'report.pbjson.dart' as $0;

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
  ],
};

/// Descriptor for `Algorithm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List algorithmDescriptor = $convert.base64Decode(
    'CglBbGdvcml0aG0SDgoCaWQYASABKAlSAmlkEhYKBmZhbWlseRgCIAEoCVIGZmFtaWx5EiAKC2'
    'Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhI0Cgh2ZXJzaW9ucxgEIAMoCzIYLmxhYi52'
    'MS5BbGdvcml0aG1WZXJzaW9uUgh2ZXJzaW9ucxI5Cg1sYXRlc3RfcmVwb3J0GAUgASgLMhQubG'
    'FiLnYxLkxhdGVzdFJlcG9ydFIMbGF0ZXN0UmVwb3J0EiEKDGFjdGl2ZV9tb2RlbBgGIAEoCVIL'
    'YWN0aXZlTW9kZWw=');

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
  ],
};

/// Descriptor for `SetVersionStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setVersionStateRequestDescriptor =
    $convert.base64Decode(
        'ChZTZXRWZXJzaW9uU3RhdGVSZXF1ZXN0Eh0KCnZlcnNpb25faWQYASABKAlSCXZlcnNpb25JZB'
        'IUCgVzdGF0ZRgCIAEoCVIFc3RhdGUSEgoEbm90ZRgDIAEoCVIEbm90ZQ==');

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
  ],
};

/// Descriptor for `LifecycleEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lifecycleEventDescriptor = $convert.base64Decode(
    'Cg5MaWZlY3ljbGVFdmVudBIdCgpmcm9tX3N0YXRlGAEgASgJUglmcm9tU3RhdGUSGQoIdG9fc3'
    'RhdGUYAiABKAlSB3RvU3RhdGUSEgoEbm90ZRgDIAEoCVIEbm90ZRIUCgVhY3RvchgEIAEoCVIF'
    'YWN0b3ISHAoKYXRfdW5peF9tcxgFIAEoA1IIYXRVbml4TXM=');

@$core.Deprecated('Use listLifecycleEventsRequestDescriptor instead')
const ListLifecycleEventsRequest$json = {
  '1': 'ListLifecycleEventsRequest',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
  ],
};

/// Descriptor for `ListLifecycleEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLifecycleEventsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0TGlmZWN5Y2xlRXZlbnRzUmVxdWVzdBIdCgp2ZXJzaW9uX2lkGAEgASgJUgl2ZXJzaW'
        '9uSWQ=');

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
  ],
};

/// Descriptor for `ListLifecycleEventsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLifecycleEventsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0TGlmZWN5Y2xlRXZlbnRzUmVzcG9uc2USLgoGZXZlbnRzGAEgAygLMhYubGFiLnYxLk'
        'xpZmVjeWNsZUV2ZW50UgZldmVudHM=');

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
  '.lab.v1.ListLifecycleEventsResponse': ListLifecycleEventsResponse$json,
  '.lab.v1.LifecycleEvent': LifecycleEvent$json,
};

/// Descriptor for `LibraryService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List libraryServiceDescriptor = $convert.base64Decode(
    'Cg5MaWJyYXJ5U2VydmljZRJPCg5MaXN0QWxnb3JpdGhtcxIdLmxhYi52MS5MaXN0QWxnb3JpdG'
    'htc1JlcXVlc3QaHi5sYWIudjEuTGlzdEFsZ29yaXRobXNSZXNwb25zZRJSCg9TZXRWZXJzaW9u'
    'U3RhdGUSHi5sYWIudjEuU2V0VmVyc2lvblN0YXRlUmVxdWVzdBofLmxhYi52MS5TZXRWZXJzaW'
    '9uU3RhdGVSZXNwb25zZRJeChNMaXN0TGlmZWN5Y2xlRXZlbnRzEiIubGFiLnYxLkxpc3RMaWZl'
    'Y3ljbGVFdmVudHNSZXF1ZXN0GiMubGFiLnYxLkxpc3RMaWZlY3ljbGVFdmVudHNSZXNwb25zZQ'
    '==');
