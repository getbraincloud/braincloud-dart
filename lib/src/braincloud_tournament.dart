import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/braincloud_social_leaderboard.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudTournament {
  final BrainCloudClient _clientRef;

  BrainCloudTournament(this._clientRef);

  /// <summary>
  /// Processes any outstanding rewards for the given player
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - CLAIM_TOURNAMENT_REWARD
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard for the tournament
  /// </param>
  /// <param name="versionId">
  /// Version of the tournament to claim rewards for.
  /// Use -1 for the latest version.
  /// </param>
  Future<ServerResponse> claimTournamentReward(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.claimTournamentReward, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the info of specified division set
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - GET_DIVISION_INFO
  /// </remarks>
  /// <param name="divSetId">
  /// The division
  /// </param>
  Future<ServerResponse> getDivisionInfo({required String divSetId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.divSetId.value] = divSetId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getDivisionInfo, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the player's recently active divisions
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - GET_MY_DIVISIONS
  /// </remarks>
  Future<ServerResponse> getMyDivisions() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getMyDivisions, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Get tournament status associated with a leaderboard
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - GET_TOURNAMENT_STATUS
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard for the tournament
  /// </param>
  /// <param name="versionId">
  /// Version of the tournament. Use -1 for the latest version.
  /// </param>
  Future<ServerResponse> getTournamentStatus(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getTournamentStatus, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the info of specified division set
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - GET_DIVISION_INFO
  /// </remarks>
  /// <param name="divSetId">
  /// The division
  /// </param>
  /// <param name="tournamentCode">
  /// The tournament to join
  /// </param>
  /// <param name="initialScore">
  /// The initial score for players first joining a tournament
  /// Usually 0, unless leaderboard is LOW_VALUE
  /// </param>
  Future<ServerResponse> joinDivision(
      {required String divSetId,
      required String tournamentCode,
      required int initialScore}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.divSetId.value] = divSetId;
    data[OperationParam.tournamentCode.value] = tournamentCode;
    data[OperationParam.initialScore.value] = initialScore;

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
        ServiceName.tournament, ServiceOperation.joinDivision, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Join the specified tournament.
  /// Any entry fees will be automatically collected.
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - JOIN_TOURNAMENT
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard for the tournament
  /// </param>
  /// <param name="tournamentCode">
  /// Tournament to join
  /// </param>
  /// <param name="initialScore">
  /// The initial score for players first joining a tournament
  /// Usually 0, unless leaderboard is LOW_VALUE
  /// </param>
  Future<ServerResponse> joinTournament(
      {required String leaderboardId,
      required String tournamentCode,
      required int initialScore}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.tournamentCode.value] = tournamentCode;
    data[OperationParam.initialScore.value] = initialScore;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.joinTournament, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the info of specified division set
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - GET_DIVISION_INFO
  /// </remarks>
  /// <param name="learboardId">
  /// The division
  /// </param>
  Future<ServerResponse> leaveDivisionInstance(
      {required String leaderboardId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.leaveDivisionInstance, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Removes player's score from tournament leaderboard
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - LEAVE_TOURNAMENT
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard for the tournament
  /// </param>
  Future<ServerResponse> leaveTournament({required String leaderboardId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.leaveTournament, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Post the users score to the leaderboard
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - POST_TOURNAMENT_SCORE
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard for the tournament
  /// </param>
  /// <param name="score">
  /// The score to post
  /// </param>
  /// <param name="jsonData">
  /// Optional data attached to the leaderboard entry
  /// </param>
  /// <param name="roundStartTimeUTC">
  /// Uses UTC time in milliseconds since epoch
  /// </param>
  Future<ServerResponse> postTournamentScoreUTC(
      {required String leaderboardId,
      required int score,
      required String jsonData,
      required int roundStartTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.score.value] = score;
    data[OperationParam.roundStartedEpoch.value] = roundStartTimeUTC;

    if (Util.isOptionalParameterValid(jsonData)) {
      Map<String, dynamic> scoreData = jsonDecode(jsonData);
      data[OperationParam.data.value] = scoreData;
    }
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.postTournamentScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Post the users score to the leaderboard and returns the results
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - POST_TOURNAMENT_SCORE_WITH_RESULTS
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard for the tournament
  /// </param>
  /// <param name="score">
  /// The score to post
  /// </param>
  /// <param name="jsonData">
  /// Optional data attached to the leaderboard entry
  /// </param>
  /// <param name="roundStartTimeUTC">
  /// Uses UTC time in milliseconds since epoch
  /// </param>
  /// <param name="sort">
  /// Sort key Sort order of page.
  /// </param>
  /// <param name="beforeCount">
  /// The count of number of players before the current player to include.
  /// </param>
  /// <param name="afterCount">
  /// The count of number of players after the current player to include.
  /// </param>
  /// <param name="initialScore">
  /// The initial score for players first joining a tournament
  /// Usually 0, unless leaderboard is LOW_VALUE
  /// </param>
  Future<ServerResponse> postTournamentScoreWithResultsUTC(
      {required String leaderboardId,
      required int score,
      required String jsonData,
      required int roundStartTimeUTC,
      required SortOrder sort,
      required int beforeCount,
      required int afterCount,
      required int initialScore}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.score.value] = score;
    data[OperationParam.roundStartedEpoch.value] = roundStartTimeUTC;
    data[OperationParam.initialScore.value] = initialScore;

    if (Util.isOptionalParameterValid(jsonData)) {
      Map<String, dynamic> scoreData = jsonDecode(jsonData);
      data[OperationParam.data.value] = scoreData;
    }

    data[OperationParam.socialLeaderboardServiceSort.value] = sort.toString();
    data[OperationParam.socialLeaderboardServiceBeforeCount.value] =
        beforeCount;
    data[OperationParam.socialLeaderboardServiceAfterCount.value] = afterCount;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    _clientRef.sendRequest(ServerCall(ServiceName.tournament,
        ServiceOperation.postTournamentScoreWithResults, data, callback));

    return completer.future;
  }

  /// <summary>
  /// Returns the user's expected reward based on the current scores
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - VIEW_CURRENT_REWARD
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard for the tournament
  /// </param>
  Future<ServerResponse> viewCurrentReward(String leaderboardId) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.viewCurrentReward, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Returns the user's reward from a finished tournament
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - VIEW_REWARD
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard for the tournament
  /// </param
  /// <param name="versionId">
  /// Version of the tournament. Use -1 for the latest version.
  /// </param>
  Future<ServerResponse> viewReward(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

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
        ServiceName.tournament, ServiceOperation.viewReward, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
