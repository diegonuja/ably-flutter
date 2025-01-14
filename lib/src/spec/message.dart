import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'enums.dart';
import 'rest/channels.dart';

/// Handles supported message data types, their encoding and decoding
class MessageData<T> {
  final T _data;

  /// Only Map, List, string and Buffer types are supported
  MessageData(this._data)
      : assert(T == Map || T == List || T == String || T == Uint8List);

  /// retrieve data
  T get data => _data;

  /// initializes [MessageData] with given value and asserts from input type
  static MessageData fromValue(Object value) {
    if (value == null) {
      return null;
    }
    assert(
      value is MessageData ||
          value is Map ||
          value is List ||
          value is String ||
          value is Uint8List,
      'Message data must be either `Map`, `List`, `String` or `Uint8List`.'
      ' Does not support $value ("${value.runtimeType}")',
    );
    if (value is MessageData) {
      return value;
    } else if (value is Map) {
      return MessageData<Map>(value);
    } else if (value is Uint8List) {
      return MessageData<Uint8List>(value);
    } else if (value is List) {
      return MessageData<List>(value);
    } else if (value is String) {
      return MessageData<String>(value);
    } else {
      throw AssertionError(
        'Message data must be either `Map`, `List`, `String` or `Uint8List`.'
        ' Does not support $value ("${value.runtimeType}")',
      );
    }
  }
}

/// An individual message to be sent/received by Ably
///
/// https://docs.ably.io/client-lib-development-guide/features/#TM1
class Message {
  /// A unique ID for this message
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TM2a
  final String id;

  /// The timestamp for this message
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TM2f
  final DateTime timestamp;

  /// The id of the publisher of this message
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TM2b
  final String clientId;

  /// The connection id of the publisher of this message
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TM2c
  final String connectionId;

  /// Any transformation applied to the data for this message
  final String encoding;

  final MessageData _data;

  /// Message payload
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TM2d
  Object get data => _data?.data;

  /// Name of the message
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TM2g
  final String name;

  /// Extras, if available
  final Map extras;

  /// Creates a message instance with [name], [data] and [clientId]
  Message({
    this.id,
    this.name,
    Object data,
    this.clientId,
    this.connectionId,
    this.timestamp,
    this.encoding,
    this.extras,
  }) : _data = MessageData.fromValue(data);

  @override
  String toString() => 'Message'
      ' id=$id'
      ' name=$name'
      ' data=$data'
      ' extras=$extras'
      ' encoding=$encoding'
      ' clientId=$clientId'
      ' timestamp=$timestamp'
      ' connectionId=$connectionId';

// TODO(tiholic) add support for fromEncoded and fromEncodedArray (TM3)
}

/// An individual presence message sent or received via realtime
///
/// https://docs.ably.io/client-lib-development-guide/features/#TP1
@immutable
class PresenceMessage {
  /// unique ID for this presence message
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TP3a
  final String id;

  /// presence action - to update presence status of current client,
  /// or to understand presence state of another client
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TP3b
  final PresenceAction action;

  /// https://docs.ably.io/client-lib-development-guide/features/#TP3c
  final String clientId;

  /// connection id of the source of this message
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TP3d
  final String connectionId;

  final MessageData _data;

  /// Message payload
  ///
  /// https://docs.ably.io/client-lib-development-guide/features/#TP3e
  Object get data => _data?.data;

  /// https://docs.ably.io/client-lib-development-guide/features/#TP3f
  final String encoding;

  /// https://docs.ably.io/client-lib-development-guide/features/#TP3i
  final Map<String, dynamic> extras;

  /// https://docs.ably.io/client-lib-development-guide/features/#TP3g
  final DateTime timestamp;

  /// https://docs.ably.io/client-lib-development-guide/features/#TP3h
  String get memberKey => '$connectionId:$clientId';

  /// instantiates presence message with
  PresenceMessage({
    this.id,
    this.action,
    this.clientId,
    this.connectionId,
    Object data,
    this.encoding,
    this.extras,
    this.timestamp,
  }) : _data = MessageData.fromValue(data);

  @override
  bool operator ==(Object other) =>
      other is PresenceMessage &&
      other.id == id &&
      other.action == action &&
      other.clientId == clientId &&
      other.connectionId == connectionId &&
      other.data == data &&
      other.encoding == encoding &&
      other.extras == extras &&
      other.timestamp == timestamp;

  @override
  int get hashCode => '$id:$clientId:$connectionId:$timestamp'.hashCode;

  /// https://docs.ably.io/client-lib-development-guide/features/#TP4
  ///
  /// TODO(tiholic): decoding and decryption is not implemented as per
  ///  RSL6 and RLS6b as mentioned in TP4
  PresenceMessage.fromEncoded(
    Map<String, dynamic> jsonObject, [
    ChannelOptions channelOptions,
  ])  : id = jsonObject['id'] as String,
        action = PresenceAction.values.firstWhere((e) =>
            e.toString().split('.')[1] == jsonObject['action'] as String),
        clientId = jsonObject['clientId'] as String,
        connectionId = jsonObject['connectionId'] as String,
        _data = MessageData.fromValue(jsonObject['data']),
        encoding = jsonObject['encoding'] as String,
        extras = Map.castFrom<dynamic, dynamic, String, dynamic>(
            jsonObject['extras'] as Map),
        timestamp = jsonObject['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                jsonObject['timestamp'] as int)
            : null;

  /// https://docs.ably.io/client-lib-development-guide/features/#TP4
  static List<PresenceMessage> fromEncodedArray(
    List<Map<String, dynamic>> jsonArray, [
    ChannelOptions channelOptions,
  ]) =>
      jsonArray.map((e) => PresenceMessage.fromEncoded(e)).toList();

  @override
  String toString() => 'PresenceMessage'
      ' id=$id'
      ' data=$data'
      ' action=$action'
      ' extras=$extras'
      ' encoding=$encoding'
      ' clientId=$clientId'
      ' timestamp=$timestamp'
      ' connectionId=$connectionId';
}
