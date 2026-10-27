import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/num.dart';
import '../../gen/lab/v1/data.pb.dart';

/// Per-pair coverage on one shared time axis. Always LTR: time runs left to right.
class CoverageTimeline extends StatelessWidget {
  const CoverageTimeline({super.key, required this.coverage, required this.now});
  final List<Coverage> coverage;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final start = coverage.map((c) => utcMs(c.firstOpenUnixMs)).reduce((a, b) => a.isBefore(b) ? a : b);
    final end = now.isAfter(start) ? now : start.add(const Duration(days: 1));
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in coverage)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.sm),
              child: Row(
                children: [
                  SizedBox(width: 90, child: Mono(c.symbol, style: AppText.mono.copyWith(fontSize: 12))),
                  Expanded(
                    child: Semantics(
                      label:
                          '${c.symbol}: ${fmtDate(utcMs(c.firstOpenUnixMs))} – ${fmtDate(utcMs(c.lastOpenUnixMs))}, '
                          '${c.segments.length} segments, ${c.problems.length} problem ranges',
                      child: CustomPaint(size: const Size.fromHeight(12), painter: _TrackPainter(c, start, end)),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              const SizedBox(width: 90),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final t in _ticks(start, end, middle: box.maxWidth > 300))
                        Mono(fmtDate(t), style: AppText.mono.copyWith(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static List<DateTime> _ticks(DateTime a, DateTime b, {required bool middle}) => [
    a,
    if (middle) a.add(b.difference(a) ~/ 2),
    b,
  ];
}

class _TrackPainter extends CustomPainter {
  _TrackPainter(this.c, this.start, this.end);
  final Coverage c;
  final DateTime start, end;

  double _x(DateTime t, double w) =>
      (t.difference(start).inMilliseconds / end.difference(start).inMilliseconds).clamp(0.0, 1.0) * w;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Radius.circular(size.height / 2);
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, r), Paint()..color = AppColors.inputBg);
    final have = Paint()..color = AppColors.accent.withValues(alpha: 0.55);
    for (final seg in c.segments) {
      final a = _x(utcMs(seg.fromUnixMs), size.width);
      final b = _x(utcMs(seg.untilUnixMs), size.width);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(a, 0, b < a + 2 ? a + 2 : b, size.height), r), have);
    }
    final bad = Paint()..color = AppColors.negative;
    for (final p in c.problems) {
      final x0 = _x(utcMs(p.fromUnixMs), size.width);
      final x1 = _x(utcMs(p.untilUnixMs), size.width);
      canvas.drawRect(Rect.fromLTRB(x0, 0, x1 - x0 < 2 ? x0 + 2 : x1, size.height), bad); // ≥ 2 px so it stays visible
    }
  }

  @override
  bool shouldRepaint(_TrackPainter old) => old.c != c || old.start != start || old.end != end;
}
