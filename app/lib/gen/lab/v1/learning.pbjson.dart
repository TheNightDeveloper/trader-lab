// This is a generated file - do not edit.
//
// Generated from lab/v1/learning.proto.

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

@$core.Deprecated('Use learningGateDescriptor instead')
const LearningGate$json = {
  '1': 'LearningGate',
  '2': [
    {
      '1': 'max_drawdown',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'maxDrawdown'
    },
    {
      '1': 'min_forward_trades',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'minForwardTrades'
    },
    {'1': 'forward_days', '3': 3, '4': 1, '5': 5, '10': 'forwardDays'},
    {
      '1': 'min_improvement',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'minImprovement'
    },
    {
      '1': 'max_dd_degradation',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'maxDdDegradation'
    },
    {'1': 'min_walk_wins', '3': 6, '4': 1, '5': 5, '10': 'minWalkWins'},
  ],
};

/// Descriptor for `LearningGate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List learningGateDescriptor = $convert.base64Decode(
    'CgxMZWFybmluZ0dhdGUSMgoMbWF4X2RyYXdkb3duGAEgASgLMg8ubGFiLnYxLkRlY2ltYWxSC2'
    '1heERyYXdkb3duEiwKEm1pbl9mb3J3YXJkX3RyYWRlcxgCIAEoBVIQbWluRm9yd2FyZFRyYWRl'
    'cxIhCgxmb3J3YXJkX2RheXMYAyABKAVSC2ZvcndhcmREYXlzEjgKD21pbl9pbXByb3ZlbWVudB'
    'gEIAEoCzIPLmxhYi52MS5EZWNpbWFsUg5taW5JbXByb3ZlbWVudBI9ChJtYXhfZGRfZGVncmFk'
    'YXRpb24YBSABKAsyDy5sYWIudjEuRGVjaW1hbFIQbWF4RGREZWdyYWRhdGlvbhIiCg1taW5fd2'
    'Fsa193aW5zGAYgASgFUgttaW5XYWxrV2lucw==');

@$core.Deprecated('Use learningConfigDescriptor instead')
const LearningConfig$json = {
  '1': 'LearningConfig',
  '2': [
    {'1': 'algorithm_id', '3': 1, '4': 1, '5': 9, '10': 'algorithmId'},
    {'1': 'symbols', '3': 2, '4': 3, '5': 9, '10': 'symbols'},
    {'1': 'timeframe', '3': 3, '4': 1, '5': 9, '10': 'timeframe'},
    {'1': 'lookback_days', '3': 4, '4': 1, '5': 5, '10': 'lookbackDays'},
    {'1': 'enabled', '3': 5, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'hour_utc', '3': 6, '4': 1, '5': 5, '10': 'hourUtc'},
    {'1': 'min_fresh_bars', '3': 7, '4': 1, '5': 5, '10': 'minFreshBars'},
    {'1': 'folds', '3': 8, '4': 1, '5': 5, '10': 'folds'},
    {'1': 'max_candidates', '3': 9, '4': 1, '5': 5, '10': 'maxCandidates'},
    {'1': 'cpu_minutes', '3': 10, '4': 1, '5': 5, '10': 'cpuMinutes'},
    {'1': 'max_bars', '3': 11, '4': 1, '5': 3, '10': 'maxBars'},
    {'1': 'seed', '3': 12, '4': 1, '5': 4, '10': 'seed'},
    {
      '1': 'capital',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'capital'
    },
    {'1': 'fee', '3': 14, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'fee'},
    {
      '1': 'slippage',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'slippage'
    },
    {
      '1': 'gate',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.LearningGate',
      '10': 'gate'
    },
  ],
};

/// Descriptor for `LearningConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List learningConfigDescriptor = $convert.base64Decode(
    'Cg5MZWFybmluZ0NvbmZpZxIhCgxhbGdvcml0aG1faWQYASABKAlSC2FsZ29yaXRobUlkEhgKB3'
    'N5bWJvbHMYAiADKAlSB3N5bWJvbHMSHAoJdGltZWZyYW1lGAMgASgJUgl0aW1lZnJhbWUSIwoN'
    'bG9va2JhY2tfZGF5cxgEIAEoBVIMbG9va2JhY2tEYXlzEhgKB2VuYWJsZWQYBSABKAhSB2VuYW'
    'JsZWQSGQoIaG91cl91dGMYBiABKAVSB2hvdXJVdGMSJAoObWluX2ZyZXNoX2JhcnMYByABKAVS'
    'DG1pbkZyZXNoQmFycxIUCgVmb2xkcxgIIAEoBVIFZm9sZHMSJQoObWF4X2NhbmRpZGF0ZXMYCS'
    'ABKAVSDW1heENhbmRpZGF0ZXMSHwoLY3B1X21pbnV0ZXMYCiABKAVSCmNwdU1pbnV0ZXMSGQoI'
    'bWF4X2JhcnMYCyABKANSB21heEJhcnMSEgoEc2VlZBgMIAEoBFIEc2VlZBInCgdjYXBpdGFsGA'
    '0gASgLMg0ubGFiLnYxLk1vbmV5UgdjYXBpdGFsEiEKA2ZlZRgOIAEoCzIPLmxhYi52MS5EZWNp'
    'bWFsUgNmZWUSKwoIc2xpcHBhZ2UYDyABKAsyDy5sYWIudjEuRGVjaW1hbFIIc2xpcHBhZ2USKA'
    'oEZ2F0ZRgQIAEoCzIULmxhYi52MS5MZWFybmluZ0dhdGVSBGdhdGU=');

@$core.Deprecated('Use cycleStepDescriptor instead')
const CycleStep$json = {
  '1': 'CycleStep',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'meta', '3': 3, '4': 1, '5': 9, '10': 'meta'},
  ],
};

/// Descriptor for `CycleStep`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cycleStepDescriptor = $convert.base64Decode(
    'CglDeWNsZVN0ZXASEAoDa2V5GAEgASgJUgNrZXkSFgoGc3RhdHVzGAIgASgJUgZzdGF0dXMSEg'
    'oEbWV0YRgDIAEoCVIEbWV0YQ==');

@$core.Deprecated('Use gateItemDescriptor instead')
const GateItem$json = {
  '1': 'GateItem',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `GateItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gateItemDescriptor = $convert.base64Decode(
    'CghHYXRlSXRlbRIQCgNrZXkYASABKAlSA2tleRIWCgZzdGF0dXMYAiABKAlSBnN0YXR1cxISCg'
    'R0ZXh0GAMgASgJUgR0ZXh0');

@$core.Deprecated('Use contenderDescriptor instead')
const Contender$json = {
  '1': 'Contender',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'model_id', '3': 2, '4': 1, '5': 9, '10': 'modelId'},
    {'1': 'active', '3': 3, '4': 1, '5': 8, '10': 'active'},
    {'1': 'change', '3': 4, '4': 1, '5': 9, '10': 'change'},
    {'1': 'seq', '3': 5, '4': 1, '5': 5, '10': 'seq'},
    {'1': 'walk', '3': 6, '4': 3, '5': 11, '6': '.lab.v1.Metric', '10': 'walk'},
    {
      '1': 'forward',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'forward'
    },
  ],
};

/// Descriptor for `Contender`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contenderDescriptor = $convert.base64Decode(
    'CglDb250ZW5kZXISHQoKdmVyc2lvbl9pZBgBIAEoCVIJdmVyc2lvbklkEhkKCG1vZGVsX2lkGA'
    'IgASgJUgdtb2RlbElkEhYKBmFjdGl2ZRgDIAEoCFIGYWN0aXZlEhYKBmNoYW5nZRgEIAEoCVIG'
    'Y2hhbmdlEhAKA3NlcRgFIAEoBVIDc2VxEiIKBHdhbGsYBiADKAsyDi5sYWIudjEuTWV0cmljUg'
    'R3YWxrEigKB2ZvcndhcmQYByADKAsyDi5sYWIudjEuTWV0cmljUgdmb3J3YXJk');

@$core.Deprecated('Use cycleUsageDescriptor instead')
const CycleUsage$json = {
  '1': 'CycleUsage',
  '2': [
    {'1': 'cpu_seconds', '3': 1, '4': 1, '5': 3, '10': 'cpuSeconds'},
    {
      '1': 'cpu_budget_seconds',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'cpuBudgetSeconds'
    },
    {'1': 'candidates', '3': 3, '4': 1, '5': 5, '10': 'candidates'},
    {'1': 'max_candidates', '3': 4, '4': 1, '5': 5, '10': 'maxCandidates'},
    {'1': 'bars', '3': 5, '4': 1, '5': 3, '10': 'bars'},
    {'1': 'max_bars', '3': 6, '4': 1, '5': 3, '10': 'maxBars'},
  ],
};

/// Descriptor for `CycleUsage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cycleUsageDescriptor = $convert.base64Decode(
    'CgpDeWNsZVVzYWdlEh8KC2NwdV9zZWNvbmRzGAEgASgDUgpjcHVTZWNvbmRzEiwKEmNwdV9idW'
    'RnZXRfc2Vjb25kcxgCIAEoA1IQY3B1QnVkZ2V0U2Vjb25kcxIeCgpjYW5kaWRhdGVzGAMgASgF'
    'UgpjYW5kaWRhdGVzEiUKDm1heF9jYW5kaWRhdGVzGAQgASgFUg1tYXhDYW5kaWRhdGVzEhIKBG'
    'JhcnMYBSABKANSBGJhcnMSGQoIbWF4X2JhcnMYBiABKANSB21heEJhcnM=');

@$core.Deprecated('Use cycleDescriptor instead')
const Cycle$json = {
  '1': 'Cycle',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'algorithm_id', '3': 2, '4': 1, '5': 9, '10': 'algorithmId'},
    {'1': 'trigger', '3': 3, '4': 1, '5': 9, '10': 'trigger'},
    {'1': 'state', '3': 4, '4': 1, '5': 9, '10': 'state'},
    {'1': 'outcome', '3': 5, '4': 1, '5': 9, '10': 'outcome'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'started_unix_ms', '3': 7, '4': 1, '5': 3, '10': 'startedUnixMs'},
    {'1': 'finished_unix_ms', '3': 8, '4': 1, '5': 3, '10': 'finishedUnixMs'},
    {'1': 'freeze_unix_ms', '3': 9, '4': 1, '5': 3, '10': 'freezeUnixMs'},
    {'1': 'forward_days', '3': 10, '4': 1, '5': 5, '10': 'forwardDays'},
    {
      '1': 'forward_days_target',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'forwardDaysTarget'
    },
    {
      '1': 'steps',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.CycleStep',
      '10': 'steps'
    },
    {
      '1': 'gate',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.GateItem',
      '10': 'gate'
    },
    {
      '1': 'champion',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Contender',
      '10': 'champion'
    },
    {
      '1': 'challenger',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Contender',
      '10': 'challenger'
    },
    {
      '1': 'usage',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.CycleUsage',
      '10': 'usage'
    },
    {'1': 'candidates', '3': 17, '4': 1, '5': 5, '10': 'candidates'},
    {'1': 'eligible', '3': 18, '4': 1, '5': 5, '10': 'eligible'},
    {'1': 'walk_wins', '3': 19, '4': 1, '5': 5, '10': 'walkWins'},
    {'1': 'walk_folds', '3': 20, '4': 1, '5': 5, '10': 'walkFolds'},
    {'1': 'can_approve', '3': 21, '4': 1, '5': 8, '10': 'canApprove'},
  ],
};

/// Descriptor for `Cycle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cycleDescriptor = $convert.base64Decode(
    'CgVDeWNsZRIOCgJpZBgBIAEoA1ICaWQSIQoMYWxnb3JpdGhtX2lkGAIgASgJUgthbGdvcml0aG'
    '1JZBIYCgd0cmlnZ2VyGAMgASgJUgd0cmlnZ2VyEhQKBXN0YXRlGAQgASgJUgVzdGF0ZRIYCgdv'
    'dXRjb21lGAUgASgJUgdvdXRjb21lEhYKBnJlYXNvbhgGIAEoCVIGcmVhc29uEiYKD3N0YXJ0ZW'
    'RfdW5peF9tcxgHIAEoA1INc3RhcnRlZFVuaXhNcxIoChBmaW5pc2hlZF91bml4X21zGAggASgD'
    'Ug5maW5pc2hlZFVuaXhNcxIkCg5mcmVlemVfdW5peF9tcxgJIAEoA1IMZnJlZXplVW5peE1zEi'
    'EKDGZvcndhcmRfZGF5cxgKIAEoBVILZm9yd2FyZERheXMSLgoTZm9yd2FyZF9kYXlzX3Rhcmdl'
    'dBgLIAEoBVIRZm9yd2FyZERheXNUYXJnZXQSJwoFc3RlcHMYDCADKAsyES5sYWIudjEuQ3ljbG'
    'VTdGVwUgVzdGVwcxIkCgRnYXRlGA0gAygLMhAubGFiLnYxLkdhdGVJdGVtUgRnYXRlEi0KCGNo'
    'YW1waW9uGA4gASgLMhEubGFiLnYxLkNvbnRlbmRlclIIY2hhbXBpb24SMQoKY2hhbGxlbmdlch'
    'gPIAEoCzIRLmxhYi52MS5Db250ZW5kZXJSCmNoYWxsZW5nZXISKAoFdXNhZ2UYECABKAsyEi5s'
    'YWIudjEuQ3ljbGVVc2FnZVIFdXNhZ2USHgoKY2FuZGlkYXRlcxgRIAEoBVIKY2FuZGlkYXRlcx'
    'IaCghlbGlnaWJsZRgSIAEoBVIIZWxpZ2libGUSGwoJd2Fsa193aW5zGBMgASgFUgh3YWxrV2lu'
    'cxIdCgp3YWxrX2ZvbGRzGBQgASgFUgl3YWxrRm9sZHMSHwoLY2FuX2FwcHJvdmUYFSABKAhSCm'
    'NhbkFwcHJvdmU=');

@$core.Deprecated('Use activeModelDescriptor instead')
const ActiveModel$json = {
  '1': 'ActiveModel',
  '2': [
    {'1': 'algorithm_id', '3': 1, '4': 1, '5': 9, '10': 'algorithmId'},
    {'1': 'version_id', '3': 2, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'model_id', '3': 3, '4': 1, '5': 9, '10': 'modelId'},
    {
      '1': 'model_as_of_unix_ms',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'modelAsOfUnixMs'
    },
  ],
};

/// Descriptor for `ActiveModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activeModelDescriptor = $convert.base64Decode(
    'CgtBY3RpdmVNb2RlbBIhCgxhbGdvcml0aG1faWQYASABKAlSC2FsZ29yaXRobUlkEh0KCnZlcn'
    'Npb25faWQYAiABKAlSCXZlcnNpb25JZBIZCghtb2RlbF9pZBgDIAEoCVIHbW9kZWxJZBIsChNt'
    'b2RlbF9hc19vZl91bml4X21zGAQgASgDUg9tb2RlbEFzT2ZVbml4TXM=');

@$core.Deprecated('Use getLearningRequestDescriptor instead')
const GetLearningRequest$json = {
  '1': 'GetLearningRequest',
};

/// Descriptor for `GetLearningRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLearningRequestDescriptor =
    $convert.base64Decode('ChJHZXRMZWFybmluZ1JlcXVlc3Q=');

@$core.Deprecated('Use getLearningResponseDescriptor instead')
const GetLearningResponse$json = {
  '1': 'GetLearningResponse',
  '2': [
    {
      '1': 'config',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.LearningConfig',
      '10': 'config'
    },
    {
      '1': 'current',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Cycle',
      '10': 'current'
    },
    {
      '1': 'active',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ActiveModel',
      '10': 'active'
    },
    {'1': 'can_rollback', '3': 4, '4': 1, '5': 8, '10': 'canRollback'},
    {
      '1': 'learning_algorithms',
      '3': 5,
      '4': 3,
      '5': 9,
      '10': 'learningAlgorithms'
    },
  ],
};

/// Descriptor for `GetLearningResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLearningResponseDescriptor = $convert.base64Decode(
    'ChNHZXRMZWFybmluZ1Jlc3BvbnNlEi4KBmNvbmZpZxgBIAEoCzIWLmxhYi52MS5MZWFybmluZ0'
    'NvbmZpZ1IGY29uZmlnEicKB2N1cnJlbnQYAiABKAsyDS5sYWIudjEuQ3ljbGVSB2N1cnJlbnQS'
    'KwoGYWN0aXZlGAMgASgLMhMubGFiLnYxLkFjdGl2ZU1vZGVsUgZhY3RpdmUSIQoMY2FuX3JvbG'
    'xiYWNrGAQgASgIUgtjYW5Sb2xsYmFjaxIvChNsZWFybmluZ19hbGdvcml0aG1zGAUgAygJUhJs'
    'ZWFybmluZ0FsZ29yaXRobXM=');

@$core.Deprecated('Use saveConfigRequestDescriptor instead')
const SaveConfigRequest$json = {
  '1': 'SaveConfigRequest',
  '2': [
    {
      '1': 'config',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.LearningConfig',
      '10': 'config'
    },
  ],
};

/// Descriptor for `SaveConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveConfigRequestDescriptor = $convert.base64Decode(
    'ChFTYXZlQ29uZmlnUmVxdWVzdBIuCgZjb25maWcYASABKAsyFi5sYWIudjEuTGVhcm5pbmdDb2'
    '5maWdSBmNvbmZpZw==');

@$core.Deprecated('Use saveConfigResponseDescriptor instead')
const SaveConfigResponse$json = {
  '1': 'SaveConfigResponse',
};

/// Descriptor for `SaveConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveConfigResponseDescriptor =
    $convert.base64Decode('ChJTYXZlQ29uZmlnUmVzcG9uc2U=');

@$core.Deprecated('Use startCycleRequestDescriptor instead')
const StartCycleRequest$json = {
  '1': 'StartCycleRequest',
};

/// Descriptor for `StartCycleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startCycleRequestDescriptor =
    $convert.base64Decode('ChFTdGFydEN5Y2xlUmVxdWVzdA==');

@$core.Deprecated('Use startCycleResponseDescriptor instead')
const StartCycleResponse$json = {
  '1': 'StartCycleResponse',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 3, '10': 'cycleId'},
  ],
};

/// Descriptor for `StartCycleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startCycleResponseDescriptor =
    $convert.base64Decode(
        'ChJTdGFydEN5Y2xlUmVzcG9uc2USGQoIY3ljbGVfaWQYASABKANSB2N5Y2xlSWQ=');

@$core.Deprecated('Use listCyclesRequestDescriptor instead')
const ListCyclesRequest$json = {
  '1': 'ListCyclesRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListCyclesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCyclesRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0Q3ljbGVzUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2VTaXplEhYKBm9mZn'
    'NldBgCIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listCyclesResponseDescriptor instead')
const ListCyclesResponse$json = {
  '1': 'ListCyclesResponse',
  '2': [
    {
      '1': 'cycles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Cycle',
      '10': 'cycles'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListCyclesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCyclesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0Q3ljbGVzUmVzcG9uc2USJQoGY3ljbGVzGAEgAygLMg0ubGFiLnYxLkN5Y2xlUgZjeW'
    'NsZXMSFAoFdG90YWwYAiABKANSBXRvdGFs');

@$core.Deprecated('Use cycleCandidateDescriptor instead')
const CycleCandidate$json = {
  '1': 'CycleCandidate',
  '2': [
    {'1': 'seq', '3': 1, '4': 1, '5': 5, '10': 'seq'},
    {'1': 'change', '3': 2, '4': 1, '5': 9, '10': 'change'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'failure', '3': 4, '4': 1, '5': 9, '10': 'failure'},
    {
      '1': 'total_return',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'totalReturn'
    },
    {
      '1': 'max_drawdown',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Metric',
      '10': 'maxDrawdown'
    },
    {'1': 'wins', '3': 7, '4': 1, '5': 5, '10': 'wins'},
    {'1': 'eligible', '3': 8, '4': 1, '5': 8, '10': 'eligible'},
    {'1': 'why', '3': 9, '4': 1, '5': 9, '10': 'why'},
  ],
};

/// Descriptor for `CycleCandidate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cycleCandidateDescriptor = $convert.base64Decode(
    'Cg5DeWNsZUNhbmRpZGF0ZRIQCgNzZXEYASABKAVSA3NlcRIWCgZjaGFuZ2UYAiABKAlSBmNoYW'
    '5nZRIWCgZzdGF0dXMYAyABKAlSBnN0YXR1cxIYCgdmYWlsdXJlGAQgASgJUgdmYWlsdXJlEjEK'
    'DHRvdGFsX3JldHVybhgFIAEoCzIOLmxhYi52MS5NZXRyaWNSC3RvdGFsUmV0dXJuEjEKDG1heF'
    '9kcmF3ZG93bhgGIAEoCzIOLmxhYi52MS5NZXRyaWNSC21heERyYXdkb3duEhIKBHdpbnMYByAB'
    'KAVSBHdpbnMSGgoIZWxpZ2libGUYCCABKAhSCGVsaWdpYmxlEhAKA3doeRgJIAEoCVIDd2h5');

@$core.Deprecated('Use listCandidatesRequestDescriptor instead')
const ListCandidatesRequest$json = {
  '1': 'ListCandidatesRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 3, '10': 'cycleId'},
  ],
};

/// Descriptor for `ListCandidatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCandidatesRequestDescriptor =
    $convert.base64Decode(
        'ChVMaXN0Q2FuZGlkYXRlc1JlcXVlc3QSGQoIY3ljbGVfaWQYASABKANSB2N5Y2xlSWQ=');

@$core.Deprecated('Use listCandidatesResponseDescriptor instead')
const ListCandidatesResponse$json = {
  '1': 'ListCandidatesResponse',
  '2': [
    {
      '1': 'candidates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.CycleCandidate',
      '10': 'candidates'
    },
  ],
};

/// Descriptor for `ListCandidatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCandidatesResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0Q2FuZGlkYXRlc1Jlc3BvbnNlEjYKCmNhbmRpZGF0ZXMYASADKAsyFi5sYWIudjEuQ3'
        'ljbGVDYW5kaWRhdGVSCmNhbmRpZGF0ZXM=');

@$core.Deprecated('Use modelInfoDescriptor instead')
const ModelInfo$json = {
  '1': 'ModelInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'version_id', '3': 2, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'as_of_unix_ms', '3': 4, '4': 1, '5': 3, '10': 'asOfUnixMs'},
    {
      '1': 'train_from_unix_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'trainFromUnixMs'
    },
    {'1': 'train_to_unix_ms', '3': 6, '4': 1, '5': 3, '10': 'trainToUnixMs'},
    {'1': 'seed', '3': 7, '4': 1, '5': 4, '10': 'seed'},
    {'1': 'recipe_hash', '3': 8, '4': 1, '5': 9, '10': 'recipeHash'},
    {'1': 'samples', '3': 9, '4': 1, '5': 5, '10': 'samples'},
    {'1': 'parent', '3': 10, '4': 1, '5': 9, '10': 'parent'},
    {'1': 'cycle_id', '3': 11, '4': 1, '5': 3, '10': 'cycleId'},
    {'1': 'train_error', '3': 12, '4': 1, '5': 1, '10': 'trainError'},
  ],
};

/// Descriptor for `ModelInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modelInfoDescriptor = $convert.base64Decode(
    'CglNb2RlbEluZm8SDgoCaWQYASABKAlSAmlkEh0KCnZlcnNpb25faWQYAiABKAlSCXZlcnNpb2'
    '5JZBIWCgZzdGF0dXMYAyABKAlSBnN0YXR1cxIhCg1hc19vZl91bml4X21zGAQgASgDUgphc09m'
    'VW5peE1zEisKEnRyYWluX2Zyb21fdW5peF9tcxgFIAEoA1IPdHJhaW5Gcm9tVW5peE1zEicKEH'
    'RyYWluX3RvX3VuaXhfbXMYBiABKANSDXRyYWluVG9Vbml4TXMSEgoEc2VlZBgHIAEoBFIEc2Vl'
    'ZBIfCgtyZWNpcGVfaGFzaBgIIAEoCVIKcmVjaXBlSGFzaBIYCgdzYW1wbGVzGAkgASgFUgdzYW'
    '1wbGVzEhYKBnBhcmVudBgKIAEoCVIGcGFyZW50EhkKCGN5Y2xlX2lkGAsgASgDUgdjeWNsZUlk'
    'Eh8KC3RyYWluX2Vycm9yGAwgASgBUgp0cmFpbkVycm9y');

@$core.Deprecated('Use listModelsRequestDescriptor instead')
const ListModelsRequest$json = {
  '1': 'ListModelsRequest',
};

/// Descriptor for `ListModelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listModelsRequestDescriptor =
    $convert.base64Decode('ChFMaXN0TW9kZWxzUmVxdWVzdA==');

@$core.Deprecated('Use listModelsResponseDescriptor instead')
const ListModelsResponse$json = {
  '1': 'ListModelsResponse',
  '2': [
    {
      '1': 'models',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.ModelInfo',
      '10': 'models'
    },
  ],
};

/// Descriptor for `ListModelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listModelsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0TW9kZWxzUmVzcG9uc2USKQoGbW9kZWxzGAEgAygLMhEubGFiLnYxLk1vZGVsSW5mb1'
    'IGbW9kZWxz');

@$core.Deprecated('Use approveCycleRequestDescriptor instead')
const ApproveCycleRequest$json = {
  '1': 'ApproveCycleRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 3, '10': 'cycleId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ApproveCycleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveCycleRequestDescriptor = $convert.base64Decode(
    'ChNBcHByb3ZlQ3ljbGVSZXF1ZXN0EhkKCGN5Y2xlX2lkGAEgASgDUgdjeWNsZUlkEhIKBG5vdG'
    'UYAiABKAlSBG5vdGU=');

@$core.Deprecated('Use approveCycleResponseDescriptor instead')
const ApproveCycleResponse$json = {
  '1': 'ApproveCycleResponse',
};

/// Descriptor for `ApproveCycleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveCycleResponseDescriptor =
    $convert.base64Decode('ChRBcHByb3ZlQ3ljbGVSZXNwb25zZQ==');

@$core.Deprecated('Use rejectCycleRequestDescriptor instead')
const RejectCycleRequest$json = {
  '1': 'RejectCycleRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 3, '10': 'cycleId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RejectCycleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectCycleRequestDescriptor = $convert.base64Decode(
    'ChJSZWplY3RDeWNsZVJlcXVlc3QSGQoIY3ljbGVfaWQYASABKANSB2N5Y2xlSWQSEgoEbm90ZR'
    'gCIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use rejectCycleResponseDescriptor instead')
const RejectCycleResponse$json = {
  '1': 'RejectCycleResponse',
};

/// Descriptor for `RejectCycleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectCycleResponseDescriptor =
    $convert.base64Decode('ChNSZWplY3RDeWNsZVJlc3BvbnNl');

@$core.Deprecated('Use rollbackRequestDescriptor instead')
const RollbackRequest$json = {
  '1': 'RollbackRequest',
  '2': [
    {'1': 'note', '3': 1, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RollbackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rollbackRequestDescriptor = $convert
    .base64Decode('Cg9Sb2xsYmFja1JlcXVlc3QSEgoEbm90ZRgBIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use rollbackResponseDescriptor instead')
const RollbackResponse$json = {
  '1': 'RollbackResponse',
};

/// Descriptor for `RollbackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rollbackResponseDescriptor =
    $convert.base64Decode('ChBSb2xsYmFja1Jlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> LearningServiceBase$json = {
  '1': 'LearningService',
  '2': [
    {
      '1': 'GetLearning',
      '2': '.lab.v1.GetLearningRequest',
      '3': '.lab.v1.GetLearningResponse'
    },
    {
      '1': 'SaveConfig',
      '2': '.lab.v1.SaveConfigRequest',
      '3': '.lab.v1.SaveConfigResponse'
    },
    {
      '1': 'StartCycle',
      '2': '.lab.v1.StartCycleRequest',
      '3': '.lab.v1.StartCycleResponse'
    },
    {
      '1': 'ListCycles',
      '2': '.lab.v1.ListCyclesRequest',
      '3': '.lab.v1.ListCyclesResponse'
    },
    {
      '1': 'ListCandidates',
      '2': '.lab.v1.ListCandidatesRequest',
      '3': '.lab.v1.ListCandidatesResponse'
    },
    {
      '1': 'ListModels',
      '2': '.lab.v1.ListModelsRequest',
      '3': '.lab.v1.ListModelsResponse'
    },
    {
      '1': 'ApproveCycle',
      '2': '.lab.v1.ApproveCycleRequest',
      '3': '.lab.v1.ApproveCycleResponse'
    },
    {
      '1': 'RejectCycle',
      '2': '.lab.v1.RejectCycleRequest',
      '3': '.lab.v1.RejectCycleResponse'
    },
    {
      '1': 'Rollback',
      '2': '.lab.v1.RollbackRequest',
      '3': '.lab.v1.RollbackResponse'
    },
  ],
};

@$core.Deprecated('Use learningServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    LearningServiceBase$messageJson = {
  '.lab.v1.GetLearningRequest': GetLearningRequest$json,
  '.lab.v1.GetLearningResponse': GetLearningResponse$json,
  '.lab.v1.LearningConfig': LearningConfig$json,
  '.lab.v1.Money': $0.Money$json,
  '.lab.v1.Decimal': $0.Decimal$json,
  '.lab.v1.LearningGate': LearningGate$json,
  '.lab.v1.Cycle': Cycle$json,
  '.lab.v1.CycleStep': CycleStep$json,
  '.lab.v1.GateItem': GateItem$json,
  '.lab.v1.Contender': Contender$json,
  '.lab.v1.Metric': $0.Metric$json,
  '.lab.v1.CycleUsage': CycleUsage$json,
  '.lab.v1.ActiveModel': ActiveModel$json,
  '.lab.v1.SaveConfigRequest': SaveConfigRequest$json,
  '.lab.v1.SaveConfigResponse': SaveConfigResponse$json,
  '.lab.v1.StartCycleRequest': StartCycleRequest$json,
  '.lab.v1.StartCycleResponse': StartCycleResponse$json,
  '.lab.v1.ListCyclesRequest': ListCyclesRequest$json,
  '.lab.v1.ListCyclesResponse': ListCyclesResponse$json,
  '.lab.v1.ListCandidatesRequest': ListCandidatesRequest$json,
  '.lab.v1.ListCandidatesResponse': ListCandidatesResponse$json,
  '.lab.v1.CycleCandidate': CycleCandidate$json,
  '.lab.v1.ListModelsRequest': ListModelsRequest$json,
  '.lab.v1.ListModelsResponse': ListModelsResponse$json,
  '.lab.v1.ModelInfo': ModelInfo$json,
  '.lab.v1.ApproveCycleRequest': ApproveCycleRequest$json,
  '.lab.v1.ApproveCycleResponse': ApproveCycleResponse$json,
  '.lab.v1.RejectCycleRequest': RejectCycleRequest$json,
  '.lab.v1.RejectCycleResponse': RejectCycleResponse$json,
  '.lab.v1.RollbackRequest': RollbackRequest$json,
  '.lab.v1.RollbackResponse': RollbackResponse$json,
};

/// Descriptor for `LearningService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List learningServiceDescriptor = $convert.base64Decode(
    'Cg9MZWFybmluZ1NlcnZpY2USRgoLR2V0TGVhcm5pbmcSGi5sYWIudjEuR2V0TGVhcm5pbmdSZX'
    'F1ZXN0GhsubGFiLnYxLkdldExlYXJuaW5nUmVzcG9uc2USQwoKU2F2ZUNvbmZpZxIZLmxhYi52'
    'MS5TYXZlQ29uZmlnUmVxdWVzdBoaLmxhYi52MS5TYXZlQ29uZmlnUmVzcG9uc2USQwoKU3Rhcn'
    'RDeWNsZRIZLmxhYi52MS5TdGFydEN5Y2xlUmVxdWVzdBoaLmxhYi52MS5TdGFydEN5Y2xlUmVz'
    'cG9uc2USQwoKTGlzdEN5Y2xlcxIZLmxhYi52MS5MaXN0Q3ljbGVzUmVxdWVzdBoaLmxhYi52MS'
    '5MaXN0Q3ljbGVzUmVzcG9uc2USTwoOTGlzdENhbmRpZGF0ZXMSHS5sYWIudjEuTGlzdENhbmRp'
    'ZGF0ZXNSZXF1ZXN0Gh4ubGFiLnYxLkxpc3RDYW5kaWRhdGVzUmVzcG9uc2USQwoKTGlzdE1vZG'
    'VscxIZLmxhYi52MS5MaXN0TW9kZWxzUmVxdWVzdBoaLmxhYi52MS5MaXN0TW9kZWxzUmVzcG9u'
    'c2USSQoMQXBwcm92ZUN5Y2xlEhsubGFiLnYxLkFwcHJvdmVDeWNsZVJlcXVlc3QaHC5sYWIudj'
    'EuQXBwcm92ZUN5Y2xlUmVzcG9uc2USRgoLUmVqZWN0Q3ljbGUSGi5sYWIudjEuUmVqZWN0Q3lj'
    'bGVSZXF1ZXN0GhsubGFiLnYxLlJlamVjdEN5Y2xlUmVzcG9uc2USPQoIUm9sbGJhY2sSFy5sYW'
    'IudjEuUm9sbGJhY2tSZXF1ZXN0GhgubGFiLnYxLlJvbGxiYWNrUmVzcG9uc2U=');
