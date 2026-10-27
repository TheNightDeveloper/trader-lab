//
//  Generated code. Do not modify.
//  source: lab/v1/fx.proto
//

import "package:connectrpc/connect.dart" as connect;
import "fx.pb.dart" as labv1fx;

/// FxService: USDT/TOMAN display rates. Append-only; display and export only.
abstract final class FxService {
  /// Fully-qualified name of the FxService service.
  static const name = 'lab.v1.FxService';

  static const listRates = connect.Spec(
    '/$name/ListRates',
    connect.StreamType.unary,
    labv1fx.ListRatesRequest.new,
    labv1fx.ListRatesResponse.new,
  );

  static const addRate = connect.Spec(
    '/$name/AddRate',
    connect.StreamType.unary,
    labv1fx.AddRateRequest.new,
    labv1fx.AddRateResponse.new,
  );
}
