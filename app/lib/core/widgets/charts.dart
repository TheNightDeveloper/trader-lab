import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../format.dart';
import '../theme/tokens.dart';

/// One line. Values are doubles for drawing only; labels use the engine's text.
class ChartSeries {
  const ChartSeries({
    required this.label,
    required this.points,
    required this.color,
    this.dashed = false,
    this.width = 2,
  });
  final String label;
  final List<(DateTime, double)> points;
  final Color color;
  final bool dashed;
  final double width;
}

class ChartRegion {
  const ChartRegion(this.from, this.to, this.label, this.color);
  final DateTime from, to;
  final String label;
  final Color color;
}

/// Equity curves with shaded regions. LTR (time runs left to right), series
/// told apart by colour and dash, hover shows the values under the pointer.
class EquityChart extends StatefulWidget {
  const EquityChart({super.key, required this.series, this.regions = const [], this.height = 260, this.format});
  final List<ChartSeries> series;
  final List<ChartRegion> regions;
  final double height;
  final String Function(double)? format;

  @override
  State<EquityChart> createState() => _EquityChartState();
}

class _EquityChartState extends State<EquityChart> {
  double? _hoverX;

  String _fmt(double v) => widget.format?.call(v) ?? v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final all = [for (final s in widget.series) ...s.points];
    if (all.isEmpty) return SizedBox(height: widget.height);
    var t0 = all.first.$1, t1 = all.first.$1;
    var lo = all.first.$2, hi = all.first.$2;
    for (final (t, v) in all) {
      if (t.isBefore(t0)) t0 = t;
      if (t.isAfter(t1)) t1 = t;
      lo = math.min(lo, v);
      hi = math.max(hi, v);
    }
    for (final r in widget.regions) {
      if (r.from.isBefore(t0)) t0 = r.from;
      if (r.to.isAfter(t1)) t1 = r.to;
    }
    if (hi == lo) {
      hi += 1;
      lo -= 1;
    }
    final pad = (hi - lo) * 0.08;
    final geom = _Geom(t0, t1, lo - pad, hi + pad);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpace.lg,
            runSpacing: AppSpace.xs,
            children: [for (final s in widget.series) _LegendItem(s), for (final r in widget.regions) _RegionItem(r)],
          ),
          const SizedBox(height: AppSpace.sm),
          SizedBox(
            height: widget.height,
            child: LayoutBuilder(
              builder: (context, box) {
                final size = Size(box.maxWidth, widget.height);
                final readout = _hoverX == null ? null : _readout(geom, size, _hoverX!);
                return MouseRegion(
                  onHover: (e) => setState(() => _hoverX = e.localPosition.dx),
                  onExit: (_) => setState(() => _hoverX = null),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Semantics(
                          label: [
                            for (final s in widget.series)
                              if (s.points.isNotEmpty) '${s.label}: ${_fmt(s.points.last.$2)}',
                          ].join('، '),
                          child: CustomPaint(
                            painter: _ChartPainter(widget.series, widget.regions, geom, _hoverX, _fmt),
                          ),
                        ),
                      ),
                      if (readout != null)
                        Positioned(
                          left: (_hoverX! + 12).clamp(0, math.max(0, size.width - 190)),
                          top: 8,
                          child: IgnorePointer(child: readout),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _readout(_Geom g, Size size, double x) {
    final t = g.timeAt(x, size.width);
    final rows = <Widget>[Text(fmtDateTime(t), style: AppText.mono.copyWith(fontSize: 11, color: AppColors.textMuted))];
    for (final s in widget.series) {
      final p = _nearest(s.points, t);
      if (p != null) {
        rows.add(Text('${s.label}  ${_fmt(p.$2)}', style: AppText.mono.copyWith(fontSize: 12, color: s.color)));
      }
    }
    return Container(
      padding: const EdgeInsets.all(AppSpace.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: rows),
    );
  }

  static (DateTime, double)? _nearest(List<(DateTime, double)> pts, DateTime t) {
    (DateTime, double)? best;
    for (final p in pts) {
      if (p.$1.isAfter(t)) break;
      best = p;
    }
    return best ?? (pts.isEmpty ? null : pts.first);
  }
}

class _Geom {
  _Geom(this.t0, this.t1, this.lo, this.hi);
  final DateTime t0, t1;
  final double lo, hi;
  static const left = 64.0, bottom = 22.0, top = 6.0;

  double x(DateTime t, double w) {
    final span = t1.difference(t0).inMilliseconds;
    return left + (span == 0 ? 0 : t.difference(t0).inMilliseconds / span) * (w - left);
  }

  double y(double v, double h) => top + (1 - (v - lo) / (hi - lo)) * (h - top - bottom);

  DateTime timeAt(double x, double w) {
    final f = ((x - left) / (w - left)).clamp(0.0, 1.0);
    return t0.add(Duration(milliseconds: (t1.difference(t0).inMilliseconds * f).round()));
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.series, this.regions, this.g, this.hoverX, this.fmt);
  final List<ChartSeries> series;
  final List<ChartRegion> regions;
  final _Geom g;
  final double? hoverX;
  final String Function(double) fmt;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    for (final r in regions) {
      canvas.drawRect(
        Rect.fromLTRB(g.x(r.from, w), _Geom.top, g.x(r.to, w), h - _Geom.bottom),
        Paint()..color = r.color,
      );
    }
    final grid = Paint()..color = AppColors.divider;
    final label = AppText.mono.copyWith(fontSize: 10, color: AppColors.textMuted);
    for (var i = 0; i <= 4; i++) {
      final v = g.lo + (g.hi - g.lo) * i / 4;
      final y = g.y(v, h);
      canvas.drawLine(Offset(_Geom.left, y), Offset(w, y), grid);
      _text(canvas, fmt(v), Offset(0, y - 7), label, _Geom.left - 6);
    }
    _text(canvas, fmtDate(g.t0), Offset(_Geom.left, h - _Geom.bottom + 6), label, 120);
    _text(canvas, fmtDate(g.t1), Offset(w - 80, h - _Geom.bottom + 6), label, 80);

    for (final s in series) {
      if (s.points.length < 2) continue;
      final path = Path();
      for (final (i, (t, v)) in s.points.indexed) {
        final o = Offset(g.x(t, w), g.y(v, h));
        i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      }
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = s.width
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(s.dashed ? _dash(path, 6, 4) : path, paint);
    }
    if (hoverX != null && hoverX! >= _Geom.left) {
      canvas.drawLine(
        Offset(hoverX!, _Geom.top),
        Offset(hoverX!, h - _Geom.bottom),
        Paint()..color = AppColors.textMuted,
      );
    }
  }

  static Path _dash(Path src, double on, double off) {
    final out = Path();
    for (final m in src.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += on + off) {
        out.addPath(m.extractPath(d, math.min(d + on, m.length)), Offset.zero);
      }
    }
    return out;
  }

  static void _text(Canvas c, String s, Offset at, TextStyle st, double maxW) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: st),
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: maxW);
    tp.paint(c, at);
  }

  @override
  bool shouldRepaint(_ChartPainter old) => old.series != series || old.hoverX != hoverX || old.regions != regions;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem(this.s);
  final ChartSeries s;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomPaint(size: const Size(22, 10), painter: _LegendLine(s.color, s.dashed)),
      const SizedBox(width: 6),
      Text(s.label, style: AppText.caption.copyWith(color: AppColors.textSecondary)),
    ],
  );
}

class _LegendLine extends CustomPainter {
  _LegendLine(this.color, this.dashed);
  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2;
    final y = size.height / 2;
    if (!dashed) return canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    for (var x = 0.0; x < size.width; x += 7) {
      canvas.drawLine(Offset(x, y), Offset(math.min(x + 4, size.width), y), p);
    }
  }

  @override
  bool shouldRepaint(_LegendLine old) => false;
}

class _RegionItem extends StatelessWidget {
  const _RegionItem(this.r);
  final ChartRegion r;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 14,
        height: 10,
        decoration: BoxDecoration(
          color: r.color,
          border: Border.all(color: AppColors.borderStrong),
        ),
      ),
      const SizedBox(width: 6),
      Text(r.label, style: AppText.caption),
    ],
  );
}

/// Signed values on a grid; positive green, negative orange, intensity by size.
/// The selected cell is outlined; every cell shows its value as text.
class Heatmap extends StatelessWidget {
  const Heatmap({super.key, required this.xs, required this.ys, required this.cells, this.selected});
  final List<String> xs, ys; // axis labels
  final List<List<({double? value, String text})>> cells; // [y][x]; null value = invalid
  final (int, int)? selected; // (x, y)

  @override
  Widget build(BuildContext context) {
    var mx = 0.0;
    for (final row in cells) {
      for (final c in row) {
        if (c.value != null) mx = math.max(mx, c.value!.abs());
      }
    }
    Color bg(double? v) {
      if (v == null) return AppColors.surfaceRaised;
      final a = mx == 0 ? 0.1 : 0.15 + 0.6 * (v.abs() / mx);
      return (v >= 0 ? AppColors.positive : AppColors.negative).withValues(alpha: a);
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          for (var yi = cells.length - 1; yi >= 0; yi--) // larger y on top
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(ys[yi], style: AppText.mono.copyWith(fontSize: 11, color: AppColors.textMuted)),
                ),
                for (final (xi, c) in cells[yi].indexed)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bg(c.value),
                        borderRadius: BorderRadius.circular(4),
                        border: selected == (xi, yi) ? Border.all(color: AppColors.textPrimary, width: 2) : null,
                      ),
                      child: Text(c.text, style: AppText.mono.copyWith(fontSize: 12, color: AppColors.textPrimary)),
                    ),
                  ),
              ],
            ),
          Row(
            children: [
              const SizedBox(width: 48),
              for (final x in xs)
                Expanded(
                  child: Center(
                    child: Text(x, style: AppText.mono.copyWith(fontSize: 11, color: AppColors.textMuted)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
