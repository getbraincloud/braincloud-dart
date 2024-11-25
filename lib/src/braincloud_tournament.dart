import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/braincloud_social_leaderboard.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudTournament {
  final BrainCloudClient _clientRef;

  BrainCloudTournament(this._clientRef);

  /// Processes any outstanding rewards for the given player
  ///
  /// Service Name - tournament
  /// Service Operation - CLAIM_TOURNAMENT_REWARD
  ///
  /// @param leaderboardId
  /// The leaderboard for the tournament
  ///
  /// @param versionId
  /// Version of the tournament to claim rewards for.
  ///
  /// Use -1 for the latest version.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> claimTournamentReward(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.claimTournamentReward, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the info of specified division set
  ///
  /// Service Name - tournament
  /// Service Operation - GET_DIVISION_INFO
  ///
  /// @param divSetId
  /// The division
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getDivisionInfo({required String divSetId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.divSetId.value] = divSetId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getDivisionInfo, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the player's recently active divisions
  ///
  /// Service Name - tournament
  /// Service Operation - GET_MY_DIVISIONS
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getMyDivisions() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getMyDivisions, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Get tournament status associated with a leaderboard
  ///
  /// Service Name - tournament
  /// Service Operation - GET_TOURNAMENT_STATUS
  ///
  /// @param leaderboardId
  /// The leaderboard for the tournament
  ///
  /// @param versionId
  /// Version of the tournament. Use -1 for the latest version.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getTournamentStatus(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.getTournamentStatus, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the info of specified division set
  ///
  /// Service Name - tournament
  /// Service Operation - GET_DIVISION_INFO
  ///
  /// @param divSetId
  /// The division
  ///
  /// @param tournamentCode
  /// The tournament to join
  ///
  /// @param initialScore
  /// The initial score for players first joining a tournament
  /// Usually 0, unless leaderboard is LOW_VALUE
  ///
  /// returns Future<ServerResponse>
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.tournament, ServiceOperation.joinDivision, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Join the specified tournament.
  /// Any entry fees will be automatically collected.
  ///
  /// Service Name - tournament
  /// Service Operation - JOIN_TOURNAMENT
  ///
  /// @param leaderboardId
  /// The leaderboard for the tournament
  ///
  /// @param tournamentCode
  /// Tournament to join
  ///
  /// @param initialScore
  /// The initial score for players first joining a tournament
  /// Usually 0, unless leaderboard is LOW_VALUE
  ///
  /// returns Future<ServerResponse>
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.joinTournament, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the info of specified division set
  ///
  /// Service Name - tournament
  /// Service Operation - GET_DIVISION_INFO
  ///
  /// @param learboardId
  /// The division
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> leaveDivisionInstance(
      {required String leaderboardId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.leaveDivisionInstance, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Removes player's score from tournament leaderboard
  ///
  /// Service Name - tournament
  /// Service Operation - LEAVE_TOURNAMENT
  ///
  /// @param leaderboardId
  /// The leaderboard for the tournament
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> leaveTournament({required String leaderboardId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.leaveTournament, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Post the users score to the leaderboard
  ///
  /// Service Name - tournament
  /// Service Operation - POST_TOURNAMENT_SCORE
  ///
  /// @param leaderboardId
  /// The leaderboard for the tournament
  ///
  /// @param score
  /// The score to post
  ///
  /// @param jsonData
  /// Optional data attached to the leaderboard entry
  ///
  /// @param roundStartTimeUTC
  /// Uses UTC time in milliseconds since epoch
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> postTournamentScore(
      {required String leaderboardId,
      required int score,
      Map<String, dynamic>? jsonData,
      required int roundStartTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.score.value] = score;
    data[OperationParam.roundStartedEpoch.value] = roundStartTimeUTC;

    if (jsonData != null) {
      data[OperationParam.data.value] = jsonData;
    }
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.postTournamentScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Post the users score to the leaderboard and returns the results
  ///
  /// Service Name - tournament
  /// Service Operation - POST_TOURNAMENT_SCORE_WITH_RESULTS
  ///
  /// @param leaderboardId
  /// The leaderboard for the tournament
  ///
  /// @param score
  /// The score to post
  ///
  /// @param jsonData
  /// Optional data attached to the leaderboard entry
  ///
  /// @param roundStartTimeUTC
  /// Uses UTC time in milliseconds since epoch
  ///
  /// @param sort
  /// Sort key Sort order of page.
  ///
  /// @param beforeCount
  /// The count of number of players before the current player to include.
  ///
  /// @param afterCount
  /// The count of number of players after the current player to include.
  ///
  /// @param initialScore
  /// The initial score for players first joining a tournament
  /// Usually 0, unless leaderboard is LOW_VALUE
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> postTournamentScoreWithResults(
      {required String leaderboardId,
      required int score,
      Map<String, dynamic>? jsonData,
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

    if (jsonData != null) {
      data[OperationParam.data.value] = jsonData;
    }

    data[OperationParam.socialLeaderboardServiceSort.value] = sort.name;
    data[OperationParam.socialLeaderboardServiceBeforeCount.value] =
        beforeCount;
    data[OperationParam.socialLeaderboardServiceAfterCount.value] = afterCount;

    var callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    _clientRef.sendRequest(ServerCall(ServiceName.tournament,
        ServiceOperation.postTournamentScoreWithResults, data, callback));

    return completer.future;
  }

  /// Returns the user's expected reward based on the current scores
  ///
  /// Service Name - tournament
  /// Service Operation - VIEW_CURRENT_REWARD
  ///
  /// @param leaderboardId
  /// The leaderboard for the tournament
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> viewCurrentReward({required String leaderboardId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.tournament,
        ServiceOperation.viewCurrentReward, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns the user's reward from a finished tournament
  ///
  /// Service Name - tournament
  /// Service Operation - VIEW_REWARD
  ///
  /// @param leaderboardId
  /// The leaderboard for the tournament
  ///
  /// @param versionId
  /// Version of the tournament. Use -1 for the latest version.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> viewReward(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.leaderboardId.value] = leaderboardId;
    data[OperationParam.versionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.tournament, ServiceOperation.viewReward, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
