// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';
import '/src/util.dart';

class BrainCloudAsyncMatch {
  final BrainCloudClient _clientRef;

  BrainCloudAsyncMatch(this._clientRef);

  /// Creates an instance of an asynchronous match.
  /// Service Name - asyncMatch
  /// Service Operation - CREATE
  ///
  /// @param jsonOpponentIds JSON string identifying the opponent platform and id for this match.
  ///        Platforms are identified as:
  ///        BC - a brainCloud profile id
  ///        FB - a Facebook id
  ///        An exmaple of this string would be:
  ///        [
  ///        {
  ///        "platform": "BC",
  ///        "id": "some-braincloud-profile"
  ///        },
  ///        {
  ///        "platform": "FB",
  ///        "id": "some-facebook-id"
  ///        }
  ///        ]
  /// @param pushNotificationMessage Optional push notification message to send to the other party.
  ///        Refer to the Push Notification functions for the syntax required.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> createMatch(
      {required List<Map<String, dynamic>> jsonOpponentIds,
      Map<String, dynamic>? pushNotificationMessage}) {
    return _createMatchInternal(
      jsonOpponentIds: jsonOpponentIds,
      pushNotificationMessage: pushNotificationMessage,
    );
  }

  /// Creates an instance of an asynchronous match with an initial turn.
  /// Service Name - asyncMatch
  /// Service Operation - CREATE
  ///
  /// @param jsonOpponentIds JSON string identifying the opponent platform and id for this match.
  ///        Platforms are identified as:
  ///        BC - a brainCloud profile id
  ///        FB - a Facebook id
  ///        An exmaple of this string would be:
  ///        [
  ///        {
  ///        "platform": "BC",
  ///        "id": "some-braincloud-profile"
  ///        },
  ///        {
  ///        "platform": "FB",
  ///        "id": "some-facebook-id"
  ///        }
  ///        ]
  /// @param jsonMatchState JSON string blob provided by the caller
  /// @param pushNotificationMessage Optional push notification message to send to the other party.
  ///        Refer to the Push Notification functions for the syntax required.
  /// @param nextPlayer Optionally, force the next player player to be a specific player
  /// @param jsonSummary Optional JSON string defining what the other player will see as a summary of the game when listing their games
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> createMatchWithInitialTurn({
    required List<Map<String, dynamic>> jsonOpponentIds,
    Map<String, dynamic>? jsonMatchState,
    Map<String, dynamic>? pushNotificationMessage,
    String? nextPlayer,
    Map<String, dynamic>? jsonSummary,
  }) {
    return _createMatchInternal(
        jsonOpponentIds: jsonOpponentIds,
        jsonMatchState: jsonMatchState,
        pushNotificationMessage: pushNotificationMessage,
        nextPlayer: nextPlayer,
        jsonSummary: jsonSummary);
  }

  /// Submits a turn for the given match.
  /// Service Name - asyncMatch
  /// Service Operation - SUBMIT_TURN
  ///
  /// @param ownerId Match owner identfier
  /// @param matchId Match identifier
  /// @param version Game state version to ensure turns are submitted once and in order
  /// @param jsonMatchState JSON string provided by the caller
  /// @param pushNotificationMessage Optional push notification message to send to the other party.
  ///        Refer to the Push Notification functions for the syntax required.
  /// @param nextPlayer Optionally, force the next player player to be a specific player
  /// @param jsonSummary Optional JSON string that other players will see as a summary of the game when listing their games
  /// @param jsonStatistics Optional JSON string blob provided by the caller
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> submitTurn(
      {required String ownerId,
      required String matchId,
      required int version,
      required Map<String, dynamic> jsonMatchState,
      String? pushNotificationMessage,
      String? nextPlayer,
      Map<String, dynamic>? jsonSummary,
      Map<String, dynamic>? jsonStatistics}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    data["version"] = version.toUnsigned(64);
    data["matchState"] = jsonMatchState;

    if (Util.isOptionalParameterValid(nextPlayer)) {
      Map<String, dynamic> status = {};
      status["currentPlayer"] = nextPlayer;
      data["status"] = status;
    }

    if (jsonSummary != null) {
      data["summary"] = jsonSummary;
    }

    if (jsonStatistics != null) {
      data["statistics"] = jsonStatistics;
    }

    if (pushNotificationMessage != null) {
      data["pushContent"] = pushNotificationMessage;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.submitTurn, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Allows the current player (only) to update Summary data without having to submit a whole turn.
  /// Service Name - asyncMatch
  /// Service Operation - UPDATE_SUMMARY
  ///
  /// @param ownerId Match owner identfier
  /// @param matchId Match identifier
  /// @param version Game state version to ensure turns are submitted once and in order
  /// @param jsonSummary JSON string that other players will see as a summary of the game when listing their games
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> updateMatchSummaryData(
      {required String ownerId,
      required String matchId,
      required int version,
      Map<String, dynamic>? jsonSummary}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    data["version"] = version.toUnsigned(64);

    if (jsonSummary != null) {
      data["summary"] = jsonSummary;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.updateMatchSummary, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Allows the current player in the game to overwrite the matchState and
  /// statistics without completing their turn or adding to matchHistory.
  /// Service Name - asyncMatch
  /// Service Operation - UPDATE_MATCH_STATE_CURRENT_TURN
  ///
  /// @param ownerId Match owner identifier
  /// @param matchId Match identifier
  /// @param version Game state version being updated, to ensure data integrity
  /// @param jsonMatchState JSON string provided by the caller Required.
  /// @param jsonStatistics Optional JSON string provided by the caller.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> updateMatchStateCurrentTurn(
      {required String ownerId,
      required String matchId,
      required int version,
      required Map<String, dynamic> matchState,
      Map<String, dynamic>? statistics}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    data["version"] = version;
    data["matchState"] = matchState;
    data["statistics"] = statistics;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));

    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.updateMatchStateCurrentTurn, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Marks the given match as complete.
  /// Service Name - asyncMatch
  /// Service Operation - COMPLETE
  ///
  /// @param ownerId Match owner identifier
  /// @param matchId Match identifier
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> completeMatch(
      {required String ownerId, required String matchId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.complete, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns the current state of the given match.
  /// Service Name - asyncMatch
  /// Service Operation - READ_MATCH
  ///
  /// @param ownerId Match owner identifier
  /// @param matchId Match identifier
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readMatch(
      {required String ownerId, required String matchId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.readMatch, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns the match history of the given match.
  /// Service Name - asyncMatch
  /// Service Operation - READ_MATCH_HISTORY
  ///
  /// @param ownerId Match owner identifier
  /// @param matchId Match identifier
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readMatchHistory(
      {required String ownerId, required String matchId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.readMatchHistory, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns all matches that are NOT in a COMPLETE state for which the player is involved.
  /// Service Name - asyncMatch
  /// Service Operation - FIND_MATCHES
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> findMatches() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.findMatches, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Returns all matches that are in a COMPLETE state for which the player is involved.
  /// Service Name - asyncMatch
  /// Service Operation - FIND_MATCHES_COMPLETED
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> findCompleteMatches() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.findMatchesCompleted, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Marks the given match as abandoned.
  /// Service Name - asyncMatch
  /// Service Operation - ABANDON
  ///
  /// @param ownerId Match owner identifier
  /// @param matchId Match identifier
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> abandonMatch(
      {required String ownerId, required String matchId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.abandon, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Removes the match and match history from the server. DEBUG ONLY, in production it is recommended
  /// the user leave it as completed.
  /// Service Name - asyncMatch
  /// Service Operation - DELETE_MATCH
  ///
  /// @param ownerId Match owner identifier
  /// @param matchId Match identifier
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> deleteMatch(
      {required String ownerId, required String matchId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.deleteMatch, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Marks the given match as complete. This call can send a notification message.
  /// Service Name - asyncMatch
  /// Service Operation - COMPLETE_MATCH_WITH_SUMMARY_DATA
  ///
  /// @param ownerId Match owner identifier
  /// @param matchId Match identifier
  /// @param pushContent Optional push notification message to send to the other party when completing the match.
  /// @param summary Optional JSON string summary that other players will see when listing their games
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> completeMatchWithSummaryData({
    required String ownerId,
    required String matchId,
    String? pushContent,
    required Map<String, dynamic> summary,
  }) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    //completedby not needed?
    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    if (pushContent != null) {
      data["pushContent"] = pushContent;
    }
    data["summary"] = summary;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.completeMatchWithSummaryData, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Marks the given match as abandoned. This call can send a notification message.
  /// Service Name - asyncMatch
  /// Service Operation - ABANDON_MATCH_WITH_SUMMARY_DATA
  ///
  /// @param ownerId Match owner identifier
  /// @param matchId Match identifier
  /// @param pushContent Optional push notification message to send to the other party when abandoning the match.
  /// @param summary Optional JSON string summary that other players will see when listing their games
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> abandonMatchWithSummaryData(
      {required String ownerId,
      required String matchId,
      String? pushContent,
      required Map<String, dynamic> summary}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    //abandoneddby not needed?
    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    if (pushContent != null) {
      data["pushContent"] = pushContent;
    }
    data["summary"] = summary;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.abandonMatchWithSummaryData, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// returns `Future<ServerResponse>`
  Future<ServerResponse> _createMatchInternal(
      {required List<Map<String, dynamic>> jsonOpponentIds,
      Map<String, dynamic>? jsonMatchState,
      Map<String, dynamic>? pushNotificationMessage,
      String? matchId,
      String? nextPlayer,
      Map<String, dynamic>? jsonSummary}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data["players"] = jsonOpponentIds;

    if (jsonMatchState != null) {
      data["matchState"] = jsonMatchState;
    }

    if (Util.isOptionalParameterValid(matchId)) {
      data["matchId"] = matchId;
    }

    if (Util.isOptionalParameterValid(nextPlayer)) {
      Map<String, dynamic> status = {};
      status["currentPlayer"] = nextPlayer;
      data["status"] = status;
    }

    if (jsonSummary != null) {
      data["summary"] = jsonSummary;
    }

    if (pushNotificationMessage != null) {
      data["pushContent"] = pushNotificationMessage;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.create, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
