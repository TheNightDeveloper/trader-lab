import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/metric.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/charts.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/report_widgets.dart';
import '../../gen/lab/v1/fx.pb.dart';
import '../../gen/lab/v1/pnl.pb.dart';
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';
import '../reports/report_providers.dart';
import '../reports/report_screen.dart';
import '../settings/settings_screen.dart' show ratesProvider;

final _num = RegExp(r'^\d+(\.\d{1,8})?$');
bool _isPos(String s) => _num.hasMatch(s.trim()) && Decimal.parse(s.trim()) > Decimal.zero;
bool _isBps(String s) =>
    RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(s.trim()) && Decimal.parse(s.trim()) < Decimal.fromInt(10000);
bool _isPct(String s) =>
    RegExp(r'^\d+(\.\d{1,4})?$').hasMatch(s.trim()) &&
    Decimal.parse(s.trim()) > Decimal.zero &&
    Decimal.parse(s.trim()) <= Decimal.fromInt(100);

/// Debounced engine call: waits 300 ms after the last edit (UI_SPEC).
mixin _Debounce<T extends StatefulWidget> on State<T> {
  Timer? _t;
  void debounce(VoidCallback f) {
    _t?.cancel();
    _t = Timer(const Duration(milliseconds: 300), f);
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }
}

class PnlScreen extends StatefulWidget {
  const PnlScreen({super.key, this.reportId});
  final String? reportId;

  @override
  State<PnlScreen> createState() => _PnlScreenState();
}

class _PnlScreenState extends State<PnlScreen> {
  bool _run = true;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return PageFrame(
      children: [
        PageHeader(title: Dest.pnl.label(l), subtitle: l.pnlSubtitle),
        LabChoiceChips<bool>(
          options: [(true, l.pnlTabRun), (false, l.pnlTabTrade)],
          selected: {_run},
          onChanged: (v) => setState(() => _run = v.first),
        ),
        AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.normal),
          child: _run
              ? _RunCalc(key: const ValueKey('run'), initial: widget.reportId)
              : const _TradeCalc(key: ValueKey('trade')),
        ),
      ],
    );
  }
}

Widget _rateSelect(L10n l, AsyncValue<ListRatesResponse> rates, int value, ValueChanged<int> onChanged) =>
    DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(labelText: l.pnlRate),
      items: [
        DropdownMenuItem(value: 0, child: Text(l.pnlRateNone)),
        for (final r in rates.value?.rates ?? <FxRate>[])
          DropdownMenuItem(
            value: r.id.toInt(),
            child: Mono('${r.date} · ${formatDecimal(moneyValue(r.tomanPerUsdt), fractionDigits: 0)} TOMAN'),
          ),
      ],
      onChanged: (v) => onChanged(v ?? 0),
    );

Widget _field(
  String label,
  TextEditingController c,
  bool Function(String) ok,
  String err,
  VoidCallback onChanged, {
  String? suffix,
  String? help,
}) => TextField(
  controller: c,
  textDirection: TextDirection.ltr,
  style: AppText.mono,
  onChanged: (_) => onChanged(),
  decoration: InputDecoration(
    labelText: label,
    suffix: unitSuffix(suffix),
    helperText: help,
    errorText: c.text.isEmpty || ok(c.text) ? null : err,
  ),
);

Widget _layout(BuildContext context, Widget inputs, Widget output) {
  final wide = MediaQuery.sizeOf(context).width >= 1100;
  return wide
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 320, child: inputs),
            const SizedBox(width: 18),
            Expanded(child: output),
          ],
        )
      : Column(children: [inputs, const SizedBox(height: 18), output]);
}

class _RunCalc extends ConsumerStatefulWidget {
  const _RunCalc({super.key, this.initial});
  final String? initial;

  @override
  ConsumerState<_RunCalc> createState() => _RunCalcState();
}

class _RunCalcState extends ConsumerState<_RunCalc> with _Debounce {
  String? _report;
  final _capital = TextEditingController(),
      _size = TextEditingController(),
      _fee = TextEditingController(),
      _slip = TextEditingController();
  int _rate = 0;
  RecalculateResponse? _res, _original;
  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _report = widget.initial;
    if (_report != null) Future.microtask(() => _load(reset: true));
  }

  @override
  void dispose() {
    for (final c in [_capital, _size, _fee, _slip]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _valid => _isPos(_capital.text) && _isPct(_size.text) && _isBps(_fee.text) && _isBps(_slip.text);

  Future<void> _load({bool reset = false}) async {
    if (_report == null || (!reset && !_valid)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final req = RecalculateRequest(reportId: _report, fxRateId: _rate == 0 ? null : Int64(_rate));
      if (!reset) {
        req
          ..capital = usdtOut(Decimal.parse(_capital.text.trim()))
          ..positionSize = pctOut(Decimal.parse(_size.text.trim()))
          ..fee = bpsOut(Decimal.parse(_fee.text.trim()))
          ..slippage = bpsOut(Decimal.parse(_slip.text.trim()));
      }
      final res = await ref.read(pnlClientProvider).recalculate(req);
      setState(() {
        _res = res;
        if (reset) {
          _original = res;
          _capital.text = moneyValue(res.capital).toString();
          _size.text = fractionToPct(res.positionSize).toString();
          _fee.text = fractionToBps(res.fee).toString();
          _slip.text = fractionToBps(res.slippage).toString();
        }
      });
    } catch (e) {
      setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final reports = ref.watch(reportsProvider(0));
    final rates = ref.watch(ratesProvider);
    void changed() => debounce(_load);

    final inputs = SectionCard(
      title: l.pnlInputs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AsyncSection(
            value: reports,
            onRetry: () => ref.invalidate(reportsProvider(0)),
            skeleton: const SizedBox(height: 56),
            isEmpty: (r) => r.reports.isEmpty,
            empty: Text(l.pnlNoReports, style: AppText.caption),
            builder: (r) => DropdownButtonFormField<String>(
              initialValue: r.reports.any((x) => x.id == _report) ? _report : null,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.pnlReport),
              items: [
                for (final x in r.reports)
                  DropdownMenuItem(
                    value: x.id,
                    child: Text(x.title, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) {
                setState(() => _report = v);
                _load(reset: true);
              },
            ),
          ),
          const SizedBox(height: AppSpace.md),
          _field(l.newCapital, _capital, _isPos, l.errPositive, changed, suffix: 'USDT'),
          const SizedBox(height: AppSpace.md),
          _field(l.pnlSize, _size, _isPct, l.errNumber, changed, suffix: '%', help: l.pnlSizeHelp),
          const SizedBox(height: AppSpace.md),
          _field(l.newFeeBps, _fee, _isBps, l.errBps, changed, suffix: l.bps, help: l.bpsHelp),
          const SizedBox(height: AppSpace.md),
          _field(l.newSlipBps, _slip, _isBps, l.errBps, changed, suffix: l.bps),
          const SizedBox(height: AppSpace.md),
          _rateSelect(l, rates, _rate, (v) {
            setState(() => _rate = v);
            _load();
          }),
          const SizedBox(height: AppSpace.md),
          OutlinedButton.icon(
            onPressed: _original == null ? null : () => _load(reset: true),
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: Text(l.pnlReset),
          ),
        ],
      ),
    );
    return _layout(context, inputs, _output(l));
  }

  Widget _output(L10n l) {
    final r = _res;
    if (_error != null) return ErrorBox(error: _error!, onRetry: _load);
    if (r == null) return SectionCard(child: EmptyState(l.pnlNoReports, icon: Icons.calculate_outlined));
    final net = moneyValue(r.waterfall.net);
    final metrics = r.metrics;
    final finalEq = metricOf(metrics, 'final_equity');
    return AnimatedOpacity(
      opacity: _loading ? 0.6 : 1,
      duration: AppMotion.of(context, AppMotion.fast),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VerdictCard(verdict: r.verdict, tone: r.tone, sentence: r.sentence),
          const SizedBox(height: 18),
          StatGrid(
            minWidth: 160,
            children: [
              StatCard(
                label: l.pnlNet,
                value: Num(net, signed: true, fractionDigits: 2, unit: 'USDT', style: AppText.statValue),
              ),
              StatCard(label: l.pnlOriginalNet, value: moneyNum(r.originalNet)),
              if (finalEq != null)
                StatCard(
                  label: l.pnlFinal,
                  value: Num(decValue(finalEq.value), fractionDigits: 2, unit: 'USDT'),
                ),
              StatCard(
                label: l.pnlBreakEvenFee,
                value: r.hasBreakEvenFee()
                    ? Num(fractionToBps(r.breakEvenFee), fractionDigits: 1, unit: 'bps')
                    : Text(l.reportBreakEvenNone, style: AppText.caption),
              ),
              if (r.hasNetToman()) StatCard(label: l.pnlTomanNet, value: moneyNum(r.netToman, digits: 0)),
            ],
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: l.reportWaterfall,
            child: WaterfallBars(
              rows: [
                WaterfallRow(l.tradeGross, moneyValue(r.waterfall.gross), AppColors.positive.withValues(alpha: 0.8)),
                WaterfallRow(
                  metricOf(metrics, 'fees')?.label ?? '',
                  -moneyValue(r.waterfall.fees),
                  AppColors.negative.withValues(alpha: 0.85),
                ),
                WaterfallRow(
                  metricOf(metrics, 'slippage')?.label ?? '',
                  -moneyValue(r.waterfall.slippage),
                  AppColors.negative.withValues(alpha: 0.6),
                ),
                WaterfallRow(l.tradeNet, net, AppColors.accent),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: l.pnlEquity,
            child: EquityChart(
              height: 220,
              format: axisUsdt,
              series: [
                ChartSeries(label: l.reportCandidate, points: equityPoints(r.equity), color: AppColors.series[0]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: l.reportTrades,
            child: DataTableBox(
              minWidth: 720,
              columns: ['#', l.dataColPair, l.tradeEntryExit, l.tradeGross, l.tradeCost, l.tradeNet],
              rows: [for (final t in r.trades.take(200)) tradeRow(l, t)],
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeCalc extends ConsumerStatefulWidget {
  const _TradeCalc({super.key});

  @override
  ConsumerState<_TradeCalc> createState() => _TradeCalcState();
}

class _TradeCalcState extends ConsumerState<_TradeCalc> with _Debounce {
  final _entry = TextEditingController(text: '67400'), _exit = TextEditingController(text: '68900');
  final _amount = TextEditingController(text: '2000'),
      _fee = TextEditingController(text: '10'),
      _slip = TextEditingController(text: '5');
  int _rate = 0;
  CalculateTradeResponse? _res;
  Object? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_calc);
  }

  @override
  void dispose() {
    for (final c in [_entry, _exit, _amount, _fee, _slip]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _calc() async {
    if (![_entry, _exit, _amount].every((c) => _isPos(c.text)) || !_isBps(_fee.text) || !_isBps(_slip.text)) return;
    try {
      final res = await ref
          .read(pnlClientProvider)
          .calculateTrade(
            CalculateTradeRequest(
              entry: usdtOut(Decimal.parse(_entry.text.trim())),
              exit: usdtOut(Decimal.parse(_exit.text.trim())),
              amount: usdtOut(Decimal.parse(_amount.text.trim())),
              fee: bpsOut(Decimal.parse(_fee.text.trim())),
              slippage: bpsOut(Decimal.parse(_slip.text.trim())),
              fxRateId: _rate == 0 ? null : Int64(_rate),
            ),
          );
      setState(() {
        _res = res;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    void changed() => debounce(_calc);
    final inputs = SectionCard(
      title: l.pnlTradeInputs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WarningBanner(l.pnlSpotNote, icon: Icons.info_outline_rounded),
          const SizedBox(height: AppSpace.md),
          _field(l.pnlEntry, _entry, _isPos, l.errPositive, changed, suffix: 'USDT'),
          const SizedBox(height: AppSpace.md),
          _field(l.pnlExit, _exit, _isPos, l.errPositive, changed, suffix: 'USDT'),
          const SizedBox(height: AppSpace.md),
          _field(l.pnlAmount, _amount, _isPos, l.errPositive, changed, suffix: 'USDT'),
          const SizedBox(height: AppSpace.md),
          _field(l.newFeeBps, _fee, _isBps, l.errBps, changed, suffix: l.bps, help: l.bpsHelp),
          const SizedBox(height: AppSpace.md),
          _field(l.newSlipBps, _slip, _isBps, l.errBps, changed, suffix: l.bps),
          const SizedBox(height: AppSpace.md),
          _rateSelect(l, ref.watch(ratesProvider), _rate, (v) {
            setState(() => _rate = v);
            _calc();
          }),
        ],
      ),
    );
    final r = _res;
    final Widget output = _error != null
        ? ErrorBox(error: _error!, onRetry: _calc)
        : r == null
        ? const SectionCard(child: SizedBox(height: 120))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VerdictCard(verdict: r.verdict, tone: r.tone, sentence: r.sentence),
              const SizedBox(height: 18),
              StatGrid(
                minWidth: 160,
                children: [
                  StatCard(label: l.pnlNet, value: moneyNum(r.waterfall.net)),
                  StatCard(label: l.pnlQty, value: Num(decValue(r.qty), fractionDigits: 8)),
                  StatCard(label: l.pnlCost, value: moneyNum(r.cost, signed: false)),
                  StatCard(
                    label: l.pnlReturn,
                    value: Num(fractionToPct(r.return_6), signed: true, fractionDigits: 2, unit: '%'),
                  ),
                  StatCard(label: l.pnlBreakEvenExit, value: moneyNum(r.breakEvenExit, signed: false)),
                  if (r.hasNetToman()) StatCard(label: l.pnlTomanNet, value: moneyNum(r.netToman, digits: 0)),
                ],
              ),
              const SizedBox(height: 18),
              SectionCard(
                title: l.reportWaterfall,
                child: WaterfallBars(
                  rows: [
                    WaterfallRow(
                      l.tradeGross,
                      moneyValue(r.waterfall.gross),
                      AppColors.positive.withValues(alpha: 0.8),
                    ),
                    WaterfallRow(
                      l.newFeeBps,
                      -moneyValue(r.waterfall.fees),
                      AppColors.negative.withValues(alpha: 0.85),
                    ),
                    WaterfallRow(
                      l.newSlipBps,
                      -moneyValue(r.waterfall.slippage),
                      AppColors.negative.withValues(alpha: 0.6),
                    ),
                    WaterfallRow(l.tradeNet, moneyValue(r.waterfall.net), AppColors.accent),
                  ],
                ),
              ),
            ],
          );
    return _layout(context, inputs, output);
  }
}
