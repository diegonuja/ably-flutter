import 'test_implementation/basic_platform_tests.dart';
import 'test_implementation/helper_tests.dart';
import 'test_implementation/realtime_tests.dart';
import 'test_implementation/rest_tests.dart';

enum TestGroup{
  BasicTests,
  HelperTests,
  Rest,
  Realtime
}

final _tests = <TestGroup, Map<String, Function>>{
  TestGroup.BasicTests: {
    'should return Platform and Ably version': testPlatformAndAblyVersion,
    'should provision AppKey': testAppKeyProvisioning,
  },
  TestGroup.Rest: {
    'should publish': testRestPublish,
  },
  TestGroup.Realtime: {
    'should publish': testRealtimePublish,
    'should subscribe to connection and channel': testRealtimeEvents,
    'should subscribe to messages': testRealtimeSubscribe,
  },
  // FlutterError seems to break the test app and needs to be run last
  TestGroup.HelperTests: {
    'should report unhandled exception': testShouldReportUnhandledException,
    'should report FlutterError': testShouldReportFlutterError,
  }
};

Map<TestGroup, Map<String, Function>> getTestsFor({
  bool all = false,
  TestGroup group,
  List<TestGroup> groups,
}) {
  assert(group != null || groups != null || all != false);
  if (all) {
    groups = _tests.keys.toList();
  } else if (group != null) {
    groups = [group];
  }
  return Map.from(_tests)..removeWhere((key, value) => !groups.contains(key));
}
