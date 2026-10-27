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

/// KLineChart behind one small adapter (plan §7: replaceable). Always LTR.
/// [onCrosshair] reports the bar under the pointer, or null when it leaves.
class CandleChart extends StatelessWidget {
  const CandleChart({
    super.key,
    required this.ticker,
    required this.bars,
    this.pricePrecision = 2,
    this.volumePrecision = 4,
    this.onCrosshair,
  });

  final String ticker;
  final List<CandleBar> bars;
  final int pricePrecision, volumePrecision;
  final ValueChanged<CandleBar?>? onCrosshair;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: impl.CandleChartView(chart: this),
  );
}
