//
//  Generated code. Do not modify.
//  source: lab/v1/pnl.proto
//

import "package:connectrpc/connect.dart" as connect;
import "pnl.pb.dart" as labv1pnl;
import "pnl.connect.spec.dart" as specs;

/// PnlService: what-if on a recorded run, and a single-trade calculator. Both use
/// the simulator math; the UI never computes P&L.
extension type PnlServiceClient (connect.Transport _transport) {
  Future<labv1pnl.RecalculateResponse> recalculate(
    labv1pnl.RecalculateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PnlService.recalculate,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1pnl.CalculateTradeResponse> calculateTrade(
    labv1pnl.CalculateTradeRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PnlService.calculateTrade,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
