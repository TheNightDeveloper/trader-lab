import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../gen/lab/v1/data.pb.dart';
import '../../l10n/app_localizations.dart';
import 'data_providers.dart';

/// Selection is supplied by the form so it survives search and page changes.
class DatasetPicker extends ConsumerStatefulWidget {
  const DatasetPicker({
    super.key,
    required this.selected,
    required this.onPick,
    required this.onRemove,
    this.timeframe = '',
  });

  final Map<String, Dataset?> selected;
  final ValueChanged<Dataset> onPick;
  final ValueChanged<String> onRemove;
  final String timeframe;

  @override
  ConsumerState<DatasetPicker> createState() => _DatasetPickerState();
}

class _DatasetPickerState extends ConsumerState<DatasetPicker> {
  Timer? _debounce;
  String _query = '';
  int _offset = 0;
  bool _typing = false;

  @override
  void didUpdateWidget(DatasetPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timeframe != widget.timeframe) _offset = 0;
  }

  void _search(String value) {
    _debounce?.cancel();
    setState(() => _typing = true);
    _debounce = Timer(const Duration(milliseconds: 250), () {
      setState(() {
        _query = value.trim();
        _offset = 0;
        _typing = false;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  static String _label(Dataset d) =>
      '${d.symbol} ${d.timeframe} · ${fmtDate(utcMs(d.fromUnixMs))} → ${fmtDate(utcMs(d.toUnixMs))} · ${shortHash(d.id)}';

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final page = researchDatasetPageProvider((query: _query, timeframe: widget.timeframe, offset: _offset));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.selected.isNotEmpty) ...[
          LabChoiceChips<String>(
            options: [
              for (final MapEntry(:key, :value) in widget.selected.entries)
                (key, value == null ? shortHash(key) : _label(value)),
            ],
            selected: widget.selected.keys.toSet(),
            ltr: true,
            multi: true,
            onChanged: (ids) => widget.onRemove(widget.selected.keys.firstWhere((id) => !ids.contains(id))),
          ),
          const SizedBox(height: AppSpace.sm),
        ],
        TextField(
          maxLength: 64,
          onChanged: _search,
          decoration: InputDecoration(
            labelText: l.datasetSearch,
            prefixIcon: const Icon(Icons.search),
            counterText: '',
          ),
        ),
        const SizedBox(height: AppSpace.sm),
        if (_typing)
          const LinearProgressIndicator()
        else
          AsyncSection(
            value: ref.watch(page),
            onRetry: () {
              ref.invalidate(overviewProvider);
              ref.invalidate(page);
            },
            skeleton: const LinearProgressIndicator(),
            builder: (result) {
              final rows = {
                for (final d in result.datasets)
                  if (!widget.selected.containsKey(d.id)) d.id: d,
              };
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (result.datasets.isEmpty)
                    Text(_query.isEmpty ? l.researchDatasetsEmpty : l.datasetNoSearchResults, style: AppText.caption),
                  if (rows.isNotEmpty)
                    LabChoiceChips<String>(
                      options: [for (final d in rows.values) (d.id, _label(d))],
                      selected: const {},
                      ltr: true,
                      onChanged: (ids) => widget.onPick(rows[ids.single]!),
                    ),
                  PagingBar(
                    Paging(
                      offset: _offset,
                      pageSize: pageSize,
                      total: result.total.toInt(),
                      onOffset: (offset) => setState(() => _offset = offset),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
