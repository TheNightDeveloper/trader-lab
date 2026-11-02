import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/features/data/data_providers.dart';
import 'package:trading_lab/gen/lab/v1/data.pb.dart';

import 'fake_transport.dart';

void main() {
  test('execution pickers require explicit permission and preserve the data catalog', () async {
    var approved = true;
    final transport = FakeTransport({
      'GetOverview': (_) => GetOverviewResponse(
        researchCapabilities: [
          ResearchCapability(symbol: 'BTCUSDT', supported: approved),
          ResearchCapability(symbol: 'ETHBTC', reason: 'unsupported'),
        ],
      ),
      'ListDatasets': (_) => ListDatasetsResponse(
        total: Int64(3),
        datasets: [
          Dataset(id: 'allowed', symbol: 'BTCUSDT'),
          Dataset(id: 'cross', symbol: 'ETHBTC'),
          Dataset(id: 'unknown', symbol: 'UNKNOWNUSDT'),
        ],
      ),
    });
    final c = ProviderContainer(overrides: [transportProvider.overrideWithValue(transport)]);
    addTearDown(c.dispose);
    expect((await c.read(researchDatasetsProvider.future)).datasets.map((d) => d.id), ['allowed']);
    expect((await c.read(allDatasetsProvider.future)).datasets.length, 3);
    approved = false;
    c.invalidate(overviewProvider);
    expect((await c.read(researchDatasetsProvider.future)).datasets, isEmpty);
  });

  test('an older server without capabilities grants no execution permission', () async {
    final transport = FakeTransport({
      'GetOverview': (_) => GetOverviewResponse(symbols: ['BTCUSDT']),
      'ListDatasets': (_) => ListDatasetsResponse(
        total: Int64(1),
        datasets: [Dataset(id: 'a', symbol: 'BTCUSDT')],
      ),
    });
    final c = ProviderContainer(overrides: [transportProvider.overrideWithValue(transport)]);
    addTearDown(c.dispose);
    expect((await c.read(researchDatasetsProvider.future)).datasets, isEmpty);
  });

  test('capability transport errors cannot produce an allowed picker', () async {
    final c = ProviderContainer(
      overrides: [
        transportProvider.overrideWithValue(
          FakeTransport({
            'GetOverview': (_) => throw StateError('offline'),
            'ListDatasets': (_) => ListDatasetsResponse(),
          }),
        ),
      ],
    );
    addTearDown(c.dispose);
    await expectLater(c.read(researchDatasetsProvider.future), throwsA(isA<StateError>()));
  });

  test('capability wire fields round trip in the Dart client', () {
    final response = researchOverview();
    final back = GetOverviewResponse.fromBuffer(response.writeToBuffer());
    expect(
      back.researchCapabilities.map((c) => (c.symbol, c.supported, c.reason)),
      response.researchCapabilities.map((c) => (c.symbol, c.supported, c.reason)),
    );
  });

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
