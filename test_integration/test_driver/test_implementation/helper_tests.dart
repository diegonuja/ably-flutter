import 'package:ably_flutter_integration_test/driver_data_handler.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future testShouldReportUnhandledException(FlutterDriver driver) async {
  const message = TestControlMessage(TestName.testHelperUnhandledExceptionTest);

  final response = await getTestResponse(driver, message);

  expect(response.testName, message.testName);

  expect(response.payload['error']['exceptionType'], 'String');
  expect(response.payload['error']['exception'], contains('Unhandled'));
}
