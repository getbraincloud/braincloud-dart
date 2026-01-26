// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/common/authentication_type.dart';
import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudFriend {
  final BrainCloudClient _clientRef;

  BrainCloudFriend(this._clientRef);

// Remove this API as it does nothing more useful than the newer getProfileInfoForCredentialIfExists
// [mc] 2024-12-19

  /// Retrieves profile information of the specified user.
  ///
  /// Service Name - Friend
  /// Service Operation - GET_PROFILE_INFO_FOR_CREDENTIAL
  ///
  /// @param externalId
  /// External id of the user to find
  ///
  /// @param authenticationType
  /// The authentication type used for the user's ID
  ///
  /// returns `Future<ServerResponse>`
  // Future<ServerResponse> getProfileInfoForCredential(
  //     {required String externalId,
  //     required AuthenticationType authenticationType}) {
  //   Completer<ServerResponse> completer = Completer();
  //   Map<String, dynamic> data = {};
  //   data[OperationParam.friendServiceExternalId.value] = externalId;
  //   data[OperationParam.friendServiceAuthenticationType.value] =
  //       authenticationType.toString();

  //   ServerCallback? callback = BrainCloudClient.createServerCallback(
  //       (response) => completer.complete(ServerResponse.fromJson(response)),
  //       (statusCode, reasonCode, statusMessage) => completer.complete(
  //           ServerResponse(
  //               statusCode: statusCode,
  //               reasonCode: reasonCode,
  //               error: statusMessage)));
  //   ServerCall sc = ServerCall(ServiceName.friend,
  //       ServiceOperation.getProfileInfoForCredential, data, callback);
  //   _clientRef.sendRequest(sc);

  //   return completer.future;
  // }
  /// Retrieves profile information for the specified user.
  /// Silently fails, if profile does not exist, just returns null and success, instead of an error.
  /// Service Name - friend
  /// Service Operation - GET_PROFILE_INFO_FOR_CREDENTIAL_IF_EXISTS
  ///
  /// @param in_externalId The users's external ID
  /// @param in_authenticationType The authentication type of the user ID
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> getProfileInfoForCredentialIfExists(
      {required String externalId,
      required AuthenticationType authenticationType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceExternalId.value] = externalId;
    data[OperationParam.friendServiceAuthenticationType.value] =
        authenticationType.toString();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getProfileInfoForCredentialIfExists, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

// Remove this API as it does nothing more useful than the newer getProfileInfoForCredentialIfExists
// [mc] 2024-12-19

  /// Retrieves profile information for the specified external auth user. Will not log an error if
  /// profile does not exists.
  ///
  /// Service Name - Friend
  /// Service Operation - GET_PROFILE_INFO_FOR_EXTERNAL_AUTH_ID_IF_EXISTS
  ///
  /// @param externalId
  /// External id of the friend to find
  ///
  /// @param externalAuthType
  /// The external authentication type used for this friend's external id
  ///
  /// returns `Future<ServerResponse>`
  // Future<ServerResponse> getProfileInfoForExternalAuthId(
  //     {required String externalId,
  //     required String externalAuthType}) {
  //   Completer<ServerResponse> completer = Completer();
  //   Map<String, dynamic> data = {};
  //   data[OperationParam.friendServiceExternalId.value] = externalId;
  //   data[OperationParam.externalAuthType.value] = externalAuthType.toString();

  //   ServerCallback? callback = BrainCloudClient.createServerCallback(
  //       (response) => completer.complete(ServerResponse.fromJson(response)),
  //       (statusCode, reasonCode, statusMessage) => completer.complete(
  //           ServerResponse(
  //               statusCode: statusCode,
  //               reasonCode: reasonCode,
  //               error: statusMessage)));
  //   ServerCall sc = ServerCall(ServiceName.friend,
  //       ServiceOperation.getProfileInfoForExternalAuthId, data, callback);
  //   _clientRef.sendRequest(sc);

  //   return completer.future;
  // }

  /// Retrieves profile information for the specified user. Silently fails, if profile does not exist, just returns null and success, instead of an error.
  /// Service Name - Friend
  /// Service Operation - GET_PROFILE_INFO_FOR_EXTERNAL_AUTH_ID_IF_EXISTS
  ///
  /// @param in_externalId External ID of the friend to find
  /// @param in_externalAuthType The external authentication type used for this friend's external ID
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> getProfileInfoForExternalAuthIdIfExists(
      {required String externalId, required String externalAuthType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceExternalId.value] = externalId;
    data[OperationParam.externalAuthType.value] = externalAuthType.toString();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend,
        ServiceOperation.getProfileInfoForExternalAuthIdIfExists,
        data,
        callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the external ID for the specified user profile ID on the specified social platform.
  ///
  /// @param in_profileId Profile (user) ID.
  /// @param in_authenticationType Associated authentication type.
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> getExternalIdForProfileId(
      {required String profileId,
      required AuthenticationType authenticationType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceProfileId.value] = profileId;
    data[OperationParam.friendServiceAuthenticationType.value] =
        authenticationType.toString();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getExternalIdForProfileId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns a particular entity of a particular friend.
  /// Service Name - Friend
  /// Service Operation - ReadFriendEntity
  ///
  /// @param in_entityId Id of entity to retrieve.
  /// @param in_friendId Profile Id of friend who owns entity.
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> readFriendEntity(
      {required String entityId, required String friendId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceEntityId.value] = entityId;
    data[OperationParam.friendServiceFriendId.value] = friendId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.readFriendEntity, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Returns entities of all friends optionally based on type.
  /// Service Name - Friend
  /// Service Operation - ReadFriendsEntities
  ///
  /// @param in_entityType Types of entities to retrieve.
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> readFriendsEntities({required String entityType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceEntityType.value] = entityType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.readFriendsEntities, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Read a friend's user state.
  /// If you are not friend with this user, you will get an error
  /// with NOT_FRIENDS reason code.
  /// Service Name - Friend
  /// Service Operation - ReadFriendsPlayerState
  ///
  /// @param in_friendId Target friend
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> readFriendUserState({required String friendId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceReadPlayerStateFriendId.value] = friendId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.readFriendPlayerState, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns user state of a particular user.
  /// Service Name - Friend
  /// Service Operation - GET_SUMMARY_DATA_FOR_PROFILE_ID
  ///
  /// @param in_profileId Profile Id of user to retrieve user state for.
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> getSummaryDataForProfileId(
      {required String profileId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceProfileId.value] = profileId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getSummaryDataForProfileId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finds a list of users matching the search text by performing an exact match search
  /// Service Name - friend
  /// Service Operation - FIND_USERS_BY_EXACT_NAME
  ///
  /// @param searchText The string to search for.
  /// @param maxResults Maximum number of results to return.
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> findUsersByExactName(
      {required String searchText, required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceSearchText.value] = searchText;
    data[OperationParam.friendServiceMaxResults.value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUsersByExactName, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves profile information of the specified universal Id.
  ///
  /// @param in_searchText Universal ID text on which to search.
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> findUserByExactUniversalId(
      {required String universalId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceSearchText.value] = universalId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUserByExactUniversalId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finds a list of users matching the search text by performing a substring
  /// search of all user names.
  /// Service Name - friend
  /// Service Operation - FIND_USERS_BY_SUBSTR_NAME
  ///
  /// @param searchText The substring to search for. Minimum length of 3 characters.
  /// @param maxResults Maximum number of results to return. If there are more the message
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> findUsersBySubstrName(
      {required String searchText, required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceSearchText.value] = searchText;
    data[OperationParam.friendServiceMaxResults.value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUsersBySubstrName, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves a list of user and friend platform information for all friends of the current user.
  /// Service Name - Friend
  /// Service Operation - LIST_FRIENDS
  ///
  /// @param in_friendPlatform Friend platform to query.
  /// @param in_includeSummaryData True if including summary data; false otherwise.
  /// @param in_callback Method to be invoked when the server response is received.
  ///
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
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.listFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the social information associated with the logged in user. Includes summary data if includeSummaryData is true.
  ///
  /// Service Name - Friend
  /// Service Operation - GET_MY_SOCIAL_INFO
  ///
  /// @param friendPlatformFriend platform to query.
  ///
  /// @param includeSummaryDataTrue if including summary data; false otherwise.
  ///
  /// returns `Future<ServerResponse>`
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
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.listFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Links the current user and the specified users as brainCloud friends.
  /// Service Name - Friend
  /// Service Operation - ADD_FRIENDS
  ///
  /// @param in_profileIds Collection of profile IDs.
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> addFriends({required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceProfileIds.value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.addFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Links the profiles for the specified externalIds for the given friend platform as internal friends.
  /// Service Name - Friend
  /// Service Operation - ADD_FRIENDS_FROM_PLATFORM
  ///
  /// @param in_friendPlatform Platform to add from (i.e: FriendPlatform::Facebook)
  /// @param in_mode ADD or SYNC
  /// @param in_externalIds Collection of external IDs from the friend platform.
  /// @param in_callback Method to be invoked when the server response is received.
  ///
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
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.friend,
        ServiceOperation.addFriendsFromPlatform, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Unlinks the current user and the specified users as brainCloud friends.
  /// Service Name - Friend
  /// Service Operation - REMOVE_FRIENDS
  ///
  /// @param in_profileIds Collection of profile IDs.
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> removeFriends({required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceProfileIds.value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.friend, ServiceOperation.removeFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Get users online status
  /// Service Name - Friend
  /// Service Operation - GET_USERS_ONLINE_STATUS
  ///
  /// @param in_profileIds Collection of profile IDs.
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> getUsersOnlineStatus(
      {required List<String> profileIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceProfileIds.value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getUsersOnlineStatus, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves profile information for the users whos names start with search text.
  ///
  /// @param in_searchText Name text on which to search.
  /// @param in_maxResults Maximum number of results to return.
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> findUsersByNameStartingWith(
      {required String searchText, required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceSearchText.value] = searchText;
    data[OperationParam.friendServiceMaxResults.value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUsersByNameStartingWith, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves profile information for the users whos UniversalId start with search text.
  ///
  /// @param in_searchText Universal ID text on which to search.
  /// @param in_maxResults Maximum number of results to return.
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> findUsersByUniversalIdStartingWith(
      {required String searchText, required int maxResults}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.friendServiceSearchText.value] = searchText;
    data[OperationParam.friendServiceMaxResults.value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.findUsersByUniversalIdStartingWith, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}

enum FriendPlatform {
  all("All"),
  brainCloud("brainCloud"),
  facebook("Facebook");

  const FriendPlatform(this.value);

  final String value;

  static FriendPlatform fromString(String s) {
    FriendPlatform type = FriendPlatform.values
        .firstWhere((e) => e.value == s, orElse: () => FriendPlatform.all);

    return type;
  }

  @override
  String toString() => value;
}
