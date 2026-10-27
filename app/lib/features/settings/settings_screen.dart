import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/nav.dart';
import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/fx.pb.dart';
import '../../l10n/app_localizations.dart';
import '../placeholder_screen.dart';

final ratesProvider = FutureProvider<ListRatesResponse>(
  (ref) => ref.watch(fxClientProvider).listRates(ListRatesRequest(limit: 50)),
);

/// Positive, at most 2 decimals — same rule as the engine.
bool validRate(String s) {
  final t = s.trim();
  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(t)) return false;
  return Decimal.parse(t) > Decimal.zero;
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.today});
  final DateTime? today; // injectable for tests

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final DateTime _today = widget.today ?? DateTime.now().toUtc();
  final _rate = TextEditingController();
  late final _date = TextEditingController(text: fmtDate(_today));
  final _source = TextEditingController();
  bool _tried = false, _saving = false;
  Object? _saveError;

  @override
  void dispose() {
    _rate.dispose();
    _date.dispose();
    _source.dispose();
    super.dispose();
  }

  String? _rateError(L10n l) => validRate(_rate.text) ? null : l.errRate;

  String? _dateError(L10n l) {
    final d = parseDate(_date.text);
    if (d == null) return l.errDate;
    return d.isAfter(DateTime.utc(_today.year, _today.month, _today.day)) ? l.errFutureDate : null;
  }

  Future<void> _save(L10n l) async {
    setState(() => _tried = true);
    if (_rateError(l) != null || _dateError(l) != null) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      await ref
          .read(fxClientProvider)
          .addRate(
            AddRateRequest(date: _date.text.trim(), tomanPerUsdt: _rate.text.trim(), source: _source.text.trim()),
          );
      ref.invalidate(ratesProvider);
      _rate.clear();
      _source.clear();
      _tried = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.settingsRateSaved)));
      }
    } catch (e) {
      _saveError = e;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return PageFrame(
      children: [
        PageHeader(title: Dest.settings.label(l), subtitle: Dest.settings.subtitle(l)),
        SectionCard(
          title: l.settingsCurrency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatGrid(
                minWidth: 260,
                children: [
                  StatCard(label: l.settingsAccounting, value: _fixed('USDT', l.settingsAccountingNote)),
                  StatCard(label: l.settingsDisplayRate, value: _fixed('USDT / TOMAN', l.settingsDisplayRateNote)),
                ],
              ),
              const SizedBox(height: AppSpace.xl),
              Wrap(
                spacing: AppSpace.md,
                runSpacing: AppSpace.md,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  SizedBox(
                    width: 260,
                    child: TextField(
                      controller: _rate,
                      textDirection: TextDirection.ltr,
                      style: AppText.mono,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: l.settingsRateField,
                        helperText: l.settingsRateHelp,
                        suffixText: 'TOMAN',
                        errorText: _tried ? _rateError(l) : null,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _date,
                      textDirection: TextDirection.ltr,
                      style: AppText.mono,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: l.settingsDateField,
                        helperText: 'YYYY-MM-DD · UTC',
                        errorText: _tried ? _dateError(l) : null,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: TextField(
                      controller: _source,
                      maxLength: 200,
                      decoration: InputDecoration(
                        labelText: l.settingsSourceField,
                        helperText: l.settingsSourceHelp,
                        counterText: '',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: FilledButton.icon(
                      onPressed: _saving ? null : () => _save(l),
                      icon: _saving
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                            )
                          : const Icon(Icons.save_outlined, size: 18),
                      label: Text(l.settingsSaveRate),
                    ),
                  ),
                ],
              ),
              if (_saveError != null) ...[
                const SizedBox(height: AppSpace.sm),
                Text(errorText(_saveError!), style: AppText.body.copyWith(color: AppColors.negativeText)),
              ],
              const SizedBox(height: AppSpace.md),
              WarningBanner(l.settingsRateNote, icon: Icons.info_outline_rounded),
            ],
          ),
        ),
        SectionCard(title: l.settingsHistory, child: _history(l)),
        SectionCard(
          title: l.settingsOther,
          child: Text(l.settingsOtherNote, style: AppText.caption),
        ),
      ],
    );
  }

  Widget _fixed(String code, String note) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Mono(code, style: AppText.statValue),
      const SizedBox(height: AppSpace.xs),
      Text(note, style: AppText.caption),
    ],
  );

  Widget _history(L10n l) {
    final cols = [
      l.settingsColDate,
      l.settingsColRate,
      l.settingsColSource,
      l.settingsColEntered,
      l.settingsColReports,
    ];
    return AsyncSection(
      value: ref.watch(ratesProvider),
      onRetry: () => ref.invalidate(ratesProvider),
      skeleton: DataTableBox(
        columns: cols,
        rows: [
          for (var i = 0; i < 3; i++) [for (var j = 0; j < 5; j++) const Text('————')],
        ],
      ),
      isEmpty: (r) => r.rates.isEmpty,
      empty: EmptyState(l.settingsHistoryEmpty, icon: Icons.currency_exchange_rounded),
      builder: (r) => DataTableBox(
        minWidth: 560,
        columns: cols,
        rows: [
          for (final rate in r.rates)
            [
              Mono(rate.date),
              Num(moneyValue(rate.tomanPerUsdt), unit: 'TOMAN'),
              Text(rate.source == 'manual' ? l.statusFxManual : rate.source, style: AppText.body.copyWith(height: 1.4)),
              Mono(fmtDateTime(utcMs(rate.enteredUnixMs))),
              Mono('${rate.reports}'),
            ],
        ],
      ),
    );
  }
}
