import 'package:material_ui/material_ui.dart';

import '../../core/theme/tokens.dart';

/// Rule fields mirror the server schema so a saved tree can be edited without a lossy conversion.
typedef RuleJson = Map<String, dynamic>;

const ruleTimeframes = <String, String>{
  '1m': '۱ دقیقه',
  '15m': '۱۵ دقیقه',
  '1h': '۱ ساعت',
  '4h': '۴ ساعت',
  '1d': '۱ روز',
};
const _operators = <String, String>{
  'gt': 'بزرگ‌تر از',
  'gte': 'بزرگ‌تر یا مساوی',
  'lt': 'کوچک‌تر از',
  'lte': 'کوچک‌تر یا مساوی',
  'cross_above': 'تقاطع صعودی با',
  'cross_below': 'تقاطع نزولی با',
  'and': 'همهٔ شرط‌ها',
  'or': 'حداقل یک شرط',
  'route': 'انتخاب بر اساس یک شرط',
};
const _kinds = <String, String>{
  'close': 'قیمت پایانی',
  'sma': 'میانگین متحرک ساده',
  'bucket_close': 'قیمت پایانی بازهٔ بزرگ‌تر',
  'constant': 'عدد ثابت',
};

/// The engine's decimal syntax is ASCII even when the user types Persian digits.
String ruleNumber(String text) => String.fromCharCodes(
  text.trim().runes.map(
    (rune) => switch (rune) {
      >= 0x06f0 && <= 0x06f9 => rune - 0x06f0 + 0x30,
      >= 0x0660 && <= 0x0669 => rune - 0x0660 + 0x30,
      0x066b => 0x2e,
      _ => rune,
    },
  ),
);
RuleJson comparisonRule(String op) => {
  'op': op,
  'left': {'kind': 'close'},
  'right': {'kind': 'sma', 'period': 20},
};

Iterable<RuleJson> childrenOf(RuleJson rule) =>
    (rule['args'] as List<dynamic>? ?? const []).cast<RuleJson>();

String describeOperand(RuleJson operand) => switch (operand['kind']) {
  'sma' => 'میانگین ${operand['period'] ?? '…'} کندل',
  'bucket_close' =>
    'پایان بازهٔ ${ruleTimeframes[operand['timeframe']] ?? '…'}',
  'constant' => '${operand['number'] ?? '…'}',
  _ => 'قیمت پایانی',
};

String describeRule(RuleJson rule) {
  final op = rule['op'] as String;
  final children = childrenOf(rule);
  if (op == 'route') {
    final branches = children.map(describeRule).toList();
    return 'اگر ${branches[0]}، ${branches[1]} وگرنه ${branches[2]}';
  }
  if (children.isNotEmpty) {
    return '(${children.map(describeRule).join(op == 'and' ? ' و ' : ' یا ')})';
  }
  return '${describeOperand(rule['left'] as RuleJson)} ${_operators[op]} ${describeOperand(rule['right'] as RuleJson)}';
}

class RuleNodeEditor extends StatefulWidget {
  const RuleNodeEditor({
    super.key,
    required this.rule,
    required this.onChanged,
    required this.label,
    this.depth = 1,
  });

  final RuleJson rule;
  final ValueChanged<RuleJson> onChanged;
  final String label;
  final int depth;

  @override
  State<RuleNodeEditor> createState() => _RuleNodeEditorState();
}

class _RuleNodeEditorState extends State<RuleNodeEditor> {
  int _childrenRevision = 0;

  @override
  Widget build(BuildContext context) {
    final RuleNodeEditor(:rule, :onChanged, :depth, :label) = widget;
    final op = rule['op'] as String;
    final children = childrenOf(rule).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RuleSelect(
          value: op,
          label: label,
          options: {
            for (final MapEntry(:key, :value) in _operators.entries)
              if (depth < 8 || !['and', 'or', 'route'].contains(key))
                key: value,
          },
          onChanged: (next) {
            if (next == op) return;
            if (op == 'route' || next == 'route') {
              setState(() => _childrenRevision++);
            }
            final previous = op == 'route'
                ? children.skip(1).toList()
                : children;
            final arms = previous.isEmpty
                ? [rule, comparisonRule('gt')]
                : previous;
            onChanged(switch (next) {
              'route' when op != 'route' => {
                'op': next,
                'args': [comparisonRule('gte'), ...arms.take(2)],
              },
              'and' || 'or' => {'op': next, 'args': arms},
              _ when children.isNotEmpty => comparisonRule(next),
              _ => {...rule, 'op': next},
            });
          },
        ),
        if (children.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpace.sm),
            child: Column(
              children: [
                for (final (side, name) in [
                  ('left', 'مقدار اول'),
                  ('right', 'مقدار دوم'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpace.sm),
                    child: _OperandEditor(
                      label: name,
                      operand: rule[side] as RuleJson,
                      onChanged: (value) => onChanged({...rule, side: value}),
                    ),
                  ),
              ],
            ),
          )
        else ...[
          for (final (index, child) in children.indexed)
            Padding(
              key: ValueKey((_childrenRevision, index)),
              padding: const EdgeInsets.only(top: AppSpace.sm),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RuleNodeEditor(
                        label: op == 'route'
                            ? [
                                'شرط انتخاب',
                                'در صورت برقراری شرط',
                                'در صورت برقرار نبودن شرط',
                              ][index]
                            : 'عملگر شرط ${index + 1}',
                        rule: child,
                        depth: depth + 1,
                        onChanged: (value) => onChanged({
                          ...rule,
                          'args': [
                            for (final (i, item) in children.indexed)
                              if (i == index) value else item,
                          ],
                        }),
                      ),
                      if (op != 'route' && children.length > 2)
                        TextButton(
                          onPressed: () {
                            // Rebuild moved fields so their editing state follows the remaining rules.
                            setState(() => _childrenRevision++);
                            onChanged({
                              ...rule,
                              'args': [
                                for (final (i, item) in children.indexed)
                                  if (i != index) item,
                              ],
                            });
                          },
                          child: Text('حذف شرط ${index + 1}'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          // The engine validates the total node count across entry and exit.
          if (op != 'route')
            TextButton(
              onPressed: children.length < 64
                  ? () => onChanged({
                      ...rule,
                      'args': [...children, comparisonRule('gt')],
                    })
                  : null,
              child: const Text('افزودن شرط'),
            ),
        ],
      ],
    );
  }
}

class _OperandEditor extends StatelessWidget {
  const _OperandEditor({
    required this.label,
    required this.operand,
    required this.onChanged,
  });

  final String label;
  final RuleJson operand;
  final ValueChanged<RuleJson> onChanged;

  @override
  Widget build(BuildContext context) {
    final kind = operand['kind'] as String;
    final field = kind == 'sma' ? 'period' : 'number';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RuleSelect(
          value: kind,
          label: label,
          options: _kinds,
          onChanged: (next) => onChanged({
            'kind': next,
            if (next == 'sma') 'period': 20,
            if (next == 'constant') 'number': 0,
            if (next == 'bucket_close') 'timeframe': '1h',
          }),
        ),
        if (kind == 'sma' || kind == 'constant') ...[
          const SizedBox(height: AppSpace.sm),
          TextFormField(
            key: ValueKey(kind),
            initialValue: operand[field]?.toString(),
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.numberWithOptions(
              decimal: kind == 'constant',
            ),
            decoration: InputDecoration(
              labelText: kind == 'sma'
                  ? 'دوره (۲ تا ۱۰۰۰ کندل)'
                  : 'عدد ثابت (صفر یا بیشتر)',
            ),
            onChanged: (text) => onChanged({
              ...operand,
              field: kind == 'sma'
                  ? int.tryParse(ruleNumber(text))
                  : double.tryParse(ruleNumber(text)),
            }),
            validator: (_) {
              final v = operand[field] as num?;
              final valid =
                  v != null &&
                  v.isFinite &&
                  (kind == 'sma' ? v >= 2 && v <= 1000 : !v.isNegative);
              return valid ? null : 'مقدار معتبر وارد کنید';
            },
          ),
        ],
        if (kind == 'bucket_close') ...[
          const SizedBox(height: AppSpace.sm),
          RuleSelect(
            label: 'بازهٔ بزرگ‌تر',
            value: operand['timeframe'] as String,
            options: ruleTimeframes,
            onChanged: (value) => onChanged({...operand, 'timeframe': value}),
          ),
        ],
      ],
    );
  }
}

class RuleSelect extends StatelessWidget {
  const RuleSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    initialValue: value,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      for (final MapEntry(:key, :value) in options.entries)
        DropdownMenuItem(value: key, child: Text(value)),
    ],
    onChanged: enabled
        ? (next) {
            if (next != null) onChanged(next);
          }
        : null,
  );
}
