import 'package:decimal/decimal.dart';

import '../gen/lab/v1/common.pb.dart' show Money;

/// Exact value of an engine [Money]. Never converts through double or web int.
/// An unset Money (no units) reads as zero, like [decValue] for Decimal.
Decimal moneyValue(Money m) => Decimal.parse(m.units.isEmpty ? '0' : m.units).shift(-m.scale);

/// U+2212, the typographic minus used for every negative number on screen.
const minusSign = '−';

/// Formats [value] with thousands separators. [fractionDigits] defaults to the
/// value's own scale (no rounding); pass it only for display precision.
/// [signed] prints + for positives; negatives always get −, zero gets no sign.
String formatDecimal(Decimal value, {int? fractionDigits, bool signed = false}) {
  final digits = fractionDigits ?? value.scale;
  final s = value.abs().toStringAsFixed(digits);
  final dot = s.indexOf('.');
  final intPart = dot < 0 ? s : s.substring(0, dot);
  final frac = dot < 0 ? '' : s.substring(dot);
  final grouped = intPart.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  final sign = value < Decimal.zero
      ? minusSign
      : signed && value > Decimal.zero
      ? '+'
      : '';
  return '$sign$grouped$frac';
}
