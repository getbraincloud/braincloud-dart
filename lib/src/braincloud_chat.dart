import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudChat {
  final BrainCloudClient _clientRef;

  BrainCloudChat(this._clientRef);

  /// <summary>
  /// Registers a listener for incoming events from <channelId>. Also returns a list of <maxReturn> recent messages from history.
  /// </summary>
  Future<ServerResponse> channelConnect(
      {required String channelId, required int maxtoreturn}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMaxReturn.value] = maxtoreturn;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.channelConnect, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Unregisters a listener for incoming events from <channelId>.
  /// </summary>
  Future<ServerResponse> channelDisconnect({required String channelId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.channelDisconnect, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Delete a chat message. <version> must match the latest or pass -1 to bypass version check.
  /// </summary>
  Future<ServerResponse> deleteChatMessage(
      {required String channelId,
      required String messageid,
      required int version}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMessageId.value] = messageid;
    data[OperationParam.chatVersion.value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.deleteChatMessage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the channelId for the given <channelType> and <channelSubId>. Channel type must be one of "gl"(GlobalChannelType) or "gr"(GroupChannelType).
  /// </summary>
  Future<ServerResponse> getChannelId(
      {required String channeltype, required String channelsubid}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelType.value] = channeltype;
    data[OperationParam.chatChannelSubId.value] = channelsubid;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback((response) {
      completer.complete(ServerResponse(statusCode: 200, body: response));
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChannelId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets description info and activity stats for channel <channelId>. Note that numMsgs and listeners only returned for non-global groups. Only callable for channels the user is a member of.
  /// </summary>
  Future<ServerResponse> getChannelInfo({required String channelId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChannelInfo, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets a populated chat object (normally for editing).
  /// </summary>
  Future<ServerResponse> getChatMessage(
      {required String channelId, required String messageid}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMessageId.value] = messageid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChatMessage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Get a list of <maxReturn> messages from history of channel <channelId>
  /// </summary>
  Future<ServerResponse> getRecentChatMessages(
      {required String channelId, required int maxToReturn}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMaxReturn.value] = maxToReturn;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.getRecentChatMessages, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets a list of the channels of type <channelType> that the user has access to. Channel type must be one of "gl"(GlobalChannelType), "gr"(GroupChannelType) or "all"(AllChannelType).
  /// </summary>
  Future<ServerResponse> getSubscribedChannels({required String channeltype}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelType.value] = channeltype;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.getSubscribedChannels, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a potentially richer member chat message. By convention, content should contain a field named text for plain-text content. Returns the id of the message created.
  /// </summary>
  ///
  Future<ServerResponse> postChatMessage(
      {required String channelId,
      required String contentJson,
      bool inRecordInHistory = true}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatContent.value] = jsonDecode(contentJson);
    data[OperationParam.chatRecordInHistory.value] = inRecordInHistory;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.postChatMessage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Send a potentially rich chat message. <content> must contain at least a "plain" field for plain-text messaging.
  /// </summary>
  ///
  // void postChatMessage(
  //     {required String channelId,
  //     required String plain,
  //     required String jsonRich,
  //     bool recordInHistory = true
  //     }) {
  //   Map<String, dynamic> data = <String, dynamic>{};

  //   // Build message content
  //   Map<String, dynamic> content = {};
  //   content[OperationParam.chatText.Value] = plain;
  //   if (Util.isOptionalParameterValid(jsonRich)) {
  //     Map<String, dynamic> jsonRich = jsonDecode(jsonRich);
  //     content[OperationParam.chatRich.Value] = jsonRich;
  //   } else {
  //     Map<String, dynamic> jsonRich = jsonDecode("{}");
  //     content[OperationParam.chatRich.Value] = jsonRich;
  //   }

  //   data[OperationParam.chatChannelId.Value] = channelId;
  //   data[OperationParam.chatContent.Value] = content;
  //   data[OperationParam.chatRecordInHistory.Value] = recordInHistory;

  //   ServerCallback? callback = BrainCloudClient.createServerCallback(
  //       success, failure);
  //   ServerCall sc = ServerCall(
  //       ServiceName.Chat, ServiceOperation.postChatMessage, data, callback);
  //   _clientRef.sendRequest(sc);
  // }

  /// <summary>
  /// Sends a plain-text chat message.
  /// </summary>
  ///
  Future<ServerResponse> postChatMessageSimple(
      {required String channelId,
      required String plain,
      bool recordInHistory = true}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatText.value] = plain;
    data[OperationParam.chatRecordInHistory.value] = recordInHistory;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.postChatMessageSimple, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Update the specified chat message. Message must have been from this user. Version provided must match (or pass -1 to bypass version enforcement).
  /// </summary>
  Future<ServerResponse> updateChatMessage(
      {required String channelId,
      required String messageid,
      required int version,
      required String contentjson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMessageId.value] = messageid;
    data[OperationParam.chatVersion.value] = version;
    data[OperationParam.chatContent.value] = jsonDecode(contentjson);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.updateChatMessage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  // /// <summary>
  // /// Update a chat message. <content> must contain at least a "plain" field for plain-text messaging. <version> must match the latest or pass -1 to bypass version check.
  // /// </summary>
  // void UpdateChatMessage(
  //     String channelId,
  //     String in_messageId,
  //     int in_version,
  //     String plain,
  //     String jsonRich,
  //     SuccessCallback? success,
  //     FailureCallback? failure) {
  //   Map<String, dynamic> content = <String, dynamic>{};
  //   content[OperationParam.chatText.Value] = plain;
  //   if (Util.isOptionalParameterValid(jsonRich)) {
  //     Map<String, dynamic> jsonRich = jsonDecode(jsonRich);
  //     content[OperationParam.chatRich.Value] = jsonRich;
  //   } else {
  //     Map<String, dynamic> jsonRich = {};
  //     content[OperationParam.chatRich.Value] = jsonRich;
  //   }

  //   Map<String, dynamic> data = {};
  //   data[OperationParam.chatChannelId.Value] = channelId;
  //   data[OperationParam.chatMessageId.Value] = in_messageId;
  //   data[OperationParam.chatVersion.Value] = in_version;
  //   data[OperationParam.chatContent.Value] = content;

  //   ServerCallback? callback = BrainCloudClient.createServerCallback(
  //       success, failure);
  //   ServerCall sc = ServerCall(
  //       ServiceName.Chat, ServiceOperation.updateChatMessage, data, callback);
  //   _clientRef.sendRequest(sc);
  // }
}
