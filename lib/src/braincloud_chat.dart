import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudChat {
  final BrainCloudClient _clientRef;

  BrainCloudChat(this._clientRef);

  /// <summary>
  /// Registers a listener for incoming events from <channelId>. Also returns a list of <maxReturn> recent messages from history.
  /// </summary>
  void ChannelConnect(String in_channelId, int in_maxToReturn,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.ChatChannelId.Value] = in_channelId;
    data[OperationParam.ChatMaxReturn.Value] = in_maxToReturn;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Chat, ServiceOperation.channelConnect, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Unregisters a listener for incoming events from <channelId>.
  /// </summary>
  void ChannelDisconnect(String in_channelId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.ChatChannelId.Value] = in_channelId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Chat, ServiceOperation.channelDisconnect, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Delete a chat message. <version> must match the latest or pass -1 to bypass version check.
  /// </summary>
  void DeleteChatMessage(
      String in_channelId,
      String in_messageId,
      int in_version,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.ChatChannelId.Value] = in_channelId;
    data[OperationParam.ChatMessageId.Value] = in_messageId;
    data[OperationParam.ChatVersion.Value] = in_version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Chat, ServiceOperation.deleteChatMessage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the channelId for the given <channelType> and <channelSubId>. Channel type must be one of "gl"(GlobalChannelType) or "gr"(GroupChannelType).
  /// </summary>
  void GetChannelId(String in_channelType, String in_channelSubId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.ChatChannelType.Value] = in_channelType;
    data[OperationParam.ChatChannelSubId.Value] = in_channelSubId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Chat, ServiceOperation.getChannelId, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets description info and activity stats for channel <channelId>. Note that numMsgs and listeners only returned for non-global groups. Only callable for channels the user is a member of.
  /// </summary>
  void GetChannelInfo(String in_channelId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.ChatChannelId.Value] = in_channelId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Chat, ServiceOperation.getChannelInfo, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets a populated chat object (normally for editing).
  /// </summary>
  void GetChatMessage(String in_channelId, String in_messageId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.ChatChannelId.Value] = in_channelId;
    data[OperationParam.ChatMessageId.Value] = in_messageId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Chat, ServiceOperation.getChatMessage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Get a list of <maxReturn> messages from history of channel <channelId>
  /// </summary>
  void GetRecentChatMessages(
      {required String in_channelId,
      required int in_maxToReturn,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.ChatChannelId.Value] = in_channelId;
    data[OperationParam.ChatMaxReturn.Value] = in_maxToReturn;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Chat,
        ServiceOperation.getRecentChatMessages, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets a list of the channels of type <channelType> that the user has access to. Channel type must be one of "gl"(GlobalChannelType), "gr"(GroupChannelType) or "all"(AllChannelType).
  /// </summary>
  void GetSubscribedChannels(String in_channelType, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.ChatChannelType.Value] = in_channelType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Chat,
        ServiceOperation.getSubscribedChannels, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Sends a potentially richer member chat message. By convention, content should contain a field named text for plain-text content. Returns the id of the message created.
  /// </summary>
  ///
  void postChatMessage(
      {required String in_channelId,
      required String in_contentJson,
      bool in_recordInHistory = true,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.ChatChannelId.Value] = in_channelId;
    data[OperationParam.ChatContent.Value] = jsonDecode(in_contentJson);
    data[OperationParam.ChatRecordInHistory.Value] = in_recordInHistory;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Chat, ServiceOperation.postChatMessage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Send a potentially rich chat message. <content> must contain at least a "plain" field for plain-text messaging.
  /// </summary>
  ///
  // void postChatMessage(
  //     {required String in_channelId,
  //     required String in_plain,
  //     required String in_jsonRich,
  //     bool in_recordInHistory = true,
  //     SuccessCallback? success,
  //     FailureCallback? failure,
  //     dynamic cbObject}) {
  //   Map<String, dynamic> data = <String, dynamic>{};

  //   // Build message content
  //   Map<String, dynamic> content = {};
  //   content[OperationParam.ChatText.Value] = in_plain;
  //   if (Util.isOptionalParameterValid(in_jsonRich)) {
  //     Map<String, dynamic> jsonRich = jsonDecode(in_jsonRich);
  //     content[OperationParam.ChatRich.Value] = jsonRich;
  //   } else {
  //     Map<String, dynamic> jsonRich = jsonDecode("{}");
  //     content[OperationParam.ChatRich.Value] = jsonRich;
  //   }

  //   data[OperationParam.ChatChannelId.Value] = in_channelId;
  //   data[OperationParam.ChatContent.Value] = content;
  //   data[OperationParam.ChatRecordInHistory.Value] = in_recordInHistory;

  //   ServerCallback? callback = BrainCloudClient.createServerCallback(
  //       success, failure,
  //       cbObject: cbObject);
  //   ServerCall sc = ServerCall(
  //       ServiceName.Chat, ServiceOperation.postChatMessage, data, callback);
  //   _clientRef.sendRequest(sc);
  // }

  /// <summary>
  /// Sends a plain-text chat message.
  /// </summary>
  ///
  void postChatMessageSimple(
      {required String in_channelId,
      required String in_plain,
      bool in_recordInHistory = true,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.ChatChannelId.Value] = in_channelId;
    data[OperationParam.ChatText.Value] = in_plain;
    data[OperationParam.ChatRecordInHistory.Value] = in_recordInHistory;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Chat,
        ServiceOperation.postChatMessageSimple, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Update the specified chat message. Message must have been from this user. Version provided must match (or pass -1 to bypass version enforcement).
  /// </summary>
  void UpdateChatMessage(
      String in_channelId,
      String in_messageId,
      int in_version,
      String in_contentJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.ChatChannelId.Value] = in_channelId;
    data[OperationParam.ChatMessageId.Value] = in_messageId;
    data[OperationParam.ChatVersion.Value] = in_version;
    data[OperationParam.ChatContent.Value] = jsonDecode(in_contentJson);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Chat, ServiceOperation.updateChatMessage, data, callback);
    _clientRef.sendRequest(sc);
  }

  // /// <summary>
  // /// Update a chat message. <content> must contain at least a "plain" field for plain-text messaging. <version> must match the latest or pass -1 to bypass version check.
  // /// </summary>
  // void UpdateChatMessage(
  //     String in_channelId,
  //     String in_messageId,
  //     int in_version,
  //     String in_plain,
  //     String in_jsonRich,
  //     SuccessCallback? success,
  //     FailureCallback? failure,
  //     dynamic cbObject) {
  //   Map<String, dynamic> content = <String, dynamic>{};
  //   content[OperationParam.ChatText.Value] = in_plain;
  //   if (Util.isOptionalParameterValid(in_jsonRich)) {
  //     Map<String, dynamic> jsonRich = jsonDecode(in_jsonRich);
  //     content[OperationParam.ChatRich.Value] = jsonRich;
  //   } else {
  //     Map<String, dynamic> jsonRich = {};
  //     content[OperationParam.ChatRich.Value] = jsonRich;
  //   }

  //   Map<String, dynamic> data = {};
  //   data[OperationParam.ChatChannelId.Value] = in_channelId;
  //   data[OperationParam.ChatMessageId.Value] = in_messageId;
  //   data[OperationParam.ChatVersion.Value] = in_version;
  //   data[OperationParam.ChatContent.Value] = content;

  //   ServerCallback? callback = BrainCloudClient.createServerCallback(
  //       success, failure,
  //       cbObject: cbObject);
  //   ServerCall sc = ServerCall(
  //       ServiceName.Chat, ServiceOperation.updateChatMessage, data, callback);
  //   _clientRef.sendRequest(sc);
  // }
}
