import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudMessaging {
  final BrainCloudClient _clientRef;

  BrainCloudMessaging(this._clientRef);

  /// Deletes specified user messages on the server. in_msgBox = OperationParam.inboxMessageType && OperationParam.sentMessageType
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> deleteMessages(
      {required String msgBox, required List<String> msgsIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = msgBox;
    data[OperationParam.messagingMessageIds.value] = msgsIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.deleteMessages, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve user's message boxes, including 'inbox', 'sent', etc.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getMessageBoxes() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessageBoxes, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns count of user's 'total' messages and their 'unread' messages.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getMessageCounts() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessageCounts, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves list of specified messages.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getMessages(
      {required String msgBox,
      required List<String> msgIds,
      required bool markAsRead}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = msgBox;
    data[OperationParam.messagingMessageIds.value] = msgIds;
    data[OperationParam.messagingMarkAsRead.value] = markAsRead;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.getMessages, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves a page of messages.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getMessagesPage(
      {required Map<String, dynamic> context}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.messagingContext.value] = context;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessagesPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the page of messages from the server based on the encoded context and specified page offset.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getMessagesPageOffset(
      {required String context, required int pageOffset}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingContext.value] = context;
    data[OperationParam.messagingPageOffset.value] = pageOffset;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessagesPageOffset, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Marks list of user messages as read on the server.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> markMessagesRead(
      {required String msgBox, required List<String> msgsIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = msgBox;
    data[OperationParam.messagingMessageIds.value] = msgsIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.markMessagesRead, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Sends a message with specified 'subject' and 'text' to list of users.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> sendMessage(
      {required List<String> toProfileIds,
      required Map<String, dynamic> contentJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingToProfileIds.value] = toProfileIds;

    data[OperationParam.messagingContent.value] = contentJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.sendMessage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Send a potentially rich chat message. content must contain at least a "plain" field for plain-text messaging.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> sendMessageSimple(
      {required List<String> toProfileIds, required String text}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.messagingToProfileIds.value] = toProfileIds;
    data[OperationParam.messagingText.value] = text;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.sendMessageSimple, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
