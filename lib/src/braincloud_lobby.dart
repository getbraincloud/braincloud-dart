// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import '/src/internal/http_pinger.dart';
import '/src/internal/relay_comms.dart'
    if (dart.library.js_interop) '/src/internal/relay_comms_web.dart';
import 'package:dart_ping/dart_ping.dart';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/reason_codes.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudLobby {
  final BrainCloudClient _clientRef;

  bool useHttps = false;
  Map<String, double> pingData = {};

  BrainCloudLobby(this._clientRef);

  /// Begins matchmaking to find a lobby matching the given parameters.
  /// Service Name - Lobby
  /// Service Operation - FindLobby
  ///
  /// @param in_lobbyType The type of lobby to search for
  /// @param in_rating The skill rating used for matchmaking
  /// @param in_maxSteps Maximum number of matchmaking steps
  /// @param in_jsonAlgo Matchmaking algorithm configuration
  /// @param in_jsonFilter Matchmaking filter criteria
  /// @param in_otherUserCxIds Other users to include in the lobby
  /// @param in_isReady Initial ready state of this user
  /// @param in_extraJson Initial extra data for this user
  /// @param in_teamCode Preferred team code, or empty for auto assignment
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> findLobby(
      {required String lobbyType,
      required int rating,
      required int maxSteps,
      required Map<String, dynamic> algo,
      Map<String, dynamic>? filterJson,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      List<String>? otherUserCxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbyMaxSteps.value] = maxSteps;
    data[OperationParam.lobbyAlgorithm.value] = algo;
    data[OperationParam.lobbyFilterJson.value] = filterJson;
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

  /// Begins matchmaking using ping data to select the best region.
  /// Service Name - Lobby
  /// Service Operation - FindLobbyWithPingData
  ///
  /// @param in_lobbyType The type of lobby to search for
  /// @param in_rating The skill rating used for matchmaking
  /// @param in_maxSteps Maximum number of matchmaking steps
  /// @param in_jsonAlgo Matchmaking algorithm configuration
  /// @param in_jsonFilter Matchmaking filter criteria
  /// @param in_otherUserCxIds Other users to include in the lobby
  /// @param in_isReady Initial ready state of this user
  /// @param in_extraJson Initial extra data for this user
  /// @param in_teamCode Preferred team code, or empty for auto assignment
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> findLobbyWithPingData(
      {required String lobbyType,
      required int rating,
      required int maxSteps,
      required Map<String, dynamic> algo,
      Map<String, dynamic>? filterJson,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      List<String>? otherUserCxids}) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbyMaxSteps.value] = maxSteps;
    data[OperationParam.lobbyAlgorithm.value] = algo;
    data[OperationParam.lobbyFilterJson.value] = filterJson;
    data[OperationParam.lobbyIsReady.value] = isReady;
    if (otherUserCxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = otherUserCxids;
    }
    data[OperationParam.lobbyExtraJson.value] = extraJson;
    data[OperationParam.lobbyTeamCode.value] = teamCode;

    return _attachPingDataAndSend(data, ServiceOperation.findLobbyWithPingData);
  }

  /// Creates a new lobby.
  /// Service Name - Lobby
  /// Service Operation - CreateLobby
  ///
  /// @param in_lobbyType The type of lobby to create
  /// @param in_rating The skill rating used for matchmaking
  /// @param in_otherUserCxIds Other users to add to the lobby
  /// @param in_isReady Initial ready state of this user
  /// @param in_extraJson Initial extra data for this user
  /// @param in_teamCode Preferred team code, or empty for auto assignment
  /// @param in_jsonSettings Configuration data for the lobby
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> createLobby(
      {required String lobbyType,
      required int rating,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      required Map<String, dynamic> settings,
      List<String>? otherUserCxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
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

  /// Creates a new lobby using collected ping data to select the best region.
  /// Service Name - Lobby
  /// Service Operation - CreateLobbyWithPingData
  ///
  /// @param in_lobbyType The type of lobby to create
  /// @param in_rating The skill rating used for matchmaking
  /// @param in_otherUserCxIds Other users to add to the lobby
  /// @param in_isReady Initial ready state of this user
  /// @param in_extraJson Initial extra data for this user
  /// @param in_teamCode Preferred team code, or empty for auto assignment
  /// @param in_jsonSettings Configuration data for the lobby
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> createLobbyWithPingData(
      {required String lobbyType,
      required int rating,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      required Map<String, dynamic> settings,
      List<String>? otherUserCxids}) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
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

  /// Finds or creates a lobby if none are available.
  /// Service Name - Lobby
  /// Service Operation - FindOrCreateLobby
  ///
  /// @param in_lobbyType The type of lobby
  /// @param in_rating The skill rating used for matchmaking
  /// @param in_maxSteps Maximum number of matchmaking steps
  /// @param in_jsonAlgo Matchmaking algorithm configuration
  /// @param in_jsonFilter Matchmaking filter criteria
  /// @param in_otherUserCxIds Other users to include in the lobby
  /// @param in_jsonSettings Configuration data for the lobby
  /// @param in_isReady Initial ready state of this user
  /// @param in_extraJson Initial extra data for this user
  /// @param in_teamCode Preferred team code, or empty for auto assignment
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> findOrCreateLobby(
      {required String lobbyType,
      required int rating,
      required int maxSteps,
      required Map<String, dynamic> algo,
      Map<String, dynamic>? filterJson,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      required Map<String, dynamic> settings,
      List<String>? otherUserCxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbyMaxSteps.value] = maxSteps;
    data[OperationParam.lobbyAlgorithm.value] = algo;
    data[OperationParam.lobbyFilterJson.value] = filterJson;
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

  /// Finds or creates a lobby using ping data.
  /// Service Name - Lobby
  /// Service Operation - FindOrCreateLobbyWithPingData
  ///
  /// @param in_lobbyType The type of lobby
  /// @param in_rating The skill rating used for matchmaking
  /// @param in_maxSteps Maximum number of matchmaking steps
  /// @param in_jsonAlgo Matchmaking algorithm configuration
  /// @param in_jsonFilter Matchmaking filter criteria
  /// @param in_otherUserCxIds Other users to include in the lobby
  /// @param in_jsonSettings Configuration data for the lobby
  /// @param in_isReady Initial ready state of this user
  /// @param in_extraJson Initial extra data for this user
  /// @param in_teamCode Preferred team code, or empty for auto assignment
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> findOrCreateLobbyWithPingData(
      {required String lobbyType,
      required int rating,
      required int maxSteps,
      required Map<String, dynamic> algo,
      Map<String, dynamic>? filterJson,
      required bool isReady,
      required Map<String, dynamic> extraJson,
      String? teamCode,
      required Map<String, dynamic> settings,
      List<String>? otherUserCxids}) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
    data[OperationParam.lobbyRating.value] = rating;
    data[OperationParam.lobbyMaxSteps.value] = maxSteps;
    data[OperationParam.lobbyAlgorithm.value] = algo;
    data[OperationParam.lobbyFilterJson.value] = filterJson;
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

  /// Retrieves full lobby data for the specified lobby.
  /// Service Name - Lobby
  /// Service Operation - GetLobbyData
  ///
  /// @param in_lobbyId The lobby identifier
  /// @return Future<ServerResponse>
  ///
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

  /// Updates the ready state and extra data for the caller.
  /// Service Name - Lobby
  /// Service Operation - UpdateReady
  ///
  /// @param in_lobbyId The lobby identifier
  /// @param in_isReady Updated ready state
  /// @param in_extraJson Updated extra data
  /// @return Future<ServerResponse>
  ///
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

  /// Updates the lobby settings.
  /// Service Name - Lobby
  /// Service Operation - UpdateSettings
  ///
  /// @param in_lobbyId The lobby identifier
  /// @param in_jsonSettings Updated lobby settings
  /// @return Future<ServerResponse>
  ///
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

  /// Switches the caller to a different team within the lobby.
  /// Service Name - Lobby
  /// Service Operation - SwitchTeam
  ///
  /// @param in_lobbyId The lobby identifier
  /// @param in_toTeamCode Target team code
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> switchTeam(
      {required String lobbyId, required String toTeamCode}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = lobbyId;
    data[OperationParam.lobbyToTeamName.value] = toTeamCode;

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

  /// Sends a signal to all lobby members.
  /// Service Name - Lobby
  /// Service Operation - SendSignal
  ///
  /// @param in_lobbyId The lobby identifier
  /// @param in_jsonSignalData Signal payload to send
  /// @return Future<ServerResponse>
  ///
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

  /// Joins the specified lobby.
  /// Service Name - Lobby
  /// Service Operation - JoinLobby
  ///
  /// @param in_lobbyId The lobby identifier
  /// @param in_isReady Initial ready state
  /// @param in_extraJson Initial extra data
  /// @param in_teamCode Preferred team code
  /// @param in_otherUserCxIds Other users to include
  /// @return Future<ServerResponse>
  ///
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

  /// Joins the specified lobby using ping data.
  /// Service Name - Lobby
  /// Service Operation - JoinLobbyWithPingData
  ///
  /// @param in_lobbyId The lobby identifier
  /// @param in_isReady Initial ready state
  /// @param in_extraJson Initial extra data
  /// @param in_teamCode Preferred team code
  /// @param in_otherUserCxIds Other users to include
  /// @return Future<ServerResponse>
  ///
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

  /// Leaves the specified lobby.
  /// Service Name - Lobby
  /// Service Operation - LeaveLobby
  ///
  /// @param in_lobbyId The lobby identifier
  /// @return Future<ServerResponse>
  ///
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

  /// Removes a member from the lobby. Caller must be the lobby owner.
  /// Service Name - Lobby
  /// Service Operation - RemoveMember
  ///
  /// @param in_lobbyId The lobby identifier
  /// @param in_cxId The cxId of the member to remove
  /// @return Future<ServerResponse>
  ///
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

  /// Cancels an active find, join, or search request for lobbies.
  ///
  /// @param in_lobbyType The lobby type associated with the request
  /// @param in_entryId The entry identifier returned from matchmaking
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> cancelFindRequest(
      {required String lobbyType, required String entryId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
    data[OperationParam.lobbyConnectionId.value] = _clientRef.rttConnectionID;
    data[OperationParam.entryId.value] = entryId;

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

  /// Retrieves the region settings for each of the given lobby types.
  /// Upon success, pingRegions should be called to collect ping data.
  /// Service Name - Lobby
  /// Service Operation - GetRegionsForLobbies
  ///
  /// @param in_roomTypes Ids of the lobby types
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getRegionsForLobbies(
      {required List<String> lobbyTypes}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyTypes.value] = lobbyTypes;

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

  /// Retrieves visible lobby instances matching the given criteria.
  /// Service Name - Lobby
  /// Service Operation - GET_LOBBY_INSTANCES
  ///
  /// @param in_lobbyType The type of lobby
  /// @param in_criteriaJson JSON filter criteria
  /// @return Future<ServerResponse>
  ///
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

  /// Retrieves visible lobby instances matching the given criteria using ping data.
  /// Service Name - Lobby
  /// Service Operation - GET_LOBBY_INSTANCES_WITH_PING_DATA
  ///
  /// @param in_lobbyType The type of lobby
  /// @param in_criteriaJson JSON filter criteria
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getLobbyInstancesWithPingData(
      {required String lobbyType, Map<String, dynamic>? criteriaJson}) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = lobbyType;
    data[OperationParam.lobbyCritera.value] = criteriaJson;

    return _attachPingDataAndSend(
        data, ServiceOperation.getLobbyInstancesWithPingData);
  }

  /// Retrieves associated ping data averages to be used with all
  /// Lobby APIs that support ping data.
  /// Must be called after getRegionsForLobbies completes successfully.
  ///
  /// @return Future<ServerResponse>
  ///
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
    /// returns `Future<ServerResponse>`
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
        _handlePingTimeResponse(
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
        _handlePingTimeResponse(pingTime, region);
      } else {
        _pingNextItemToProcess();
      }
    } on TimeoutException {
      _pingNextItemToProcess();
    }
  }

  void _handlePingTimeResponse(int responsetime, String region) {
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
