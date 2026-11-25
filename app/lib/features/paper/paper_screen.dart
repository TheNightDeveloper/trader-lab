import 'package:connectrpc/connect.dart';
import 'package:decimal/decimal.dart';
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
import '../../core/widgets/workspace_status.dart';
import '../../gen/lab/v1/common.pb.dart' show Money;
import '../../gen/lab/v1/paper.pb.dart';
import '../../gen/lab/v1/workspace.pbenum.dart';
import '../../l10n/app_localizations.dart';
import '../library/rule_editor.dart' show ruleNumber;
import '../page_frame.dart';
import 'paper_entries.dart';
import 'paper_providers.dart';

class PaperScreen extends ConsumerWidget {
  const PaperScreen({super.key, this.opportunityId});

  final Int64? opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final accountState = ref.watch(paperAccountProvider);
    final snapshot = accountState.value;
    final id = opportunityId;
    final account = snapshot != null && snapshot.hasPaperAccount() ? snapshot.paperAccount : null;
    return PageFrame(
      children: [
        PageHeader(title: Dest.paper.label(l), subtitle: Dest.paper.subtitle(l), actions: const [_PaperBadge()]),
        if (snapshot == null)
          AsyncSection(
            value: accountState,
            onRetry: () => ref.invalidate(paperAccountProvider),
            skeleton: Text(l.paperLoading),
            builder: (_) => const SizedBox.shrink(),
          )
        else ...[
          if (accountState.hasError) WarningBanner(l.engineUnreachable),
          if (account == null)
            _PaperAmountsForm(
              title: l.paperCreateAccount,
              labels: [l.paperInitialCapital, l.paperMaxLoss, l.paperMaxOpenLoss, l.paperMaxExposure],
              action: l.paperCreateAccount,
              enabled: !accountState.hasError,
              submit: (values, signal) async {
                await ref
                    .read(paperClientProvider)
                    .initializePaperAccount(
                      InitializePaperAccountRequest(
                        capital: values[0],
                        maxLossPerTrade: values[1],
                        maxOpenLoss: values[2],
                        maxSpotExposure: values[3],
                      ),
                      signal: signal,
                    );
                if (context.mounted) ref.invalidate(paperAccountProvider);
                return null;
              },
            )
          else ...[
            _PaperAccountSummary(account: account),
            if (id != null && id > Int64.ZERO)
              _PaperAmountsForm(
                key: ValueKey(id),
                title: l.paperReviewOpportunity,
                labels: [l.paperStop, l.paperTarget],
                action: l.paperBuildPlan,
                enabled: !accountState.hasError,
                submit: (values, signal) async {
                  final result = await ref
                      .read(paperClientProvider)
                      .previewPaperPlan(
                        PreviewPaperPlanRequest(
                          account: account.snapshot.account,
                          opportunityId: id,
                          stop: values[0],
                          takeProfit: values[1],
                        ),
                        signal: signal,
                      );
                  if (context.mounted && result.hasPlan()) context.go('/paper/plans/${result.plan.planHash}');
                  return result.hasRestriction() ? result.restriction.detail : null;
                },
              ),
            PaperActivity(positions: snapshot.positions, receipts: snapshot.recentReceipts),
          ],
        ],
      ],
    );
  }
}

class PaperPlanScreen extends ConsumerWidget {
  const PaperPlanScreen({super.key, required this.hash});

  final String hash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final provider = paperPlanProvider(hash);
    final state = ref.watch(provider);
    final review = state.value;
    return PageFrame(
      children: [
        PageHeader(title: l.paperPlanTitle, actions: const [_PaperBadge()]),
        if (review == null)
          AsyncSection(
            value: state,
            onRetry: () => ref.invalidate(provider),
            skeleton: Text(l.paperPlanLoading),
            builder: (_) => const SizedBox.shrink(),
          )
        else ...[
          if (state.hasError) WarningBanner(l.engineUnreachable),
          if (review.hasRestriction()) WarningBanner(review.restriction.detail),
          _PaperPlanSummary(
            plan: review.plan,
            confirm: PaperPlanConfirm(
              review: review,
              enabled: !state.hasError && !state.isLoading,
              onRefresh: () => ref.invalidate(provider),
            ),
          ),
        ],
      ],
    );
  }
}

class _PaperBadge extends StatelessWidget {
  const _PaperBadge();

  @override
  Widget build(BuildContext context) => const EnvironmentBadge(environment: Environment.ENVIRONMENT_PAPER);
}

class _PaperAccountSummary extends StatelessWidget {
  const _PaperAccountSummary({required this.account});

  final PaperAccount account;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final snapshot = account.snapshot;
    return SectionCard(
      title: l.navPaper,
      trailing: Mono(snapshot.account.accountId),
      child: _PaperReadings(
        values: [
          (l.paperAvailable, snapshot.availableBalance.hasValue() ? snapshot.availableBalance.value : null),
          (l.paperReserved, account.reservedBalance),
          (l.paperEquity, snapshot.equity.hasValue() ? snapshot.equity.value : null),
          (l.paperMaxLoss, account.maxLossPerTrade),
          (l.paperMaxOpenLoss, account.maxOpenLoss),
          (l.paperMaxExposure, account.maxSpotExposure),
        ],
      ),
    );
  }
}

class _PaperPlanSummary extends StatelessWidget {
  const _PaperPlanSummary({required this.plan, required this.confirm});

  final PaperPlan plan;
  final Widget confirm;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SectionCard(
      title: l.paperRiskSummary,
      trailing: Wrap(spacing: AppSpace.sm, children: [Mono(plan.instrument.symbol), Mono(plan.account.accountId)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PaperReadings(
            values: [
              (l.paperPlannedLoss, plan.plannedLoss),
              (l.paperEstimatedCost, plan.estimatedCost),
              (l.paperRequiredCash, plan.requiredCash),
              (l.paperQuantity, plan.quantity),
              (l.paperNotional, plan.notional),
              (l.paperExpectedEntry, plan.estimatedEntry),
              (l.paperEntryLimit, plan.maxEntryPrice),
              (l.paperStop, plan.stop),
              (l.paperTarget, plan.takeProfit),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Text(l.paperFillAssumptions, style: AppText.caption),
          Wrap(
            spacing: AppSpace.sm,
            children: [
              Text(l.paperFeeRate),
              Num(fractionToBps(plan.feeRate), unit: 'bps'),
            ],
          ),
          Wrap(
            spacing: AppSpace.sm,
            children: [
              Text(l.paperSlippageRate),
              Num(fractionToBps(plan.slippageRate), unit: 'bps'),
            ],
          ),
          Wrap(
            spacing: AppSpace.sm,
            children: [Text(l.paperCandleTime), Mono('${fmtDateTime(utcMs(plan.referenceCandleClosedAtUnixMs))} UTC')],
          ),
          Wrap(
            spacing: AppSpace.sm,
            children: [Text(l.paperPlanExpiry), Mono('${fmtDateTime(utcMs(plan.expiresAtUnixMs))} UTC')],
          ),
          const SizedBox(height: AppSpace.sm),
          confirm,
          Wrap(
            spacing: AppSpace.sm,
            children: [
              TextButton(
                onPressed: () => context.go('/reports/${Uri.encodeComponent(plan.reportId)}'),
                child: Text(l.marketOpportunityReport),
              ),
              OutlinedButton(
                onPressed: () => context.go('${Dest.paper.path}?opportunity=${plan.opportunityId}'),
                child: Text(l.paperReviewAgain),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaperReadings extends StatelessWidget {
  const _PaperReadings({required this.values});

  final List<(String, Money?)> values;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final (label, amount) in values)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.xs),
          child: Wrap(
            spacing: AppSpace.sm,
            children: [
              Text(label),
              if (amount != null)
                Num(moneyValue(amount), unit: amount.asset)
              else
                Text(L10n.of(context).statusLiveUnavailable),
            ],
          ),
        ),
    ],
  );
}

class _PaperAmountsForm extends StatefulWidget {
  const _PaperAmountsForm({
    super.key,
    required this.title,
    required this.labels,
    required this.action,
    required this.enabled,
    required this.submit,
  });

  final String title, action;
  final List<String> labels;
  final bool enabled;
  final Future<String?> Function(List<Money>, AbortSignal) submit;

  @override
  State<_PaperAmountsForm> createState() => _PaperAmountsFormState();
}

class _PaperAmountsFormState extends State<_PaperAmountsForm> {
  final _form = GlobalKey<FormState>();
  final _signal = CancelableSignal();
  late final _controllers = widget.labels.map((_) => TextEditingController()).toList();
  bool _busy = false;
  String? _error;

  static final _amount = RegExp(r'^\d+(\.\d{1,8})?$');

  static Decimal? _parse(String? value) {
    final text = ruleNumber(value ?? '');
    return _amount.hasMatch(text) ? Decimal.tryParse(text) : null;
  }

  @override
  void dispose() {
    _signal.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final values = _controllers.map((c) => usdtOut(_parse(c.text)!)).toList();
      final detail = await widget.submit(values, TimeoutSignal(const Duration(seconds: 15), parent: _signal));
      if (mounted) setState(() => _error = detail);
    } catch (error) {
      if (mounted) setState(() => _error = errorText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SectionCard(
      title: widget.title,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (index, label) in widget.labels.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.md),
                child: TextFormField(
                  controller: _controllers[index],
                  enabled: !_busy,
                  maxLength: 30,
                  textDirection: TextDirection.ltr,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: label, suffix: unitSuffix('USDT'), counterText: ''),
                  validator: (_) {
                    final value = _parse(_controllers[index].text);
                    return value == null || value <= Decimal.zero ? l.paperAmountError : null;
                  },
                ),
              ),
            FilledButton(
              onPressed: widget.enabled && !_busy ? _submit : null,
              child: Text(_busy ? l.paperSaving : widget.action),
            ),
            if (_error case final detail?) WarningBanner(detail),
          ],
        ),
      ),
    );
  }
}
