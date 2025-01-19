import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudSocialLeaderboard {
  final BrainCloudClient _clientRef;

  BrainCloudSocialLeaderboard(this._clientRef);

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
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_SOCIAL_LEADERBOARD
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve
  ///
  /// @param replaceName
  /// If true, the currently logged in player's name will be replaced
  /// by the String "You".
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getSocialLeaderboard(
      {required String leaderboardId, required bool replaceName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceReplaceName.value] =
        replaceName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

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
  ///
  /// This method returns the same data as GetSocialLeaderboard, but it will not return an error if the leaderboard is not found.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_SOCIAL_LEADERBOARD_IF_EXISTS
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve
  ///
  /// @param replaceName
  /// If true, the currently logged in player's name will be replaced
  /// by the string "You".
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getSocialLeaderboardIfExists(
      {required String leaderboardId, required bool replaceName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceReplaceName.value] =
        replaceName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    var sc = new ServerCall(ServiceName.leaderboard,
        ServiceOperation.GetSocialLeaderboardIfExists, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

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
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_SOCIAL_LEADERBOARD
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve
  ///
  /// @param replaceName
  /// If true, the currently logged in player's name will be replaced
  /// by the String "You".
  ///
  /// @param versionId
  /// The version
  ///
  /// returns `Future<ServerResponse>`
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

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

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
  ///
  /// This method returns the same data as GetSocialLeaderboardByVersion, but it will not return an error if the leaderboard does not exist.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_SOCIAL_LEADERBOARD_BY_VERSION_IF_EXISTS
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve
  ///
  /// @param replaceName
  /// If true, the currently logged in player's name will be replaced
  /// by the string "You".
  ///
  /// @param versionId
  /// The version
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getSocialLeaderboardByVersionIfExists(
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

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = new ServerCall(ServiceName.leaderboard,
        ServiceOperation.getSocialLeaderboardByVersionIfExists, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reads multiple social leaderboards.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_MULTI_SOCIAL_LEADERBOARD
  ///
  /// @param leaderboardIds
  /// Array of leaderboard id Strings
  ///
  /// @param leaderboardResultCount
  /// Maximum count of entries to return for each leaderboard.
  ///
  /// @param replaceName
  /// If true, the currently logged in player's name will be replaced
  /// by the String "You".
  ///
  /// returns `Future<ServerResponse>`
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

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getMultiSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method returns a page of global leaderboard results.
  ///
  /// Leaderboards entries contain the player's score and optionally, some user-defined
  /// data associated with the score.
  ///
  /// Note: This method allows the client to retrieve pages from within the global leaderboard list
  ///
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardPage
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve.
  ///
  /// @param sort
  /// Sort key Sort order of page.
  ///
  /// @param startIndex
  /// The index at which to start the page.
  ///
  /// @param endIndex
  /// The index at which to end the page.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardPage(
      {required String leaderboardId,
      required SortOrder sortOrder,
      required int startIndex,
      required int endIndex}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sortOrder.name;
    data[OperationParam.socialLeaderboardServiceStartIndex.value] = startIndex;
    data[OperationParam.socialLeaderboardServiceEndIndex.value] = endIndex;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method returns a page of global leaderboard results.
  ///
  /// Leaderboards entries contain the player's score and optionally, some user-defined
  /// data associated with the score.
  ///
  /// Note: This method allows the client to retrieve pages from within the global leaderboard list
  ///
  /// This method returns the same data as GetGlobalLeaderboardPage, but will not return an error if the leaderboard does not exist.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_GLOBAL_LEADERBOARD_PAGE_IF_EXISTS
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve.
  ///
  /// @param sort
  /// Sort key Sort order of page.
  ///
  /// @param startIndex
  /// The index at which to start the page.
  ///
  /// @param endIndex
  /// The index at which to end the page.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardPageIfExists(
      {required String leaderboardId,
      required SortOrder sortOrder,
      required int startIndex,
      required int endIndex}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sortOrder.name;
    data[OperationParam.socialLeaderboardServiceStartIndex.value] = startIndex;
    data[OperationParam.socialLeaderboardServiceEndIndex.value] = endIndex;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));

    var sc = new ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardPageIfExists, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method returns a page of global leaderboard results. By using a non-current version id,
  /// the user can retrieve a historical leaderboard. See GetGlobalLeaderboardVersions method
  /// to retrieve the version id.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardPage
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve.
  ///
  /// @param sort
  /// Sort key Sort order of page.
  ///
  /// @param startIndex
  /// The index at which to start the page.
  ///
  /// @param endIndex
  /// The index at which to end the page.
  ///
  /// @param versionId
  /// The historical version to retrieve.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardPageByVersion(
      {required String leaderboardId,
      required SortOrder sortOrder,
      required int startIndex,
      required int endIndex,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sortOrder.name;
    data[OperationParam.socialLeaderboardServiceStartIndex.value] = startIndex;
    data[OperationParam.socialLeaderboardServiceEndIndex.value] = endIndex;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method returns a page of global leaderboard results. By using a non-current version id,
  /// the user can retrieve a historical leaderboard. See GetGlobalLeaderboardVersions method
  /// to retrieve the version id.
  ///
  /// This method returns the same data as GetGlobalLeaderboardPage, but it will not return an error if the leaderboard does not exist.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_GLOBAL_LEADERBOARD_PAGE_IF_EXISTS
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve.
  ///
  /// @param sort
  /// Sort key Sort order of page.
  ///
  /// @param startIndex
  /// The index at which to start the page.
  ///
  /// @param endIndex
  /// The index at which to end the page.
  ///
  /// @param versionId
  /// The historical version to retrieve.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardPageByVersionIfExists(
      {required String leaderboardId,
      required SortOrder sortOrder,
      required int startIndex,
      required int endIndex,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sortOrder.name;
    data[OperationParam.socialLeaderboardServiceStartIndex.value] = startIndex;
    data[OperationParam.socialLeaderboardServiceEndIndex.value] = endIndex;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = new ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardPageIfExists, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method returns a view of global leaderboard results that centers on the current player.
  ///
  /// Leaderboards entries contain the player's score and optionally, some user-defined
  /// data associated with the score.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardView
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve.
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
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardView(
      {required String leaderboardId,
      required SortOrder sortOrder,
      required int beforeCount,
      required int afterCount}) {
    return getGlobalLeaderboardViewByVersion(
        leaderboardId: leaderboardId,
        sortOrder: sortOrder,
        beforeCount: beforeCount,
        afterCount: afterCount,
        versionId: -1);
  }

  /// Method returns a view of global leaderboard results that centers on the current player.
  ///
  /// Leaderboards entries contain the player's score and optionally, some user-defined
  /// data associated with the score.
  ///
  /// This method returns the same data as GetGlobalLeaderboardView, but it will not return an error if the leaderboard does not exist.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_GLOBAL_LEADERBOARD_VIEW_IF_EXISTS
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve.
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
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardViewIfExists(
      {required String leaderboardId,
      required SortOrder sortOrder,
      required int beforeCount,
      required int afterCount}) {
    return getGlobalLeaderboardViewByVersionIfExists(
        leaderboardId: leaderboardId,
        sortOrder: sortOrder,
        beforeCount: beforeCount,
        afterCount: afterCount,
        versionId: -1);
  }

  /// Method returns a view of global leaderboard results that centers on the current player.
  /// By using a non-current version id, the user can retrieve a historical leaderboard.
  /// See GetGlobalLeaderboardVersions method to retrieve the version id.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardView
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve.
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
  /// @param versionId
  /// The historial version to retrieve. Use -1 for current leaderboard.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardViewByVersion(
      {required String leaderboardId,
      required SortOrder sortOrder,
      required int beforeCount,
      required int afterCount,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sortOrder.name;
    data[OperationParam.socialLeaderboardServiceBeforeCount.value] =
        beforeCount;
    data[OperationParam.socialLeaderboardServiceAfterCount.value] = afterCount;
    if (versionId != -1) {
      data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method returns a view of global leaderboard results that centers on the current player.
  /// By using a non-current version id, the user can retrieve a historical leaderboard.
  /// See GetGlobalLeaderboardVersions method to retrieve the version id.
  ///
  /// This method returns the same data as GetGlobalLeaderboardViewByVersion, but it will not return an error if the leaderboard does not exist.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_GLOBAL_LEADERBOARD_VIEW_IF_EXISTS
  ///
  /// @param leaderboardId
  /// The id of the leaderboard to retrieve.
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
  /// @param versionId
  /// The historial version to retrieve. Use -1 for current leaderboard.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardViewByVersionIfExists(
      {required String leaderboardId,
      required SortOrder sortOrder,
      required int beforeCount,
      required int afterCount,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sortOrder.name;
    data[OperationParam.socialLeaderboardServiceBeforeCount.value] =
        beforeCount;
    data[OperationParam.socialLeaderboardServiceAfterCount.value] = afterCount;
    if (versionId != -1) {
      data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    var sc = new ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardViewIfExists, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Gets the global leaderboard versions.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GetGlobalLeaderboardVersions
  ///
  /// @param leaderboardIdIn_leaderboard identifier.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardVersions(
      {required String leaderboardId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardVersions, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the social leaderboard for a group.
  ///
  /// Service Name - ocialLeaderboard
  /// Service Operation - GET_GROUP_SOCIAL_LEADERBOARD
  ///
  /// @param leaderboardIdThe leaderboard to read
  ///
  /// @param groupIdThe group ID
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGroupSocialLeaderboard(
      {required String leaderboardId, required String groupId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the social leaderboard for a group by its version.
  ///
  /// Service Name - ocialLeaderboard
  /// Service Operation - GET_GROUP_SOCIAL_LEADERBOARD_BY_VERSION
  ///
  /// @param leaderboardIdThe leaderboard to read
  ///
  /// @param groupIdThe group ID
  ///
  /// @param versionIdThe version ID
  ///
  /// returns `Future<ServerResponse>`
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

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Post the players score to the given social leaderboard.
  /// You can optionally send a user-defined json String of data
  /// with the posted score. This String could include information
  /// relevant to the posted score.
  ///
  /// Note that the behaviour of posting a score can be modified in
  /// the brainCloud portal. By default, the server will only keep
  /// the player's best score.
  ///
  /// Service Name - leaderboard
  /// Service Operation - PostScore
  ///
  /// @param leaderboardId
  /// The leaderboard to post to
  ///
  /// @param score
  /// The score to post
  ///
  /// @param data
  /// Optional user-defined data to post with the score
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> postScoreToLeaderboard(
      {required String leaderboardId,
      required int score,
      Map<String, dynamic>? data}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> dataMap = {};
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    dataMap[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (data != null) {
      dataMap[OperationParam.socialLeaderboardServiceData.value] = data;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(
        ServiceName.leaderboard, ServiceOperation.postScore, dataMap, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Removes a player's score from the leaderboard
  ///
  /// Service Name - leaderboard
  /// Service Operation - REMOVE_PLAYER_SCORE
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// @param versionId
  /// The version of the leaderboard
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> removePlayerScore(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.removePlayerScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Post the players score to the given social leaderboard.
  /// Pass leaderboard config data to dynamically create if necessary.
  /// You can optionally send a user-defined json String of data
  /// with the posted score. This String could include information
  /// relevant to the posted score.
  ///
  /// Service Name - leaderboard
  /// Service Operation - PostScoreDynamic
  ///
  /// @param leaderboardId
  /// The leaderboard to post to
  ///
  /// @param score
  /// The score to post
  ///
  /// @param data
  /// Optional user-defined data to post with the score
  ///
  /// @param leaderboardType
  /// leaderboard type
  ///
  /// @param rotationType
  /// Type of rotation
  ///
  /// @param rotationResetUTC
  /// Date to reset the leaderboard using UTC time in milliseconds since epoch
  ///
  /// @param retainedCount
  /// How many rotations to keep
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> postScoreToDynamicLeaderboardUTC(
      {required String leaderboardId,
      required int score,
      Map<String, dynamic>? data,
      required SocialLeaderboardType leaderboardType,
      required RotationType rotationType,
      int? rotationResetUTC,
      required int retainedCount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> dataMap = {};
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    dataMap[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (data != null) {
      dataMap[OperationParam.socialLeaderboardServiceData.value] = data;
    }
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardType.value] =
        leaderboardType.value;
    dataMap[OperationParam.socialLeaderboardServiceRotationType.value] =
        rotationType.value;

    if (rotationResetUTC != null) {
      dataMap[OperationParam.socialLeaderboardServiceRotationResetTime.value] =
          rotationResetUTC.toUnsigned(64);
    }

    dataMap[OperationParam.socialLeaderboardServiceRetainedCount.value] =
        retainedCount;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamic, dataMap, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Post the player's score to the given social leaderboard,
  /// dynamically creating the leaderboard if it does not exist yet.
  /// To create new leaderboard, configJson must specify
  /// leaderboardType, rotationType, resetAt, and retainedCount, at a minimum,
  /// with support to optionally specify an expiry in minutes.
  ///
  /// Service Name - leaderboard
  /// Service Operation - POST_SCORE_DYNAMIC_USING_CONFIG
  ///
  /// @param leaderboardIdThe leaderboard to post to.
  ///
  /// @param scoreA score to post.
  ///
  /// @param scoreDataOptional user-defined data to post with the score.
  ///
  /// @param configJson
  /// Configuration for the leaderboard if it does not exist yet, specified as JSON object.
  /// Configuration fields supported are:
  /// ```
  ///     {
  ///         'leaderboardType': Required. Type of leaderboard. Valid values are:
  ///             'LAST_VALUE',
  ///             'HIGH_VALUE',
  ///             'LOW_VALUE',
  ///             'CUMULATIVE',
  ///             'ARCADE_HIGH',
  ///             'ARCADE_LOW';
  ///
  ///         'rotationType': Required. Type of rotation. Valid values are:
  ///             'NEVER',
  ///             'DAILY',
  ///             'DAYS',
  ///             'WEEKLY',
  ///             'MONTHLY',
  ///             'YEARLY';
  ///
  ///         'numDaysToRotate': Required if 'DAYS' rotation type, with valid values between 2 and 14; otherwise, null;
  ///
  ///         'resetAt': UTC timestamp, in milliseconds, at which to rotate the period. Always null if 'NEVER' rotation type;
  ///
  ///         'retainedCount': Required. Number of rotations (versions) of the leaderboard to retain;
  ///
  ///         'expireInMins': Optional. Duration, in minutes, before the leaderboard is to automatically expire.
  ///     }
  /// ```
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> postScoreToDynamicLeaderboardUsingConfig(
      {required String leaderboardId,
      required int score,
      Map<String, dynamic>? scoreData,
      required Map<String, dynamic> configJson}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (scoreData != null) {
      var optionalScoreData = scoreData;
      data[OperationParam.socialLeaderboardServiceScoreData.value] =
          optionalScoreData;
    }
    var leaderboardConfigJson = configJson;
    data[OperationParam.socialLeaderboardServiceConfigJson.value] =
        leaderboardConfigJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamicUsingConfig, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Post the group score to the given social group leaderboard.
  /// Pass leaderboard config data to dynamically create if necessary.
  /// You can optionally send a user-defined json String of data
  /// with the posted score. This String could include information
  /// relevant to the posted score.
  ///
  /// Service Name - leaderboard
  /// Service Operation - PostScoreToDynamicLeaderboard
  ///
  /// @param leaderboardId
  /// The leaderboard to post to
  ///
  /// @param groupId
  /// group ID the leaderboard belongs to
  ///
  /// @param score
  /// The score to post
  ///
  /// @param data
  /// Optional user-defined data to post with the score
  ///
  /// @param leaderboardType
  /// leaderboard type
  ///
  /// @param rotationType
  /// Type of rotation
  ///
  /// @param rotationResetUTC
  /// Date to reset the leaderboard UTC
  ///
  /// @param retainedCount
  /// How many rotations to keep
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> postScoreToDynamicGroupLeaderboardUTC(
      {required String leaderboardId,
      required String groupId,
      required int score,
      Map<String, dynamic>? data,
      required SocialLeaderboardType leaderboardType,
      required RotationType rotationType,
      int? rotationResetUTC,
      required int retainedCount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> dataMap = {};
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    dataMap[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    dataMap[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (data != null) {
      dataMap[OperationParam.socialLeaderboardServiceData.value] = data;
    }
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardType.value] =
        leaderboardType.value;
    dataMap[OperationParam.socialLeaderboardServiceRotationType.value] =
        rotationType.value;

    if (rotationResetUTC != null) {
      dataMap[OperationParam.socialLeaderboardServiceRotationResetTime.value] =
          rotationResetUTC.toUnsigned(64);
    }

    dataMap[OperationParam.socialLeaderboardServiceRetainedCount.value] =
        retainedCount;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreToDynamicGroupLeaderboard, dataMap, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

Future<ServerResponse> postScoreToDynamicGroupLeaderboardUsingConfig(
   {required String leaderboardId,
      required String groupId,
      required int score,
      Map<String, dynamic>? scoreData,
      required Map<String, dynamic> configJson}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    data[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (scoreData != null) {
      var optionalScoreData = scoreData;
      data[OperationParam.socialLeaderboardServiceScoreData.value] =
          optionalScoreData;
    }
    var leaderboardConfigJson = configJson;
    data[OperationParam.socialLeaderboardServiceConfigJson.value] =
        leaderboardConfigJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreToDynamicGroupLeaderboardUsingConfig, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
}
  /// Post the players score to the given social leaderboard with a rotation type of DAYS.
  /// Pass leaderboard config data to dynamically create if necessary.
  /// You can optionally send a user-defined json String of data
  /// with the posted score. This String could include information
  /// relevant to the posted score.
  ///
  /// Service Name - leaderboard
  /// Service Operation - PostScoreDynamic
  ///
  /// @param leaderboardId
  /// The leaderboard to post to
  ///
  /// @param score
  /// The score to post
  ///
  /// @param data
  /// Optional user-defined data to post with the score
  ///
  /// @param leaderboardType
  /// leaderboard type
  ///
  /// @param rotationResetUTC
  /// Date to reset the leaderboard using UTC time since epoch
  ///
  /// @param retainedCount
  /// How many rotations to keep
  ///
  /// @param numDaysToRotate
  /// How many days between each rotation
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> postScoreToDynamicLeaderboardDaysUTC(
      {required String leaderboardId,
      required int score,
      Map<String, dynamic>? data,
      required SocialLeaderboardType leaderboardType,
      int? rotationReset,
      required int retainedCount,
      required int numDaysToRotate}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> dataMap = {};
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    dataMap[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (data != null) {
      dataMap[OperationParam.socialLeaderboardServiceData.value] = data;
    }
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardType.value] =
        leaderboardType.value;
    dataMap[OperationParam.socialLeaderboardServiceRotationType.value] = "DAYS";

    if (rotationReset != null) {
      dataMap[OperationParam.socialLeaderboardServiceRotationResetTime.value] =
          rotationReset.toUnsigned(64);
    }

    dataMap[OperationParam.socialLeaderboardServiceRetainedCount.value] =
        retainedCount;
    dataMap[OperationParam.numDaysToRotate.value] = numDaysToRotate;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreDynamic, dataMap, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Post the group score to the given group leaderboard
  /// and dynamically create if necessary. LeaderboardType,
  /// rotationType, rotationReset, and retainedCount are required.
  ///
  /// @param leaderboardId
  /// The leaderboard to post to
  ///
  /// @param groupId
  /// The id of the group.
  ///
  /// @param score
  /// The score to post
  ///
  /// @param data
  /// Optional user-defined data to post with the score
  ///
  /// @param leaderboardType
  /// leaderboard type
  ///
  /// @param rotationResetUTC
  /// Date to reset the leaderboard using UTC time since epoch
  ///
  /// @param retainedCount
  /// How many rotations to keep
  ///
  /// @param numDaysToRotate
  /// How many days between each rotation
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> postScoreToDynamicGroupLeaderboardDaysUTC(
      {required String leaderboardId,
      required String groupId,
      required int score,
      Map<String, dynamic>? data,
      required SocialLeaderboardType leaderboardType,
      int? rotationResetTime,
      required int retainedCount,
      required int numDaysToRotate}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> dataMap = {};
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    dataMap[OperationParam.socialLeaderboardServiceScore.value] = score;
    dataMap[OperationParam.presenceServiceGroupId.value] = groupId;
    if (data != null) {
      dataMap[OperationParam.socialLeaderboardServiceData.value] = data;
    }
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardType.value] =
        leaderboardType.value;
    dataMap[OperationParam.socialLeaderboardServiceRotationType.value] = "DAYS";

    if (rotationResetTime != null) {
      dataMap[OperationParam.socialLeaderboardServiceRotationResetTime.value] =
          rotationResetTime.toUnsigned(64);
    }

    dataMap[OperationParam.socialLeaderboardServiceRetainedCount.value] =
        retainedCount;
    dataMap[OperationParam.numDaysToRotate.value] = numDaysToRotate;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreToDynamicGroupLeaderboard, dataMap, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the social leaderboard for a list of players.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYERS_SOCIAL_LEADERBOARD
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// @param profileIds
  /// The IDs of the players
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getPlayersSocialLeaderboard(
      {required String leaderboardId, required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceProfileIds.value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayersSocialLeaderboard, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the social leaderboard for a list of players.
  /// This function returns the same data as GetPlayersSocialLeaderboard, but it will not return an error if the leaderboard does not exist.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYERS_SOCIAL_LEADERBOARD_IF_EXISTS
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// @param profileIds
  /// The IDs of the players
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getPlayersSocialLeaderboardIfExists(
      {required String leaderboardId, required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceProfileIds.value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    var sc = new ServerCall(ServiceName.leaderboard,
        ServiceOperation.GetPlayersSocialLeaderboardIfExists, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the social leaderboard for a list of players by their version.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYERS_SOCIAL_LEADERBOARD_BY_VERSION
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// @param profileIds
  /// The IDs of the players
  ///
  /// @param versionId
  /// The version
  ///
  /// returns `Future<ServerResponse>`
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

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayersSocialLeaderboardByVersion, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the social leaderboard for a list of players by their version.
  /// This function returns the same data as GetPlayersSocialLeaderboardByVersion, but it will not return an error if the leaderboard does not exist.
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYERS_SOCIAL_LEADERBOARD_BY_VERSION_IF_EXISTS
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// @param profileIds
  /// The IDs of the players
  ///
  /// @param versionId
  /// The version
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getPlayersSocialLeaderboardByVersionIfExists(
      {required String leaderboardId,
      required List<String> profileIds,
      required int versionId}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceProfileIds.value] = profileIds;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    var sc = new ServerCall(
        ServiceName.leaderboard,
        ServiceOperation.getPlayersSocialLeaderboardByVersionIfExists,
        data,
        callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve a list of all leaderboards
  ///
  /// Service Name - leaderboard
  /// Service Operation - LIST_LEADERBOARDS
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> listAllLeaderboards() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.listAllLeaderboards, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the number of entries in a global leaderboard
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_GLOBAL_LEADERBOARD_ENTRY_COUNT
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardEntryCount(
      {required String leaderboardId}) {
    return getGlobalLeaderboardEntryCountByVersion(
        leaderboardId: leaderboardId, versionId: -1);
  }

  /// Gets the number of entries in a global leaderboard
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_GLOBAL_LEADERBOARD_ENTRY_COUNT
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// @param versionId
  /// The version of the leaderboard
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGlobalLeaderboardEntryCountByVersion(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;

    if (versionId > -1) {
      data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGlobalLeaderboardEntryCount, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets a player's score from a leaderboard
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYER_SCORE
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// @param versionId
  /// The version of the leaderboard. Use -1 for current.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getPlayerScore(
      {required String leaderboardId, required int versionId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets a player's highest scores from a leaderboard
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYER_SCORES
  ///
  /// @param leaderboardId
  /// The ID of the leaderboard
  ///
  /// @param versionId
  /// The version of the leaderboard. Use -1 for current.
  ///
  /// @param maxResults
  /// The number of max results to return.
  ///
  /// returns `Future<ServerResponse>`
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

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScores, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets a player's score from multiple leaderboards
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_PLAYER_SCORES_FROM_LEADERBOARDS
  ///
  /// @param leaderboardIds
  /// A collection of leaderboardIds to retrieve scores from
  ///
  /// @param versionId
  /// The version of the leaderboard. Use -1 for current.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getPlayerScoresFromLeaderboards(
      {required List<String> leaderboardIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardIds.value] =
        leaderboardIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getPlayerScoresFromLeaderboards, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Posts score to Group's leaderboard - NOTE the user must be a member of the group
  ///
  /// Service Name - leaderboard
  /// Service Operation - POST_SCORE_TO_GROUP_LEADERBOARD
  ///
  /// @param leaderboardId
  /// the id of the leaderboard
  ///
  /// @param groupId
  /// The groups Id
  ///
  /// @param score
  /// The score you wish to post
  ///
  /// @param data
  /// Extra data json
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> postScoreToGroupLeaderboard(
      {required String leaderboardId,
      required String groupId,
      required int score,
      Map<String, dynamic>? data}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> dataMap = {};
    dataMap[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    dataMap[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    dataMap[OperationParam.socialLeaderboardServiceScore.value] = score;
    if (data != null) {
      dataMap[OperationParam.socialLeaderboardServiceData.value] = data;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.postScoreToGroupLeaderboard, dataMap, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Posts score to Group's leaderboard - NOTE the user must be a member of the group
  ///
  /// Service Name - leaderboard
  /// Service Operation - POST_SCORE_TO_GROUP_LEADERBOARD
  ///
  /// @param leaderboardId
  /// the id of the leaderboard
  ///
  /// @param groupId
  /// The groups Id
  ///
  /// @param versionId
  /// The version defaults to -1
  ///
  /// returns `Future<ServerResponse>`
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

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.removeGroupScore, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve a view of the group leaderboard surrounding the current group
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_GROUP_LEADERBOARD_VIEW
  ///
  /// @param leaderboardId
  /// the id of the leaderboard
  ///
  /// @param groupId
  /// The groups Id
  ///
  /// @param sort
  /// The groups Id
  ///
  /// @param beforeCount
  /// The count of number of players before the current player to include.
  ///
  /// @param afterCount
  /// The count of number of players after the current player to include.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGroupLeaderboardView(
      {required String leaderboardId,
      required String groupId,
      required SortOrder sortOrder,
      required int beforeCount,
      required int afterCount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sortOrder.name;
    data[OperationParam.socialLeaderboardServiceBeforeCount.value] =
        beforeCount;
    data[OperationParam.socialLeaderboardServiceAfterCount.value] = afterCount;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve a view of the group leaderboard surrounding the current group
  ///
  /// Service Name - leaderboard
  /// Service Operation - GET_GROUP_LEADERBOARD_VIEW_BY_VERSION
  ///
  /// @param leaderboardId
  /// the id of the leaderboard
  ///
  /// @param groupId
  /// The groups Id
  ///
  /// @param sort
  /// The groups Id
  ///
  /// @param beforeCount
  /// The count of number of players before the current player to include.
  ///
  /// @param afterCount
  /// The count of number of players after the current player to include.
  ///
  /// @param versionId
  /// The version
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getGroupLeaderboardViewByVersion(
      {required String leaderboardId,
      required String groupId,
      required int versionId,
      required SortOrder sortOrder,
      required int beforeCount,
      required int afterCount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.socialLeaderboardServiceLeaderboardId.value] =
        leaderboardId;
    data[OperationParam.socialLeaderboardServiceGroupId.value] = groupId;
    data[OperationParam.socialLeaderboardServiceSort.value] = sortOrder.name;
    data[OperationParam.socialLeaderboardServiceBeforeCount.value] =
        beforeCount;
    data[OperationParam.socialLeaderboardServiceAfterCount.value] = afterCount;
    data[OperationParam.socialLeaderboardServiceVersionId.value] = versionId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    var sc = ServerCall(ServiceName.leaderboard,
        ServiceOperation.getGroupLeaderboardView, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}

enum SocialLeaderboardType {
  HIGH_VALUE("HIGH_VALUE"),
  CUMULATIVE("CUMULATIVE"),
  LAST_VALUE("LAST_VALUE"),
  LOW_VALUE("LOW_VALUE");

  const SocialLeaderboardType(this.value);
  final String value;

  static SocialLeaderboardType fromString(String s) {
    SocialLeaderboardType newValue = SocialLeaderboardType.values.firstWhere(
        (e) => e.value == s,
        orElse: () => SocialLeaderboardType.HIGH_VALUE);

    return newValue;
  }

  @override
  String toString() => value;
}

enum RotationType {
  NEVER("NEVER"),
  DAILY("DAILY"),
  WEEKLY("WEEKLY"),
  MONTHLY("MONTHLY"),
  YEARLY("YEARLY");

  const RotationType(this.value);
  final String value;

  static RotationType fromString(String s) {
    RotationType newValue = RotationType.values
        .firstWhere((e) => e.value == s, orElse: () => RotationType.NEVER);
    return newValue;
  }

  @override
  String toString() => value;
}

enum FetchType {
  HIGHEST_RANKED("HIGHEST_RANKED");

  const FetchType(this.value);
  final String value;

  static FetchType fromString(String s) {
    FetchType newValue = FetchType.values.firstWhere((e) => e.value == s,
        orElse: () => FetchType.HIGHEST_RANKED);
    return newValue;
  }

  @override
  String toString() => value;
}

enum SortOrder {
  HIGH_TO_LOW("HIGH_TO_LOW"),
  LOW_TO_HIGH("LOW_TO_HIGH");

  const SortOrder(this.value);
  final String value;

  static SortOrder fromString(String s) {
    SortOrder newValue = SortOrder.values
        .firstWhere((e) => e.value == s, orElse: () => SortOrder.HIGH_TO_LOW);
    return newValue;
  }

  @override
  String toString() => value;
}
