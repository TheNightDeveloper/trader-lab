// This is a generated file - do not edit.
//
// Generated from lab/v1/chart.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;
import 'report.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetChartRequest extends $pb.GeneratedMessage {
  factory GetChartRequest({
    $core.String? reportId,
    $core.String? symbol,
    $core.String? timeframe,
    $core.Iterable<$core.String>? indicators,
    $core.int? maxBars,
  }) {
    final result = GetChartRequest._();
    if (reportId != null) result.reportId = reportId;
    if (symbol != null) result.symbol = symbol;
    if (timeframe != null) result.timeframe = timeframe;
    if (indicators != null) result.indicators.addAll(indicators);
    if (maxBars != null) result.maxBars = maxBars;
    return result;
  }

  GetChartRequest._();

  factory GetChartRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChartRequest()..mergeFromBuffer(data, registry);
  factory GetChartRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChartRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChartRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetChartRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aOS(2, _omitFieldNames ? '' : 'symbol')
    ..aOS(3, _omitFieldNames ? '' : 'timeframe')
    ..pPS(4, _omitFieldNames ? '' : 'indicators')
    ..aI(5, _omitFieldNames ? '' : 'maxBars')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChartRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChartRequest copyWith(void Function(GetChartRequest) updates) =>
      super.copyWith((message) => updates(message as GetChartRequest))
          as GetChartRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetChartRequest() / GetChartRequest.new instead')
  static GetChartRequest create() => GetChartRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetChartRequest._();
  @$core.override
  GetChartRequest createEmptyInstance() => GetChartRequest._();
  @$core.pragma('dart2js:noInline')
  static GetChartRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetChartRequest>(
          GetChartRequest.$_createMessage);
  static GetChartRequest? _defaultInstance;

  /// With a report: its dataset bars for symbol, and its decisions as markers.
  /// Without: the latest bars of symbol at timeframe.
  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get symbol => $_getSZ(1);
  @$pb.TagNumber(2)
  set symbol($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSymbol() => $_has(1);
  @$pb.TagNumber(2)
  void clearSymbol() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get timeframe => $_getSZ(2);
  @$pb.TagNumber(3)
  set timeframe($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeframe() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeframe() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get indicators => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get maxBars => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxBars($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxBars() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxBars() => $_clearField(5);
}

class ChartBar extends $pb.GeneratedMessage {
  factory ChartBar({
    $fixnum.Int64? openUnixMs,
    $0.Decimal? open,
    $0.Decimal? high,
    $0.Decimal? low,
    $0.Decimal? close,
    $0.Decimal? volume,
  }) {
    final result = ChartBar._();
    if (openUnixMs != null) result.openUnixMs = openUnixMs;
    if (open != null) result.open = open;
    if (high != null) result.high = high;
    if (low != null) result.low = low;
    if (close != null) result.close = close;
    if (volume != null) result.volume = volume;
    return result;
  }

  ChartBar._();

  factory ChartBar.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChartBar()..mergeFromBuffer(data, registry);
  factory ChartBar.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChartBar()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartBar',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ChartBar.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'openUnixMs')
    ..aOM<$0.Decimal>(2, _omitFieldNames ? '' : 'open',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(3, _omitFieldNames ? '' : 'high',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(4, _omitFieldNames ? '' : 'low',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(5, _omitFieldNames ? '' : 'close',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOM<$0.Decimal>(6, _omitFieldNames ? '' : 'volume',
        subBuilder: $0.Decimal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartBar clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartBar copyWith(void Function(ChartBar) updates) =>
      super.copyWith((message) => updates(message as ChartBar)) as ChartBar;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChartBar() / ChartBar.new instead')
  static ChartBar create() => ChartBar._();
  static $pb.GeneratedMessage $_createMessage() => ChartBar._();
  @$core.override
  ChartBar createEmptyInstance() => ChartBar._();
  @$core.pragma('dart2js:noInline')
  static ChartBar getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartBar>(ChartBar.$_createMessage);
  static ChartBar? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get openUnixMs => $_getI64(0);
  @$pb.TagNumber(1)
  set openUnixMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpenUnixMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpenUnixMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Decimal get open => $_getN(1);
  @$pb.TagNumber(2)
  set open($0.Decimal value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpen() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpen() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Decimal ensureOpen() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Decimal get high => $_getN(2);
  @$pb.TagNumber(3)
  set high($0.Decimal value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasHigh() => $_has(2);
  @$pb.TagNumber(3)
  void clearHigh() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Decimal ensureHigh() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Decimal get low => $_getN(3);
  @$pb.TagNumber(4)
  set low($0.Decimal value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLow() => $_has(3);
  @$pb.TagNumber(4)
  void clearLow() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Decimal ensureLow() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Decimal get close => $_getN(4);
  @$pb.TagNumber(5)
  set close($0.Decimal value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasClose() => $_has(4);
  @$pb.TagNumber(5)
  void clearClose() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Decimal ensureClose() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Decimal get volume => $_getN(5);
  @$pb.TagNumber(6)
  set volume($0.Decimal value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVolume() => $_has(5);
  @$pb.TagNumber(6)
  void clearVolume() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Decimal ensureVolume() => $_ensure(5);
}

class IndicatorLine extends $pb.GeneratedMessage {
  factory IndicatorLine({
    $core.String? name,
    $core.Iterable<$core.String>? values,
  }) {
    final result = IndicatorLine._();
    if (name != null) result.name = name;
    if (values != null) result.values.addAll(values);
    return result;
  }

  IndicatorLine._();

  factory IndicatorLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IndicatorLine()..mergeFromBuffer(data, registry);
  factory IndicatorLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IndicatorLine()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IndicatorLine',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: IndicatorLine.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..pPS(2, _omitFieldNames ? '' : 'values')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorLine copyWith(void Function(IndicatorLine) updates) =>
      super.copyWith((message) => updates(message as IndicatorLine))
          as IndicatorLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IndicatorLine() / IndicatorLine.new instead')
  static IndicatorLine create() => IndicatorLine._();
  static $pb.GeneratedMessage $_createMessage() => IndicatorLine._();
  @$core.override
  IndicatorLine createEmptyInstance() => IndicatorLine._();
  @$core.pragma('dart2js:noInline')
  static IndicatorLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IndicatorLine>(
          IndicatorLine.$_createMessage);
  static IndicatorLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Aligned with bars; "" while the indicator is not defined yet (warm-up).
  /// Decimal strings at 8 decimals, from the engine's computation.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get values => $_getList(1);
}

class ChartIndicator extends $pb.GeneratedMessage {
  factory ChartIndicator({
    $core.String? key,
    $core.String? label,
    $core.String? pane,
    $core.Iterable<IndicatorLine>? lines,
  }) {
    final result = ChartIndicator._();
    if (key != null) result.key = key;
    if (label != null) result.label = label;
    if (pane != null) result.pane = pane;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  ChartIndicator._();

  factory ChartIndicator.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChartIndicator()..mergeFromBuffer(data, registry);
  factory ChartIndicator.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChartIndicator()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartIndicator',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ChartIndicator.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'pane')
    ..pPM<IndicatorLine>(4, _omitFieldNames ? '' : 'lines',
        subBuilder: IndicatorLine.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartIndicator clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartIndicator copyWith(void Function(ChartIndicator) updates) =>
      super.copyWith((message) => updates(message as ChartIndicator))
          as ChartIndicator;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChartIndicator() / ChartIndicator.new instead')
  static ChartIndicator create() => ChartIndicator._();
  static $pb.GeneratedMessage $_createMessage() => ChartIndicator._();
  @$core.override
  ChartIndicator createEmptyInstance() => ChartIndicator._();
  @$core.pragma('dart2js:noInline')
  static ChartIndicator getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChartIndicator>(
          ChartIndicator.$_createMessage);
  static ChartIndicator? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pane => $_getSZ(2);
  @$pb.TagNumber(3)
  set pane($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPane() => $_has(2);
  @$pb.TagNumber(3)
  void clearPane() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<IndicatorLine> get lines => $_getList(3);
}

class ChartMarker extends $pb.GeneratedMessage {
  factory ChartMarker({
    $core.int? decisionId,
    $fixnum.Int64? barOpenUnixMs,
    $core.String? kind,
    $0.Decimal? price,
    $core.String? detail,
  }) {
    final result = ChartMarker._();
    if (decisionId != null) result.decisionId = decisionId;
    if (barOpenUnixMs != null) result.barOpenUnixMs = barOpenUnixMs;
    if (kind != null) result.kind = kind;
    if (price != null) result.price = price;
    if (detail != null) result.detail = detail;
    return result;
  }

  ChartMarker._();

  factory ChartMarker.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChartMarker()..mergeFromBuffer(data, registry);
  factory ChartMarker.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChartMarker()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartMarker',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: ChartMarker.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'decisionId')
    ..aInt64(2, _omitFieldNames ? '' : 'barOpenUnixMs')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aOM<$0.Decimal>(4, _omitFieldNames ? '' : 'price',
        subBuilder: $0.Decimal.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartMarker clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartMarker copyWith(void Function(ChartMarker) updates) =>
      super.copyWith((message) => updates(message as ChartMarker))
          as ChartMarker;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChartMarker() / ChartMarker.new instead')
  static ChartMarker create() => ChartMarker._();
  static $pb.GeneratedMessage $_createMessage() => ChartMarker._();
  @$core.override
  ChartMarker createEmptyInstance() => ChartMarker._();
  @$core.pragma('dart2js:noInline')
  static ChartMarker getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChartMarker>(
          ChartMarker.$_createMessage);
  static ChartMarker? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get decisionId => $_getIZ(0);
  @$pb.TagNumber(1)
  set decisionId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDecisionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDecisionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get barOpenUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set barOpenUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBarOpenUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearBarOpenUnixMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Decimal get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($0.Decimal value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Decimal ensurePrice() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get detail => $_getSZ(4);
  @$pb.TagNumber(5)
  set detail($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => $_clearField(5);
}

class GetChartResponse extends $pb.GeneratedMessage {
  factory GetChartResponse({
    $core.String? symbol,
    $core.String? timeframe,
    $core.int? pricePrecision,
    $core.Iterable<ChartBar>? bars,
    $core.Iterable<ChartIndicator>? indicators,
    $core.Iterable<ChartMarker>? markers,
    $core.String? reportTitle,
    $core.Iterable<$core.String>? symbols,
    $core.int? totalBars,
  }) {
    final result = GetChartResponse._();
    if (symbol != null) result.symbol = symbol;
    if (timeframe != null) result.timeframe = timeframe;
    if (pricePrecision != null) result.pricePrecision = pricePrecision;
    if (bars != null) result.bars.addAll(bars);
    if (indicators != null) result.indicators.addAll(indicators);
    if (markers != null) result.markers.addAll(markers);
    if (reportTitle != null) result.reportTitle = reportTitle;
    if (symbols != null) result.symbols.addAll(symbols);
    if (totalBars != null) result.totalBars = totalBars;
    return result;
  }

  GetChartResponse._();

  factory GetChartResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChartResponse()..mergeFromBuffer(data, registry);
  factory GetChartResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChartResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChartResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetChartResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aOS(2, _omitFieldNames ? '' : 'timeframe')
    ..aI(3, _omitFieldNames ? '' : 'pricePrecision')
    ..pPM<ChartBar>(4, _omitFieldNames ? '' : 'bars',
        subBuilder: ChartBar.$_createMessage)
    ..pPM<ChartIndicator>(5, _omitFieldNames ? '' : 'indicators',
        subBuilder: ChartIndicator.$_createMessage)
    ..pPM<ChartMarker>(6, _omitFieldNames ? '' : 'markers',
        subBuilder: ChartMarker.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'reportTitle')
    ..pPS(8, _omitFieldNames ? '' : 'symbols')
    ..aI(9, _omitFieldNames ? '' : 'totalBars')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChartResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChartResponse copyWith(void Function(GetChartResponse) updates) =>
      super.copyWith((message) => updates(message as GetChartResponse))
          as GetChartResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetChartResponse() / GetChartResponse.new instead')
  static GetChartResponse create() => GetChartResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetChartResponse._();
  @$core.override
  GetChartResponse createEmptyInstance() => GetChartResponse._();
  @$core.pragma('dart2js:noInline')
  static GetChartResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetChartResponse>(
          GetChartResponse.$_createMessage);
  static GetChartResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get timeframe => $_getSZ(1);
  @$pb.TagNumber(2)
  set timeframe($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeframe() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeframe() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pricePrecision => $_getIZ(2);
  @$pb.TagNumber(3)
  set pricePrecision($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPricePrecision() => $_has(2);
  @$pb.TagNumber(3)
  void clearPricePrecision() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ChartBar> get bars => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<ChartIndicator> get indicators => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<ChartMarker> get markers => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get reportTitle => $_getSZ(6);
  @$pb.TagNumber(7)
  set reportTitle($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReportTitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearReportTitle() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get symbols => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get totalBars => $_getIZ(8);
  @$pb.TagNumber(9)
  set totalBars($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotalBars() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalBars() => $_clearField(9);
}

class GetDecisionRequest extends $pb.GeneratedMessage {
  factory GetDecisionRequest({
    $core.String? reportId,
    $core.int? decisionId,
  }) {
    final result = GetDecisionRequest._();
    if (reportId != null) result.reportId = reportId;
    if (decisionId != null) result.decisionId = decisionId;
    return result;
  }

  GetDecisionRequest._();

  factory GetDecisionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDecisionRequest()..mergeFromBuffer(data, registry);
  factory GetDecisionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDecisionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDecisionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetDecisionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aI(2, _omitFieldNames ? '' : 'decisionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDecisionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDecisionRequest copyWith(void Function(GetDecisionRequest) updates) =>
      super.copyWith((message) => updates(message as GetDecisionRequest))
          as GetDecisionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetDecisionRequest() / GetDecisionRequest.new instead')
  static GetDecisionRequest create() => GetDecisionRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetDecisionRequest._();
  @$core.override
  GetDecisionRequest createEmptyInstance() => GetDecisionRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDecisionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDecisionRequest>(
          GetDecisionRequest.$_createMessage);
  static GetDecisionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get decisionId => $_getIZ(1);
  @$pb.TagNumber(2)
  set decisionId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDecisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDecisionId() => $_clearField(2);
}

class GetDecisionResponse extends $pb.GeneratedMessage {
  factory GetDecisionResponse({
    $1.DecisionRow? decision,
    $0.Money? refPrice,
  }) {
    final result = GetDecisionResponse._();
    if (decision != null) result.decision = decision;
    if (refPrice != null) result.refPrice = refPrice;
    return result;
  }

  GetDecisionResponse._();

  factory GetDecisionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDecisionResponse()..mergeFromBuffer(data, registry);
  factory GetDecisionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDecisionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDecisionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'lab.v1'),
      createEmptyInstance: GetDecisionResponse.$_createMessage)
    ..aOM<$1.DecisionRow>(1, _omitFieldNames ? '' : 'decision',
        subBuilder: $1.DecisionRow.$_createMessage)
    ..aOM<$0.Money>(2, _omitFieldNames ? '' : 'refPrice',
        subBuilder: $0.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDecisionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDecisionResponse copyWith(void Function(GetDecisionResponse) updates) =>
      super.copyWith((message) => updates(message as GetDecisionResponse))
          as GetDecisionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetDecisionResponse() / GetDecisionResponse.new instead')
  static GetDecisionResponse create() => GetDecisionResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetDecisionResponse._();
  @$core.override
  GetDecisionResponse createEmptyInstance() => GetDecisionResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDecisionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDecisionResponse>(
          GetDecisionResponse.$_createMessage);
  static GetDecisionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.DecisionRow get decision => $_getN(0);
  @$pb.TagNumber(1)
  set decision($1.DecisionRow value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDecision() => $_has(0);
  @$pb.TagNumber(1)
  void clearDecision() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.DecisionRow ensureDecision() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Money get refPrice => $_getN(1);
  @$pb.TagNumber(2)
  set refPrice($0.Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRefPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefPrice() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Money ensureRefPrice() => $_ensure(1);
}

/// ChartService: bars, engine-computed indicators and decision markers. The app
/// draws these values; it never computes an indicator itself.
class ChartServiceApi {
  final $pb.RpcClient _client;

  ChartServiceApi(this._client);

  $async.Future<GetChartResponse> getChart(
          $pb.ClientContext? ctx, GetChartRequest request) =>
      _client.invoke<GetChartResponse>(
          ctx, 'ChartService', 'GetChart', request, GetChartResponse());
  $async.Future<GetDecisionResponse> getDecision(
          $pb.ClientContext? ctx, GetDecisionRequest request) =>
      _client.invoke<GetDecisionResponse>(
          ctx, 'ChartService', 'GetDecision', request, GetDecisionResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
