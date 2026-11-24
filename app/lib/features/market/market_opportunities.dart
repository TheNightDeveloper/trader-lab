import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/health.pbenum.dart';
import '../../gen/lab/v1/market.connect.client.dart';
import '../../gen/lab/v1/market.pb.dart';
import '../../l10n/app_localizations.dart';
import '../library/rule_draft_dialog.dart' show ruleVersionPath;
import '../library/rule_version_picker.dart';

class MarketScanCard extends ConsumerStatefulWidget {
  const MarketScanCard({
    super.key,
    required this.ruleId,
    required this.watches,
    required this.disconnected,
    required this.onRecorded,
  });

  final Int64 ruleId;
  final List<MarketWatch> watches;
  final bool disconnected;
  final VoidCallback onRecorded;

  @override
  ConsumerState<MarketScanCard> createState() => _MarketScanCardState();
}

class _MarketScanCardState extends ConsumerState<MarketScanCard> {
  final _signal = CancelableSignal();
  String? _symbol;
  bool _scanning = false;
  MarketScanState? _result;
  Object? _error;

  @override
  void dispose() {
    _signal.cancel();
    super.dispose();
  }

  Future<void> _scan(String symbol) async {
    setState(() {
      _scanning = true;
      _result = null;
      _error = null;
    });
    try {
      final client = MarketServiceClient(ref.read(transportProvider));
      final response = await client.scanMarketOpportunity(
        ScanMarketOpportunityRequest(ruleVersionId: widget.ruleId, symbol: symbol),
        signal: TimeoutSignal(const Duration(seconds: 15), parent: _signal),
      );
      if (!mounted) return;
      setState(() => _result = response.state);
      if (response.hasOpportunity()) widget.onRecorded();
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final version = ref.watch(ruleVersionProvider(widget.ruleId)).value?.version;
    final symbol = _symbol;
    final selected = widget.watches.any((watch) => watch.instrument.symbol == symbol) ? symbol : null;
    final fresh =
        !widget.disconnected &&
        widget.watches.any((watch) => watch.instrument.symbol == selected && watch.state == LiveState.LIVE_STATE_FRESH);
    final message = switch (_result) {
      MarketScanState.MARKET_SCAN_STATE_MATCH => l.marketScanRecorded,
      MarketScanState.MARKET_SCAN_STATE_NO_MATCH => l.marketScanNoMatch,
      MarketScanState.MARKET_SCAN_STATE_INCOMPLETE_DATA => l.marketScanIncomplete,
      null => null,
      _ => l.marketScanUnexpected,
    };
    return SectionCard(
      title: l.marketScanTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (version != null) Text(version.title, style: AppText.sectionTitle),
          Text(l.marketScanHelp, style: AppText.body),
          const SizedBox(height: AppSpace.md),
          DropdownButton<String>(
            value: selected,
            hint: Text(l.marketScanSymbol),
            items: [
              for (final watch in widget.watches)
                DropdownMenuItem(value: watch.instrument.symbol, child: Mono(watch.instrument.symbol)),
            ],
            onChanged: _scanning
                ? null
                : (symbol) => setState(() {
                    _symbol = symbol;
                    _result = null;
                    _error = null;
                  }),
          ),
          FilledButton(
            onPressed: !_scanning && fresh && selected != null ? () => _scan(selected) : null,
            child: Text(_scanning ? l.marketScanRunning : l.marketScanReady),
          ),
          if (_error case final error?) WarningBanner(errorText(error)),
          if (message != null) Semantics(liveRegion: true, child: Text(message, style: AppText.body)),
          if (!fresh) Text(l.marketScanWaitForFeed, style: AppText.caption),
        ],
      ),
    );
  }
}

/// Each disclosure keeps the recorded inputs and its original evidence reachable after expiry.
class MarketOpportunityHistory extends StatelessWidget {
  const MarketOpportunityHistory({super.key, required this.opportunities, required this.disconnected});

  final List<MarketOpportunity> opportunities;
  final bool disconnected;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SectionCard(
      title: l.marketOpportunitiesTitle,
      child: opportunities.isEmpty
          ? EmptyState(l.marketOpportunitiesEmpty)
          : Column(
              children: [
                for (final item in opportunities)
                  _OpportunityDetails(key: ValueKey(item.id), item: item, current: item.current && !disconnected),
              ],
            ),
    );
  }
}

class _OpportunityDetails extends StatelessWidget {
  const _OpportunityDetails({super.key, required this.item, required this.current});

  final MarketOpportunity item;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final reason = switch (item.reason) {
      'rule entry' => l.marketOpportunityEntry,
      'rule regime entry: A' => l.marketOpportunityRegimeA,
      'rule regime entry: B' => l.marketOpportunityRegimeB,
      _ => item.reason,
    };
    return ExpansionTile(
      title: Wrap(spacing: AppSpace.sm, children: [Mono(item.symbol), Text(item.ruleTitle)]),
      subtitle: StatusText(
        current
            ? (l.marketOpportunityCurrent, AppColors.positive)
            : (l.marketOpportunityInactive, AppColors.warningText),
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.all(AppSpace.md),
      children: [
        Text(reason),
        Text(l.marketOpportunityPrice, style: AppText.caption),
        Num(moneyValue(item.referenceClose), unit: item.referenceClose.asset),
        Wrap(
          spacing: AppSpace.sm,
          children: [Text(l.marketClosedAt), Mono('${fmtDateTime(utcMs(item.candleClosedAtUnixMs))} UTC')],
        ),
        Wrap(
          spacing: AppSpace.sm,
          children: [Text(l.marketOpportunityExpires), Mono('${fmtDateTime(utcMs(item.expiresAtUnixMs))} UTC')],
        ),
        Wrap(
          spacing: AppSpace.sm,
          children: [
            TextButton(
              onPressed: () => context.go(ruleVersionPath(item.ruleVersionId)),
              child: Text(l.marketOpportunityRule),
            ),
            TextButton(
              onPressed: () => context.go('/reports/${Uri.encodeComponent(item.reportId)}'),
              child: Text(l.marketOpportunityReport),
            ),
          ],
        ),
      ],
    );
  }
}
