import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';

import 'candle_chart_stub.dart' if (dart.library.js_interop) 'candle_chart_web.dart' as impl;

/// One closed bar for display. Values arrive as exact decimals; only the chart
/// adapter turns them into JS numbers, for drawing.
class CandleBar {
  const CandleBar(this.time, this.open, this.high, this.low, this.close, this.volume);
  final DateTime time;
  final Decimal open, high, low, close, volume;
}

/// An engine-computed indicator line, aligned with the bars (null = undefined).
class EngineLine {
  const EngineLine(this.name, this.values);
  final String name;
  final List<Decimal?> values;
}

/// An engine indicator: drawn as given, never recomputed by the chart.
class EngineIndicator {
  const EngineIndicator({required this.key, required this.label, required this.main, required this.lines});
  final String key, label;
  final bool main; // over the candles, else its own pane
  final List<EngineLine> lines;

  /// Per bar timestamp, the values to draw: what the chart's indicator calc
  /// returns. Exactly the engine's numbers (only converted to double to draw).
  List<Map<String, double>> valuesFor(List<CandleBar> bars) => [
    for (var i = 0; i < bars.length; i++)
      {
        for (final l in lines)
          if (i < l.values.length && l.values[i] != null) l.name: l.values[i]!.toDouble(),
      },
  ];
}

/// A decision marker on a bar.
class ChartMark {
  const ChartMark({required this.index, required this.time, required this.kind, required this.price});
  final int index; // position in the marker list
  final DateTime time;
  final String kind; // entry | exit | rejected
  final Decimal price;

  String get glyph => switch (kind) {
    'entry' => 'B',
    'exit' => 'S',
    _ => '×',
  };
}

/// KLineChart behind one small adapter (plan §7: replaceable). Always LTR.
/// [onCrosshair] reports the bar under the pointer, or null when it leaves.
class CandleChart extends StatelessWidget {
  const CandleChart({
    super.key,
    required this.ticker,
    required this.bars,
    this.timeframe = '1m',
    this.indicators = const [],
    this.marks = const [],
    this.selected,
    this.onMarkTap,
    this.pricePrecision = 2,
    this.volumePrecision = 4,
    this.onCrosshair,
  });

  final String ticker, timeframe;
  final List<CandleBar> bars;
  final List<EngineIndicator> indicators;
  final List<ChartMark> marks;
  final int? selected;
  final ValueChanged<ChartMark>? onMarkTap;
  final int pricePrecision, volumePrecision;
  final ValueChanged<CandleBar?>? onCrosshair;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: impl.CandleChartView(chart: this),
  );
}
