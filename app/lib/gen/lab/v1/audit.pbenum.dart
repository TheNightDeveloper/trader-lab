// This is a generated file - do not edit.
//
// Generated from lab/v1/audit.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AuditActor extends $pb.ProtobufEnum {
  static const AuditActor AUDIT_ACTOR_UNSPECIFIED =
      AuditActor._(0, _omitEnumNames ? '' : 'AUDIT_ACTOR_UNSPECIFIED');
  static const AuditActor AUDIT_ACTOR_USER =
      AuditActor._(1, _omitEnumNames ? '' : 'AUDIT_ACTOR_USER');
  static const AuditActor AUDIT_ACTOR_SYSTEM =
      AuditActor._(2, _omitEnumNames ? '' : 'AUDIT_ACTOR_SYSTEM');

  static const $core.List<AuditActor> values = <AuditActor>[
    AUDIT_ACTOR_UNSPECIFIED,
    AUDIT_ACTOR_USER,
    AUDIT_ACTOR_SYSTEM,
  ];

  static final $core.List<AuditActor?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AuditActor? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuditActor._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
