import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudMessaging {
  final BrainCloudClient _clientRef;

  BrainCloudMessaging(this._clientRef);

  /// <summary>
  /// Deletes specified user messages on the server. in_msgBox = OperationParam.inboxMessageType && OperationParam.sentMessageType
  /// </summary>
  Future<ServerResponse> deleteMessages(
      {required String msgBox, required List<String> msgsIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = msgBox;
    data[OperationParam.messagingMessageIds.value] = msgsIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.deleteMessages, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve user's message boxes, including 'inbox', 'sent', etc.
  /// </summary>
  Future<ServerResponse> getMessageboxes() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessageBoxes, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Returns count of user's 'total' messages and their 'unread' messages.
  /// </summary>
  Future<ServerResponse> getMessageCounts() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessageCounts, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves list of specified messages.
  /// </summary>
  Future<ServerResponse> getMessages(
      {required String inMsgbox,
      required List<String> inMsgsids,
      required bool markAsRead}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = inMsgbox;
    data[OperationParam.messagingMessageIds.value] = inMsgsids;
    data[OperationParam.messagingMarkAsRead.value] = markAsRead;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.getMessages, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves a page of messages.
  /// </summary>
  Future<ServerResponse> getMessagesPage({required String context}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.messagingContext.value] = context;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessagesPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the page of messages from the server based on the encoded context and specified page offset.
  /// </summary>
  Future<ServerResponse> getMessagesPageOffset(
      {required String context, required int pageOffset}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingContext.value] = context;
    data[OperationParam.messagingPageOffset.value] = pageOffset;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessagesPageOffset, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Marks list of user messages as read on the server.
  /// </summary>
  Future<ServerResponse> markMessagesRead(
      {required String msgBox, required List<String> msgsIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = msgBox;
    data[OperationParam.messagingMessageIds.value] = msgsIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.markMessagesRead, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Sends a message with specified 'subject' and 'text' to list of users.
  /// </summary>
  Future<ServerResponse> sendMessage(
      {required List<String> toprofileids, required String contentjson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingToProfileIds.value] = toprofileids;

    var content = jsonDecode(contentjson);
    data[OperationParam.messagingContent.value] = content;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.sendMessage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Send a potentially rich chat message. <content> must contain at least a "plain" field for plain-text messaging.
  /// </summary>
  ///
  Future<ServerResponse> sendMessageSimple(
      {required List<String> toprofileids, required String messagetext}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingToProfileIds.value] = toprofileids;
    data[OperationParam.messagingText.value] = messagetext;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.sendMessageSimple, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
