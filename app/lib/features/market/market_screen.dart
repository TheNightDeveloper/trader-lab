import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/workspace_status.dart';
import '../../gen/lab/v1/health.pb.dart';
import '../../gen/lab/v1/market.connect.client.dart';
import '../../gen/lab/v1/market.pb.dart';
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';
import 'market_opportunities.dart';

/// One request at a time, only while the screen is visible. Riverpod keeps the
/// last confirmed response when a request fails and restarts the stream on retry.
final _marketSnapshotProvider = StreamProvider.autoDispose<GetMarketSnapshotResponse>((ref) async* {
  final market = MarketServiceClient(ref.watch(transportProvider));
  final signal = CancelableSignal();
  ref.onDispose(signal.cancel);
  const interval = Duration(seconds: 5);
  while (ref.mounted) {
    yield await market.getMarketSnapshot(GetMarketSnapshotRequest(), signal: TimeoutSignal(interval, parent: signal));
    await Future<void>.delayed(interval);
  }
}, retry: reconnectForever);

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key, this.ruleId});

  final Int64? ruleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final market = ref.watch(_marketSnapshotProvider);
    final snapshot = market.value;
    final disconnected = market.hasError;
    final selectedRule = ruleId;
    return PageFrame(
      children: [
        PageHeader(title: Dest.market.label(l), subtitle: Dest.market.subtitle(l)),
        if (snapshot == null)
          AsyncSection(
            value: market,
            onRetry: () => ref.invalidate(_marketSnapshotProvider),
            skeleton: Text(l.marketLoading),
            builder: (_) => const SizedBox.shrink(),
          )
        else ...[
          if (disconnected) WarningBanner(l.marketDisconnected, icon: Icons.cloud_off_rounded),
          if (selectedRule != null && selectedRule > Int64.ZERO)
            MarketScanCard(
              key: ValueKey(selectedRule),
              ruleId: selectedRule,
              watches: snapshot.marketWatch,
              disconnected: disconnected,
              onRecorded: () => ref.invalidate(_marketSnapshotProvider),
            ),
          MarketOpportunityHistory(opportunities: snapshot.opportunities, disconnected: disconnected),
          _MarketTimestamp(label: l.marketObservedAt, time: snapshot.observedAtUnixMs),
          if (snapshot.marketWatch.isEmpty)
            EmptyState(l.marketEmpty)
          else
            _MarketCards(watches: snapshot.marketWatch, disconnected: disconnected),
        ],
      ],
    );
  }
}

class _MarketCards extends StatelessWidget {
  const _MarketCards({required this.watches, required this.disconnected});

  final List<MarketWatch> watches;
  final bool disconnected;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const gap = AppSpace.md;
      // Keep each timestamp and its timezone together on narrow screens.
      final columns = (constraints.maxWidth / 300).floor().clamp(1, 3);
      final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final watch in watches)
            SizedBox(
              width: width,
              child: _MarketCard(watch: watch, disconnected: disconnected),
            ),
        ],
      );
    },
  );
}

class _MarketCard extends StatelessWidget {
  const _MarketCard({required this.watch, required this.disconnected});

  final MarketWatch watch;
  final bool disconnected;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final candle = watch.candle;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Semantics(header: true, child: Mono(watch.instrument.symbol, style: AppText.sectionTitle)),
              FreshnessBadge(
                live: LiveData(state: watch.state),
                disconnected: disconnected,
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          if (!watch.hasCandle())
            Text(l.marketNoCandle, style: AppText.caption)
          else ...[
            Text(l.marketClosePrice, style: AppText.caption),
            Num(moneyValue(candle.close), unit: candle.close.asset, style: AppText.statValue),
            const SizedBox(height: AppSpace.sm),
            _MarketTimestamp(label: l.marketClosedAt, time: candle.closedAtUnixMs),
            const SizedBox(height: AppSpace.xs),
            _MarketTimestamp(label: l.marketAvailableAt, time: candle.availableAtUnixMs),
          ],
        ],
      ),
    );
  }
}

class _MarketTimestamp extends StatelessWidget {
  const _MarketTimestamp({required this.label, required this.time});

  final String label;
  final Int64 time;

  @override
  Widget build(BuildContext context) {
    final utc = utcMs(time);
    return Wrap(
      spacing: AppSpace.sm,
      children: [
        Text(label, style: AppText.caption),
        Mono('${fmtDateTime(utc)}:${two(utc.second)} UTC', style: AppText.mono.copyWith(fontSize: 12)),
      ],
    );
  }
}
