import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/gen/lab/v1/health.pb.dart';
import 'package:trading_lab/gen/lab/v1/workspace.pb.dart';

void main() {
  test('workspace environment uses the typed status before legacy mode', () {
    expect(workspaceEnvironment(null), Environment.ENVIRONMENT_UNSPECIFIED);

    final legacy = EngineStatus(mode: RunMode.RUN_MODE_RESEARCH);
    expect(workspaceEnvironment(legacy), Environment.ENVIRONMENT_RESEARCH);
    expect(
      workspaceEnvironment(legacy.deepCopy()..capabilities = WorkspaceCapabilities()),
      Environment.ENVIRONMENT_UNSPECIFIED,
    );
    expect(
      workspaceEnvironment(legacy.deepCopy()..environment = Environment.ENVIRONMENT_PAPER),
      Environment.ENVIRONMENT_PAPER,
    );
  });

  test('signal v1 preserves an explicit flat target and absent expiry', () {
    // The engine reads the same fixture with protojson.
    final fixture = jsonDecode(File('../testdata/contracts/signal-v1.json').readAsStringSync());
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
