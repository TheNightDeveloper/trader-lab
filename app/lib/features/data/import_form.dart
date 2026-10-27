import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/data.pb.dart';
import '../../l10n/app_localizations.dart';
import 'data_providers.dart';

const timeframes = ['1m', '15m', '1h', '4h', '1d'];

/// Archive import → dataset versions. Validates before calling the engine; the
/// engine validates again.
class ImportForm extends ConsumerStatefulWidget {
  const ImportForm({super.key, required this.symbols, this.today});
  final List<String> symbols;
  final DateTime? today; // injectable for tests; defaults to now (UTC)

  @override
  ConsumerState<ImportForm> createState() => _ImportFormState();
}

class _ImportFormState extends ConsumerState<ImportForm> {
  late final DateTime _today = widget.today ?? DateTime.now().toUtc();
  late final _from = TextEditingController(text: fmtDate(_today.subtract(const Duration(days: 30))));
  late final _to = TextEditingController(text: fmtDate(_today.subtract(const Duration(days: 1))));
  Set<String> _pairs = {'BTCUSDT'};
  String _tf = '1h';
  String _gap = 'flag';
  bool _tried = false;

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  String? _dateError(L10n l, String s) => parseDate(s) == null ? l.errDate : null;

  String? _rangeError(L10n l) {
    final f = parseDate(_from.text), t = parseDate(_to.text);
    if (f == null || t == null) return null;
    final today = DateTime.utc(_today.year, _today.month, _today.day);
    return f.isAfter(t) || t.isAfter(today) ? l.errRange : null;
  }

  bool _valid(L10n l) =>
      _pairs.isNotEmpty &&
      _dateError(l, _from.text) == null &&
      _dateError(l, _to.text) == null &&
      _rangeError(l) == null;

  void _submit(L10n l) {
    setState(() => _tried = true);
    if (!_valid(l)) return;
    ref
        .read(importProvider.notifier)
        .run(
          ImportRequest(
            symbols: widget.symbols.where(_pairs.contains), // stable order
            fromDate: _from.text.trim(),
            toDate: _to.text.trim(),
            timeframe: _tf,
            gapPolicy: _gap,
          ),
        );
  }

  Future<void> _pick(TextEditingController c) async {
    final d = await showDatePicker(
      context: context,
      initialDate: parseDate(c.text) ?? _today,
      firstDate: DateTime.utc(2017, 1, 1),
      lastDate: _today,
    );
    if (d != null) setState(() => c.text = fmtDate(d));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final st = ref.watch(importProvider);
    Widget dateField(String label, TextEditingController c) => TextField(
      controller: c,
      textDirection: TextDirection.ltr,
      style: AppText.mono,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        helperText: l.dataDateHelp,
        helperMaxLines: 2,
        errorText: _tried ? _dateError(l, c.text) : null,
        suffixIcon: IconButton(
          tooltip: label,
          icon: const Icon(Icons.calendar_month_outlined, size: 18),
          onPressed: () => _pick(c),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.dataSource, style: AppText.label),
        const SizedBox(height: AppSpace.xs),
        Mono(l.dataSourceArchive, style: AppText.mono.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpace.lg),
        Text(l.dataPairs, style: AppText.label),
        const SizedBox(height: AppSpace.sm),
        LabChoiceChips<String>(
          multi: true,
          ltr: true,
          options: [for (final s in widget.symbols) (s, s)],
          selected: _pairs,
          onChanged: (v) => setState(() => _pairs = v),
        ),
        if (_tried && _pairs.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(l.errPickPair, style: _err),
          ),
        const SizedBox(height: AppSpace.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: dateField(l.dataFrom, _from)),
            const SizedBox(width: AppSpace.md),
            Expanded(child: dateField(l.dataTo, _to)),
          ],
        ),
        if (_tried && _rangeError(l) != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(_rangeError(l)!, style: _err),
          ),
        const SizedBox(height: AppSpace.lg),
        Text(l.dataTimeframe, style: AppText.label),
        const SizedBox(height: AppSpace.sm),
        LabChoiceChips<String>(
          ltr: true,
          options: [for (final t in timeframes) (t, t)],
          selected: {_tf},
          onChanged: (v) => setState(() => _tf = v.first),
        ),
        const SizedBox(height: AppSpace.lg),
        Text(l.dataGapPolicy, style: AppText.label),
        RadioGroup<String>(
          groupValue: _gap,
          onChanged: (v) => setState(() => _gap = v!),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                for (final (v, label) in [('flag', l.gapFlag), ('stop', l.gapStop), ('ffill', l.gapFfill)])
                  RadioListTile<String>(
                    value: v,
                    title: Text(label, style: AppText.body.copyWith(height: 1.5)),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpace.md),
        FilledButton.icon(
          onPressed: st.running ? null : () => _submit(l),
          icon: st.running
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                )
              : const Icon(Icons.download_rounded, size: 18),
          label: Text(st.running ? l.dataImportRunning : l.dataImportButton),
        ),
        const SizedBox(height: AppSpace.sm),
        Text(l.dataImportNote, style: AppText.caption),
        _ImportStatus(st),
      ],
    );
  }

  static final _err = AppText.caption.copyWith(color: AppColors.negativeText);
}

class _ImportStatus extends StatelessWidget {
  const _ImportStatus(this.st);
  final ImportState st;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final d = AppMotion.of(context, AppMotion.normal);
    return AnimatedSize(
      duration: d,
      curve: AppMotion.curve,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in st.progress.values) ...[
            const SizedBox(height: AppSpace.md),
            Text(l.dataImportProgress(p.symbol, p.filesDone, p.filesTotal, p.inserted), style: AppText.caption),
            const SizedBox(height: AppSpace.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: p.filesTotal == 0 ? 0 : p.filesDone / p.filesTotal),
                duration: d,
                builder: (context, v, _) => LinearProgressIndicator(
                  value: v,
                  minHeight: 6,
                  color: AppColors.accent,
                  backgroundColor: AppColors.inputBg,
                ),
              ),
            ),
          ],
          if (st.error != null) ...[
            const SizedBox(height: AppSpace.md),
            Text(
              '${l.dataImportFailed}: ${errorText(st.error!)}',
              style: AppText.body.copyWith(color: AppColors.negativeText),
            ).animate().shakeX(hz: 3, amount: 3, duration: AppMotion.of(context, AppMotion.slow)),
          ],
          for (final (i, ds) in st.created.indexed) ...[
            const SizedBox(height: AppSpace.md),
            Container(
                  padding: const EdgeInsets.all(AppSpace.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.positiveBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.positive, size: 18),
                      const SizedBox(width: AppSpace.sm),
                      Text(l.dataImportDone, style: AppText.body.copyWith(color: AppColors.positive)),
                      const Spacer(),
                      Mono(
                        '${ds.symbol} ${ds.timeframe} · ${shortHash(ds.id)}',
                        style: AppText.mono.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                )
                .animate(delay: AppMotion.of(context, AppMotion.stagger) * i)
                .fadeIn(duration: d)
                .slideY(begin: 0.2, curve: AppMotion.curve),
          ],
        ],
      ),
    );
  }
}
