import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/metric.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/library.pb.dart';
import '../page_frame.dart';
import 'rule_composer.dart';
import 'rule_draft_dialog.dart';
import 'rule_editor.dart';
import 'rule_version_picker.dart';

class RuleLibraryScreen extends ConsumerWidget {
  const RuleLibraryScreen({super.key});

  Future<void> _compose(BuildContext context) async {
    final version = await showDialog<RuleVersionSummary>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ComposeRuleDialog(),
    );
    if (context.mounted && version != null) {
      context.go(ruleVersionPath(version.id));
    }
  }

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
          OutlinedButton.icon(
            onPressed: () => _compose(context),
            icon: const Icon(Icons.merge_type),
            label: const Text('ترکیب نسخه‌ها'),
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
          showEvidence: true,
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

class _RuleDetails extends StatefulWidget {
  const _RuleDetails({required this.data});

  final GetRuleVersionResponse data;

  @override
  State<_RuleDetails> createState() => _RuleDetailsState();
}

class _RuleDetailsState extends State<_RuleDetails> {
  int _tab = 0;

  Future<void> _clone(BuildContext context) async {
    final data = widget.data;
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
    final data = widget.data;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DefaultTabController(
                length: 4,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  onTap: (tab) => setState(() => _tab = tab),
                  tabs: const [
                    Tab(text: 'قواعد'),
                    Tab(text: 'عملکرد'),
                    Tab(text: 'نسخه‌ها'),
                    Tab(text: 'نیاز داده'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.md),
              switch (_tab) {
                1 => _RuleEvidence(
                  report: data.hasLatestReport() ? data.latestReport : null,
                ),
                2 => _RuleLineage(version: version, definition: definition),
                3 => Text(
                  base == null
                      ? 'کندل بسته‌شده از هر بازهٔ پشتیبانی‌شده'
                      : 'کندل بسته‌شده در بازهٔ ${ruleTimeframes[base]}. بازهٔ داده باید با این نسخه هم‌خوان باشد.',
                ),
                _ => _RuleSummary(definition: definition),
              },
            ],
          ),
        ),
        const SizedBox(height: AppSpace.md),
        _RuleBacktests(data: data),
      ],
    );
  }
}

class _RuleLineage extends StatelessWidget {
  const _RuleLineage({required this.version, required this.definition});

  final RuleVersionSummary version;
  final RuleJson definition;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('نسخهٔ ${version.id}'),
      SelectableText(
        version.contentHash,
        textDirection: TextDirection.ltr,
        style: AppText.mono,
      ),
      if (version.templateKey.isNotEmpty) Text('الگوی ${version.templateKey}'),
      for (final parent in [
        version.parentId,
        version.otherParentId,
      ].where((id) => id != Int64.ZERO))
        _RuleParent(id: parent, current: definition),
    ],
  );
}

class _RuleEvidence extends StatelessWidget {
  const _RuleEvidence({required this.report});

  final LatestReport? report;

  @override
  Widget build(BuildContext context) {
    final latest = report;
    if (latest == null) {
      return const EmptyState('برای این نسخه هنوز بک‌تستی ثبت نشده است.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('آخرین بک‌تست · ${fmtDateTime(utcMs(latest.createdUnixMs))}'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('بازده خارج از نمونه'),
          trailing: Num(
            fractionToPct(latest.totalReturn),
            signed: true,
            fractionDigits: 2,
            unit: '%',
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/reports/${latest.reportId}'),
            icon: const Icon(Icons.assessment_outlined),
            label: const Text('گزارش و شرایط اجرا'),
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

class _RuleBacktests extends StatefulWidget {
  const _RuleBacktests({required this.data});

  final GetRuleVersionResponse data;

  @override
  State<_RuleBacktests> createState() => _RuleBacktestsState();
}

class _RuleBacktestsState extends State<_RuleBacktests> {
  // Once expanded the form stays mounted so hiding it does not discard an in-flight group.
  bool _opened = false;
  bool get _group => widget.data.version.otherParentId != Int64.ZERO;

  @override
  Widget build(BuildContext context) => SectionCard(
    child: ExpansionTile(
      title: Text(_group ? 'بک‌تست A، B و A+B' : 'بک‌تست این نسخه'),
      maintainState: true,
      onExpansionChanged: (value) {
        if (value && !_opened) setState(() => _opened = true);
      },
      children: [
        if (_opened) RuleBacktestSection(rule: widget.data, compare: _group),
      ],
    ),
  );
}
