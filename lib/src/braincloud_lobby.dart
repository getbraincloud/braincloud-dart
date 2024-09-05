import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:mutex/mutex.dart';

class BrainCloudLobby {
  final BrainCloudClient _clientRef;

  bool useHttps = false;
  Map<String, double> pingData = {};

  BrainCloudLobby(this._clientRef);

  /// <summary>
  /// Finds a lobby matching the specified parameters
  /// </summary>
  ///
  Future<ServerResponse> findLobby(
      {required String inRoomtype,
      required int inRating,
      required int inMaxsteps,
      required Map<String, dynamic> inAlgo,
      required Map<String, dynamic> inFilterjson,
      required int inTimeoutsecs,
      required bool inIsready,
      required Map<String, dynamic> inExtrajson,
      required String inTeamcode,
      List<String>? inOtherusercxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inRoomtype;
    data[OperationParam.lobbyRating.value] = inRating;
    data[OperationParam.lobbyMaxSteps.value] = inMaxsteps;
    data[OperationParam.lobbyAlgorithm.value] = inAlgo;
    data[OperationParam.lobbyFilterJson.value] = inFilterjson;
    data[OperationParam.lobbyTimeoutSeconds.value] = inTimeoutsecs;
    data[OperationParam.lobbyIsReady.value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = inOtherusercxids;
    }
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;
    data[OperationParam.lobbyTeamCode.value] = inTeamcode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
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

  /// <summary>
  /// Finds a lobby matching the specified parameters WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  /// </summary>
  ///
  Future<ServerResponse> findLobbyWithPingData(
      {required String inRoomtype,
      required int inRating,
      required int inMaxsteps,
      required Map<String, dynamic> inAlgo,
      required Map<String, dynamic> inFilterjson,
      required int inTimeoutsecs,
      required bool inIsready,
      required Map<String, dynamic> inExtrajson,
      required String inTeamcode,
      List<String>? inOtherusercxids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inRoomtype;
    data[OperationParam.lobbyRating.value] = inRating;
    data[OperationParam.lobbyMaxSteps.value] = inMaxsteps;
    data[OperationParam.lobbyAlgorithm.value] = inAlgo;
    data[OperationParam.lobbyFilterJson.value] = inFilterjson;
    data[OperationParam.lobbyTimeoutSeconds.value] = inTimeoutsecs;
    data[OperationParam.lobbyIsReady.value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = inOtherusercxids;
    }
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;
    data[OperationParam.lobbyTeamCode.value] = inTeamcode;

    _attachPingDataAndSend(
      data,
      ServiceOperation.findLobbyWithPingData,
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );

    return completer.future;
  }

  /// <summary>
  /// Like findLobby, but explicitely geared toward creating new lobbies
  /// </summary>
  ///
  void createLobby(
      String inRoomtype,
      int inRating,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      Map<String, dynamic> inSettings,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inRoomtype;
    data[OperationParam.lobbyRating.value] = inRating;
    data[OperationParam.lobbySettings.value] = inSettings;
    data[OperationParam.lobbyIsReady.value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = inOtherusercxids;
    }
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;
    data[OperationParam.lobbyTeamCode.value] = inTeamcode;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.createLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Like findLobby, but explicitely geared toward creating new lobbies WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  /// </summary>
  ///
  void createLobbyWithPingData(
      String inRoomtype,
      int inRating,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      Map<String, dynamic> inSettings,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inRoomtype;
    data[OperationParam.lobbyRating.value] = inRating;
    data[OperationParam.lobbySettings.value] = inSettings;
    data[OperationParam.lobbyIsReady.value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = inOtherusercxids;
    }
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;
    data[OperationParam.lobbyTeamCode.value] = inTeamcode;
    _attachPingDataAndSend(
        data, ServiceOperation.createLobbyWithPingData, success, failure);
  }

  /// <summary>
  /// Finds a lobby matching the specified parameters, or creates one
  /// </summary>
  ///
  void findOrCreateLobby(
      String inRoomtype,
      int inRating,
      int inMaxsteps,
      Map<String, dynamic> inAlgo,
      Map<String, dynamic> inFilterjson,
      int inTimeoutsecs,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      Map<String, dynamic> inSettings,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inRoomtype;
    data[OperationParam.lobbyRating.value] = inRating;
    data[OperationParam.lobbyMaxSteps.value] = inMaxsteps;
    data[OperationParam.lobbyAlgorithm.value] = inAlgo;
    data[OperationParam.lobbyFilterJson.value] = inFilterjson;
    data[OperationParam.lobbyTimeoutSeconds.value] = inTimeoutsecs;
    data[OperationParam.lobbySettings.value] = inSettings;
    data[OperationParam.lobbyIsReady.value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = inOtherusercxids;
    }
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;
    data[OperationParam.lobbyTeamCode.value] = inTeamcode;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.findOrCreateLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Finds a lobby matching the specified parameters, or creates one WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  /// </summary>
  ///
  void findOrCreateLobbyWithPingData(
      String inRoomtype,
      int inRating,
      int inMaxsteps,
      Map<String, dynamic> inAlgo,
      Map<String, dynamic> inFilterjson,
      int inTimeoutsecs,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      Map<String, dynamic> inSettings,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inRoomtype;
    data[OperationParam.lobbyRating.value] = inRating;
    data[OperationParam.lobbyMaxSteps.value] = inMaxsteps;
    data[OperationParam.lobbyAlgorithm.value] = inAlgo;
    data[OperationParam.lobbyFilterJson.value] = inFilterjson;
    data[OperationParam.lobbyTimeoutSeconds.value] = inTimeoutsecs;
    data[OperationParam.lobbySettings.value] = inSettings;
    data[OperationParam.lobbyIsReady.value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = inOtherusercxids;
    }
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;
    data[OperationParam.lobbyTeamCode.value] = inTeamcode;

    _attachPingDataAndSend(
        data, ServiceOperation.findOrCreateLobbyWithPingData, success, failure);
  }

  /// <summary>
  /// Gets data for the given lobby instance <lobbyId>.
  /// </summary>
  void getLobbyData(
      String inLobbyid, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.getLobbyData, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// updates the ready state of the player
  /// </summary>
  void updateReady(
      String inLobbyid,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;
    data[OperationParam.lobbyIsReady.value] = inIsready;
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.updateReady, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// valid only for the owner of the group -- edits the overally lobby config data
  /// </summary>
  void updateSettings(String inLobbyid, Map<String, dynamic> inSettings,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;
    data[OperationParam.lobbySettings.value] = inSettings;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.updateSettings, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// switches to the specified team (if allowed). Note - may be blocked by cloud code script
  /// </summary>
  void switchTeam(String inLobbyid, String inToteamname,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;
    data[OperationParam.lobbyToTeamName.value] = inToteamname;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.switchTeam, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// sends LOBBY_SIGNAL_DATA message to all lobby members
  /// </summary>
  void sendSignal(String inLobbyid, Map<String, dynamic> inSignaldata,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;
    data[OperationParam.lobbySignalData.value] = inSignaldata;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.sendSignal, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// User joins the specified lobby.
  /// </summary>
  void joinLobby(
      String inLobbyid,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};

    if (inOtherusercxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = inOtherusercxids;
    }
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;
    data[OperationParam.lobbyTeamCode.value] = inTeamcode;
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;
    data[OperationParam.lobbyIsReady.value] = inIsready;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.joinLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// User joins the specified lobby WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  /// </summary>
  void joinLobbyWithPingData(
      String inLobbyid,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};

    if (inOtherusercxids != null) {
      data[OperationParam.lobbyOtherUserCxIds.value] = inOtherusercxids;
    }
    data[OperationParam.lobbyExtraJson.value] = inExtrajson;
    data[OperationParam.lobbyTeamCode.value] = inTeamcode;
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;
    data[OperationParam.lobbyIsReady.value] = inIsready;
    _attachPingDataAndSend(
        data, ServiceOperation.joinLobbyWithPingData, success, failure);
  }

  /// <summary>
  /// User leaves the specified lobby. if the user was the owner, a new owner will be chosen
  /// </summary>
  ///
  void leaveLobby(
      String inLobbyid, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.leaveLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Only valid from the owner of the lobby -- removes the specified member from the lobby
  /// </summary>
  ///
  void removeMember(String inLobbyid, String inConnectionid,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyIdentifier.value] = inLobbyid;
    data[OperationParam.lobbyConnectionId.value] = inConnectionid;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.removeMember, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Cancel this members Find, Join and Searching of Lobbies
  /// </summary>
  ///
  void cancelFindRequest(
      String inRoomtype, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inRoomtype;
    data[OperationParam.lobbyConnectionId.value] = _clientRef.rttConnectionID;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.cancelFindRequest, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves the region settings for each of the given lobby types. Upon SuccessCallback or afterwards, call PingRegions to start retrieving appropriate data.
  /// Once that completes, the associated region Ping Data is retrievable via PingData and all associated <>WithPingData APIs are useable
  /// </summary>
  ///
  void getRegionsForLobbies(List<String> inRoomtypes, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyTypes.value] = inRoomtypes;

    mergedCallback(Map<String, dynamic> response) {
      _onRegionForLobbiesSuccess(response, null);

      if (success != null) {
        success(response);
      }
    }

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(mergedCallback, failure);
    ServerCall sc = ServerCall(ServiceName.lobby,
        ServiceOperation.getRegionsForLobbies, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// Gets a map keyed by rating of the visible lobby instances matching the given type and rating range.
  /// any ping data provided in the criteriaJson will be ignored.
  ///
  /// Service Name - Lobby
  /// Service Operation - GetLobbyInstances
  ///
  /// @param lobbyType The type of lobby to look for.
  /// @param criteriaJson A JSON object used to describe filter criteria.
  void getLobbyInstances(String inLobbytype, Map<String, dynamic> criteriaJson,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inLobbytype;
    data[OperationParam.lobbyCritera.value] = criteriaJson;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.getLobbyInstances, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// Gets a map keyed by rating of the visible lobby instances matching the given type and rating range.
  /// Only lobby instances in the regions that satisfy the ping portion of the criteriaJson (based on the values provided in pingData) will be returned.
  ///
  /// Service Name - Lobby
  /// Service Operation - GetLobbyInstancesWithPingData
  ///
  /// @param lobbyType The type of lobby to look for.
  /// @param criteriaJson A JSON object used to describe filter criteria.
  void getLobbyInstancesWithPingData(
      String inLobbytype,
      Map<String, dynamic> criteriaJson,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.lobbyRoomType.value] = inLobbytype;
    data[OperationParam.lobbyCritera.value] = criteriaJson;

    _attachPingDataAndSend(
        data, ServiceOperation.getLobbyInstancesWithPingData, success, failure);
  }

  /// <summary>
  /// Retrieves associated PingData averages to be used with all associated <>WithPingData APIs.
  /// Call anytime after GetRegionsForLobbies before proceeding.
  /// </summary>
  ///
  void pingRegions(SuccessCallback? success, FailureCallback? failure) {
    if (_pingRegionSuccessCallback != null) {
      _queueFailure(failure, ReasonCodes.missingRequiredParameter,
          "Ping is already happening.");
      return;
    }

    pingData = {};

    // Now we have the region ping data, we can start pinging each region and its defined target
    Map<String, dynamic> regionInner;
    if (_regionPingData.isNotEmpty) {
      _pingRegionSuccessCallback = success;
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
      _queueFailure(failure, ReasonCodes.missingRequiredParameter,
          "No Regions to Ping. Please call GetRegionsForLobbies and await the response before calling PingRegions.");
    }
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

        _pingRegionSuccessCallback!(pingData);

        _pingRegionSuccessCallback = null;
// #if !DOT_NET || GODOT
//                     m_regionTargetIPs.Clear();
// #endif
        return;
      }
    } finally {
      _regionTargetsToProcessLock.release();
    }

    _pingRegionSuccessCallback = null;
// #if !DOT_NET || GODOT
//                 m_regionTargetIPs.Clear();
// #endif
  }

  void _attachPingDataAndSend(
      Map<String, dynamic> inData,
      ServiceOperation inOperation,
      SuccessCallback? success,
      FailureCallback? failure) {
    bool hasPingData = pingData.isNotEmpty;
    if (hasPingData) {
      inData[OperationParam.pingData.value] = pingData;

      ServerCallback? callback =
          BrainCloudClient.createServerCallback(success, failure);
      ServerCall sc =
          ServerCall(ServiceName.lobby, inOperation, inData, callback);
      _clientRef.sendRequest(sc);
    } else {
      _queueFailure(failure!, ReasonCodes.missingRequiredParameter,
          "Processing exception (message): Required message parameter 'pingData' is missing.  Please ensure PingData exists by first calling GetRegionsForLobbies and PingRegions, and waiting for response before proceeding.");
    }
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

  // void update() {
  //   // trigger failure events
  //   for (int i = 0; i < _failureQueue.length; ++i) {
  //     Failure failure = _failureQueue[i];
  //     failure.callback!(failure.status, failure.reasonCode, failure.jsonError);
  //   }
  //   _failureQueue.clear();
  // }

  void _onRegionForLobbiesSuccess(Map<String, dynamic> inJson, dynamic inObj) {
    pingData = {};

    Map<String, dynamic> data = inJson["data"];
    _regionPingData = data["regionPingData"];
    //lobbyTypeRegions = data["lobbyTypeRegions"];
  }

  void _pingHost(RegionTarget inRegionTarget) {
    // if (inRegionTarget.isHttpType())
    // {
    //     HandleHTTPResponse(inRegionTarget.region, inRegionTarget.target);
    // }
    // else
    // {
    //     _handlePingReponse(inRegionTarget.region, inRegionTarget.target);
    // }
// #else
//             if (_clientRef.Wrapper != null)
//             {
//                 _clientRef.Wrapper.StartCoroutine(in_regionTarget.IsHttpType ? HandleHTTPResponse(in_regionTarget.region, in_regionTarget.target)
//                                                                               : HandlePingReponse(in_regionTarget.region, in_regionTarget.target));
//             }
// #endif
  }

// #if DOT_NET || GODOT
//         private void HandleHTTPResponse(String in_region, String in_target)
//         {
//             if (!in_target.StartsWith("http"))
//             {
//                 in_target = (UseHttps ? "https://" : "http://") + in_target;
//             }

//             DateTime RoundtripTime = DateTime.UtcNow;

//             HttpClient client = new HttpClient();
//             client.Timeout = new TimeSpan(100000000); // 10 seconds

//             client.GetAsync(in_target).ContinueWith((Task<HttpResponseMessage> task) =>
//             {
//                 if (task.IsCompleted && task.Result is HttpResponseMessage response && response.IsSuccessStatusCode)
//                 {
//                     handlePingTimeResponse((long)(DateTime.UtcNow - RoundtripTime).TotalMilliseconds, in_region);
//                 }
//                 else
//                 {
//                     _pingNextItemToProcess();
//                 }

//                 client.Dispose();
//             });
//         }

  //void _handlePingReponse(String inRegion, String inTarget) {
  // Ping pinger = new Ping();
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
  //}
// #else
//         private IEnumerator HandleHTTPResponse(String in_region, String in_target)
//         {
//             if (!in_target.StartsWith("http"))
//             {
//                 in_target = (UseHttps ? "https://" : "http://") + in_target;
//             }

//             DateTime RoundtripTime = DateTime.UtcNow;
// #if USE_WEB_REQUEST
//             UnityWebRequest request = UnityWebRequest.Get(in_target);
//             request.timeout = 10;

//             yield return request.SendWebRequest();
// #else
//             WWWForm postForm = new WWWForm();
//             WWW request = new WWW(in_target, postForm);

//             while (!request.isDone && (DateTime.UtcNow - RoundtripTime).TotalMilliseconds < 10000)
//             {
//                 yield return null;
//             }
// #endif
//             if (request.isDone && String.IsNullOrWhiteSpace(request.error))
//             {
//                 handlePingTimeResponse((long)(DateTime.UtcNow - RoundtripTime).TotalMilliseconds, in_region);
//             }
//             else
//             {
//                 _pingNextItemToProcess();
//             }

//             request.Dispose();
//         }

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

  void handlePingTimeResponse(int inResponsetime, String inRegion) {
    var region = _cachedPingResponses[inRegion];

    region?.add(inResponsetime);
    if (region != null) {
      if (region.length == maxPingCalls) {
        int totalAccumulated = 0;
        int highestValue = 0;
        for (var pingResponse in region) {
          totalAccumulated += pingResponse;
          if (pingResponse > highestValue) {
            highestValue = pingResponse;
          }
        }

        // accumulated ALL, now subtract the highest value
        totalAccumulated -= highestValue;
        pingData[inRegion] = totalAccumulated / (region.length - 1);
      }
    }

    _pingNextItemToProcess();
  }

  Map<String, dynamic> _regionPingData = {};
  //Map<String, dynamic> _lobbyTypeRegions = {};
  final Map<String, List<int>> _cachedPingResponses = {};

  final List<RegionTarget> _regionTargetsToProcess = [];
  final Mutex _regionTargetsToProcessLock = Mutex();
  SuccessCallback? _pingRegionSuccessCallback;

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
