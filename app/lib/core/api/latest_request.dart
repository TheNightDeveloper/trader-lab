import 'package:connectrpc/connect.dart';

/// A request keeps its own generation and cancellation signal across awaits.
typedef RequestTicket = ({int generation, CancelableSignal signal});

/// Only the latest input may publish results, even when cancellation races a reply.
class LatestRequest {
  int _generation = 0;
  CancelableSignal? _signal;
  bool _disposed = false;

  RequestTicket begin() {
    if (_disposed) throw StateError('Request owner is disposed');
    invalidate();
    final signal = CancelableSignal();
    _signal = signal;
    return (generation: _generation, signal: signal);
  }

  bool isCurrent(RequestTicket ticket) => !_disposed && ticket.generation == _generation;

  /// Invalidate on edit, before the debounce timer starts the next request.
  void invalidate() {
    _generation++;
    _signal?.cancel();
    _signal = null;
  }

  void dispose() {
    _disposed = true;
    invalidate();
  }
}
