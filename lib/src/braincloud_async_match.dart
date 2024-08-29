import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudAsyncMatch {
  final BrainCloudClient _clientRef;

  BrainCloudAsyncMatch(this._clientRef);

  /// <summary>
  /// Creates an instance of an asynchronous match.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - Create
  /// </remarks>
  /// <param name="jsonOpponentIds">
  /// JSON String identifying the opponent platform and id for this match.
  ///
  /// Platforms are identified as:
  /// BC - a brainCloud profile id
  /// FB - a Facebook id
  ///
  /// An exmaple of this String would be:
  /// [
  ///     {
  ///         "platform": "BC",
  ///         "id": "some-braincloud-profile"
  ///     },
  ///     {
  ///         "platform": "FB",
  ///         "id": "some-facebook-id"
  ///     }
  /// ]
  /// </param>
  /// <param name="pushNotificationMessage">
  /// Optional push notification message to send to the other party.
  /// Refer to the Push Notification functions for the syntax required.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void createMatch({
    required jsonOpponentIds,
    required String pushNotificationMessage,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    _createMatchInternal(
        jsonOpponentIds: jsonOpponentIds,
        pushNotificationMessage: pushNotificationMessage,
        success: success,
        failure: failure);
  }

  /// <summary>
  /// Creates an instance of an asynchronous match with an initial turn.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - Create
  /// </remarks>
  /// <param name="jsonOpponentIds">
  /// JSON String identifying the opponent platform and id for this match.
  ///
  /// Platforms are identified as:
  /// BC - a brainCloud profile id
  /// FB - a Facebook id
  ///
  /// An exmaple of this String would be:
  /// [
  ///     {
  ///         "platform": "BC",
  ///         "id": "some-braincloud-profile"
  ///     },
  ///     {
  ///         "platform": "FB",
  ///         "id": "some-facebook-id"
  ///     }
  /// ]
  /// </param>
  /// <param name="jsonMatchState">
  /// JSON String blob provided by the caller
  /// </param>
  /// <param name="pushNotificationMessage">
  /// Optional push notification message to send to the other party.
  /// Refer to the Push Notification functions for the syntax required.
  /// </param>
  /// <param name="nextPlayer">
  /// Optionally, force the next player player to be a specific player
  /// </param>
  /// <param name="jsonSummary">
  /// Optional JSON String defining what the other player will see as a summary of the game when listing their games
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void createMatchWithInitialTurn({
    required String jsonOpponentIds,
    String? jsonMatchState,
    required String pushNotificationMessage,
    String? nextPlayer,
    String? jsonSummary,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    _createMatchInternal(
        jsonOpponentIds: jsonOpponentIds,
        jsonMatchState: jsonMatchState ?? "{}",
        pushNotificationMessage: pushNotificationMessage,
        nextPlayer: nextPlayer,
        jsonSummary: jsonSummary,
        success: success,
        failure: failure);
  }

  /// <summary>
  /// Submits a turn for the given match.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - SubmitTurn
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identfier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="version">
  /// Game state version to ensure turns are submitted once and in order
  /// </param>
  /// <param name="jsonMatchState">
  /// JSON String blob provided by the caller
  /// </param>
  /// <param name="pushNotificationMessage">
  /// Optional push notification message to send to the other party.
  /// Refer to the Push Notification functions for the syntax required.
  /// </param>
  /// <param name="nextPlayer">
  /// Optionally, force the next player player to be a specific player
  /// </param>
  /// <param name="jsonSummary">
  /// Optional JSON String that other players will see as a summary of the game when listing their games
  /// </param>
  /// <param name="jsonStatistics">
  /// Optional JSON String blob provided by the caller
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void submitTurn({
    required String ownerId,
    required String matchId,
    required int version,
    required String jsonMatchState,
    String? pushNotificationMessage,
    String? nextPlayer,
    String? jsonSummary,
    String? jsonStatistics,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    data["version"] = version.toUnsigned(64);
    data["matchState"] = jsonDecode(jsonMatchState);

    if (Util.isOptionalParameterValid(nextPlayer)) {
      Map<String, dynamic> status = {};
      status["currentPlayer"] = nextPlayer;
      data["status"] = status;
    }

    if (Util.isOptionalParameterValid(jsonSummary)) {
      data["summary"] = jsonDecode(jsonSummary!);
    }

    if (Util.isOptionalParameterValid(jsonStatistics)) {
      data["statistics"] = jsonDecode(jsonStatistics!);
    }

    if (Util.isOptionalParameterValid(pushNotificationMessage)) {
      data["pushContent"] = pushNotificationMessage;
    }

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.submitTurn, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Allows the current player (only) to update Summary data without having to submit a whole turn.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - UpdateMatchSummary
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identfier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="version">
  /// Game state version to ensure turns are submitted once and in order
  /// </param>
  /// <param name="jsonSummary">
  /// JSON String provided by the caller that other players will see as a summary of the game when listing their games
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void updateMatchSummaryData({
    required String ownerId,
    required String matchId,
    required int version,
    String? jsonSummary,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    data["version"] = version.toUnsigned(64);

    if (Util.isOptionalParameterValid(jsonSummary)) {
      data["summary"] = jsonDecode(jsonSummary!);
    }

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.updateMatchSummary, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Marks the given match as complete.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - Complete
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identifier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void completeMatch({
    required String ownerId,
    required String matchId,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.complete, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns the current state of the given match.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - ReadMatch
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identifier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void readMatch({
    required String ownerId,
    required String matchId,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.readMatch, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns the match history of the given match.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - ReadMatchHistory
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identifier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void readMatchHistory({
    required String ownerId,
    required String matchId,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.readMatchHistory, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns all matches that are NOT in a COMPLETE state for which the player is involved.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - FindMatches
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void findMatches({
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.findMatches, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns all matches that are in a COMPLETE state for which the player is involved.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - FindMatchesCompleted
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void findCompleteMatches({
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.findMatchesCompleted, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Marks the given match as abandoned.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - Abandon
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identifier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void abandonMatch({
    required String ownerId,
    required String matchId,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.abandon, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Removes the match and match history from the server. DEBUG ONLY, in production it is recommended
  /// the user leave it as completed.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - Delete
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identifier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void deleteMatch({
    required String ownerId,
    required String matchId,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};

    data["ownerId"] = ownerId;
    data["matchId"] = matchId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.deleteMatch, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Removes the match and match history from the server. DEBUG ONLY, in production it is recommended
  /// the user leave it as completed.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - Delete
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identifier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="pushContent">
  /// Match owner identifier
  /// </param>
  /// <param name="summary">
  /// Match owner identifier
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void completeMatchWithSummaryData({
    required String ownerId,
    required String matchId,
    String? pushContent,
    required summary,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};
    //completedby not needed?
    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    if (pushContent != null) {
      data["pushContent"] = pushContent;
    }
    data["summary"] = jsonDecode(summary);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.completeMatchWithSummaryData, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Removes the match and match history from the server. DEBUG ONLY, in production it is recommended
  /// the user leave it as completed.
  /// </summary>
  /// <remarks>
  /// Service Name - AsyncMatch
  /// Service Operation - Delete
  /// </remarks>
  /// <param name="ownerId">
  /// Match owner identifier
  /// </param>
  /// <param name="matchId">
  /// Match identifier
  /// </param>
  /// <param name="pushContent">
  /// Match owner identifier
  /// </param>
  /// <param name="summary">
  /// Match owner identifier
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>

  //String abandonedBy,
  void abandonMatchWithSummaryData({
    required String ownerId,
    required String matchId,
    String? pushContent,
    required summary,
    SuccessCallback? success,
    FailureCallback? failure,
  }) {
    Map<String, dynamic> data = {};
    //abandoneddby not needed?
    data["ownerId"] = ownerId;
    data["matchId"] = matchId;
    if (pushContent != null) {
      data["pushContent"] = pushContent;
    }
    data["summary"] = jsonDecode(summary);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.asyncMatch,
        ServiceOperation.abandonMatchWithSummaryData, data, callback);
    _clientRef.sendRequest(sc);
  }

  void _createMatchInternal(
      {required String jsonOpponentIds,
      String? jsonMatchState,
      required String pushNotificationMessage,
      String? matchId,
      String? nextPlayer,
      String? jsonSummary,
      SuccessCallback? success,
      FailureCallback? failure}) {
    Map<String, dynamic> data = {};
    data["players"] = jsonDecode(jsonOpponentIds);

    if (Util.isOptionalParameterValid(jsonMatchState)) {
      data["matchState"] = jsonDecode(jsonMatchState!);
    }

    if (Util.isOptionalParameterValid(matchId)) {
      data["matchId"] = matchId;
    }

    if (Util.isOptionalParameterValid(nextPlayer)) {
      Map<String, dynamic> status = {};
      status["currentPlayer"] = nextPlayer;
      data["status"] = status;
    }

    if (Util.isOptionalParameterValid(jsonSummary)) {
      data["summary"] = jsonDecode(jsonSummary!);
    }

    if (Util.isOptionalParameterValid(pushNotificationMessage)) {
      data["pushContent"] = pushNotificationMessage;
    }

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.asyncMatch, ServiceOperation.create, data, callback);
    _clientRef.sendRequest(sc);
  }
}
