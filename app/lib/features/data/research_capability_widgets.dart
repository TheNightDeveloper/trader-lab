import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../l10n/app_localizations.dart';
import 'data_providers.dart';

/// Keep the server's explanation beside the controls it restricts.
class ResearchCapabilityNotice extends ConsumerWidget {
  const ResearchCapabilityNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    return AsyncSection(
      value: ref.watch(overviewProvider),
      onRetry: () => ref.invalidate(overviewProvider),
      skeleton: Text(l.researchCapabilitiesLoading, style: AppText.caption),
      builder: (r) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            r.researchCapabilities.isEmpty ? l.researchCapabilitiesMissing : l.researchScopeHelp,
            style: AppText.caption,
          ),
          for (final c in r.researchCapabilities.where((c) => !c.supported && c.reason.isNotEmpty))
            Text(c.reason, style: AppText.caption),
        ],
      ),
    );
  }
}

/// The capability list drives learning settings and dataset-based execution alike.
class ResearchSymbolPicker extends ConsumerWidget {
  const ResearchSymbolPicker({required this.selected, required this.onChanged, super.key});
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncSection(
      value: ref.watch(overviewProvider),
      onRetry: () => ref.invalidate(overviewProvider),
      skeleton: const SizedBox(height: 44),
      builder: (r) {
        final symbols = r.researchCapabilities.where((c) => c.supported).map((c) => c.symbol).toSet();
        return LabChoiceChips<String>(
          multi: true,
          ltr: true,
          options: [for (final s in symbols) (s, s)],
          selected: selected.intersection(symbols),
          onChanged: onChanged,
        );
      },
    );
  }
}
