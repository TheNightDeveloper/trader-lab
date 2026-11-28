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
}
