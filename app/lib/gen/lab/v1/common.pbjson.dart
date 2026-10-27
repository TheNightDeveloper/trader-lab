// This is a generated file - do not edit.
//
// Generated from lab/v1/common.proto.

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

@$core.Deprecated('Use moneyDescriptor instead')
const Money$json = {
  '1': 'Money',
  '2': [
    {'1': 'units', '3': 1, '4': 1, '5': 9, '10': 'units'},
    {'1': 'scale', '3': 2, '4': 1, '5': 5, '10': 'scale'},
    {'1': 'asset', '3': 3, '4': 1, '5': 9, '10': 'asset'},
  ],
};

/// Descriptor for `Money`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moneyDescriptor =
    $convert.base64Decode('CgVNb25leRIUCgV1bml0cxgBIAEoCVIFdW5pdHMSFAoFc2NhbGUYAiABKAVSBXNjYWxlEhQKBW'
        'Fzc2V0GAMgASgJUgVhc3NldA==');

@$core.Deprecated('Use decimalDescriptor instead')
const Decimal$json = {
  '1': 'Decimal',
  '2': [
    {'1': 'units', '3': 1, '4': 1, '5': 9, '10': 'units'},
    {'1': 'scale', '3': 2, '4': 1, '5': 5, '10': 'scale'},
  ],
};

/// Descriptor for `Decimal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decimalDescriptor =
    $convert.base64Decode('CgdEZWNpbWFsEhQKBXVuaXRzGAEgASgJUgV1bml0cxIUCgVzY2FsZRgCIAEoBVIFc2NhbGU=');

@$core.Deprecated('Use metricDescriptor instead')
const Metric$json = {
  '1': 'Metric',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'group', '3': 2, '4': 1, '5': 9, '10': 'group'},
    {'1': 'value', '3': 3, '4': 1, '5': 11, '6': '.lab.v1.Decimal', '10': 'value'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'valid', '3': 5, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'invalid', '3': 6, '4': 1, '5': 9, '10': 'invalid'},
    {'1': 'label', '3': 7, '4': 1, '5': 9, '10': 'label'},
    {'1': 'definition', '3': 8, '4': 1, '5': 9, '10': 'definition'},
  ],
};

/// Descriptor for `Metric`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metricDescriptor =
    $convert.base64Decode('CgZNZXRyaWMSEAoDa2V5GAEgASgJUgNrZXkSFAoFZ3JvdXAYAiABKAlSBWdyb3VwEiUKBXZhbH'
        'VlGAMgASgLMg8ubGFiLnYxLkRlY2ltYWxSBXZhbHVlEhIKBHVuaXQYBCABKAlSBHVuaXQSFAoF'
        'dmFsaWQYBSABKAhSBXZhbGlkEhgKB2ludmFsaWQYBiABKAlSB2ludmFsaWQSFAoFbGFiZWwYBy'
        'ABKAlSBWxhYmVsEh4KCmRlZmluaXRpb24YCCABKAlSCmRlZmluaXRpb24=');

@$core.Deprecated('Use equityPointDescriptor instead')
const EquityPoint$json = {
  '1': 'EquityPoint',
  '2': [
    {'1': 't_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'tUnixMs'},
    {'1': 'equity', '3': 2, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'equity'},
  ],
};

/// Descriptor for `EquityPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List equityPointDescriptor =
    $convert.base64Decode('CgtFcXVpdHlQb2ludBIaCgl0X3VuaXhfbXMYASABKANSB3RVbml4TXMSJQoGZXF1aXR5GAIgAS'
        'gLMg0ubGFiLnYxLk1vbmV5UgZlcXVpdHk=');
