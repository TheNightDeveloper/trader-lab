import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import '../theme/tokens.dart';
import 'candle_chart.dart';

@JS('klinecharts.init')
external _KChart? _init(web.HTMLElement el, JSObject options);

@JS('klinecharts.dispose')
external void _dispose(web.HTMLElement el);

@JS('klinecharts.registerIndicator')
external void _registerIndicator(JSObject template);

@JS('klinecharts.registerOverlay')
external void _registerOverlay(JSObject template);

extension type _KChart._(JSObject _) implements JSObject {
  external void setSymbol(JSObject symbol);
  external void setPeriod(JSObject period);
  external void setDataLoader(JSObject loader);
  external void setStyles(JSObject styles);
  external void resize();
  external void subscribeAction(String type, JSFunction callback);
  external JSAny? createIndicator(JSObject value, bool isStack);
  external void removeIndicator(JSObject filter);
  external JSAny? createOverlay(JSObject value);
  external void removeOverlay(JSObject filter);
  external void scrollToTimestamp(int timestamp, int animationDuration);
}

class CandleChartView extends StatefulWidget {
  const CandleChartView({super.key, required this.chart});
  final CandleChart chart;

  @override
  State<CandleChartView> createState() => _CandleChartViewState();
}

/// Each load registers indicator templates under fresh names: their calc only
/// returns the engine's values for these bars.
var _templates = 0;
var _markerRegistered = false;
var _colorIndex = 0;
final _palette = [...AppColors.series, AppColors.positive, AppColors.link];

class _CandleChartViewState extends State<CandleChartView> {
  web.HTMLElement? _el;
  _KChart? _chart;
  web.ResizeObserver? _resize;
  final _indicatorIds = <String>[];

  void _created(Object element) {
    final el = (element as web.HTMLElement)
      ..style.width = '100%'
      ..style.height = '100%'
      ..dir = 'ltr';
    _el = el;
    // The element is created detached (width 0). KLineChart measures on init, so
    // create it on the first callback with a real size, then just follow resizes.
    _resize = web.ResizeObserver(
      ((JSArray<JSAny?> _, web.ResizeObserver _) {
        if (_chart != null) return _chart!.resize();
        if (el.clientWidth > 0) _mount(el);
      }).toJS,
    )..observe(el);
  }

  void _mount(web.HTMLElement el) {
    final chart = _init(el, {'styles': 'dark'}.jsify()! as JSObject);
    if (chart == null) return;
    _chart = chart;
    chart.setStyles(_styles());
    chart.subscribeAction(
      'onCrosshairChange',
      ((JSObject? c) {
        final idx = c?['dataIndex'];
        final bars = widget.chart.bars;
        final i = idx.isA<JSNumber>() ? (idx as JSNumber).toDartInt : -1;
        widget.chart.onCrosshair?.call(c?['kLineData'] != null && i >= 0 && i < bars.length ? bars[i] : null);
      }).toJS,
    );
    _registerMarker();
    _load();
  }

  void _load() {
    final chart = _chart;
    if (chart == null) return;
    final c = widget.chart;
    chart.setSymbol(
      {'ticker': c.ticker, 'pricePrecision': c.pricePrecision, 'volumePrecision': c.volumePrecision}.jsify()!
          as JSObject,
    );
    chart.setPeriod(_period(c.timeframe).jsify()! as JSObject);
    final loader = JSObject();
    loader['getBars'] = ((JSObject params) {
      final data = [
        for (final b in c.bars)
          {
            'timestamp': b.time.millisecondsSinceEpoch,
            'open': b.open.toDouble(),
            'high': b.high.toDouble(),
            'low': b.low.toDouble(),
            'close': b.close.toDouble(),
            'volume': b.volume.toDouble(),
          },
      ].jsify();
      (params['callback'] as JSFunction).callAsFunction(null, data, false.toJS);
    }).toJS;
    chart.setDataLoader(loader);
    _indicators();
    _marks();
  }

  void _indicators() {
    final chart = _chart!;
    for (final id in _indicatorIds) {
      chart.removeIndicator({'id': id}.jsify()! as JSObject);
    }
    _indicatorIds.clear();
    final c = widget.chart;
    final byTime = <int, int>{for (final (i, b) in c.bars.indexed) b.time.millisecondsSinceEpoch: i};
    _colorIndex = 0;
    for (final ind in c.indicators) {
      final name = 'lab_${_templates++}';
      final values = ind.valuesFor(c.bars).map((m) => m.jsify()).toList();
      final template =
          {
                'name': name,
                'shortName': ind.label,
                'figures': [
                  for (final l in ind.lines)
                    {'key': l.name, 'title': '${l.name}: ', 'type': l.name == 'hist' ? 'bar' : 'line'},
                ],
              }.jsify()!
              as JSObject;
      // calc returns the engine's values for each bar; it computes nothing.
      template['calc'] = ((JSArray<JSObject> dataList, JSObject _) {
        final out = <JSAny?>[];
        for (final d in dataList.toDart) {
          final i = byTime[(d['timestamp'] as JSNumber).toDartInt];
          out.add(i == null ? JSObject() : values[i]);
        }
        return out.toJS;
      }).toJS;
      _registerIndicator(template);
      chart.createIndicator(
        {
              'name': name,
              'id': name,
              'paneId': ind.main ? 'candle_pane' : 'pane_$name',
              // Each line its own color (KLineChart would give every single-line
              // indicator the same first color).
              'styles': {
                'lines': [
                  for (final _ in ind.lines)
                    {
                      'color': _css(_palette[_colorIndex++ % _palette.length]),
                      'size': 1,
                      'style': 'solid',
                      'smooth': false,
                      'dashedValue': [2, 2],
                    },
                ],
              },
            }.jsify()!
            as JSObject,
        ind.main,
      );
      _indicatorIds.add(name);
    }
  }

  void _marks() {
    final chart = _chart!;
    chart.removeOverlay({'groupId': 'lab_marks'}.jsify()! as JSObject);
    final c = widget.chart;
    for (final m in c.marks) {
      final o =
          {
                'name': 'labMarker',
                'groupId': 'lab_marks',
                'lock': true,
                'points': [
                  {'timestamp': m.time.millisecondsSinceEpoch, 'value': m.price.toDouble()},
                ],
                'extendData': {'glyph': m.glyph, 'kind': m.kind, 'selected': m.index == c.selected},
              }.jsify()!
              as JSObject;
      o['onClick'] = ((JSObject _) {
        widget.chart.onMarkTap?.call(m);
        return true.toJS;
      }).toJS;
      chart.createOverlay(o);
    }
    final sel = c.marks.where((m) => m.index == c.selected).firstOrNull;
    if (sel != null) chart.scrollToTimestamp(sel.time.millisecondsSinceEpoch, 200);
  }

  @override
  void didUpdateWidget(CandleChartView old) {
    super.didUpdateWidget(old);
    final o = old.chart, n = widget.chart;
    if (!identical(o.bars, n.bars) || o.ticker != n.ticker || o.timeframe != n.timeframe) {
      _load();
    } else {
      if (!identical(o.indicators, n.indicators)) _indicators();
      if (!identical(o.marks, n.marks) || o.selected != n.selected) _marks();
    }
  }

  @override
  void dispose() {
    _resize?.disconnect();
    if (_el != null) _dispose(_el!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlElementView.fromTagName(tagName: 'div', onElementCreated: _created);
}

Map<String, Object> _period(String tf) => switch (tf) {
  '5m' => {'type': 'minute', 'span': 5},
  '15m' => {'type': 'minute', 'span': 15},
  '1h' => {'type': 'hour', 'span': 1},
  '4h' => {'type': 'hour', 'span': 4},
  '1d' => {'type': 'day', 'span': 1},
  _ => {'type': 'minute', 'span': 1},
};

String _css(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// The marker: a disc with B, S or × below (entries) or above (exits) its bar.
void _registerMarker() {
  if (_markerRegistered) return;
  _markerRegistered = true;
  final t =
      {
            'name': 'labMarker',
            'totalStep': 2,
            'needDefaultPointFigure': false,
            'needDefaultXAxisFigure': false,
            'needDefaultYAxisFigure': false,
          }.jsify()!
          as JSObject;
  t['createPointFigures'] = ((JSObject p) {
    final overlay = p['overlay'] as JSObject;
    final ext = overlay['extendData'] as JSObject;
    final pt = (p['coordinates'] as JSArray<JSObject>).toDart.first;
    final kind = (ext['kind'] as JSString).toDart;
    final selected = (ext['selected'] as JSBoolean).toDart;
    final x = (pt['x'] as JSNumber).toDartDouble;
    final y = (pt['y'] as JSNumber).toDartDouble + (kind == 'exit' ? -16 : 16);
    final fill = switch (kind) {
      'entry' => _css(AppColors.accent),
      'exit' => _css(AppColors.textPrimary),
      _ => _css(AppColors.warning),
    };
    return [
      {
        'type': 'circle',
        'attrs': {'x': x, 'y': y, 'r': selected ? 11 : 9},
        'styles': {
          'style': 'stroke_fill',
          'color': fill,
          'borderColor': selected ? '#FFFFFF' : _css(AppColors.bg),
          'borderSize': selected ? 2 : 1,
        },
      },
      {
        'type': 'text',
        'ignoreEvent': true,
        'attrs': {'x': x, 'y': y, 'text': (ext['glyph'] as JSString).toDart, 'align': 'center', 'baseline': 'middle'},
        'styles': {'color': _css(AppColors.bg), 'size': 11, 'weight': 'bold', 'backgroundColor': 'transparent'},
      },
    ].jsify();
  }).toJS;
  _registerOverlay(t);
}

JSObject _styles() {
  final up = _css(AppColors.positive), down = _css(AppColors.negative), grid = _css(AppColors.divider);
  return {
        'grid': {
          'horizontal': {'color': grid},
          'vertical': {'color': grid},
        },
        'candle': {
          'bar': {
            'upColor': up,
            'upBorderColor': up,
            'upWickColor': up,
            'downColor': down,
            'downBorderColor': down,
            'downWickColor': down,
          },
        },
      }.jsify()!
      as JSObject;
}
