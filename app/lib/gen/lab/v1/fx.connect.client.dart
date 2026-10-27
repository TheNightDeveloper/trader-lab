//
//  Generated code. Do not modify.
//  source: lab/v1/fx.proto
//

import "package:connectrpc/connect.dart" as connect;
import "fx.pb.dart" as labv1fx;
import "fx.connect.spec.dart" as specs;

/// FxService: USDT/TOMAN display rates. Append-only; display and export only.
extension type FxServiceClient(connect.Transport _transport) {
  Future<labv1fx.ListRatesResponse> listRates(
    labv1fx.ListRatesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FxService.listRates,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1fx.AddRateResponse> addRate(
    labv1fx.AddRateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(
      _transport,
    ).unary(specs.FxService.addRate, input, signal: signal, headers: headers, onHeader: onHeader, onTrailer: onTrailer);
  }
}
