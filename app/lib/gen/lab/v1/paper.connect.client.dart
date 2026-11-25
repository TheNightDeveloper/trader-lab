//
//  Generated code. Do not modify.
//  source: lab/v1/paper.proto
//

import "package:connectrpc/connect.dart" as connect;
import "paper.pb.dart" as labv1paper;
import "paper.connect.spec.dart" as specs;

/// PaperService only operates on local, simulated spot accounts.
extension type PaperServiceClient (connect.Transport _transport) {
  Future<labv1paper.GetPaperAccountResponse> getPaperAccount(
    labv1paper.GetPaperAccountRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PaperService.getPaperAccount,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1paper.InitializePaperAccountResponse> initializePaperAccount(
    labv1paper.InitializePaperAccountRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PaperService.initializePaperAccount,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1paper.PreviewPaperPlanResponse> previewPaperPlan(
    labv1paper.PreviewPaperPlanRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PaperService.previewPaperPlan,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1paper.GetPaperPlanResponse> getPaperPlan(
    labv1paper.GetPaperPlanRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PaperService.getPaperPlan,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
