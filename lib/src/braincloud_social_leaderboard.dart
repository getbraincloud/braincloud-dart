import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getSocialLeaderboard(String leaderboardId, bool replaceName,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceReplaceName.Value] =
        replaceName;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getSocialLeaderboardByVersion(
      String leaderboardId,
      bool replaceName,
      int versionId,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceReplaceName.Value] =
        replaceName;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getMultiSocialLeaderboard(
      List<String> leaderboardIds,
      int leaderboardResultCount,
      bool replaceName,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardIds.Value] =
        leaderboardIds;
    data[OperationParam.SocialLeaderboardServiceLeaderboardResultCount.Value] =
        leaderboardResultCount;
    data[OperationParam.SocialLeaderboardServiceReplaceName.Value] =
        replaceName;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getMultiSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getGlobalLeaderboardPage(
      String leaderboardId,
      SortOrder sort,
      int startIndex,
      int endIndex,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceSort.Value] = sort.toString();
    data[OperationParam.SocialLeaderboardServiceStartIndex.Value] = startIndex;
    data[OperationParam.SocialLeaderboardServiceEndIndex.Value] = endIndex;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardPage, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getGlobalLeaderboardPageByVersion(
      String leaderboardId,
      SortOrder sort,
      int startIndex,
      int endIndex,
      int versionId,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceSort.Value] = sort.toString();
    data[OperationParam.SocialLeaderboardServiceStartIndex.Value] = startIndex;
    data[OperationParam.SocialLeaderboardServiceEndIndex.Value] = endIndex;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardPage, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getGlobalLeaderboardView(
      String leaderboardId,
      SortOrder sort,
      int beforeCount,
      int afterCount,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    getGlobalLeaderboardViewByVersion(
        leaderboardId, sort, beforeCount, afterCount, -1, success, failure,
        cbObject: cbObject);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getGlobalLeaderboardViewByVersion(
      String leaderboardId,
      SortOrder sort,
      int beforeCount,
      int afterCount,
      int versionId,
      SuccessCallback? success,
      FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceSort.Value] = sort.toString();
    data[OperationParam.SocialLeaderboardServiceBeforeCount.Value] =
        beforeCount;
    data[OperationParam.SocialLeaderboardServiceAfterCount.Value] = afterCount;
    if (versionId != -1) {
      data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the global leaderboard versions.
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardVersions
  /// </remarks>
  /// <param name="leaderboardId">In_leaderboard identifier.</param>
  /// <param name="success">The success callback.</param>
  /// <param name="failure">The failure callback.</param>
  /// <param name="cbObject">The user object sent to the callback.</param>
  void getGlobalLeaderboardVersions(String leaderboardId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardVersions, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">The success callback.</param>
  /// <param name="failure">The failure callback.</param>
  /// <param name="cbObject">The user object sent to the callback.</param>
  void getGroupSocialLeaderboard(String leaderboardId, String groupId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceGroupId.Value] = groupId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">The success callback.</param>
  /// <param name="failure">The failure callback.</param>
  /// <param name="cbObject">The user object sent to the callback.</param>
  void getGroupSocialLeaderboardByVersion(
      String leaderboardId,
      String groupId,
      int versionId,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceGroupId.Value] = groupId;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void postScoreToLeaderboard(String leaderboardId, int score, String jsonData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceScore.Value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.SocialLeaderboardServiceData.Value] = customData;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(
        ServiceName.leaderboard, ServiceOperation.postScore, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void removePlayerScore(String leaderboardId, int versionId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.removePlayerScore, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void postScoreToDynamicLeaderboardUTC(
      String leaderboardId,
      int score,
      String jsonData,
      SocialLeaderboardType leaderboardType,
      RotationType rotationType,
      int? rotationResetUTC,
      int retainedCount,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceScore.Value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.SocialLeaderboardServiceData.Value] = customData;
    }
    data[OperationParam.SocialLeaderboardServiceLeaderboardType.Value] =
        leaderboardType.toString();
    data[OperationParam.SocialLeaderboardServiceRotationType.Value] =
        rotationType.toString();

    if (rotationResetUTC != null) {
      data[OperationParam.SocialLeaderboardServiceRotationResetTime.Value] =
          rotationResetUTC.toUnsigned(64);
    }

    data[OperationParam.SocialLeaderboardServiceRetainedCount.Value] =
        retainedCount;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamic, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void postScoreToDynamicGroupLeaderboardUTC(
      String leaderboardId,
      String groupId,
      int score,
      String jsonData,
      SocialLeaderboardType leaderboardType,
      RotationType rotationType,
      int? rotationResetUTC,
      int retainedCount,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceGroupId.Value] = groupId;
    data[OperationParam.SocialLeaderboardServiceScore.Value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.SocialLeaderboardServiceData.Value] = customData;
    }
    data[OperationParam.SocialLeaderboardServiceLeaderboardType.Value] =
        leaderboardType.toString();
    data[OperationParam.SocialLeaderboardServiceRotationType.Value] =
        rotationType.toString();

    if (rotationResetUTC != null) {
      data[OperationParam.SocialLeaderboardServiceRotationResetTime.Value] =
          rotationResetUTC.toUnsigned(64);
    }

    data[OperationParam.SocialLeaderboardServiceRetainedCount.Value] =
        retainedCount;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreToDynamicGroupLeaderboard, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void postScoreToDynamicLeaderboardDaysUTC(
      String leaderboardId,
      int score,
      String jsonData,
      SocialLeaderboardType leaderboardType,
      int? rotationResetUTC,
      int retainedCount,
      int numDaysToRotate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceScore.Value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.SocialLeaderboardServiceData.Value] = customData;
    }
    data[OperationParam.SocialLeaderboardServiceLeaderboardType.Value] =
        leaderboardType.toString();
    data[OperationParam.SocialLeaderboardServiceRotationType.Value] = "DAYS";

    if (rotationResetUTC != null) {
      data[OperationParam.SocialLeaderboardServiceRotationResetTime.Value] =
          rotationResetUTC.toUnsigned(64);
    }

    data[OperationParam.SocialLeaderboardServiceRetainedCount.Value] =
        retainedCount;
    data[OperationParam.NumDaysToRotate.Value] = numDaysToRotate;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamic, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void postScoreToDynamicGroupLeaderboardDaysUTC(
      String leaderboardId,
      String groupId,
      int score,
      String jsonData,
      SocialLeaderboardType leaderboardType,
      int? rotationResetUTC,
      int retainedCount,
      int numDaysToRotate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceScore.Value] = score;
    data[OperationParam.PresenceServiceGroupId.Value] = groupId;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.SocialLeaderboardServiceData.Value] = customData;
    }
    data[OperationParam.SocialLeaderboardServiceLeaderboardType.Value] =
        leaderboardType.toString();
    data[OperationParam.SocialLeaderboardServiceRotationType.Value] = "DAYS";

    if (rotationResetUTC != null) {
      data[OperationParam.SocialLeaderboardServiceRotationResetTime.Value] =
          rotationResetUTC.toUnsigned(64);
    }

    data[OperationParam.SocialLeaderboardServiceRetainedCount.Value] =
        retainedCount;
    data[OperationParam.NumDaysToRotate.Value] = numDaysToRotate;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamic, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getPlayersSocialLeaderboard(
      String leaderboardId,
      List<String> profileIds,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceProfileIds.Value] = profileIds;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayersSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getPlayersSocialLeaderboardByVersion(
      String leaderboardId,
      List<String> profileIds,
      int versionId,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceProfileIds.Value] = profileIds;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayersSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieve a list of all leaderboards
  /// </summary>
  /// <remarks>
  /// Service Name - leaderboard
  /// Service Operation - LIST_LEADERBOARDS
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void listAllLeaderboards(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.listAllLeaderboards, null, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getGlobalLeaderboardEntryCount(String leaderboardId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    getGlobalLeaderboardEntryCountByVersion(leaderboardId, -1, success, failure,
        cbObject: cbObject);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getGlobalLeaderboardEntryCountByVersion(String leaderboardId,
      int versionId, SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;

    if (versionId > -1) {
      data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardEntryCount, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getPlayerScore(String leaderboardId, int versionId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScore, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getPlayerScores(String leaderboardId, int versionId, int maxResults,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceMaxResults.Value] = maxResults;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScores, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getPlayerScoresFromLeaderboards(List<String> leaderboardIds,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardIds.Value] =
        leaderboardIds;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScoresFromLeaderboards, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void postScoreToGroupLeaderboard(
      String leaderboardId,
      String groupId,
      int score,
      String jsonData,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceGroupId.Value] = groupId;
    data[OperationParam.SocialLeaderboardServiceScore.Value] = score;
    if (Util.isOptionalParameterValid(jsonData)) {
      var customData = jsonDecode(jsonData);
      data[OperationParam.SocialLeaderboardServiceData.Value] = customData;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreToGroupLeaderboard, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void removeGroupScore(String leaderboardId, String groupId, int versionId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceGroupId.Value] = groupId;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.removeGroupScore, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getGroupLeaderboardView(
      String leaderboardId,
      String groupId,
      SortOrder sort,
      int beforeCount,
      int afterCount,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceGroupId.Value] = groupId;
    data[OperationParam.SocialLeaderboardServiceSort.Value] = sort.toString();
    data[OperationParam.SocialLeaderboardServiceBeforeCount.Value] =
        beforeCount;
    data[OperationParam.SocialLeaderboardServiceAfterCount.Value] = afterCount;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getGroupLeaderboardViewByVersion(
      String leaderboardId,
      String groupId,
      int versionId,
      SortOrder sort,
      int beforeCount,
      int afterCount,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.SocialLeaderboardServiceLeaderboardId.Value] =
        leaderboardId;
    data[OperationParam.SocialLeaderboardServiceGroupId.Value] = groupId;
    data[OperationParam.SocialLeaderboardServiceSort.Value] = sort.toString();
    data[OperationParam.SocialLeaderboardServiceBeforeCount.Value] =
        beforeCount;
    data[OperationParam.SocialLeaderboardServiceAfterCount.Value] = afterCount;
    data[OperationParam.SocialLeaderboardServiceVersionId.Value] = versionId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);
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
