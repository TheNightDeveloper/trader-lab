import 'package:decimal/decimal.dart';

import '../l10n/app_localizations.dart';

final _num = RegExp(r'^\d+(\.\d{1,2})?$');

/// A positive number with at most two decimals (capital, percents).
String? vPositive(L10n l, String s) =>
    _num.hasMatch(s.trim()) && Decimal.parse(s.trim()) > Decimal.zero ? null : l.errPositive;

/// Basis points: 0..1000 with at most two decimals.
String? vBps(L10n l, String s) =>
    _num.hasMatch(s.trim()) && Decimal.parse(s.trim()) <= Decimal.fromInt(1000) ? null : l.errBps;

/// A non-negative number with at most two decimals.
String? vNonNegative(L10n l, String s) => _num.hasMatch(s.trim()) ? null : l.errNumber;

String? vInt(L10n l, String s, int lo, int hi) {
  final v = int.tryParse(s.trim());
  return v != null && v >= lo && v <= hi ? null : l.errNumber;
}
