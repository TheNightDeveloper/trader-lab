// This is a generated file - do not edit.
//
// Generated from lab/v1/experiment.proto.

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

@$core.Deprecated('Use objectiveDescriptor instead')
const Objective$json = {
  '1': 'Objective',
  '2': [
    {'1': 'metric', '3': 1, '4': 1, '5': 9, '10': 'metric'},
    {'1': 'maximize', '3': 2, '4': 1, '5': 8, '10': 'maximize'},
  ],
};

/// Descriptor for `Objective`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List objectiveDescriptor = $convert.base64Decode(
    'CglPYmplY3RpdmUSFgoGbWV0cmljGAEgASgJUgZtZXRyaWMSGgoIbWF4aW1pemUYAiABKAhSCG'
    '1heGltaXpl');

@$core.Deprecated('Use constraintDescriptor instead')
const Constraint$json = {
  '1': 'Constraint',
  '2': [
    {'1': 'metric', '3': 1, '4': 1, '5': 9, '10': 'metric'},
    {'1': 'op', '3': 2, '4': 1, '5': 9, '10': 'op'},
    {'1': 'value', '3': 3, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `Constraint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List constraintDescriptor = $convert.base64Decode(
    'CgpDb25zdHJhaW50EhYKBm1ldHJpYxgBIAEoCVIGbWV0cmljEg4KAm9wGAIgASgJUgJvcBIUCg'
    'V2YWx1ZRgDIAEoCVIFdmFsdWU=');

@$core.Deprecated('Use paramRangeDescriptor instead')
const ParamRange$json = {
  '1': 'ParamRange',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 1, '10': 'values'},
    {'1': 'min', '3': 2, '4': 1, '5': 1, '10': 'min'},
    {'1': 'max', '3': 3, '4': 1, '5': 1, '10': 'max'},
    {'1': 'step', '3': 4, '4': 1, '5': 1, '10': 'step'},
  ],
};

/// Descriptor for `ParamRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paramRangeDescriptor = $convert.base64Decode(
    'CgpQYXJhbVJhbmdlEhYKBnZhbHVlcxgBIAMoAVIGdmFsdWVzEhAKA21pbhgCIAEoAVIDbWluEh'
    'AKA21heBgDIAEoAVIDbWF4EhIKBHN0ZXAYBCABKAFSBHN0ZXA=');

@$core.Deprecated('Use searchPlanDescriptor instead')
const SearchPlan$json = {
  '1': 'SearchPlan',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 9, '10': 'mode'},
    {'1': 'seed', '3': 2, '4': 1, '5': 4, '10': 'seed'},
    {'1': 'max_attempts', '3': 3, '4': 1, '5': 5, '10': 'maxAttempts'},
    {'1': 'max_wall_seconds', '3': 4, '4': 1, '5': 5, '10': 'maxWallSeconds'},
  ],
};

/// Descriptor for `SearchPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchPlanDescriptor = $convert.base64Decode(
    'CgpTZWFyY2hQbGFuEhIKBG1vZGUYASABKAlSBG1vZGUSEgoEc2VlZBgCIAEoBFIEc2VlZBIhCg'
    'xtYXhfYXR0ZW1wdHMYAyABKAVSC21heEF0dGVtcHRzEigKEG1heF93YWxsX3NlY29uZHMYBCAB'
    'KAVSDm1heFdhbGxTZWNvbmRz');

@$core.Deprecated('Use experimentDefinitionDescriptor instead')
const ExperimentDefinition$json = {
  '1': 'ExperimentDefinition',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'hypothesis', '3': 2, '4': 1, '5': 9, '10': 'hypothesis'},
    {'1': 'falsifier', '3': 3, '4': 1, '5': 9, '10': 'falsifier'},
    {
      '1': 'objective',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Objective',
      '10': 'objective'
    },
    {
      '1': 'constraints',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Constraint',
      '10': 'constraints'
    },
    {'1': 'dataset_ids', '3': 6, '4': 3, '5': 9, '10': 'datasetIds'},
    {
      '1': 'algorithm_version',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'algorithmVersion'
    },
    {
      '1': 'space',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ExperimentDefinition.SpaceEntry',
      '10': 'space'
    },
    {
      '1': 'search',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.SearchPlan',
      '10': 'search'
    },
    {
      '1': 'capital',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'capital'
    },
    {'1': 'fee', '3': 11, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'fee'},
    {
      '1': 'slippage',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'slippage'
    },
    {'1': 'latency_bars', '3': 13, '4': 1, '5': 5, '10': 'latencyBars'},
    {'1': 'folds', '3': 14, '4': 1, '5': 5, '10': 'folds'},
    {'1': 'rolling', '3': 15, '4': 1, '5': 8, '10': 'rolling'},
    {
      '1': 'holdout',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'holdout'
    },
  ],
  '3': [ExperimentDefinition_SpaceEntry$json],
};

@$core.Deprecated('Use experimentDefinitionDescriptor instead')
const ExperimentDefinition_SpaceEntry$json = {
  '1': 'SpaceEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ParamRange',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `ExperimentDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List experimentDefinitionDescriptor = $convert.base64Decode(
    'ChRFeHBlcmltZW50RGVmaW5pdGlvbhISCgRuYW1lGAEgASgJUgRuYW1lEh4KCmh5cG90aGVzaX'
    'MYAiABKAlSCmh5cG90aGVzaXMSHAoJZmFsc2lmaWVyGAMgASgJUglmYWxzaWZpZXISLwoJb2Jq'
    'ZWN0aXZlGAQgASgLMhEubGFiLnYxLk9iamVjdGl2ZVIJb2JqZWN0aXZlEjQKC2NvbnN0cmFpbn'
    'RzGAUgAygLMhIubGFiLnYxLkNvbnN0cmFpbnRSC2NvbnN0cmFpbnRzEh8KC2RhdGFzZXRfaWRz'
    'GAYgAygJUgpkYXRhc2V0SWRzEisKEWFsZ29yaXRobV92ZXJzaW9uGAcgASgJUhBhbGdvcml0aG'
    '1WZXJzaW9uEj0KBXNwYWNlGAggAygLMicubGFiLnYxLkV4cGVyaW1lbnREZWZpbml0aW9uLlNw'
    'YWNlRW50cnlSBXNwYWNlEioKBnNlYXJjaBgJIAEoCzISLmxhYi52MS5TZWFyY2hQbGFuUgZzZW'
    'FyY2gSJwoHY2FwaXRhbBgKIAEoCzINLmxhYi52MS5Nb25leVIHY2FwaXRhbBIhCgNmZWUYCyAB'
    'KAsyDy5sYWIudjEuRGVjaW1hbFIDZmVlEisKCHNsaXBwYWdlGAwgASgLMg8ubGFiLnYxLkRlY2'
    'ltYWxSCHNsaXBwYWdlEiEKDGxhdGVuY3lfYmFycxgNIAEoBVILbGF0ZW5jeUJhcnMSFAoFZm9s'
    'ZHMYDiABKAVSBWZvbGRzEhgKB3JvbGxpbmcYDyABKAhSB3JvbGxpbmcSKQoHaG9sZG91dBgQIA'
    'EoCzIPLmxhYi52MS5EZWNpbWFsUgdob2xkb3V0GkwKClNwYWNlRW50cnkSEAoDa2V5GAEgASgJ'
    'UgNrZXkSKAoFdmFsdWUYAiABKAsyEi5sYWIudjEuUGFyYW1SYW5nZVIFdmFsdWU6AjgB');

@$core.Deprecated('Use estimateRequestDescriptor instead')
const EstimateRequest$json = {
  '1': 'EstimateRequest',
  '2': [
    {
      '1': 'definition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ExperimentDefinition',
      '10': 'definition'
    },
  ],
};

/// Descriptor for `EstimateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List estimateRequestDescriptor = $convert.base64Decode(
    'Cg9Fc3RpbWF0ZVJlcXVlc3QSPAoKZGVmaW5pdGlvbhgBIAEoCzIcLmxhYi52MS5FeHBlcmltZW'
    '50RGVmaW5pdGlvblIKZGVmaW5pdGlvbg==');

@$core.Deprecated('Use estimateResponseDescriptor instead')
const EstimateResponse$json = {
  '1': 'EstimateResponse',
  '2': [
    {'1': 'candidates', '3': 1, '4': 1, '5': 5, '10': 'candidates'},
    {'1': 'attempts', '3': 2, '4': 1, '5': 5, '10': 'attempts'},
    {
      '1': 'estimated_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'estimatedSeconds'
    },
    {'1': 'error', '3': 4, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `EstimateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List estimateResponseDescriptor = $convert.base64Decode(
    'ChBFc3RpbWF0ZVJlc3BvbnNlEh4KCmNhbmRpZGF0ZXMYASABKAVSCmNhbmRpZGF0ZXMSGgoIYX'
    'R0ZW1wdHMYAiABKAVSCGF0dGVtcHRzEisKEWVzdGltYXRlZF9zZWNvbmRzGAMgASgDUhBlc3Rp'
    'bWF0ZWRTZWNvbmRzEhQKBWVycm9yGAQgASgJUgVlcnJvcg==');

@$core.Deprecated('Use createExperimentRequestDescriptor instead')
const CreateExperimentRequest$json = {
  '1': 'CreateExperimentRequest',
  '2': [
    {
      '1': 'definition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ExperimentDefinition',
      '10': 'definition'
    },
  ],
};

/// Descriptor for `CreateExperimentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createExperimentRequestDescriptor =
    $convert.base64Decode(
        'ChdDcmVhdGVFeHBlcmltZW50UmVxdWVzdBI8CgpkZWZpbml0aW9uGAEgASgLMhwubGFiLnYxLk'
        'V4cGVyaW1lbnREZWZpbml0aW9uUgpkZWZpbml0aW9u');

@$core.Deprecated('Use createExperimentResponseDescriptor instead')
const CreateExperimentResponse$json = {
  '1': 'CreateExperimentResponse',
  '2': [
    {'1': 'experiment_id', '3': 1, '4': 1, '5': 9, '10': 'experimentId'},
    {'1': 'already_existed', '3': 2, '4': 1, '5': 8, '10': 'alreadyExisted'},
  ],
};

/// Descriptor for `CreateExperimentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createExperimentResponseDescriptor =
    $convert.base64Decode(
        'ChhDcmVhdGVFeHBlcmltZW50UmVzcG9uc2USIwoNZXhwZXJpbWVudF9pZBgBIAEoCVIMZXhwZX'
        'JpbWVudElkEicKD2FscmVhZHlfZXhpc3RlZBgCIAEoCFIOYWxyZWFkeUV4aXN0ZWQ=');

@$core.Deprecated('Use attemptCountsDescriptor instead')
const AttemptCounts$json = {
  '1': 'AttemptCounts',
  '2': [
    {'1': 'queued', '3': 1, '4': 1, '5': 5, '10': 'queued'},
    {'1': 'running', '3': 2, '4': 1, '5': 5, '10': 'running'},
    {'1': 'done', '3': 3, '4': 1, '5': 5, '10': 'done'},
    {'1': 'failed', '3': 4, '4': 1, '5': 5, '10': 'failed'},
    {'1': 'cancelled', '3': 5, '4': 1, '5': 5, '10': 'cancelled'},
    {'1': 'total', '3': 6, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `AttemptCounts`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attemptCountsDescriptor = $convert.base64Decode(
    'Cg1BdHRlbXB0Q291bnRzEhYKBnF1ZXVlZBgBIAEoBVIGcXVldWVkEhgKB3J1bm5pbmcYAiABKA'
    'VSB3J1bm5pbmcSEgoEZG9uZRgDIAEoBVIEZG9uZRIWCgZmYWlsZWQYBCABKAVSBmZhaWxlZBIc'
    'CgljYW5jZWxsZWQYBSABKAVSCWNhbmNlbGxlZBIUCgV0b3RhbBgGIAEoBVIFdG90YWw=');

@$core.Deprecated('Use experimentResultDescriptor instead')
const ExperimentResult$json = {
  '1': 'ExperimentResult',
  '2': [
    {'1': 'chosen', '3': 1, '4': 1, '5': 5, '10': 'chosen'},
    {
      '1': 'params',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ExperimentResult.ParamsEntry',
      '10': 'params'
    },
    {
      '1': 'objective',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'objective'
    },
    {'1': 'candidates', '3': 4, '4': 1, '5': 5, '10': 'candidates'},
    {
      '1': 'eligible_candidates',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'eligibleCandidates'
    },
    {'1': 'attempts', '3': 6, '4': 1, '5': 5, '10': 'attempts'},
    {'1': 'report_ids', '3': 7, '4': 3, '5': 9, '10': 'reportIds'},
    {'1': 'reason', '3': 8, '4': 1, '5': 9, '10': 'reason'},
  ],
  '3': [ExperimentResult_ParamsEntry$json],
};

@$core.Deprecated('Use experimentResultDescriptor instead')
const ExperimentResult_ParamsEntry$json = {
  '1': 'ParamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ExperimentResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List experimentResultDescriptor = $convert.base64Decode(
    'ChBFeHBlcmltZW50UmVzdWx0EhYKBmNob3NlbhgBIAEoBVIGY2hvc2VuEjwKBnBhcmFtcxgCIA'
    'MoCzIkLmxhYi52MS5FeHBlcmltZW50UmVzdWx0LlBhcmFtc0VudHJ5UgZwYXJhbXMSLAoJb2Jq'
    'ZWN0aXZlGAMgASgLMg4ubGFiLnYxLk1ldHJpY1IJb2JqZWN0aXZlEh4KCmNhbmRpZGF0ZXMYBC'
    'ABKAVSCmNhbmRpZGF0ZXMSLwoTZWxpZ2libGVfY2FuZGlkYXRlcxgFIAEoBVISZWxpZ2libGVD'
    'YW5kaWRhdGVzEhoKCGF0dGVtcHRzGAYgASgFUghhdHRlbXB0cxIdCgpyZXBvcnRfaWRzGAcgAy'
    'gJUglyZXBvcnRJZHMSFgoGcmVhc29uGAggASgJUgZyZWFzb24aOQoLUGFyYW1zRW50cnkSEAoD'
    'a2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAFSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use experimentSummaryDescriptor instead')
const ExperimentSummary$json = {
  '1': 'ExperimentSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'created_unix_ms', '3': 4, '4': 1, '5': 3, '10': 'createdUnixMs'},
    {'1': 'finished_unix_ms', '3': 5, '4': 1, '5': 3, '10': 'finishedUnixMs'},
    {
      '1': 'algorithm_version',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'algorithmVersion'
    },
    {
      '1': 'counts',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AttemptCounts',
      '10': 'counts'
    },
  ],
};

/// Descriptor for `ExperimentSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List experimentSummaryDescriptor = $convert.base64Decode(
    'ChFFeHBlcmltZW50U3VtbWFyeRIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZR'
    'IWCgZzdGF0dXMYAyABKAlSBnN0YXR1cxImCg9jcmVhdGVkX3VuaXhfbXMYBCABKANSDWNyZWF0'
    'ZWRVbml4TXMSKAoQZmluaXNoZWRfdW5peF9tcxgFIAEoA1IOZmluaXNoZWRVbml4TXMSKwoRYW'
    'xnb3JpdGhtX3ZlcnNpb24YBiABKAlSEGFsZ29yaXRobVZlcnNpb24SLQoGY291bnRzGAcgASgL'
    'MhUubGFiLnYxLkF0dGVtcHRDb3VudHNSBmNvdW50cw==');

@$core.Deprecated('Use listExperimentsRequestDescriptor instead')
const ListExperimentsRequest$json = {
  '1': 'ListExperimentsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListExperimentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExperimentsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0RXhwZXJpbWVudHNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemUSFg'
        'oGb2Zmc2V0GAIgASgFUgZvZmZzZXQ=');

@$core.Deprecated('Use listExperimentsResponseDescriptor instead')
const ListExperimentsResponse$json = {
  '1': 'ListExperimentsResponse',
  '2': [
    {
      '1': 'experiments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ExperimentSummary',
      '10': 'experiments'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListExperimentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExperimentsResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0RXhwZXJpbWVudHNSZXNwb25zZRI7CgtleHBlcmltZW50cxgBIAMoCzIZLmxhYi52MS'
    '5FeHBlcmltZW50U3VtbWFyeVILZXhwZXJpbWVudHMSFAoFdG90YWwYAiABKANSBXRvdGFs');

@$core.Deprecated('Use getExperimentRequestDescriptor instead')
const GetExperimentRequest$json = {
  '1': 'GetExperimentRequest',
  '2': [
    {'1': 'experiment_id', '3': 1, '4': 1, '5': 9, '10': 'experimentId'},
  ],
};

/// Descriptor for `GetExperimentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getExperimentRequestDescriptor = $convert.base64Decode(
    'ChRHZXRFeHBlcmltZW50UmVxdWVzdBIjCg1leHBlcmltZW50X2lkGAEgASgJUgxleHBlcmltZW'
    '50SWQ=');

@$core.Deprecated('Use getExperimentResponseDescriptor instead')
const GetExperimentResponse$json = {
  '1': 'GetExperimentResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ExperimentSummary',
      '10': 'summary'
    },
    {
      '1': 'definition',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ExperimentDefinition',
      '10': 'definition'
    },
    {
      '1': 'result',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ExperimentResult',
      '10': 'result'
    },
    {'1': 'error', '3': 4, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `GetExperimentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getExperimentResponseDescriptor = $convert.base64Decode(
    'ChVHZXRFeHBlcmltZW50UmVzcG9uc2USMwoHc3VtbWFyeRgBIAEoCzIZLmxhYi52MS5FeHBlcm'
    'ltZW50U3VtbWFyeVIHc3VtbWFyeRI8CgpkZWZpbml0aW9uGAIgASgLMhwubGFiLnYxLkV4cGVy'
    'aW1lbnREZWZpbml0aW9uUgpkZWZpbml0aW9uEjAKBnJlc3VsdBgDIAEoCzIYLmxhYi52MS5FeH'
    'BlcmltZW50UmVzdWx0UgZyZXN1bHQSFAoFZXJyb3IYBCABKAlSBWVycm9y');

@$core.Deprecated('Use watchExperimentRequestDescriptor instead')
const WatchExperimentRequest$json = {
  '1': 'WatchExperimentRequest',
  '2': [
    {'1': 'experiment_id', '3': 1, '4': 1, '5': 9, '10': 'experimentId'},
  ],
};

/// Descriptor for `WatchExperimentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchExperimentRequestDescriptor =
    $convert.base64Decode(
        'ChZXYXRjaEV4cGVyaW1lbnRSZXF1ZXN0EiMKDWV4cGVyaW1lbnRfaWQYASABKAlSDGV4cGVyaW'
        '1lbnRJZA==');

@$core.Deprecated('Use watchExperimentResponseDescriptor instead')
const WatchExperimentResponse$json = {
  '1': 'WatchExperimentResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'counts',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AttemptCounts',
      '10': 'counts'
    },
    {'1': 'elapsed_seconds', '3': 3, '4': 1, '5': 3, '10': 'elapsedSeconds'},
    {
      '1': 'wall_budget_seconds',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'wallBudgetSeconds'
    },
    {'1': 'attempt_budget', '3': 5, '4': 1, '5': 5, '10': 'attemptBudget'},
    {'1': 'cache_hits', '3': 6, '4': 1, '5': 5, '10': 'cacheHits'},
    {'1': 'cache_looked', '3': 7, '4': 1, '5': 5, '10': 'cacheLooked'},
    {
      '1': 'research_slots_in_use',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'researchSlotsInUse'
    },
    {'1': 'research_slots', '3': 9, '4': 1, '5': 5, '10': 'researchSlots'},
    {
      '1': 'best_objective',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'bestObjective'
    },
  ],
};

/// Descriptor for `WatchExperimentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchExperimentResponseDescriptor = $convert.base64Decode(
    'ChdXYXRjaEV4cGVyaW1lbnRSZXNwb25zZRIWCgZzdGF0dXMYASABKAlSBnN0YXR1cxItCgZjb3'
    'VudHMYAiABKAsyFS5sYWIudjEuQXR0ZW1wdENvdW50c1IGY291bnRzEicKD2VsYXBzZWRfc2Vj'
    'b25kcxgDIAEoA1IOZWxhcHNlZFNlY29uZHMSLgoTd2FsbF9idWRnZXRfc2Vjb25kcxgEIAEoA1'
    'IRd2FsbEJ1ZGdldFNlY29uZHMSJQoOYXR0ZW1wdF9idWRnZXQYBSABKAVSDWF0dGVtcHRCdWRn'
    'ZXQSHQoKY2FjaGVfaGl0cxgGIAEoBVIJY2FjaGVIaXRzEiEKDGNhY2hlX2xvb2tlZBgHIAEoBV'
    'ILY2FjaGVMb29rZWQSMQoVcmVzZWFyY2hfc2xvdHNfaW5fdXNlGAggASgFUhJyZXNlYXJjaFNs'
    'b3RzSW5Vc2USJQoOcmVzZWFyY2hfc2xvdHMYCSABKAVSDXJlc2VhcmNoU2xvdHMSNQoOYmVzdF'
    '9vYmplY3RpdmUYCiABKAsyDi5sYWIudjEuTWV0cmljUg1iZXN0T2JqZWN0aXZl');

@$core.Deprecated('Use attemptRowDescriptor instead')
const AttemptRow$json = {
  '1': 'AttemptRow',
  '2': [
    {'1': 'seq', '3': 1, '4': 1, '5': 5, '10': 'seq'},
    {'1': 'candidate', '3': 2, '4': 1, '5': 5, '10': 'candidate'},
    {
      '1': 'params',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.AttemptRow.ParamsEntry',
      '10': 'params'
    },
    {'1': 'symbol', '3': 4, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
    {'1': 'failure', '3': 6, '4': 1, '5': 9, '10': 'failure'},
    {
      '1': 'total_return',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'totalReturn'
    },
    {
      '1': 'max_drawdown',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'maxDrawdown'
    },
    {
      '1': 'trades',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'trades'
    },
    {'1': 'has_eligibility', '3': 10, '4': 1, '5': 8, '10': 'hasEligibility'},
    {'1': 'eligible', '3': 11, '4': 1, '5': 8, '10': 'eligible'},
    {'1': 'violations', '3': 12, '4': 3, '5': 9, '10': 'violations'},
    {'1': 'cache', '3': 13, '4': 1, '5': 9, '10': 'cache'},
    {'1': 'runs', '3': 14, '4': 1, '5': 5, '10': 'runs'},
  ],
  '3': [AttemptRow_ParamsEntry$json],
};

@$core.Deprecated('Use attemptRowDescriptor instead')
const AttemptRow_ParamsEntry$json = {
  '1': 'ParamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AttemptRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attemptRowDescriptor = $convert.base64Decode(
    'CgpBdHRlbXB0Um93EhAKA3NlcRgBIAEoBVIDc2VxEhwKCWNhbmRpZGF0ZRgCIAEoBVIJY2FuZG'
    'lkYXRlEjYKBnBhcmFtcxgDIAMoCzIeLmxhYi52MS5BdHRlbXB0Um93LlBhcmFtc0VudHJ5UgZw'
    'YXJhbXMSFgoGc3ltYm9sGAQgASgJUgZzeW1ib2wSFgoGc3RhdHVzGAUgASgJUgZzdGF0dXMSGA'
    'oHZmFpbHVyZRgGIAEoCVIHZmFpbHVyZRIxCgx0b3RhbF9yZXR1cm4YByABKAsyDi5sYWIudjEu'
    'TWV0cmljUgt0b3RhbFJldHVybhIxCgxtYXhfZHJhd2Rvd24YCCABKAsyDi5sYWIudjEuTWV0cm'
    'ljUgttYXhEcmF3ZG93bhImCgZ0cmFkZXMYCSABKAsyDi5sYWIudjEuTWV0cmljUgZ0cmFkZXMS'
    'JwoPaGFzX2VsaWdpYmlsaXR5GAogASgIUg5oYXNFbGlnaWJpbGl0eRIaCghlbGlnaWJsZRgLIA'
    'EoCFIIZWxpZ2libGUSHgoKdmlvbGF0aW9ucxgMIAMoCVIKdmlvbGF0aW9ucxIUCgVjYWNoZRgN'
    'IAEoCVIFY2FjaGUSEgoEcnVucxgOIAEoBVIEcnVucxo5CgtQYXJhbXNFbnRyeRIQCgNrZXkYAS'
    'ABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgB');

@$core.Deprecated('Use listAttemptsRequestDescriptor instead')
const ListAttemptsRequest$json = {
  '1': 'ListAttemptsRequest',
  '2': [
    {'1': 'experiment_id', '3': 1, '4': 1, '5': 9, '10': 'experimentId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListAttemptsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAttemptsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0QXR0ZW1wdHNSZXF1ZXN0EiMKDWV4cGVyaW1lbnRfaWQYASABKAlSDGV4cGVyaW1lbn'
    'RJZBIWCgZzdGF0dXMYAiABKAlSBnN0YXR1cxIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl'
    'EhYKBm9mZnNldBgEIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listAttemptsResponseDescriptor instead')
const ListAttemptsResponse$json = {
  '1': 'ListAttemptsResponse',
  '2': [
    {
      '1': 'attempts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.AttemptRow',
      '10': 'attempts'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListAttemptsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAttemptsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QXR0ZW1wdHNSZXNwb25zZRIuCghhdHRlbXB0cxgBIAMoCzISLmxhYi52MS5BdHRlbX'
    'B0Um93UghhdHRlbXB0cxIUCgV0b3RhbBgCIAEoA1IFdG90YWw=');

@$core.Deprecated('Use pauseExperimentRequestDescriptor instead')
const PauseExperimentRequest$json = {
  '1': 'PauseExperimentRequest',
  '2': [
    {'1': 'experiment_id', '3': 1, '4': 1, '5': 9, '10': 'experimentId'},
  ],
};

/// Descriptor for `PauseExperimentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseExperimentRequestDescriptor =
    $convert.base64Decode(
        'ChZQYXVzZUV4cGVyaW1lbnRSZXF1ZXN0EiMKDWV4cGVyaW1lbnRfaWQYASABKAlSDGV4cGVyaW'
        '1lbnRJZA==');

@$core.Deprecated('Use pauseExperimentResponseDescriptor instead')
const PauseExperimentResponse$json = {
  '1': 'PauseExperimentResponse',
};

/// Descriptor for `PauseExperimentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseExperimentResponseDescriptor =
    $convert.base64Decode('ChdQYXVzZUV4cGVyaW1lbnRSZXNwb25zZQ==');

@$core.Deprecated('Use resumeExperimentRequestDescriptor instead')
const ResumeExperimentRequest$json = {
  '1': 'ResumeExperimentRequest',
  '2': [
    {'1': 'experiment_id', '3': 1, '4': 1, '5': 9, '10': 'experimentId'},
  ],
};

/// Descriptor for `ResumeExperimentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeExperimentRequestDescriptor =
    $convert.base64Decode(
        'ChdSZXN1bWVFeHBlcmltZW50UmVxdWVzdBIjCg1leHBlcmltZW50X2lkGAEgASgJUgxleHBlcm'
        'ltZW50SWQ=');

@$core.Deprecated('Use resumeExperimentResponseDescriptor instead')
const ResumeExperimentResponse$json = {
  '1': 'ResumeExperimentResponse',
};

/// Descriptor for `ResumeExperimentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeExperimentResponseDescriptor =
    $convert.base64Decode('ChhSZXN1bWVFeHBlcmltZW50UmVzcG9uc2U=');

@$core.Deprecated('Use cancelExperimentRequestDescriptor instead')
const CancelExperimentRequest$json = {
  '1': 'CancelExperimentRequest',
  '2': [
    {'1': 'experiment_id', '3': 1, '4': 1, '5': 9, '10': 'experimentId'},
  ],
};

/// Descriptor for `CancelExperimentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelExperimentRequestDescriptor =
    $convert.base64Decode(
        'ChdDYW5jZWxFeHBlcmltZW50UmVxdWVzdBIjCg1leHBlcmltZW50X2lkGAEgASgJUgxleHBlcm'
        'ltZW50SWQ=');

@$core.Deprecated('Use cancelExperimentResponseDescriptor instead')
const CancelExperimentResponse$json = {
  '1': 'CancelExperimentResponse',
};

/// Descriptor for `CancelExperimentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelExperimentResponseDescriptor =
    $convert.base64Decode('ChhDYW5jZWxFeHBlcmltZW50UmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> ExperimentServiceBase$json = {
  '1': 'ExperimentService',
  '2': [
    {
      '1': 'Estimate',
      '2': '.lab.v1.EstimateRequest',
      '3': '.lab.v1.EstimateResponse'
    },
    {
      '1': 'CreateExperiment',
      '2': '.lab.v1.CreateExperimentRequest',
      '3': '.lab.v1.CreateExperimentResponse'
    },
    {
      '1': 'ListExperiments',
      '2': '.lab.v1.ListExperimentsRequest',
      '3': '.lab.v1.ListExperimentsResponse'
    },
    {
      '1': 'GetExperiment',
      '2': '.lab.v1.GetExperimentRequest',
      '3': '.lab.v1.GetExperimentResponse'
    },
    {
      '1': 'WatchExperiment',
      '2': '.lab.v1.WatchExperimentRequest',
      '3': '.lab.v1.WatchExperimentResponse',
      '6': true
    },
    {
      '1': 'ListAttempts',
      '2': '.lab.v1.ListAttemptsRequest',
      '3': '.lab.v1.ListAttemptsResponse'
    },
    {
      '1': 'PauseExperiment',
      '2': '.lab.v1.PauseExperimentRequest',
      '3': '.lab.v1.PauseExperimentResponse'
    },
    {
      '1': 'ResumeExperiment',
      '2': '.lab.v1.ResumeExperimentRequest',
      '3': '.lab.v1.ResumeExperimentResponse'
    },
    {
      '1': 'CancelExperiment',
      '2': '.lab.v1.CancelExperimentRequest',
      '3': '.lab.v1.CancelExperimentResponse'
    },
  ],
};

@$core.Deprecated('Use experimentServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ExperimentServiceBase$messageJson = {
  '.lab.v1.EstimateRequest': EstimateRequest$json,
  '.lab.v1.ExperimentDefinition': ExperimentDefinition$json,
  '.lab.v1.Objective': Objective$json,
  '.lab.v1.Constraint': Constraint$json,
  '.lab.v1.ExperimentDefinition.SpaceEntry':
      ExperimentDefinition_SpaceEntry$json,
  '.lab.v1.ParamRange': ParamRange$json,
  '.lab.v1.SearchPlan': SearchPlan$json,
  '.lab.v1.Money': $0.Money$json,
  '.lab.v1.Decimal': $0.Decimal$json,
  '.lab.v1.EstimateResponse': EstimateResponse$json,
  '.lab.v1.CreateExperimentRequest': CreateExperimentRequest$json,
  '.lab.v1.CreateExperimentResponse': CreateExperimentResponse$json,
  '.lab.v1.ListExperimentsRequest': ListExperimentsRequest$json,
  '.lab.v1.ListExperimentsResponse': ListExperimentsResponse$json,
  '.lab.v1.ExperimentSummary': ExperimentSummary$json,
  '.lab.v1.AttemptCounts': AttemptCounts$json,
  '.lab.v1.GetExperimentRequest': GetExperimentRequest$json,
  '.lab.v1.GetExperimentResponse': GetExperimentResponse$json,
  '.lab.v1.ExperimentResult': ExperimentResult$json,
  '.lab.v1.ExperimentResult.ParamsEntry': ExperimentResult_ParamsEntry$json,
  '.lab.v1.Metric': $0.Metric$json,
  '.lab.v1.WatchExperimentRequest': WatchExperimentRequest$json,
  '.lab.v1.WatchExperimentResponse': WatchExperimentResponse$json,
  '.lab.v1.ListAttemptsRequest': ListAttemptsRequest$json,
  '.lab.v1.ListAttemptsResponse': ListAttemptsResponse$json,
  '.lab.v1.AttemptRow': AttemptRow$json,
  '.lab.v1.AttemptRow.ParamsEntry': AttemptRow_ParamsEntry$json,
  '.lab.v1.PauseExperimentRequest': PauseExperimentRequest$json,
  '.lab.v1.PauseExperimentResponse': PauseExperimentResponse$json,
  '.lab.v1.ResumeExperimentRequest': ResumeExperimentRequest$json,
  '.lab.v1.ResumeExperimentResponse': ResumeExperimentResponse$json,
  '.lab.v1.CancelExperimentRequest': CancelExperimentRequest$json,
  '.lab.v1.CancelExperimentResponse': CancelExperimentResponse$json,
};

/// Descriptor for `ExperimentService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List experimentServiceDescriptor = $convert.base64Decode(
    'ChFFeHBlcmltZW50U2VydmljZRI9CghFc3RpbWF0ZRIXLmxhYi52MS5Fc3RpbWF0ZVJlcXVlc3'
    'QaGC5sYWIudjEuRXN0aW1hdGVSZXNwb25zZRJVChBDcmVhdGVFeHBlcmltZW50Eh8ubGFiLnYx'
    'LkNyZWF0ZUV4cGVyaW1lbnRSZXF1ZXN0GiAubGFiLnYxLkNyZWF0ZUV4cGVyaW1lbnRSZXNwb2'
    '5zZRJSCg9MaXN0RXhwZXJpbWVudHMSHi5sYWIudjEuTGlzdEV4cGVyaW1lbnRzUmVxdWVzdBof'
    'LmxhYi52MS5MaXN0RXhwZXJpbWVudHNSZXNwb25zZRJMCg1HZXRFeHBlcmltZW50EhwubGFiLn'
    'YxLkdldEV4cGVyaW1lbnRSZXF1ZXN0Gh0ubGFiLnYxLkdldEV4cGVyaW1lbnRSZXNwb25zZRJU'
    'Cg9XYXRjaEV4cGVyaW1lbnQSHi5sYWIudjEuV2F0Y2hFeHBlcmltZW50UmVxdWVzdBofLmxhYi'
    '52MS5XYXRjaEV4cGVyaW1lbnRSZXNwb25zZTABEkkKDExpc3RBdHRlbXB0cxIbLmxhYi52MS5M'
    'aXN0QXR0ZW1wdHNSZXF1ZXN0GhwubGFiLnYxLkxpc3RBdHRlbXB0c1Jlc3BvbnNlElIKD1BhdX'
    'NlRXhwZXJpbWVudBIeLmxhYi52MS5QYXVzZUV4cGVyaW1lbnRSZXF1ZXN0Gh8ubGFiLnYxLlBh'
    'dXNlRXhwZXJpbWVudFJlc3BvbnNlElUKEFJlc3VtZUV4cGVyaW1lbnQSHy5sYWIudjEuUmVzdW'
    '1lRXhwZXJpbWVudFJlcXVlc3QaIC5sYWIudjEuUmVzdW1lRXhwZXJpbWVudFJlc3BvbnNlElUK'
    'EENhbmNlbEV4cGVyaW1lbnQSHy5sYWIudjEuQ2FuY2VsRXhwZXJpbWVudFJlcXVlc3QaIC5sYW'
    'IudjEuQ2FuY2VsRXhwZXJpbWVudFJlc3BvbnNl');
