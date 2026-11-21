// This is a generated file - do not edit.
//
// Generated from lab/v1/audit.proto.

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

@$core.Deprecated('Use auditActorDescriptor instead')
const AuditActor$json = {
  '1': 'AuditActor',
  '2': [
    {'1': 'AUDIT_ACTOR_UNSPECIFIED', '2': 0},
    {'1': 'AUDIT_ACTOR_USER', '2': 1},
    {'1': 'AUDIT_ACTOR_SYSTEM', '2': 2},
  ],
};

/// Descriptor for `AuditActor`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List auditActorDescriptor = $convert.base64Decode(
    'CgpBdWRpdEFjdG9yEhsKF0FVRElUX0FDVE9SX1VOU1BFQ0lGSUVEEAASFAoQQVVESVRfQUNUT1'
    'JfVVNFUhABEhYKEkFVRElUX0FDVE9SX1NZU1RFTRAC');

@$core.Deprecated('Use auditCursorDescriptor instead')
const AuditCursor$json = {
  '1': 'AuditCursor',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AccountRef',
      '9': 0,
      '10': 'account'
    },
    {
      '1': 'strategy_version_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'strategyVersionId'
    },
    {'1': 'sequence', '3': 3, '4': 1, '5': 3, '10': 'sequence'},
  ],
  '8': [
    {'1': 'scope'},
  ],
};

/// Descriptor for `AuditCursor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List auditCursorDescriptor = $convert.base64Decode(
    'CgtBdWRpdEN1cnNvchIuCgdhY2NvdW50GAEgASgLMhIubGFiLnYxLkFjY291bnRSZWZIAFIHYW'
    'Njb3VudBIwChNzdHJhdGVneV92ZXJzaW9uX2lkGAIgASgJSABSEXN0cmF0ZWd5VmVyc2lvbklk'
    'EhoKCHNlcXVlbmNlGAMgASgDUghzZXF1ZW5jZUIHCgVzY29wZQ==');

@$core.Deprecated('Use auditEventDescriptor instead')
const AuditEvent$json = {
  '1': 'AuditEvent',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.AuditCursor',
      '10': 'cursor'
    },
    {
      '1': 'actor',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.AuditActor',
      '10': 'actor'
    },
    {
      '1': 'recorded_at_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'recordedAtUnixMs'
    },
  ],
};

/// Descriptor for `AuditEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List auditEventDescriptor = $convert.base64Decode(
    'CgpBdWRpdEV2ZW50EisKBmN1cnNvchgBIAEoCzITLmxhYi52MS5BdWRpdEN1cnNvclIGY3Vyc2'
    '9yEigKBWFjdG9yGAIgASgOMhIubGFiLnYxLkF1ZGl0QWN0b3JSBWFjdG9yEi0KE3JlY29yZGVk'
    'X2F0X3VuaXhfbXMYAyABKANSEHJlY29yZGVkQXRVbml4TXM=');
