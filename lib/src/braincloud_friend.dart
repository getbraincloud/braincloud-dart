import 'dart:async';

import 'package:braincloud_dart/src/Common/authentication_type.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudFriend {
  final BrainCloudClient _clientRef;

  BrainCloudFriend(this._clientRef);

  /// <summary>
  /// Retrieves profile information of the specified user.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - GET_PROFILE_INFO_FOR_CREDENTIAL
  /// </remarks>
  /// <param name="externalId">
  /// External id of the user to find
  /// </param>
  /// <param name="authenticationType">
  /// The authentication type used for the user's ID
  /// </param>
  Future<ServerResponse> getProfileInfoForCredential(
      {required String externalId,
      required AuthenticationType authenticationType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceExternalId.value] = externalId;
    data[OperationParam.friendServiceAuthenticationType.value] =
        authenticationType.toString();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getProfileInfoForCredential, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves profile information for the specified external auth user.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - GET_PROFILE_INFO_FOR_EXTERNAL_AUTH_ID
  /// </remarks>
  /// <param name="externalId">
  /// External id of the friend to find
  /// </param>
  /// <param name="externalAuthType">
  /// The external authentication type used for this friend's external id
  /// </param>
  Future<ServerResponse> getProfileInfoForExternalAuthId(
      {required String externalId, required String externalAuthType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceExternalId.value] = externalId;
    data[OperationParam.externalAuthType.value] = externalAuthType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getProfileInfoForExternalAuthId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves the external ID for the specified user profile ID on the specified social platform.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - GET_EXTERNAL_ID_FOR_PROFILE_ID
  /// </remarks>
  /// <param name="profileId">
  /// Profile (user) ID.
  /// </param>
  /// <param name="authenticationType">
  /// Associated authentication type.
  /// </param>
  Future<ServerResponse> getExternalIdForProfileId(
      {required String profileId, required String authenticationType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceProfileId.value] = profileId;
    data[OperationParam.friendServiceAuthenticationType.value] =
        authenticationType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getExternalIdForProfileId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Returns a particular entity of a particular friend.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - ReadFriendEntity
  /// </remarks>
  /// <param name="entityId">
  /// Id of entity to retrieve.
  /// </param>
  /// <param name="friendId">
  /// Profile Id of friend who owns entity.
  /// </param>
  Future<ServerResponse> readFriendEntity(
      {required String entityId, required String friendId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceEntityId.value] = entityId;
    data[OperationParam.friendServiceFriendId.value] = friendId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.readFriendEntity, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Returns entities of all friends based on type and/or subtype.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - ReadFriendsEntities
  /// </remarks>
  /// <param name="entityType">
  /// Types of entities to retrieve.
  /// </param>
  Future<ServerResponse> readFriendsEntities({required String entityType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceEntityType.value] = entityType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.readFriendsEntities, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Returns user state of a particular friend.
  /// If you are not friend with this user, you will get an error
  /// with NOT_FRIENDS reason code.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - ReadFriendPlayerState
  /// </remarks>
  /// <param name="friendId">
  /// Profile Id of friend to retrieve user state for.
  /// </param>
  Future<ServerResponse> readFriendUserState({required String friendId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceReadPlayerStateFriendId.value] = friendId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.readFriendPlayerState, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Returns user state of a particular user.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - GET_SUMMARY_DATA_FOR_PROFILE_ID
  /// </remarks>
  /// <param name="profileId">
  /// Profile Id of user to retrieve player state for.
  /// </param>
  Future<ServerResponse> getSummaryDataForProfileId(
      {required String profileId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceProfileId.value] = profileId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getSummaryDataForProfileId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Finds a list of users matching the search text by performing an exact
  /// search of all user names.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - FIND_USERS_BY_EXACT_NAME
  /// </remarks>
  /// <param name="searchText">
  /// The String to search for.
  /// </param>
  /// <param name="maxResults">
  /// Maximum number of results to return.
  /// </param>
  Future<ServerResponse> findUsersByExactName(
      {required String searchText, required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceSearchText.value] = searchText;
    data[OperationParam.friendServiceMaxResults.value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUsersByExactName, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Find a specific user by their Universal Id
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - FIND_USER_BY_EXACT_UNIVERSAL_ID
  /// </remarks>
  /// <param name="searchText">
  /// The String to search for.
  /// </param>
  Future<ServerResponse> findUserByExactUniversalId(
      {required String searchText}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceSearchText.value] = searchText;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUserByExactUniversalId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Finds a list of users matching the search text by performing a subString
  /// search of all user names.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - FIND_USERS_BY_EXACT_NAME
  /// </remarks>
  /// <param name="searchText">
  /// The subString to search for. Minimum length of 3 characters.
  /// </param>
  /// <param name="maxResults">
  /// Maximum number of results to return.
  /// </param>
  Future<ServerResponse> findUsersBySubstrName(
      {required String searchText, required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceSearchText.value] = searchText;
    data[OperationParam.friendServiceMaxResults.value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUsersBySubstrName, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves a list of user and friend platform information for all friends of the current user.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - LIST_FRIENDS
  /// </remarks>
  /// <param name="friendPlatform">Friend platform to query.</param>
  /// <param name="includeSummaryData">True if including summary data; false otherwise.</param>
  Future<ServerResponse> listFriends(
      {required FriendPlatform friendPlatform,
      required bool includeSummaryData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceFriendPlatform.value] =
        friendPlatform.toString();
    data[OperationParam.friendServiceIncludeSummaryData.value] =
        includeSummaryData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.listFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves the social information associated with the logged in user. Includes summary data if includeSummaryData is true.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - GET_MY_SOCIAL_INFO
  /// </remarks>
  /// <param name="friendPlatform">Friend platform to query.</param>
  /// <param name="includeSummaryData">True if including summary data; false otherwise.</param>
  Future<ServerResponse> getMySocialInfo(
      {required FriendPlatform friendPlatform,
      required bool includeSummaryData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceFriendPlatform.value] =
        friendPlatform.toString();
    data[OperationParam.friendServiceIncludeSummaryData.value] =
        includeSummaryData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.listFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Links the current user and the specified users as brainCloud friends.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - ADD_FRIENDS
  /// </remarks>
  /// <param name="profileIds">Collection of profile IDs.</param>
  Future<ServerResponse> addFriends({required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceProfileIds.value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.addFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Links the profiles for the specified externalIds for the given friend platform as internal friends.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - ADD_FRIENDS_FROM_PLATFORM
  /// </remarks>
  /// <param name="friendPlatform">Platform to add from (i.e: FriendPlatform:Facebook)</param>
  /// <param name="mode">ADD or SYNC</param>
  /// <param name="externalIds">Collection of external ID's from the friend platform</param>
  Future<ServerResponse> addFriendsFromPlatform(
      {required FriendPlatform friendPlatform,
      required String mode,
      required List<String> externalIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceFriendPlatform.value] =
        friendPlatform.toString();
    data[OperationParam.friendServiceMode.value] = mode;
    data[OperationParam.friendServiceExternalIds.value] = externalIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.friend,
        ServiceOperation.addFriendsFromPlatform, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// <summary>
  /// Unlinks the current user and the specified users as brainCloud friends.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - REMOVE_FRIENDS
  /// </remarks>
  /// <param name="profileIds">Collection of profile IDs.</param>
  Future<ServerResponse> removeFriends({required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceProfileIds.value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.removeFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Get users online status
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - GET_USERS_ONLINE_STATUS
  /// </remarks>
  /// <param name="profileIds">Collection of profile IDs.</param>
  Future<ServerResponse> getUsersOnlineStatus(
      {required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceProfileIds.value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getUsersOnlineStatus, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves Name information for the partial matches of the specified text.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - FIND_USERS_BY_NAME_STARTING_WITH
  /// </remarks>
  /// <param name="searchText">
  /// text on which to search.
  /// </param>
  /// <param name="maxResults">
  /// Maximum number of results to return.
  /// </param>
  Future<ServerResponse> findUsersByNameStartingWith(
      {required String searchText, required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceSearchText.value] = searchText;
    data[OperationParam.friendServiceMaxResults.value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUsersByNameStartingWith, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves Universal Id information for the partial matches of the specified text.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - FIND_USERS_BY_UNIVERSAL_ID_STARTING_WITH
  /// </remarks>
  /// <param name="searchText">
  /// text on which to search.
  /// </param>
  /// <param name="maxResults">
  /// Maximum number of results to return.
  /// </param>
  Future<ServerResponse> findUsersByUniversalIdStartingWith(
      {required String searchText, required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceSearchText.value] = searchText;
    data[OperationParam.friendServiceMaxResults.value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUsersByUniversalIdStartingWith, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}

enum FriendPlatform { all, brainCloud, facebook }
