import 'enums.dart';

//==============================================================================
//==========================    ABSTRACT CLASSES    ============================
//==============================================================================
abstract class CipherParams {
  String algorithm;
  dynamic key;
  int keyLength;
  String mode;
}

abstract class ErrorInfo {
  int code;
  String message;
  int statusCode;
}

abstract class StatsMessageCount {
  int count;
  int data;
}

abstract class StatsMessageTypes {
  StatsMessageCount all;
  StatsMessageCount messages;
  StatsMessageCount presence;
}

abstract class StatsRequestCount {
  int failed;
  int refused;
  int succeeded;
}

abstract class StatsResourceCount {
  int mean;
  int min;
  int opened;
  int peak;
  int refused;
}

abstract class StatsConnectionTypes {
  StatsResourceCount all;
  StatsResourceCount plain;
  StatsResourceCount tls;
}

abstract class StatsMessageTraffic {
  StatsMessageTypes all;
  StatsMessageTypes realtime;
  StatsMessageTypes rest;
  StatsMessageTypes webhook;
}

abstract class TokenParams {
  String  capability;
  String clientId;
  String nonce;
  int timestamp;
  int ttl;
}

class TokenDetails {
  TokenDetails(this.token);
  String capability;
  String clientId;
  int expires;
  int issued;
  String token;
}

abstract class TokenRequest {
  String capability;
  String clientId;
  String keyName;
  String mac;
  String nonce;
  int timestamp;
  int ttl;
}


abstract class RestHistoryParams {
  int start;
  int end;
  String direction;
  int limit;
}

abstract class RestPresenceParams {
  int limit;
  String clientId;
  String connectionId;
}

abstract class RealtimePresenceParams {
  bool waitForSync; //waitForSync;	//?: bool;
  String clientId; //clientId;	//?: String;
  String connectionId; //;	//?: String;
}

abstract class RealtimeHistoryParams {
  int start; //  start;	//?: int;
  int end; //  end;	//?: int;
  int direction; //  direction;	//?: String;
  int limit; //  limit;	//?: int;
  bool untilAttach; //  untilAttach;	//?: bool;
}


/// An exception generated by the client library SDK called by this plugin.
class AblyException implements Exception {

  final String code;
  final dynamic message;

  AblyException([this.code, this.message]);

  String toString() {
    if (message == null) return "AblyException";
    return "AblyException: $message (${(code==null)?"":'$code '})";
  }

}

typedef void LogHandler({String msg, AblyException exception});
class LogInfo{

  LogInfo({
    this.level = LogLevel.info,
    LogHandler handler
  });

  ///A int controlling the verbosity of the output.
  ///Valid values are: 0 (no logs), 1 (errors only),
  ///2 (errors plus connection and channel state changes), 3 (high-level debug output), and 4 (full debug output).
  LogLevel level;  //level?: int;

  /// A function to handle each line of log output.
  /// If handler is not specified, console.log is used.
  LogHandler handler;

  void log({String msg, AblyException exception}){
    if(handler==null){
      print(exception??msg);
    }else{
      handler(msg: msg, exception: exception);
    }
  }
}

/// Java: io.ably.lib.types.ProxyOptions
class ProxyOptions {
  String host;
  int port;
  String username;
  String password;
  List<String> nonProxyHosts;
  HttpAuthType prefAuthType;
}

abstract class ChannelStateChange {
  ChannelState current;
  ChannelState previous;
  ErrorInfo reason; //optional
  bool resumed;
}

abstract class ConnectionStateChange {
  ConnectionState current;
  ConnectionState previous;
  ErrorInfo reason; //optional
  int retryIn;      //optional
}

abstract class DevicePushDetails {
  dynamic recipient;
  DevicePushState state;  //optional
  ErrorInfo errorReason;  //optional
}

abstract class DeviceDetails {
  String id;
  String clientId;  //optional
  DevicePlatform platform;
  FormFactor formFactor;
  dynamic metadata; //optional
  String deviceSecret;  //optional
  DevicePushDetails push; //optional
}

abstract class PushChannelSubscription {
  String channel;
  String deviceId;  //optional
  String clientId;  //optional
}

abstract class DeviceRegistrationParams {
  String clientId;  //optional
  String deviceId;  //optional
  int limit;  //optional
  DevicePushState state;  //optional
}

abstract class PushChannelSubscriptionParams {
  String channel;  //optional
  String clientId;  //optional
  String deviceId;  //optional
  int limit;    //optional
}

abstract class PushChannelsParams {
  int limit;    //optional
}


// Internal Classes
/// Interface implemented by event listeners, returned by event emitters.
abstract class EventListener<E> {
  /// Register for all events (no parameter), or a specific event.
  Stream<E> on([E event]);

  /// Register for a single occurrence of any event (no parameter), or a specific event.
  Future<E> once([E event]);

  /// Remove registrations for this listener, irrespective of type.
  Future<void> off();
}

/// Interface implemented by Ably classes that can emit events, offering the capability
/// to create listeners for those events.
abstract class EventEmitter<E> {
  /// Remove all listener registrations, irrespective of type.
  Future<void> off();

  /// Create a listener, with which registrations may be made.
  Future<EventListener<E>> createListener();
}

abstract class PaginatedResult<T> {
  List<T> items();
  Future<PaginatedResult<T>> first();
  Future<PaginatedResult<T>> next();
  Future<PaginatedResult<T>> current();
  bool hasNext();
  bool isLast();
}

abstract class HttpPaginatedResponse extends PaginatedResult<String> {
  List<String> items();
  int statusCode;
  bool success;
  int errorCode;
  String errorMessage;
  Map<String, String> headers;
}

class Stats {
  StatsMessageTypes all;
  StatsRequestCount apiRequests;
  StatsResourceCount channels;
  StatsConnectionTypes connections;
  StatsMessageTraffic inbound;
  String intervalId;
  StatsMessageTraffic outbound;
  StatsMessageTypes persisted;
  StatsRequestCount tokenRequests;
}
