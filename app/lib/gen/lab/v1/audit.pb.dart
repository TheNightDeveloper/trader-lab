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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'audit.pbenum.dart';
import 'workspace.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'audit.pbenum.dart';

enum AuditCursor_Scope { account, strategyVersionId, notSet }

/// AuditCursor is valid only in its stream. Sequence is ordered within that stream.
class AuditCursor extends $pb.GeneratedMessage {
  factory AuditCursor({
    $0.AccountRef? account,
    $core.String? strategyVersionId,
    $fixnum.Int64? sequence,
  }) {
    final result = AuditCursor._();
    if (account != null) result.account = account;
    if (strategyVersionId != null) result.strategyVersionId = strategyVersionId;
    if (sequence != null) result.sequence = sequence;
    return result;
  }

  AuditCursor._();

  factory AuditCursor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AuditCursor()..mergeFromBuffer(data, registry);
  factory AuditCursor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AuditCursor()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AuditCursor_Scope> _AuditCursor_ScopeByTag =
      {
    1: AuditCursor_Scope.account,
    2: AuditCursor_Scope.strategyVersionId,
    0: AuditCursor_Scope.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuditCursor',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AuditCursor.$_createMessage)
    ..oo(0, [1, 2])
    ..aOM<$0.AccountRef>(1, _omitFieldNames ? '' : 'account',
        subBuilder: $0.AccountRef.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'strategyVersionId')
    ..aInt64(3, _omitFieldNames ? '' : 'sequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuditCursor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuditCursor copyWith(void Function(AuditCursor) updates) =>
      super.copyWith((message) => updates(message as AuditCursor))
          as AuditCursor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AuditCursor() / AuditCursor.new instead')
  static AuditCursor create() => AuditCursor._();
  static $pb.GeneratedMessage $_createMessage() => AuditCursor._();
  @$core.override
  AuditCursor createEmptyInstance() => AuditCursor._();
  @$core.pragma('dart2js:noInline')
  static AuditCursor getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuditCursor>(
          AuditCursor.$_createMessage);
  static AuditCursor? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  AuditCursor_Scope whichScope() => _AuditCursor_ScopeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearScope() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.AccountRef get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($0.AccountRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.AccountRef ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get strategyVersionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set strategyVersionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStrategyVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStrategyVersionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sequence => $_getI64(2);
  @$pb.TagNumber(3)
  set sequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearSequence() => $_clearField(3);
}

/// AuditEvent supplies the shared identity, actor and timestamp for a domain event.
class AuditEvent extends $pb.GeneratedMessage {
  factory AuditEvent({
    AuditCursor? cursor,
    AuditActor? actor,
    $fixnum.Int64? recordedAtUnixMs,
  }) {
    final result = AuditEvent._();
    if (cursor != null) result.cursor = cursor;
    if (actor != null) result.actor = actor;
    if (recordedAtUnixMs != null) result.recordedAtUnixMs = recordedAtUnixMs;
    return result;
  }

  AuditEvent._();

  factory AuditEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AuditEvent()..mergeFromBuffer(data, registry);
  factory AuditEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AuditEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuditEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: AuditEvent.$_createMessage)
    ..aOM<AuditCursor>(1, _omitFieldNames ? '' : 'cursor',
        subBuilder: AuditCursor.$_createMessage)
    ..aE<AuditActor>(2, _omitFieldNames ? '' : 'actor',
        enumValues: AuditActor.values)
    ..aInt64(3, _omitFieldNames ? '' : 'recordedAtUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuditEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuditEvent copyWith(void Function(AuditEvent) updates) =>
      super.copyWith((message) => updates(message as AuditEvent)) as AuditEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AuditEvent() / AuditEvent.new instead')
  static AuditEvent create() => AuditEvent._();
  static $pb.GeneratedMessage $_createMessage() => AuditEvent._();
  @$core.override
  AuditEvent createEmptyInstance() => AuditEvent._();
  @$core.pragma('dart2js:noInline')
  static AuditEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuditEvent>(AuditEvent.$_createMessage);
  static AuditEvent? _defaultInstance;

  @$pb.TagNumber(1)
  AuditCursor get cursor => $_getN(0);
  @$pb.TagNumber(1)
  set cursor(AuditCursor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);
  @$pb.TagNumber(1)
  AuditCursor ensureCursor() => $_ensure(0);

  @$pb.TagNumber(2)
  AuditActor get actor => $_getN(1);
  @$pb.TagNumber(2)
  set actor(AuditActor value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasActor() => $_has(1);
  @$pb.TagNumber(2)
  void clearActor() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get recordedAtUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set recordedAtUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordedAtUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordedAtUnixMs() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
