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

class DraftQuestion extends $pb.ProtobufEnum {
  static const DraftQuestion DRAFT_QUESTION_UNSPECIFIED =
      DraftQuestion._(0, _omitEnumNames ? '' : 'DRAFT_QUESTION_UNSPECIFIED');
  static const DraftQuestion DRAFT_QUESTION_ENTRY =
      DraftQuestion._(1, _omitEnumNames ? '' : 'DRAFT_QUESTION_ENTRY');
  static const DraftQuestion DRAFT_QUESTION_EXIT =
      DraftQuestion._(2, _omitEnumNames ? '' : 'DRAFT_QUESTION_EXIT');
  static const DraftQuestion DRAFT_QUESTION_EXPOSURE =
      DraftQuestion._(3, _omitEnumNames ? '' : 'DRAFT_QUESTION_EXPOSURE');
  static const DraftQuestion DRAFT_QUESTION_TIMEFRAME =
      DraftQuestion._(4, _omitEnumNames ? '' : 'DRAFT_QUESTION_TIMEFRAME');
  static const DraftQuestion DRAFT_QUESTION_UNSUPPORTED =
      DraftQuestion._(5, _omitEnumNames ? '' : 'DRAFT_QUESTION_UNSUPPORTED');
  static const DraftQuestion DRAFT_QUESTION_PARAMETERS =
      DraftQuestion._(6, _omitEnumNames ? '' : 'DRAFT_QUESTION_PARAMETERS');

  static const $core.List<DraftQuestion> values = <DraftQuestion>[
    DRAFT_QUESTION_UNSPECIFIED,
    DRAFT_QUESTION_ENTRY,
    DRAFT_QUESTION_EXIT,
    DRAFT_QUESTION_EXPOSURE,
    DRAFT_QUESTION_TIMEFRAME,
    DRAFT_QUESTION_UNSUPPORTED,
    DRAFT_QUESTION_PARAMETERS,
  ];

  static final $core.List<DraftQuestion?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static DraftQuestion? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DraftQuestion._(super.value, super.name);
}

class ResearchFocus extends $pb.ProtobufEnum {
  static const ResearchFocus RESEARCH_FOCUS_UNSPECIFIED =
      ResearchFocus._(0, _omitEnumNames ? '' : 'RESEARCH_FOCUS_UNSPECIFIED');
  static const ResearchFocus RESEARCH_FOCUS_ASSUMPTIONS =
      ResearchFocus._(1, _omitEnumNames ? '' : 'RESEARCH_FOCUS_ASSUMPTIONS');
  static const ResearchFocus RESEARCH_FOCUS_RETURN =
      ResearchFocus._(2, _omitEnumNames ? '' : 'RESEARCH_FOCUS_RETURN');
  static const ResearchFocus RESEARCH_FOCUS_DRAWDOWN =
      ResearchFocus._(3, _omitEnumNames ? '' : 'RESEARCH_FOCUS_DRAWDOWN');
  static const ResearchFocus RESEARCH_FOCUS_SAMPLE =
      ResearchFocus._(4, _omitEnumNames ? '' : 'RESEARCH_FOCUS_SAMPLE');

  static const $core.List<ResearchFocus> values = <ResearchFocus>[
    RESEARCH_FOCUS_UNSPECIFIED,
    RESEARCH_FOCUS_ASSUMPTIONS,
    RESEARCH_FOCUS_RETURN,
    RESEARCH_FOCUS_DRAWDOWN,
    RESEARCH_FOCUS_SAMPLE,
  ];

  static final $core.List<ResearchFocus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ResearchFocus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ResearchFocus._(super.value, super.name);
}

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
