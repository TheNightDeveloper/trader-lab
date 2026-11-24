//
//  Generated code. Do not modify.
//  source: lab/v1/market.proto
//

import "package:connectrpc/connect.dart" as connect;
import "market.pb.dart" as labv1market;

abstract final class MarketService {
  /// Fully-qualified name of the MarketService service.
  static const name = 'lab.v1.MarketService';

  /// Returns the configured spot USDT watchlist and its latest known observations.
  static const getMarketSnapshot = connect.Spec(
    '/$name/GetMarketSnapshot',
    connect.StreamType.unary,
    labv1market.GetMarketSnapshotRequest.new,
    labv1market.GetMarketSnapshotResponse.new,
  );
}
