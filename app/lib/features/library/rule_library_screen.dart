import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../gen/lab/v1/library.pb.dart';
import '../page_frame.dart';
import 'rule_draft_dialog.dart';
import 'rule_editor.dart';
import 'rule_version_picker.dart';

class RuleLibraryScreen extends ConsumerWidget {
  const RuleLibraryScreen({super.key});

  Future<void> _draft(BuildContext context, {RuleTemplate? template}) async {
    final version = await showDialog<RuleVersionSummary>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RuleDraftDialog(template: template),
    );
    if (context.mounted && version != null) {
      context.go(ruleVersionPath(version.id));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => PageFrame(
    children: [
      PageHeader(
        title: 'کتابخانهٔ قواعد',
        actions: [
          OutlinedButton(
            onPressed: () => context.go('/library'),
            child: const Text('استراتژی‌های داخلی'),
          ),
          FilledButton.icon(
            onPressed: () => _draft(context),
            icon: const Icon(Icons.add),
            label: const Text('پیش‌نویس تازه'),
          ),
        ],
      ),
      SectionCard(
        title: 'نسخه‌های ذخیره‌شده',
        child: RuleVersionPicker(
          onPick: (version) => context.go(ruleVersionPath(version.id)),
        ),
      ),
      SectionCard(
        title: 'شروع از یک الگو',
        child: AsyncSection(
          value: ref.watch(ruleTemplatesProvider),
          onRetry: () => ref.invalidate(ruleTemplatesProvider),
          skeleton: const Card(child: ListTile(title: Text('دریافت الگوها'))),
          builder: (templates) => Column(
            children: [
              for (final template in templates)
                ListTile(
                  title: Text(template.title),
                  subtitle: Text(template.description),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => _draft(context, template: template),
                ),
            ],
          ),
        ),
      ),
    ],
  );
}

class RuleDetailsScreen extends ConsumerWidget {
  const RuleDetailsScreen({super.key, required this.id});

  final Int64 id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ruleVersionProvider(id);
    return PageFrame(
      children: [
        PageHeader(
          title: 'نسخهٔ قواعد',
          actions: [
            OutlinedButton(
              onPressed: () => context.go('/library/rules'),
              child: const Text('کتابخانهٔ قواعد'),
            ),
          ],
        ),
        AsyncSection(
          value: ref.watch(provider),
          onRetry: () => ref.invalidate(provider),
          skeleton: const Card(child: ListTile(title: Text('دریافت نسخه'))),
          builder: (data) => _RuleDetails(data: data),
        ),
      ],
    );
  }
}

class _RuleDetails extends StatelessWidget {
  const _RuleDetails({required this.data});

  final GetRuleVersionResponse data;

  Future<void> _clone(BuildContext context) async {
    final copy = await showDialog<RuleVersionSummary>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RuleDraftDialog(
        parent: data.version,
        definition: data.definitionJson,
      ),
    );
    if (context.mounted && copy != null) context.go(ruleVersionPath(copy.id));
  }

  @override
  Widget build(BuildContext context) {
    final version = data.version;
    final definition = jsonDecode(data.definitionJson) as RuleJson;
    final base = definition['base_timeframe'] as String?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          title: version.title,
          trailing: OutlinedButton.icon(
            onPressed: () => _clone(context),
            icon: const Icon(Icons.copy_outlined),
            label: const Text('ساخت نسخه از این تعریف'),
          ),
          child: _RuleSummary(definition: definition),
        ),
        const SizedBox(height: AppSpace.md),
        SectionCard(
          title: 'نیاز داده',
          child: Text(
            base == null
                ? 'کندل بسته‌شده از هر بازهٔ پشتیبانی‌شده'
                : 'کندل بسته‌شده در بازهٔ ${ruleTimeframes[base]}. بازهٔ داده باید با این نسخه هم‌خوان باشد.',
          ),
        ),
        const SizedBox(height: AppSpace.md),
        SectionCard(
          title: 'تبار نسخه',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('نسخهٔ ${version.id}'),
              SelectableText(
                version.contentHash,
                textDirection: TextDirection.ltr,
                style: AppText.mono,
              ),
              if (version.templateKey.isNotEmpty)
                Text('الگوی ${version.templateKey}'),
              for (final parent in [
                version.parentId,
                version.otherParentId,
              ].where((id) => id != Int64.ZERO))
                _RuleParent(id: parent, current: definition),
            ],
          ),
        ),
      ],
    );
  }
}

class _RuleSummary extends StatelessWidget {
  const _RuleSummary({required this.definition});

  final RuleJson definition;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('ورود: ${describeRule(definition['entry'] as RuleJson)}'),
      Text('خروج: ${describeRule(definition['exit'] as RuleJson)}'),
      Text('سهم سرمایه: ${definition['exposure']}'),
    ],
  );
}

class _RuleParent extends ConsumerStatefulWidget {
  const _RuleParent({required this.id, required this.current});

  final Int64 id;
  final RuleJson current;

  @override
  ConsumerState<_RuleParent> createState() => _RuleParentState();
}

class _RuleParentState extends ConsumerState<_RuleParent> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    final provider = ruleVersionProvider(widget.id);
    return ExpansionTile(
      title: Text('تغییرات نسبت به نسخهٔ ${widget.id}'),
      onExpansionChanged: (open) => setState(() => _opened = open),
      children: [
        if (_opened)
          AsyncSection(
            value: ref.watch(provider),
            onRetry: () => ref.invalidate(provider),
            skeleton: const LinearProgressIndicator(),
            builder: (data) => _RuleChanges(
              previous: jsonDecode(data.definitionJson) as RuleJson,
              current: widget.current,
            ),
          ),
        TextButton(
          onPressed: () => context.go(ruleVersionPath(widget.id)),
          child: const Text('بازکردن نسخهٔ مبنا'),
        ),
      ],
    );
  }
}

class _RuleChanges extends StatelessWidget {
  const _RuleChanges({required this.previous, required this.current});

  final RuleJson previous;
  final RuleJson current;

  @override
  Widget build(BuildContext context) {
    final changes = [
      for (final (key, label) in [
        ('entry', 'ورود'),
        ('exit', 'خروج'),
        ('exposure', 'سهم سرمایه'),
        ('base_timeframe', 'بازهٔ پایه'),
      ])
        if (jsonEncode(previous[key]) != jsonEncode(current[key]))
          (label, _display(previous[key]), _display(current[key])),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (changes.isEmpty) const Text('تعریف قواعد تغییری ندارد.'),
        for (final (label, before, after) in changes)
          ListTile(
            title: Text(label),
            subtitle: Text('مبنا: $before\nاین نسخه: $after'),
          ),
      ],
    );
  }

  String _display(Object? value) => value is RuleJson
      ? describeRule(value)
      : ruleTimeframes[value] ?? value?.toString() ?? 'همهٔ بازه‌ها';
}
