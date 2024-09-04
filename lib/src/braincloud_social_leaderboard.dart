import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudSocialLeaderboard {
  final BrainCloudClient _clientRef;

  BrainCloudSocialLeaderboard(this._clientRef);

  /// <summary>
  /// Method returns the social leaderboard. A player's social leaderboard is
  /// comprised of players who are recognized as being your friend.
  ///
  /// The getSocialLeaderboard will retrieve all friends from all friend platforms, so
  /// - all external friends (Facebook, Steam, PlaystationNetwork)
  /// - all internal friends (brainCloud)
  /// - plus "self".
  ///
  /// Leaderboards entries contain the player's score and optionally, some user-defined
  /// data associated with the score. The currently logged in player will also
  /// be returned in the social leaderboard.
  ///
  /// Note: If no friends have played the game, the bestScore, createdAt, updatedAt
  /// will contain NULL.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_SOCIAL_LEADERBOARD
  /// </remarks>
  /// <param name="leaderboardId">
  /// The id of the leaderboard to retrieve
  /// </param>
  /// <param name="replaceName">
  /// If true, the currently logged in player's name will be replaced
  /// by the String "You".
  /// </param>
  Future<ServerResponse> getSocialLeaderboard(
      {required String leaderboardId, required bool replaceName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceReplaceName.value] =
        replaceName;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method returns the social leaderboard by its version. A player's social leaderboard is
  /// comprised of players who are recognized as being your friend.
  ///
  /// The getSocialLeaderboard will retrieve all friends from all friend platforms, so
  /// - all external friends (Facebook, Steam, PlaystationNetwork)
  /// - all internal friends (brainCloud)
  /// - plus "self".
  ///
  /// Leaderboards entries contain the player's score and optionally, some user-defined
  /// data associated with the score. The currently logged in player will also
  /// be returned in the social leaderboard.
  ///
  /// Note: If no friends have played the game, the bestScore, createdAt, updatedAt
  /// will contain NULL.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_SOCIAL_LEADERBOARD
  /// </remarks>
  /// <param name="leaderboardId">
  /// The id of the leaderboard to retrieve
  /// </param>
  /// <param name="replaceName">
  /// If true, the currently logged in player's name will be replaced
  /// by the String "You".
  /// </param>
  /// <param name="versionId">
  /// The version
  /// </param>
  Future<ServerResponse> getSocialLeaderboardByVersion(
      {required String leaderboardId,
      required bool replaceName,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceReplaceName.value] =
        replaceName;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Reads multiple social leaderboards.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_MULTI_SOCIAL_LEADERBOARD
  /// </remarks>
  /// <param name="leaderboardIds">
  /// Array of leaderboard id Strings
  /// </param>
  /// <param name="leaderboardResultCount">
  /// Maximum count of entries to return for each leaderboard.
  /// </param>
  /// <param name="replaceName">
  /// If true, the currently logged in player's name will be replaced
  /// by the String "You".
  /// </param>
  Future<ServerResponse> getMultiSocialLeaderboard(
      {required List<String> leaderboardIds,
      required int leaderboardResultCount,
      required bool replaceName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardIds.value] =
        leaderboardIds;
    data[OperationParam.socialLeaderboardServiceLeaderboardResultCount.value] =
        leaderboardResultCount;
    data[OperationParam.socialLeaderboardServiceReplaceName.value] =
        replaceName;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getMultiSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method returns a page of global leaderboard results.
  ///
  /// Leaderboards entries contain the player's score and optionally, some user-defined
  /// data associated with the score.
  ///
  /// Note: This method allows the client to retrieve pages from within the global leaderboard list
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardPage
  /// </remarks>
  /// <param name="leaderboardId">
  /// The id of the leaderboard to retrieve.
  /// </param>
  /// <param name="sort">
  /// Sort key Sort order of page.
  /// </param>
  /// <param name="startIndex">
  /// The index at which to start the page.
  /// </param>
  /// <param name="endIndex">
  /// The index at which to end the page.
  /// </param>
  Future<ServerResponse> getGlobalLeaderboardPage(
      {required String leaderboardId,
      required SortOrder sort,
      required int startIndex,
      required int endIndex}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sort.toString();
    data[OperationParam.socialLeaderboardServiceStartIndex.value] = startIndex;
    data[OperationParam.socialLeaderboardServiceEndIndex.value] = endIndex;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method returns a page of global leaderboard results. By using a non-current version id,
  /// the user can retrieve a historical leaderboard. See GetGlobalLeaderboardVersions method
  /// to retrieve the version id.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardPage
  /// </remarks>
  /// <param name="leaderboardId">
  /// The id of the leaderboard to retrieve.
  /// </param>
  /// <param name="sort">
  /// Sort key Sort order of page.
  /// </param>
  /// <param name="startIndex">
  /// The index at which to start the page.
  /// </param>
  /// <param name="endIndex">
  /// The index at which to end the page.
  /// </param>
  /// <param name="versionId">
  /// The historical version to retrieve.
  /// </param>
  Future<ServerResponse> getGlobalLeaderboardPageByVersion(
      {required String leaderboardId,
      required SortOrder sort,
      required int startIndex,
      required int endIndex,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sort.toString();
    data[OperationParam.socialLeaderboardServiceStartIndex.value] = startIndex;
    data[OperationParam.socialLeaderboardServiceEndIndex.value] = endIndex;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method returns a view of global leaderboard results that centers on the current player.
  ///
  /// Leaderboards entries contain the player's score and optionally, some user-defined
  /// data associated with the score.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardView
  /// </remarks>
  /// <param name="leaderboardId">
  /// The id of the leaderboard to retrieve.
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
  Future<ServerResponse> getGlobalLeaderboardView(
      {required String leaderboardId,
      required SortOrder sort,
      required int beforeCount,
      required int afterCount}) {
    return getGlobalLeaderboardViewByVersion(
        leaderboardId: leaderboardId,
        sort: sort,
        beforeCount: beforeCount,
        afterCount: afterCount,
        versionId: -1);
  }

  /// <summary>
  /// Method returns a view of global leaderboard results that centers on the current player.
  /// By using a non-current version id, the user can retrieve a historical leaderboard.
  /// See GetGlobalLeaderboardVersions method to retrieve the version id.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardView
  /// </remarks>
  /// <param name="leaderboardId">
  /// The id of the leaderboard to retrieve.
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
  /// <param name="versionId">
  /// The historial version to retrieve. Use -1 for current leaderboard.
  /// </param>
  Future<ServerResponse> getGlobalLeaderboardViewByVersion(
      {required String leaderboardId,
      required SortOrder sort,
      required int beforeCount,
      required int afterCount,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sort.toString();
    data[OperationParam.socialLeaderboardServiceBeforeCount.value] =
        beforeCount;
    data[OperationParam.socialLeaderboardServiceAfterCount.value] = afterCount;
    if (versionId != -1) {
      data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;
    }

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the global leaderboard versions.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardVersions
  /// </remarks>
  /// <param name="leaderboardId">In_leaderboard identifier.</param>
  Future<ServerResponse> getGlobalLeaderboardVersions(
      {required String leaderboardId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardVersions, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve the social leaderboard for a group.
  /// </summary>
  /// <remarks>
  /// Service Name - ocialLeaderboard
  /// Service Operation - GET_GROUP_SOCIAL_LEADERBOARD
  /// </remarks>
  /// <param name="leaderboardId">The leaderboard to read</param>
  /// <param name="groupId">The group ID</param>
  Future<ServerResponse> getGroupSocialLeaderboard(
      {required String leaderboardId, required String groupId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve the social leaderboard for a group by its version.
  /// </summary>
  /// <remarks>
  /// Service Name - ocialLeaderboard
  /// Service Operation - GET_GROUP_SOCIAL_LEADERBOARD_BY_VERSION
  /// </remarks>
  /// <param name="leaderboardId">The leaderboard to read</param>
  /// <param name="groupId">The group ID</param>
  /// <param name="versionId">The version ID</param>
  Future<ServerResponse> getGroupSocialLeaderboardByVersion(
      {required String leaderboardId,
      required String groupId,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Post the players score to the given social leaderboard.
  /// You can optionally send a user-defined json String of data
  /// with the posted score. This String could include information
  /// relevant to the posted score.
  ///
  /// Note that the behaviour of posting a score can be modified in
  /// the brainCloud portal. By default, the server will only keep
  /// the player's best score.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - PostScore
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard to post to
  /// </param>
  /// <param name="score">
  /// The score to post
  /// </param>
  /// <param name="data">
  /// Optional user-defined data to post with the score
  /// </param>
  Future<ServerResponse> postScoreToLeaderboard(
      {required String leaderboardId,
      required int score,
      required String jsonData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.socialLeaderboardServiceData.value] = customData;
    }

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(
        ServiceName.leaderboard, ServiceOperation.postScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Removes a player's score from the leaderboard
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - REMOVE_PLAYER_SCORE
  /// </remarks>
  /// <param name="leaderboardId">
  /// The ID of the leaderboard
  /// </param>
  /// <param name="versionId">
  /// The version of the leaderboard
  /// </param>
  Future<ServerResponse> removePlayerScore(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.removePlayerScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Post the players score to the given social leaderboard.
  /// Pass leaderboard config data to dynamically create if necessary.
  /// You can optionally send a user-defined json String of data
  /// with the posted score. This String could include information
  /// relevant to the posted score.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - PostScoreDynamic
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard to post to
  /// </param>
  /// <param name="score">
  /// The score to post
  /// </param>
  /// <param name="data">
  /// Optional user-defined data to post with the score
  /// </param>
  /// <param name="leaderboardType">
  /// leaderboard type
  /// </param>
  /// <param name="rotationType">
  /// Type of rotation
  /// </param>
  /// <param name="rotationResetUTC">
  /// Date to reset the leaderboard using UTC time in milliseconds since epoch
  /// </param>
  /// <param name="retainedCount">
  /// How many rotations to keep
  /// </param>
  Future<ServerResponse> postScoreToDynamicLeaderboardUTC(
      {required String leaderboardId,
      required int score,
      required String jsonData,
      required SocialLeaderboardType leaderboardType,
      required RotationType rotationType,
      int? rotationResetUTC,
      required int retainedCount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.socialLeaderboardServiceData.value] = customData;
    }
    data[OperationParam.socialLeaderboardServiceLeaderboardType.value] =
        leaderboardType.toString();
    data[OperationParam.socialLeaderboardServiceRotationType.value] =
        rotationType.toString();

    if (rotationResetUTC != null) {
      data[OperationParam.socialLeaderboardServiceRotationResetTime.value] =
          rotationResetUTC.toUnsigned(64);
    }

    data[OperationParam.socialLeaderboardServiceRetainedCount.value] =
        retainedCount;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamic, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Post the player's score to the given social leaderboard,
  /// dynamically creating the leaderboard if it does not exist yet.
  /// To create new leaderboard, configJson must specify
  /// leaderboardType, rotationType, resetAt, and retainedCount, at a minimum,
  /// with support to optionally specify an expiry in minutes.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - POST_SCORE_DYNAMIC_USING_CONFIG
  /// </remarks>
  /// <param name="leaderboardId">The leaderboard to post to.</param>
  /// <param name="score">A score to post.</param>
  /// <param name="scoreData">Optional user-defined data to post with the score.</param>
  /// <param name="configJson">
  /// Configuration for the leaderboard if it does not exist yet, specified as JSON object.
  /// Configuration fields supported are:
  ///     leaderboardType': Required. Type of leaderboard. Valid values are:
  ///         'LAST_VALUE',
  ///         'HIGH_VALUE',
  ///         'LOW_VALUE',
  ///         'CUMULATIVE',
  ///         'ARCADE_HIGH',
  ///         'ARCADE_LOW';
  ///     'rotationType': Required. Type of rotation. Valid values are:
  ///         'NEVER',
  ///         'DAILY',
  ///         'DAYS',
  ///         'WEEKLY',
  ///         'MONTHLY',
  ///         'YEARLY';
  ///     'numDaysToRotate': Required if 'DAYS' rotation type, with valid values between 2 and 14; otherwise, null;
  ///     'resetAt': UTC timestamp, in milliseconds, at which to rotate the period. Always null if 'NEVER' rotation type;
  ///     'retainedCount': Required. Number of rotations (versions) of the leaderboard to retain;
  ///     'expireInMins': Optional. Duration, in minutes, before the leaderboard is to automatically expire.
  /// </param>
  Future<ServerResponse> postScoreToDynamicLeaderboardUsingConfig(
      {required String leaderboardId,
      required int score,
      required String scoreData,
      required String configJson}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (Util.isOptionalParameterValid(scoreData)) {
      var optionalScoreData = jsonDecode(scoreData);
      data[OperationParam.socialLeaderboardServiceScoreData.value] =
          optionalScoreData;
    }
    var leaderboardConfigJson = jsonDecode(configJson);
    data[OperationParam.socialLeaderboardServiceConfigJson.value] =
        leaderboardConfigJson;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamicUsingConfig, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Post the group score to the given social group leaderboard.
  /// Pass leaderboard config data to dynamically create if necessary.
  /// You can optionally send a user-defined json String of data
  /// with the posted score. This String could include information
  /// relevant to the posted score.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - PostScoreToDynamicLeaderboard
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard to post to
  /// </param>
  /// <param name="groupId">
  /// group ID the leaderboard belongs to
  /// </param>
  /// <param name="score">
  /// The score to post
  /// </param>
  /// <param name="data">
  /// Optional user-defined data to post with the score
  /// </param>
  /// <param name="leaderboardType">
  /// leaderboard type
  /// </param>
  /// <param name="rotationType">
  /// Type of rotation
  /// </param>
  /// <param name="rotationResetUTC">
  /// Date to reset the leaderboard UTC
  /// </param>
  /// <param name="retainedCount">
  /// How many rotations to keep
  /// </param>
  Future<ServerResponse> postScoreToDynamicGroupLeaderboardUTC(
      {required String leaderboardId,
      required String groupId,
      required int score,
      required String jsonData,
      required SocialLeaderboardType leaderboardType,
      required RotationType rotationType,
      int? rotationResetUTC,
      required int retainedCount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.socialLeaderboardServiceData.value] = customData;
    }
    data[OperationParam.socialLeaderboardServiceLeaderboardType.value] =
        leaderboardType.toString();
    data[OperationParam.socialLeaderboardServiceRotationType.value] =
        rotationType.toString();

    if (rotationResetUTC != null) {
      data[OperationParam.socialLeaderboardServiceRotationResetTime.value] =
          rotationResetUTC.toUnsigned(64);
    }

    data[OperationParam.socialLeaderboardServiceRetainedCount.value] =
        retainedCount;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreToDynamicGroupLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Post the players score to the given social leaderboard with a rotation type of DAYS.
  /// Pass leaderboard config data to dynamically create if necessary.
  /// You can optionally send a user-defined json String of data
  /// with the posted score. This String could include information
  /// relevant to the posted score.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - PostScoreDynamic
  /// </remarks>
  /// <param name="leaderboardId">
  /// The leaderboard to post to
  /// </param>
  /// <param name="score">
  /// The score to post
  /// </param>
  /// <param name="data">
  /// Optional user-defined data to post with the score
  /// </param>
  /// <param name="leaderboardType">
  /// leaderboard type
  /// </param>
  /// <param name="rotationResetUTC">
  /// Date to reset the leaderboard using UTC time since epoch
  /// </param>
  /// <param name="retainedCount">
  /// How many rotations to keep
  /// </param>
  /// <param name="numDaysToRotate">
  /// How many days between each rotation
  /// </param>
  Future<ServerResponse> postScoreToDynamicLeaderboardDaysUTC(
      {required String leaderboardId,
      required int score,
      required String jsonData,
      required SocialLeaderboardType leaderboardType,
      int? rotationResetUTC,
      required int retainedCount,
      required int numDaysToRotate}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.socialLeaderboardServiceData.value] = customData;
    }
    data[OperationParam.socialLeaderboardServiceLeaderboardType.value] =
        leaderboardType.toString();
    data[OperationParam.socialLeaderboardServiceRotationType.value] = "DAYS";

    if (rotationResetUTC != null) {
      data[OperationParam.socialLeaderboardServiceRotationResetTime.value] =
          rotationResetUTC.toUnsigned(64);
    }

    data[OperationParam.socialLeaderboardServiceRetainedCount.value] =
        retainedCount;
    data[OperationParam.numDaysToRotate.value] = numDaysToRotate;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamic, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Post the group score to the given group leaderboard
  /// and dynamically create if necessary. LeaderboardType,
  /// rotationType, rotationReset, and retainedCount are required.
  /// </summary>
  /// <param name="leaderboardId">
  /// The leaderboard to post to
  /// </param>
  /// <param name="groupId">
  /// The id of the group.
  /// </param>
  /// <param name="score">
  /// The score to post
  /// </param>
  /// <param name="data">
  /// Optional user-defined data to post with the score
  /// </param>
  /// <param name="leaderboardType">
  /// leaderboard type
  /// </param>
  /// <param name="rotationResetUTC">
  /// Date to reset the leaderboard using UTC time since epoch
  /// </param>
  /// <param name="retainedCount">
  /// How many rotations to keep
  /// </param>
  /// <param name="numDaysToRotate">
  /// How many days between each rotation
  /// </param>
  Future<ServerResponse> postScoreToDynamicGroupLeaderboardDaysUTC(
      {required String leaderboardId,
      required String groupId,
      required int score,
      required String jsonData,
      required SocialLeaderboardType leaderboardType,
      int? rotationResetUTC,
      required int retainedCount,
      required int numDaysToRotate}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    data[OperationParam.presenceServiceGroupId.value] = groupId;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.socialLeaderboardServiceData.value] = customData;
    }
    data[OperationParam.socialLeaderboardServiceLeaderboardType.value] =
        leaderboardType.toString();
    data[OperationParam.socialLeaderboardServiceRotationType.value] = "DAYS";

    if (rotationResetUTC != null) {
      data[OperationParam.socialLeaderboardServiceRotationResetTime.value] =
          rotationResetUTC.toUnsigned(64);
    }

    data[OperationParam.socialLeaderboardServiceRetainedCount.value] =
        retainedCount;
    data[OperationParam.numDaysToRotate.value] = numDaysToRotate;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamic, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve the social leaderboard for a list of players.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYERS_SOCIAL_LEADERBOARD
  /// </remarks>
  /// <param name="leaderboardId">
  /// The ID of the leaderboard
  /// </param>
  /// <param name="profileIds">
  /// The IDs of the players
  /// </param>
  Future<ServerResponse> getPlayersSocialLeaderboard(
      {required String leaderboardId, required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceProfileIds.value] = profileIds;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayersSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve the social leaderboard for a list of players by their version.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYERS_SOCIAL_LEADERBOARD_BY_VERSION
  /// </remarks>
  /// <param name="leaderboardId">
  /// The ID of the leaderboard
  /// </param>
  /// <param name="profileIds">
  /// The IDs of the players
  /// </param>
  /// <param name="versionId">
  /// The version
  /// </param>
  Future<ServerResponse> getPlayersSocialLeaderboardByVersion(
      {required String leaderboardId,
      required List<String> profileIds,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceProfileIds.value] = profileIds;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayersSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve a list of all leaderboards
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - LIST_LEADERBOARDS
  /// </remarks>
  Future<ServerResponse> listAllLeaderboards() {
    Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.listAllLeaderboards, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the number of entries in a global leaderboard
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_GLOBAL_LEADERBOARD_ENTRY_COUNT
  /// </remarks>
  /// <param name="leaderboardId">
  /// The ID of the leaderboard
  /// </param>
  Future<ServerResponse> getGlobalLeaderboardEntryCount(
      {required String leaderboardId}) {
    return getGlobalLeaderboardEntryCountByVersion(
        leaderboardId: leaderboardId, versionId: -1);
  }

  /// <summary>
  /// Gets the number of entries in a global leaderboard
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_GLOBAL_LEADERBOARD_ENTRY_COUNT
  /// </remarks>
  /// <param name="leaderboardId">
  /// The ID of the leaderboard
  /// </param>
  /// <param name="versionId">
  /// The version of the leaderboard
  /// </param>
  Future<ServerResponse> getGlobalLeaderboardEntryCountByVersion(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;

    if (versionId > -1) {
      data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;
    }

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardEntryCount, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets a player's score from a leaderboard
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYER_SCORE
  /// </remarks>
  /// <param name="leaderboardId">
  /// The ID of the leaderboard
  /// </param>
  /// <param name="versionId">
  /// The version of the leaderboard. Use -1 for current.
  /// </param>
  Future<ServerResponse> getPlayerScore(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets a player's highest scores from a leaderboard
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYER_SCORES
  /// </remarks>
  /// <param name="leaderboardId">
  /// The ID of the leaderboard
  /// </param>
  /// <param name="versionId">
  /// The version of the leaderboard. Use -1 for current.
  /// </param>
  /// <param name="maxResults">
  /// The number of max results to return.
  /// </param>
  Future<ServerResponse> getPlayerScores(
      {required String leaderboardId,
      required int versionId,
      required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceMaxResults.value] = maxResults;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScores, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets a player's score from multiple leaderboards
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYER_SCORES_FROM_LEADERBOARDS
  /// </remarks>
  /// <param name="leaderboardIds">
  /// A collection of leaderboardIds to retrieve scores from
  /// </param>
  /// <param name="versionId">
  /// The version of the leaderboard. Use -1 for current.
  /// </param>
  Future<ServerResponse> getPlayerScoresFromLeaderboards(
      {required List<String> leaderboardIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardIds.value] =
        leaderboardIds;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScoresFromLeaderboards, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Posts score to Group's leaderboard - NOTE the user must be a member of the group
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - POST_SCORE_TO_GROUP_LEADERBOARD
  /// </remarks>
  /// <param name="leaderboardId">
  /// the id of the leaderboard
  /// </param>
  /// <param name="groupId">
  /// The groups Id
  /// </param>
  /// <param name="score">
  /// The score you wish to post
  /// </param>
  /// <param name="data">
  /// Extra data json
  /// </param>
  Future<ServerResponse> postScoreToGroupLeaderboard(
      {required String leaderboardId,
      required String groupId,
      required int score,
      required String jsonData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.socialLeaderboardServiceData.value] = customData;
    }

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreToGroupLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Posts score to Group's leaderboard - NOTE the user must be a member of the group
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - POST_SCORE_TO_GROUP_LEADERBOARD
  /// </remarks>
  /// <param name="leaderboardId">
  /// the id of the leaderboard
  /// </param>
  /// <param name="groupId">
  /// The groups Id
  /// </param>
  /// <param name="versionId">
  /// The version defaults to -1
  /// </param>
  Future<ServerResponse> removeGroupScore(
      {required String leaderboardId,
      required String groupId,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.removeGroupScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve a view of the group leaderboard surrounding the current group
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_GROUP_LEADERBOARD_VIEW
  /// </remarks>
  /// <param name="leaderboardId">
  /// the id of the leaderboard
  /// </param>
  /// <param name="groupId">
  /// The groups Id
  /// </param>
  /// <param name="sort">
  /// The groups Id
  /// </param>
  /// <param name="beforeCount">
  /// The count of number of players before the current player to include.
  /// </param>
  /// <param name="afterCount">
  /// The count of number of players after the current player to include.
  /// </param>
  Future<ServerResponse> getGroupLeaderboardView(
      {required String leaderboardId,
      required String groupId,
      required SortOrder sort,
      required int beforeCount,
      required int afterCount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
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
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieve a view of the group leaderboard surrounding the current group
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GET_GROUP_LEADERBOARD_VIEW_BY_VERSION
  /// </remarks>
  /// <param name="leaderboardId">
  /// the id of the leaderboard
  /// </param>
  /// <param name="groupId">
  /// The groups Id
  /// </param>
  /// <param name="sort">
  /// The groups Id
  /// </param>
  /// <param name="beforeCount">
  /// The count of number of players before the current player to include.
  /// </param>
  /// <param name="afterCount">
  /// The count of number of players after the current player to include.
  /// </param>
  /// <param name="versionId">
  /// The version
  /// </param>
  Future<ServerResponse> getGroupLeaderboardViewByVersion(
      {required String leaderboardId,
      required String groupId,
      required int versionId,
      required SortOrder sort,
      required int beforeCount,
      required int afterCount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sort.toString();
    data[OperationParam.socialLeaderboardServiceBeforeCount.value] =
        beforeCount;
    data[OperationParam.socialLeaderboardServiceAfterCount.value] = afterCount;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    var callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}

// ignore: constant_identifier_names
enum SocialLeaderboardType { HIGH_VALUE, CUMULATIVE, LAST_VALUE, LOW_VALUE }

// ignore: constant_identifier_names
enum RotationType { NEVER, DAILY, WEEKLY, MONTHLY, YEARLY }

// ignore: constant_identifier_names
enum FetchType { HIGHEST_RANKED }

// ignore: constant_identifier_names
enum SortOrder { HIGH_TO_LOW, LOW_TO_HIGH }
