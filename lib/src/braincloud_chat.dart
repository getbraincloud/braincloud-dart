// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudChat {
  final BrainCloudClient _clientRef;

  BrainCloudChat(this._clientRef);

/// Registers a listener for incoming events from <channelId>.
/// Also returns a list of <maxReturn> recent messages from history.
/// Service Name - Chat
/// Service Operation - ChannelConnect
///
/// @param channelId The id of the chat channel to return history from.
/// @param maxReturn Maximum number of messages to return.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> channelConnect(
      {required String channelId, required int maxToReturn}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMaxReturn.value] = maxToReturn;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.channelConnect, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Unregisters a listener for incoming events from <channelId>.
/// Service Name - Chat
/// Service Operation - ChannelDisconnect
///
/// @param channelId The id of the chat channel to unsubscribed from.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> channelDisconnect({required String channelId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.channelDisconnect, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Delete a chat message. <version> must match the latest or pass -1 to bypass version check.
/// Service Name - Chat
/// Service Operation - DeleteChatMessage
///
/// @param channelId The id of the chat channel that contains the message to delete.
/// @param msgId The message id to delete.
/// @param version Version of the message to delete. Must match latest or pass -1 to bypass version check.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> deleteChatMessage(
      {required String channelId,
      required String msgId,
      required int version}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMessageId.value] = msgId;
    data[OperationParam.chatVersion.value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.deleteChatMessage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Gets the channelId for the given <channelType> and <channelSubId>. Channel type must be one of "gl" or "gr".
/// Service Name - Chat
/// Service Operation - GetChannelId
///
/// @param channelType Channel type must be one of "gl" or "gr". For (global) or (group) respectively.
/// @param channelSubId The sub id of the channel.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getChannelId(
      {required String channelType, required String channelSubId}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelType.value] = channelType;
    data[OperationParam.chatChannelSubId.value] = channelSubId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback((response) {
      completer.complete(ServerResponse.fromJson(response));
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChannelId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Gets description info and activity stats for channel <channelId>.
/// Note that numMsgs and listeners only returned for non-global groups.
/// Only callable for channels the user is a member of.
/// Service Name - Chat
/// Service Operation - GetChannelInfo
///
/// @param channelId Id of the channel to receive the info from.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getChannelInfo({required String channelId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChannelInfo, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Gets a populated chat object (normally for editing).
/// Service Name - Chat
/// Service Operation - GetChatMessage
///
/// @param channelId Id of the channel to receive the message from.
/// @param msgId Id of the message to read.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getChatMessage(
      {required String channelId, required String msgId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMessageId.value] = msgId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChatMessage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Get a list of <maxReturn> messages from history of channel <channelId>.
/// Service Name - Chat
/// Service Operation - GetRecentChatMessages
///
/// @param channelId Id of the channel to receive the info from.
/// @param maxReturn Maximum message count to return.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getRecentChatMessages(
      {required String channelId, required int maxReturn}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMaxReturn.value] = maxReturn;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.getRecentChatMessages, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Gets a list of the channels of type <channelType> that the user has access to.
/// Channel type must be one of "gl", "gr" or "all".
/// Service Name - Chat
/// Service Operation - GetSubscribedChannels
///
/// @param channelType Type of channels to get back. "gl" for global, "gr" for group or "all" for both.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getSubscribedChannels({required String channelType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelType.value] = channelType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.getSubscribedChannels, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Send a potentially rich chat message.
/// <content> must contain at least a "text" field for text messaging.
/// Service Name - Chat
/// Service Operation - PostChatMessage
///
/// @param channelId Channel id to post message to.
/// @param content Object containing "text" for the text message. Can also has rich content for custom data.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> postChatMessage(
      {required String channelId,
      required Map<String, dynamic> contentJson,
      bool recordInHistory = true}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatContent.value] = contentJson;
    data[OperationParam.chatRecordInHistory.value] = recordInHistory;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.postChatMessage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Send a chat message with text only
/// Service Name - Chat
/// Service Operation - PostChatMessage
///
/// @param channelId Channel id to post message to.
/// @param text The text message.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> postChatMessageSimple(
      {required String channelId,
      required String chatMessage,
      bool recordInHistory = true}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatText.value] = chatMessage;
    data[OperationParam.chatRecordInHistory.value] = recordInHistory;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.postChatMessageSimple, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Update a chat message.
/// <content> must contain at least a "text" field for text-text messaging.
/// <version> must match the latest or pass -1 to bypass version check.
/// Service Name - Chat
/// Service Operation - UpdateChatMessage
///
/// @param channelId Channel id where the message to update is.
/// @param msgId Message id to update.
/// @param version Version of the message to update. Must match latest or pass -1 to bypass version check.
/// @param content Data to update. Object containing "text" for the text message. Can also has rich content for custom data.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> updateChatMessage(
      {required String channelId,
      required String messageId,
      required int version,
      required Map<String, dynamic> contentJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMessageId.value] = messageId;
    data[OperationParam.chatVersion.value] = version;
    data[OperationParam.chatContent.value] = contentJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.updateChatMessage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
