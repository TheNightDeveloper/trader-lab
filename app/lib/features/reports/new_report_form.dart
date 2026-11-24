import 'package:decimal/decimal.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/engine.dart';
import '../../core/metric.dart';
import '../../core/theme/tokens.dart';
import '../../core/validate.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/data.dart';
import '../../gen/lab/v1/data.pb.dart';
import '../../gen/lab/v1/library.pb.dart';
import '../../gen/lab/v1/report.pb.dart';
import '../../l10n/app_localizations.dart';
import '../data/data_providers.dart';
import '../data/dataset_picker.dart';
import '../data/research_capability_widgets.dart';
import 'report_providers.dart';

/// Quick backtest: datasets + strategy + costs + split → CreateReport. The full
/// six-step experiment builder arrives in M4.
class NewReportForm extends ConsumerStatefulWidget {
  const NewReportForm({
    super.key,
    this.ruleVersions = const [],
    this.requiredTimeframe = '',
  });

  final List<RuleVersionSummary> ruleVersions;
  final String requiredTimeframe;

  @override
  ConsumerState<NewReportForm> createState() => _NewReportFormState();
}

class _NewReportFormState extends ConsumerState<NewReportForm> {
  final _datasets = <String, Dataset>{};
  String _strategy = 'trend-ema';
  final _params = <String, TextEditingController>{};
  final _capital = TextEditingController(text: '10000');
  final _fee = TextEditingController(text: '10');
  final _slip = TextEditingController(text: '5');
  final _folds = TextEditingController(text: '4');
  final _holdout = TextEditingController(text: '20');
  bool _rolling = false, _tried = false, _running = false;
  Object? _error;
  final _completed = <String>[];

  @override
  void dispose() {
    for (final c in [
      _capital,
      _fee,
      _slip,
      _folds,
      _holdout,
      ..._params.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _param(ParamSpec p) => _params.putIfAbsent(
    '$_strategy.${p.name}',
    () => TextEditingController(
      text: p.integer ? p.default_2.toInt().toString() : p.default_2.toString(),
    ),
  );

  String? _paramError(L10n l, ParamSpec p, String s) {
    final v = double.tryParse(s.trim()); // a strategy parameter, not money
    if (v == null || v <= 0) return l.errPositive;
    if (p.integer && v != v.roundToDouble()) return l.errNumber;
    return null;
  }

  Future<void> _submit(L10n l, StrategyInfo? info) async {
    setState(() => _tried = true);
    final allowed = ref
        .read(overviewProvider)
        .value
        ?.researchCapabilities
        .where((c) => c.supported)
        .map((c) => c.symbol)
        .toSet();
    final errs = [
      if (_datasets.isEmpty ||
          allowed == null ||
          !_datasets.values.every((d) => allowed.contains(d.symbol)))
        l.errPickDataset,
      vPositive(l, _capital.text),
      vBps(l, _fee.text),
      vBps(l, _slip.text),
      vInt(l, _folds.text, 1, 12),
      vInt(l, _holdout.text, 5, 45),
      for (final p in info?.params ?? <ParamSpec>[])
        _paramError(l, p, _param(p).text),
    ];
    if (errs.any((e) => e != null)) return;
    setState(() {
      _running = true;
      _error = null;
    });
    try {
      final client = ref.read(reportClientProvider);
      final rules = widget.ruleVersions;
      final spec = ReportSpec(
        datasetIds: _datasets.keys,
        strategy: rules.isEmpty ? _strategy : 'rules/v1',
        params: {
          for (final p in info?.params ?? <ParamSpec>[])
            p.name: double.parse(_param(p).text.trim()),
        }.entries,
        capital: usdtOut(Decimal.parse(_capital.text.trim())),
        fee: bpsOut(Decimal.parse(_fee.text.trim())),
        slippage: bpsOut(Decimal.parse(_slip.text.trim())),
        folds: int.parse(_folds.text.trim()),
        rolling: _rolling,
        holdout: pctOut(Decimal.parse(_holdout.text.trim())),
      );
      // Keep assumptions fixed and resume after the last successful run if a later leg fails.
      for (
        var i = _completed.length;
        i < (rules.isEmpty ? 1 : rules.length);
        i++
      ) {
        if (rules.isNotEmpty) {
          spec.ruleVersionId = rules[i].id;
          spec.ruleContentHash = rules[i].contentHash;
        }
        final response = await client.createReport(
          CreateReportRequest(spec: spec),
        );
        if (!mounted) return;
        setState(() => _completed.add(response.reportId));
        ref.invalidate(reportsProvider);
      }
      if (_completed.length > 1) {
        context.go('/compare?ids=${_completed.join(',')}&composition=1');
      } else {
        context.go('/reports/${_completed.single}');
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final rules = widget.ruleVersions;
    final locked = _running || _completed.isNotEmpty;
    final strategies = rules.isEmpty ? ref.watch(strategiesProvider) : null;
    final info = strategies?.value?.strategies
        .where((s) => s.name == _strategy)
        .firstOrNull;
    Widget field(
      String label,
      TextEditingController c,
      String? Function(String) err, {
      String? suffix,
      String? help,
    }) => SizedBox(
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
        ExcludeFocus(
          excluding: locked,
          child: IgnorePointer(
            ignoring: locked,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (rules.length > 1) ...[
                  for (final (i, version) in rules.indexed)
                    Text(
                      '${['A', 'B', 'A+B'][i]} · ${version.title} (#${version.id})',
                    ),
                  const SizedBox(height: AppSpace.md),
                ],
                Text(l.newDatasets, style: AppText.label),
                const SizedBox(height: AppSpace.sm),
                DatasetPicker(
                  timeframe:
                      _datasets.values.firstOrNull?.timeframe ??
                      widget.requiredTimeframe,
                  selected: _datasets,
                  onPick: (d) => setState(() {
                    // Keep one immutable version per pair for the shared timeframe.
                    _datasets.removeWhere((_, old) => old.symbol == d.symbol);
                    _datasets[d.id] = d;
                  }),
                  onRemove: (id) => setState(() => _datasets.remove(id)),
                ),
                Text(l.newDatasetsHelp, style: AppText.caption),
                const ResearchCapabilityNotice(),
                if (_tried && _datasets.isEmpty)
                  Text(
                    l.errPickDataset,
                    style: AppText.caption.copyWith(
                      color: AppColors.negativeText,
                    ),
                  ),
                const SizedBox(height: AppSpace.lg),
                if (strategies != null) ...[
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
                ],
                if (info != null && info.params.isNotEmpty) ...[
                  const SizedBox(height: AppSpace.md),
                  Text(l.newParams, style: AppText.label),
                  const SizedBox(height: AppSpace.sm),
                  Wrap(
                    spacing: AppSpace.md,
                    runSpacing: AppSpace.md,
                    children: [
                      for (final p in info.params)
                        field(p.name, _param(p), (s) => _paramError(l, p, s)),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpace.lg),
                Wrap(
                  spacing: AppSpace.md,
                  runSpacing: AppSpace.md,
                  children: [
                    field(
                      l.newCapital,
                      _capital,
                      (s) => vPositive(l, s),
                      suffix: 'USDT',
                    ),
                    field(
                      l.newFeeBps,
                      _fee,
                      (s) => vBps(l, s),
                      suffix: l.bps,
                      help: l.bpsHelp,
                    ),
                    field(
                      l.newSlipBps,
                      _slip,
                      (s) => vBps(l, s),
                      suffix: l.bps,
                    ),
                    field(l.newFolds, _folds, (s) => vInt(l, s, 1, 12)),
                    field(
                      l.newHoldout,
                      _holdout,
                      (s) => vInt(l, s, 5, 45),
                      suffix: '%',
                      help: l.newHoldoutHelp,
                    ),
                  ],
                ),
                SwitchListTile(
                  value: _rolling,
                  onChanged: (v) => setState(() => _rolling = v),
                  title: Text(l.newRolling, style: AppText.body),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
        if (rules.length > 1 && locked)
          Semantics(
            liveRegion: true,
            child: Text(
              '${_completed.length} از ${rules.length} بک‌تست پایان یافت.',
            ),
          ),
        for (final (i, id) in _completed.indexed)
          if (rules.length > 1 && !_running)
            TextButton(
              onPressed: () => context.push('/reports/$id'),
              child: Text('گزارش ${['A', 'B', 'A+B'][i]}'),
            ),
        const SizedBox(height: AppSpace.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.icon(
            onPressed: _running || _datasets.isEmpty
                ? null
                : () => _submit(l, info),
            icon: _running
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onAccent,
                    ),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: Text(
              _running
                  ? l.newRunning
                  : _completed.isNotEmpty
                  ? 'ادامهٔ اجرا'
                  : rules.length > 1
                  ? 'اجرای سه بک‌تست'
                  : l.newRun,
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpace.sm),
          Text(
            errorText(_error!),
            style: AppText.body.copyWith(color: AppColors.negativeText),
          ),
        ],
      ],
    );
  }
}
