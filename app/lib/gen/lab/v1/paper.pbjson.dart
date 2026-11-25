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

@$core.Deprecated('Use paperReductionStateDescriptor instead')
const PaperReductionState$json = {
  '1': 'PaperReductionState',
  '2': [
    {'1': 'PAPER_REDUCTION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PAPER_REDUCTION_STATE_PENDING', '2': 1},
    {'1': 'PAPER_REDUCTION_STATE_FILLED', '2': 2},
    {'1': 'PAPER_REDUCTION_STATE_SUPERSEDED', '2': 3},
  ],
};

/// Descriptor for `PaperReductionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List paperReductionStateDescriptor = $convert.base64Decode(
    'ChNQYXBlclJlZHVjdGlvblN0YXRlEiUKIVBBUEVSX1JFRFVDVElPTl9TVEFURV9VTlNQRUNJRk'
    'lFRBAAEiEKHVBBUEVSX1JFRFVDVElPTl9TVEFURV9QRU5ESU5HEAESIAocUEFQRVJfUkVEVUNU'
    'SU9OX1NUQVRFX0ZJTExFRBACEiQKIFBBUEVSX1JFRFVDVElPTl9TVEFURV9TVVBFUlNFREVEEA'
    'M=');

@$core.Deprecated('Use paperEntryStateDescriptor instead')
const PaperEntryState$json = {
  '1': 'PaperEntryState',
  '2': [
    {'1': 'PAPER_ENTRY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PAPER_ENTRY_STATE_PENDING', '2': 1},
    {'1': 'PAPER_ENTRY_STATE_PARTIAL', '2': 2},
    {'1': 'PAPER_ENTRY_STATE_FILLED', '2': 3},
    {'1': 'PAPER_ENTRY_STATE_CANCELLED', '2': 4},
    {'1': 'PAPER_ENTRY_STATE_EXPIRED', '2': 5},
  ],
};

/// Descriptor for `PaperEntryState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List paperEntryStateDescriptor = $convert.base64Decode(
    'Cg9QYXBlckVudHJ5U3RhdGUSIQodUEFQRVJfRU5UUllfU1RBVEVfVU5TUEVDSUZJRUQQABIdCh'
    'lQQVBFUl9FTlRSWV9TVEFURV9QRU5ESU5HEAESHQoZUEFQRVJfRU5UUllfU1RBVEVfUEFSVElB'
    'TBACEhwKGFBBUEVSX0VOVFJZX1NUQVRFX0ZJTExFRBADEh8KG1BBUEVSX0VOVFJZX1NUQVRFX0'
    'NBTkNFTExFRBAEEh0KGVBBUEVSX0VOVFJZX1NUQVRFX0VYUElSRUQQBQ==');

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
    {
      '1': 'recent_receipts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.PaperReceipt',
      '10': 'recentReceipts'
    },
    {
      '1': 'positions',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.PaperPosition',
      '10': 'positions'
    },
    {
      '1': 'reconciliation',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReconciliation',
      '10': 'reconciliation'
    },
  ],
};

/// Descriptor for `GetPaperAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaperAccountResponseDescriptor = $convert.base64Decode(
    'ChdHZXRQYXBlckFjY291bnRSZXNwb25zZRI5Cg1wYXBlcl9hY2NvdW50GAEgASgLMhQubGFiLn'
    'YxLlBhcGVyQWNjb3VudFIMcGFwZXJBY2NvdW50Ej0KD3JlY2VudF9yZWNlaXB0cxgCIAMoCzIU'
    'LmxhYi52MS5QYXBlclJlY2VpcHRSDnJlY2VudFJlY2VpcHRzEjMKCXBvc2l0aW9ucxgDIAMoCz'
    'IVLmxhYi52MS5QYXBlclBvc2l0aW9uUglwb3NpdGlvbnMSQwoOcmVjb25jaWxpYXRpb24YBCAB'
    'KAsyGy5sYWIudjEuUGFwZXJSZWNvbmNpbGlhdGlvblIOcmVjb25jaWxpYXRpb24=');

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
    {'1': 'entries_paused', '3': 9, '4': 1, '5': 8, '10': 'entriesPaused'},
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
    'ZVJhdGUSJQoOZW50cmllc19wYXVzZWQYCSABKAhSDWVudHJpZXNQYXVzZWQ=');

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
    {
      '1': 'receipt',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReceipt',
      '10': 'receipt'
    },
  ],
};

/// Descriptor for `GetPaperPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaperPlanResponseDescriptor = $convert.base64Decode(
    'ChRHZXRQYXBlclBsYW5SZXNwb25zZRIlCgRwbGFuGAEgASgLMhEubGFiLnYxLlBhcGVyUGxhbl'
    'IEcGxhbhI6CgtyZXN0cmljdGlvbhgCIAEoCzIYLmxhYi52MS5QYXBlclJlc3RyaWN0aW9uUgty'
    'ZXN0cmljdGlvbhIuCgdyZWNlaXB0GAMgASgLMhQubGFiLnYxLlBhcGVyUmVjZWlwdFIHcmVjZW'
    'lwdA==');

@$core.Deprecated('Use confirmPaperPlanRequestDescriptor instead')
const ConfirmPaperPlanRequest$json = {
  '1': 'ConfirmPaperPlanRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '10': 'account'
    },
    {'1': 'plan_hash', '3': 2, '4': 1, '5': 9, '10': 'planHash'},
  ],
};

/// Descriptor for `ConfirmPaperPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmPaperPlanRequestDescriptor =
    $convert.base64Decode(
        'ChdDb25maXJtUGFwZXJQbGFuUmVxdWVzdBIsCgdhY2NvdW50GAEgASgLMhIubGFiLnYxLkFjY2'
        '91bnRSZWZSB2FjY291bnQSGwoJcGxhbl9oYXNoGAIgASgJUghwbGFuSGFzaA==');

@$core.Deprecated('Use confirmPaperPlanResponseDescriptor instead')
const ConfirmPaperPlanResponse$json = {
  '1': 'ConfirmPaperPlanResponse',
  '2': [
    {
      '1': 'receipt',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReceipt',
      '10': 'receipt'
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

/// Descriptor for `ConfirmPaperPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmPaperPlanResponseDescriptor = $convert.base64Decode(
    'ChhDb25maXJtUGFwZXJQbGFuUmVzcG9uc2USLgoHcmVjZWlwdBgBIAEoCzIULmxhYi52MS5QYX'
    'BlclJlY2VpcHRSB3JlY2VpcHQSOgoLcmVzdHJpY3Rpb24YAiABKAsyGC5sYWIudjEuUGFwZXJS'
    'ZXN0cmljdGlvblILcmVzdHJpY3Rpb24=');

@$core.Deprecated('Use getPaperReceiptRequestDescriptor instead')
const GetPaperReceiptRequest$json = {
  '1': 'GetPaperReceiptRequest',
  '2': [
    {'1': 'receipt_id', '3': 1, '4': 1, '5': 3, '10': 'receiptId'},
  ],
};

/// Descriptor for `GetPaperReceiptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaperReceiptRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRQYXBlclJlY2VpcHRSZXF1ZXN0Eh0KCnJlY2VpcHRfaWQYASABKANSCXJlY2VpcHRJZA'
        '==');

@$core.Deprecated('Use getPaperReceiptResponseDescriptor instead')
const GetPaperReceiptResponse$json = {
  '1': 'GetPaperReceiptResponse',
  '2': [
    {
      '1': 'receipt',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReceipt',
      '10': 'receipt'
    },
    {
      '1': 'events',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.PaperExecutionEvent',
      '10': 'events'
    },
    {
      '1': 'reduction',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReduction',
      '10': 'reduction'
    },
  ],
};

/// Descriptor for `GetPaperReceiptResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaperReceiptResponseDescriptor = $convert.base64Decode(
    'ChdHZXRQYXBlclJlY2VpcHRSZXNwb25zZRIuCgdyZWNlaXB0GAEgASgLMhQubGFiLnYxLlBhcG'
    'VyUmVjZWlwdFIHcmVjZWlwdBIzCgZldmVudHMYAiADKAsyGy5sYWIudjEuUGFwZXJFeGVjdXRp'
    'b25FdmVudFIGZXZlbnRzEjQKCXJlZHVjdGlvbhgDIAEoCzIWLmxhYi52MS5QYXBlclJlZHVjdG'
    'lvblIJcmVkdWN0aW9u');

@$core.Deprecated('Use listPaperJournalRequestDescriptor instead')
const ListPaperJournalRequest$json = {
  '1': 'ListPaperJournalRequest',
  '2': [
    {'1': 'before_receipt_id', '3': 1, '4': 1, '5': 3, '10': 'beforeReceiptId'},
  ],
};

/// Descriptor for `ListPaperJournalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPaperJournalRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UGFwZXJKb3VybmFsUmVxdWVzdBIqChFiZWZvcmVfcmVjZWlwdF9pZBgBIAEoA1IPYm'
        'Vmb3JlUmVjZWlwdElk');

@$core.Deprecated('Use listPaperJournalResponseDescriptor instead')
const ListPaperJournalResponse$json = {
  '1': 'ListPaperJournalResponse',
  '2': [
    {
      '1': 'trades',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.PaperJournalTrade',
      '10': 'trades'
    },
    {
      '1': 'next_before_receipt_id',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'nextBeforeReceiptId'
    },
  ],
};

/// Descriptor for `ListPaperJournalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPaperJournalResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0UGFwZXJKb3VybmFsUmVzcG9uc2USMQoGdHJhZGVzGAEgAygLMhkubGFiLnYxLlBhcG'
    'VySm91cm5hbFRyYWRlUgZ0cmFkZXMSMwoWbmV4dF9iZWZvcmVfcmVjZWlwdF9pZBgCIAEoA1IT'
    'bmV4dEJlZm9yZVJlY2VpcHRJZA==');

@$core.Deprecated('Use paperJournalTradeDescriptor instead')
const PaperJournalTrade$json = {
  '1': 'PaperJournalTrade',
  '2': [
    {
      '1': 'receipt',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReceipt',
      '10': 'receipt'
    },
    {
      '1': 'open_quantity',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'openQuantity'
    },
    {
      '1': 'fees_paid',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'feesPaid'
    },
    {
      '1': 'realized_pnl',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'realizedPnl'
    },
  ],
};

/// Descriptor for `PaperJournalTrade`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperJournalTradeDescriptor = $convert.base64Decode(
    'ChFQYXBlckpvdXJuYWxUcmFkZRIuCgdyZWNlaXB0GAEgASgLMhQubGFiLnYxLlBhcGVyUmVjZW'
    'lwdFIHcmVjZWlwdBIyCg1vcGVuX3F1YW50aXR5GAIgASgLMg0ubGFiLnYxLk1vbmV5UgxvcGVu'
    'UXVhbnRpdHkSKgoJZmVlc19wYWlkGAMgASgLMg0ubGFiLnYxLk1vbmV5UghmZWVzUGFpZBIwCg'
    'xyZWFsaXplZF9wbmwYBCABKAsyDS5sYWIudjEuTW9uZXlSC3JlYWxpemVkUG5s');

@$core.Deprecated('Use cancelPaperEntryRequestDescriptor instead')
const CancelPaperEntryRequest$json = {
  '1': 'CancelPaperEntryRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '10': 'account'
    },
    {'1': 'receipt_id', '3': 2, '4': 1, '5': 3, '10': 'receiptId'},
  ],
};

/// Descriptor for `CancelPaperEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelPaperEntryRequestDescriptor =
    $convert.base64Decode(
        'ChdDYW5jZWxQYXBlckVudHJ5UmVxdWVzdBIsCgdhY2NvdW50GAEgASgLMhIubGFiLnYxLkFjY2'
        '91bnRSZWZSB2FjY291bnQSHQoKcmVjZWlwdF9pZBgCIAEoA1IJcmVjZWlwdElk');

@$core.Deprecated('Use cancelPaperEntryResponseDescriptor instead')
const CancelPaperEntryResponse$json = {
  '1': 'CancelPaperEntryResponse',
  '2': [
    {
      '1': 'receipt',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReceipt',
      '10': 'receipt'
    },
  ],
};

/// Descriptor for `CancelPaperEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelPaperEntryResponseDescriptor =
    $convert.base64Decode(
        'ChhDYW5jZWxQYXBlckVudHJ5UmVzcG9uc2USLgoHcmVjZWlwdBgBIAEoCzIULmxhYi52MS5QYX'
        'BlclJlY2VpcHRSB3JlY2VpcHQ=');

@$core.Deprecated('Use reducePaperPositionRequestDescriptor instead')
const ReducePaperPositionRequest$json = {
  '1': 'ReducePaperPositionRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '10': 'account'
    },
    {'1': 'receipt_id', '3': 2, '4': 1, '5': 3, '10': 'receiptId'},
    {
      '1': 'position_revision',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'positionRevision'
    },
    {
      '1': 'quantity',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'quantity'
    },
  ],
};

/// Descriptor for `ReducePaperPositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reducePaperPositionRequestDescriptor = $convert.base64Decode(
    'ChpSZWR1Y2VQYXBlclBvc2l0aW9uUmVxdWVzdBIsCgdhY2NvdW50GAEgASgLMhIubGFiLnYxLk'
    'FjY291bnRSZWZSB2FjY291bnQSHQoKcmVjZWlwdF9pZBgCIAEoA1IJcmVjZWlwdElkEisKEXBv'
    'c2l0aW9uX3JldmlzaW9uGAMgASgDUhBwb3NpdGlvblJldmlzaW9uEikKCHF1YW50aXR5GAQgAS'
    'gLMg0ubGFiLnYxLk1vbmV5UghxdWFudGl0eQ==');

@$core.Deprecated('Use reducePaperPositionResponseDescriptor instead')
const ReducePaperPositionResponse$json = {
  '1': 'ReducePaperPositionResponse',
  '2': [
    {
      '1': 'reduction',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReduction',
      '10': 'reduction'
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

/// Descriptor for `ReducePaperPositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reducePaperPositionResponseDescriptor =
    $convert.base64Decode(
        'ChtSZWR1Y2VQYXBlclBvc2l0aW9uUmVzcG9uc2USNAoJcmVkdWN0aW9uGAEgASgLMhYubGFiLn'
        'YxLlBhcGVyUmVkdWN0aW9uUglyZWR1Y3Rpb24SOgoLcmVzdHJpY3Rpb24YAiABKAsyGC5sYWIu'
        'djEuUGFwZXJSZXN0cmljdGlvblILcmVzdHJpY3Rpb24=');

@$core.Deprecated('Use paperReductionDescriptor instead')
const PaperReduction$json = {
  '1': 'PaperReduction',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'receipt_id', '3': 2, '4': 1, '5': 3, '10': 'receiptId'},
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.PaperReductionState',
      '10': 'state'
    },
    {
      '1': 'quantity',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'quantity'
    },
    {
      '1': 'requested_at_unix_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'requestedAtUnixMs'
    },
    {
      '1': 'result_event_id',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'resultEventId',
      '17': true
    },
  ],
  '8': [
    {'1': '_result_event_id'},
  ],
};

/// Descriptor for `PaperReduction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperReductionDescriptor = $convert.base64Decode(
    'Cg5QYXBlclJlZHVjdGlvbhIOCgJpZBgBIAEoA1ICaWQSHQoKcmVjZWlwdF9pZBgCIAEoA1IJcm'
    'VjZWlwdElkEjEKBXN0YXRlGAMgASgOMhsubGFiLnYxLlBhcGVyUmVkdWN0aW9uU3RhdGVSBXN0'
    'YXRlEikKCHF1YW50aXR5GAQgASgLMg0ubGFiLnYxLk1vbmV5UghxdWFudGl0eRIvChRyZXF1ZX'
    'N0ZWRfYXRfdW5peF9tcxgFIAEoA1IRcmVxdWVzdGVkQXRVbml4TXMSKwoPcmVzdWx0X2V2ZW50'
    'X2lkGAYgASgDSABSDXJlc3VsdEV2ZW50SWSIAQFCEgoQX3Jlc3VsdF9ldmVudF9pZA==');

@$core.Deprecated('Use paperReconciliationDescriptor instead')
const PaperReconciliation$json = {
  '1': 'PaperReconciliation',
  '2': [
    {
      '1': 'checked_at_unix_ms',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'checkedAtUnixMs'
    },
    {'1': 'last_event_id', '3': 2, '4': 1, '5': 3, '10': 'lastEventId'},
    {'1': 'cash_matches', '3': 3, '4': 1, '5': 8, '10': 'cashMatches'},
    {
      '1': 'reservations_match',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'reservationsMatch'
    },
    {'1': 'positions_match', '3': 5, '4': 1, '5': 8, '10': 'positionsMatch'},
    {'1': 'events_match', '3': 6, '4': 1, '5': 8, '10': 'eventsMatch'},
  ],
};

/// Descriptor for `PaperReconciliation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperReconciliationDescriptor = $convert.base64Decode(
    'ChNQYXBlclJlY29uY2lsaWF0aW9uEisKEmNoZWNrZWRfYXRfdW5peF9tcxgBIAEoA1IPY2hlY2'
    'tlZEF0VW5peE1zEiIKDWxhc3RfZXZlbnRfaWQYAiABKANSC2xhc3RFdmVudElkEiEKDGNhc2hf'
    'bWF0Y2hlcxgDIAEoCFILY2FzaE1hdGNoZXMSLQoScmVzZXJ2YXRpb25zX21hdGNoGAQgASgIUh'
    'FyZXNlcnZhdGlvbnNNYXRjaBInCg9wb3NpdGlvbnNfbWF0Y2gYBSABKAhSDnBvc2l0aW9uc01h'
    'dGNoEiEKDGV2ZW50c19tYXRjaBgGIAEoCFILZXZlbnRzTWF0Y2g=');

@$core.Deprecated('Use setPaperEntryPauseRequestDescriptor instead')
const SetPaperEntryPauseRequest$json = {
  '1': 'SetPaperEntryPauseRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '10': 'account'
    },
    {'1': 'paused', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'paused', '17': true},
  ],
  '8': [
    {'1': '_paused'},
  ],
};

/// Descriptor for `SetPaperEntryPauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPaperEntryPauseRequestDescriptor = $convert.base64Decode(
    'ChlTZXRQYXBlckVudHJ5UGF1c2VSZXF1ZXN0EiwKB2FjY291bnQYASABKAsyEi5sYWIudjEuQW'
    'Njb3VudFJlZlIHYWNjb3VudBIbCgZwYXVzZWQYAiABKAhIAFIGcGF1c2VkiAEBQgkKB19wYXVz'
    'ZWQ=');

@$core.Deprecated('Use setPaperEntryPauseResponseDescriptor instead')
const SetPaperEntryPauseResponse$json = {
  '1': 'SetPaperEntryPauseResponse',
  '2': [
    {'1': 'paused', '3': 1, '4': 1, '5': 8, '10': 'paused'},
  ],
};

/// Descriptor for `SetPaperEntryPauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setPaperEntryPauseResponseDescriptor =
    $convert.base64Decode(
        'ChpTZXRQYXBlckVudHJ5UGF1c2VSZXNwb25zZRIWCgZwYXVzZWQYASABKAhSBnBhdXNlZA==');

@$core.Deprecated('Use paperReceiptDescriptor instead')
const PaperReceipt$json = {
  '1': 'PaperReceipt',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {
      '1': 'account',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '10': 'account'
    },
    {'1': 'plan_hash', '3': 3, '4': 1, '5': 9, '10': 'planHash'},
    {'1': 'symbol', '3': 4, '4': 1, '5': 9, '10': 'symbol'},
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.PaperEntryState',
      '10': 'state'
    },
    {
      '1': 'requested_quantity',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'requestedQuantity'
    },
    {
      '1': 'filled_quantity',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'filledQuantity'
    },
    {
      '1': 'reserved_cash',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'reservedCash'
    },
    {
      '1': 'confirmed_at_unix_ms',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'confirmedAtUnixMs'
    },
    {
      '1': 'expires_at_unix_ms',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'expiresAtUnixMs'
    },
  ],
};

/// Descriptor for `PaperReceipt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperReceiptDescriptor = $convert.base64Decode(
    'CgxQYXBlclJlY2VpcHQSDgoCaWQYASABKANSAmlkEiwKB2FjY291bnQYAiABKAsyEi5sYWIudj'
    'EuQWNjb3VudFJlZlIHYWNjb3VudBIbCglwbGFuX2hhc2gYAyABKAlSCHBsYW5IYXNoEhYKBnN5'
    'bWJvbBgEIAEoCVIGc3ltYm9sEi0KBXN0YXRlGAUgASgOMhcubGFiLnYxLlBhcGVyRW50cnlTdG'
    'F0ZVIFc3RhdGUSPAoScmVxdWVzdGVkX3F1YW50aXR5GAYgASgLMg0ubGFiLnYxLk1vbmV5UhFy'
    'ZXF1ZXN0ZWRRdWFudGl0eRI2Cg9maWxsZWRfcXVhbnRpdHkYByABKAsyDS5sYWIudjEuTW9uZX'
    'lSDmZpbGxlZFF1YW50aXR5EjIKDXJlc2VydmVkX2Nhc2gYCCABKAsyDS5sYWIudjEuTW9uZXlS'
    'DHJlc2VydmVkQ2FzaBIvChRjb25maXJtZWRfYXRfdW5peF9tcxgJIAEoA1IRY29uZmlybWVkQX'
    'RVbml4TXMSKwoSZXhwaXJlc19hdF91bml4X21zGAogASgDUg9leHBpcmVzQXRVbml4TXM=');

@$core.Deprecated('Use paperPositionDescriptor instead')
const PaperPosition$json = {
  '1': 'PaperPosition',
  '2': [
    {'1': 'receipt_id', '3': 1, '4': 1, '5': 3, '10': 'receiptId'},
    {'1': 'symbol', '3': 2, '4': 1, '5': 9, '10': 'symbol'},
    {
      '1': 'quantity',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'quantity'
    },
    {
      '1': 'cost_basis',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'costBasis'
    },
    {
      '1': 'market_value',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.MoneyReading',
      '10': 'marketValue'
    },
    {'1': 'revision', '3': 6, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'lot', '3': 7, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'lot'},
    {
      '1': 'pending_reduction',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReduction',
      '10': 'pendingReduction'
    },
  ],
};

/// Descriptor for `PaperPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperPositionDescriptor = $convert.base64Decode(
    'Cg1QYXBlclBvc2l0aW9uEh0KCnJlY2VpcHRfaWQYASABKANSCXJlY2VpcHRJZBIWCgZzeW1ib2'
    'wYAiABKAlSBnN5bWJvbBIpCghxdWFudGl0eRgDIAEoCzINLmxhYi52MS5Nb25leVIIcXVhbnRp'
    'dHkSLAoKY29zdF9iYXNpcxgEIAEoCzINLmxhYi52MS5Nb25leVIJY29zdEJhc2lzEjcKDG1hcm'
    'tldF92YWx1ZRgFIAEoCzIULmxhYi52MS5Nb25leVJlYWRpbmdSC21hcmtldFZhbHVlEhoKCHJl'
    'dmlzaW9uGAYgASgDUghyZXZpc2lvbhIfCgNsb3QYByABKAsyDS5sYWIudjEuTW9uZXlSA2xvdB'
    'JDChFwZW5kaW5nX3JlZHVjdGlvbhgIIAEoCzIWLmxhYi52MS5QYXBlclJlZHVjdGlvblIQcGVu'
    'ZGluZ1JlZHVjdGlvbg==');

@$core.Deprecated('Use paperExecutionEventDescriptor instead')
const PaperExecutionEvent$json = {
  '1': 'PaperExecutionEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {
      '1': 'recorded_at_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'recordedAtUnixMs'
    },
    {
      '1': 'quantity',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'quantity'
    },
    {
      '1': 'reference_price',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'referencePrice'
    },
    {
      '1': 'fill_price',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'fillPrice'
    },
    {'1': 'fee', '3': 7, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'fee'},
    {'1': 'cash', '3': 8, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'cash'},
    {
      '1': 'candle_opened_at_unix_ms',
      '3': 9,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'candleOpenedAtUnixMs',
      '17': true
    },
    {'1': 'candle_revision', '3': 10, '4': 1, '5': 5, '10': 'candleRevision'},
    {
      '1': 'realized_pnl',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'realizedPnl'
    },
  ],
  '8': [
    {'1': '_candle_opened_at_unix_ms'},
  ],
};

/// Descriptor for `PaperExecutionEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paperExecutionEventDescriptor = $convert.base64Decode(
    'ChNQYXBlckV4ZWN1dGlvbkV2ZW50Eg4KAmlkGAEgASgDUgJpZBISCgRraW5kGAIgASgJUgRraW'
    '5kEi0KE3JlY29yZGVkX2F0X3VuaXhfbXMYAyABKANSEHJlY29yZGVkQXRVbml4TXMSKQoIcXVh'
    'bnRpdHkYBCABKAsyDS5sYWIudjEuTW9uZXlSCHF1YW50aXR5EjYKD3JlZmVyZW5jZV9wcmljZR'
    'gFIAEoCzINLmxhYi52MS5Nb25leVIOcmVmZXJlbmNlUHJpY2USLAoKZmlsbF9wcmljZRgGIAEo'
    'CzINLmxhYi52MS5Nb25leVIJZmlsbFByaWNlEh8KA2ZlZRgHIAEoCzINLmxhYi52MS5Nb25leV'
    'IDZmVlEiEKBGNhc2gYCCABKAsyDS5sYWIudjEuTW9uZXlSBGNhc2gSOwoYY2FuZGxlX29wZW5l'
    'ZF9hdF91bml4X21zGAkgASgDSABSFGNhbmRsZU9wZW5lZEF0VW5peE1ziAEBEicKD2NhbmRsZV'
    '9yZXZpc2lvbhgKIAEoBVIOY2FuZGxlUmV2aXNpb24SMAoMcmVhbGl6ZWRfcG5sGAsgASgLMg0u'
    'bGFiLnYxLk1vbmV5UgtyZWFsaXplZFBubEIbChlfY2FuZGxlX29wZW5lZF9hdF91bml4X21z');

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
    {
      '1': 'ConfirmPaperPlan',
      '2': '.lab.v1.ConfirmPaperPlanRequest',
      '3': '.lab.v1.ConfirmPaperPlanResponse'
    },
    {
      '1': 'GetPaperReceipt',
      '2': '.lab.v1.GetPaperReceiptRequest',
      '3': '.lab.v1.GetPaperReceiptResponse'
    },
    {
      '1': 'ListPaperJournal',
      '2': '.lab.v1.ListPaperJournalRequest',
      '3': '.lab.v1.ListPaperJournalResponse'
    },
    {
      '1': 'CancelPaperEntry',
      '2': '.lab.v1.CancelPaperEntryRequest',
      '3': '.lab.v1.CancelPaperEntryResponse'
    },
    {
      '1': 'ReducePaperPosition',
      '2': '.lab.v1.ReducePaperPositionRequest',
      '3': '.lab.v1.ReducePaperPositionResponse'
    },
    {
      '1': 'SetPaperEntryPause',
      '2': '.lab.v1.SetPaperEntryPauseRequest',
      '3': '.lab.v1.SetPaperEntryPauseResponse'
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
  '.lab.v1.PaperReceipt': PaperReceipt$json,
  '.lab.v1.PaperPosition': PaperPosition$json,
  '.lab.v1.PaperReduction': PaperReduction$json,
  '.lab.v1.PaperReconciliation': PaperReconciliation$json,
  '.lab.v1.InitializePaperAccountRequest': InitializePaperAccountRequest$json,
  '.lab.v1.InitializePaperAccountResponse': InitializePaperAccountResponse$json,
  '.lab.v1.PreviewPaperPlanRequest': PreviewPaperPlanRequest$json,
  '.lab.v1.PreviewPaperPlanResponse': PreviewPaperPlanResponse$json,
  '.lab.v1.PaperPlan': PaperPlan$json,
  '.lab.v1.InstrumentKey': $2.InstrumentKey$json,
  '.lab.v1.PaperRestriction': PaperRestriction$json,
  '.lab.v1.GetPaperPlanRequest': GetPaperPlanRequest$json,
  '.lab.v1.GetPaperPlanResponse': GetPaperPlanResponse$json,
  '.lab.v1.ConfirmPaperPlanRequest': ConfirmPaperPlanRequest$json,
  '.lab.v1.ConfirmPaperPlanResponse': ConfirmPaperPlanResponse$json,
  '.lab.v1.GetPaperReceiptRequest': GetPaperReceiptRequest$json,
  '.lab.v1.GetPaperReceiptResponse': GetPaperReceiptResponse$json,
  '.lab.v1.PaperExecutionEvent': PaperExecutionEvent$json,
  '.lab.v1.ListPaperJournalRequest': ListPaperJournalRequest$json,
  '.lab.v1.ListPaperJournalResponse': ListPaperJournalResponse$json,
  '.lab.v1.PaperJournalTrade': PaperJournalTrade$json,
  '.lab.v1.CancelPaperEntryRequest': CancelPaperEntryRequest$json,
  '.lab.v1.CancelPaperEntryResponse': CancelPaperEntryResponse$json,
  '.lab.v1.ReducePaperPositionRequest': ReducePaperPositionRequest$json,
  '.lab.v1.ReducePaperPositionResponse': ReducePaperPositionResponse$json,
  '.lab.v1.SetPaperEntryPauseRequest': SetPaperEntryPauseRequest$json,
  '.lab.v1.SetPaperEntryPauseResponse': SetPaperEntryPauseResponse$json,
};

/// Descriptor for `PaperService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List paperServiceDescriptor = $convert.base64Decode(
    'CgxQYXBlclNlcnZpY2USUgoPR2V0UGFwZXJBY2NvdW50Eh4ubGFiLnYxLkdldFBhcGVyQWNjb3'
    'VudFJlcXVlc3QaHy5sYWIudjEuR2V0UGFwZXJBY2NvdW50UmVzcG9uc2USZwoWSW5pdGlhbGl6'
    'ZVBhcGVyQWNjb3VudBIlLmxhYi52MS5Jbml0aWFsaXplUGFwZXJBY2NvdW50UmVxdWVzdBomLm'
    'xhYi52MS5Jbml0aWFsaXplUGFwZXJBY2NvdW50UmVzcG9uc2USVQoQUHJldmlld1BhcGVyUGxh'
    'bhIfLmxhYi52MS5QcmV2aWV3UGFwZXJQbGFuUmVxdWVzdBogLmxhYi52MS5QcmV2aWV3UGFwZX'
    'JQbGFuUmVzcG9uc2USSQoMR2V0UGFwZXJQbGFuEhsubGFiLnYxLkdldFBhcGVyUGxhblJlcXVl'
    'c3QaHC5sYWIudjEuR2V0UGFwZXJQbGFuUmVzcG9uc2USVQoQQ29uZmlybVBhcGVyUGxhbhIfLm'
    'xhYi52MS5Db25maXJtUGFwZXJQbGFuUmVxdWVzdBogLmxhYi52MS5Db25maXJtUGFwZXJQbGFu'
    'UmVzcG9uc2USUgoPR2V0UGFwZXJSZWNlaXB0Eh4ubGFiLnYxLkdldFBhcGVyUmVjZWlwdFJlcX'
    'Vlc3QaHy5sYWIudjEuR2V0UGFwZXJSZWNlaXB0UmVzcG9uc2USVQoQTGlzdFBhcGVySm91cm5h'
    'bBIfLmxhYi52MS5MaXN0UGFwZXJKb3VybmFsUmVxdWVzdBogLmxhYi52MS5MaXN0UGFwZXJKb3'
    'VybmFsUmVzcG9uc2USVQoQQ2FuY2VsUGFwZXJFbnRyeRIfLmxhYi52MS5DYW5jZWxQYXBlckVu'
    'dHJ5UmVxdWVzdBogLmxhYi52MS5DYW5jZWxQYXBlckVudHJ5UmVzcG9uc2USXgoTUmVkdWNlUG'
    'FwZXJQb3NpdGlvbhIiLmxhYi52MS5SZWR1Y2VQYXBlclBvc2l0aW9uUmVxdWVzdBojLmxhYi52'
    'MS5SZWR1Y2VQYXBlclBvc2l0aW9uUmVzcG9uc2USWwoSU2V0UGFwZXJFbnRyeVBhdXNlEiEubG'
    'FiLnYxLlNldFBhcGVyRW50cnlQYXVzZVJlcXVlc3QaIi5sYWIudjEuU2V0UGFwZXJFbnRyeVBh'
    'dXNlUmVzcG9uc2U=');
