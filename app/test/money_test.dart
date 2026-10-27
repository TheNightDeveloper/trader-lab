import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/core/money.dart';
import 'package:trading_lab/gen/lab/v1/common.pb.dart' show Money;

void main() {
  test('moneyValue is exact beyond 2^53', () {
    // 9007199254740993 cannot be represented as a double or a web int.
    final m = Money(units: '-9007199254740993', scale: 8, asset: 'USDT');
    expect(moneyValue(m), Decimal.parse('-90071992.54740993'));
  });

  test('formatDecimal signs, groups, and keeps scale', () {
    final d = Decimal.parse;
    expect(formatDecimal(d('1234567.5'), fractionDigits: 2, signed: true), '+1,234,567.50');
    expect(formatDecimal(d('-0.05'), fractionDigits: 2), '${minusSign}0.05');
    expect(formatDecimal(d('-1000')), '${minusSign}1,000');
    expect(formatDecimal(d('0'), fractionDigits: 2, signed: true), '0.00');
    expect(formatDecimal(d('999')), '999');
  });
}
