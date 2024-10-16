// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/foundation.dart';
import 'package:mutex/mutex.dart';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/request_state.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudLobby {
  final BrainCloudClient _clientRef;

  bool useHttps = false;
  Map<String, double> pingData = {};

  BrainCloudLobby(this._clientRef);

  /// Finds a lobby matching the specified parameters

  ///
  /// @returns Future<ServerResponse>
  Future<ServerResponse> findLobby(
      {required String roomtype,
      required int rating,
      required int maxSteps,
      required Map<String, dynamic> algo,
      Map<String, dynamic>? filterjson,
      int? timeoutsecs,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      List<String>? otherUserCxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = roomtype;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbyMaxSteps.value] = maxSteps;
    data[OperationParam.lobbyAlgorithm.value] = algo;
    data[OperationParam.lobbyFilterJson.value] = filterjson;
    data[OperationParam.lobbyTimeoutSeconds.value] = timeoutsecs;
    data[OperationParam.lobbyIsReady.value] = isReady;
    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.findLobby, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finds a lobby matching the specified parameters WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  ///
  /// @returns Future<ServerResponse>
  Future<ServerResponse> findLobbyWithPingData(
      {required String roomType,
      required int rating,
      required int maxSteps,
      required Map<String, dynamic> algo,
      Map<String, dynamic>? filterJson,
      int? timeoutSecs,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      List<String>? otherUserCxids}) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = roomType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbyMaxSteps.value] = maxSteps;
    data[OperationParam.lobbyAlgorithm.value] = algo;
    data[OperationParam.lobbyFilterJson.value] = filterJson;
    data[OperationParam.lobbyTimeoutSeconds.value] = timeoutSecs;
    data[OperationParam.lobbyIsReady.value] = isReady;
    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;

    return _attachPingDataAndSend(data, ServiceOperation.findLobbyWithPingData);
  }

  /// Like findLobby, but explicitely geared toward creating new lobbies
  ///
  /// @returns Future<ServerResponse>
  Future<ServerResponse> createLobby(
      {required String roomType,
      required int rating,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      required Map<String, dynamic> settings,
      List<String>? otherUserCxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = roomType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbySettings.value] = settings;
    data[OperationParam.lobbyIsReady.value] = isReady;
    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.createLobby, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Like findLobby, but explicitely geared toward creating new lobbies WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  ///
  /// @returns Future<ServerResponse>
  Future<ServerResponse> createLobbyWithPingData(
      {required String roomType,
      required int rating,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      required Map<String, dynamic> settings,
      List<String>? otherUserCxids}) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = roomType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbySettings.value] = settings;
    data[OperationParam.lobbyIsReady.value] = isReady;
    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;

    return _attachPingDataAndSend(
      data,
      ServiceOperation.createLobbyWithPingData,
    );
  }

  /// Finds a lobby matching the specified parameters, or creates one
  ///
  /// @returns Future<ServerResponse>
  Future<ServerResponse> findOrCreateLobby(
      {required String roomType,
      required int rating,
      required int maxSteps,
      required Map<String, dynamic> algo,
      Map<String, dynamic>? filterJson,
      int? timeoutSecs,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      required Map<String, dynamic> settings,
      List<String>? otherUserCxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = roomType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbyMaxSteps.value] = maxSteps;
    data[OperationParam.lobbyAlgorithm.value] = algo;
    data[OperationParam.lobbyFilterJson.value] = filterJson;
    data[OperationParam.lobbyTimeoutSeconds.value] = timeoutSecs;
    data[OperationParam.lobbySettings.value] = settings;
    data[OperationParam.lobbyIsReady.value] = isReady;
    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.findOrCreateLobby, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finds a lobby matching the specified parameters, or creates one WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  Future<ServerResponse> findOrCreateLobbyWithPingData(
      {required String roomType,
      required int rating,
      required int maxSteps,
      required Map<String, dynamic> algo,
      Map<String, dynamic>? filterJson,
      int? timeoutSecs,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      required Map<String, dynamic> settings,
      List<String>? otherUserCxids}) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = roomType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbyMaxSteps.value] = maxSteps;
    data[OperationParam.lobbyAlgorithm.value] = algo;
    data[OperationParam.lobbyFilterJson.value] = filterJson;
    data[OperationParam.lobbyTimeoutSeconds.value] = timeoutSecs;
    data[OperationParam.lobbySettings.value] = settings;
    data[OperationParam.lobbyIsReady.value] = isReady;
    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;

    return _attachPingDataAndSend(
        data, ServiceOperation.findOrCreateLobbyWithPingData);
  }

  /// Gets data for the given lobby instance <lobbyId>.
  Future<ServerResponse> getLobbyData({required String lobbyId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.getLobbyData, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// updates the ready state of the player

  Future<ServerResponse> updateReady(
      {required String lobbyId,
      required bool isReady,
      required Map<String, dynamic> extraJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbyIsReady.value] = isReady;
    data[OperationParam.lobbyExtraJson.value] = extraJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.updateReady, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// valid only for the owner of the group -- edits the overally lobby config data
  Future<ServerResponse> updateSettings(
      {required String lobbyId, required Map<String, dynamic> settings}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbySettings.value] = settings;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.updateSettings, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// switches to the specified team (if allowed). Note - may be blocked by cloud code script
  Future<ServerResponse> switchTeam(
      {required String lobbyId, required String toTeamName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbyToTeamName.value] = toTeamName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.switchTeam, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// sends LOBBY_SIGNAL_DATA message to all lobby members
  Future<ServerResponse> sendSignal(
      {required String lobbyId, required Map<String, dynamic> signalData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbySignalData.value] = signalData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.sendSignal, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// User joins the specified lobby.
  Future<ServerResponse> joinLobby(
      {required String lobbyId,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      List<String>? otherUserCxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbyIsReady.value] = isReady;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.joinLobby, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// User joins the specified lobby WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  Future<ServerResponse> joinLobbyWithPingData(
      {required String lobbyId,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      List<String>? otherUserCxids}) {
    Map<String, dynamic> data = {};

    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbyIsReady.value] = isReady;
    return _attachPingDataAndSend(data, ServiceOperation.joinLobbyWithPingData);
  }

  /// User leaves the specified lobby. if the user was the owner, a new owner will be chosen
  Future<ServerResponse> leaveLobby({required String lobbyId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.leaveLobby, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Only valid from the owner of the lobby -- removes the specified member from the lobby
  Future<ServerResponse> removeMember(
      {required String lobbyId, required String inConnectionid}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbyConnectionId.value] = inConnectionid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.removeMember, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Cancel this members Find, Join and Searching of Lobbies
  Future<ServerResponse> cancelFindRequest({required String roomType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = roomType;
    data[OperationParam.lobbyConnectionId.value] = _clientRef.rttConnectionID;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.cancelFindRequest, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the region settings for each of the given lobby types. Upon SuccessCallback or afterwards, call PingRegions to start retrieving appropriate data.
  /// Once that completes, the associated region Ping Data is retrievable via PingData and all associated <>WithPingData APIs are useable
  Future<ServerResponse> getRegionsForLobbies(
      {required List<String> roomTypes}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyTypes.value] = roomTypes;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) {
      _onRegionForLobbiesSuccess(response, null);
      completer.complete(ServerResponse.fromJson(response));
    },
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.lobby,
        ServiceOperation.getRegionsForLobbies, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets a map keyed by rating of the visible lobby instances matching the given type and rating range.
  /// any ping data provided in the criteriaJson will be ignored.
  ///
  /// Service Name - Lobby
  /// Service Operation - GetLobbyInstances
  ///
  /// @param lobbyType The type of lobby to look for.
  ///
  /// @param criteriaJson A JSON object used to describe filter criteria.
  Future<ServerResponse> getLobbyInstances(
      {required String lobbyType, Map<String, dynamic>? criteriaJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
    data[OperationParam.lobbyCritera.value] = criteriaJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.getLobbyInstances, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets a map keyed by rating of the visible lobby instances matching the given type and rating range.
  /// Only lobby instances in the regions that satisfy the ping portion of the criteriaJson (based on the values provided in pingData) will be returned.
  ///
  /// Service Name - Lobby
  /// Service Operation - GetLobbyInstancesWithPingData
  ///
  /// @param lobbyType The type of lobby to look for.
  /// @param criteriaJson A JSON object used to describe filter criteria.
  Future<ServerResponse> getLobbyInstancesWithPingData(
      {required String lobbyType, Map<String, dynamic>? criteriaJson}) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
    data[OperationParam.lobbyCritera.value] = criteriaJson;

    return _attachPingDataAndSend(
        data, ServiceOperation.getLobbyInstancesWithPingData);
  }

  /// Retrieves associated PingData averages to be used with all associated <>WithPingData APIs.
  /// Call anytime after GetRegionsForLobbies before proceeding.
  Future<ServerResponse> pingRegions() {
    Completer<ServerResponse> completer = Completer();

    if (_pingRegionSuccessCallback != null) {
      _queueFailure(
          (statusCode, reasonCode, statusMessage) => completer.complete(
              ServerResponse(
                  statusCode: statusCode,
                  reasonCode: reasonCode,
                  statusMessage: statusMessage)),
          ReasonCodes.missingRequiredParameter,
          "Ping is already happening.");
    }

    pingData = {};

    // Now we have the region ping data, we can start pinging each region and its defined target
    Map<String, dynamic> regionInner;
    if (_regionPingData.isNotEmpty) {
      _pingRegionSuccessCallback = (response) => completer.complete(response);

      _regionPingData.forEach((key, value) {
        _cachedPingResponses[key] = [];
        regionInner = value;
        RegionTarget regionTarget = RegionTarget(
            region: key,
            target: regionInner["target"].toString(),
            type: regionInner.containsKey("type")
                ? regionInner["type"].toString().toUpperCase()
                : RegionTarget.pingType);

        _regionTargetsToProcessLock.acquire();
        try {
          for (int i = 0; i < maxPingCalls; ++i) {
            _regionTargetsToProcess.add(regionTarget);
          }
        } finally {
          _regionTargetsToProcessLock.release();
        }
      });

      _pingNextItemToProcess();
    } else {
      _queueFailure(
          (statusCode, reasonCode, statusMessage) => completer.complete(
              ServerResponse(
                  statusCode: statusCode,
                  reasonCode: reasonCode,
                  statusMessage: statusMessage)),
          ReasonCodes.missingRequiredParameter,
          "No Regions to Ping. Please call GetRegionsForLobbies and await the response before calling PingRegions.");
    }

    return completer.future;
  }

  void _pingNextItemToProcess() {
    _regionTargetsToProcessLock.acquire();
    try {
      if (_regionTargetsToProcess.isNotEmpty) {
        RegionTarget regionTarget = _regionTargetsToProcess[0];
        _regionTargetsToProcess.removeAt(0);
        _pingHost(regionTarget);

        return;
      } else if (_regionPingData.length == pingData.length &&
          _pingRegionSuccessCallback != null) {
        String pingStr = _clientRef.serializeJson(pingData);

        if (_clientRef.loggingEnabled) {
          _clientRef.log("PINGS: $pingStr");
        }

        _pingRegionSuccessCallback!(
            ServerResponse(statusCode: 200, data: pingData));

        _pingRegionSuccessCallback = null;

        return;
      }
    } finally {
      _regionTargetsToProcessLock.release();
    }

    _pingRegionSuccessCallback = null;
  }

  Future<ServerResponse> _attachPingDataAndSend(
    Map<String, dynamic> inData,
    ServiceOperation inOperation,
  ) {
    Completer<ServerResponse> completer = Completer();
    bool hasPingData = pingData.isNotEmpty;
    if (hasPingData) {
      inData[OperationParam.pingData.value] = pingData;

      ServerCallback? callback = BrainCloudClient.createServerCallback(
          (response) => completer.complete(ServerResponse.fromJson(response)),
          (statusCode, reasonCode, statusMessage) => completer.complete(
              ServerResponse(
                  statusCode: statusCode,
                  reasonCode: reasonCode,
                  statusMessage: statusMessage)));

      ServerCall sc =
          ServerCall(ServiceName.lobby, inOperation, inData, callback);
      _clientRef.sendRequest(sc);
    } else {
      _queueFailure(
          (statusCode, reasonCode, statusMessage) => completer.complete(
              ServerResponse(
                  statusCode: statusCode,
                  reasonCode: reasonCode,
                  statusMessage: statusMessage)),
          ReasonCodes.missingRequiredParameter,
          "Processing exception (message): Required message parameter 'pingData' is missing.  Please ensure PingData exists by first calling GetRegionsForLobbies and PingRegions, and waiting for response before proceeding.");
    }

    return completer.future;
  }

  void _queueFailure(
      FailureCallback? inFailure, int reasonCode, String statusMessage) {
    if (inFailure != null) {
      Map<String, dynamic> jsonError = {};
      jsonError["reason_code"] = reasonCode;
      jsonError["status"] = 400;
      jsonError["status_message"] = statusMessage;
      jsonError["severity"] = "ERROR";

      Failure failure = Failure(
          callback: inFailure,
          status: 400,
          reasonCode: reasonCode,
          jsonError: _clientRef.serializeJson(jsonError));

      _failureQueue.add(failure);
    }
  }

  void update() {
    // trigger failure events
    for (int i = 0; i < _failureQueue.length; ++i) {
      Failure failure = _failureQueue[i];
      failure.callback!(failure.status, failure.reasonCode, failure.jsonError);
    }
    _failureQueue.clear();
  }

  void _onRegionForLobbiesSuccess(Map<String, dynamic> inJson, dynamic inObj) {
    pingData = {};

    Map<String, dynamic> data = inJson["data"];
    _regionPingData = data["regionPingData"];
    //lobbyTypeRegions = data["lobbyTypeRegions"];
  }

  void _pingHost(RegionTarget inRegionTarget) {
    if (inRegionTarget.isHttpType()) {
      _handleHTTPResponse(inRegionTarget.region, inRegionTarget.target);
    } else {
      _handlePingReponse(inRegionTarget.region, inRegionTarget.target);
    }
  }

  void _handlePingReponse(String region, String target) async {
    debugPrint("Redion: $region - Target: $target");

    final response = await Ping(target, count: 1, timeout: 10000).stream.first;

    if (response.error == null) {
      handlePingTimeResponse(
          response.response?.time?.inMilliseconds ?? 0, region);
    } else {
      _pingNextItemToProcess();
    }

    // try
    // {
    //     pinger.PingCompleted += (o, response) =>
    //     {
    //         if (response.Error == null && response.Reply.Status == IPStatus.Success)
    //         {
    //             handlePingTimeResponse(response.Reply.RoundtripTime, in_region);
    //         }
    //         else
    //         {
    //             _pingNextItemToProcess();
    //         }
    //     };

    //     pinger.SendPingAsync(in_target, 10000);
    // }
    // catch (Exception) { }
    // finally
    // {
    //     pinger?.Dispose();
    // }
  }

  void _handleHTTPResponse(String region, String target) async {
    if (!target.startsWith("http")) {
      target = (useHttps ? "https://" : "http://") + target;
    }

    DateTime roundtripTime = DateTime.now().toUtc();
    WebRequest request = WebRequest(region, Uri.parse(target));

    await request.send();

    if (request.isDone && request.error!.isEmpty) {
      handlePingTimeResponse(
          DateTime.now().toUtc().difference(roundtripTime).inMilliseconds,
          region);
    } else {
      _pingNextItemToProcess();
    }
  }

//         private IEnumerator HandlePingReponse(String in_region, String in_target)
//         {
//             if (!m_regionTargetIPs.containsKey(in_target))
//             {
//                 IPHostEntry host = Dns.GetHostEntry(in_target);
//                 foreach (IPAddress addresses in host.AddressList)
//                 {
//                     if (addresses.AddressFamily == AddressFamily.InterNetwork)
//                     {
//                         m_regionTargetIPs.Add(in_target, addresses.toString());
//                         break;
//                     }
//                 }
//             }

//             if (m_regionTargetIPs.containsKey(in_target))
//             {
//                 DateTime ttl = DateTime.UtcNow;
//                 UnityEngine.Ping ping = new UnityEngine.Ping(m_regionTargetIPs[in_target]);
//                 while (!ping.isDone && (DateTime.UtcNow - ttl).TotalMilliseconds < 10000)
//                 {
//                     yield return null;
//                 }

//                 if (ping.isDone && ping.time > 0)
//                 {
//                     handlePingTimeResponse(ping.time, in_region);
//                 }
//                 else
//                 {
//                     _pingNextItemToProcess();
//                 }

//                 ping.DestroyPing();
//             }
//             else
//             {
//                 _pingNextItemToProcess();
//             }
//         }
// #endif

  void handlePingTimeResponse(int responsetime, String region) {
    var regions = _cachedPingResponses[region];

    regions?.add(responsetime);
    if (regions != null) {
      if (regions.length == maxPingCalls) {
        int totalAccumulated = 0;
        int highestValue = 0;
        for (var pingResponse in regions) {
          totalAccumulated += pingResponse;
          if (pingResponse > highestValue) {
            highestValue = pingResponse;
          }
        }

        // accumulated ALL, now subtract the highest value
        totalAccumulated -= highestValue;
        pingData[region] = totalAccumulated / (region.length - 1);
      }
    }

    _pingNextItemToProcess();
  }

  Map<String, dynamic> _regionPingData = {};
  //Map<String, dynamic> _lobbyTypeRegions = {};
  final Map<String, List<int>> _cachedPingResponses = {};

  final List<RegionTarget> _regionTargetsToProcess = [];
  final Mutex _regionTargetsToProcessLock = Mutex();
  void Function(ServerResponse)? _pingRegionSuccessCallback;

// #if !DOT_NET || GODOT
//         private Dictionary<String, String> m_regionTargetIPs = new Dictionary<String, String>();
// #endif

  static const int maxPingCalls = 4;

  final List<Failure> _failureQueue = [];
}

class Failure {
  FailureCallback? callback;
  int status;
  int reasonCode;
  String jsonError;

  Failure(
      {this.callback,
      required this.status,
      required this.reasonCode,
      required this.jsonError});
}

class RegionTarget {
  static const String pingType = "PING";
  static const String httpType = "HTTP";

  String region;
  String target;
  String type;

  bool isPingType() => type == pingType;
  bool isHttpType() => type == httpType;

  RegionTarget(
      {required this.region, required this.target, required this.type});
}
