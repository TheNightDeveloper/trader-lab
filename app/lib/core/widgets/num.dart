import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../money.dart';
import '../theme/tokens.dart';

enum Tone { auto, positive, negative, neutral }

/// Every number on screen: mono, tabular, LTR, with unit; signed values always
/// carry + or − so color is never the only cue.
class Num extends StatelessWidget {
  const Num(
    this.value, {
    super.key,
    this.unit,
    this.signed = false,
    this.tone = Tone.auto,
    this.fractionDigits,
    this.style = AppText.mono,
  });

  final Decimal value;
  final String? unit;
  final bool signed;
  final Tone tone;
  final int? fractionDigits;
  final TextStyle style;

  Color? get _color => switch (tone) {
    Tone.positive => AppColors.positive,
    Tone.negative => AppColors.negativeText,
    Tone.neutral => null,
    Tone.auto when signed && value > Decimal.zero => AppColors.positive,
    Tone.auto when signed && value < Decimal.zero => AppColors.negativeText,
    Tone.auto => null,
  };

  @override
  Widget build(BuildContext context) {
    final text = formatDecimal(value, fractionDigits: fractionDigits, signed: signed);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(unit == null ? text : '$text $unit', style: style.copyWith(color: _color)),
    );
  }
}

/// LTR mono text for symbols, hashes and codes that are not numbers.
class Mono extends StatelessWidget {
  const Mono(this.text, {super.key, this.style = AppText.mono});
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: Text(text, style: style),
  );
}
