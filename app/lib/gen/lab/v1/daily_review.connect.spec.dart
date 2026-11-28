//
//  Generated code. Do not modify.
//  source: lab/v1/daily_review.proto
//

import "package:connectrpc/connect.dart" as connect;
import "daily_review.pb.dart" as labv1daily_review;

abstract final class DailyReviewService {
  /// Fully-qualified name of the DailyReviewService service.
  static const name = 'lab.v1.DailyReviewService';

  static const getDailyReview = connect.Spec(
    '/$name/GetDailyReview',
    connect.StreamType.unary,
    labv1daily_review.GetDailyReviewRequest.new,
    labv1daily_review.GetDailyReviewResponse.new,
  );

  static const getDailyReviewStatus = connect.Spec(
    '/$name/GetDailyReviewStatus',
    connect.StreamType.unary,
    labv1daily_review.GetDailyReviewStatusRequest.new,
    labv1daily_review.GetDailyReviewStatusResponse.new,
  );

  static const setDailyReviewReminder = connect.Spec(
    '/$name/SetDailyReviewReminder',
    connect.StreamType.unary,
    labv1daily_review.SetDailyReviewReminderRequest.new,
    labv1daily_review.SetDailyReviewReminderResponse.new,
  );

  static const markDailyReviewRead = connect.Spec(
    '/$name/MarkDailyReviewRead',
    connect.StreamType.unary,
    labv1daily_review.MarkDailyReviewReadRequest.new,
    labv1daily_review.MarkDailyReviewReadResponse.new,
  );
}
