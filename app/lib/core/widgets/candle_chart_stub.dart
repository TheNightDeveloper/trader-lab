import 'package:flutter/widgets.dart';

import 'candle_chart.dart';

/// Non-web builds (widget tests): an empty box with the chart's semantics.
class CandleChartView extends StatelessWidget {
  const CandleChartView({super.key, required this.chart});
  final CandleChart chart;

  @override
  Widget build(BuildContext context) => Semantics(label: chart.ticker, child: const SizedBox.expand());
}
