// This is a generated file - do not edit.
//
// Generated from lab/v1/paper.proto.

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

import 'account.pbjson.dart' as $1;
import 'common.pbjson.dart' as $0;
import 'workspace.pbjson.dart' as $2;

@$core.Deprecated('Use getPaperAccountRequestDescriptor instead')
const GetPaperAccountRequest$json = {
  '1': 'GetPaperAccountRequest',
};

/// Descriptor for `GetPaperAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaperAccountRequestDescriptor =
    $convert.base64Decode('ChZHZXRQYXBlckFjY291bnRSZXF1ZXN0');

@$core.Deprecated('Use getPaperAccountResponseDescriptor instead')
const GetPaperAccountResponse$json = {
  '1': 'GetPaperAccountResponse',
  '2': [
    {
      '1': 'paper_account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperAccount',
      '10': 'paperAccount'
    },
  ],
};

/// Descriptor for `GetPaperAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaperAccountResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRQYXBlckFjY291bnRSZXNwb25zZRI5Cg1wYXBlcl9hY2NvdW50GAEgASgLMhQubGFiLn'
        'YxLlBhcGVyQWNjb3VudFIMcGFwZXJBY2NvdW50');

@$core.Deprecated('Use initializePaperAccountRequestDescriptor instead')
const InitializePaperAccountRequest$json = {
  '1': 'InitializePaperAccountRequest',
  '2': [
    {
      '1': 'capital',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'capital'
    },
    {
      '1': 'max_loss_per_trade',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'maxLossPerTrade'
    },
    {
      '1': 'max_open_loss',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'maxOpenLoss'
    },
    {
      '1': 'max_spot_exposure',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'maxSpotExposure'
    },
  ],
};

/// Descriptor for `InitializePaperAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initializePaperAccountRequestDescriptor = $convert.base64Decode(
    'Ch1Jbml0aWFsaXplUGFwZXJBY2NvdW50UmVxdWVzdBInCgdjYXBpdGFsGAEgASgLMg0ubGFiLn'
    'YxLk1vbmV5UgdjYXBpdGFsEjoKEm1heF9sb3NzX3Blcl90cmFkZRgCIAEoCzINLmxhYi52MS5N'
    'b25leVIPbWF4TG9zc1BlclRyYWRlEjEKDW1heF9vcGVuX2xvc3MYAyABKAsyDS5sYWIudjEuTW'
    '9uZXlSC21heE9wZW5Mb3NzEjkKEW1heF9zcG90X2V4cG9zdXJlGAQgASgLMg0ubGFiLnYxLk1v'
    'bmV5Ug9tYXhTcG90RXhwb3N1cmU=');

@$core.Deprecated('Use initializePaperAccountResponseDescriptor instead')
const InitializePaperAccountResponse$json = {
  '1': 'InitializePaperAccountResponse',
  '2': [
    {
      '1': 'paper_account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperAccount',
      '10': 'paperAccount'
    },
  ],
};

/// Descriptor for `InitializePaperAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initializePaperAccountResponseDescriptor =
    $convert.base64Decode(
        'Ch5Jbml0aWFsaXplUGFwZXJBY2NvdW50UmVzcG9uc2USOQoNcGFwZXJfYWNjb3VudBgBIAEoCz'
        'IULmxhYi52MS5QYXBlckFjY291bnRSDHBhcGVyQWNjb3VudA==');

@$core.Deprecated('Use paperAccountDescriptor instead')
const PaperAccount$json = {
  '1': 'PaperAccount',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountSnapshot',
      '10': 'snapshot'
    },
    {
      '1': 'initial_capital',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'initialCapital'
    },
    {
      '1': 'reserved_balance',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'reservedBalance'
    },
    {
      '1': 'max_loss_per_trade',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'maxLossPerTrade'
    },
    {
      '1': 'max_open_loss',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'maxOpenLoss'
    },
    {
      '1': 'max_spot_exposure',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'maxSpotExposure'
    },
    {
      '1': 'fee_rate',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'feeRate'
    },
    {
      '1': 'slippage_rate',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'slippageRate'
    },
  ],
};

/// Descriptor for `PaperAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperAccountDescriptor = $convert.base64Decode(
    'CgxQYXBlckFjY291bnQSMwoIc25hcHNob3QYASABKAsyFy5sYWIudjEuQWNjb3VudFNuYXBzaG'
    '90UghzbmFwc2hvdBI2Cg9pbml0aWFsX2NhcGl0YWwYAiABKAsyDS5sYWIudjEuTW9uZXlSDmlu'
    'aXRpYWxDYXBpdGFsEjgKEHJlc2VydmVkX2JhbGFuY2UYAyABKAsyDS5sYWIudjEuTW9uZXlSD3'
    'Jlc2VydmVkQmFsYW5jZRI6ChJtYXhfbG9zc19wZXJfdHJhZGUYBCABKAsyDS5sYWIudjEuTW9u'
    'ZXlSD21heExvc3NQZXJUcmFkZRIxCg1tYXhfb3Blbl9sb3NzGAUgASgLMg0ubGFiLnYxLk1vbm'
    'V5UgttYXhPcGVuTG9zcxI5ChFtYXhfc3BvdF9leHBvc3VyZRgGIAEoCzINLmxhYi52MS5Nb25l'
    'eVIPbWF4U3BvdEV4cG9zdXJlEioKCGZlZV9yYXRlGAcgASgLMg8ubGFiLnYxLkRlY2ltYWxSB2'
    'ZlZVJhdGUSNAoNc2xpcHBhZ2VfcmF0ZRgIIAEoCzIPLmxhYi52MS5EZWNpbWFsUgxzbGlwcGFn'
    'ZVJhdGU=');

@$core.Deprecated('Use previewPaperPlanRequestDescriptor instead')
const PreviewPaperPlanRequest$json = {
  '1': 'PreviewPaperPlanRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '10': 'account'
    },
    {'1': 'opportunity_id', '3': 2, '4': 1, '5': 3, '10': 'opportunityId'},
    {'1': 'stop', '3': 3, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'stop'},
    {
      '1': 'take_profit',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'takeProfit'
    },
  ],
};

/// Descriptor for `PreviewPaperPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewPaperPlanRequestDescriptor = $convert.base64Decode(
    'ChdQcmV2aWV3UGFwZXJQbGFuUmVxdWVzdBIsCgdhY2NvdW50GAEgASgLMhIubGFiLnYxLkFjY2'
    '91bnRSZWZSB2FjY291bnQSJQoOb3Bwb3J0dW5pdHlfaWQYAiABKANSDW9wcG9ydHVuaXR5SWQS'
    'IQoEc3RvcBgDIAEoCzINLmxhYi52MS5Nb25leVIEc3RvcBIuCgt0YWtlX3Byb2ZpdBgEIAEoCz'
    'INLmxhYi52MS5Nb25leVIKdGFrZVByb2ZpdA==');

@$core.Deprecated('Use previewPaperPlanResponseDescriptor instead')
const PreviewPaperPlanResponse$json = {
  '1': 'PreviewPaperPlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperPlan',
      '10': 'plan'
    },
    {
      '1': 'restriction',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperRestriction',
      '10': 'restriction'
    },
  ],
};

/// Descriptor for `PreviewPaperPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewPaperPlanResponseDescriptor = $convert.base64Decode(
    'ChhQcmV2aWV3UGFwZXJQbGFuUmVzcG9uc2USJQoEcGxhbhgBIAEoCzIRLmxhYi52MS5QYXBlcl'
    'BsYW5SBHBsYW4SOgoLcmVzdHJpY3Rpb24YAiABKAsyGC5sYWIudjEuUGFwZXJSZXN0cmljdGlv'
    'blILcmVzdHJpY3Rpb24=');

@$core.Deprecated('Use getPaperPlanRequestDescriptor instead')
const GetPaperPlanRequest$json = {
  '1': 'GetPaperPlanRequest',
  '2': [
    {'1': 'plan_hash', '3': 1, '4': 1, '5': 9, '10': 'planHash'},
  ],
};

/// Descriptor for `GetPaperPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaperPlanRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRQYXBlclBsYW5SZXF1ZXN0EhsKCXBsYW5faGFzaBgBIAEoCVIIcGxhbkhhc2g=');

@$core.Deprecated('Use getPaperPlanResponseDescriptor instead')
const GetPaperPlanResponse$json = {
  '1': 'GetPaperPlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperPlan',
      '10': 'plan'
    },
    {
      '1': 'restriction',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperRestriction',
      '10': 'restriction'
    },
  ],
};

/// Descriptor for `GetPaperPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaperPlanResponseDescriptor = $convert.base64Decode(
    'ChRHZXRQYXBlclBsYW5SZXNwb25zZRIlCgRwbGFuGAEgASgLMhEubGFiLnYxLlBhcGVyUGxhbl'
    'IEcGxhbhI6CgtyZXN0cmljdGlvbhgCIAEoCzIYLmxhYi52MS5QYXBlclJlc3RyaWN0aW9uUgty'
    'ZXN0cmljdGlvbg==');

@$core.Deprecated('Use paperRestrictionDescriptor instead')
const PaperRestriction$json = {
  '1': 'PaperRestriction',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `PaperRestriction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperRestrictionDescriptor = $convert.base64Decode(
    'ChBQYXBlclJlc3RyaWN0aW9uEhIKBGNvZGUYASABKAlSBGNvZGUSFgoGZGV0YWlsGAIgASgJUg'
    'ZkZXRhaWw=');

@$core.Deprecated('Use paperPlanDescriptor instead')
const PaperPlan$json = {
  '1': 'PaperPlan',
  '2': [
    {'1': 'plan_hash', '3': 1, '4': 1, '5': 9, '10': 'planHash'},
    {
      '1': 'account',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '10': 'account'
    },
    {'1': 'account_revision', '3': 3, '4': 1, '5': 3, '10': 'accountRevision'},
    {
      '1': 'risk_policy',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.RiskPolicyVersion',
      '10': 'riskPolicy'
    },
    {'1': 'opportunity_id', '3': 5, '4': 1, '5': 3, '10': 'opportunityId'},
    {
      '1': 'instrument',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.InstrumentKey',
      '10': 'instrument'
    },
    {'1': 'rule_version_id', '3': 7, '4': 1, '5': 3, '10': 'ruleVersionId'},
    {'1': 'report_id', '3': 8, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'snapshot_sha256', '3': 9, '4': 1, '5': 9, '10': 'snapshotSha256'},
    {'1': 'quoted_at_unix_ms', '3': 10, '4': 1, '5': 3, '10': 'quotedAtUnixMs'},
    {
      '1': 'expires_at_unix_ms',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'expiresAtUnixMs'
    },
    {
      '1': 'reference_price',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'referencePrice'
    },
    {
      '1': 'estimated_entry',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'estimatedEntry'
    },
    {
      '1': 'max_entry_price',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'maxEntryPrice'
    },
    {'1': 'stop', '3': 15, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'stop'},
    {
      '1': 'take_profit',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'takeProfit'
    },
    {
      '1': 'quantity',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'quantity'
    },
    {
      '1': 'notional',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'notional'
    },
    {
      '1': 'required_cash',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'requiredCash'
    },
    {
      '1': 'planned_loss',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'plannedLoss'
    },
    {
      '1': 'estimated_cost',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'estimatedCost'
    },
    {
      '1': 'fee_rate',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'feeRate'
    },
    {
      '1': 'slippage_rate',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'slippageRate'
    },
    {'1': 'fill_model', '3': 24, '4': 1, '5': 9, '10': 'fillModel'},
    {
      '1': 'reference_candle_closed_at_unix_ms',
      '3': 25,
      '4': 1,
      '5': 3,
      '10': 'referenceCandleClosedAtUnixMs'
    },
    {
      '1': 'reference_candle_revision',
      '3': 26,
      '4': 1,
      '5': 5,
      '10': 'referenceCandleRevision'
    },
  ],
};

/// Descriptor for `PaperPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperPlanDescriptor = $convert.base64Decode(
    'CglQYXBlclBsYW4SGwoJcGxhbl9oYXNoGAEgASgJUghwbGFuSGFzaBIsCgdhY2NvdW50GAIgAS'
    'gLMhIubGFiLnYxLkFjY291bnRSZWZSB2FjY291bnQSKQoQYWNjb3VudF9yZXZpc2lvbhgDIAEo'
    'A1IPYWNjb3VudFJldmlzaW9uEjoKC3Jpc2tfcG9saWN5GAQgASgLMhkubGFiLnYxLlJpc2tQb2'
    'xpY3lWZXJzaW9uUgpyaXNrUG9saWN5EiUKDm9wcG9ydHVuaXR5X2lkGAUgASgDUg1vcHBvcnR1'
    'bml0eUlkEjUKCmluc3RydW1lbnQYBiABKAsyFS5sYWIudjEuSW5zdHJ1bWVudEtleVIKaW5zdH'
    'J1bWVudBImCg9ydWxlX3ZlcnNpb25faWQYByABKANSDXJ1bGVWZXJzaW9uSWQSGwoJcmVwb3J0'
    'X2lkGAggASgJUghyZXBvcnRJZBInCg9zbmFwc2hvdF9zaGEyNTYYCSABKAlSDnNuYXBzaG90U2'
    'hhMjU2EikKEXF1b3RlZF9hdF91bml4X21zGAogASgDUg5xdW90ZWRBdFVuaXhNcxIrChJleHBp'
    'cmVzX2F0X3VuaXhfbXMYCyABKANSD2V4cGlyZXNBdFVuaXhNcxI2Cg9yZWZlcmVuY2VfcHJpY2'
    'UYDCABKAsyDS5sYWIudjEuTW9uZXlSDnJlZmVyZW5jZVByaWNlEjYKD2VzdGltYXRlZF9lbnRy'
    'eRgNIAEoCzINLmxhYi52MS5Nb25leVIOZXN0aW1hdGVkRW50cnkSNQoPbWF4X2VudHJ5X3ByaW'
    'NlGA4gASgLMg0ubGFiLnYxLk1vbmV5Ug1tYXhFbnRyeVByaWNlEiEKBHN0b3AYDyABKAsyDS5s'
    'YWIudjEuTW9uZXlSBHN0b3ASLgoLdGFrZV9wcm9maXQYECABKAsyDS5sYWIudjEuTW9uZXlSCn'
    'Rha2VQcm9maXQSKQoIcXVhbnRpdHkYESABKAsyDS5sYWIudjEuTW9uZXlSCHF1YW50aXR5EikK'
    'CG5vdGlvbmFsGBIgASgLMg0ubGFiLnYxLk1vbmV5Ughub3Rpb25hbBIyCg1yZXF1aXJlZF9jYX'
    'NoGBMgASgLMg0ubGFiLnYxLk1vbmV5UgxyZXF1aXJlZENhc2gSMAoMcGxhbm5lZF9sb3NzGBQg'
    'ASgLMg0ubGFiLnYxLk1vbmV5UgtwbGFubmVkTG9zcxI0Cg5lc3RpbWF0ZWRfY29zdBgVIAEoCz'
    'INLmxhYi52MS5Nb25leVINZXN0aW1hdGVkQ29zdBIqCghmZWVfcmF0ZRgWIAEoCzIPLmxhYi52'
    'MS5EZWNpbWFsUgdmZWVSYXRlEjQKDXNsaXBwYWdlX3JhdGUYFyABKAsyDy5sYWIudjEuRGVjaW'
    '1hbFIMc2xpcHBhZ2VSYXRlEh0KCmZpbGxfbW9kZWwYGCABKAlSCWZpbGxNb2RlbBJJCiJyZWZl'
    'cmVuY2VfY2FuZGxlX2Nsb3NlZF9hdF91bml4X21zGBkgASgDUh1yZWZlcmVuY2VDYW5kbGVDbG'
    '9zZWRBdFVuaXhNcxI6ChlyZWZlcmVuY2VfY2FuZGxlX3JldmlzaW9uGBogASgFUhdyZWZlcmVu'
    'Y2VDYW5kbGVSZXZpc2lvbg==');

const $core.Map<$core.String, $core.dynamic> PaperServiceBase$json = {
  '1': 'PaperService',
  '2': [
    {
      '1': 'GetPaperAccount',
      '2': '.lab.v1.GetPaperAccountRequest',
      '3': '.lab.v1.GetPaperAccountResponse'
    },
    {
      '1': 'InitializePaperAccount',
      '2': '.lab.v1.InitializePaperAccountRequest',
      '3': '.lab.v1.InitializePaperAccountResponse'
    },
    {
      '1': 'PreviewPaperPlan',
      '2': '.lab.v1.PreviewPaperPlanRequest',
      '3': '.lab.v1.PreviewPaperPlanResponse'
    },
    {
      '1': 'GetPaperPlan',
      '2': '.lab.v1.GetPaperPlanRequest',
      '3': '.lab.v1.GetPaperPlanResponse'
    },
  ],
};

@$core.Deprecated('Use paperServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    PaperServiceBase$messageJson = {
  '.lab.v1.GetPaperAccountRequest': GetPaperAccountRequest$json,
  '.lab.v1.GetPaperAccountResponse': GetPaperAccountResponse$json,
  '.lab.v1.PaperAccount': PaperAccount$json,
  '.lab.v1.AccountSnapshot': $1.AccountSnapshot$json,
  '.lab.v1.AccountRef': $2.AccountRef$json,
  '.lab.v1.MoneyReading': $1.MoneyReading$json,
  '.lab.v1.Money': $0.Money$json,
  '.lab.v1.UnavailableMoney': $1.UnavailableMoney$json,
  '.lab.v1.RiskPolicyVersion': $1.RiskPolicyVersion$json,
  '.lab.v1.Decimal': $0.Decimal$json,
  '.lab.v1.InitializePaperAccountRequest': InitializePaperAccountRequest$json,
  '.lab.v1.InitializePaperAccountResponse': InitializePaperAccountResponse$json,
  '.lab.v1.PreviewPaperPlanRequest': PreviewPaperPlanRequest$json,
  '.lab.v1.PreviewPaperPlanResponse': PreviewPaperPlanResponse$json,
  '.lab.v1.PaperPlan': PaperPlan$json,
  '.lab.v1.InstrumentKey': $2.InstrumentKey$json,
  '.lab.v1.PaperRestriction': PaperRestriction$json,
  '.lab.v1.GetPaperPlanRequest': GetPaperPlanRequest$json,
  '.lab.v1.GetPaperPlanResponse': GetPaperPlanResponse$json,
};

/// Descriptor for `PaperService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List paperServiceDescriptor = $convert.base64Decode(
    'CgxQYXBlclNlcnZpY2USUgoPR2V0UGFwZXJBY2NvdW50Eh4ubGFiLnYxLkdldFBhcGVyQWNjb3'
    'VudFJlcXVlc3QaHy5sYWIudjEuR2V0UGFwZXJBY2NvdW50UmVzcG9uc2USZwoWSW5pdGlhbGl6'
    'ZVBhcGVyQWNjb3VudBIlLmxhYi52MS5Jbml0aWFsaXplUGFwZXJBY2NvdW50UmVxdWVzdBomLm'
    'xhYi52MS5Jbml0aWFsaXplUGFwZXJBY2NvdW50UmVzcG9uc2USVQoQUHJldmlld1BhcGVyUGxh'
    'bhIfLmxhYi52MS5QcmV2aWV3UGFwZXJQbGFuUmVxdWVzdBogLmxhYi52MS5QcmV2aWV3UGFwZX'
    'JQbGFuUmVzcG9uc2USSQoMR2V0UGFwZXJQbGFuEhsubGFiLnYxLkdldFBhcGVyUGxhblJlcXVl'
    'c3QaHC5sYWIudjEuR2V0UGFwZXJQbGFuUmVzcG9uc2U=');
