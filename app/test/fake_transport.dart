import 'package:connectrpc/connect.dart' as connect;
import 'package:flutter_test/flutter_test.dart';

/// Answers RPCs by method name and records every request, so screens run on
/// their real providers and clients.
class FakeTransport implements connect.Transport {
  FakeTransport(this.unaries, {this.streams = const {}});
  final Map<String, Object Function(Object)> unaries;
  final Map<String, Stream<Object> Function(Object)> streams;
  final calls = <String, List<Object>>{};

  String _name(connect.Spec spec) => spec.procedure.split('/').last;

  @override
  Future<connect.UnaryResponse<I, O>> unary<I extends Object, O extends Object>(
    connect.Spec<I, O> spec,
    I input, [
    connect.CallOptions? options,
  ]) async {
    final n = _name(spec);
    (calls[n] ??= []).add(input);
    final h = unaries[n];
    return connect.UnaryResponse(
      spec,
      connect.Headers(),
      h == null ? spec.outputFactory() : h(input) as O,
      connect.Headers(),
    );
  }

  @override
  Future<connect.StreamResponse<I, O>> stream<I extends Object, O extends Object>(
    connect.Spec<I, O> spec,
    Stream<I> input, [
    connect.CallOptions? options,
  ]) async {
    final n = _name(spec);
    final req = await input.first;
    (calls[n] ??= []).add(req);
    final h = streams[n];
    return connect.StreamResponse(spec, connect.Headers(), h == null ? Stream<O>.empty() : h(req).cast<O>(), connect.Headers());
  }
}

Future<void> settle(WidgetTester t, [int frames = 20]) async {
  for (var i = 0; i < frames; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
}
