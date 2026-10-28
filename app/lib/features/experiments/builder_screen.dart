import 'dart:async';
import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/local_store.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/validate.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/status.dart';
import '../../gen/lab/v1/data.pb.dart';
import '../../gen/lab/v1/experiment.pb.dart';
import '../../gen/lab/v1/library.pb.dart';
import '../../gen/lab/v1/report.pb.dart' show ParamSpec;
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';
import '../reports/report_providers.dart';
import 'experiment_providers.dart';

const draftKey = 'lab.builder.draft.v1';
const _tfOrder = ['1m', '5m', '15m', '1h', '4h', '1d'];
const _lastStep = 5;

String _today() {
  final n = DateTime.now();
  return '${n.year}${two(n.month)}${two(n.day)}';
}

Map<String, String> _defaults() => {
  'tpl': 'search',
  'name': '',
  'hypothesis': '',
  'falsifier': '',
  'goal': 'net',
  'timeframe': '',
  'algo': '',
  'capital': '10000',
  'fee': '10',
  'slip': '5',
  'folds': '4',
  'holdout': '20',
  'maxDd': '25',
  'minTrades': '10',
  'minReturn': '0',
  'mode': 'grid',
  'seed': _today(),
  'maxAttempts': '500',
  'maxMinutes': '60',
};

/// Parameter values typed as "9, 12, 15" (Persian comma too). Null if any is not a
/// positive number, or not whole for an integer parameter. Empty = keep default.
List<double>? parseValues(String s, bool integer) {
  final out = <double>[];
  for (final t in s.split(RegExp(r'[,،\s]+')).where((t) => t.isNotEmpty)) {
    final v = double.tryParse(t); // strategy parameter (model math), not money
    if (v == null || v <= 0 || (integer && v != v.roundToDouble())) return null;
    if (!out.contains(v)) out.add(v);
  }
  return out;
}

/// Starting values for a template. Search: three values around each default
/// (exposure is position sizing, not a rule, so it stays). Idea: two values of the
/// first parameter. Quick: defaults only.
Map<String, String> prefill(AlgorithmVersion? v, String tpl) {
  if (v == null || tpl == 'quick' || v.params.isEmpty) return {};
  String vals(ParamSpec p, List<double> f) =>
      f.map((x) => p.default_2 * x).map((x) => p.integer ? x.roundToDouble() : x).toSet().map(fmtParam).join(', ');
  if (tpl == 'idea') {
    return {
      v.params.first.name: vals(v.params.first, [1, 1.5]),
    };
  }
  return {
    for (final p in v.params)
      if (p.name != 'exposure') p.name: vals(p, [0.75, 1, 1.25]),
  };
}

class BuilderScreen extends ConsumerStatefulWidget {
  const BuilderScreen({super.key, this.algo});

  /// Preselected algorithm version (from the library), e.g. trend-ema@v1.
  final String? algo;

  @override
  ConsumerState<BuilderScreen> createState() => _BuilderScreenState();
}

class _BuilderScreenState extends ConsumerState<BuilderScreen> {
  var f = _defaults();
  var ds = <String>{};
  var vals = <String, String>{};
  var rolling = false;
  var step = 0, reached = 0, gen = 0;
  var tried = false, restored = false, adv = false, reverse = false, running = false;
  EstimateResponse? est;
  String? estErr;
  Object? runErr;
  Timer? _debounce;
  var _estSeq = 0;

  @override
  void initState() {
    super.initState();
    final raw = localGet(draftKey);
    if (raw != null) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        f = {..._defaults(), ...(j['f'] as Map).cast<String, String>()};
        ds = {...(j['ds'] as List).cast<String>()};
        vals = (j['vals'] as Map).cast<String, String>();
        rolling = j['rolling'] as bool;
        step = j['step'] as int;
        reached = j['reached'] as int;
        restored = true;
      } catch (_) {
        localRemove(draftKey); // an old or broken draft: start clean
      }
    }
    if (widget.algo != null && widget.algo != f['algo']) {
      f['algo'] = widget.algo!;
      vals = {};
    }
    _scheduleEstimate();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _changed() {
    setState(() {});
    localSet(
      draftKey,
      jsonEncode({'f': f, 'ds': ds.toList(), 'vals': vals, 'rolling': rolling, 'step': step, 'reached': reached}),
    );
    _scheduleEstimate();
  }

  void _reset() {
    localRemove(draftKey);
    setState(() {
      f = _defaults();
      ds = {};
      vals = {};
      rolling = false;
      step = reached = 0;
      tried = restored = adv = false;
      gen++;
      est = null;
      estErr = null;
    });
  }

  AlgorithmVersion? get _version {
    for (final a in ref.read(algorithmsProvider).value?.algorithms ?? <Algorithm>[]) {
      for (final v in a.versions) {
        if (v.id == f['algo']) return v;
      }
    }
    return null;
  }

  // ---- definition -------------------------------------------------------------

  Map<String, ParamRange>? _space() {
    final v = _version;
    if (v == null) return null;
    final out = <String, ParamRange>{};
    for (final p in v.params) {
      final xs = parseValues(vals[p.name] ?? '', p.integer);
      if (xs == null) return null;
      if (xs.isNotEmpty) out[p.name] = ParamRange(values: xs);
    }
    return out;
  }

  /// The definition the engine will lock, or null while inputs are incomplete.
  /// [forEstimate] fills empty text so the run count shows before step 1 is done.
  ExperimentDefinition? _definition({bool forEstimate = false}) {
    if (ds.isEmpty || f['algo']!.isEmpty) return null;
    final space = _space();
    if (space == null) return null;
    try {
      String frac(String k) => (Decimal.parse(f[k]!.trim()) / Decimal.fromInt(100)).toDecimal().toString();
      String text(String k) => forEstimate && f[k]!.trim().isEmpty ? '-' : f[k]!.trim();
      final goal = f['goal'];
      return ExperimentDefinition(
        name: text('name'),
        hypothesis: text('hypothesis'),
        falsifier: text('falsifier'),
        objective: switch (goal) {
          'dd' => Objective(metric: 'max_drawdown', maximize: false),
          'stable' => Objective(metric: 'sharpe', maximize: true),
          _ => Objective(metric: 'total_return', maximize: true),
        },
        constraints: [
          if (goal == 'dd')
            Constraint(metric: 'total_return', op: '>=', value: frac('minReturn'))
          else
            Constraint(metric: 'max_drawdown', op: '<=', value: frac('maxDd')),
          Constraint(metric: 'closed_trades', op: '>=', value: '${int.parse(f['minTrades']!.trim())}'),
        ],
        datasetIds: [...ds]..sort(),
        algorithmVersion: f['algo'],
        space: space.entries,
        search: SearchPlan(
          mode: f['mode'],
          seed: Int64.parseInt(f['seed']!.trim()),
          maxAttempts: int.parse(f['maxAttempts']!.trim()),
          maxWallSeconds: int.parse(f['maxMinutes']!.trim()) * 60,
        ),
        capital: usdtOut(Decimal.parse(f['capital']!.trim())),
        fee: bpsOut(Decimal.parse(f['fee']!.trim())),
        slippage: bpsOut(Decimal.parse(f['slip']!.trim())),
        folds: int.parse(f['folds']!.trim()),
        rolling: rolling,
        holdout: pctOut(Decimal.parse(f['holdout']!.trim())),
      );
    } catch (_) {
      return null; // a field is invalid; its own error text says which
    }
  }

  void _scheduleEstimate() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _estimate);
  }

  Future<void> _estimate() async {
    final def = _definition(forEstimate: true);
    final seq = ++_estSeq;
    if (def == null) {
      if (mounted) {
        setState(() {
          est = null;
          estErr = null;
        });
      }
      return;
    }
    try {
      final r = await ref.read(experimentClientProvider).estimate(EstimateRequest(definition: def));
      if (!mounted || seq != _estSeq) return;
      setState(() {
        est = r.error.isEmpty ? r : null;
        estErr = r.error.isEmpty ? null : r.error;
      });
    } catch (e) {
      if (mounted && seq == _estSeq) {
        setState(() {
          est = null;
          estErr = errorText(e);
        });
      }
    }
  }

  // ---- validation and navigation -----------------------------------------------

  List<Dataset> get _datasets => ref.read(allDatasetsProvider).value?.datasets ?? const [];

  List<String> _errors(L10n l, int s) => switch (s) {
    1 => [
      for (final k in ['name', 'hypothesis', 'falsifier'])
        if (f[k]!.trim().isEmpty) l.errHypothesis,
    ],
    2 => [
      if (ds.isEmpty) l.errPickDataset,
      if (_datasets.where((d) => ds.contains(d.id)).map((d) => d.symbol).toSet().length != ds.length)
        l.errDatasetsPerPair,
    ],
    3 => [if (f['algo']!.isEmpty) l.errRequired, if (_space() == null) l.errValues],
    4 => [vPositive(l, f['capital']!), vBps(l, f['fee']!), vBps(l, f['slip']!)],
    5 => [
      vInt(l, f['folds']!, 1, 12),
      vInt(l, f['holdout']!, 5, 45),
      vPositive(l, f['maxDd']!),
      vInt(l, f['minTrades']!, 0, 100000),
      vNonNegative(l, f['minReturn']!),
      RegExp(r'^\d{1,18}$').hasMatch(f['seed']!.trim()) ? null : l.errNumber,
      vInt(l, f['maxAttempts']!, 1, 5000),
      vInt(l, f['maxMinutes']!, 1, 1440),
    ],
    _ => const [],
  }.whereType<String>().toList();

  void _go(int to) {
    reverse = to < step;
    step = to;
    if (reached < to) reached = to;
    tried = false;
    _changed();
  }

  void _next(L10n l) {
    if (_errors(l, step).isNotEmpty) return setState(() => tried = true);
    _go(step + 1);
  }

  Future<void> _run(L10n l) async {
    for (var s = 1; s <= _lastStep; s++) {
      if (_errors(l, s).isNotEmpty) {
        _go(s);
        return setState(() => tried = true);
      }
    }
    final def = _definition();
    if (def == null) return;
    setState(() {
      running = true;
      runErr = null;
    });
    try {
      final r = await ref.read(experimentClientProvider).createExperiment(CreateExperimentRequest(definition: def));
      localRemove(draftKey);
      ref.invalidate(experimentsProvider);
      if (!mounted) return;
      if (r.alreadyExisted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.bExisted)));
      context.go('/experiments/${r.experimentId}/queue');
    } catch (e) {
      if (mounted) setState(() => runErr = e);
    } finally {
      if (mounted) setState(() => running = false);
    }
  }

  // ---- widgets -----------------------------------------------------------------

  Widget _field(
    String k,
    String label, {
    String? Function(String)? err,
    String? unit,
    String? help,
    bool ltr = true,
    int lines = 1,
    double? width = 200,
  }) => SizedBox(
    width: width,
    child: TextFormField(
      key: ValueKey('$k.$gen'),
      initialValue: f[k],
      textDirection: ltr ? TextDirection.ltr : null,
      style: ltr ? AppText.mono : AppText.body,
      minLines: lines,
      maxLines: lines == 1 ? 1 : lines + 2,
      onChanged: (v) {
        f[k] = v;
        _changed();
      },
      decoration: InputDecoration(
        labelText: label,
        suffix: unitSuffix(unit),
        helperText: help,
        helperMaxLines: 3,
        errorText: tried && err != null ? err(f[k]!) : null,
      ),
    ),
  );

  Widget _card({required bool on, required VoidCallback onTap, required Widget child, double width = 280}) => SizedBox(
    width: width,
    child: Semantics(
      button: true,
      selected: on,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: AnimatedContainer(
            duration: AppMotion.of(context, AppMotion.fast),
            padding: const EdgeInsets.all(AppSpace.lg),
            decoration: BoxDecoration(
              color: on ? AppColors.accentStrongBg : AppColors.inputBg,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: on ? AppColors.accent : AppColors.border, width: 2),
            ),
            child: child,
          ),
        ),
      ),
    ),
  );

  String _tplTitle(L10n l) => switch (f['tpl']) {
    'quick' => l.tplQuick,
    'idea' => l.tplIdea,
    _ => l.tplSearch,
  };

  String _goalTitle(L10n l) => switch (f['goal']) {
    'dd' => l.goalDd,
    'stable' => l.goalStable,
    _ => l.goalNet,
  };

  Widget _stepStart(L10n l) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(l.bWhat, style: AppText.sectionTitle),
      const SizedBox(height: AppSpace.md),
      Wrap(
        spacing: AppSpace.md,
        runSpacing: AppSpace.md,
        children: [
          for (final (k, title, desc, meta) in [
            ('quick', l.tplQuick, l.tplQuickDesc, l.tplQuickMeta),
            ('search', l.tplSearch, l.tplSearchDesc, l.tplSearchMeta),
            ('idea', l.tplIdea, l.tplIdeaDesc, l.tplIdeaMeta),
          ])
            _card(
              on: f['tpl'] == k,
              onTap: () {
                f['tpl'] = k;
                vals = prefill(_version, k);
                gen++;
                _go(1);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.body.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: AppSpace.xs),
                  Text(desc, style: AppText.caption),
                  const SizedBox(height: AppSpace.sm),
                  Text(meta, style: AppText.label.copyWith(color: AppColors.accent)),
                ],
              ),
            ),
        ],
      ),
    ],
  );

  Widget _stepIdea(L10n l) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(l.bIdeaTitle, style: AppText.sectionTitle),
      const SizedBox(height: AppSpace.md),
      _field('name', l.bName, err: (s) => s.trim().isEmpty ? l.errRequired : null, ltr: false, width: 420),
      const SizedBox(height: AppSpace.md),
      _field(
        'hypothesis',
        l.bHypothesis,
        help: l.bHypothesisHelp,
        err: (s) => s.trim().isEmpty ? l.errRequired : null,
        ltr: false,
        lines: 2,
        width: null,
      ),
      const SizedBox(height: AppSpace.md),
      _field(
        'falsifier',
        l.bFalsifier,
        help: l.bFalsifierHelp,
        err: (s) => s.trim().isEmpty ? l.errRequired : null,
        ltr: false,
        lines: 2,
        width: null,
      ),
      const SizedBox(height: AppSpace.lg),
      Text(l.bGoal, style: AppText.label),
      const SizedBox(height: AppSpace.sm),
      LabChoiceChips<String>(
        options: [('net', l.goalNet), ('dd', l.goalDd), ('stable', l.goalStable)],
        selected: {f['goal']!},
        onChanged: (v) {
          f['goal'] = v.first;
          _changed();
        },
      ),
    ],
  );

  Widget _stepData(L10n l) {
    final all = ref.watch(allDatasetsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.bDataTitle, style: AppText.sectionTitle),
        const SizedBox(height: AppSpace.md),
        AsyncSection(
          value: all,
          onRetry: () => ref.invalidate(allDatasetsProvider),
          skeleton: const SizedBox(height: 88),
          isEmpty: (r) => r.datasets.isEmpty,
          empty: Text(l.newDatasetsEmpty, style: AppText.caption),
          builder: (r) {
            final tfs = r.datasets.map((d) => d.timeframe).toSet().toList()
              ..sort((a, b) => _tfOrder.indexOf(a).compareTo(_tfOrder.indexOf(b)));
            final tf = tfs.contains(f['timeframe']) ? f['timeframe']! : tfs.first;
            final shown = r.datasets.where((d) => d.timeframe == tf).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.bTimeframe, style: AppText.label),
                const SizedBox(height: AppSpace.sm),
                LabChoiceChips<String>(
                  ltr: true,
                  options: [for (final t in tfs) (t, t)],
                  selected: {tf},
                  onChanged: (v) {
                    f['timeframe'] = v.first;
                    final keep = r.datasets.where((d) => d.timeframe == v.first).map((d) => d.id).toSet();
                    ds = ds.intersection(keep);
                    _changed();
                  },
                ),
                const SizedBox(height: AppSpace.lg),
                Text(l.bDatasets, style: AppText.label),
                const SizedBox(height: AppSpace.sm),
                LabChoiceChips<String>(
                  multi: true,
                  ltr: true,
                  options: [
                    for (final d in shown)
                      (
                        d.id,
                        '${d.symbol} · ${fmtDate(utcMs(d.fromUnixMs))} → ${fmtDate(utcMs(d.toUnixMs))} · ${shortHash(d.id)}',
                      ),
                  ],
                  selected: ds,
                  onChanged: (v) {
                    // One version per pair: picking another version of a pair replaces it.
                    final added = v.difference(ds);
                    final bySymbol = {for (final d in r.datasets) d.id: d.symbol};
                    ds = {
                      for (final id in v)
                        if (added.contains(id) || !added.any((a) => bySymbol[a] == bySymbol[id])) id,
                    };
                    f['timeframe'] = tf;
                    _changed();
                  },
                ),
                Text(l.newDatasetsHelp, style: AppText.caption),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _stepAlgo(L10n l) {
    final algs = ref.watch(algorithmsProvider);
    final v = _version;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.bAlgoTitle, style: AppText.sectionTitle),
        const SizedBox(height: AppSpace.md),
        AsyncSection(
          value: algs,
          onRetry: () => ref.invalidate(algorithmsProvider),
          skeleton: const SizedBox(height: 120),
          builder: (r) => Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.md,
            children: [
              // Learning algorithms are trained in learning cycles, not searched here.
              for (final a in r.algorithms.where((a) => a.family != 'learning'))
                if (usableVersion(a) case final ver?)
                  _card(
                    on: f['algo'] == ver.id,
                    width: 260,
                    onTap: () {
                      f['algo'] = ver.id;
                      vals = prefill(ver, f['tpl']!);
                      gen++;
                      _changed();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Mono(ver.id, style: AppText.mono.copyWith(fontWeight: FontWeight.w700)),
                            ),
                            StatusText(lifecycleState(l, ver.state)),
                          ],
                        ),
                        const SizedBox(height: AppSpace.xs),
                        Text(a.description, style: AppText.caption, maxLines: 3, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        if (v != null) ...[
          const SizedBox(height: AppSpace.xl),
          Text(l.bParamsTitle, style: AppText.sectionTitle),
          const SizedBox(height: AppSpace.sm),
          if (v.params.isEmpty)
            Text(l.bNoParams, style: AppText.caption)
          else
            for (final p in v.params)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.md),
                child: Wrap(
                  spacing: AppSpace.lg,
                  runSpacing: AppSpace.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Mono(p.name, style: AppText.mono.copyWith(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text('${l.bParamDefault}: ${fmtParam(p.default_2)}', style: AppText.label),
                    ),
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        key: ValueKey('${v.id}.${p.name}.$gen'),
                        initialValue: vals[p.name] ?? '',
                        textDirection: TextDirection.ltr,
                        style: AppText.mono,
                        onChanged: (s) {
                          vals[p.name] = s;
                          _changed();
                        },
                        decoration: InputDecoration(
                          labelText: l.bParamValues,
                          hintText: l.bParamValuesHelp,
                          errorText: tried && parseValues(vals[p.name] ?? '', p.integer) == null ? l.errValues : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ],
    );
  }

  Widget _stepMoney(L10n l) {
    // Display hint only: both legs pay fee + slippage. The engine does the accounting.
    String? roundTrip;
    if (vBps(l, f['fee']!) == null && vBps(l, f['slip']!) == null) {
      final bps = (Decimal.parse(f['fee']!.trim()) + Decimal.parse(f['slip']!.trim())) * Decimal.fromInt(2);
      roundTrip = '${formatDecimal((bps / Decimal.fromInt(100)).toDecimal(), fractionDigits: 2)}%';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.bMoneyTitle, style: AppText.sectionTitle),
        const SizedBox(height: AppSpace.md),
        Wrap(
          spacing: AppSpace.md,
          runSpacing: AppSpace.md,
          children: [
            _field('capital', l.newCapital, err: (s) => vPositive(l, s), unit: 'USDT'),
            _field('fee', l.newFeeBps, err: (s) => vBps(l, s), unit: l.bps, help: l.bpsHelp),
            _field('slip', l.newSlipBps, err: (s) => vBps(l, s), unit: l.bps),
          ],
        ),
        if (roundTrip != null) ...[
          const SizedBox(height: AppSpace.lg),
          WarningBanner(l.bRoundTrip(roundTrip), icon: Icons.info_outline_rounded),
        ],
      ],
    );
  }

  Widget _summaryRows(L10n l) {
    final v = _version;
    final byId = {for (final d in _datasets) d.id: d};
    final space = _space();
    final rows = <(String, String, bool)>[
      (l.bStep0, _tplTitle(l), false),
      (l.bGoal, _goalTitle(l), false),
      (
        l.bStep2,
        ds.isEmpty
            ? '—'
            : '${(ds.map((id) => byId[id]?.symbol ?? id).toList()..sort()).join(', ')} · ${f['timeframe']}',
        true,
      ),
      (l.bStep3, f['algo']!.isEmpty ? '—' : f['algo']!, true),
      if (v != null && space != null && space.isNotEmpty)
        (
          l.newParams,
          space.entries.map((e) => '${e.key}: ${e.value.values.map(fmtParam).join(',')}').join(' · '),
          true,
        ),
      (l.newCapital, '${f['capital']} USDT', true),
      (l.bStep4, '${f['fee']} + ${f['slip']} ${l.bps}', true),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (k, val, ltr) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 96, child: Text(k, style: AppText.label)),
                Expanded(
                  child: ltr
                      ? Mono(val, style: AppText.mono.copyWith(fontSize: 13))
                      : Text(val, style: AppText.body.copyWith(height: 1.5)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _stepReview(L10n l) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(l.bReviewTitle, style: AppText.sectionTitle),
      const SizedBox(height: AppSpace.md),
      _summaryRows(l),
      const SizedBox(height: AppSpace.lg),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: () => setState(() => adv = !adv),
          icon: AnimatedRotation(
            turns: adv ? 0.5 : 0,
            duration: AppMotion.of(context, AppMotion.fast),
            child: const Icon(Icons.expand_more_rounded),
          ),
          label: Text(l.bAdvanced),
        ),
      ),
      AnimatedSize(
        duration: AppMotion.of(context, AppMotion.normal),
        curve: AppMotion.curve,
        alignment: AlignmentDirectional.topStart,
        child: !(adv || (tried && _errors(l, 5).isNotEmpty))
            ? const SizedBox(width: double.infinity)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.bAdvancedHelp, style: AppText.caption),
                  const SizedBox(height: AppSpace.md),
                  Wrap(
                    spacing: AppSpace.md,
                    runSpacing: AppSpace.md,
                    children: [
                      if (f['goal'] == 'dd')
                        _field('minReturn', l.bMinReturn, err: (s) => vNonNegative(l, s), unit: '%')
                      else
                        _field('maxDd', l.bMaxDd, err: (s) => vPositive(l, s), unit: '%'),
                      _field('minTrades', l.bMinTrades, err: (s) => vInt(l, s, 0, 100000)),
                      _field('folds', l.newFolds, err: (s) => vInt(l, s, 1, 12)),
                      _field('holdout', l.newHoldout, err: (s) => vInt(l, s, 5, 45), unit: '%', help: l.newHoldoutHelp),
                      _field('maxAttempts', l.bMaxAttempts, err: (s) => vInt(l, s, 1, 5000)),
                      _field('maxMinutes', l.bMaxMinutes, err: (s) => vInt(l, s, 1, 1440), unit: l.minutes),
                      _field(
                        'seed',
                        l.bSeed,
                        err: (s) => RegExp(r'^\d{1,18}$').hasMatch(s.trim()) ? null : l.errNumber,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.md),
                  Text(l.bSearchMode, style: AppText.label),
                  const SizedBox(height: AppSpace.sm),
                  LabChoiceChips<String>(
                    options: [('grid', l.modeGrid), ('random', l.modeRandom)],
                    selected: {f['mode']!},
                    onChanged: (v) {
                      f['mode'] = v.first;
                      _changed();
                    },
                  ),
                  SwitchListTile(
                    value: rolling,
                    onChanged: (v) {
                      rolling = v;
                      _changed();
                    },
                    title: Text(l.newRolling, style: AppText.body),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
      ),
      const SizedBox(height: AppSpace.md),
      WarningBanner(l.bLockNote, icon: Icons.lock_outline_rounded),
    ],
  );

  Widget _stepNav(L10n l) => Wrap(
    spacing: AppSpace.sm,
    runSpacing: AppSpace.sm,
    children: [
      for (var i = 0; i <= _lastStep; i++)
        Semantics(
          button: true,
          selected: i == step,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: i <= reached && i != step ? () => _go(i) : null,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: AnimatedContainer(
                duration: AppMotion.of(context, AppMotion.fast),
                constraints: const BoxConstraints(minHeight: AppSize.minTouch),
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
                decoration: BoxDecoration(
                  color: i == step ? AppColors.accentSoftBg : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: i == step ? AppColors.accent : AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: AppMotion.of(context, AppMotion.fast),
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < reached && i != step ? AppColors.positive : AppColors.inputBg,
                        border: Border.all(color: i == step ? AppColors.accent : AppColors.borderStrong),
                      ),
                      child: i < reached && i != step
                          ? const Icon(Icons.check_rounded, size: 14, color: AppColors.onAccent)
                          : Mono('${i + 1}', style: AppText.mono.copyWith(fontSize: 11)),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Text(
                      [l.bStep0, l.bStep1, l.bStep2, l.bStep3, l.bStep4, l.bStep5][i],
                      style: AppText.body.copyWith(
                        height: 1.4,
                        fontWeight: i == step ? FontWeight.w700 : FontWeight.w400,
                        color: i <= reached ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    ],
  );

  Widget _aside(L10n l) => SectionCard(
    title: l.bSummary,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _summaryRows(l),
        const Divider(height: AppSpace.xl),
        AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.normal),
          child: est != null
              ? Column(
                  key: const ValueKey('est'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.bRuns(est!.attempts, est!.candidates),
                      style: AppText.statValue.copyWith(fontFamily: AppFonts.ui, fontSize: 16),
                    ),
                    Text(
                      l.bEta(humanDuration(l, est!.estimatedSeconds.toInt().clamp(60, 1 << 31))),
                      style: AppText.label,
                    ),
                  ],
                )
              : estErr != null
              ? Text(
                  estErr!,
                  key: const ValueKey('err'),
                  style: AppText.caption.copyWith(color: AppColors.warningText),
                )
              : const Mono('—', key: ValueKey('none')),
        ),
        const SizedBox(height: AppSpace.md),
        Text(l.bLockNote, style: AppText.caption),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    // Versions and datasets arrive async; re-estimate once they do.
    ref.listen(algorithmsProvider, (_, _) => _scheduleEstimate());
    ref.listen(allDatasetsProvider, (_, _) => _scheduleEstimate());
    final errs = tried ? _errors(l, step) : const <String>[];
    final body = [_stepStart, _stepIdea, _stepData, _stepAlgo, _stepMoney, _stepReview][step](l);
    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _stepNav(l),
        const SizedBox(height: AppSpace.lg),
        SectionCard(
          child: PageTransitionSwitcher(
            duration: AppMotion.of(context, AppMotion.slow),
            reverse: reverse,
            layoutBuilder: (entries) => Stack(alignment: AlignmentDirectional.topStart, children: entries),
            transitionBuilder: (child, a, b) => SharedAxisTransition(
              animation: a,
              secondaryAnimation: b,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: AppColors.surface,
              child: child,
            ),
            child: KeyedSubtree(key: ValueKey(step), child: body),
          ),
        ),
        if (errs.isNotEmpty) ...[
          const SizedBox(height: AppSpace.md),
          for (final e in errs.toSet()) Text(e, style: AppText.body.copyWith(color: AppColors.negativeText)),
        ],
        if (runErr != null) ...[
          const SizedBox(height: AppSpace.md),
          Text(errorText(runErr!), style: AppText.body.copyWith(color: AppColors.negativeText)),
        ],
        const SizedBox(height: AppSpace.lg),
        Row(
          children: [
            Visibility.maintain(
              visible: step > 0,
              child: OutlinedButton(onPressed: () => _go(step - 1), child: Text(l.bBack)),
            ),
            const Spacer(),
            if (step < _lastStep)
              FilledButton(onPressed: () => _next(l), child: Text(l.bNext))
            else
              FilledButton.icon(
                onPressed: running ? null : () => _run(l),
                icon: running
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(l.bRun),
              ),
          ],
        ),
      ],
    );
    return PageFrame(
      children: [
        PageHeader(
          title: Dest.builder.label(l),
          subtitle: restored ? l.bDraftRestored : l.bSubtitle,
          actions: [
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: Text(l.bDraftClear),
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, box) => box.maxWidth < 1000
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    main,
                    const SizedBox(height: AppSpace.xl),
                    _aside(l),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: main),
                    const SizedBox(width: AppSpace.xl),
                    SizedBox(width: 340, child: _aside(l)),
                  ],
                ),
        ),
      ],
    );
  }
}
