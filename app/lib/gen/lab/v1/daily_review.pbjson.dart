// This is a generated file - do not edit.
//
// Generated from lab/v1/daily_review.proto.

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

import 'account.pbjson.dart' as $4;
import 'common.pbjson.dart' as $3;
import 'market.pbjson.dart' as $1;
import 'paper.pbjson.dart' as $0;
import 'shadow.pbjson.dart' as $2;
import 'workspace.pbjson.dart' as $5;

@$core.Deprecated('Use getDailyReviewRequestDescriptor instead')
const GetDailyReviewRequest$json = {
  '1': 'GetDailyReviewRequest',
};

/// Descriptor for `GetDailyReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyReviewRequestDescriptor =
    $convert.base64Decode('ChVHZXREYWlseVJldmlld1JlcXVlc3Q=');

@$core.Deprecated('Use getDailyReviewResponseDescriptor instead')
const GetDailyReviewResponse$json = {
  '1': 'GetDailyReviewResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.DailyReviewStatus',
      '10': 'status'
    },
    {'1': 'as_of_unix_ms', '3': 2, '4': 1, '5': 3, '10': 'asOfUnixMs'},
    {
      '1': 'paper_account',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperAccount',
      '10': 'paperAccount'
    },
    {
      '1': 'positions',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.PaperPosition',
      '10': 'positions'
    },
    {
      '1': 'reconciliation',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.PaperReconciliation',
      '10': 'reconciliation'
    },
    {
      '1': 'exposure',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.DailyReviewExposure',
      '10': 'exposure'
    },
    {
      '1': 'open_window',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.MarketOpportunity',
      '10': 'openWindow'
    },
    {
      '1': 'expired',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.MarketOpportunity',
      '10': 'expired'
    },
    {'1': 'open_window_count', '3': 9, '4': 1, '5': 3, '10': 'openWindowCount'},
    {'1': 'expired_count', '3': 10, '4': 1, '5': 3, '10': 'expiredCount'},
    {
      '1': 'shadow',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.ShadowDeployment',
      '10': 'shadow'
    },
    {
      '1': 'events',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.lab.v1.DailyReviewEvent',
      '10': 'events'
    },
    {
      '1': 'shadow_rule_title',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'shadowRuleTitle'
    },
  ],
};

/// Descriptor for `GetDailyReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyReviewResponseDescriptor = $convert.base64Decode(
    'ChZHZXREYWlseVJldmlld1Jlc3BvbnNlEjEKBnN0YXR1cxgBIAEoCzIZLmxhYi52MS5EYWlseV'
    'Jldmlld1N0YXR1c1IGc3RhdHVzEiEKDWFzX29mX3VuaXhfbXMYAiABKANSCmFzT2ZVbml4TXMS'
    'OQoNcGFwZXJfYWNjb3VudBgDIAEoCzIULmxhYi52MS5QYXBlckFjY291bnRSDHBhcGVyQWNjb3'
    'VudBIzCglwb3NpdGlvbnMYBCADKAsyFS5sYWIudjEuUGFwZXJQb3NpdGlvblIJcG9zaXRpb25z'
    'EkMKDnJlY29uY2lsaWF0aW9uGAUgASgLMhsubGFiLnYxLlBhcGVyUmVjb25jaWxpYXRpb25SDn'
    'JlY29uY2lsaWF0aW9uEjcKCGV4cG9zdXJlGAYgAygLMhsubGFiLnYxLkRhaWx5UmV2aWV3RXhw'
    'b3N1cmVSCGV4cG9zdXJlEjoKC29wZW5fd2luZG93GAcgAygLMhkubGFiLnYxLk1hcmtldE9wcG'
    '9ydHVuaXR5UgpvcGVuV2luZG93EjMKB2V4cGlyZWQYCCADKAsyGS5sYWIudjEuTWFya2V0T3Bw'
    'b3J0dW5pdHlSB2V4cGlyZWQSKgoRb3Blbl93aW5kb3dfY291bnQYCSABKANSD29wZW5XaW5kb3'
    'dDb3VudBIjCg1leHBpcmVkX2NvdW50GAogASgDUgxleHBpcmVkQ291bnQSMAoGc2hhZG93GAsg'
    'ASgLMhgubGFiLnYxLlNoYWRvd0RlcGxveW1lbnRSBnNoYWRvdxIwCgZldmVudHMYDCADKAsyGC'
    '5sYWIudjEuRGFpbHlSZXZpZXdFdmVudFIGZXZlbnRzEioKEXNoYWRvd19ydWxlX3RpdGxlGA0g'
    'ASgJUg9zaGFkb3dSdWxlVGl0bGU=');

@$core.Deprecated('Use dailyReviewExposureDescriptor instead')
const DailyReviewExposure$json = {
  '1': 'DailyReviewExposure',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {
      '1': 'market_value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Money',
      '10': 'marketValue'
    },
    {
      '1': 'share_of_open_value',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'shareOfOpenValue'
    },
  ],
};

/// Descriptor for `DailyReviewExposure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailyReviewExposureDescriptor = $convert.base64Decode(
    'ChNEYWlseVJldmlld0V4cG9zdXJlEhYKBnN5bWJvbBgBIAEoCVIGc3ltYm9sEjAKDG1hcmtldF'
    '92YWx1ZRgCIAEoCzINLmxhYi52MS5Nb25leVILbWFya2V0VmFsdWUSPgoTc2hhcmVfb2Zfb3Bl'
    'bl92YWx1ZRgDIAEoCzIPLmxhYi52MS5EZWNpbWFsUhBzaGFyZU9mT3BlblZhbHVl');

@$core.Deprecated('Use dailyReviewEventDescriptor instead')
const DailyReviewEvent$json = {
  '1': 'DailyReviewEvent',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {
      '1': 'detected_at_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'detectedAtUnixMs'
    },
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `DailyReviewEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailyReviewEventDescriptor = $convert.base64Decode(
    'ChBEYWlseVJldmlld0V2ZW50EhYKBnN5bWJvbBgBIAEoCVIGc3ltYm9sEhIKBGtpbmQYAiABKA'
    'lSBGtpbmQSLQoTZGV0ZWN0ZWRfYXRfdW5peF9tcxgDIAEoA1IQZGV0ZWN0ZWRBdFVuaXhNcxIW'
    'CgZkZXRhaWwYBCABKAlSBmRldGFpbA==');

@$core.Deprecated('Use dailyReviewStatusDescriptor instead')
const DailyReviewStatus$json = {
  '1': 'DailyReviewStatus',
  '2': [
    {'1': 'day_start_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'dayStartUnixMs'},
    {'1': 'reminder_enabled', '3': 2, '4': 1, '5': 8, '10': 'reminderEnabled'},
    {'1': 'reviewed_today', '3': 3, '4': 1, '5': 8, '10': 'reviewedToday'},
  ],
};

/// Descriptor for `DailyReviewStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailyReviewStatusDescriptor = $convert.base64Decode(
    'ChFEYWlseVJldmlld1N0YXR1cxIpChFkYXlfc3RhcnRfdW5peF9tcxgBIAEoA1IOZGF5U3Rhcn'
    'RVbml4TXMSKQoQcmVtaW5kZXJfZW5hYmxlZBgCIAEoCFIPcmVtaW5kZXJFbmFibGVkEiUKDnJl'
    'dmlld2VkX3RvZGF5GAMgASgIUg1yZXZpZXdlZFRvZGF5');

@$core.Deprecated('Use getDailyReviewStatusRequestDescriptor instead')
const GetDailyReviewStatusRequest$json = {
  '1': 'GetDailyReviewStatusRequest',
};

/// Descriptor for `GetDailyReviewStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyReviewStatusRequestDescriptor =
    $convert.base64Decode('ChtHZXREYWlseVJldmlld1N0YXR1c1JlcXVlc3Q=');

@$core.Deprecated('Use getDailyReviewStatusResponseDescriptor instead')
const GetDailyReviewStatusResponse$json = {
  '1': 'GetDailyReviewStatusResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.DailyReviewStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `GetDailyReviewStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyReviewStatusResponseDescriptor =
    $convert.base64Decode(
        'ChxHZXREYWlseVJldmlld1N0YXR1c1Jlc3BvbnNlEjEKBnN0YXR1cxgBIAEoCzIZLmxhYi52MS'
        '5EYWlseVJldmlld1N0YXR1c1IGc3RhdHVz');

@$core.Deprecated('Use setDailyReviewReminderRequestDescriptor instead')
const SetDailyReviewReminderRequest$json = {
  '1': 'SetDailyReviewReminderRequest',
  '2': [
    {
      '1': 'enabled',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
  ],
  '8': [
    {'1': '_enabled'},
  ],
};

/// Descriptor for `SetDailyReviewReminderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDailyReviewReminderRequestDescriptor =
    $convert.base64Decode(
        'Ch1TZXREYWlseVJldmlld1JlbWluZGVyUmVxdWVzdBIdCgdlbmFibGVkGAEgASgISABSB2VuYW'
        'JsZWSIAQFCCgoIX2VuYWJsZWQ=');

@$core.Deprecated('Use setDailyReviewReminderResponseDescriptor instead')
const SetDailyReviewReminderResponse$json = {
  '1': 'SetDailyReviewReminderResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.DailyReviewStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `SetDailyReviewReminderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDailyReviewReminderResponseDescriptor =
    $convert.base64Decode(
        'Ch5TZXREYWlseVJldmlld1JlbWluZGVyUmVzcG9uc2USMQoGc3RhdHVzGAEgASgLMhkubGFiLn'
        'YxLkRhaWx5UmV2aWV3U3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use markDailyReviewReadRequestDescriptor instead')
const MarkDailyReviewReadRequest$json = {
  '1': 'MarkDailyReviewReadRequest',
  '2': [
    {'1': 'day_start_unix_ms', '3': 1, '4': 1, '5': 3, '10': 'dayStartUnixMs'},
  ],
};

/// Descriptor for `MarkDailyReviewReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markDailyReviewReadRequestDescriptor =
    $convert.base64Decode(
        'ChpNYXJrRGFpbHlSZXZpZXdSZWFkUmVxdWVzdBIpChFkYXlfc3RhcnRfdW5peF9tcxgBIAEoA1'
        'IOZGF5U3RhcnRVbml4TXM=');

@$core.Deprecated('Use markDailyReviewReadResponseDescriptor instead')
const MarkDailyReviewReadResponse$json = {
  '1': 'MarkDailyReviewReadResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.DailyReviewStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `MarkDailyReviewReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markDailyReviewReadResponseDescriptor =
    $convert.base64Decode(
        'ChtNYXJrRGFpbHlSZXZpZXdSZWFkUmVzcG9uc2USMQoGc3RhdHVzGAEgASgLMhkubGFiLnYxLk'
        'RhaWx5UmV2aWV3U3RhdHVzUgZzdGF0dXM=');

const $core.Map<$core.String, $core.dynamic> DailyReviewServiceBase$json = {
  '1': 'DailyReviewService',
  '2': [
    {
      '1': 'GetDailyReview',
      '2': '.lab.v1.GetDailyReviewRequest',
      '3': '.lab.v1.GetDailyReviewResponse'
    },
    {
      '1': 'GetDailyReviewStatus',
      '2': '.lab.v1.GetDailyReviewStatusRequest',
      '3': '.lab.v1.GetDailyReviewStatusResponse'
    },
    {
      '1': 'SetDailyReviewReminder',
      '2': '.lab.v1.SetDailyReviewReminderRequest',
      '3': '.lab.v1.SetDailyReviewReminderResponse'
    },
    {
      '1': 'MarkDailyReviewRead',
      '2': '.lab.v1.MarkDailyReviewReadRequest',
      '3': '.lab.v1.MarkDailyReviewReadResponse'
    },
  ],
};

@$core.Deprecated('Use dailyReviewServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DailyReviewServiceBase$messageJson = {
  '.lab.v1.GetDailyReviewRequest': GetDailyReviewRequest$json,
  '.lab.v1.GetDailyReviewResponse': GetDailyReviewResponse$json,
  '.lab.v1.DailyReviewStatus': DailyReviewStatus$json,
  '.lab.v1.PaperAccount': $0.PaperAccount$json,
  '.lab.v1.AccountSnapshot': $4.AccountSnapshot$json,
  '.lab.v1.AccountRef': $5.AccountRef$json,
  '.lab.v1.MoneyReading': $4.MoneyReading$json,
  '.lab.v1.Money': $3.Money$json,
  '.lab.v1.UnavailableMoney': $4.UnavailableMoney$json,
  '.lab.v1.RiskPolicyVersion': $4.RiskPolicyVersion$json,
  '.lab.v1.Decimal': $3.Decimal$json,
  '.lab.v1.PaperPosition': $0.PaperPosition$json,
  '.lab.v1.PaperReduction': $0.PaperReduction$json,
  '.lab.v1.PaperReconciliation': $0.PaperReconciliation$json,
  '.lab.v1.DailyReviewExposure': DailyReviewExposure$json,
  '.lab.v1.MarketOpportunity': $1.MarketOpportunity$json,
  '.lab.v1.ShadowDeployment': $2.ShadowDeployment$json,
  '.lab.v1.DailyReviewEvent': DailyReviewEvent$json,
  '.lab.v1.GetDailyReviewStatusRequest': GetDailyReviewStatusRequest$json,
  '.lab.v1.GetDailyReviewStatusResponse': GetDailyReviewStatusResponse$json,
  '.lab.v1.SetDailyReviewReminderRequest': SetDailyReviewReminderRequest$json,
  '.lab.v1.SetDailyReviewReminderResponse': SetDailyReviewReminderResponse$json,
  '.lab.v1.MarkDailyReviewReadRequest': MarkDailyReviewReadRequest$json,
  '.lab.v1.MarkDailyReviewReadResponse': MarkDailyReviewReadResponse$json,
};

/// Descriptor for `DailyReviewService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List dailyReviewServiceDescriptor = $convert.base64Decode(
    'ChJEYWlseVJldmlld1NlcnZpY2USTwoOR2V0RGFpbHlSZXZpZXcSHS5sYWIudjEuR2V0RGFpbH'
    'lSZXZpZXdSZXF1ZXN0Gh4ubGFiLnYxLkdldERhaWx5UmV2aWV3UmVzcG9uc2USYQoUR2V0RGFp'
    'bHlSZXZpZXdTdGF0dXMSIy5sYWIudjEuR2V0RGFpbHlSZXZpZXdTdGF0dXNSZXF1ZXN0GiQubG'
    'FiLnYxLkdldERhaWx5UmV2aWV3U3RhdHVzUmVzcG9uc2USZwoWU2V0RGFpbHlSZXZpZXdSZW1p'
    'bmRlchIlLmxhYi52MS5TZXREYWlseVJldmlld1JlbWluZGVyUmVxdWVzdBomLmxhYi52MS5TZX'
    'REYWlseVJldmlld1JlbWluZGVyUmVzcG9uc2USXgoTTWFya0RhaWx5UmV2aWV3UmVhZBIiLmxh'
    'Yi52MS5NYXJrRGFpbHlSZXZpZXdSZWFkUmVxdWVzdBojLmxhYi52MS5NYXJrRGFpbHlSZXZpZX'
    'dSZWFkUmVzcG9uc2U=');
