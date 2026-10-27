import 'package:fixnum/fixnum.dart';

/// Engine timestamps are UTC milliseconds; the UI shows them in UTC, LTR.
DateTime utcMs(Int64 ms) => DateTime.fromMillisecondsSinceEpoch(ms.toInt(), isUtc: true);

String two(int n) => n.toString().padLeft(2, '0');

/// 2024-01-31
String fmtDate(DateTime t) => '${t.year}-${two(t.month)}-${two(t.day)}';

/// 2024-01-31 13:05
String fmtDateTime(DateTime t) => '${fmtDate(t)} ${two(t.hour)}:${two(t.minute)}';

/// ds:7f3a…c1 — short, recognizable form of a content hash.
String shortHash(String h, {String prefix = 'ds:'}) =>
    h.length <= 8 ? '$prefix$h' : '$prefix${h.substring(0, 4)}…${h.substring(h.length - 2)}';

/// 38.2 GB
String fmtBytes(Int64 bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var v = bytes.toDouble(); // display only
  var i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  return '${i == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1)} ${units[i]}';
}

/// Parses YYYY-MM-DD as a UTC date; null if malformed.
DateTime? parseDate(String s) {
  final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(s.trim());
  if (m == null) return null;
  final d = DateTime.utc(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
  return fmtDate(d) == s.trim() ? d : null; // rejects 2024-02-31
}

/// A strategy parameter (model math, not money): 12 or 2.5, no trailing ".0".
String fmtParam(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

/// fast=12 slow=26, keys sorted so the same candidate always reads the same.
String fmtParams(Map<String, double> p) => ([...p.keys]..sort()).map((k) => '$k=${fmtParam(p[k]!)}').join(' ');
