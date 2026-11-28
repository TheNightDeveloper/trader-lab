// This is a generated file - do not edit.
//
// Generated from lab/v1/report.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EvidenceStatus extends $pb.ProtobufEnum {
  static const EvidenceStatus EVIDENCE_STATUS_UNSPECIFIED =
      EvidenceStatus._(0, _omitEnumNames ? '' : 'EVIDENCE_STATUS_UNSPECIFIED');
  static const EvidenceStatus EVIDENCE_STATUS_RECORDED =
      EvidenceStatus._(1, _omitEnumNames ? '' : 'EVIDENCE_STATUS_RECORDED');
  static const EvidenceStatus EVIDENCE_STATUS_INCOMPLETE =
      EvidenceStatus._(2, _omitEnumNames ? '' : 'EVIDENCE_STATUS_INCOMPLETE');
  static const EvidenceStatus EVIDENCE_STATUS_LEGACY =
      EvidenceStatus._(3, _omitEnumNames ? '' : 'EVIDENCE_STATUS_LEGACY');
  static const EvidenceStatus EVIDENCE_STATUS_LOCAL_BUILD =
      EvidenceStatus._(4, _omitEnumNames ? '' : 'EVIDENCE_STATUS_LOCAL_BUILD');

  static const $core.List<EvidenceStatus> values = <EvidenceStatus>[
    EVIDENCE_STATUS_UNSPECIFIED,
    EVIDENCE_STATUS_RECORDED,
    EVIDENCE_STATUS_INCOMPLETE,
    EVIDENCE_STATUS_LEGACY,
    EVIDENCE_STATUS_LOCAL_BUILD,
  ];

  static final $core.List<EvidenceStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EvidenceStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EvidenceStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
