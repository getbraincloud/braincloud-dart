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
  void channelConnect(String inChannelid, int inMaxtoreturn,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = inChannelid;
    data[OperationParam.chatMaxReturn.value] = inMaxtoreturn;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.channelConnect, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Unregisters a listener for incoming events from <channelId>.
  /// </summary>
  void channelDisconnect(String inChannelid, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = inChannelid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.channelDisconnect, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Delete a chat message. <version> must match the latest or pass -1 to bypass version check.
  /// </summary>
  void deleteChatMessage(String inChannelid, String inMessageid, int inVersion,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = inChannelid;
    data[OperationParam.chatMessageId.value] = inMessageid;
    data[OperationParam.chatVersion.value] = inVersion;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.deleteChatMessage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the channelId for the given <channelType> and <channelSubId>. Channel type must be one of "gl"(GlobalChannelType) or "gr"(GroupChannelType).
  /// </summary>
  void getChannelId(String inChanneltype, String inChannelsubid,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelType.value] = inChanneltype;
    data[OperationParam.chatChannelSubId.value] = inChannelsubid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChannelId, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets description info and activity stats for channel <channelId>. Note that numMsgs and listeners only returned for non-global groups. Only callable for channels the user is a member of.
  /// </summary>
  void getChannelInfo(String inChannelid, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = inChannelid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChannelInfo, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets a populated chat object (normally for editing).
  /// </summary>
  void getChatMessage(String inChannelid, String inMessageid,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = inChannelid;
    data[OperationParam.chatMessageId.value] = inMessageid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.getChatMessage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Get a list of <maxReturn> messages from history of channel <channelId>
  /// </summary>
  void getRecentChatMessages(
      {required String inChannelId,
      required int inMaxToReturn,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelId.value] = inChannelId;
    data[OperationParam.chatMaxReturn.value] = inMaxToReturn;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.getRecentChatMessages, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets a list of the channels of type <channelType> that the user has access to. Channel type must be one of "gl"(GlobalChannelType), "gr"(GroupChannelType) or "all"(AllChannelType).
  /// </summary>
  void getSubscribedChannels(String inChanneltype, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[OperationParam.chatChannelType.value] = inChanneltype;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.getSubscribedChannels, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Sends a potentially richer member chat message. By convention, content should contain a field named text for plain-text content. Returns the id of the message created.
  /// </summary>
  ///
  void postChatMessage(
      {required String inChannelId,
      required String inContentJson,
      bool inRecordInHistory = true,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = inChannelId;
    data[OperationParam.chatContent.value] = jsonDecode(inContentJson);
    data[OperationParam.chatRecordInHistory.value] = inRecordInHistory;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.postChatMessage, data, callback);
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
  //   content[OperationParam.chatText.Value] = in_plain;
  //   if (Util.isOptionalParameterValid(in_jsonRich)) {
  //     Map<String, dynamic> jsonRich = jsonDecode(in_jsonRich);
  //     content[OperationParam.chatRich.Value] = jsonRich;
  //   } else {
  //     Map<String, dynamic> jsonRich = jsonDecode("{}");
  //     content[OperationParam.chatRich.Value] = jsonRich;
  //   }

  //   data[OperationParam.chatChannelId.Value] = in_channelId;
  //   data[OperationParam.chatContent.Value] = content;
  //   data[OperationParam.chatRecordInHistory.Value] = in_recordInHistory;

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
      {required String inChannelId,
      required String inPlain,
      bool inRecordInHistory = true,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject}) {
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = inChannelId;
    data[OperationParam.chatText.value] = inPlain;
    data[OperationParam.chatRecordInHistory.value] = inRecordInHistory;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.chat,
        ServiceOperation.postChatMessageSimple, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Update the specified chat message. Message must have been from this user. Version provided must match (or pass -1 to bypass version enforcement).
  /// </summary>
  void updateChatMessage(
      String inChannelid,
      String inMessageid,
      int inVersion,
      String inContentjson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = <String, dynamic>{};

    data[OperationParam.chatChannelId.value] = inChannelid;
    data[OperationParam.chatMessageId.value] = inMessageid;
    data[OperationParam.chatVersion.value] = inVersion;
    data[OperationParam.chatContent.value] = jsonDecode(inContentjson);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.chat, ServiceOperation.updateChatMessage, data, callback);
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
  //   content[OperationParam.chatText.Value] = in_plain;
  //   if (Util.isOptionalParameterValid(in_jsonRich)) {
  //     Map<String, dynamic> jsonRich = jsonDecode(in_jsonRich);
  //     content[OperationParam.chatRich.Value] = jsonRich;
  //   } else {
  //     Map<String, dynamic> jsonRich = {};
  //     content[OperationParam.chatRich.Value] = jsonRich;
  //   }

  //   Map<String, dynamic> data = {};
  //   data[OperationParam.chatChannelId.Value] = in_channelId;
  //   data[OperationParam.chatMessageId.Value] = in_messageId;
  //   data[OperationParam.chatVersion.Value] = in_version;
  //   data[OperationParam.chatContent.Value] = content;

  //   ServerCallback? callback = BrainCloudClient.createServerCallback(
  //       success, failure,
  //       cbObject: cbObject);
  //   ServerCall sc = ServerCall(
  //       ServiceName.Chat, ServiceOperation.updateChatMessage, data, callback);
  //   _clientRef.sendRequest(sc);
  // }
}
