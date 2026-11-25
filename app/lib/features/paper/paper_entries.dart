import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/nav.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/workspace_status.dart';
import '../../gen/lab/v1/common.pb.dart' show Money;
import '../../gen/lab/v1/paper.pb.dart';
import '../../gen/lab/v1/workspace.pb.dart' show AccountRef;
import '../../gen/lab/v1/workspace.pbenum.dart';
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';
import 'paper_controls.dart';
import 'paper_journal_note.dart';
import 'paper_providers.dart';

String _receiptPath(Int64 id) => '/paper/receipts/$id';

String paperEntryStateLabel(L10n l, PaperEntryState state) => switch (state) {
  PaperEntryState.PAPER_ENTRY_STATE_PENDING => l.paperEntryPending,
  PaperEntryState.PAPER_ENTRY_STATE_PARTIAL => l.paperEntryPartial,
  PaperEntryState.PAPER_ENTRY_STATE_FILLED => l.paperEntryFilled,
  PaperEntryState.PAPER_ENTRY_STATE_CANCELLED => l.paperEntryCancelled,
  PaperEntryState.PAPER_ENTRY_STATE_EXPIRED => l.paperEntryExpired,
  _ => l.statusLiveUnknown,
};

class PaperPlanConfirm extends ConsumerStatefulWidget {
  const PaperPlanConfirm({super.key, required this.review, required this.enabled, required this.onRefresh});

  final GetPaperPlanResponse review;
  final bool enabled;
  final VoidCallback onRefresh;

  @override
  ConsumerState<PaperPlanConfirm> createState() => _PaperPlanConfirmState();
}

class _PaperPlanConfirmState extends ConsumerState<PaperPlanConfirm> {
  final _signal = CancelableSignal();
  bool _busy = false;
  bool _unknown = false;
  String? _restriction;

  @override
  void dispose() {
    _signal.cancel();
    super.dispose();
  }

  Future<void> _confirm() async {
    final plan = widget.review.plan;
    setState(() {
      _busy = true;
      _unknown = false;
      _restriction = null;
    });
    try {
      final result = await ref
          .read(paperClientProvider)
          .confirmPaperPlan(
            ConfirmPaperPlanRequest(account: plan.account, planHash: plan.planHash),
            signal: TimeoutSignal(const Duration(seconds: 15), parent: _signal),
          );
      if (!mounted) return;
      if (result.hasReceipt()) {
        context.go(_receiptPath(result.receipt.id));
        return;
      }
      setState(() => _restriction = result.restriction.detail);
      widget.onRefresh();
    } catch (_) {
      if (mounted) {
        // A response can be lost after commit. Re-read the plan before offering another action.
        setState(() => _unknown = true);
        widget.onRefresh();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    if (widget.review.hasReceipt()) {
      return FilledButton(
        onPressed: () => context.go(_receiptPath(widget.review.receipt.id)),
        child: Text(l.paperViewReceipt),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_unknown) WarningBanner(l.paperConfirmationUnknown),
        if (_restriction case final message? when message.isNotEmpty && !widget.review.hasRestriction())
          WarningBanner(message),
        FilledButton(
          onPressed: widget.enabled && !_busy && !widget.review.hasRestriction() ? _confirm : null,
          child: Text(_busy ? l.paperSaving : l.paperConfirm),
        ),
      ],
    );
  }
}

class PaperActivity extends StatelessWidget {
  const PaperActivity({
    super.key,
    required this.account,
    required this.positions,
    required this.receipts,
    required this.reductionEnabled,
  });

  final AccountRef account;
  final List<PaperPosition> positions;
  final List<PaperReceipt> receipts;
  final bool reductionEnabled;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (positions.isNotEmpty) ...[
          SectionCard(
            title: l.paperOpenPositions,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final position in positions)
                  Padding(
                    key: ValueKey(position.receiptId),
                    padding: const EdgeInsets.only(bottom: AppSpace.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpace.sm,
                          children: [
                            Mono(position.symbol),
                            Num(moneyValue(position.quantity), unit: position.quantity.asset),
                          ],
                        ),
                        PaperMoneyLine(label: l.paperCostBasis, amount: position.costBasis),
                        PaperMoneyLine(
                          label: l.paperPositionValue,
                          amount: position.marketValue.hasValue() ? position.marketValue.value : null,
                        ),
                        Wrap(
                          spacing: AppSpace.sm,
                          children: [
                            PaperReductionControl(account: account, position: position, enabled: reductionEnabled),
                            TextButton(
                              onPressed: () => context.go(_receiptPath(position.receiptId)),
                              child: Text(l.paperViewReceipt),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.md),
        ],
        if (receipts.isNotEmpty)
          SectionCard(
            title: l.paperRecentReceipts,
            child: Column(
              children: [
                for (final receipt in receipts)
                  ListTile(
                    title: Mono('${receipt.symbol} · ${receipt.id}'),
                    subtitle: Text(paperEntryStateLabel(l, receipt.state)),
                    onTap: () => context.go(_receiptPath(receipt.id)),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class PaperReceiptScreen extends ConsumerStatefulWidget {
  const PaperReceiptScreen({super.key, required this.id});

  final Int64 id;

  @override
  ConsumerState<PaperReceiptScreen> createState() => _PaperReceiptScreenState();
}

class _PaperReceiptScreenState extends ConsumerState<PaperReceiptScreen> {
  final _signal = CancelableSignal();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _signal.cancel();
    super.dispose();
  }

  Future<void> _cancel(PaperReceipt receipt) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(paperClientProvider)
          .cancelPaperEntry(
            CancelPaperEntryRequest(account: receipt.account, receiptId: receipt.id),
            signal: TimeoutSignal(const Duration(seconds: 15), parent: _signal),
          );
    } catch (error) {
      if (mounted) setState(() => _error = errorText(error));
    } finally {
      if (mounted) {
        ref.invalidate(paperReceiptProvider(widget.id));
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final provider = paperReceiptProvider(widget.id);
    final state = ref.watch(provider);
    final snapshot = state.value;
    return PageFrame(
      children: [
        PageHeader(
          title: l.paperReceipt,
          actions: [
            const EnvironmentBadge(environment: Environment.ENVIRONMENT_PAPER),
            if (snapshot != null)
              OutlinedButton(
                onPressed: () => context.go('/paper/receipts/${widget.id}/replay'),
                child: Text(l.paperReplayTitle),
              ),
          ],
        ),
        if (snapshot == null)
          AsyncSection(
            value: state,
            onRetry: () => ref.invalidate(provider),
            skeleton: Text(l.paperPlanLoading),
            builder: (_) => const SizedBox.shrink(),
          )
        else ...[
          if (state.hasError) WarningBanner(l.engineUnreachable),
          if (_error case final message?) WarningBanner(message),
          _PaperReceiptSummary(
            receipt: snapshot.receipt,
            reduction: snapshot.hasReduction() ? snapshot.reduction : null,
            busy: _busy,
            onCancel: !_busy && !state.hasError && !state.isLoading ? () => _cancel(snapshot.receipt) : null,
          ),
          SectionCard(
            title: l.paperEventHistory,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (final event in snapshot.events) PaperEventRow(event: event)],
            ),
          ),
          PaperJournalNoteEditor(
            key: ValueKey(widget.id),
            receiptId: widget.id,
            note: snapshot.hasNote() ? snapshot.note : null,
            connected: !state.hasError && !state.isLoading,
          ),
        ],
      ],
    );
  }
}

class _PaperReceiptSummary extends StatelessWidget {
  const _PaperReceiptSummary({required this.receipt, required this.busy, this.onCancel, this.reduction});

  final PaperReceipt receipt;
  final PaperReduction? reduction;
  final bool busy;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final canCancel =
        receipt.state == PaperEntryState.PAPER_ENTRY_STATE_PENDING ||
        receipt.state == PaperEntryState.PAPER_ENTRY_STATE_PARTIAL;
    return SectionCard(
      title: paperEntryStateLabel(l, receipt.state),
      trailing: Mono('${receipt.account.accountId} · ${receipt.symbol} · ${receipt.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PaperMoneyLine(label: l.paperQuantity, amount: receipt.requestedQuantity),
          PaperMoneyLine(label: l.paperFilledQuantity, amount: receipt.filledQuantity),
          PaperMoneyLine(label: l.paperReserved, amount: receipt.reservedCash),
          PaperTimeLine(label: l.paperConfirmedAt, at: receipt.confirmedAtUnixMs),
          PaperTimeLine(label: l.paperEntryExpires, at: receipt.expiresAtUnixMs),
          if (reduction case final attempt?) PaperReductionStatus(reduction: attempt),
          Wrap(
            spacing: AppSpace.sm,
            children: [
              if (canCancel)
                OutlinedButton(onPressed: onCancel, child: Text(busy ? l.paperSaving : l.paperCancelEntry)),
              TextButton(onPressed: () => context.go('/paper/plans/${receipt.planHash}'), child: Text(l.paperViewPlan)),
              TextButton(onPressed: () => context.go(Dest.paper.path), child: Text(l.navPaper)),
            ],
          ),
        ],
      ),
    );
  }
}

class PaperEventRow extends StatelessWidget {
  const PaperEventRow({super.key, required this.event, this.initiallyExpanded = false});

  final PaperExecutionEvent event;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final title = switch (event.kind) {
      'accepted' => l.paperEventAccepted,
      'entry_fill' => l.paperEventEntryFill,
      'stop_exit' => l.paperEventStopExit,
      'target_exit' => l.paperEventTargetExit,
      'manual_exit' => l.paperEventManualExit,
      'reduction_requested' => l.paperEventReduceRequest,
      'reduction_cancelled_remainder' => l.paperEventReduceCancelEntry,
      'cancelled' => l.paperEntryCancelled,
      'expired' => l.paperEntryExpired,
      'protection_cancelled_remainder' => l.paperEventProtectionCancel,
      _ => event.kind,
    };
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      title: Text(title),
      subtitle: Mono('${fmtDateTime(utcMs(event.recordedAtUnixMs))} UTC'),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.all(AppSpace.md),
      children: [
        if (event.hasQuantity()) PaperMoneyLine(label: l.paperFilledQuantity, amount: event.quantity),
        if (event.hasReferencePrice()) PaperMoneyLine(label: l.marketOpportunityPrice, amount: event.referencePrice),
        if (event.hasFillPrice()) PaperMoneyLine(label: l.paperExecutionPrice, amount: event.fillPrice),
        if (event.hasCandleOpenedAtUnixMs())
          PaperTimeLine(label: l.paperExecutionCandle, at: event.candleOpenedAtUnixMs),
        if (event.hasFee()) PaperMoneyLine(label: l.paperEventFee, amount: event.fee),
        if (event.hasCash()) PaperMoneyLine(label: l.paperEventCash, amount: event.cash),
        if (event.hasRealizedPnl()) PaperMoneyLine(label: l.paperRealizedPnl, amount: event.realizedPnl),
      ],
    );
  }
}

class PaperMoneyLine extends StatelessWidget {
  const PaperMoneyLine({super.key, required this.label, required this.amount});

  final String label;
  final Money? amount;

  @override
  Widget build(BuildContext context) {
    final value = amount;
    return Wrap(
      spacing: AppSpace.sm,
      children: [
        Text(label),
        if (value != null) Num(moneyValue(value), unit: value.asset) else Text(L10n.of(context).statusLiveUnavailable),
      ],
    );
  }
}

class PaperTimeLine extends StatelessWidget {
  const PaperTimeLine({super.key, required this.label, required this.at});

  final String label;
  final Int64 at;

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: AppSpace.sm, children: [Text(label), Mono('${fmtDateTime(utcMs(at))} UTC')]);
}
