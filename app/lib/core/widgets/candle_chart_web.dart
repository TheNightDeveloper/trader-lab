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

extension type _KChart._(JSObject _) implements JSObject {
  external void setSymbol(JSObject symbol);
  external void setPeriod(JSObject period);
  external void setDataLoader(JSObject loader);
  external void setStyles(JSObject styles);
  external void resize();
  external void subscribeAction(String type, JSFunction callback);
}

class CandleChartView extends StatefulWidget {
  const CandleChartView({super.key, required this.chart});
  final CandleChart chart;

  @override
  State<CandleChartView> createState() => _CandleChartViewState();
}

class _CandleChartViewState extends State<CandleChartView> {
  web.HTMLElement? _el;
  _KChart? _chart;
  web.ResizeObserver? _resize;

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
    chart.setPeriod({'type': 'minute', 'span': 1}.jsify()! as JSObject);
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
  }

  @override
  void didUpdateWidget(CandleChartView old) {
    super.didUpdateWidget(old);
    if (!identical(old.chart.bars, widget.chart.bars) || old.chart.ticker != widget.chart.ticker) _load();
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

String _css(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

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
