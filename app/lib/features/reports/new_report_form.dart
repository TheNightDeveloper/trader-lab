import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/data.dart';
import '../../gen/lab/v1/report.pb.dart';
import '../../l10n/app_localizations.dart';
import 'report_providers.dart';

/// Quick backtest: datasets + strategy + costs + split → CreateReport. The full
/// six-step experiment builder arrives in M4.
class NewReportForm extends ConsumerStatefulWidget {
  const NewReportForm({super.key});

  @override
  ConsumerState<NewReportForm> createState() => _NewReportFormState();
}

class _NewReportFormState extends ConsumerState<NewReportForm> {
  Set<String> _datasets = {};
  String _strategy = 'trend-ema';
  final _params = <String, TextEditingController>{};
  final _capital = TextEditingController(text: '10000');
  final _fee = TextEditingController(text: '10');
  final _slip = TextEditingController(text: '5');
  final _folds = TextEditingController(text: '4');
  final _holdout = TextEditingController(text: '20');
  bool _rolling = false, _tried = false, _running = false;
  Object? _error;

  @override
  void dispose() {
    for (final c in [_capital, _fee, _slip, _folds, _holdout, ..._params.values]) {
      c.dispose();
    }
    super.dispose();
  }

  static final _num = RegExp(r'^\d+(\.\d{1,2})?$');

  String? _positive(L10n l, String s) =>
      _num.hasMatch(s.trim()) && Decimal.parse(s.trim()) > Decimal.zero ? null : l.errPositive;
  String? _bps(L10n l, String s) =>
      _num.hasMatch(s.trim()) && Decimal.parse(s.trim()) <= Decimal.fromInt(1000) ? null : l.errBps;
  String? _int(L10n l, String s, int lo, int hi) {
    final v = int.tryParse(s.trim());
    return v != null && v >= lo && v <= hi ? null : l.errNumber;
  }

  TextEditingController _param(ParamSpec p) => _params.putIfAbsent(
    '$_strategy.${p.name}',
    () => TextEditingController(text: p.integer ? p.default_2.toInt().toString() : p.default_2.toString()),
  );

  String? _paramError(L10n l, ParamSpec p, String s) {
    final v = double.tryParse(s.trim()); // a strategy parameter, not money
    if (v == null || v <= 0) return l.errPositive;
    if (p.integer && v != v.roundToDouble()) return l.errNumber;
    return null;
  }

  Future<void> _submit(L10n l, StrategyInfo? info) async {
    setState(() => _tried = true);
    final errs = [
      if (_datasets.isEmpty) l.errPickDataset,
      _positive(l, _capital.text),
      _bps(l, _fee.text),
      _bps(l, _slip.text),
      _int(l, _folds.text, 1, 12),
      _int(l, _holdout.text, 5, 45),
      for (final p in info?.params ?? <ParamSpec>[]) _paramError(l, p, _param(p).text),
    ];
    if (errs.any((e) => e != null)) return;
    setState(() {
      _running = true;
      _error = null;
    });
    try {
      final res = await ref
          .read(reportClientProvider)
          .createReport(
            CreateReportRequest(
              spec: ReportSpec(
                datasetIds: _datasets,
                strategy: _strategy,
                params: {
                  for (final p in info?.params ?? <ParamSpec>[]) p.name: double.parse(_param(p).text.trim()),
                }.entries,
                capital: usdtOut(Decimal.parse(_capital.text.trim())),
                fee: bpsOut(Decimal.parse(_fee.text.trim())),
                slippage: bpsOut(Decimal.parse(_slip.text.trim())),
                folds: int.parse(_folds.text.trim()),
                rolling: _rolling,
                holdout: pctOut(Decimal.parse(_holdout.text.trim())),
              ),
            ),
          );
      ref.invalidate(reportsProvider);
      if (mounted) context.go('/reports/${res.reportId}');
    } catch (e) {
      setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final datasets = ref.watch(allDatasetsProvider);
    final strategies = ref.watch(strategiesProvider);
    final info = strategies.value?.strategies.where((s) => s.name == _strategy).firstOrNull;
    Widget field(String label, TextEditingController c, String? Function(String) err, {String? suffix, String? help}) =>
        SizedBox(
          width: 200,
          child: TextField(
            controller: c,
            textDirection: TextDirection.ltr,
            style: AppText.mono,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: label,
              suffix: unitSuffix(suffix),
              helperText: help,
              helperMaxLines: 2,
              errorText: _tried ? err(c.text) : null,
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.newDatasets, style: AppText.label),
        const SizedBox(height: AppSpace.sm),
        AsyncSection(
          value: datasets,
          onRetry: () => ref.invalidate(allDatasetsProvider),
          skeleton: const SizedBox(height: 44),
          isEmpty: (r) => r.datasets.isEmpty,
          empty: Text(l.newDatasetsEmpty, style: AppText.caption),
          builder: (r) => LabChoiceChips<String>(
            multi: true,
            ltr: true,
            options: [
              for (final d in r.datasets)
                (d.id, '${d.symbol} ${d.timeframe} · ${fmtDate(utcMs(d.fromUnixMs))} · ${shortHash(d.id)}'),
            ],
            selected: _datasets,
            onChanged: (v) => setState(() => _datasets = v),
          ),
        ),
        Text(l.newDatasetsHelp, style: AppText.caption),
        if (_tried && _datasets.isEmpty)
          Text(l.errPickDataset, style: AppText.caption.copyWith(color: AppColors.negativeText)),
        const SizedBox(height: AppSpace.lg),
        Text(l.newStrategy, style: AppText.label),
        const SizedBox(height: AppSpace.sm),
        AsyncSection(
          value: strategies,
          onRetry: () => ref.invalidate(strategiesProvider),
          skeleton: const SizedBox(height: 44),
          builder: (r) => LabChoiceChips<String>(
            ltr: true,
            options: [for (final s in r.strategies) (s.name, s.name)],
            selected: {_strategy},
            onChanged: (v) => setState(() => _strategy = v.first),
          ),
        ),
        if (info != null && info.params.isNotEmpty) ...[
          const SizedBox(height: AppSpace.md),
          Text(l.newParams, style: AppText.label),
          const SizedBox(height: AppSpace.sm),
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.md,
            children: [for (final p in info.params) field(p.name, _param(p), (s) => _paramError(l, p, s))],
          ),
        ],
        const SizedBox(height: AppSpace.lg),
        Wrap(
          spacing: AppSpace.md,
          runSpacing: AppSpace.md,
          children: [
            field(l.newCapital, _capital, (s) => _positive(l, s), suffix: 'USDT'),
            field(l.newFeeBps, _fee, (s) => _bps(l, s), suffix: l.bps, help: l.bpsHelp),
            field(l.newSlipBps, _slip, (s) => _bps(l, s), suffix: l.bps),
            field(l.newFolds, _folds, (s) => _int(l, s, 1, 12)),
            field(l.newHoldout, _holdout, (s) => _int(l, s, 5, 45), suffix: '%', help: l.newHoldoutHelp),
          ],
        ),
        SwitchListTile(
          value: _rolling,
          onChanged: (v) => setState(() => _rolling = v),
          title: Text(l.newRolling, style: AppText.body),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpace.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.icon(
            onPressed: _running ? null : () => _submit(l, info),
            icon: _running
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: Text(_running ? l.newRunning : l.newRun),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpace.sm),
          Text(errorText(_error!), style: AppText.body.copyWith(color: AppColors.negativeText)),
        ],
      ],
    );
  }
}
