// Copyright 2026 bitHeads, Inc. All Rights Reserved.
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

  /// Deletes specified user messages on the server.
  /// Service Name - Messaging
  /// Service Operation - DeleteMessages
  ///
  /// @param in_msgbox The message box to delete from.
  /// @param in_msgIds Arrays of message ids to delete.
  /// @param in_callback The method to be invoked when the server response is received
  ///
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
  /// Service Name - Messaging
  /// Service Operation - GetMessageboxes
  ///
  /// @param in_callback The method to be invoked when the server response is received
  ///
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

  /// Retrieve user's message boxes, including 'inbox', 'sent', etc.
  /// Service Name - Messaging
  /// Service Operation - GetMessageCounts
  ///
  /// @param in_callback The method to be invoked when the server response is received
  ///
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
  /// Service Name - Messaging
  /// Service Operation - GetMessages
  ///
  /// @param in_msgbox The message box to get messages from.
  /// @param in_msgIds Arrays of message ids to get.
  /// @param markAsRead mark messages that are read
  /// @param in_callback The method to be invoked when the server response is received
  ///
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
  /// Service Name - Messaging
  /// Service Operation - GetMessagesPage
  ///
  /// @param in_context The context for the page of messages.
  /// @param in_callback The method to be invoked when the server response is received
  ///
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
  /// Service Name - Messaging
  /// Service Operation - GetMessagesPageOffset
  ///
  /// @param in_context The context for the page of messages.
  /// @param pageOffset The page offset.
  /// @param in_callback The method to be invoked when the server response is received
  ///
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
  /// Service Name - Messaging
  /// Service Operation - MarkMessagesRead
  ///
  /// @param msgbox The message box to mark as read.
  /// @param msgIds Arrays of message ids to mark as read.
  /// @param in_callback The method to be invoked when the server response is received
  ///
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
  /// Service Name - Messaging
  /// Service Operation - SendMessage
  ///
  /// @param toProfileIds The list of profile ids to send the message to.
  /// @param contentJson The message you are sending
  /// @param in_callback The method to be invoked when the server response is received
  ///
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

  /// Sends a simple message to specified list of users.
  /// Service Name - Messaging
  /// Service Operation - SendMessageSimple
  ///
  /// @param toProfileIds The list of profile ids to send the message to.
  /// @param messageText The message text you are sending
  /// @param in_callback The method to be invoked when the server response is received
  ///
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
