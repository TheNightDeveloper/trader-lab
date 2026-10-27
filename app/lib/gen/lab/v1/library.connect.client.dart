//
//  Generated code. Do not modify.
//  source: lab/v1/library.proto
//

import "package:connectrpc/connect.dart" as connect;
import "library.pb.dart" as labv1library;
import "library.connect.spec.dart" as specs;

/// LibraryService: algorithms, their versions and lifecycle. Only a user action
/// moves a version to active.
extension type LibraryServiceClient (connect.Transport _transport) {
  Future<labv1library.ListAlgorithmsResponse> listAlgorithms(
    labv1library.ListAlgorithmsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LibraryService.listAlgorithms,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1library.SetVersionStateResponse> setVersionState(
    labv1library.SetVersionStateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LibraryService.setVersionState,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<labv1library.ListLifecycleEventsResponse> listLifecycleEvents(
    labv1library.ListLifecycleEventsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.LibraryService.listLifecycleEvents,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
