// This is a generated file - do not edit.
//
// Generated from lab/v1/data.proto.

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

@$core.Deprecated('Use getOverviewRequestDescriptor instead')
const GetOverviewRequest$json = {
  '1': 'GetOverviewRequest',
};

/// Descriptor for `GetOverviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOverviewRequestDescriptor =
    $convert.base64Decode('ChJHZXRPdmVydmlld1JlcXVlc3Q=');

@$core.Deprecated('Use getOverviewResponseDescriptor instead')
const GetOverviewResponse$json = {
  '1': 'GetOverviewResponse',
  '2': [
    {'1': 'live_symbols', '3': 1, '4': 1, '5': 5, '10': 'liveSymbols'},
    {'1': 'live_source', '3': 2, '4': 1, '5': 9, '10': 'liveSource'},
    {'1': 'outages_today', '3': 3, '4': 1, '5': 5, '10': 'outagesToday'},
    {
      '1': 'outage_seconds_today',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'outageSecondsToday'
    },
    {'1': 'storage_bytes', '3': 5, '4': 1, '5': 3, '10': 'storageBytes'},
    {'1': 'symbols', '3': 6, '4': 3, '5': 9, '10': 'symbols'},
  ],
};

/// Descriptor for `GetOverviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOverviewResponseDescriptor = $convert.base64Decode(
    'ChNHZXRPdmVydmlld1Jlc3BvbnNlEiEKDGxpdmVfc3ltYm9scxgBIAEoBVILbGl2ZVN5bWJvbH'
    'MSHwoLbGl2ZV9zb3VyY2UYAiABKAlSCmxpdmVTb3VyY2USIwoNb3V0YWdlc190b2RheRgDIAEo'
    'BVIMb3V0YWdlc1RvZGF5EjAKFG91dGFnZV9zZWNvbmRzX3RvZGF5GAQgASgDUhJvdXRhZ2VTZW'
    'NvbmRzVG9kYXkSIwoNc3RvcmFnZV9ieXRlcxgFIAEoA1IMc3RvcmFnZUJ5dGVzEhgKB3N5bWJv'
    'bHMYBiADKAlSB3N5bWJvbHM=');

@$core.Deprecated('Use datasetDescriptor instead')
const Dataset$json = {
  '1': 'Dataset',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'symbol', '3': 2, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'timeframe', '3': 3, '4': 1, '5': 9, '10': 'timeframe'},
    {'1': 'from_unix_ms', '3': 4, '4': 1, '5': 3, '10': 'fromUnixMs'},
    {'1': 'to_unix_ms', '3': 5, '4': 1, '5': 3, '10': 'toUnixMs'},
    {'1': 'gap_policy', '3': 6, '4': 1, '5': 9, '10': 'gapPolicy'},
    {'1': 'bar_count', '3': 7, '4': 1, '5': 5, '10': 'barCount'},
    {'1': 'gaps', '3': 8, '4': 1, '5': 5, '10': 'gaps'},
    {'1': 'filled', '3': 9, '4': 1, '5': 5, '10': 'filled'},
    {'1': 'created_unix_ms', '3': 10, '4': 1, '5': 3, '10': 'createdUnixMs'},
    {'1': 'experiments', '3': 11, '4': 1, '5': 5, '10': 'experiments'},
  ],
};

/// Descriptor for `Dataset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List datasetDescriptor = $convert.base64Decode(
    'CgdEYXRhc2V0Eg4KAmlkGAEgASgJUgJpZBIWCgZzeW1ib2wYAiABKAlSBnN5bWJvbBIcCgl0aW'
    '1lZnJhbWUYAyABKAlSCXRpbWVmcmFtZRIgCgxmcm9tX3VuaXhfbXMYBCABKANSCmZyb21Vbml4'
    'TXMSHAoKdG9fdW5peF9tcxgFIAEoA1IIdG9Vbml4TXMSHQoKZ2FwX3BvbGljeRgGIAEoCVIJZ2'
    'FwUG9saWN5EhsKCWJhcl9jb3VudBgHIAEoBVIIYmFyQ291bnQSEgoEZ2FwcxgIIAEoBVIEZ2Fw'
    'cxIWCgZmaWxsZWQYCSABKAVSBmZpbGxlZBImCg9jcmVhdGVkX3VuaXhfbXMYCiABKANSDWNyZW'
    'F0ZWRVbml4TXMSIAoLZXhwZXJpbWVudHMYCyABKAVSC2V4cGVyaW1lbnRz');

@$core.Deprecated('Use listDatasetsRequestDescriptor instead')
const ListDatasetsRequest$json = {
  '1': 'ListDatasetsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListDatasetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDatasetsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0RGF0YXNldHNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemUSFgoGb2'
    'Zmc2V0GAIgASgFUgZvZmZzZXQ=');

@$core.Deprecated('Use listDatasetsResponseDescriptor instead')
const ListDatasetsResponse$json = {
  '1': 'ListDatasetsResponse',
  '2': [
    {
      '1': 'datasets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Dataset',
      '10': 'datasets'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListDatasetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDatasetsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0RGF0YXNldHNSZXNwb25zZRIrCghkYXRhc2V0cxgBIAMoCzIPLmxhYi52MS5EYXRhc2'
    'V0UghkYXRhc2V0cxIUCgV0b3RhbBgCIAEoA1IFdG90YWw=');

@$core.Deprecated('Use getCoverageRequestDescriptor instead')
const GetCoverageRequest$json = {
  '1': 'GetCoverageRequest',
};

/// Descriptor for `GetCoverageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCoverageRequestDescriptor =
    $convert.base64Decode('ChJHZXRDb3ZlcmFnZVJlcXVlc3Q=');

@$core.Deprecated('Use coverageDescriptor instead')
const Coverage$json = {
  '1': 'Coverage',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {
      '1': 'first_open_unix_ms',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'firstOpenUnixMs'
    },
    {'1': 'last_open_unix_ms', '3': 3, '4': 1, '5': 3, '10': 'lastOpenUnixMs'},
    {'1': 'bars', '3': 4, '4': 1, '5': 3, '10': 'bars'},
    {
      '1': 'problems',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.TimeRange',
      '10': 'problems'
    },
    {
      '1': 'segments',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.TimeRange',
      '10': 'segments'
    },
  ],
};

/// Descriptor for `Coverage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coverageDescriptor = $convert.base64Decode(
    'CghDb3ZlcmFnZRIWCgZzeW1ib2wYASABKAlSBnN5bWJvbBIrChJmaXJzdF9vcGVuX3VuaXhfbX'
    'MYAiABKANSD2ZpcnN0T3BlblVuaXhNcxIpChFsYXN0X29wZW5fdW5peF9tcxgDIAEoA1IObGFz'
    'dE9wZW5Vbml4TXMSEgoEYmFycxgEIAEoA1IEYmFycxItCghwcm9ibGVtcxgFIAMoCzIRLmxhYi'
    '52MS5UaW1lUmFuZ2VSCHByb2JsZW1zEi0KCHNlZ21lbnRzGAYgAygLMhEubGFiLnYxLlRpbWVS'
    'YW5nZVIIc2VnbWVudHM=');

@$core.Deprecated('Use timeRangeDescriptor instead')
const TimeRange$json = {
  '1': 'TimeRange',
  '2': [
    {'1': 'from_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'fromUnixMs'},
    {'1': 'until_unix_ms', '3': 2, '4': 1, '5': 3, '10': 'untilUnixMs'},
  ],
};

/// Descriptor for `TimeRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeRangeDescriptor = $convert.base64Decode(
    'CglUaW1lUmFuZ2USIAoMZnJvbV91bml4X21zGAEgASgDUgpmcm9tVW5peE1zEiIKDXVudGlsX3'
    'VuaXhfbXMYAiABKANSC3VudGlsVW5peE1z');

@$core.Deprecated('Use getCoverageResponseDescriptor instead')
const GetCoverageResponse$json = {
  '1': 'GetCoverageResponse',
  '2': [
    {
      '1': 'coverage',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.Coverage',
      '10': 'coverage'
    },
  ],
};

/// Descriptor for `GetCoverageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCoverageResponseDescriptor = $convert.base64Decode(
    'ChNHZXRDb3ZlcmFnZVJlc3BvbnNlEiwKCGNvdmVyYWdlGAEgAygLMhAubGFiLnYxLkNvdmVyYW'
    'dlUghjb3ZlcmFnZQ==');

@$core.Deprecated('Use qualityIssueDescriptor instead')
const QualityIssue$json = {
  '1': 'QualityIssue',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'symbol', '3': 2, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'at_unix_ms', '3': 4, '4': 1, '5': 3, '10': 'atUnixMs'},
    {'1': 'until_unix_ms', '3': 5, '4': 1, '5': 3, '10': 'untilUnixMs'},
    {'1': 'detail', '3': 6, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `QualityIssue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityIssueDescriptor = $convert.base64Decode(
    'CgxRdWFsaXR5SXNzdWUSDgoCaWQYASABKANSAmlkEhYKBnN5bWJvbBgCIAEoCVIGc3ltYm9sEh'
    'IKBGtpbmQYAyABKAlSBGtpbmQSHAoKYXRfdW5peF9tcxgEIAEoA1IIYXRVbml4TXMSIgoNdW50'
    'aWxfdW5peF9tcxgFIAEoA1ILdW50aWxVbml4TXMSFgoGZGV0YWlsGAYgASgJUgZkZXRhaWw=');

@$core.Deprecated('Use listQualityIssuesRequestDescriptor instead')
const ListQualityIssuesRequest$json = {
  '1': 'ListQualityIssuesRequest',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListQualityIssuesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listQualityIssuesRequestDescriptor =
    $convert.base64Decode(
        'ChhMaXN0UXVhbGl0eUlzc3Vlc1JlcXVlc3QSFgoGc3ltYm9sGAEgASgJUgZzeW1ib2wSGwoJcG'
        'FnZV9zaXplGAIgASgFUghwYWdlU2l6ZRIWCgZvZmZzZXQYAyABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listQualityIssuesResponseDescriptor instead')
const ListQualityIssuesResponse$json = {
  '1': 'ListQualityIssuesResponse',
  '2': [
    {
      '1': 'issues',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.QualityIssue',
      '10': 'issues'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListQualityIssuesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listQualityIssuesResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0UXVhbGl0eUlzc3Vlc1Jlc3BvbnNlEiwKBmlzc3VlcxgBIAMoCzIULmxhYi52MS5RdW'
        'FsaXR5SXNzdWVSBmlzc3VlcxIUCgV0b3RhbBgCIAEoA1IFdG90YWw=');

@$core.Deprecated('Use importRequestDescriptor instead')
const ImportRequest$json = {
  '1': 'ImportRequest',
  '2': [
    {'1': 'symbols', '3': 1, '4': 3, '5': 9, '10': 'symbols'},
    {'1': 'from_date', '3': 2, '4': 1, '5': 9, '10': 'fromDate'},
    {'1': 'to_date', '3': 3, '4': 1, '5': 9, '10': 'toDate'},
    {'1': 'timeframe', '3': 4, '4': 1, '5': 9, '10': 'timeframe'},
    {'1': 'gap_policy', '3': 5, '4': 1, '5': 9, '10': 'gapPolicy'},
  ],
};

/// Descriptor for `ImportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importRequestDescriptor = $convert.base64Decode(
    'Cg1JbXBvcnRSZXF1ZXN0EhgKB3N5bWJvbHMYASADKAlSB3N5bWJvbHMSGwoJZnJvbV9kYXRlGA'
    'IgASgJUghmcm9tRGF0ZRIXCgd0b19kYXRlGAMgASgJUgZ0b0RhdGUSHAoJdGltZWZyYW1lGAQg'
    'ASgJUgl0aW1lZnJhbWUSHQoKZ2FwX3BvbGljeRgFIAEoCVIJZ2FwUG9saWN5');

@$core.Deprecated('Use importResponseDescriptor instead')
const ImportResponse$json = {
  '1': 'ImportResponse',
  '2': [
    {
      '1': 'progress',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ImportProgress',
      '9': 0,
      '10': 'progress'
    },
    {
      '1': 'dataset',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Dataset',
      '9': 0,
      '10': 'dataset'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ImportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importResponseDescriptor = $convert.base64Decode(
    'Cg5JbXBvcnRSZXNwb25zZRI0Cghwcm9ncmVzcxgBIAEoCzIWLmxhYi52MS5JbXBvcnRQcm9ncm'
    'Vzc0gAUghwcm9ncmVzcxIrCgdkYXRhc2V0GAIgASgLMg8ubGFiLnYxLkRhdGFzZXRIAFIHZGF0'
    'YXNldEIHCgVldmVudA==');

@$core.Deprecated('Use importProgressDescriptor instead')
const ImportProgress$json = {
  '1': 'ImportProgress',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'file', '3': 2, '4': 1, '5': 9, '10': 'file'},
    {'1': 'files_done', '3': 3, '4': 1, '5': 5, '10': 'filesDone'},
    {'1': 'files_total', '3': 4, '4': 1, '5': 5, '10': 'filesTotal'},
    {'1': 'rows', '3': 5, '4': 1, '5': 5, '10': 'rows'},
    {'1': 'inserted', '3': 6, '4': 1, '5': 5, '10': 'inserted'},
    {'1': 'corrections', '3': 7, '4': 1, '5': 5, '10': 'corrections'},
    {'1': 'missing', '3': 8, '4': 1, '5': 5, '10': 'missing'},
  ],
};

/// Descriptor for `ImportProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importProgressDescriptor = $convert.base64Decode(
    'Cg5JbXBvcnRQcm9ncmVzcxIWCgZzeW1ib2wYASABKAlSBnN5bWJvbBISCgRmaWxlGAIgASgJUg'
    'RmaWxlEh0KCmZpbGVzX2RvbmUYAyABKAVSCWZpbGVzRG9uZRIfCgtmaWxlc190b3RhbBgEIAEo'
    'BVIKZmlsZXNUb3RhbBISCgRyb3dzGAUgASgFUgRyb3dzEhoKCGluc2VydGVkGAYgASgFUghpbn'
    'NlcnRlZBIgCgtjb3JyZWN0aW9ucxgHIAEoBVILY29ycmVjdGlvbnMSGAoHbWlzc2luZxgIIAEo'
    'BVIHbWlzc2luZw==');

const $core.Map<$core.String, $core.dynamic> DataServiceBase$json = {
  '1': 'DataService',
  '2': [
    {
      '1': 'GetOverview',
      '2': '.lab.v1.GetOverviewRequest',
      '3': '.lab.v1.GetOverviewResponse'
    },
    {
      '1': 'ListDatasets',
      '2': '.lab.v1.ListDatasetsRequest',
      '3': '.lab.v1.ListDatasetsResponse'
    },
    {
      '1': 'GetCoverage',
      '2': '.lab.v1.GetCoverageRequest',
      '3': '.lab.v1.GetCoverageResponse'
    },
    {
      '1': 'ListQualityIssues',
      '2': '.lab.v1.ListQualityIssuesRequest',
      '3': '.lab.v1.ListQualityIssuesResponse'
    },
    {
      '1': 'Import',
      '2': '.lab.v1.ImportRequest',
      '3': '.lab.v1.ImportResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use dataServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DataServiceBase$messageJson = {
  '.lab.v1.GetOverviewRequest': GetOverviewRequest$json,
  '.lab.v1.GetOverviewResponse': GetOverviewResponse$json,
  '.lab.v1.ListDatasetsRequest': ListDatasetsRequest$json,
  '.lab.v1.ListDatasetsResponse': ListDatasetsResponse$json,
  '.lab.v1.Dataset': Dataset$json,
  '.lab.v1.GetCoverageRequest': GetCoverageRequest$json,
  '.lab.v1.GetCoverageResponse': GetCoverageResponse$json,
  '.lab.v1.Coverage': Coverage$json,
  '.lab.v1.TimeRange': TimeRange$json,
  '.lab.v1.ListQualityIssuesRequest': ListQualityIssuesRequest$json,
  '.lab.v1.ListQualityIssuesResponse': ListQualityIssuesResponse$json,
  '.lab.v1.QualityIssue': QualityIssue$json,
  '.lab.v1.ImportRequest': ImportRequest$json,
  '.lab.v1.ImportResponse': ImportResponse$json,
  '.lab.v1.ImportProgress': ImportProgress$json,
};

/// Descriptor for `DataService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List dataServiceDescriptor = $convert.base64Decode(
    'CgtEYXRhU2VydmljZRJGCgtHZXRPdmVydmlldxIaLmxhYi52MS5HZXRPdmVydmlld1JlcXVlc3'
    'QaGy5sYWIudjEuR2V0T3ZlcnZpZXdSZXNwb25zZRJJCgxMaXN0RGF0YXNldHMSGy5sYWIudjEu'
    'TGlzdERhdGFzZXRzUmVxdWVzdBocLmxhYi52MS5MaXN0RGF0YXNldHNSZXNwb25zZRJGCgtHZX'
    'RDb3ZlcmFnZRIaLmxhYi52MS5HZXRDb3ZlcmFnZVJlcXVlc3QaGy5sYWIudjEuR2V0Q292ZXJh'
    'Z2VSZXNwb25zZRJYChFMaXN0UXVhbGl0eUlzc3VlcxIgLmxhYi52MS5MaXN0UXVhbGl0eUlzc3'
    'Vlc1JlcXVlc3QaIS5sYWIudjEuTGlzdFF1YWxpdHlJc3N1ZXNSZXNwb25zZRI5CgZJbXBvcnQS'
    'FS5sYWIudjEuSW1wb3J0UmVxdWVzdBoWLmxhYi52MS5JbXBvcnRSZXNwb25zZTAB');
