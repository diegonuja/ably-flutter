import 'package:ably_flutter/ably_flutter.dart';

import '../test_dispatcher.dart';
import 'app_key_provision_helper.dart';
import 'encoders.dart';
import 'realtime_publish_test.dart';
import 'test_widget_abstract.dart';

class RealtimeSubscribeTest extends TestWidget {
  const RealtimeSubscribeTest(TestDispatcherState dispatcher)
      : super(dispatcher);

  @override
  TestWidgetState<TestWidget> createState() => RealtimeSubscribeTestState();
}

class RealtimeSubscribeTestState
    extends TestWidgetState<RealtimeSubscribeTest> {

  @override
  Future<void> test() async {
    final appKey = await provision('sandbox-');

    widget.dispatcher.reportTestCompletion(<String, dynamic>{
      'all': await getAllMessages(appKey.toString(), 'test-all'),
      'filteredWithName':
          await getAllMessages(appKey.toString(), 'test-name', name: 'name1'),
      'filteredWithNames': await getAllMessages(appKey.toString(), 'test-name',
          names: ['name1', 'name2']),
    });
  }

  Future<List<Map<String, dynamic>>> getAllMessages(
    String apiKey,
    String channelName, {
    String name,
    List<String> names,
  }) async {
    final messages = <Map<String, dynamic>>[];

    final realtime = Realtime(
      options: ClientOptions.fromKey(apiKey)
        ..environment = 'sandbox'
        ..clientId = 'someClientId'
        ..autoConnect = false,
    );
    await realtime.connect();

    final channel = realtime.channels.get(channelName);
    await channel.attach();
    final subscription =
        channel.subscribe(name: name, names: names).listen((message) {
      messages.add(encodeMessage(message));
    });
    await realtimeMessagesPublishUtil(channel);
    await subscription.cancel();
    return messages;
  }

}