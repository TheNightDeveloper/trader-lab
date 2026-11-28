import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/api/engine.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/library.pb.dart';
import '../../gen/lab/v1/shadow.connect.client.dart';
import '../../gen/lab/v1/shadow.pb.dart';
import '../../l10n/app_localizations.dart';
import '../library/rule_version_picker.dart';

class ShadowStartDialog extends ConsumerStatefulWidget {
  const ShadowStartDialog({super.key, required this.symbols});

  final List<String> symbols;

  @override
  ConsumerState<ShadowStartDialog> createState() => _ShadowStartDialogState();
}

class _ShadowStartDialogState extends ConsumerState<ShadowStartDialog> {
  String? _symbol;
  RuleVersionSummary? _rule;
  bool _saving = false;
  Object? _error;

  Future<void> _start() async {
    final symbol = _symbol;
    final rule = _rule;
    if (_saving || symbol == null || rule == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final result = await ShadowServiceClient(ref.read(transportProvider))
          .startShadowDeployment(
            StartShadowDeploymentRequest(
              symbol: symbol,
              ruleVersionId: rule.id,
            ),
            signal: TimeoutSignal(const Duration(seconds: 12)),
          );
      if (mounted) Navigator.pop(context, result.deploymentId);
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
    final l = L10n.of(context);
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: Text(l.shadowStart),
        scrollable: true,
        content: SizedBox(
          width: 540,
          child: AbsorbPointer(
            absorbing: _saving,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.shadowStartHelp),
                const SizedBox(height: AppSpace.sm),
                DropdownButton<String>(
                  value: _symbol,
                  isExpanded: true,
                  hint: Text(l.marketScanSymbol),
                  items: [
                    for (final symbol in widget.symbols)
                      DropdownMenuItem(value: symbol, child: Mono(symbol)),
                  ],
                  onChanged: (value) => setState(() => _symbol = value),
                ),
                RuleVersionPicker(
                  showEvidence: true,
                  selected: _rule?.id,
                  onPick: (rule) => setState(() => _rule = rule),
                ),
                if (_rule case final rule?)
                  Text(rule.title, style: AppText.label),
                if (_error case final error?) WarningBanner(errorText(error)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: _saving || _symbol == null || _rule == null
                ? null
                : _start,
            child: Text(_saving ? l.shadowRegistering : l.shadowRegister),
          ),
        ],
      ),
    );
  }
}
