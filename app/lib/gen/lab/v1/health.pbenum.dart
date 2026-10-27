// This is a generated file - do not edit.
//
// Generated from lab/v1/health.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RunMode extends $pb.ProtobufEnum {
  static const RunMode RUN_MODE_UNSPECIFIED = RunMode._(0, _omitEnumNames ? '' : 'RUN_MODE_UNSPECIFIED');
  static const RunMode RUN_MODE_RESEARCH = RunMode._(1, _omitEnumNames ? '' : 'RUN_MODE_RESEARCH');

  static const $core.List<RunMode> values = <RunMode>[
    RUN_MODE_UNSPECIFIED,
    RUN_MODE_RESEARCH,
  ];

  static final $core.List<RunMode?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static RunMode? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RunMode._(super.value, super.name);
}

class LiveState extends $pb.ProtobufEnum {
  static const LiveState LIVE_STATE_UNSPECIFIED = LiveState._(0, _omitEnumNames ? '' : 'LIVE_STATE_UNSPECIFIED');
  static const LiveState LIVE_STATE_OFF = LiveState._(1, _omitEnumNames ? '' : 'LIVE_STATE_OFF');
  static const LiveState LIVE_STATE_FRESH = LiveState._(2, _omitEnumNames ? '' : 'LIVE_STATE_FRESH');
  static const LiveState LIVE_STATE_STALE = LiveState._(3, _omitEnumNames ? '' : 'LIVE_STATE_STALE');
  static const LiveState LIVE_STATE_RECONNECTING = LiveState._(4, _omitEnumNames ? '' : 'LIVE_STATE_RECONNECTING');

  static const $core.List<LiveState> values = <LiveState>[
    LIVE_STATE_UNSPECIFIED,
    LIVE_STATE_OFF,
    LIVE_STATE_FRESH,
    LIVE_STATE_STALE,
    LIVE_STATE_RECONNECTING,
  ];

  static final $core.List<LiveState?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 4);
  static LiveState? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LiveState._(super.value, super.name);
}

class WorkerState extends $pb.ProtobufEnum {
  static const WorkerState WORKER_STATE_UNSPECIFIED =
      WorkerState._(0, _omitEnumNames ? '' : 'WORKER_STATE_UNSPECIFIED');
  static const WorkerState WORKER_STATE_RUNNING = WorkerState._(1, _omitEnumNames ? '' : 'WORKER_STATE_RUNNING');
  static const WorkerState WORKER_STATE_PAUSED = WorkerState._(2, _omitEnumNames ? '' : 'WORKER_STATE_PAUSED');

  static const $core.List<WorkerState> values = <WorkerState>[
    WORKER_STATE_UNSPECIFIED,
    WORKER_STATE_RUNNING,
    WORKER_STATE_PAUSED,
  ];

  static final $core.List<WorkerState?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static WorkerState? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkerState._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
