//
//  Generated code. Do not modify.
//  source: lab/v1/report.proto
//

import "package:connectrpc/connect.dart" as connect;
import "report.pb.dart" as labv1report;

/// ReportService: evaluate a configuration, read reports, compare, export.
abstract final class ReportService {
  /// Fully-qualified name of the ReportService service.
  static const name = 'lab.v1.ReportService';

  static const listStrategies = connect.Spec(
    '/$name/ListStrategies',
    connect.StreamType.unary,
    labv1report.ListStrategiesRequest.new,
    labv1report.ListStrategiesResponse.new,
  );

  /// Runs the walk-forward evaluation synchronously (M4 moves this to the queue).
  static const createReport = connect.Spec(
    '/$name/CreateReport',
    connect.StreamType.unary,
    labv1report.CreateReportRequest.new,
    labv1report.CreateReportResponse.new,
  );

  static const listReports = connect.Spec(
    '/$name/ListReports',
    connect.StreamType.unary,
    labv1report.ListReportsRequest.new,
    labv1report.ListReportsResponse.new,
  );

  static const getReport = connect.Spec(
    '/$name/GetReport',
    connect.StreamType.unary,
    labv1report.GetReportRequest.new,
    labv1report.GetReportResponse.new,
  );

  /// Reveals the final holdout. Every call is logged and counted.
  static const viewHoldout = connect.Spec(
    '/$name/ViewHoldout',
    connect.StreamType.unary,
    labv1report.ViewHoldoutRequest.new,
    labv1report.ViewHoldoutResponse.new,
  );

  static const listTrades = connect.Spec(
    '/$name/ListTrades',
    connect.StreamType.unary,
    labv1report.ListTradesRequest.new,
    labv1report.ListTradesResponse.new,
  );

  static const listDecisions = connect.Spec(
    '/$name/ListDecisions',
    connect.StreamType.unary,
    labv1report.ListDecisionsRequest.new,
    labv1report.ListDecisionsResponse.new,
  );

  static const compare = connect.Spec(
    '/$name/Compare',
    connect.StreamType.unary,
    labv1report.CompareRequest.new,
    labv1report.CompareResponse.new,
  );

  static const export = connect.Spec(
    '/$name/Export',
    connect.StreamType.unary,
    labv1report.ExportRequest.new,
    labv1report.ExportResponse.new,
  );

  /// Re-evaluates from the stored inputs and checks every number is identical.
  static const reproduce = connect.Spec(
    '/$name/Reproduce',
    connect.StreamType.unary,
    labv1report.ReproduceRequest.new,
    labv1report.ReproduceResponse.new,
  );
}
