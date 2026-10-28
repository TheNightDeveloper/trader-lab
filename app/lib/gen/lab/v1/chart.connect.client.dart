//
//  Generated code. Do not modify.
//  source: lab/v1/chart.proto
//

import "package:connectrpc/connect.dart" as connect;
import "chart.pb.dart" as labv1chart;
import "chart.connect.spec.dart" as specs;

/// ChartService: bars, engine-computed indicators and decision markers. The app
/// draws these values; it never computes an indicator itself.
extension type ChartServiceClient (connect.Transport _transport) {
  Future<labv1chart.GetChartResponse> getChart(
    labv1chart.GetChartRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ChartService.getChart,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1chart.GetDecisionResponse> getDecision(
    labv1chart.GetDecisionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ChartService.getDecision,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
