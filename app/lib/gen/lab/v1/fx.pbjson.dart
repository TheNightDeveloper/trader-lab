// This is a generated file - do not edit.
//
// Generated from lab/v1/fx.proto.

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

@$core.Deprecated('Use fxRateDescriptor instead')
const FxRate$json = {
  '1': 'FxRate',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'date', '3': 2, '4': 1, '5': 9, '10': 'date'},
    {'1': 'toman_per_usdt', '3': 3, '4': 1, '5': 11, '6': '.lab.v1.Money', '10': 'tomanPerUsdt'},
    {'1': 'source', '3': 4, '4': 1, '5': 9, '10': 'source'},
    {'1': 'entered_unix_ms', '3': 5, '4': 1, '5': 3, '10': 'enteredUnixMs'},
    {'1': 'reports', '3': 6, '4': 1, '5': 5, '10': 'reports'},
  ],
};

/// Descriptor for `FxRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fxRateDescriptor =
    $convert.base64Decode('CgZGeFJhdGUSDgoCaWQYASABKANSAmlkEhIKBGRhdGUYAiABKAlSBGRhdGUSMwoOdG9tYW5fcG'
        'VyX3VzZHQYAyABKAsyDS5sYWIudjEuTW9uZXlSDHRvbWFuUGVyVXNkdBIWCgZzb3VyY2UYBCAB'
        'KAlSBnNvdXJjZRImCg9lbnRlcmVkX3VuaXhfbXMYBSABKANSDWVudGVyZWRVbml4TXMSGAoHcm'
        'Vwb3J0cxgGIAEoBVIHcmVwb3J0cw==');

@$core.Deprecated('Use listRatesRequestDescriptor instead')
const ListRatesRequest$json = {
  '1': 'ListRatesRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListRatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRatesRequestDescriptor =
    $convert.base64Decode('ChBMaXN0UmF0ZXNSZXF1ZXN0EhQKBWxpbWl0GAEgASgFUgVsaW1pdA==');

@$core.Deprecated('Use listRatesResponseDescriptor instead')
const ListRatesResponse$json = {
  '1': 'ListRatesResponse',
  '2': [
    {'1': 'rates', '3': 1, '4': 3, '5': 11, '6': '.lab.v1.FxRate', '10': 'rates'},
  ],
};

/// Descriptor for `ListRatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRatesResponseDescriptor =
    $convert.base64Decode('ChFMaXN0UmF0ZXNSZXNwb25zZRIkCgVyYXRlcxgBIAMoCzIOLmxhYi52MS5GeFJhdGVSBXJhdG'
        'Vz');

@$core.Deprecated('Use addRateRequestDescriptor instead')
const AddRateRequest$json = {
  '1': 'AddRateRequest',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
    {'1': 'toman_per_usdt', '3': 2, '4': 1, '5': 9, '10': 'tomanPerUsdt'},
    {'1': 'source', '3': 3, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `AddRateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addRateRequestDescriptor =
    $convert.base64Decode('Cg5BZGRSYXRlUmVxdWVzdBISCgRkYXRlGAEgASgJUgRkYXRlEiQKDnRvbWFuX3Blcl91c2R0GA'
        'IgASgJUgx0b21hblBlclVzZHQSFgoGc291cmNlGAMgASgJUgZzb3VyY2U=');

@$core.Deprecated('Use addRateResponseDescriptor instead')
const AddRateResponse$json = {
  '1': 'AddRateResponse',
  '2': [
    {'1': 'rate', '3': 1, '4': 1, '5': 11, '6': '.lab.v1.FxRate', '10': 'rate'},
  ],
};

/// Descriptor for `AddRateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addRateResponseDescriptor =
    $convert.base64Decode('Cg9BZGRSYXRlUmVzcG9uc2USIgoEcmF0ZRgBIAEoCzIOLmxhYi52MS5GeFJhdGVSBHJhdGU=');

const $core.Map<$core.String, $core.dynamic> FxServiceBase$json = {
  '1': 'FxService',
  '2': [
    {'1': 'ListRates', '2': '.lab.v1.ListRatesRequest', '3': '.lab.v1.ListRatesResponse'},
    {'1': 'AddRate', '2': '.lab.v1.AddRateRequest', '3': '.lab.v1.AddRateResponse'},
  ],
};

@$core.Deprecated('Use fxServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> FxServiceBase$messageJson = {
  '.lab.v1.ListRatesRequest': ListRatesRequest$json,
  '.lab.v1.ListRatesResponse': ListRatesResponse$json,
  '.lab.v1.FxRate': FxRate$json,
  '.lab.v1.Money': $0.Money$json,
  '.lab.v1.AddRateRequest': AddRateRequest$json,
  '.lab.v1.AddRateResponse': AddRateResponse$json,
};

/// Descriptor for `FxService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List fxServiceDescriptor =
    $convert.base64Decode('CglGeFNlcnZpY2USQAoJTGlzdFJhdGVzEhgubGFiLnYxLkxpc3RSYXRlc1JlcXVlc3QaGS5sYW'
        'IudjEuTGlzdFJhdGVzUmVzcG9uc2USOgoHQWRkUmF0ZRIWLmxhYi52MS5BZGRSYXRlUmVxdWVz'
        'dBoXLmxhYi52MS5BZGRSYXRlUmVzcG9uc2U=');
