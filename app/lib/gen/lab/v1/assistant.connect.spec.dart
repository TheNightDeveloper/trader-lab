//
//  Generated code. Do not modify.
//  source: lab/v1/assistant.proto
//

import "package:connectrpc/connect.dart" as connect;
import "assistant.pb.dart" as labv1assistant;

abstract final class AssistantService {
  /// Fully-qualified name of the AssistantService service.
  static const name = 'lab.v1.AssistantService';

  /// Explain a saved engine observation. This can spend assistant budget.
  static const explainOpportunity = connect.Spec(
    '/$name/ExplainOpportunity',
    connect.StreamType.unary,
    labv1assistant.ExplainOpportunityRequest.new,
    labv1assistant.ExplainOpportunityResponse.new,
  );

  /// Review the out-of-sample evidence of one report or compare up to six reports.
  static const reviewReports = connect.Spec(
    '/$name/ReviewReports',
    connect.StreamType.unary,
    labv1assistant.ReviewReportsRequest.new,
    labv1assistant.ReviewReportsResponse.new,
  );
}
