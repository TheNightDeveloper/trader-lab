import 'package:decimal/decimal.dart';

import '../gen/lab/v1/common.pb.dart' as pb;
import '../l10n/app_localizations.dart';
import 'money.dart';

/// Exact value of an engine Decimal (ratios, plain numbers).
Decimal decValue(pb.Decimal d) => Decimal.parse(d.units.isEmpty ? '0' : d.units).shift(-d.scale);

/// A UI-side Decimal for requests: [v] at exactly [scale] decimals (throws if
/// that would round — callers validate first).
pb.Decimal decOut(Decimal v, int scale) {
  final units = v.shift(scale);
  if (!units.isInteger) throw ArgumentError('$v has more than $scale decimals');
  return pb.Decimal(units: units.toBigInt().toString(), scale: scale);
}

pb.Money usdtOut(Decimal v) {
  final units = v.shift(8);
  if (!units.isInteger) throw ArgumentError('$v has more than 8 decimals');
  return pb.Money(units: units.toBigInt().toString(), scale: 8, asset: 'USDT');
}

/// bps (e.g. "10" or "7.5") → fraction Decimal at scale 6 (10 bps = 0.001000).
pb.Decimal bpsOut(Decimal bps) => decOut((bps / Decimal.fromInt(10000)).toDecimal(), 6);

/// percent (e.g. "50") → fraction at scale 6.
pb.Decimal pctOut(Decimal pct) => decOut((pct / Decimal.fromInt(100)).toDecimal(), 6);

Decimal fractionToBps(pb.Decimal d) => decValue(d) * Decimal.fromInt(10000);
Decimal fractionToPct(pb.Decimal d) => decValue(d) * Decimal.fromInt(100);

enum Sign { positive, negative, neutral }

class MetricText {
  const MetricText(this.text, this.sign, {this.unit});
  final String text;
  final String? unit;
  final Sign sign;
}

Sign signOf(Decimal v) => v > Decimal.zero
    ? Sign.positive
    : v < Decimal.zero
    ? Sign.negative
    : Sign.neutral;

const _costs = {'fees', 'slippage'};
const _plainUsdt = {'final_equity'};
const _plainRatio = {'win_rate', 'exposure'};

/// How a metric reads on screen: signed where it is a gain or loss, costs as
/// negatives, drawdown as a negative percent, durations humanized.
MetricText formatMetric(L10n l, pb.Metric m) {
  if (!m.valid) return MetricText(l.invalid, Sign.neutral);
  final v = decValue(m.value);
  switch (m.unit) {
    case 'USDT':
      if (_costs.contains(m.key)) {
        return MetricText(
          formatDecimal(-v, fractionDigits: 2),
          v > Decimal.zero ? Sign.negative : Sign.neutral,
          unit: 'USDT',
        );
      }
      final signed = !_plainUsdt.contains(m.key);
      return MetricText(
        formatDecimal(v, fractionDigits: 2, signed: signed),
        signed ? signOf(v) : Sign.neutral,
        unit: 'USDT',
      );
    case 'ratio':
      if (m.key == 'profit_factor') return MetricText(formatDecimal(v, fractionDigits: 2), Sign.neutral, unit: '×');
      final pct = v * Decimal.fromInt(100);
      if (m.key == 'max_drawdown') return MetricText(formatDecimal(-pct, fractionDigits: 2), Sign.neutral, unit: '%');
      if (_plainRatio.contains(m.key)) {
        return MetricText(formatDecimal(pct, fractionDigits: 1), Sign.neutral, unit: '%');
      }
      return MetricText(formatDecimal(pct, fractionDigits: 2, signed: true), signOf(v), unit: '%');
    case 'count':
      return MetricText(formatDecimal(v, fractionDigits: 0), Sign.neutral);
    case 'seconds':
      return MetricText(humanDuration(l, v.toBigInt().toInt()), Sign.neutral);
    default:
      return MetricText(formatDecimal(v, fractionDigits: 2), Sign.neutral);
  }
}

String humanDuration(L10n l, int seconds) {
  if (seconds >= 86400) return l.durationDays((seconds / 86400).round());
  if (seconds >= 3600) return l.durationHours((seconds / 3600).round());
  return l.durationMinutes((seconds / 60).round());
}

pb.Metric? metricOf(List<pb.Metric> ms, String key) {
  for (final m in ms) {
    if (m.key == key) return m;
  }
  return null;
}
