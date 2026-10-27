import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../gen/lab/v1/common.pb.dart' as pb;
import '../../l10n/app_localizations.dart';
import '../metric.dart';
import '../money.dart';
import '../theme/tokens.dart';
import 'num.dart';

Color toneColor(String tone) => switch (tone) {
  'positive' => AppColors.positive,
  'negative' => AppColors.negativeText,
  'warning' => AppColors.warning,
  _ => AppColors.textSecondary,
};

Color signColor(Sign s) => switch (s) {
  Sign.positive => AppColors.positive,
  Sign.negative => AppColors.negativeText,
  Sign.neutral => AppColors.textPrimary,
};

/// Engine verdict + plain-language sentence; border tone matches the verdict.
class VerdictCard extends StatelessWidget {
  const VerdictCard({super.key, required this.verdict, required this.tone, required this.sentence, this.title});
  final String verdict, tone, sentence;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = toneColor(tone);
    final border = switch (tone) {
      'positive' => AppColors.positiveBorder,
      'negative' => AppColors.negativeBorder,
      'warning' => AppColors.warningBorder,
      _ => AppColors.border,
    };
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.normal),
      padding: const EdgeInsets.all(AppSpace.lg + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (title != null) Text(title!, style: AppText.sectionTitle),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: border),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      switch (tone) {
                        'positive' => Icons.trending_up_rounded,
                        'negative' => Icons.trending_down_rounded,
                        _ => Icons.info_outline_rounded,
                      },
                      size: 16,
                      color: c,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      verdict,
                      style: AppText.body.copyWith(color: c, fontWeight: FontWeight.w700, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Text(sentence, style: AppText.body.copyWith(height: 2)),
        ],
      ),
    );
  }
}

class WaterfallRow {
  const WaterfallRow(this.label, this.amount, this.color);
  final String label;
  final Decimal amount;
  final Color color;
}

/// Gross → costs → net. Bar width ∝ |amount| / max; widths animate in.
class WaterfallBars extends StatelessWidget {
  const WaterfallBars({super.key, required this.rows, this.unit = 'USDT'});
  final List<WaterfallRow> rows;
  final String unit;

  @override
  Widget build(BuildContext context) {
    var mx = Decimal.zero;
    for (final r in rows) {
      if (r.amount.abs() > mx) mx = r.amount.abs();
    }
    final d = AppMotion.of(context, AppMotion.slow);
    return Column(
      children: [
        for (final (i, r) in rows.indexed)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SizedBox(width: 96, child: Text(r.label, style: AppText.label)),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: LayoutBuilder(
                      builder: (context, box) {
                        // Display only: a bar length, never a reported number.
                        final f = mx == Decimal.zero ? 0.0 : (r.amount.abs() / mx).toDouble();
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: f),
                            duration: d + AppMotion.of(context, AppMotion.stagger) * i,
                            curve: AppMotion.curve,
                            builder: (context, v, _) => Container(
                              width: (box.maxWidth * v).clamp(2, box.maxWidth),
                              height: 14,
                              decoration: BoxDecoration(color: r.color, borderRadius: BorderRadius.circular(3)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSpace.sm),
                SizedBox(
                  width: 120,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Num(r.amount, signed: true, fractionDigits: 2, unit: unit),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A metric with its engine definition behind "?". Invalid metrics show the word
/// "invalid" and the reason, never a number.
class MetricTile extends StatelessWidget {
  const MetricTile(this.metric, {super.key, this.label});
  final pb.Metric metric;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final t = formatMetric(l, metric);
    final help = metric.valid ? metric.definition : '${metric.definition}\n\n${l.invalid}: ${metric.invalid}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Flexible(
            child: Text(
              label ?? metric.label,
              style: AppText.body.copyWith(color: AppColors.textSecondary, height: 1.4),
            ),
          ),
          Tooltip(
            message: help,
            preferBelow: false,
            child: Semantics(
              button: true,
              label: help,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.help_outline_rounded, size: 16, color: AppColors.textMuted),
              ),
            ),
          ),
          const Spacer(),
          if (metric.valid)
            Mono(
              t.unit == null ? t.text : '${t.text} ${t.unit}',
              style: AppText.mono.copyWith(color: signColor(t.sign)),
            )
          else
            Tooltip(
              message: metric.invalid,
              child: Text(t.text, style: AppText.body.copyWith(color: AppColors.warningText, height: 1.4)),
            ),
        ],
      ),
    );
  }
}

class BadgeChip extends StatelessWidget {
  const BadgeChip(this.text, {super.key, this.tone = 'neutral'});
  final String text, tone;

  @override
  Widget build(BuildContext context) {
    final warn = tone == 'warning';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warn ? AppColors.warningBg : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: warn ? AppColors.warningBorder : AppColors.borderStrong),
      ),
      child: Text(
        text,
        style: AppText.caption.copyWith(color: warn ? AppColors.warningText : toneColor(tone), height: 1.5),
      ),
    ).animate().fadeIn(duration: AppMotion.of(context, AppMotion.normal));
  }
}

/// A Money from the engine as a signed number with unit.
Widget moneyNum(pb.Money m, {bool signed = true, int digits = 2}) =>
    Num(moneyValue(m), signed: signed, fractionDigits: digits, unit: m.asset);
