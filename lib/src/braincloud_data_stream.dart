import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudDataStream {
  final BrainCloudClient _clientRef;

  BrainCloudDataStream(this._clientRef);

  /// Creates custom data stream page event
  ///
  /// Service Name - DataStream
  /// Service Operation - CustomPageEvent
  ///
  /// @param eventName
  /// The name of the event
  ///
  /// @param jsonEventProperties
  /// The properties of the event
  ///
  /// returns Future<ServerResponse>
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
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customPageEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Creates custom data stream screen event
  ///
  /// Service Name - DataStream
  /// Service Operation - CustomScreenEvent
  ///
  /// @param eventName
  /// The name of the event
  ///
  /// @param jsonEventProperties
  /// The properties of the event
  ///
  /// returns Future<ServerResponse>
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
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customScreenEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Creates custom data stream track event
  ///
  /// Service Name - DataStream
  /// Service Operation - CustomTrackEvent
  ///
  /// @param eventName
  /// The name of the event
  ///
  /// @param jsonEventProperties
  /// The properties of the event
  ///
  /// returns Future<ServerResponse>
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
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customTrackEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Sends a crash report data
  ///
  /// Service Name - DataStream
  /// Service Operation - SubmitCrashReport
  ///
  /// @param crashType
  /// The type of the crash
  ///
  /// @param errorMsg
  /// The error message
  ///
  /// @param crashJson
  /// The data from the error
  ///
  /// @param crashLog
  /// The crash logs
  ///
  /// @param userName
  /// The user email
  ///
  /// @param userEmail
  /// The user email
  ///
  /// @param userNotes
  /// The notes related to the user
  ///
  /// @param userSubmitted
  /// The bool passed by the user
  ///
  /// returns Future<ServerResponse>
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
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.submitCrashReport, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }
}
