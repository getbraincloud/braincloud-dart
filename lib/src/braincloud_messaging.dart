import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudMessaging {
  final BrainCloudClient _clientRef;

  BrainCloudMessaging(this._clientRef);

  /// <summary>
  /// Deletes specified user messages on the server. in_msgBox = OperationParam.inboxMessageType && OperationParam.sentMessageType
  /// </summary>
  void deleteMessages(String inMsgbox, List<String> inMsgsids,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = inMsgbox;
    data[OperationParam.messagingMessageIds.value] = inMsgsids;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.deleteMessages, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieve user's message boxes, including 'inbox', 'sent', etc.
  /// </summary>
  void getMessageboxes(SuccessCallback? success, FailureCallback? failure) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessageBoxes, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns count of user's 'total' messages and their 'unread' messages.
  /// </summary>
  void getMessageCounts(SuccessCallback? success, FailureCallback? failure) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessageCounts, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves list of specified messages.
  /// </summary>
  void getMessages(String inMsgbox, List<String> inMsgsids, bool markAsRead,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = inMsgbox;
    data[OperationParam.messagingMessageIds.value] = inMsgsids;
    data[OperationParam.messagingMarkAsRead.value] = markAsRead;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.getMessages, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves a page of messages.
  /// </summary>
  void getMessagesPage(
      String inContext, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    var context = jsonDecode(inContext);
    data[OperationParam.messagingContext.value] = context;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessagesPage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the page of messages from the server based on the encoded context and specified page offset.
  /// </summary>
  void getMessagesPageOffset(String inContext, int pageOffset,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.messagingContext.value] = inContext;
    data[OperationParam.messagingPageOffset.value] = pageOffset;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.getMessagesPageOffset, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Marks list of user messages as read on the server.
  /// </summary>
  void markMessagesRead(String inMsgbox, List<String> inMsgsids,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.messagingMessageBox.value] = inMsgbox;
    data[OperationParam.messagingMessageIds.value] = inMsgsids;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.markMessagesRead, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Sends a message with specified 'subject' and 'text' to list of users.
  /// </summary>
  void sendMessage(List<String> inToprofileids, String inContentjson,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.messagingToProfileIds.value] = inToprofileids;

    var content = jsonDecode(inContentjson);
    data[OperationParam.messagingContent.value] = content;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.messaging, ServiceOperation.sendMessage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Send a potentially rich chat message. <content> must contain at least a "plain" field for plain-text messaging.
  /// </summary>
  ///
  void sendMessageSimple(List<String> inToprofileids, String inMessagetext,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.messagingToProfileIds.value] = inToprofileids;
    data[OperationParam.messagingText.value] = inMessagetext;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.messaging,
        ServiceOperation.sendMessageSimple, data, callback);
    _clientRef.sendRequest(sc);
  }
}
