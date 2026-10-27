//
//  Generated code. Do not modify.
//  source: lab/v1/data.proto
//

import "package:connectrpc/connect.dart" as connect;
import "data.pb.dart" as labv1data;

/// DataService: datasets, coverage, quality issues, live feed, archive import.
abstract final class DataService {
  /// Fully-qualified name of the DataService service.
  static const name = 'lab.v1.DataService';

  static const getOverview = connect.Spec(
    '/$name/GetOverview',
    connect.StreamType.unary,
    labv1data.GetOverviewRequest.new,
    labv1data.GetOverviewResponse.new,
  );

  static const listDatasets = connect.Spec(
    '/$name/ListDatasets',
    connect.StreamType.unary,
    labv1data.ListDatasetsRequest.new,
    labv1data.ListDatasetsResponse.new,
  );

  static const getCoverage = connect.Spec(
    '/$name/GetCoverage',
    connect.StreamType.unary,
    labv1data.GetCoverageRequest.new,
    labv1data.GetCoverageResponse.new,
  );

  static const listQualityIssues = connect.Spec(
    '/$name/ListQualityIssues',
    connect.StreamType.unary,
    labv1data.ListQualityIssuesRequest.new,
    labv1data.ListQualityIssuesResponse.new,
  );

  /// Imports archive files for each symbol, then creates one dataset version per
  /// symbol. Streams progress; the stream ends after the last dataset.
  static const import = connect.Spec(
    '/$name/Import',
    connect.StreamType.server,
    labv1data.ImportRequest.new,
    labv1data.ImportResponse.new,
  );
}
