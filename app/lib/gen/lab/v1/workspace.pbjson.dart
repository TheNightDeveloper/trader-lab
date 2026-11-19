// This is a generated file - do not edit.
//
// Generated from lab/v1/workspace.proto.

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

@$core.Deprecated('Use environmentDescriptor instead')
const Environment$json = {
  '1': 'Environment',
  '2': [
    {'1': 'ENVIRONMENT_UNSPECIFIED', '2': 0},
    {'1': 'ENVIRONMENT_RESEARCH', '2': 1},
    {'1': 'ENVIRONMENT_PAPER', '2': 2},
    {'1': 'ENVIRONMENT_LIVE', '2': 3},
  ],
};

/// Descriptor for `Environment`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List environmentDescriptor = $convert.base64Decode(
    'CgtFbnZpcm9ubWVudBIbChdFTlZJUk9OTUVOVF9VTlNQRUNJRklFRBAAEhgKFEVOVklST05NRU'
    '5UX1JFU0VBUkNIEAESFQoRRU5WSVJPTk1FTlRfUEFQRVIQAhIUChBFTlZJUk9OTUVOVF9MSVZF'
    'EAM=');

@$core.Deprecated('Use marketProductDescriptor instead')
const MarketProduct$json = {
  '1': 'MarketProduct',
  '2': [
    {'1': 'MARKET_PRODUCT_UNSPECIFIED', '2': 0},
    {'1': 'MARKET_PRODUCT_SPOT', '2': 1},
    {'1': 'MARKET_PRODUCT_PERPETUAL', '2': 2},
  ],
};

/// Descriptor for `MarketProduct`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List marketProductDescriptor = $convert.base64Decode(
    'Cg1NYXJrZXRQcm9kdWN0Eh4KGk1BUktFVF9QUk9EVUNUX1VOU1BFQ0lGSUVEEAASFwoTTUFSS0'
    'VUX1BST0RVQ1RfU1BPVBABEhwKGE1BUktFVF9QUk9EVUNUX1BFUlBFVFVBTBAC');

@$core.Deprecated('Use instrumentKeyDescriptor instead')
const InstrumentKey$json = {
  '1': 'InstrumentKey',
  '2': [
    {'1': 'venue', '3': 1, '4': 1, '5': 9, '10': 'venue'},
    {
      '1': 'product',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.MarketProduct',
      '10': 'product'
    },
    {'1': 'symbol', '3': 3, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'settlement_asset', '3': 4, '4': 1, '5': 9, '10': 'settlementAsset'},
    {'1': 'spec_revision', '3': 5, '4': 1, '5': 9, '10': 'specRevision'},
  ],
};

/// Descriptor for `InstrumentKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List instrumentKeyDescriptor = $convert.base64Decode(
    'Cg1JbnN0cnVtZW50S2V5EhQKBXZlbnVlGAEgASgJUgV2ZW51ZRIvCgdwcm9kdWN0GAIgASgOMh'
    'UubGFiLnYxLk1hcmtldFByb2R1Y3RSB3Byb2R1Y3QSFgoGc3ltYm9sGAMgASgJUgZzeW1ib2wS'
    'KQoQc2V0dGxlbWVudF9hc3NldBgEIAEoCVIPc2V0dGxlbWVudEFzc2V0EiMKDXNwZWNfcmV2aX'
    'Npb24YBSABKAlSDHNwZWNSZXZpc2lvbg==');

@$core.Deprecated('Use accountRefDescriptor instead')
const AccountRef$json = {
  '1': 'AccountRef',
  '2': [
    {
      '1': 'environment',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.lab.v1.Environment',
      '10': 'environment'
    },
    {'1': 'account_id', '3': 2, '4': 1, '5': 9, '10': 'accountId'},
  ],
};

/// Descriptor for `AccountRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountRefDescriptor = $convert.base64Decode(
    'CgpBY2NvdW50UmVmEjUKC2Vudmlyb25tZW50GAEgASgOMhMubGFiLnYxLkVudmlyb25tZW50Ug'
    'tlbnZpcm9ubWVudBIdCgphY2NvdW50X2lkGAIgASgJUglhY2NvdW50SWQ=');

@$core.Deprecated('Use signalDescriptor instead')
const Signal$json = {
  '1': 'Signal',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 13, '10': 'schemaVersion'},
    {
      '1': 'strategy_version_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'strategyVersionId'
    },
    {
      '1': 'instrument',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.InstrumentKey',
      '10': 'instrument'
    },
    {
      '1': 'observed_at_unix_ms',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'observedAtUnixMs'
    },
    {
      '1': 'valid_until_unix_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'validUntilUnixMs',
      '17': true
    },
    {
      '1': 'target_exposure',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lab.v1.Decimal',
      '10': 'targetExposure'
    },
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
  ],
  '8': [
    {'1': '_valid_until_unix_ms'},
  ],
};

/// Descriptor for `Signal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalDescriptor = $convert.base64Decode(
    'CgZTaWduYWwSJQoOc2NoZW1hX3ZlcnNpb24YASABKA1SDXNjaGVtYVZlcnNpb24SLgoTc3RyYX'
    'RlZ3lfdmVyc2lvbl9pZBgCIAEoCVIRc3RyYXRlZ3lWZXJzaW9uSWQSNQoKaW5zdHJ1bWVudBgD'
    'IAEoCzIVLmxhYi52MS5JbnN0cnVtZW50S2V5UgppbnN0cnVtZW50Ei0KE29ic2VydmVkX2F0X3'
    'VuaXhfbXMYBCABKANSEG9ic2VydmVkQXRVbml4TXMSMgoTdmFsaWRfdW50aWxfdW5peF9tcxgF'
    'IAEoA0gAUhB2YWxpZFVudGlsVW5peE1ziAEBEjgKD3RhcmdldF9leHBvc3VyZRgGIAEoCzIPLm'
    'xhYi52MS5EZWNpbWFsUg50YXJnZXRFeHBvc3VyZRIWCgZyZWFzb24YByABKAlSBnJlYXNvbkIW'
    'ChRfdmFsaWRfdW50aWxfdW5peF9tcw==');

@$core.Deprecated('Use strategyCapabilityDescriptor instead')
const StrategyCapability$json = {
  '1': 'StrategyCapability',
  '2': [
    {
      '1': 'products',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.lab.v1.MarketProduct',
      '10': 'products'
    },
    {
      '1': 'environments',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.lab.v1.Environment',
      '10': 'environments'
    },
  ],
};

/// Descriptor for `StrategyCapability`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List strategyCapabilityDescriptor = $convert.base64Decode(
    'ChJTdHJhdGVneUNhcGFiaWxpdHkSMQoIcHJvZHVjdHMYASADKA4yFS5sYWIudjEuTWFya2V0UH'
    'JvZHVjdFIIcHJvZHVjdHMSNwoMZW52aXJvbm1lbnRzGAIgAygOMhMubGFiLnYxLkVudmlyb25t'
    'ZW50UgxlbnZpcm9ubWVudHM=');
