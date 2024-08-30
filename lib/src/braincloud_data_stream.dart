import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudDataStream {
  final BrainCloudClient _clientRef;

  BrainCloudDataStream(this._clientRef);

  /// <summary>
  /// Creates custom data stream page event
  /// </summary>
  /// <remarks>
  /// Service Name - DataStream
  /// Service Operation - CustomPageEvent
  /// </remarks>
  /// <param name="eventName">
  /// The name of the event
  /// </param>
  /// <param name="jsonEventProperties">
  /// The properties of the event
  /// </param>
  Future<ServerResponse> customPageEvent(
      {required String eventName, required String jsonEventProperties}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.dataStreamEventName.value] = eventName;

    if (Util.isOptionalParameterValid(jsonEventProperties)) {
      Map<String, dynamic> eventProperties = jsonDecode(jsonEventProperties);
      data[OperationParam.dataStreamEventProperties.value] = eventProperties;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customPageEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// <summary>
  /// Creates custom data stream screen event
  /// </summary>
  /// <remarks>
  /// Service Name - DataStream
  /// Service Operation - CustomScreenEvent
  /// </remarks>
  /// <param name="eventName">
  /// The name of the event
  /// </param>
  /// <param name="jsonEventProperties">
  /// The properties of the event
  /// </param>
  Future<ServerResponse> customScreenEvent(
      {required String eventName, required String jsonEventProperties}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.dataStreamEventName.value] = eventName;

    if (Util.isOptionalParameterValid(jsonEventProperties)) {
      Map<String, dynamic> eventProperties = jsonDecode(jsonEventProperties);
      data[OperationParam.dataStreamEventProperties.value] = eventProperties;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customScreenEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// <summary>
  /// Creates custom data stream track event
  /// </summary>
  /// <remarks>
  /// Service Name - DataStream
  /// Service Operation - CustomTrackEvent
  /// </remarks>
  /// <param name="eventName">
  /// The name of the event
  /// </param>
  /// <param name="jsonEventProperties">
  /// The properties of the event
  /// </param>
  Future<ServerResponse> customTrackEvent(
      {required String eventName, required String jsonEventProperties}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.dataStreamEventName.value] = eventName;

    if (Util.isOptionalParameterValid(jsonEventProperties)) {
      Map<String, dynamic> eventProperties = jsonDecode(jsonEventProperties);
      data[OperationParam.dataStreamEventProperties.value] = eventProperties;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.dataStream,
        ServiceOperation.customTrackEvent, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// <summary>
  /// Sends a crash report data
  /// </summary>
  /// <remarks>
  /// Service Name - DataStream
  /// Service Operation - SubmitCrashReport
  /// </remarks>
  /// <param name="crashType">
  /// The type of the crash
  /// </param>
  /// <param name="errorMsg">
  /// The error message
  /// </param>
  /// <param name="crashJson">
  /// The data from the error
  /// </param>
  /// <param name="crashLog">
  /// The crash logs
  /// </param>
  /// <param name="userName">
  /// The user email
  /// </param>
  /// <param name="userEmail">
  /// The user email
  /// </param>
  /// <param name="userNotes">
  /// The notes related to the user
  /// </param>
  /// <param name="userSubmitted">
  /// The bool passed by the user
  /// </param>
  Future<ServerResponse> submitCrashReport(
      {required String crashType,
      required String errorMsg,
      required String crashJson,
      required String crashLog,
      required String userName,
      required String userEmail,
      required String userNotes,
      required bool userSubmitted}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.dataStreamCrashType.value] = crashType;
    data[OperationParam.dataStreamErrorMsg.value] = errorMsg;
    Map<String, dynamic> crashInfo = jsonDecode(crashJson);
    data[OperationParam.dataStreamCrashInfo.value] = crashInfo;
    data[OperationParam.dataStreamCrashLog.value] = crashLog;
    data[OperationParam.dataStreamUserName.value] = userName;
    data[OperationParam.dataStreamUserEmail.value] = userEmail;
    data[OperationParam.dataStreamUserNotes.value] = userNotes;
    data[OperationParam.dataStreamUserSubmitted.value] = userSubmitted;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
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
