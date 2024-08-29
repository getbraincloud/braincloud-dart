import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudScript {
  final BrainCloudClient _clientRef;

  BrainCloudScript(this._clientRef);

  /// <summary>
  /// Executes a script on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - Run
  /// </remarks>
  /// <param name="scriptName">
  /// The name of the script to be run
  /// </param>
  /// <param name="jsonScriptData">
  /// Data to be sent to the script in json format
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void runScript(String scriptName, String jsonScriptData,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (Util.isOptionalParameterValid(jsonScriptData)) {
      Map<String, dynamic> scriptData = jsonDecode(jsonScriptData);
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc =
        ServerCall(ServiceName.script, ServiceOperation.run, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Allows cloud script executions to be scheduled
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - ScheduleCloudScriptMillisUTC
  /// </remarks>
  /// <param name="scriptName"> Name of script </param>
  /// <param name="jsonScriptData"> JSON bundle to pass to script </param>
  /// <param name="roundStartTimeUTC">  use UTC time in milliseconds since epoch </param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  void scheduleRunScriptMillisUTC(
      String scriptName,
      String jsonScriptData,
      int roundStartTimeUTC,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (Util.isOptionalParameterValid(jsonScriptData)) {
      Map<String, dynamic> scriptData = jsonDecode(jsonScriptData);
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.scriptServiceStartDateUTC.value] =
        roundStartTimeUTC.toUnsigned(64);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.scheduleCloudScript, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Allows cloud script executions to be scheduled
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - ScheduleCloudScript
  /// </remarks>
  /// <param name="scriptName"> Name of script </param>
  /// <param name="jsonScriptData"> JSON bundle to pass to script </param>
  /// <param name="minutesFromNow"> Number of minutes from now to run script </param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  void scheduleRunScriptMinutes(String scriptName, String jsonScriptData,
      int minutesFromNow, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (Util.isOptionalParameterValid(jsonScriptData)) {
      Map<String, dynamic> scriptData = jsonDecode(jsonScriptData);
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.scriptServiceStartMinutesFromNow.value] =
        minutesFromNow;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.scheduleCloudScript, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Run a cloud script in a parent app
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - RUN_PARENT_SCRIPT
  /// </remarks>
  /// <param name="scriptName"> Name of script </param>
  /// <param name="jsonScriptData"> JSON bundle to pass to script </param>
  /// <param name="parentLevel"> The level name of the parent to run the script from </param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  void runParentScript(String scriptName, String jsonScriptData,
      String parentLevel, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (Util.isOptionalParameterValid(jsonScriptData)) {
      Map<String, dynamic> scriptData = jsonDecode(jsonScriptData);
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.scriptServiceParentLevel.value] = parentLevel;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.script, ServiceOperation.runParentScript, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Cancels a scheduled cloud code script
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - CANCEL_SCHEDULED_SCRIPT
  /// </remarks>
  /// <param name="jobId"> ID of script job to cancel </param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  void cancelScheduledScript(
      String jobId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceJobId.value] = jobId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.cancelScheduledScript, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// get a scheduled cloud code script
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - GET_SCHEDULED_CLOUD_SCRIPTS
  /// </remarks>
  /// <param name="startDateUTC"> ID of script job to cancel </param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  void getScheduledCloudScripts(DateTime startDateUTC, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceStartDateUTC.value] = startDateUTC;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.getScheduledCloudScripts, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// get a scheduled cloud code script
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - GET_RUNNING_OR_QUEUED_CLOUD_SCRIPTS
  /// </remarks>
  /// <param name="startDateUTC"> ID of script job to cancel </param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  void getRunningOrQueuedCloudScripts(
      SuccessCallback? success, FailureCallback? failure) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.getRunningOrQueuedCloudScripts, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Runs a script from the context of a peer
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - RUN_PEER_SCRIPT
  /// </remarks>
  /// <param name="scriptName">The name of the script to run</param>
  /// <param name="jsonScriptData">JSON data to pass into the script</param>
  /// <param name="peer">Identifies the peer</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void runPeerScript(String scriptName, String jsonScriptData, String peer,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (Util.isOptionalParameterValid(jsonScriptData)) {
      Map<String, dynamic> scriptData = jsonDecode(jsonScriptData);
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.peer.value] = peer;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.script, ServiceOperation.runPeerScript, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Runs a script asynchronously from the context of a peer
  /// This operation does not wait for the script to complete before returning
  /// </summary>
  /// <remarks>
  /// Service Name - Script
  /// Service Operation - RUN_PEER_SCRIPT
  /// </remarks>
  /// <param name="scriptName">The name of the script to run</param>
  /// <param name="jsonScriptData">JSON data to pass into the script</param>
  /// <param name="peer">Identifies the peer</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void runPeerScriptAsync(String scriptName, String jsonScriptData, String peer,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.scriptServiceRunScriptName.value] = scriptName;

    if (Util.isOptionalParameterValid(jsonScriptData)) {
      Map<String, dynamic> scriptData = jsonDecode(jsonScriptData);
      data[OperationParam.scriptServiceRunScriptData.value] = scriptData;
    }

    data[OperationParam.peer.value] = peer;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.script,
        ServiceOperation.runPeerScriptAsync, data, callback);
    _clientRef.sendRequest(sc);
  }
}
