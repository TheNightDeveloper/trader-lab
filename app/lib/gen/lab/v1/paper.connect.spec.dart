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

  static const confirmPaperPlan = connect.Spec(
    '/$name/ConfirmPaperPlan',
    connect.StreamType.unary,
    labv1paper.ConfirmPaperPlanRequest.new,
    labv1paper.ConfirmPaperPlanResponse.new,
  );

  static const getPaperReceipt = connect.Spec(
    '/$name/GetPaperReceipt',
    connect.StreamType.unary,
    labv1paper.GetPaperReceiptRequest.new,
    labv1paper.GetPaperReceiptResponse.new,
  );

  static const listPaperJournal = connect.Spec(
    '/$name/ListPaperJournal',
    connect.StreamType.unary,
    labv1paper.ListPaperJournalRequest.new,
    labv1paper.ListPaperJournalResponse.new,
  );

  static const getPaperReplay = connect.Spec(
    '/$name/GetPaperReplay',
    connect.StreamType.unary,
    labv1paper.GetPaperReplayRequest.new,
    labv1paper.GetPaperReplayResponse.new,
  );

  static const savePaperJournalNote = connect.Spec(
    '/$name/SavePaperJournalNote',
    connect.StreamType.unary,
    labv1paper.SavePaperJournalNoteRequest.new,
    labv1paper.SavePaperJournalNoteResponse.new,
  );

  static const cancelPaperEntry = connect.Spec(
    '/$name/CancelPaperEntry',
    connect.StreamType.unary,
    labv1paper.CancelPaperEntryRequest.new,
    labv1paper.CancelPaperEntryResponse.new,
  );

  static const reducePaperPosition = connect.Spec(
    '/$name/ReducePaperPosition',
    connect.StreamType.unary,
    labv1paper.ReducePaperPositionRequest.new,
    labv1paper.ReducePaperPositionResponse.new,
  );

  static const setPaperEntryPause = connect.Spec(
    '/$name/SetPaperEntryPause',
    connect.StreamType.unary,
    labv1paper.SetPaperEntryPauseRequest.new,
    labv1paper.SetPaperEntryPauseResponse.new,
  );
}
