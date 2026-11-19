import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/gen/lab/v1/workspace.pb.dart';

void main() {
  test('signal v1 preserves an explicit flat target and absent expiry', () {
    // The engine reads the same fixture with protojson.
    final fixture = jsonDecode(
      File('../testdata/contracts/signal-v1.json').readAsStringSync(),
    );
    final signal = Signal()..mergeFromProto3Json(fixture);

    expect(signal.schemaVersion, 1);
    expect(signal.strategyVersionId, 'trend-ema@v1');
    expect(signal.instrument.product, MarketProduct.MARKET_PRODUCT_SPOT);
    expect(signal.instrument.symbol, 'BTCUSDT');
    expect(signal.observedAtUnixMs.toString(), '1795046400123');
    expect(signal.hasValidUntilUnixMs(), isFalse);
    expect(signal.targetExposure.units, '0');
    expect(signal.targetExposure.scale, 6);
    expect(Signal.fromBuffer(signal.writeToBuffer()), signal);
  });
}
