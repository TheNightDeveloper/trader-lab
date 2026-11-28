// This is a generated file - do not edit.
//
// Generated from lab/v1/assistant.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ExplanationFocus extends $pb.ProtobufEnum {
  static const ExplanationFocus EXPLANATION_FOCUS_UNSPECIFIED =
      ExplanationFocus._(
          0, _omitEnumNames ? '' : 'EXPLANATION_FOCUS_UNSPECIFIED');
  static const ExplanationFocus EXPLANATION_FOCUS_RULE =
      ExplanationFocus._(1, _omitEnumNames ? '' : 'EXPLANATION_FOCUS_RULE');
  static const ExplanationFocus EXPLANATION_FOCUS_SNAPSHOT =
      ExplanationFocus._(2, _omitEnumNames ? '' : 'EXPLANATION_FOCUS_SNAPSHOT');
  static const ExplanationFocus EXPLANATION_FOCUS_REPORT =
      ExplanationFocus._(3, _omitEnumNames ? '' : 'EXPLANATION_FOCUS_REPORT');

  static const $core.List<ExplanationFocus> values = <ExplanationFocus>[
    EXPLANATION_FOCUS_UNSPECIFIED,
    EXPLANATION_FOCUS_RULE,
    EXPLANATION_FOCUS_SNAPSHOT,
    EXPLANATION_FOCUS_REPORT,
  ];

  static final $core.List<ExplanationFocus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ExplanationFocus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExplanationFocus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
