import 'package:connectrpc/connect.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/common.pb.dart' show Money;
import '../../gen/lab/v1/paper.pb.dart';
import '../../gen/lab/v1/workspace.pb.dart' show AccountRef;
import '../../l10n/app_localizations.dart';
import '../library/rule_editor.dart' show ruleNumber;
import 'paper_providers.dart';

bool paperLedgerMatches(PaperReconciliation status) =>
    status.cashMatches && status.reservationsMatch && status.positionsMatch && status.eventsMatch;

class PaperRiskControls extends ConsumerStatefulWidget {
  const PaperRiskControls({super.key, required this.account, required this.reconciliation, required this.enabled});

  final PaperAccount account;
  final PaperReconciliation reconciliation;
  final bool enabled;

  @override
  ConsumerState<PaperRiskControls> createState() => _PaperRiskControlsState();
}

class _PaperRiskControlsState extends ConsumerState<PaperRiskControls> {
  final _signal = CancelableSignal();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _signal.cancel();
    super.dispose();
  }

  Future<void> _setPause(bool paused) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(paperClientProvider)
          .setPaperEntryPause(
            SetPaperEntryPauseRequest(account: widget.account.snapshot.account, paused: paused),
            signal: TimeoutSignal(const Duration(seconds: 15), parent: _signal),
          );
    } catch (error) {
      if (mounted) setState(() => _error = errorText(error));
    } finally {
      if (mounted) {
        ref.invalidate(paperAccountProvider);
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final status = widget.reconciliation;
    final paused = widget.account.entriesPaused;
    return SectionCard(
      title: l.paperRiskControls,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paperLedgerMatches(status))
            Text(l.paperReconciled)
          else ...[
            WarningBanner(l.paperReconcileMismatch),
            if (!status.cashMatches) Text(l.paperReconcileCash),
            if (!status.reservationsMatch) Text(l.paperReconcileReservations),
            if (!status.positionsMatch) Text(l.paperReconcilePositions),
            if (!status.eventsMatch) Text(l.paperReconcileEvents),
          ],
          Wrap(
            spacing: AppSpace.sm,
            children: [Text(l.paperReconcileChecked), Mono('${fmtDateTime(utcMs(status.checkedAtUnixMs))} UTC')],
          ),
          if (paused) Text(l.paperEntriesPaused, style: AppText.caption),
          if (_error case final message?) WarningBanner(message),
          OutlinedButton(
            onPressed: widget.enabled && !_busy ? () => _setPause(!paused) : null,
            child: Text(
              _busy
                  ? l.paperSaving
                  : paused
                  ? l.paperResumeEntries
                  : l.paperPauseEntries,
            ),
          ),
        ],
      ),
    );
  }
}

class PaperReductionControl extends ConsumerStatefulWidget {
  const PaperReductionControl({super.key, required this.account, required this.position, required this.enabled});

  final AccountRef account;
  final PaperPosition position;
  final bool enabled;

  @override
  ConsumerState<PaperReductionControl> createState() => _PaperReductionControlState();
}

class _PaperReductionControlState extends ConsumerState<PaperReductionControl> {
  final _signal = CancelableSignal();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _signal.cancel();
    super.dispose();
  }

  Future<void> _reduce() async {
    final position = widget.position;
    final amount = await showDialog<Money>(
      context: context,
      builder: (_) => _PaperReductionDialog(position: position),
    );
    if (!mounted || amount == null || !widget.enabled) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(paperClientProvider)
          .reducePaperPosition(
            ReducePaperPositionRequest(
              account: widget.account,
              receiptId: position.receiptId,
              positionRevision: position.revision,
              quantity: amount,
            ),
            signal: TimeoutSignal(const Duration(seconds: 15), parent: _signal),
          );
      if (mounted && result.hasRestriction()) setState(() => _error = result.restriction.detail);
    } catch (error) {
      if (mounted) setState(() => _error = errorText(error));
    } finally {
      if (mounted) {
        ref.invalidate(paperAccountProvider);
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final position = widget.position;
    if (position.hasPendingReduction()) return PaperReductionStatus(reduction: position.pendingReduction);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_error case final message?) WarningBanner(message),
        OutlinedButton(
          onPressed: widget.enabled && !_busy ? _reduce : null,
          child: Text(_busy ? l.paperSaving : l.paperReducePosition),
        ),
      ],
    );
  }
}

class PaperReductionStatus extends StatelessWidget {
  const PaperReductionStatus({super.key, required this.reduction});

  final PaperReduction reduction;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final label = switch (reduction.state) {
      PaperReductionState.PAPER_REDUCTION_STATE_PENDING => l.paperReductionPending,
      PaperReductionState.PAPER_REDUCTION_STATE_FILLED => l.paperReductionFilled,
      PaperReductionState.PAPER_REDUCTION_STATE_SUPERSEDED => l.paperReductionSuperseded,
      _ => l.statusLiveUnknown,
    };
    return Wrap(
      spacing: AppSpace.sm,
      children: [
        Text(label),
        Num(moneyValue(reduction.quantity), unit: reduction.quantity.asset),
      ],
    );
  }
}

class _PaperReductionDialog extends StatefulWidget {
  const _PaperReductionDialog({required this.position});

  final PaperPosition position;

  @override
  State<_PaperReductionDialog> createState() => _PaperReductionDialogState();
}

class _PaperReductionDialogState extends State<_PaperReductionDialog> {
  late final _quantity = TextEditingController(text: moneyValue(widget.position.quantity).toString());
  final _form = GlobalKey<FormState>();

  static final _amount = RegExp(r'^\d+(\.\d{1,8})?$');

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  Money? _validatedQuantity() {
    final raw = ruleNumber(_quantity.text);
    final value = _amount.hasMatch(raw) ? Decimal.tryParse(raw) : null;
    final held = widget.position.quantity;
    if (value == null || value <= Decimal.zero || value > moneyValue(held)) return null;
    final units = value.shift(held.scale);
    final lot = moneyValue(widget.position.lot).shift(held.scale);
    if (!units.isInteger || !lot.isInteger || lot <= Decimal.zero || units.toBigInt() % lot.toBigInt() != BigInt.zero) {
      return null;
    }
    final exact = decOut(value, held.scale);
    return Money(units: exact.units, scale: exact.scale, asset: held.asset);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return AlertDialog(
      title: Text(l.paperReducePosition),
      scrollable: true,
      content: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.paperReduceDescription),
            Wrap(
              spacing: AppSpace.sm,
              children: [
                Text(l.paperReduceLot),
                Num(moneyValue(widget.position.lot), unit: widget.position.lot.asset),
              ],
            ),
            TextFormField(
              controller: _quantity,
              maxLength: 30,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: l.paperReduceAmount,
                suffix: unitSuffix(widget.position.quantity.asset),
                counterText: '',
              ),
              validator: (_) => _validatedQuantity() == null ? l.paperReduceAmountError : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.cancel)),
        FilledButton(
          onPressed: () {
            if (_form.currentState!.validate()) Navigator.of(context).pop(_validatedQuantity());
          },
          child: Text(l.paperReduceRequest),
        ),
      ],
    );
  }
}
