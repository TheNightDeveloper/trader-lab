// This is a generated file - do not edit.
//
// Generated from lab/v1/account.proto.

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

@$core.Deprecated('Use moneyAvailabilityDescriptor instead')
const MoneyAvailability$json = {
  '1': 'MoneyAvailability',
  '2': [
    {'1': 'MONEY_AVAILABILITY_UNSPECIFIED', '2': 0},
    {'1': 'MONEY_AVAILABILITY_MISSING', '2': 1},
    {'1': 'MONEY_AVAILABILITY_INVALID', '2': 2},
    {'1': 'MONEY_AVAILABILITY_STALE', '2': 3},
  ],
};

/// Descriptor for `MoneyAvailability`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List moneyAvailabilityDescriptor = $convert.base64Decode(
    'ChFNb25leUF2YWlsYWJpbGl0eRIiCh5NT05FWV9BVkFJTEFCSUxJVFlfVU5TUEVDSUZJRUQQAB'
    'IeChpNT05FWV9BVkFJTEFCSUxJVFlfTUlTU0lORxABEh4KGk1PTkVZX0FWQUlMQUJJTElUWV9J'
    'TlZBTElEEAISHAoYTU9ORVlfQVZBSUxBQklMSVRZX1NUQUxFEAM=');

@$core.Deprecated('Use moneyReadingDescriptor instead')
const MoneyReading$json = {
  '1': 'MoneyReading',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '9': 0,
      '10': 'value'
    },
    {
      '1': 'unavailable',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.UnavailableMoney',
      '9': 0,
      '10': 'unavailable'
    },
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `MoneyReading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moneyReadingDescriptor = $convert.base64Decode(
    'CgxNb25leVJlYWRpbmcSJQoFdmFsdWUYASABKAsyDS5sYWIudjEuTW9uZXlIAFIFdmFsdWUSPA'
    'oLdW5hdmFpbGFibGUYAiABKAsyGC5sYWIudjEuVW5hdmFpbGFibGVNb25leUgAUgt1bmF2YWls'
    'YWJsZUIICgZyZXN1bHQ=');

@$core.Deprecated('Use unavailableMoneyDescriptor instead')
const UnavailableMoney$json = {
  '1': 'UnavailableMoney',
  '2': [
    {
      '1': 'reason',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.MoneyAvailability',
      '10': 'reason'
    },
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `UnavailableMoney`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unavailableMoneyDescriptor = $convert.base64Decode(
    'ChBVbmF2YWlsYWJsZU1vbmV5EjEKBnJlYXNvbhgBIAEoDjIZLmxhYi52MS5Nb25leUF2YWlsYW'
    'JpbGl0eVIGcmVhc29uEhYKBmRldGFpbBgCIAEoCVIGZGV0YWls');

@$core.Deprecated('Use riskPolicyVersionDescriptor instead')
const RiskPolicyVersion$json = {
  '1': 'RiskPolicyVersion',
  '2': [
    {'1': 'policy_id', '3': 1, '4': 1, '5': 9, '10': 'policyId'},
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'effective_from_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'effectiveFromUnixMs'
    },
  ],
};

/// Descriptor for `RiskPolicyVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List riskPolicyVersionDescriptor = $convert.base64Decode(
    'ChFSaXNrUG9saWN5VmVyc2lvbhIbCglwb2xpY3lfaWQYASABKAlSCHBvbGljeUlkEhoKCHJldm'
    'lzaW9uGAIgASgDUghyZXZpc2lvbhIzChZlZmZlY3RpdmVfZnJvbV91bml4X21zGAMgASgDUhNl'
    'ZmZlY3RpdmVGcm9tVW5peE1z');

@$core.Deprecated('Use accountSnapshotDescriptor instead')
const AccountSnapshot$json = {
  '1': 'AccountSnapshot',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '10': 'account'
    },
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'as_of_unix_ms', '3': 3, '4': 1, '5': 3, '10': 'asOfUnixMs'},
    {'1': 'accounting_asset', '3': 4, '4': 1, '5': 9, '10': 'accountingAsset'},
    {
      '1': 'equity',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.MoneyReading',
      '10': 'equity'
    },
    {
      '1': 'available_balance',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.MoneyReading',
      '10': 'availableBalance'
    },
    {
      '1': 'risk_policy',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.RiskPolicyVersion',
      '10': 'riskPolicy'
    },
  ],
};

/// Descriptor for `AccountSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountSnapshotDescriptor = $convert.base64Decode(
    'Cg9BY2NvdW50U25hcHNob3QSLAoHYWNjb3VudBgBIAEoCzISLmxhYi52MS5BY2NvdW50UmVmUg'
    'dhY2NvdW50EhoKCHJldmlzaW9uGAIgASgDUghyZXZpc2lvbhIhCg1hc19vZl91bml4X21zGAMg'
    'ASgDUgphc09mVW5peE1zEikKEGFjY291bnRpbmdfYXNzZXQYBCABKAlSD2FjY291bnRpbmdBc3'
    'NldBIsCgZlcXVpdHkYBSABKAsyFC5sYWIudjEuTW9uZXlSZWFkaW5nUgZlcXVpdHkSQQoRYXZh'
    'aWxhYmxlX2JhbGFuY2UYBiABKAsyFC5sYWIudjEuTW9uZXlSZWFkaW5nUhBhdmFpbGFibGVCYW'
    'xhbmNlEjoKC3Jpc2tfcG9saWN5GAcgASgLMhkubGFiLnYxLlJpc2tQb2xpY3lWZXJzaW9uUgpy'
    'aXNrUG9saWN5');
