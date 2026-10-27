import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../l10n/app_localizations.dart';
import '../theme/tokens.dart';

/// Renders an AsyncValue with the UI_SPEC states: loading (skeleton of the same
/// shape), error (what failed + retry), empty (one sentence + next action), data.
class AsyncSection<T> extends StatelessWidget {
  const AsyncSection({
    super.key,
    required this.value,
    required this.builder,
    required this.skeleton,
    required this.onRetry,
    this.isEmpty,
    this.empty,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final Widget skeleton; // placeholder with the real layout's shape
  final VoidCallback onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    final Widget child = switch (value) {
      AsyncData(:final value) when isEmpty?.call(value) ?? false => empty ?? const SizedBox.shrink(),
      AsyncData(:final value) => builder(value),
      AsyncError(:final error) => ErrorBox(error: error, onRetry: onRetry),
      _ => Skeletonizer(
        effect: const ShimmerEffect(baseColor: AppColors.surfaceRaised, highlightColor: AppColors.borderStrong),
        child: skeleton,
      ),
    };
    return AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.normal),
      switchInCurve: AppMotion.curve,
      child: KeyedSubtree(key: ValueKey(value.runtimeType), child: child),
    );
  }
}

class ErrorBox extends StatelessWidget {
  const ErrorBox({super.key, required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.negativeBorder),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.negative, size: 20),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: Text(l.loadFailed(errorText(error)), style: AppText.body.copyWith(color: AppColors.negativeText)),
            ),
            const SizedBox(width: AppSpace.sm),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l.retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Short, user-facing text for an error (Connect errors carry a clean message).
String errorText(Object e) {
  final s = e.toString();
  final i = s.indexOf(': ');
  return i > 0 && s.startsWith('ConnectException') ? s.substring(i + 2) : s;
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.text, {super.key, this.icon = Icons.inbox_outlined});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpace.xl),
    child: Column(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 28),
        const SizedBox(height: AppSpace.sm),
        Text(text, style: AppText.caption, textAlign: TextAlign.center),
      ],
    ),
  ).animate().fadeIn(duration: AppMotion.of(context, AppMotion.normal));
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value, this.tone});
  final String label;
  final Widget value;
  final Color? tone;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpace.lg),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(height: 6),
        DefaultTextStyle.merge(
          style: AppText.statValue.copyWith(
            fontFamily: AppFonts.ui,
            fontSize: 16,
            color: tone ?? AppColors.textPrimary,
          ),
          child: value,
        ),
      ],
    ),
  );
}

/// Grid of stat cards: auto-fit columns of at least [minWidth], 2 columns on phones.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.children, this.minWidth = 200});
  final List<Widget> children;
  final double minWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      const gap = 14.0;
      final cols = max(2, ((box.maxWidth + gap) / (minWidth + gap)).floor()).clamp(1, max(1, children.length));
      final w = (box.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final c in children) SizedBox(width: w, child: c)],
      );
    },
  );
}

/// Table that scrolls horizontally when narrower than [minWidth]; header muted,
/// row dividers, optional server-side paging footer.
class DataTableBox extends StatelessWidget {
  const DataTableBox({super.key, required this.columns, required this.rows, this.minWidth = 640, this.paging});
  final List<String> columns;
  final List<List<Widget>> rows;
  final double minWidth;
  final Paging? paging;

  @override
  Widget build(BuildContext context) {
    final header = TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      children: [for (final c in columns) _cell(Text(c, style: AppText.label))],
    );
    final body = [
      for (final r in rows)
        TableRow(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          children: [for (final c in r) _cell(c)],
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, box) {
            final w = max(box.maxWidth, minWidth);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: w,
                child: Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, children: [header, ...body]),
              ),
            );
          },
        ),
        if (paging != null) _PagingBar(paging!),
      ],
    );
  }

  static Widget _cell(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: 10),
    child: child,
  );
}

class Paging {
  const Paging({required this.offset, required this.pageSize, required this.total, required this.onOffset});
  final int offset, pageSize, total;
  final ValueChanged<int> onOffset;
}

class _PagingBar extends StatelessWidget {
  const _PagingBar(this.p);
  final Paging p;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    if (p.total <= p.pageSize) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.sm),
      child: Row(
        children: [
          Text(l.pageOf(p.offset + 1, min(p.offset + p.pageSize, p.total), p.total), style: AppText.caption),
          const Spacer(),
          TextButton(
            onPressed: p.offset > 0 ? () => p.onOffset(max(0, p.offset - p.pageSize)) : null,
            child: Text(l.pagePrev),
          ),
          TextButton(
            onPressed: p.offset + p.pageSize < p.total ? () => p.onOffset(p.offset + p.pageSize) : null,
            child: Text(l.pageNext),
          ),
        ],
      ),
    );
  }
}

/// Single- or multi-select chips. Selected = accentSoftBg + accent border + bold.
class LabChoiceChips<T> extends StatelessWidget {
  const LabChoiceChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.multi = false,
    this.ltr = false,
  });
  final List<(T, String)> options;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final bool multi;
  final bool ltr; // symbols and codes read left-to-right

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpace.sm,
    runSpacing: AppSpace.sm,
    children: [
      for (final (v, label) in options)
        _Chip(
          label: label,
          ltr: ltr,
          selected: selected.contains(v),
          onTap: () {
            if (!multi) return onChanged({v});
            final next = {...selected};
            next.contains(v) ? next.remove(v) : next.add(v);
            onChanged(next);
          },
        ),
    ],
  );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap, required this.ltr});
  final String label;
  final bool selected, ltr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    checked: selected,
    child: Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.fast),
          curve: AppMotion.curve,
          constraints: const BoxConstraints(minHeight: AppSize.minTouch, minWidth: AppSize.minTouch),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentSoftBg : AppColors.inputBg,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: selected ? AppColors.accent : AppColors.borderStrong),
          ),
          // Centered at its own size: `alignment` on the container would stretch the
          // chip to the full row width inside a Wrap.
          child: Align(
            widthFactor: 1,
            heightFactor: 1,
            child: Directionality(
              textDirection: ltr ? TextDirection.ltr : Directionality.of(context),
              child: Text(
                label,
                style: (ltr ? AppText.mono : AppText.body.copyWith(height: 1.4)).copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
