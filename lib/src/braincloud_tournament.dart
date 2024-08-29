import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/braincloud_social_leaderboard.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void claimTournamentReward(String leaderboardId, int versionId,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.claimTournamentReward, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getDivisionInfo(
      String divSetId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.divSetId.value] = divSetId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getDivisionInfo, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the player's recently active divisions
  /// </summary>
  /// <remarks>
  /// Service Name - tournament
  /// Service Operation - GET_MY_DIVISIONS
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>

  void getMyDivisions(SuccessCallback? success, FailureCallback? failure) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getMyDivisions, null, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>

  void getTournamentStatus(String leaderboardId, int versionId,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getTournamentStatus, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void joinDivision(String divSetId, String tournamentCode, int initialScore,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.divSetId.value] = divSetId;
    data[OperationParam.tournamentCode.value] = tournamentCode;
    data[OperationParam.initialScore.value] = initialScore;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.tournament, ServiceOperation.joinDivision, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void joinTournament(String leaderboardId, String tournamentCode,
      int initialScore, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.tournamentCode.value] = tournamentCode;
    data[OperationParam.initialScore.value] = initialScore;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.joinTournament, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void leaveDivisionInstance(String leaderboardId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.leaveDivisionInstance, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void leaveTournament(String leaderboardId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.leaveTournament, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void postTournamentScoreUTC(
      String leaderboardId,
      int score,
      String jsonData,
      int roundStartTimeUTC,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.score.value] = score;
    data[OperationParam.roundStartedEpoch.value] = roundStartTimeUTC;

    if (Util.isOptionalParameterValid(jsonData)) {
      Map<String, dynamic> scoreData = jsonDecode(jsonData);
      data[OperationParam.data.value] = scoreData;
    }
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.postTournamentScore, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void postTournamentScoreWithResultsUTC(
      String leaderboardId,
      int score,
      String jsonData,
      int roundStartTimeUTC,
      SortOrder sort,
      int beforeCount,
      int afterCount,
      int initialScore,
      SuccessCallback? success,
      FailureCallback? failure) {
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

    var callback = BrainCloudClient.createServerCallback(success, failure);
    _clientRef.sendRequest(ServerCall(ServiceName.tournament,
        ServiceOperation.postTournamentScoreWithResults, data, callback));
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void viewCurrentReward(String leaderboardId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.viewCurrentReward, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void viewReward(String leaderboardId, int versionId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.tournament, ServiceOperation.viewReward, data, callback);
    _clientRef.sendRequest(sc);
  }
}
