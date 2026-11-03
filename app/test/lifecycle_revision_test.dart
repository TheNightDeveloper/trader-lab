import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading_lab/gen/lab/v1/library.pb.dart';
import 'package:trading_lab/gen/lab/v1/learning.pb.dart';

void main() {
  test('zero revision retains presence on every lifecycle mutation', () {
    final move = SetVersionStateRequest(expectedRevision: Int64.ZERO);
    final approve = ApproveCycleRequest(expectedRevision: Int64.ZERO);
    final rollback = RollbackRequest(expectedRevision: Int64.ZERO);
    expect(SetVersionStateRequest().hasExpectedRevision(), isFalse);
    expect(ApproveCycleRequest().hasExpectedRevision(), isFalse);
    expect(RollbackRequest().hasExpectedRevision(), isFalse);
    expect(
      SetVersionStateRequest.fromBuffer(move.writeToBuffer())
          .hasExpectedRevision(),
      isTrue,
    );
    expect(
      ApproveCycleRequest.fromBuffer(approve.writeToBuffer())
          .hasExpectedRevision(),
      isTrue,
    );
    expect(
      RollbackRequest.fromBuffer(rollback.writeToBuffer())
          .hasExpectedRevision(),
      isTrue,
    );
  });

  test('revision beyond JavaScript integer precision stays exact', () {
    // Revision is an opaque server token, never converted through a Dart web int/double.
    final revision = Int64.parseInt('9007199254740993');
    final algorithm = Algorithm(lifecycleRevision: revision);
    final active = ActiveModel(lifecycleRevision: revision);
    expect(
      Algorithm.fromBuffer(algorithm.writeToBuffer()).lifecycleRevision,
      revision,
    );
    expect(
      ActiveModel.fromBuffer(active.writeToBuffer()).lifecycleRevision,
      revision,
    );
    final request = ApproveCycleRequest(
      expectedRevision: active.lifecycleRevision,
    );
    expect(
      ApproveCycleRequest.fromJson(request.writeToJson()).expectedRevision,
      revision,
    );
  });
}
