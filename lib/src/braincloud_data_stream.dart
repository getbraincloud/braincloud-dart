// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudDataStream {
  final BrainCloudClient _clientRef;

  BrainCloudDataStream(this._clientRef);

  /// Creates custom data stream page event
  ///
  /// @param eventName Name of event
  /// @param eventProperties Properties of event
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> customPageEvent(
      {required String eventName, Map<String, dynamic>? jsonEventProperties}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.dataStreamEventName.value] = eventName;

    if (jsonEventProperties != null) {
      data[OperationParam.dataStreamEventProperties.value] =
          jsonEventProperties;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customPageEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Creates custom data stream screen event
  ///
  /// @param eventName Name of event
  /// @param eventProperties Properties of event
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> customScreenEvent(
      {required String eventName, Map<String, dynamic>? jsonEventProperties}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.dataStreamEventName.value] = eventName;

    if (jsonEventProperties != null) {
      data[OperationParam.dataStreamEventProperties.value] =
          jsonEventProperties;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customScreenEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Creates custom data stream track event
  ///
  /// @param eventName Name of event
  /// @param eventProperties Properties of event
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> customTrackEvent(
      {required String eventName, Map<String, dynamic>? jsonEventProperties}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.dataStreamEventName.value] = eventName;

    if (jsonEventProperties != null) {
      data[OperationParam.dataStreamEventProperties.value] =
          jsonEventProperties;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customTrackEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Send crash report
  /// @param crashType
  /// @param errorMsg
  /// @param crashJson
  /// @param crashLog
  /// @param userName
  /// @param userEmail
  /// @param userNotes
  /// @param userSubmitted
  ///
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> submitCrashReport(
      {required String crashType,
      required String errorMsg,
      required Map<String, dynamic> crashJson,
      required String crashLog,
      required String userName,
      required String userEmail,
      required String userNotes,
      required bool userSubmitted}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.dataStreamCrashType.value] = crashType;
    data[OperationParam.dataStreamErrorMsg.value] = errorMsg;
    Map<String, dynamic> crashInfo = crashJson;
    data[OperationParam.dataStreamCrashInfo.value] = crashInfo;
    data[OperationParam.dataStreamCrashLog.value] = crashLog;
    data[OperationParam.dataStreamUserName.value] = userName;
    data[OperationParam.dataStreamUserEmail.value] = userEmail;
    data[OperationParam.dataStreamUserNotes.value] = userNotes;
    data[OperationParam.dataStreamUserSubmitted.value] = userSubmitted;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.submitCrashReport, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }
}
