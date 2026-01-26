// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudScript {
  final BrainCloudClient _clientRef;

  BrainCloudScript(this._clientRef);

  /// Executes a script on the server.
  /// Service Name - Script
  /// Service Operation - Run
  ///
  /// @param in_scriptName The name of the script to be run
  /// @param in_jsonScriptData Data to be sent to the script in json format
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> runScript(
      {required String scriptName, Map<String, dynamic>? scriptData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (scriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc =
        ServerCall(ServiceName.script, ServiceOperation.run, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Allows cloud script executions to be scheduled - UTC time
  /// Service Name - Script
  /// Service Operation - ScheduleCloudScript
  ///
  /// @param in_scriptName The name of the script to be run
  /// @param in_jsonScriptData Data to be sent to the script in json format
  /// @param in_startDateInUTC The start date in UTC
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> scheduleRunScriptMillisUTC(
      {required String scriptName,
      Map<String, dynamic>? scriptData,
      required int startDateUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (scriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.scriptServiceStartDateUTC.value] =
        startDateUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.scheduleCloudScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Allows cloud script executions to be scheduled
  /// Service Name - Script
  /// Service Operation - ScheduleCloudScript
  ///
  /// @param in_scriptName The name of the script to be run
  /// @param in_jsonScriptData Data to be sent to the script in json format
  /// @param in_minutesFromNow Number of minutes from now to run script
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> scheduleRunScriptMinutes(
      {required String scriptName,
      Map<String, dynamic>? scriptData,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (scriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.scriptServiceStartMinutesFromNow.value] =
        minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.scheduleCloudScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Run a cloud script in a parent app
  /// Service Name - Script
  /// Service Operation - RUN_PARENT_SCRIPT
  ///
  /// @param in_scriptName The name of the script to be run
  /// @param in_scriptData Data to be sent to the script in json format
  /// @param in_parentLevel The level name of the parent to run the script from
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> runParentScript(
      {required String scriptName,
      Map<String, dynamic>? scriptData,
      required String parentLevel}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (scriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.scriptServiceParentLevel.value] = parentLevel;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.script, ServiceOperation.runParentScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Cancels a scheduled cloud code script
  /// Service Name - Script
  /// Service Operation - CANCEL_SCHEDULED_SCRIPT
  ///
  /// @param in_jobId ID of script job to cancel
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> cancelScheduledScript({required String jobId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceJobId.value] = jobId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.cancelScheduledScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Cancels a scheduled cloud code script
  /// Service Name - Script
  /// Service Operation - CANCEL_SCHEDULED_SCRIPT
  ///
  /// @param in_jobId ID of script job to cancel
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getScheduledCloudScripts(
      {required DateTime startDateUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceStartDateUTC.value] =
        startDateUTC.millisecondsSinceEpoch;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.getScheduledCloudScripts, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Cancels a scheduled cloud code script
  /// Service Name - Script
  /// Service Operation - CANCEL_SCHEDULED_SCRIPT
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getRunningOrQueuedCloudScripts() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.getRunningOrQueuedCloudScripts, {}, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Runs a script from the context of a peer
  /// Service Name - Script
  /// Service Operation - RUN_PEER_SCRIPT
  ///
  /// @param in_scriptName The name of the script to be run
  /// @param in_jsonScriptData Data to be sent to the script in json format
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> runPeerScript(
      {required String scriptName,
      Map<String, dynamic>? scriptData,
      required String peer}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (scriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.peer.value] = peer;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.script, ServiceOperation.runPeerScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Runs a script asynchronously from the context of a peer
  /// This method does not wait for the script to complete before returning
  /// Service Name - Script
  /// Service Operation - RUN_PEER_SCRIPT_ASYNC
  ///
  /// @param in_scriptName The name of the script to be run
  /// @param in_jsonScriptData Data to be sent to the script in json format
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> runPeerScriptAsync(
      {required String scriptName,
      Map<String, dynamic>? scriptData,
      required String peer}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (scriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.peer.value] = peer;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.runPeerScriptAsync, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
