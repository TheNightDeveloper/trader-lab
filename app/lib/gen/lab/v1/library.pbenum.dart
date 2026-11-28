// This is a generated file - do not edit.
//
// Generated from lab/v1/library.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RuleEvidenceFilter extends $pb.ProtobufEnum {
  static const RuleEvidenceFilter RULE_EVIDENCE_FILTER_UNSPECIFIED =
      RuleEvidenceFilter._(
          0, _omitEnumNames ? '' : 'RULE_EVIDENCE_FILTER_UNSPECIFIED');
  static const RuleEvidenceFilter RULE_EVIDENCE_FILTER_WITH_REPORT =
      RuleEvidenceFilter._(
          1, _omitEnumNames ? '' : 'RULE_EVIDENCE_FILTER_WITH_REPORT');
  static const RuleEvidenceFilter RULE_EVIDENCE_FILTER_WITHOUT_REPORT =
      RuleEvidenceFilter._(
          2, _omitEnumNames ? '' : 'RULE_EVIDENCE_FILTER_WITHOUT_REPORT');

  static const $core.List<RuleEvidenceFilter> values = <RuleEvidenceFilter>[
    RULE_EVIDENCE_FILTER_UNSPECIFIED,
    RULE_EVIDENCE_FILTER_WITH_REPORT,
    RULE_EVIDENCE_FILTER_WITHOUT_REPORT,
  ];

  static final $core.List<RuleEvidenceFilter?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static RuleEvidenceFilter? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RuleEvidenceFilter._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
