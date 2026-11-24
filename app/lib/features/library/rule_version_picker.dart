import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../gen/lab/v1/library.pb.dart';

final ruleTemplatesProvider = FutureProvider.autoDispose<List<RuleTemplate>>((
  ref,
) async {
  final response = await ref
      .watch(libraryClientProvider)
      .listRuleTemplates(ListRuleTemplatesRequest());
  return response.templates;
});

final ruleVersionProvider = FutureProvider.autoDispose
    .family<GetRuleVersionResponse, Int64>(
      (ref, id) => ref
          .watch(libraryClientProvider)
          .getRuleVersion(GetRuleVersionRequest(id: id)),
    );

final ruleVersionsProvider = FutureProvider.autoDispose
    .family<ListRuleVersionsResponse, (String, Int64)>((ref, page) {
      final (query, before) = page;
      return ref
          .watch(libraryClientProvider)
          .listRuleVersions(
            ListRuleVersionsRequest(query: query, beforeId: before),
          );
    });

/// The selected version belongs to the form and survives navigation between pages.
class RuleVersionPicker extends ConsumerStatefulWidget {
  const RuleVersionPicker({
    super.key,
    required this.onPick,
    this.selected,
    this.excluded,
  });

  final ValueChanged<RuleVersionSummary> onPick;
  final Int64? selected;
  final Int64? excluded;

  @override
  ConsumerState<RuleVersionPicker> createState() => _RuleVersionPickerState();
}

class _RuleVersionPickerState extends ConsumerState<RuleVersionPicker> {
  final _pages = [Int64.ZERO];
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      setState(() {
        _query = text.trim();
        _pages
          ..clear()
          ..add(Int64.ZERO);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ruleVersionsProvider((_query, _pages.last));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          maxLength: 100,
          decoration: const InputDecoration(
            labelText: 'جست‌وجوی عنوان نسخه',
            prefixIcon: Icon(Icons.search),
            counterText: '',
          ),
          onChanged: _search,
        ),
        const SizedBox(height: AppSpace.sm),
        AsyncSection(
          value: ref.watch(provider),
          onRetry: () => ref.invalidate(provider),
          skeleton: const Card(child: ListTile(title: Text('دریافت نسخه‌ها'))),
          builder: (data) => Column(
            children: [
              if (data.versions.isEmpty)
                const EmptyState('نسخه‌ای با این عنوان پیدا نشد.'),
              for (final version in data.versions)
                ListTile(
                  enabled: version.id != widget.excluded,
                  selected: widget.selected == version.id,
                  title: Text(version.title),
                  subtitle: Text(
                    'نسخهٔ ${version.id} · ${fmtDateTime(DateTime.fromMillisecondsSinceEpoch(version.createdUnixMs.toInt()))}',
                  ),
                  onTap: version.id == widget.excluded
                      ? null
                      : () => widget.onPick(version),
                ),
              if (_pages.length > 1 || data.nextBeforeId != Int64.ZERO)
                Wrap(
                  spacing: AppSpace.sm,
                  children: [
                    OutlinedButton(
                      onPressed: _pages.length > 1
                          ? () => setState(_pages.removeLast)
                          : null,
                      child: const Text('صفحهٔ قبل'),
                    ),
                    OutlinedButton(
                      onPressed: data.nextBeforeId == Int64.ZERO
                          ? null
                          : () => setState(() => _pages.add(data.nextBeforeId)),
                      child: const Text('صفحهٔ بعد'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
