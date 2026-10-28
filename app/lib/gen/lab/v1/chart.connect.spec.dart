//
//  Generated code. Do not modify.
//  source: lab/v1/chart.proto
//

import "package:connectrpc/connect.dart" as connect;
import "chart.pb.dart" as labv1chart;

/// ChartService: bars, engine-computed indicators and decision markers. The app
/// draws these values; it never computes an indicator itself.
abstract final class ChartService {
  /// Fully-qualified name of the ChartService service.
  static const name = 'lab.v1.ChartService';

  static const getChart = connect.Spec(
    '/$name/GetChart',
    connect.StreamType.unary,
    labv1chart.GetChartRequest.new,
    labv1chart.GetChartResponse.new,
  );

  static const getDecision = connect.Spec(
    '/$name/GetDecision',
    connect.StreamType.unary,
    labv1chart.GetDecisionRequest.new,
    labv1chart.GetDecisionResponse.new,
  );
}
