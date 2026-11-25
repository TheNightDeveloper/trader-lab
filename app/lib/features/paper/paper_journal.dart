import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/nav.dart';
import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/data.dart';
import '../../core/widgets/layout.dart';
import '../../core/widgets/num.dart';
import '../../core/widgets/workspace_status.dart';
import '../../gen/lab/v1/paper.pb.dart';
import '../../gen/lab/v1/workspace.pbenum.dart';
import '../../l10n/app_localizations.dart';
import '../page_frame.dart';
import 'paper_entries.dart';
import 'paper_providers.dart';

class PaperJournalScreen extends ConsumerWidget {
  const PaperJournalScreen({super.key, required this.before});

  final Int64 before;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L10n.of(context);
    final provider = paperJournalProvider(before);
    final state = ref.watch(provider);
    final page = state.value;
    return PageFrame(
      children: [
        PageHeader(
          title: l.paperJournalTitle,
          actions: [
            const EnvironmentBadge(environment: Environment.ENVIRONMENT_PAPER),
            OutlinedButton(onPressed: () => context.go(Dest.paper.path), child: Text(l.navPaper)),
            if (before != Int64.ZERO)
              TextButton(onPressed: () => context.go('/paper/journal'), child: Text(l.paperJournalNewest)),
          ],
        ),
        // A failed poll leaves the last recorded page readable.
        if (page != null) ...[
          if (state.hasError) WarningBanner(l.engineUnreachable),
          if (page.trades.isEmpty) Text(l.paperJournalEmpty),
          for (final trade in page.trades) _JournalTrade(key: ValueKey(trade.receipt.id), trade: trade),
          if (page.nextBeforeReceiptId > Int64.ZERO)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton(
                onPressed: () => context.go('/paper/journal?before=${page.nextBeforeReceiptId}'),
                child: Text(l.paperJournalOlder),
              ),
            ),
        ] else
          AsyncSection(
            value: state,
            onRetry: () => ref.invalidate(provider),
            skeleton: Text(l.paperLoading),
            builder: (_) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}

class _JournalTrade extends StatelessWidget {
  const _JournalTrade({super.key, required this.trade});

  final PaperJournalTrade trade;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final receipt = trade.receipt;
    return SectionCard(
      title: paperEntryStateLabel(l, receipt.state),
      trailing: Mono('${receipt.symbol} · ${receipt.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Mono('${fmtDateTime(utcMs(receipt.confirmedAtUnixMs))} UTC'),
          const SizedBox(height: AppSpace.xs),
          if (trade.hasOpenQuantity())
            PaperMoneyLine(label: l.paperJournalOpenQuantity, amount: trade.openQuantity)
          else if (receipt.filledQuantity.units != '0')
            Text(l.paperJournalClosedPosition),
          PaperMoneyLine(label: l.paperJournalFeesPaid, amount: trade.feesPaid),
          PaperMoneyLine(label: l.paperRealizedPnl, amount: trade.realizedPnl),
          TextButton(onPressed: () => context.go('/paper/receipts/${receipt.id}'), child: Text(l.paperViewReceipt)),
        ],
      ),
    );
  }
}
