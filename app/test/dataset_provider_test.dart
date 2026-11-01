import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/features/data/data_providers.dart';
import 'package:trading_lab/gen/lab/v1/data.pb.dart';

import 'fake_transport.dart';

void main() {
  test('pickers include dataset 201 and imports invalidate the shared cache', () async {
    var imported = false;
    final transport = FakeTransport(
      {
        'ListDatasets': (input) {
          final q = input as ListDatasetsRequest;
          final count = imported ? 202 : 201;
          return ListDatasetsResponse(
            total: Int64(count),
            datasets: List.generate(count, (i) => Dataset(id: 'ds-$i')).skip(q.offset).take(q.pageSize),
          );
        },
      },
      streams: {
        'Import': (_) async* {
          imported = true;
          yield ImportResponse(dataset: Dataset(id: 'ds-201'));
        },
      },
    );
    final container = ProviderContainer(overrides: [transportProvider.overrideWithValue(transport)]);
    addTearDown(container.dispose);
    final first = await container.read(allDatasetsProvider.future);
    expect(first.datasets.last.id, 'ds-200');
    expect((transport.calls['ListDatasets']!.last as ListDatasetsRequest).offset, 200);
    await container.read(importProvider.notifier).run(ImportRequest());
    final refreshed = await container.read(allDatasetsProvider.future);
    expect(refreshed.datasets.length, 202);
    expect(refreshed.datasets.last.id, 'ds-201');
  });
}
