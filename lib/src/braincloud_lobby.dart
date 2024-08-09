import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';
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
  void FindLobby(
      String inRoomtype,
      int inRating,
      int inMaxsteps,
      Map<String, dynamic> inAlgo,
      Map<String, dynamic> inFilterjson,
      int inTimeoutsecs,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inRoomtype;
    data[OperationParam.LobbyRating.Value] = inRating;
    data[OperationParam.LobbyMaxSteps.Value] = inMaxsteps;
    data[OperationParam.LobbyAlgorithm.Value] = inAlgo;
    data[OperationParam.LobbyFilterJson.Value] = inFilterjson;
    data[OperationParam.LobbyTimeoutSeconds.Value] = inTimeoutsecs;
    data[OperationParam.LobbyIsReady.Value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.LobbyOtherUserCxIds.Value] = inOtherusercxids;
    }
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;
    data[OperationParam.LobbyTeamCode.Value] = inTeamcode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.findLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Finds a lobby matching the specified parameters WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  /// </summary>
  ///
  void FindLobbyWithPingData(
      String inRoomtype,
      int inRating,
      int inMaxsteps,
      Map<String, dynamic> inAlgo,
      Map<String, dynamic> inFilterjson,
      int inTimeoutsecs,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inRoomtype;
    data[OperationParam.LobbyRating.Value] = inRating;
    data[OperationParam.LobbyMaxSteps.Value] = inMaxsteps;
    data[OperationParam.LobbyAlgorithm.Value] = inAlgo;
    data[OperationParam.LobbyFilterJson.Value] = inFilterjson;
    data[OperationParam.LobbyTimeoutSeconds.Value] = inTimeoutsecs;
    data[OperationParam.LobbyIsReady.Value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.LobbyOtherUserCxIds.Value] = inOtherusercxids;
    }
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;
    data[OperationParam.LobbyTeamCode.Value] = inTeamcode;

    _attachPingDataAndSend(data, ServiceOperation.findLobbyWithPingData,
        success, failure, cbObject);
  }

  /// <summary>
  /// Like findLobby, but explicitely geared toward creating new lobbies
  /// </summary>
  ///
  void CreateLobby(
      String inRoomtype,
      int inRating,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      Map<String, dynamic> inSettings,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inRoomtype;
    data[OperationParam.LobbyRating.Value] = inRating;
    data[OperationParam.LobbySettings.Value] = inSettings;
    data[OperationParam.LobbyIsReady.Value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.LobbyOtherUserCxIds.Value] = inOtherusercxids;
    }
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;
    data[OperationParam.LobbyTeamCode.Value] = inTeamcode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.createLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Like findLobby, but explicitely geared toward creating new lobbies WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  /// </summary>
  ///
  void CreateLobbyWithPingData(
      String inRoomtype,
      int inRating,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      Map<String, dynamic> inSettings,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inRoomtype;
    data[OperationParam.LobbyRating.Value] = inRating;
    data[OperationParam.LobbySettings.Value] = inSettings;
    data[OperationParam.LobbyIsReady.Value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.LobbyOtherUserCxIds.Value] = inOtherusercxids;
    }
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;
    data[OperationParam.LobbyTeamCode.Value] = inTeamcode;
    _attachPingDataAndSend(data, ServiceOperation.createLobbyWithPingData,
        success, failure, cbObject);
  }

  /// <summary>
  /// Finds a lobby matching the specified parameters, or creates one
  /// </summary>
  ///
  void FindOrCreateLobby(
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
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inRoomtype;
    data[OperationParam.LobbyRating.Value] = inRating;
    data[OperationParam.LobbyMaxSteps.Value] = inMaxsteps;
    data[OperationParam.LobbyAlgorithm.Value] = inAlgo;
    data[OperationParam.LobbyFilterJson.Value] = inFilterjson;
    data[OperationParam.LobbyTimeoutSeconds.Value] = inTimeoutsecs;
    data[OperationParam.LobbySettings.Value] = inSettings;
    data[OperationParam.LobbyIsReady.Value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.LobbyOtherUserCxIds.Value] = inOtherusercxids;
    }
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;
    data[OperationParam.LobbyTeamCode.Value] = inTeamcode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.findOrCreateLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Finds a lobby matching the specified parameters, or creates one WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  /// </summary>
  ///
  void FindOrCreateLobbyWithPingData(
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
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inRoomtype;
    data[OperationParam.LobbyRating.Value] = inRating;
    data[OperationParam.LobbyMaxSteps.Value] = inMaxsteps;
    data[OperationParam.LobbyAlgorithm.Value] = inAlgo;
    data[OperationParam.LobbyFilterJson.Value] = inFilterjson;
    data[OperationParam.LobbyTimeoutSeconds.Value] = inTimeoutsecs;
    data[OperationParam.LobbySettings.Value] = inSettings;
    data[OperationParam.LobbyIsReady.Value] = inIsready;
    if (inOtherusercxids != null) {
      data[OperationParam.LobbyOtherUserCxIds.Value] = inOtherusercxids;
    }
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;
    data[OperationParam.LobbyTeamCode.Value] = inTeamcode;

    _attachPingDataAndSend(data, ServiceOperation.findOrCreateLobbyWithPingData,
        success, failure, cbObject);
  }

  /// <summary>
  /// Gets data for the given lobby instance <lobbyId>.
  /// </summary>
  void GetLobbyData(String inLobbyid, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.getLobbyData, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// updates the ready state of the player
  /// </summary>
  void UpdateReady(
      String inLobbyid,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;
    data[OperationParam.LobbyIsReady.Value] = inIsready;
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.updateReady, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// valid only for the owner of the group -- edits the overally lobby config data
  /// </summary>
  void UpdateSettings(String inLobbyid, Map<String, dynamic> inSettings,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;
    data[OperationParam.LobbySettings.Value] = inSettings;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.updateSettings, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// switches to the specified team (if allowed). Note - may be blocked by cloud code script
  /// </summary>
  void SwitchTeam(String inLobbyid, String inToteamname,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;
    data[OperationParam.LobbyToTeamName.Value] = inToteamname;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.switchTeam, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// sends LOBBY_SIGNAL_DATA message to all lobby members
  /// </summary>
  void SendSignal(String inLobbyid, Map<String, dynamic> inSignaldata,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;
    data[OperationParam.LobbySignalData.Value] = inSignaldata;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.sendSignal, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// User joins the specified lobby.
  /// </summary>
  void JoinLobby(
      String inLobbyid,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (inOtherusercxids != null) {
      data[OperationParam.LobbyOtherUserCxIds.Value] = inOtherusercxids;
    }
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;
    data[OperationParam.LobbyTeamCode.Value] = inTeamcode;
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;
    data[OperationParam.LobbyIsReady.Value] = inIsready;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.joinLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// User joins the specified lobby WITH PING DATA.  GetRegionsForLobbies and PingRegions must be successfully responded to
  /// prior to calling.
  /// </summary>
  void JoinLobbyWithPingData(
      String inLobbyid,
      bool inIsready,
      Map<String, dynamic> inExtrajson,
      String inTeamcode,
      List<String>? inOtherusercxids,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (inOtherusercxids != null) {
      data[OperationParam.LobbyOtherUserCxIds.Value] = inOtherusercxids;
    }
    data[OperationParam.LobbyExtraJson.Value] = inExtrajson;
    data[OperationParam.LobbyTeamCode.Value] = inTeamcode;
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;
    data[OperationParam.LobbyIsReady.Value] = inIsready;
    _attachPingDataAndSend(data, ServiceOperation.joinLobbyWithPingData,
        success, failure, cbObject);
  }

  /// <summary>
  /// User leaves the specified lobby. if the user was the owner, a new owner will be chosen
  /// </summary>
  ///
  void LeaveLobby(String inLobbyid, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.leaveLobby, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Only valid from the owner of the lobby -- removes the specified member from the lobby
  /// </summary>
  ///
  void RemoveMember(String inLobbyid, String inConnectionid,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyIdentifier.Value] = inLobbyid;
    data[OperationParam.LobbyConnectionId.Value] = inConnectionid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.removeMember, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Cancel this members Find, Join and Searching of Lobbies
  /// </summary>
  ///
  void CancelFindRequest(String inRoomtype, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inRoomtype;
    data[OperationParam.LobbyConnectionId.Value] = _clientRef.rttConnectionID;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.lobby, ServiceOperation.cancelFindRequest, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves the region settings for each of the given lobby types. Upon SuccessCallback or afterwards, call PingRegions to start retrieving appropriate data.
  /// Once that completes, the associated region Ping Data is retrievable via PingData and all associated <>WithPingData APIs are useable
  /// </summary>
  ///
  void GetRegionsForLobbies(List<String> inRoomtypes, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyTypes.Value] = inRoomtypes;

    mergedCallback(Map<String, dynamic> response) {
      _onRegionForLobbiesSuccess(response, null);

      if (success != null) {
        success(response);
      }
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        mergedCallback, failure,
        cbObject: cbObject);
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
  void GetLobbyInstances(String inLobbytype, Map<String, dynamic> criteriaJson,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inLobbytype;
    data[OperationParam.LobbyCritera.Value] = criteriaJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
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
  void GetLobbyInstancesWithPingData(
      String inLobbytype,
      Map<String, dynamic> criteriaJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.LobbyRoomType.Value] = inLobbytype;
    data[OperationParam.LobbyCritera.Value] = criteriaJson;

    _attachPingDataAndSend(data, ServiceOperation.getLobbyInstancesWithPingData,
        success, failure, cbObject);
  }

  /// <summary>
  /// Retrieves associated PingData averages to be used with all associated <>WithPingData APIs.
  /// Call anytime after GetRegionsForLobbies before proceeding.
  /// </summary>
  ///
  void PingRegions(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    if (_pingRegionSuccessCallback != null) {
      _queueFailure(failure, ReasonCodes.MISSING_REQUIRED_PARAMETER,
          "Ping is already happening.", cbObject);
      return;
    }

    pingData = {};

    // Now we have the region ping data, we can start pinging each region and its defined target
    Map<String, dynamic> regionInner;
    if (_regionPingData.isNotEmpty) {
      _pingRegionSuccessCallback = success;
      _pingRegionObject = cbObject;

      _regionPingData.forEach((key, value) {
        _cachedPingResponses[key] = [];
        regionInner = value;
        RegionTarget regionTarget = RegionTarget(
            region: key,
            target: regionInner["target"].toString(),
            type: regionInner.containsKey("type")
                ? regionInner["type"].toString().toUpperCase()
                : RegionTarget.PING_TYPE);

        _regionTargetsToProcessLock.acquire();
        try {
          for (int i = 0; i < MAX_PING_CALLS; ++i) {
            _regionTargetsToProcess.add(regionTarget);
          }
        } finally {
          _regionTargetsToProcessLock.release();
        }
      });

      _pingNextItemToProcess();
    } else {
      _queueFailure(
          failure,
          ReasonCodes.MISSING_REQUIRED_PARAMETER,
          "No Regions to Ping. Please call GetRegionsForLobbies and await the response before calling PingRegions.",
          cbObject);
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
      FailureCallback? failure,
      dynamic cbObject) {
    bool hasPingData = pingData.isNotEmpty;
    if (hasPingData) {
      inData[OperationParam.PingData.Value] = pingData;

      ServerCallback? callback = BrainCloudClient.createServerCallback(
          success, failure,
          cbObject: cbObject);
      ServerCall sc =
          ServerCall(ServiceName.lobby, inOperation, inData, callback);
      _clientRef.sendRequest(sc);
    } else {
      _queueFailure(
          failure!,
          ReasonCodes.MISSING_REQUIRED_PARAMETER,
          "Processing exception (message): Required message parameter 'pingData' is missing.  Please ensure PingData exists by first calling GetRegionsForLobbies and PingRegions, and waiting for response before proceeding.",
          cbObject);
    }
  }

  void _queueFailure(FailureCallback? inFailure, int reasonCode,
      String statusMessage, dynamic cbObject) {
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
          jsonError: _clientRef.serializeJson(jsonError),
          cbObject: cbObject);

      _failureQueue.add(failure);
    }
  }

  void Update() {
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
    _lobbyTypeRegions = data["lobbyTypeRegions"];
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

  void _handlePingReponse(String in_region, String in_target) {
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
  }
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

  void _handlePingTimeResponse(int inResponsetime, String inRegion) {
    var region = _cachedPingResponses[inRegion];

    region?.add(inResponsetime);
    if (region != null) {
      if (region.length == MAX_PING_CALLS) {
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
  Map<String, dynamic> _lobbyTypeRegions = {};
  final Map<String, List<int>> _cachedPingResponses = {};

  final List<RegionTarget> _regionTargetsToProcess = [];
  final Mutex _regionTargetsToProcessLock = Mutex();
  SuccessCallback? _pingRegionSuccessCallback;
  dynamic _pingRegionObject;

// #if !DOT_NET || GODOT
//         private Dictionary<String, String> m_regionTargetIPs = new Dictionary<String, String>();
// #endif

  static const int MAX_PING_CALLS = 4;

  final List<Failure> _failureQueue = [];
}

class Failure {
  FailureCallback? callback;
  int status;
  int reasonCode;
  String jsonError;
  dynamic cbObject;

  Failure(
      {this.callback,
      required this.status,
      required this.reasonCode,
      required this.jsonError,
      this.cbObject});
}

class RegionTarget {
  static const String PING_TYPE = "PING";
  static const String HTTP_TYPE = "HTTP";

  String region;
  String target;
  String type;

  bool isPingType() => type == PING_TYPE;
  bool isHttpType() => type == HTTP_TYPE;

  RegionTarget(
      {required this.region, required this.target, required this.type});
}
