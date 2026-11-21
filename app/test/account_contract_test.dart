import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/gen/lab/v1/account.pb.dart';
import 'package:trading_lab/gen/lab/v1/workspace.pbenum.dart';

void main() {
  test('account snapshot distinguishes a zero value from unavailable money', () {
    // The same fixture is decoded by the Go contract test.
    final fixture = jsonDecode(File('../testdata/contracts/account-snapshot.json').readAsStringSync());
    final snapshot = AccountSnapshot()..mergeFromProto3Json(fixture);

    expect(snapshot.account.environment, Environment.ENVIRONMENT_PAPER);
    expect(snapshot.revision.toString(), '9007199254740993');
    expect(snapshot.equity.hasValue(), isTrue);
    expect(snapshot.equity.value.units, '0');
    expect(snapshot.availableBalance.hasValue(), isFalse);
    expect(snapshot.availableBalance.unavailable.reason, MoneyAvailability.MONEY_AVAILABILITY_MISSING);
    expect(snapshot.riskPolicy.revision.toString(), '2');
    expect(AccountSnapshot.fromBuffer(snapshot.writeToBuffer()), snapshot);
  });
}
