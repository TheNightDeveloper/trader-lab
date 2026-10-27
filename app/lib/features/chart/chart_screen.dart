import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../app/nav.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/candle_chart.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../l10n/app_localizations.dart';
import '../placeholder_screen.dart';

/// M0 spike: KLineChart in an RTL page. Real bars come from ChartService in M6.
class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final _bars = _sampleBars();
  final _hover = ValueNotifier<CandleBar?>(null);

  @override
  void dispose() {
    _hover.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return PageFrame(
      children: [
        PageHeader(title: Dest.chart.label(l), subtitle: Dest.chart.subtitle(l)),
        SectionCard(
          title: l.chartSpikeTitle,
          trailing: const Mono('BTCUSDT · 1m'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.chartSpikeHint, style: AppText.caption),
              const SizedBox(height: AppSpace.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: SizedBox(
                  height: 420,
                  child: CandleChart(ticker: 'BTCUSDT', bars: _bars, onCrosshair: (b) => _hover.value = b),
                ),
              ),
              const SizedBox(height: AppSpace.md),
              ValueListenableBuilder(
                valueListenable: _hover,
                builder: (context, b, _) => AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.fast),
                  child: b == null
                      ? Text(l.chartCrosshairNone, key: const ValueKey(0), style: AppText.caption)
                      : Wrap(
                          key: const ValueKey(1),
                          spacing: AppSpace.lg,
                          children: [
                            Text(l.chartCrosshair, style: AppText.caption),
                            Mono(b.time.toUtc().toIso8601String().substring(0, 16)),
                            Num(b.open, unit: 'O'),
                            Num(b.high, unit: 'H'),
                            Num(b.low, unit: 'L'),
                            Num(b.close, unit: 'C'),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Deterministic random walk; display-only sample data for the spike.
List<CandleBar> _sampleBars() {
  final rnd = Random(42);
  var price = 6500000; // cents: 65,000.00
  final start = DateTime.utc(2026, 1, 1);
  final d = Decimal.fromInt;
  Decimal cents(int v) => (d(v) / d(100)).toDecimal();
  return List.generate(300, (i) {
    final open = price;
    final close = open + rnd.nextInt(30001) - 15000;
    final high = max(open, close) + rnd.nextInt(8000);
    final low = min(open, close) - rnd.nextInt(8000);
    price = close;
    return CandleBar(
      start.add(Duration(minutes: i)),
      cents(open),
      cents(high),
      cents(low),
      cents(close),
      (d(rnd.nextInt(500000)) / d(10000)).toDecimal(),
    );
  });
}
