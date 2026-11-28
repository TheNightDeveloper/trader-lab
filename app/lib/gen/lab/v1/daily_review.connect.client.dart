//
//  Generated code. Do not modify.
//  source: lab/v1/daily_review.proto
//

import "package:connectrpc/connect.dart" as connect;
import "daily_review.pb.dart" as labv1daily_review;
import "daily_review.connect.spec.dart" as specs;

extension type DailyReviewServiceClient (connect.Transport _transport) {
  Future<labv1daily_review.GetDailyReviewResponse> getDailyReview(
    labv1daily_review.GetDailyReviewRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DailyReviewService.getDailyReview,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1daily_review.GetDailyReviewStatusResponse> getDailyReviewStatus(
    labv1daily_review.GetDailyReviewStatusRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DailyReviewService.getDailyReviewStatus,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1daily_review.SetDailyReviewReminderResponse> setDailyReviewReminder(
    labv1daily_review.SetDailyReviewReminderRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DailyReviewService.setDailyReviewReminder,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1daily_review.MarkDailyReviewReadResponse> markDailyReviewRead(
    labv1daily_review.MarkDailyReviewReadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DailyReviewService.markDailyReviewRead,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
