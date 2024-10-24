import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudScript {
  final BrainCloudClient _clientRef;

  BrainCloudScript(this._clientRef);

  /// Executes a script on the server.
  ///
  /// Service Name - Script
  /// Service Operation - Run
  ///
  /// @param scriptName
  /// The name of the script to be run
  ///
  /// @param jsonScriptData
  /// Data to be sent to the script in json format
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> runScript(
      {required String scriptName, Map<String, dynamic>? jsonScriptData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (jsonScriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = jsonScriptData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc =
        ServerCall(ServiceName.script, ServiceOperation.run, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Allows cloud script executions to be scheduled
  ///
  /// Service Name - Script
  /// Service Operation - ScheduleCloudScriptMillisUTC
  ///
  /// @param scriptName Name of script
  ///
  /// @param jsonScriptData JSON bundle to pass to script
  ///
  /// @param roundStartTimeUTC  use UTC time in milliseconds since epoch
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> scheduleRunScriptMillisUTC(
      {required String scriptName,
      Map<String, dynamic>? jsonScriptData,
      required int roundStartTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (jsonScriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = jsonScriptData;
    }

    data[OperationParam.scriptServiceStartDateUTC.value] =
        roundStartTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.scheduleCloudScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Allows cloud script executions to be scheduled
  ///
  /// Service Name - Script
  /// Service Operation - ScheduleCloudScript
  ///
  /// @param scriptName Name of script
  ///
  /// @param jsonScriptData JSON bundle to pass to script
  ///
  /// @param minutesFromNow Number of minutes from now to run script
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> scheduleRunScriptMinutes(
      {required String scriptName,
      Map<String, dynamic>? jsonScriptData,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (jsonScriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = jsonScriptData;
    }

    data[OperationParam.scriptServiceStartMinutesFromNow.value] =
        minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.scheduleCloudScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Run a cloud script in a parent app
  ///
  /// Service Name - Script
  /// Service Operation - RUN_PARENT_SCRIPT
  ///
  /// @param scriptName Name of script
  ///
  /// @param jsonScriptData JSON bundle to pass to script
  ///
  /// @param parentLevel The level name of the parent to run the script from
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> runParentScript(
      {required String scriptName,
      Map<String, dynamic>? jsonScriptData,
      required String parentLevel}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (jsonScriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = jsonScriptData;
    }

    data[OperationParam.scriptServiceParentLevel.value] = parentLevel;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.script, ServiceOperation.runParentScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Cancels a scheduled cloud code script
  ///
  /// Service Name - Script
  /// Service Operation - CANCEL_SCHEDULED_SCRIPT
  ///
  /// @param jobId ID of script job to cancel
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.cancelScheduledScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// get a scheduled cloud code script
  ///
  /// Service Name - Script
  /// Service Operation - GET_SCHEDULED_CLOUD_SCRIPTS
  ///
  /// @param startDateUTC ID of script job to cancel
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getScheduledCloudScripts(
      {required DateTime startDateUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceStartDateUTC.value] = startDateUTC;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.getScheduledCloudScripts, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// get a scheduled cloud code script
  ///
  /// Service Name - Script
  /// Service Operation - GET_RUNNING_OR_QUEUED_CLOUD_SCRIPTS
  ///
  /// @param startDateUTC ID of script job to cancel
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getRunningOrQueuedCloudScripts() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.getRunningOrQueuedCloudScripts, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Runs a script from the context of a peer
  ///
  /// Service Name - Script
  /// Service Operation - RUN_PEER_SCRIPT
  ///
  /// @param scriptNameThe name of the script to run
  ///
  /// @param jsonScriptDataJSON data to pass into the script
  ///
  /// @param peerIdentifies the peer
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> runPeerScript(
      {required String scriptName,
      Map<String, dynamic>? jsonScriptData,
      required String peer}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (jsonScriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = jsonScriptData;
    }

    data[OperationParam.peer.value] = peer;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.script, ServiceOperation.runPeerScript, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Runs a script asynchronously from the context of a peer
  /// This operation does not wait for the script to complete before returning
  ///
  /// Service Name - Script
  /// Service Operation - RUN_PEER_SCRIPT
  ///
  /// @param scriptNameThe name of the script to run
  ///
  /// @param jsonScriptDataJSON data to pass into the script
  ///
  /// @param peerIdentifies the peer
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> runPeerScriptAsync(
      {required String scriptName,
      Map<String, dynamic>? jsonScriptData,
      required String peer}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (jsonScriptData != null) {
      data[OperationParam.scriptServiceRunScriptData.value] = jsonScriptData;
    }

    data[OperationParam.peer.value] = peer;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.runPeerScriptAsync, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
