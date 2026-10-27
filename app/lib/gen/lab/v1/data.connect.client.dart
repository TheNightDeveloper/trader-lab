//
//  Generated code. Do not modify.
//  source: lab/v1/data.proto
//

import "package:connectrpc/connect.dart" as connect;
import "data.pb.dart" as labv1data;
import "data.connect.spec.dart" as specs;

/// DataService: datasets, coverage, quality issues, live feed, archive import.
extension type DataServiceClient (connect.Transport _transport) {
  Future<labv1data.GetOverviewResponse> getOverview(
    labv1data.GetOverviewRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DataService.getOverview,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1data.ListDatasetsResponse> listDatasets(
    labv1data.ListDatasetsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DataService.listDatasets,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1data.GetCoverageResponse> getCoverage(
    labv1data.GetCoverageRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DataService.getCoverage,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1data.ListQualityIssuesResponse> listQualityIssues(
    labv1data.ListQualityIssuesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DataService.listQualityIssues,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Imports archive files for each symbol, then creates one dataset version per
  /// symbol. Streams progress; the stream ends after the last dataset.
  Stream<labv1data.ImportResponse> import(
    labv1data.ImportRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.DataService.import,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
