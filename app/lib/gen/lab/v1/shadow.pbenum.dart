// This is a generated file - do not edit.
//
// Generated from lab/v1/shadow.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ShadowState extends $pb.ProtobufEnum {
  static const ShadowState SHADOW_STATE_UNSPECIFIED =
      ShadowState._(0, _omitEnumNames ? '' : 'SHADOW_STATE_UNSPECIFIED');
  static const ShadowState SHADOW_STATE_ACTIVE =
      ShadowState._(1, _omitEnumNames ? '' : 'SHADOW_STATE_ACTIVE');
  static const ShadowState SHADOW_STATE_COMPLETE =
      ShadowState._(2, _omitEnumNames ? '' : 'SHADOW_STATE_COMPLETE');
  static const ShadowState SHADOW_STATE_STOPPED =
      ShadowState._(3, _omitEnumNames ? '' : 'SHADOW_STATE_STOPPED');
  static const ShadowState SHADOW_STATE_GAP =
      ShadowState._(4, _omitEnumNames ? '' : 'SHADOW_STATE_GAP');
  static const ShadowState SHADOW_STATE_BUILD_CHANGED =
      ShadowState._(5, _omitEnumNames ? '' : 'SHADOW_STATE_BUILD_CHANGED');

  static const $core.List<ShadowState> values = <ShadowState>[
    SHADOW_STATE_UNSPECIFIED,
    SHADOW_STATE_ACTIVE,
    SHADOW_STATE_COMPLETE,
    SHADOW_STATE_STOPPED,
    SHADOW_STATE_GAP,
    SHADOW_STATE_BUILD_CHANGED,
  ];

  static final $core.List<ShadowState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ShadowState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ShadowState._(super.value, super.name);
}

class ShadowGate extends $pb.ProtobufEnum {
  static const ShadowGate SHADOW_GATE_UNSPECIFIED =
      ShadowGate._(0, _omitEnumNames ? '' : 'SHADOW_GATE_UNSPECIFIED');
  static const ShadowGate SHADOW_GATE_NO_SIGNAL =
      ShadowGate._(1, _omitEnumNames ? '' : 'SHADOW_GATE_NO_SIGNAL');
  static const ShadowGate SHADOW_GATE_PENDING =
      ShadowGate._(2, _omitEnumNames ? '' : 'SHADOW_GATE_PENDING');
  static const ShadowGate SHADOW_GATE_ALLOW =
      ShadowGate._(3, _omitEnumNames ? '' : 'SHADOW_GATE_ALLOW');
  static const ShadowGate SHADOW_GATE_BLOCK =
      ShadowGate._(4, _omitEnumNames ? '' : 'SHADOW_GATE_BLOCK');
  static const ShadowGate SHADOW_GATE_UNAVAILABLE =
      ShadowGate._(5, _omitEnumNames ? '' : 'SHADOW_GATE_UNAVAILABLE');

  static const $core.List<ShadowGate> values = <ShadowGate>[
    SHADOW_GATE_UNSPECIFIED,
    SHADOW_GATE_NO_SIGNAL,
    SHADOW_GATE_PENDING,
    SHADOW_GATE_ALLOW,
    SHADOW_GATE_BLOCK,
    SHADOW_GATE_UNAVAILABLE,
  ];

  static final $core.List<ShadowGate?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ShadowGate? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ShadowGate._(super.value, super.name);
}

class ShadowUserDecision extends $pb.ProtobufEnum {
  static const ShadowUserDecision SHADOW_USER_DECISION_UNSPECIFIED =
      ShadowUserDecision._(
          0, _omitEnumNames ? '' : 'SHADOW_USER_DECISION_UNSPECIFIED');
  static const ShadowUserDecision SHADOW_USER_DECISION_OPEN =
      ShadowUserDecision._(
          1, _omitEnumNames ? '' : 'SHADOW_USER_DECISION_OPEN');
  static const ShadowUserDecision SHADOW_USER_DECISION_ALLOW =
      ShadowUserDecision._(
          2, _omitEnumNames ? '' : 'SHADOW_USER_DECISION_ALLOW');
  static const ShadowUserDecision SHADOW_USER_DECISION_SKIP =
      ShadowUserDecision._(
          3, _omitEnumNames ? '' : 'SHADOW_USER_DECISION_SKIP');
  static const ShadowUserDecision SHADOW_USER_DECISION_UNANSWERED =
      ShadowUserDecision._(
          4, _omitEnumNames ? '' : 'SHADOW_USER_DECISION_UNANSWERED');

  static const $core.List<ShadowUserDecision> values = <ShadowUserDecision>[
    SHADOW_USER_DECISION_UNSPECIFIED,
    SHADOW_USER_DECISION_OPEN,
    SHADOW_USER_DECISION_ALLOW,
    SHADOW_USER_DECISION_SKIP,
    SHADOW_USER_DECISION_UNANSWERED,
  ];

  static final $core.List<ShadowUserDecision?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ShadowUserDecision? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ShadowUserDecision._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
