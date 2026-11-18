import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/core/api/engine.dart';
import 'package:trading_lab/features/data/data_providers.dart';
import 'package:trading_lab/gen/lab/v1/data.pb.dart';

import 'fake_transport.dart';

const _firstPage = (query: '', timeframe: '', offset: 0);

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
    expect((await c.read(researchDatasetPageProvider(_firstPage).future)).datasets.map((d) => d.id), ['allowed']);
    expect((await c.read(datasetsProvider(0).future)).datasets.length, 3);
    approved = false;
    c.invalidate(overviewProvider);
    expect((await c.read(researchDatasetPageProvider(_firstPage).future)).datasets, isEmpty);
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
    expect((await c.read(researchDatasetPageProvider(_firstPage).future)).datasets, isEmpty);
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
    await expectLater(c.read(researchDatasetPageProvider(_firstPage).future), throwsA(isA<StateError>()));
  });

  test('capability wire fields round trip in the Dart client', () {
    final response = researchOverview();
    final back = GetOverviewResponse.fromBuffer(response.writeToBuffer());
    expect(
      back.researchCapabilities.map((c) => (c.symbol, c.supported, c.reason)),
      response.researchCapabilities.map((c) => (c.symbol, c.supported, c.reason)),
    );
  });

  test('pickers fetch one filtered page and imports invalidate pages and draft lookups', () async {
    var imported = false;
    final transport = FakeTransport(
      {
        'GetOverview': (_) => researchOverview(),
        'ListDatasets': (input) {
          final q = input as ListDatasetsRequest;
          final count = imported ? 202 : 201;
          final catalog = List.generate(count, (i) => Dataset(id: 'ds-$i', symbol: 'BTCUSDT', timeframe: '1h'));
          final matching = catalog.where((d) => q.ids.isEmpty || q.ids.contains(d.id)).toList();
          return ListDatasetsResponse(
            total: Int64(matching.length),
            datasets: matching.skip(q.offset).take(q.pageSize),
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
    final page = researchDatasetPageProvider((query: 'BTCUSDT', timeframe: '1h', offset: 200));
    final selection = researchDatasetByIdProvider('ds-201');
    final pageListener = container.listen(page, (_, _) {});
    addTearDown(pageListener.close);
    final first = await container.read(page.future);
    expect(first.datasets.single.id, 'ds-200');
    final request = transport.calls['ListDatasets']!.single as ListDatasetsRequest;
    expect(
      (request.offset, request.pageSize, request.query, request.timeframe, request.researchOnly),
      (200, pageSize, 'BTCUSDT', '1h', true),
    );
    final selectionListener = container.listen(selection, (_, _) {});
    addTearDown(selectionListener.close);
    expect(await container.read(selection.future), isNull);
    await container.read(importProvider.notifier).run(ImportRequest());
    final refreshed = await container.read(page.future);
    expect(refreshed.total.toInt(), 202);
    expect(refreshed.datasets.last.id, 'ds-201');
    expect((await container.read(selection.future))?.id, 'ds-201');
  });
}
