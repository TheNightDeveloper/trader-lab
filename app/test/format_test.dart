import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/core/format.dart';

void main() {
  test('dates are UTC and strict', () {
    expect(fmtDateTime(utcMs(Int64(1704067200000))), '2024-01-01 00:00');
    expect(parseDate('2024-02-29'), DateTime.utc(2024, 2, 29));
    expect(parseDate('2024-02-31'), isNull);
    expect(parseDate('2024-2-3'), isNull);
    expect(parseDate('31/01/2024'), isNull);
  });

  test('bytes and hashes', () {
    expect(fmtBytes(Int64(512)), '512 B');
    expect(fmtBytes(Int64(41019805696)), '38.2 GB');
    expect(shortHash('7f3a9d0000000000c1'), 'ds:7f3a…c1');
  });
}
