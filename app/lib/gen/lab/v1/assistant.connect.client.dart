//
//  Generated code. Do not modify.
//  source: lab/v1/assistant.proto
//

import "package:connectrpc/connect.dart" as connect;
import "assistant.pb.dart" as labv1assistant;
import "assistant.connect.spec.dart" as specs;

extension type AssistantServiceClient (connect.Transport _transport) {
  /// Explain a saved engine observation. This can spend assistant budget.
  Future<labv1assistant.ExplainOpportunityResponse> explainOpportunity(
    labv1assistant.ExplainOpportunityRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssistantService.explainOpportunity,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Review the out-of-sample evidence of one report or compare up to six reports.
  Future<labv1assistant.ReviewReportsResponse> reviewReports(
    labv1assistant.ReviewReportsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.AssistantService.reviewReports,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
