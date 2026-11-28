import 'dart:convert';

import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/nav.dart';
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
import '../library/rule_editor.dart' show RuleJson, describeRule;
import '../library/rule_version_picker.dart';
import 'opportunity_assistant.dart';

class MarketScanCard extends ConsumerStatefulWidget {
  const MarketScanCard({
    super.key,
    required this.ruleId,
    required this.watches,
    required this.subscriptions,
    required this.disconnected,
    required this.onRecorded,
  });

  final Int64 ruleId;
  final List<MarketWatch> watches;
  final List<MarketScanSubscription> subscriptions;
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

  Future<void> _scan(String symbol, {bool background = false}) async {
    setState(() {
      _scanning = true;
      _result = null;
      _error = null;
    });
    try {
      final client = MarketServiceClient(ref.read(transportProvider));
      final signal = TimeoutSignal(const Duration(seconds: 15), parent: _signal);
      if (background) {
        await client.setMarketScanSubscription(
          SetMarketScanSubscriptionRequest(ruleVersionId: widget.ruleId, symbol: symbol, enabled: true),
          signal: signal,
        );
        if (mounted) widget.onRecorded();
        return;
      }
      final response = await client.scanMarketOpportunity(
        ScanMarketOpportunityRequest(ruleVersionId: widget.ruleId, symbol: symbol),
        signal: signal,
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
    final active = widget.subscriptions.where((scan) => scan.symbol == selected).firstOrNull;
    final fresh =
        !widget.disconnected &&
        widget.watches.any((watch) => watch.instrument.symbol == selected && watch.state == LiveState.LIVE_STATE_FRESH);
    final result = _result;
    final message = result == null ? null : _marketScanMessage(l, result);
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
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              FilledButton(
                onPressed: !_scanning && fresh && selected != null ? () => _scan(selected) : null,
                child: Text(l.marketScanReady),
              ),
              OutlinedButton(
                onPressed: !_scanning && !widget.disconnected && active == null && selected != null
                    ? () => _scan(selected, background: true)
                    : null,
                child: Text(l.marketBackgroundEnable),
              ),
            ],
          ),
          if (_scanning) Text(l.marketScanRunning, style: AppText.caption),
          if (active != null)
            Text(
              active.ruleVersionId == widget.ruleId ? l.marketBackgroundEnabled : l.marketBackgroundOccupied,
              style: AppText.caption,
            ),
          if (_error case final error?) WarningBanner(errorText(error)),
          if (message != null) Semantics(liveRegion: true, child: Text(message, style: AppText.body)),
          if (!fresh) Text(l.marketScanWaitForFeed, style: AppText.caption),
        ],
      ),
    );
  }
}

String _marketScanMessage(L10n l, MarketScanState state) => switch (state) {
  MarketScanState.MARKET_SCAN_STATE_MATCH => l.marketScanRecorded,
  MarketScanState.MARKET_SCAN_STATE_NO_MATCH => l.marketScanNoMatch,
  MarketScanState.MARKET_SCAN_STATE_INCOMPLETE_DATA => l.marketScanIncomplete,
  _ => l.marketScanUnexpected,
};

class MarketBackgroundScans extends ConsumerStatefulWidget {
  const MarketBackgroundScans({
    super.key,
    required this.subscriptions,
    required this.freshSymbols,
    required this.disconnected,
    required this.onChanged,
  });

  final List<MarketScanSubscription> subscriptions;
  final Set<String> freshSymbols;
  final bool disconnected;
  final VoidCallback onChanged;

  @override
  ConsumerState<MarketBackgroundScans> createState() => _MarketBackgroundScansState();
}

class _MarketBackgroundScansState extends ConsumerState<MarketBackgroundScans> {
  final _signal = CancelableSignal();
  String? _pending;
  Object? _error;

  @override
  void dispose() {
    _signal.cancel();
    super.dispose();
  }

  Future<void> _pause(MarketScanSubscription scan) async {
    setState(() {
      _pending = scan.symbol;
      _error = null;
    });
    try {
      final client = MarketServiceClient(ref.read(transportProvider));
      await client.setMarketScanSubscription(
        SetMarketScanSubscriptionRequest(ruleVersionId: scan.ruleVersionId, symbol: scan.symbol, enabled: false),
        signal: TimeoutSignal(const Duration(seconds: 25), parent: _signal),
      );
      if (mounted) widget.onChanged();
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _pending = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SectionCard(
      title: l.marketBackgroundTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error case final error?) WarningBanner(errorText(error)),
          for (final scan in widget.subscriptions)
            _MarketBackgroundScanRow(
              scan: scan,
              fresh: widget.freshSymbols.contains(scan.symbol),
              pending: _pending == scan.symbol,
              onPause: widget.disconnected || _pending != null ? null : () => _pause(scan),
            ),
        ],
      ),
    );
  }
}

class _MarketBackgroundScanRow extends StatelessWidget {
  const _MarketBackgroundScanRow({required this.scan, required this.fresh, required this.pending, this.onPause});

  final MarketScanSubscription scan;
  final bool fresh;
  final bool pending;
  final VoidCallback? onPause;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final checked = scan.hasLastCandleClosedAtUnixMs();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Mono(scan.symbol),
              TextButton(onPressed: () => context.go(ruleVersionPath(scan.ruleVersionId)), child: Text(scan.ruleTitle)),
              OutlinedButton(
                onPressed: onPause,
                child: Text(pending ? l.marketBackgroundPausing : l.marketBackgroundPause),
              ),
            ],
          ),
          if (!fresh || !checked)
            Text(fresh ? l.marketBackgroundFirst : l.marketBackgroundWaiting, style: AppText.caption),
          if (checked)
            Wrap(
              spacing: AppSpace.sm,
              children: [
                Text(l.marketBackgroundLast, style: AppText.caption),
                Mono('${fmtDateTime(utcMs(scan.lastCandleClosedAtUnixMs))} UTC'),
                Text(_marketScanMessage(l, scan.lastState), style: AppText.caption),
              ],
            ),
        ],
      ),
    );
  }
}

/// Each disclosure keeps the recorded inputs and its original evidence reachable after expiry.
class MarketOpportunityHistory extends StatefulWidget {
  const MarketOpportunityHistory({super.key, required this.opportunities, required this.disconnected});

  final List<MarketOpportunity> opportunities;
  final bool disconnected;

  @override
  State<MarketOpportunityHistory> createState() => _MarketOpportunityHistoryState();
}

class _MarketOpportunityHistoryState extends State<MarketOpportunityHistory> {
  String _symbol = '';
  bool _onlyCurrent = false;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final opportunities = widget.opportunities;
    final symbols = opportunities.map((item) => item.symbol).toSet().toList()..sort();
    final selected = symbols.contains(_symbol) ? _symbol : '';
    // Filter on the last snapshot so a disconnect keeps the same results visible.
    final filtered = opportunities.where(
      (item) => (selected.isEmpty || item.symbol == selected) && (!_onlyCurrent || item.current),
    );
    return SectionCard(
      title: l.marketOpportunitiesTitle,
      child: opportunities.isEmpty
          ? EmptyState(l.marketOpportunitiesEmpty)
          : Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Wrap(
                    spacing: AppSpace.sm,
                    runSpacing: AppSpace.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: selected,
                        items: [
                          DropdownMenuItem(value: '', child: Text(l.marketOpportunityAllSymbols)),
                          for (final symbol in symbols) DropdownMenuItem(value: symbol, child: Mono(symbol)),
                        ],
                        onChanged: (value) => setState(() => _symbol = value ?? ''),
                      ),
                      FilterChip(
                        label: Text(l.marketOpportunityOnlyCurrent),
                        selected: _onlyCurrent,
                        onSelected: (value) => setState(() => _onlyCurrent = value),
                      ),
                    ],
                  ),
                ),
                if (filtered.isEmpty) EmptyState(l.marketOpportunityNoFiltered),
                for (final item in filtered)
                  _OpportunityDetails(
                    key: ValueKey(item.id),
                    item: item,
                    current: item.current && !widget.disconnected,
                    connected: !widget.disconnected,
                  ),
              ],
            ),
    );
  }
}

String marketOpportunityReason(L10n l, String reason) => switch (reason) {
  'rule entry' => l.marketOpportunityEntry,
  'rule regime entry: A' => l.marketOpportunityRegimeA,
  'rule regime entry: B' => l.marketOpportunityRegimeB,
  _ => reason,
};

class _OpportunityDetails extends StatelessWidget {
  const _OpportunityDetails({super.key, required this.item, required this.current, required this.connected});

  final MarketOpportunity item;
  final bool current;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final reason = marketOpportunityReason(l, item.reason);
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
        _OpportunityEntryCondition(versionId: item.ruleVersionId),
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
            if (current)
              OutlinedButton(
                onPressed: () => context.go('${Dest.paper.path}?opportunity=${item.id}'),
                child: Text(l.paperReviewOpportunity),
              ),
          ],
        ),
        const SizedBox(height: AppSpace.md),
        OpportunityAssistant(opportunityId: item.id, connected: connected),
      ],
    );
  }
}

class _OpportunityEntryCondition extends ConsumerWidget {
  const _OpportunityEntryCondition({required this.versionId});

  final Int64 versionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final provider = ruleVersionProvider(versionId);
    return AsyncSection(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      skeleton: Text(l.paperReplayEntryRule),
      builder: (version) {
        // Assess the saved version the observation used, even after a newer draft is saved.
        final definition = jsonDecode(version.definitionJson) as RuleJson;
        return Wrap(
          spacing: AppSpace.sm,
          children: [
            Text(l.paperReplayEntryRule, style: AppText.caption),
            Text(describeRule(definition['entry'] as RuleJson)),
          ],
        );
      },
    );
  }
}
