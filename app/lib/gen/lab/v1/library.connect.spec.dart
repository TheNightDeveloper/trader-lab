//
//  Generated code. Do not modify.
//  source: lab/v1/library.proto
//

import "package:connectrpc/connect.dart" as connect;
import "library.pb.dart" as labv1library;

/// LibraryService: algorithms, their versions and lifecycle. Only a user action
/// moves a version to active.
abstract final class LibraryService {
  /// Fully-qualified name of the LibraryService service.
  static const name = 'lab.v1.LibraryService';

  static const listAlgorithms = connect.Spec(
    '/$name/ListAlgorithms',
    connect.StreamType.unary,
    labv1library.ListAlgorithmsRequest.new,
    labv1library.ListAlgorithmsResponse.new,
  );

  static const setVersionState = connect.Spec(
    '/$name/SetVersionState',
    connect.StreamType.unary,
    labv1library.SetVersionStateRequest.new,
    labv1library.SetVersionStateResponse.new,
  );

  static const listLifecycleEvents = connect.Spec(
    '/$name/ListLifecycleEvents',
    connect.StreamType.unary,
    labv1library.ListLifecycleEventsRequest.new,
    labv1library.ListLifecycleEventsResponse.new,
  );
}
