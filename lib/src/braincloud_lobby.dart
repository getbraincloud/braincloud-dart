// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/internal/http_pinger.dart';
import 'package:braincloud_dart/src/internal/relay_comms.dart';
import 'package:dart_ping/dart_ping.dart';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
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
  /// returns Future<ServerResponse>
  Future<ServerResponse> findLobby(
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
    Completer<ServerResponse> completer = Completer();
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

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.findLobby, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finds a lobby matching the specified parameters WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  ///
  /// returns Future<ServerResponse>
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
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.createLobby, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Like findLobby, but explicitely geared toward creating new lobbies WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  ///
  /// returns Future<ServerResponse>
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
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.findOrCreateLobby, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finds a lobby matching the specified parameters, or creates one WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.getLobbyData, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// updates the ready state of the player
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.updateReady, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// valid only for the owner of the group -- edits the overally lobby config data
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.updateSettings, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// switches to the specified team (if allowed). Note - may be blocked by cloud code script
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.switchTeam, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// sends LOBBY_SIGNAL_DATA message to all lobby members
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.sendSignal, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// User joins the specified lobby.
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.joinLobby, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// User joins the specified lobby WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.leaveLobby, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Only valid from the owner of the lobby -- removes the specified member from the lobby
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> removeMember(
      {required String lobbyId, required String connectionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbyConnectionId.value] = connectionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.removeMember, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Cancel this members Find, Join and Searching of Lobbies
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.cancelFindRequest, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the region settings for each of the given lobby types. Upon SuccessCallback or afterwards, call PingRegions to start retrieving appropriate data.
  /// Once that completes, the associated region Ping Data is retrievable via PingData and all associated <>WithPingData APIs are useable
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
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
  ///
  /// returns Future<ServerResponse>
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
                error: statusMessage)));
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
  ///
  /// @param criteriaJson A JSON object used to describe filter criteria.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> pingRegions() {
    Completer<ServerResponse> completer = Completer();

    if (_pingRegionSuccessCallback != null) {
      _queueFailure(
          (statusCode, reasonCode, statusMessage) => completer.complete(
              ServerResponse(
                  statusCode: statusCode,
                  reasonCode: reasonCode,
                  error: statusMessage)),
          ReasonCodes.missingRequiredParameter,
          "Ping is already happening.");
    }

    pingData = {};

    /// Now we have the region ping data, we can start pinging each region and its defined target
    ///
    /// returns Future<ServerResponse>
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

        for (int i = 0; i < maxPingCalls; ++i) {
          _regionTargetsToProcess.add(regionTarget);
        }
      });

      _pingNextItemToProcess();
    } else {
      _queueFailure(
          (statusCode, reasonCode, statusMessage) => completer.complete(
              ServerResponse(
                  statusCode: statusCode,
                  reasonCode: reasonCode,
                  error: statusMessage)),
          ReasonCodes.missingRequiredParameter,
          "No Regions to Ping. Please call GetRegionsForLobbies and await the response before calling PingRegions.");
    }

    return completer.future;
  }

  void _pingNextItemToProcess() {
    var returnEarly = false;
    try {
      if (_regionTargetsToProcess.isNotEmpty) {
        RegionTarget regionTarget = _regionTargetsToProcess[0];
        _regionTargetsToProcess.removeAt(0);
        _pingHost(regionTarget);

        returnEarly = true;
      } else if (_regionPingData.length == pingData.length &&
          _pingRegionSuccessCallback != null) {
        if (_clientRef.loggingEnabled) {
          _clientRef.log("PINGS: $pingData");
        }

        _pingRegionSuccessCallback!(
            ServerResponse(statusCode: 200, data: pingData));

        _pingRegionSuccessCallback = null;

        returnEarly = true;
      }
    } finally {
      if (returnEarly == true) {
        return;
      }
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
                  error: statusMessage)));

      ServerCall sc =
          ServerCall(ServiceName.lobby, inOperation, inData, callback);
      _clientRef.sendRequest(sc);
    } else {
      _queueFailure(
          (statusCode, reasonCode, statusMessage) => completer.complete(
              ServerResponse(
                  statusCode: statusCode,
                  reasonCode: reasonCode,
                  error: statusMessage)),
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
          jsonError: jsonEncode(jsonError));

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
    //_lobbyTypeRegions = data["lobbyTypeRegions"];
  }

  void _pingHost(RegionTarget inRegionTarget) {
    if (kIsWeb || inRegionTarget.isHttpType()) {
      _handleHTTPPing(inRegionTarget.region, inRegionTarget.target);
    } else {
      _handleICMPPing(inRegionTarget.region, inRegionTarget.target);
    }
  }

  void _handleICMPPing(String region, String target) async {
    print("Region: $region - Target: $target");

    var ping = Ping(target, count: 1, timeout: 10); // timeout is in seconds
    ping.stream.listen((event) {
      if (event.response != null) {
        handlePingTimeResponse(
            event.response?.time?.inMilliseconds ?? 0, region);
      }
      ping.stop();
    }).onError((error) {
      _pingNextItemToProcess();
    });
  }

  void _handleHTTPPing(String region, String target) async {
    if (!target.startsWith("http")) {
      target = (useHttps ? "https://" : "http://") + target;
    }

    HttpPigner request = HttpPigner(Uri.parse(target));

    try {
      // await request.send().timeout(Duration(seconds: 10));
      int pingTime = await request.ping();
      if (request.isDone && request.error.isEmpty) {
        handlePingTimeResponse(pingTime,region);
      } else {
        _pingNextItemToProcess();
      }
    } on TimeoutException {
      _pingNextItemToProcess();
    }
  }

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
  void Function(ServerResponse)? _pingRegionSuccessCallback;

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
