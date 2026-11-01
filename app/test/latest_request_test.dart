import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/core/api/latest_request.dart';

void main() {
  test('old success cannot publish over newer input', () async {
    final requests = LatestRequest();
    addTearDown(requests.dispose);
    final oldReply = Completer<int>();
    int? displayed;
    final old = requests.begin();
    final pending = oldReply.future.then((value) {
      if (requests.isCurrent(old)) displayed = value;
    });
    final current = requests.begin();
    if (requests.isCurrent(current)) displayed = 2;
    oldReply.complete(1);
    await pending;
    expect(displayed, 2);
    expect(await old.signal.future, isNotNull);
  });

  test('edit invalidates before debounce and dispose cancels the active call', () async {
    final requests = LatestRequest();
    final first = requests.begin();
    requests.invalidate();
    expect(requests.isCurrent(first), isFalse);
    final last = requests.begin();
    requests.dispose();
    expect(requests.isCurrent(last), isFalse);
    expect(await last.signal.future, isNotNull);
    expect(requests.begin, throwsStateError);
  });
}
