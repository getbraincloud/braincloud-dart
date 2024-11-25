import 'dart:async';

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

  /// Registers a listener for incoming events from <channelId>. Also returns a list of <maxReturn> recent messages from history.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> channelConnect(
      {required String channelId, required int maxtoreturn}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMaxReturn.value] = maxtoreturn;

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
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// returns Future<ServerResponse>
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

  /// Gets the channelId for the given <channelType> and <channelSubId>. Channel type must be one of "gl"(GlobalChannelType) or "gr"(GroupChannelType).
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getChannelId(
      {required String channeltype, required String channelsubid}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelType.value] = channeltype;
    data[OperationParam.chatChannelSubId.value] = channelsubid;

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

  /// Gets description info and activity stats for channel <channelId>. Note that numMsgs and listeners only returned for non-global groups. Only callable for channels the user is a member of.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getChatMessage(
      {required String channelId, required String messageid}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMessageId.value] = messageid;

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

  /// Get a list of <maxReturn> messages from history of channel <channelId>
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getRecentChatMessages(
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
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.getRecentChatMessages, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets a list of the channels of type <channelType> that the user has access to. Channel type must be one of "gl"(GlobalChannelType), "gr"(GroupChannelType) or "all"(AllChannelType).
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getSubscribedChannels({required String channeltype}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelType.value] = channeltype;

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

  /// Sends a potentially richer member chat message.
  ///
  /// By convention, content should contain a field named text for plain-text content. Returns the id of the message created.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> postChatMessage(
      {required String channelId,
      required Map<String, dynamic> contentJson,
      bool inRecordInHistory = true}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatContent.value] = contentJson;
    data[OperationParam.chatRecordInHistory.value] = inRecordInHistory;

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

  /// Sends a plain-text chat message.
  ///
  /// returns Future<ServerResponse>
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

  /// Update the specified chat message. Message must have been from this user. Version provided must match (or pass -1 to bypass version enforcement).
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateChatMessage(
      {required String channelId,
      required String messageid,
      required int version,
      required Map<String, dynamic> contentjson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = channelId;
    data[OperationParam.chatMessageId.value] = messageid;
    data[OperationParam.chatVersion.value] = version;
    data[OperationParam.chatContent.value] = contentjson;

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
