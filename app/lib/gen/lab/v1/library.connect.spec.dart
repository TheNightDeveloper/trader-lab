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

  static const listRuleVersions = connect.Spec(
    '/$name/ListRuleVersions',
    connect.StreamType.unary,
    labv1library.ListRuleVersionsRequest.new,
    labv1library.ListRuleVersionsResponse.new,
  );

  static const getRuleVersion = connect.Spec(
    '/$name/GetRuleVersion',
    connect.StreamType.unary,
    labv1library.GetRuleVersionRequest.new,
    labv1library.GetRuleVersionResponse.new,
  );

  static const saveRuleVersion = connect.Spec(
    '/$name/SaveRuleVersion',
    connect.StreamType.unary,
    labv1library.SaveRuleVersionRequest.new,
    labv1library.SaveRuleVersionResponse.new,
  );

  static const composeRuleVersions = connect.Spec(
    '/$name/ComposeRuleVersions',
    connect.StreamType.unary,
    labv1library.ComposeRuleVersionsRequest.new,
    labv1library.ComposeRuleVersionsResponse.new,
  );

  static const listRuleTemplates = connect.Spec(
    '/$name/ListRuleTemplates',
    connect.StreamType.unary,
    labv1library.ListRuleTemplatesRequest.new,
    labv1library.ListRuleTemplatesResponse.new,
  );
}
