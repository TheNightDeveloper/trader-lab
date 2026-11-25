import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/candle_chart.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/paper.pb.dart';
import '../../l10n/app_localizations.dart';
import 'paper_entries.dart';
import 'paper_providers.dart';

class PaperPlanMarket extends ConsumerWidget {
  const PaperPlanMarket({super.key, required this.plan});

  final PaperPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final provider = paperPlanContextProvider(plan.planHash);
    return SectionCard(
      title: l.paperMarketChart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AsyncSection(
            value: ref.watch(provider),
            onRetry: () => ref.invalidate(provider),
            skeleton: const LinearProgressIndicator(),
            builder: (value) =>
                PaperMarketChart(market: value.marketContext, symbol: plan.instrument.symbol, plan: plan),
          ),
          const SizedBox(height: AppSpace.sm),
          PaperTimeLine(label: l.paperCandleTime, at: plan.referenceCandleClosedAtUnixMs),
          PaperTimeLine(label: l.paperPlanQuoteAt, at: plan.quotedAtUnixMs),
          Text(l.paperFillAssumptions, style: AppText.caption),
          if (plan.engineBuildSha256.isNotEmpty)
            PaperEvidenceHash(label: l.paperPlanEngineBuild, hash: plan.engineBuildSha256),
        ],
      ),
    );
  }
}

class PaperMarketChart extends StatelessWidget {
  const PaperMarketChart({super.key, required this.market, required this.symbol, this.plan});

  final PaperMarketContext market;
  final String symbol;
  final PaperPlan? plan;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final bars = market.candles
        .map(
          (bar) => CandleBar(
            utcMs(bar.openUnixMs),
            decValue(bar.open),
            decValue(bar.high),
            decValue(bar.low),
            decValue(bar.close),
            decValue(bar.volume),
          ),
        )
        .toList(growable: false);
    final terms = plan;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The levels come from the server review. The chart only draws them.
        Semantics(
          label: l.paperMarketChart,
          child: SizedBox(
            height: 220,
            child: CandleChart(
              ticker: symbol,
              bars: bars,
              timeframe: '1h',
              indicators: [
                if (terms != null)
                  EngineIndicator(
                    key: 'paper-levels',
                    label: l.paperRiskSummary,
                    main: true,
                    lines: [
                      EngineLine(l.paperEntryLimit, List.filled(bars.length, moneyValue(terms.maxEntryPrice))),
                      EngineLine(l.paperStop, List.filled(bars.length, moneyValue(terms.stop))),
                      EngineLine(l.paperTarget, List.filled(bars.length, moneyValue(terms.takeProfit))),
                    ],
                  ),
              ],
            ),
          ),
        ),
        PaperTimeLine(label: l.marketClosedAt, at: market.candleClosedAtUnixMs),
        PaperTimeLine(label: l.paperReplayObservedAt, at: market.observedAtUnixMs),
        if (market.scannerBuildSha256.isNotEmpty)
          PaperEvidenceHash(label: l.paperScannerBuild, hash: market.scannerBuildSha256),
      ],
    );
  }
}

class PaperEvidenceHash extends StatelessWidget {
  const PaperEvidenceHash({super.key, required this.label, required this.hash});

  final String label;
  final String hash;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: hash,
    child: Wrap(
      spacing: AppSpace.sm,
      children: [
        Text(label, style: AppText.caption),
        Mono(shortHash(hash, prefix: '')),
      ],
    ),
  );
}
