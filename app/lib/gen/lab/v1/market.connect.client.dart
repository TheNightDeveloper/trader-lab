//
//  Generated code. Do not modify.
//  source: lab/v1/market.proto
//

import "package:connectrpc/connect.dart" as connect;
import "market.pb.dart" as labv1market;
import "market.connect.spec.dart" as specs;

extension type MarketServiceClient (connect.Transport _transport) {
  /// Returns the configured spot USDT watchlist and its latest known observations.
  Future<labv1market.GetMarketSnapshotResponse> getMarketSnapshot(
    labv1market.GetMarketSnapshotRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MarketService.getMarketSnapshot,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Observes a tested rule on the latest complete 1h candle and records a match.
  Future<labv1market.ScanMarketOpportunityResponse> scanMarketOpportunity(
    labv1market.ScanMarketOpportunityRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MarketService.scanMarketOpportunity,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Enables an hourly scan for a tested version or pauses that exact subscription.
  Future<labv1market.SetMarketScanSubscriptionResponse> setMarketScanSubscription(
    labv1market.SetMarketScanSubscriptionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MarketService.setMarketScanSubscription,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
