import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../gen/lab/v1/library.pb.dart';
import 'rule_editor.dart';
import 'rule_version_picker.dart';

class RuleDraftDialog extends ConsumerStatefulWidget {
  const RuleDraftDialog({
    super.key,
    this.definition,
    this.parent,
    this.template,
  });

  final String? definition;
  final RuleVersionSummary? parent;
  final RuleTemplate? template;

  @override
  ConsumerState<RuleDraftDialog> createState() => _RuleDraftDialogState();
}

class _RuleDraftDialogState extends ConsumerState<RuleDraftDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _exposure;
  late RuleJson _entry, _exit;
  late String _timeframe;
  bool _saving = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    final source = widget.definition ?? widget.template?.definitionJson;
    final definition = source == null
        ? <String, dynamic>{}
        : jsonDecode(source) as RuleJson;
    _title = TextEditingController(
      text: widget.parent?.title ?? widget.template?.title,
    );
    _exposure = TextEditingController(
      text: definition['exposure'] as String? ?? '1',
    );
    _timeframe = definition['base_timeframe'] as String? ?? '';
    _entry = definition['entry'] as RuleJson? ?? comparisonRule('cross_above');
    _exit = definition['exit'] as RuleJson? ?? comparisonRule('cross_below');
  }

  @override
  void dispose() {
    _title.dispose();
    _exposure.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || _form.currentState?.validate() != true) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // Every save creates a new immutable version and records its actual source.
      final saved = await ref
          .read(libraryClientProvider)
          .saveRuleVersion(
            SaveRuleVersionRequest(
              title: _title.text.trim(),
              parentId: widget.parent?.id,
              templateKey: widget.template?.key,
              definitionJson: jsonEncode({
                'format': 'rules/v1',
                'entry': _entry,
                'exit': _exit,
                'exposure': ruleNumber(_exposure.text),
                if (_timeframe.isNotEmpty) 'base_timeframe': _timeframe,
              }),
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
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AlertDialog(
      title: Text(
        widget.parent == null
            ? 'پیش‌نویس قواعد'
            : 'نسخهٔ تازه از ${widget.parent!.title}',
      ),
      scrollable: true,
      content: SizedBox(
        width: 620,
        child: AbsorbPointer(
          absorbing: _saving,
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  maxLength: 100,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'عنوان نسخه'),
                  validator: (text) =>
                      (text ?? '').trim().isEmpty ? 'عنوان را وارد کنید' : null,
                ),
                RuleSelect(
                  label: 'بازهٔ پایهٔ داده',
                  value: _timeframe,
                  options: const {
                    '': 'هر بازهٔ پشتیبانی‌شده',
                    ...ruleTimeframes,
                  },
                  onChanged: (value) => setState(() => _timeframe = value),
                ),
                const SizedBox(height: AppSpace.sm),
                TextFormField(
                  controller: _exposure,
                  textDirection: TextDirection.ltr,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'سهم سرمایه از صفر تا یک',
                    helperText: 'برای مثال ۰٫۲۵ یعنی یک‌چهارم سرمایه',
                  ),
                  validator: (text) {
                    final raw = ruleNumber(text ?? '');
                    final value = double.tryParse(raw);
                    return RegExp(r'^(?:0?\.\d{1,6}|0|1(?:\.0{1,6})?)$')
                                .hasMatch(raw) &&
                            value != null &&
                            value > 0
                        ? null
                        : 'عددی بزرگ‌تر از صفر تا ۱، با حداکثر ۶ رقم اعشار وارد کنید';
                  },
                ),
                const SizedBox(height: AppSpace.md),
                SectionCard(
                  title: 'ورود',
                  child: RuleNodeEditor(
                    rule: _entry,
                    label: 'عملگر ورود',
                    onChanged: (rule) => setState(() => _entry = rule),
                  ),
                ),
                const SizedBox(height: AppSpace.md),
                SectionCard(
                  title: 'خروج',
                  child: RuleNodeEditor(
                    rule: _exit,
                    label: 'عملگر خروج',
                    onChanged: (rule) => setState(() => _exit = rule),
                  ),
                ),
                const SizedBox(height: AppSpace.md),
                Text('پیش‌نمایش', style: AppText.sectionTitle),
                Text(
                  'ورود وقتی ${describeRule(_entry)} باشد. خروج وقتی ${describeRule(_exit)} باشد.',
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpace.sm),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      errorText(_error!),
                      style: const TextStyle(color: AppColors.negativeText),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'در حال ذخیره…' : 'ذخیرهٔ نسخه'),
        ),
      ],
    ),
  );
}

/// Used by each details view to keep ancestry links on the same route pattern.
String ruleVersionPath(Int64 id) => '/library/rules/$id';
