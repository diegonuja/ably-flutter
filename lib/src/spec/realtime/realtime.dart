import '../connection.dart';
import '../rest/ably_base.dart';
import '../rest/options.dart';
import 'channels.dart';

/// an abstract class for Ably's Realtime client
///
/// https://docs.ably.io/client-lib-development-guide/features/#RTC1
abstract class RealtimeInterface<C extends RealtimeChannels> extends AblyBase {
  /// https://docs.ably.io/client-lib-development-guide/features/#RTC1
  RealtimeInterface({
    ClientOptions options,
    final String key,
  }) : super(
          options: options,
          key: key,
        );

  /// closes the [connection]
  void close();

  /// connects to [connection]
  void connect();

  /// Provides access to the underlying Connection object
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#RTC2
  ConnectionInterface get connection;

  /// collection of [RealtimeChannelInterface] objects
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#RTC3
  C get channels;
}
