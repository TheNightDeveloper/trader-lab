//
//  Generated code. Do not modify.
//  source: lab/v1/pnl.proto
//

import "package:connectrpc/connect.dart" as connect;
import "pnl.pb.dart" as labv1pnl;

/// PnlService: what-if on a recorded run, and a single-trade calculator. Both use
/// the simulator math; the UI never computes P&L.
abstract final class PnlService {
  /// Fully-qualified name of the PnlService service.
  static const name = 'lab.v1.PnlService';

  static const recalculate = connect.Spec(
    '/$name/Recalculate',
    connect.StreamType.unary,
    labv1pnl.RecalculateRequest.new,
    labv1pnl.RecalculateResponse.new,
  );

  static const calculateTrade = connect.Spec(
    '/$name/CalculateTrade',
    connect.StreamType.unary,
    labv1pnl.CalculateTradeRequest.new,
    labv1pnl.CalculateTradeResponse.new,
  );
}
