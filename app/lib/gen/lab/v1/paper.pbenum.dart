// This is a generated file - do not edit.
//
// Generated from lab/v1/paper.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PaperEntryState extends $pb.ProtobufEnum {
  static const PaperEntryState PAPER_ENTRY_STATE_UNSPECIFIED =
      PaperEntryState._(
          0, _omitEnumNames ? '' : 'PAPER_ENTRY_STATE_UNSPECIFIED');
  static const PaperEntryState PAPER_ENTRY_STATE_PENDING =
      PaperEntryState._(1, _omitEnumNames ? '' : 'PAPER_ENTRY_STATE_PENDING');
  static const PaperEntryState PAPER_ENTRY_STATE_PARTIAL =
      PaperEntryState._(2, _omitEnumNames ? '' : 'PAPER_ENTRY_STATE_PARTIAL');
  static const PaperEntryState PAPER_ENTRY_STATE_FILLED =
      PaperEntryState._(3, _omitEnumNames ? '' : 'PAPER_ENTRY_STATE_FILLED');
  static const PaperEntryState PAPER_ENTRY_STATE_CANCELLED =
      PaperEntryState._(4, _omitEnumNames ? '' : 'PAPER_ENTRY_STATE_CANCELLED');
  static const PaperEntryState PAPER_ENTRY_STATE_EXPIRED =
      PaperEntryState._(5, _omitEnumNames ? '' : 'PAPER_ENTRY_STATE_EXPIRED');

  static const $core.List<PaperEntryState> values = <PaperEntryState>[
    PAPER_ENTRY_STATE_UNSPECIFIED,
    PAPER_ENTRY_STATE_PENDING,
    PAPER_ENTRY_STATE_PARTIAL,
    PAPER_ENTRY_STATE_FILLED,
    PAPER_ENTRY_STATE_CANCELLED,
    PAPER_ENTRY_STATE_EXPIRED,
  ];

  static final $core.List<PaperEntryState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PaperEntryState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PaperEntryState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
