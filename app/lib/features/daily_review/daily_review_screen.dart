import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/nav.dart';
import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/daily_review.pb.dart';
import '../../gen/lab/v1/market.pb.dart';
import '../../gen/lab/v1/shadow.pb.dart';
import '../../l10n/app_localizations.dart';
import '../data/data_screen.dart' show issueKind;
import '../page_frame.dart';
import '../paper/paper_controls.dart' show paperLedgerMatches;
import '../shadow/shadow_results.dart' show shadowStateLabel;
import 'daily_review_api.dart';

class DailyReviewScreen extends ConsumerWidget {
  const DailyReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final snapshot = ref.watch(dailyReviewProvider);
    final data = snapshot.value;
    return PageFrame(
      children: [
        PageHeader(
          title: Dest.dailyReview.label(l),
          subtitle: Dest.dailyReview.subtitle(l),
          actions: [
            OutlinedButton.icon(
              onPressed: snapshot.isLoading
                  ? null
                  : () => ref.invalidate(dailyReviewProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l.dailyReviewRefresh),
            ),
          ],
        ),
        if (data == null)
          AsyncSection(
            value: snapshot,
            onRetry: () => ref.invalidate(dailyReviewProvider),
            skeleton: Text(l.dailyReviewLoading),
            builder: (_) => const SizedBox.shrink(),
          )
        else ...[
          if (snapshot.hasError) WarningBanner(l.engineUnreachable),
          DailyReviewControls(
            status: data.status,
            asOf: data.asOfUnixMs,
            enabled: !snapshot.hasError && !snapshot.isLoading,
          ),
          _NextReview(snapshot: data),
          _PaperReview(snapshot: data),
          _OpportunityReview(snapshot: data),
          _ShadowReview(snapshot: data),
          _EventReview(events: data.events),
        ],
      ],
    );
  }
}

class DailyReviewControls extends ConsumerStatefulWidget {
  const DailyReviewControls({
    super.key,
    required this.status,
    required this.asOf,
    required this.enabled,
  });

  final DailyReviewStatus status;
  final Int64 asOf;
  final bool enabled;

  @override
  ConsumerState<DailyReviewControls> createState() =>
      _DailyReviewControlsState();
}

class _DailyReviewControlsState extends ConsumerState<DailyReviewControls> {
  bool _busy = false;
  String? _error;

  Future<void> _save({bool? reminder}) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final client = ref.read(dailyReviewClientProvider);
    final signal = TimeoutSignal(const Duration(seconds: 8));
    try {
      if (reminder == null) {
        await client.markDailyReviewRead(
          MarkDailyReviewReadRequest(
            dayStartUnixMs: widget.status.dayStartUnixMs,
          ),
          signal: signal,
        );
      } else {
        await client.setDailyReviewReminder(
          SetDailyReviewReminderRequest(enabled: reminder),
          signal: signal,
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = errorText(error));
    } finally {
      if (mounted) {
        // Refresh after a lost response or a UTC rollover as well as success.
        ref.invalidate(dailyReviewProvider);
        ref.invalidate(dailyReviewReminderProvider);
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final enabled = widget.enabled && !_busy;
    final status = widget.status;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.xs,
            children: [
              Text(l.dailyReviewDay),
              Mono('${fmtDate(utcMs(status.dayStartUnixMs))} UTC'),
              Text(l.dailyReviewAsOf),
              _ReviewTime(widget.asOf),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.dailyReviewReminder),
            value: status.reminderEnabled,
            onChanged: enabled ? (value) => _save(reminder: value) : null,
          ),
          if (status.reviewedToday)
            Semantics(liveRegion: true, child: Text(l.dailyReviewRead))
          else
            FilledButton(
              onPressed: enabled ? () => _save() : null,
              child: Text(l.dailyReviewMarkRead),
            ),
          if (_error case final error?) WarningBanner(error),
        ],
      ),
    );
  }
}

class _NextReview extends StatelessWidget {
  const _NextReview({required this.snapshot});
  final GetDailyReviewResponse snapshot;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    // Prioritize evidence that needs checking and keep this action navigational.
    final (url, label) = switch (snapshot) {
      _
          when snapshot.hasPaperAccount() &&
              (snapshot.paperAccount.entriesPaused ||
                  !paperLedgerMatches(snapshot.reconciliation) ||
                  snapshot.positions.isNotEmpty) =>
        (Dest.paper.path, l.dailyReviewCheckPositions),
      _ when snapshot.events.isNotEmpty => (
        Dest.data.path,
        l.dailyReviewCheckData,
      ),
      _ when snapshot.openWindow.isNotEmpty => (
        Dest.market.path,
        l.dailyReviewCheckMarket,
      ),
      _ when snapshot.shadow.state == ShadowState.SHADOW_STATE_ACTIVE => (
        '/shadow/${snapshot.shadow.id}',
        l.dailyReviewOpenShadow,
      ),
      _ => (Dest.market.path, l.dailyReviewCheckMarket),
    };
    return SectionCard(
      title: l.dailyReviewNext,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: OutlinedButton(
          onPressed: () => context.go(url),
          child: Text(label),
        ),
      ),
    );
  }
}

class _PaperReview extends StatelessWidget {
  const _PaperReview({required this.snapshot});
  final GetDailyReviewResponse snapshot;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SectionCard(
      title: l.paperOpenPositions,
      trailing: TextButton(
        onPressed: () => context.go(Dest.paper.path),
        child: Text(l.navPaper),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!snapshot.hasPaperAccount())
            Text(l.dailyReviewNoPaper)
          else ...[
            if (snapshot.paperAccount.entriesPaused)
              WarningBanner(l.paperEntriesPaused),
            if (!paperLedgerMatches(snapshot.reconciliation))
              WarningBanner(l.paperReconcileMismatch),
            if (snapshot.positions.isEmpty) Text(l.dailyReviewNoPositions),
            for (final p in snapshot.positions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Mono(p.symbol),
                subtitle: Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.xs,
                  children: [
                    Num(moneyValue(p.quantity), unit: p.quantity.asset),
                    if (p.marketValue.hasValue())
                      Num(
                        moneyValue(p.marketValue.value),
                        unit: p.marketValue.value.asset,
                      )
                    else
                      Text(
                        p.marketValue.unavailable.detail.isEmpty
                            ? l.statusLiveUnavailable
                            : p.marketValue.unavailable.detail,
                      ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_left_rounded),
                onTap: () => context.go('/paper/receipts/${p.receiptId}'),
              ),
            if (snapshot.positions.isNotEmpty) ...[
              const Divider(),
              Text(l.dailyReviewConcentration, style: AppText.sectionTitle),
              const SizedBox(height: AppSpace.xs),
              if (snapshot.exposure.isEmpty)
                Text(l.dailyReviewExposureUnavailable)
              else ...[
                Text(l.dailyReviewExposureHelp, style: AppText.caption),
                for (final row in snapshot.exposure)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpace.xs),
                    child: Wrap(
                      spacing: AppSpace.md,
                      runSpacing: AppSpace.xs,
                      children: [
                        Mono(row.symbol),
                        Num(
                          fractionToPct(row.shareOfOpenValue),
                          unit: '%',
                          fractionDigits: 2,
                        ),
                        Num(
                          moneyValue(row.marketValue),
                          unit: row.marketValue.asset,
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

class _OpportunityReview extends StatelessWidget {
  const _OpportunityReview({required this.snapshot});
  final GetDailyReviewResponse snapshot;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final open = _OpportunityList(
        items: snapshot.openWindow,
        total: snapshot.openWindowCount,
        expired: false,
      );
      final expired = _OpportunityList(
        items: snapshot.expired,
        total: snapshot.expiredCount,
        expired: true,
      );
      const gap = AppSpace.md;
      final width = constraints.maxWidth >= 760
          ? (constraints.maxWidth - gap) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          SizedBox(width: width, child: open),
          SizedBox(width: width, child: expired),
        ],
      );
    },
  );
}

class _OpportunityList extends StatelessWidget {
  const _OpportunityList({
    required this.items,
    required this.total,
    required this.expired,
  });
  final List<MarketOpportunity> items;
  final Int64 total;
  final bool expired;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SectionCard(
      title: expired ? l.dailyReviewExpired : l.dailyReviewOpenWindow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (items.isEmpty)
            Text(l.dailyReviewNoOpportunities)
          else ...[
            if (total > Int64(items.length))
              Text(
                l.dailyReviewPreviewCount(items.length, '$total'),
                style: AppText.caption,
              ),
            for (final (i, item) in items.indexed) ...[
              if (i > 0) const Divider(),
              Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.xs,
                children: [Mono(item.symbol), Text(item.ruleTitle)],
              ),
              Text(
                expired
                    ? l.dailyReviewExpiredStatus
                    : item.current
                    ? l.marketOpportunityCurrent
                    : l.dailyReviewUnverified,
              ),
              Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.xs,
                children: [
                  Text(l.marketOpportunityExpires),
                  _ReviewTime(item.expiresAtUnixMs),
                ],
              ),
              Wrap(
                spacing: AppSpace.sm,
                children: [
                  TextButton(
                    onPressed: () => context.go(
                      '/reports/${Uri.encodeComponent(item.reportId)}',
                    ),
                    child: Text(l.marketOpportunityReport),
                  ),
                  if (!expired && item.current)
                    OutlinedButton(
                      onPressed: () => context.go(
                        '${Dest.paper.path}?opportunity=${item.id}',
                      ),
                      child: Text(l.paperReviewOpportunity),
                    ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _ShadowReview extends StatelessWidget {
  const _ShadowReview({required this.snapshot});
  final GetDailyReviewResponse snapshot;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final shadow = snapshot.shadow;
    return SectionCard(
      title: l.dailyReviewShadow,
      child: !snapshot.hasShadow()
          ? Text(l.shadowEmpty)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.xs,
                  children: [
                    Mono(shadow.symbol),
                    Text(snapshot.shadowRuleTitle),
                    Text(shadowStateLabel(l, shadow.state)),
                  ],
                ),
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.xs,
                  children: [
                    Text(l.shadowWindow),
                    _ReviewTime(shadow.startAtUnixMs),
                    _ReviewTime(shadow.endAtUnixMs),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go('/shadow/${shadow.id}'),
                  child: Text(l.dailyReviewOpenShadow),
                ),
              ],
            ),
    );
  }
}

class _EventReview extends StatelessWidget {
  const _EventReview({required this.events});
  final List<DailyReviewEvent> events;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SectionCard(
      title: l.dailyReviewEvents,
      trailing: TextButton(
        onPressed: () => context.go(Dest.data.path),
        child: Text(l.navData),
      ),
      child: events.isEmpty
          ? Text(l.dailyReviewNoEvents)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, event) in events.indexed) ...[
                  if (i > 0) const Divider(),
                  Wrap(
                    spacing: AppSpace.sm,
                    runSpacing: AppSpace.xs,
                    children: [
                      Mono(event.symbol),
                      Text(issueKind(l, event.kind).$1),
                      _ReviewTime(event.detectedAtUnixMs),
                    ],
                  ),
                  if (event.detail.isNotEmpty) Text(event.detail),
                ],
              ],
            ),
    );
  }
}

class _ReviewTime extends StatelessWidget {
  const _ReviewTime(this.value);
  final Int64 value;

  @override
  Widget build(BuildContext context) =>
      Mono('${fmtDateTime(utcMs(value))} UTC');
}
