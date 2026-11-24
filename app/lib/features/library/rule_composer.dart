import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../gen/lab/v1/library.pb.dart';
import '../reports/new_report_form.dart';
import 'rule_editor.dart';
import 'rule_version_picker.dart';

class ComposeRuleDialog extends ConsumerStatefulWidget {
  const ComposeRuleDialog({super.key});

  @override
  ConsumerState<ComposeRuleDialog> createState() => _ComposeRuleDialogState();
}

class _ComposeRuleDialogState extends ConsumerState<ComposeRuleDialog> {
  final _title = TextEditingController();
  final _period = TextEditingController(text: '20');
  final _form = GlobalKey<FormState>();
  RuleVersionSummary? _first, _second;
  String _mode = 'and';
  String _owner = 'a';
  bool _saving = false;
  Object? _error;

  @override
  void dispose() {
    _title.dispose();
    _period.dispose();
    super.dispose();
  }

  Future<void> _pick(bool first) async {
    final other = first ? _second : _first;
    final picked = await showDialog<RuleVersionSummary>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(first ? 'انتخاب نسخهٔ A' : 'انتخاب نسخهٔ B'),
        scrollable: true,
        content: SizedBox(
          width: 480,
          child: RuleVersionPicker(
            excluded: other?.id,
            selected: (first ? _first : _second)?.id,
            onPick: (picked) => Navigator.pop(context, picked),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
        ],
      ),
    );
    if (!mounted || picked == null) return;
    setState(() {
      if (first) {
        _first = picked;
      } else {
        _second = picked;
      }
    });
  }

  Future<void> _save() async {
    final first = _first, second = _second;
    if (_saving ||
        first == null ||
        second == null ||
        _form.currentState?.validate() != true) {
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final saved = await ref
          .read(libraryClientProvider)
          .composeRuleVersions(
            ComposeRuleVersionsRequest(
              title: _title.text.trim(),
              firstId: first.id,
              secondId: second.id,
              entryMode: _mode,
              regimeSmaPeriod: _mode == 'regime'
                  ? int.parse(ruleNumber(_period.text))
                  : null,
              exitOwnerId: _owner == 'a' ? first.id : second.id,
            ),
          );
      if (!mounted) return;
      ref.invalidate(ruleVersionsProvider);
      Navigator.pop(context, saved.version);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error;
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final owner =
        (_owner == 'a' ? _first : _second)?.title ?? _owner.toUpperCase();
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: const Text('ترکیب نسخه‌های قواعد'),
        scrollable: true,
        content: SizedBox(
          width: 520,
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  enabled: !_saving,
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: 'عنوان ترکیب'),
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'عنوان ترکیب را وارد کنید'
                      : null,
                ),
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.sm,
                  children: [
                    OutlinedButton(
                      onPressed: _saving ? null : () => _pick(true),
                      child: Text('A · ${_first?.title ?? 'انتخاب نسخه'}'),
                    ),
                    OutlinedButton(
                      onPressed: _saving ? null : () => _pick(false),
                      child: Text('B · ${_second?.title ?? 'انتخاب نسخه'}'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.md),
                RuleSelect(
                  label: 'شرط ورود',
                  value: _mode,
                  options: const {
                    'and': 'هر دو شرط (AND)',
                    'or': 'حداقل یک شرط (OR)',
                    'regime': 'انتخاب بر اساس وضعیت بازار',
                  },
                  onChanged: (mode) => setState(() => _mode = mode),
                  enabled: !_saving,
                ),
                const SizedBox(height: AppSpace.sm),
                if (_mode == 'regime') ...[
                  TextFormField(
                    controller: _period,
                    enabled: !_saving,
                    textDirection: TextDirection.ltr,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'دورهٔ میانگین وضعیت بازار (کندل)',
                    ),
                    validator: (text) {
                      final value = int.tryParse(ruleNumber(text ?? ''));
                      return value != null && value >= 2 && value <= 1000
                          ? null
                          : 'دوره باید بین ۲ و ۱۰۰۰ کندل باشد';
                    },
                  ),
                  const SizedBox(height: AppSpace.sm),
                ],
                RuleSelect(
                  label: 'مسئول خروج و اندازهٔ موقعیت',
                  value: _owner,
                  options: const {'a': 'نسخهٔ A', 'b': 'نسخهٔ B'},
                  onChanged: (owner) => setState(() => _owner = owner),
                  enabled: !_saving,
                ),
                const SizedBox(height: AppSpace.md),
                SectionCard(
                  title: 'رفتار ترکیب',
                  child: Text(
                    '${switch (_mode) {
                      'and' => 'برای ورود هر دو شرط باید هم‌زمان برقرار باشند.',
                      'regime' => 'اگر قیمت پایانی کندل برابر یا بالاتر از میانگین باشد، شرط ورود A بررسی می‌شود. زیر میانگین، شرط ورود B بررسی می‌شود. تا آماده شدن میانگین، ورودی صادر نمی‌شود.',
                      _ => 'برای ورود کافی است یکی از دو شرط برقرار باشد.',
                    }} خروج و اندازهٔ موقعیت از «$owner» گرفته می‌شود.',
                  ),
                ),
                if (_error != null)
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      errorText(_error!),
                      style: const TextStyle(color: AppColors.negativeText),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: _saving || _first == null || _second == null
                ? null
                : _save,
            child: Text(_saving ? 'در حال ذخیره…' : 'ذخیرهٔ ترکیب'),
          ),
        ],
      ),
    );
  }
}

class RuleBacktestSection extends ConsumerWidget {
  const RuleBacktestSection({
    super.key,
    required this.rule,
    required this.compare,
  });

  final GetRuleVersionResponse rule;
  final bool compare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final def = jsonDecode(rule.definitionJson) as RuleJson;
    final timeframe = def['base_timeframe'] as String? ?? '';
    if (!compare) {
      return NewReportForm(
        ruleVersions: [rule.version],
        requiredTimeframe: timeframe,
      );
    }

    // Compare the exact two parents recorded when the composition was saved.
    final first = ruleVersionProvider(rule.version.parentId);
    final second = ruleVersionProvider(rule.version.otherParentId);
    final a = ref.watch(first);
    final b = ref.watch(second);
    final components = switch ((a, b)) {
      (AsyncData(:final value), AsyncData(value: final other)) => AsyncData((
        value,
        other,
      )),
      (AsyncError(:final error, :final stackTrace), _) ||
      (
        _,
        AsyncError(:final error, :final stackTrace),
      ) => AsyncError<(GetRuleVersionResponse, GetRuleVersionResponse)>(
        error,
        stackTrace,
      ),
      _ =>
        const AsyncLoading<(GetRuleVersionResponse, GetRuleVersionResponse)>(),
    };
    return AsyncSection(
      value: components,
      onRetry: () {
        ref.invalidate(first);
        ref.invalidate(second);
      },
      skeleton: const LinearProgressIndicator(),
      builder: (parents) => NewReportForm(
        ruleVersions: [parents.$1.version, parents.$2.version, rule.version],
        requiredTimeframe: timeframe,
      ),
    );
  }
}
