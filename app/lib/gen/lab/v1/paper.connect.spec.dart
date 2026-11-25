//
//  Generated code. Do not modify.
//  source: lab/v1/paper.proto
//

import "package:connectrpc/connect.dart" as connect;
import "paper.pb.dart" as labv1paper;

/// PaperService only operates on local, simulated spot accounts.
abstract final class PaperService {
  /// Fully-qualified name of the PaperService service.
  static const name = 'lab.v1.PaperService';

  static const getPaperAccount = connect.Spec(
    '/$name/GetPaperAccount',
    connect.StreamType.unary,
    labv1paper.GetPaperAccountRequest.new,
    labv1paper.GetPaperAccountResponse.new,
  );

  static const initializePaperAccount = connect.Spec(
    '/$name/InitializePaperAccount',
    connect.StreamType.unary,
    labv1paper.InitializePaperAccountRequest.new,
    labv1paper.InitializePaperAccountResponse.new,
  );

  static const previewPaperPlan = connect.Spec(
    '/$name/PreviewPaperPlan',
    connect.StreamType.unary,
    labv1paper.PreviewPaperPlanRequest.new,
    labv1paper.PreviewPaperPlanResponse.new,
  );

  static const getPaperPlan = connect.Spec(
    '/$name/GetPaperPlan',
    connect.StreamType.unary,
    labv1paper.GetPaperPlanRequest.new,
    labv1paper.GetPaperPlanResponse.new,
  );
}
