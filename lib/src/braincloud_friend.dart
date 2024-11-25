import 'dart:async';

import 'package:braincloud_dart/src/common/authentication_type.dart';
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
  /// returns Future<ServerResponse>
  Future<ServerResponse> getProfileInfoForCredential(
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
        ServiceOperation.getProfileInfoForCredential, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves profile information for the specified external auth user.
  ///
  /// Service Name - Friend
  /// Service Operation - GET_PROFILE_INFO_FOR_EXTERNAL_AUTH_ID
  ///
  /// @param externalId
  /// External id of the friend to find
  ///
  /// @param externalAuthType
  /// The external authentication type used for this friend's external id
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getProfileInfoForExternalAuthId(
      {required String externalId,
      required AuthenticationType externalAuthType}) {
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
    ServerCall sc = ServerCall(ServiceName.friend,
        ServiceOperation.getProfileInfoForExternalAuthId, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the external ID for the specified user profile ID on the specified social platform.
  ///
  /// Service Name - Friend
  /// Service Operation - GET_EXTERNAL_ID_FOR_PROFILE_ID
  ///
  /// @param profileId
  /// Profile (user) ID.
  ///
  /// @param authenticationType
  /// Associated authentication type.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// Service Name - Friend
  /// Service Operation - ReadFriendEntity
  ///
  /// @param entityId
  /// Id of entity to retrieve.
  ///
  /// @param friendId
  /// Profile Id of friend who owns entity.
  ///
  /// returns Future<ServerResponse>
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

  /// Returns entities of all friends based on type and/or subtype.
  ///
  /// Service Name - Friend
  /// Service Operation - ReadFriendsEntities
  ///
  /// @param entityType
  /// Types of entities to retrieve.
  ///
  /// returns Future<ServerResponse>
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

  /// Returns user state of a particular friend.
  /// If you are not friend with this user, you will get an error
  /// with NOT_FRIENDS reason code.
  ///
  /// Service Name - Friend
  /// Service Operation - ReadFriendPlayerState
  ///
  /// @param friendId
  /// Profile Id of friend to retrieve user state for.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// Service Name - Friend
  /// Service Operation - GET_SUMMARY_DATA_FOR_PROFILE_ID
  ///
  /// @param profileId
  /// Profile Id of user to retrieve player state for.
  ///
  /// returns Future<ServerResponse>
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

  /// Finds a list of users matching the search text by performing an exact
  /// search of all user names.
  ///
  /// Service Name - Friend
  /// Service Operation - FIND_USERS_BY_EXACT_NAME
  ///
  /// @param searchText
  /// The String to search for.
  ///
  /// @param maxResults
  /// Maximum number of results to return.
  ///
  /// returns Future<ServerResponse>
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

  /// Find a specific user by their Universal Id
  ///
  /// Service Name - Friend
  /// Service Operation - FIND_USER_BY_EXACT_UNIVERSAL_ID
  ///
  /// @param searchText
  /// The String to search for.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> findUserByExactUniversalId(
      {required String searchText}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.friendServiceSearchText.value] = searchText;

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

  /// Finds a list of users matching the search text by performing a subString
  /// search of all user names.
  ///
  /// Service Name - Friend
  /// Service Operation - FIND_USERS_BY_EXACT_NAME
  ///
  /// @param searchText
  /// The subString to search for. Minimum length of 3 characters.
  ///
  /// @param maxResults
  /// Maximum number of results to return.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// Service Name - Friend
  /// Service Operation - LIST_FRIENDS
  ///
  /// @param friendPlatformFriend platform to query.
  ///
  /// @param includeSummaryDataTrue if including summary data; false otherwise.
  ///
  /// returns Future<ServerResponse>
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
  /// returns Future<ServerResponse>
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
  ///
  /// Service Name - Friend
  /// Service Operation - ADD_FRIENDS
  ///
  /// @param profileIdsCollection of profile IDs.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// Service Name - Friend
  /// Service Operation - ADD_FRIENDS_FROM_PLATFORM
  ///
  /// @param friendPlatformPlatform to add from (i.e: FriendPlatform:Facebook)
  ///
  /// @param modeADD or SYNC
  ///
  /// @param externalIdsCollection of external ID's from the friend platform
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// Service Name - Friend
  /// Service Operation - REMOVE_FRIENDS
  ///
  /// @param profileIdsCollection of profile IDs.
  ///
  /// returns Future<ServerResponse>
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
  ///
  /// Service Name - Friend
  /// Service Operation - GET_USERS_ONLINE_STATUS
  ///
  /// @param profileIdsCollection of profile IDs.
  ///
  /// returns Future<ServerResponse>
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

  /// Retrieves Name information for the partial matches of the specified text.
  ///
  /// Service Name - Friend
  /// Service Operation - FIND_USERS_BY_NAME_STARTING_WITH
  ///
  /// @param searchText
  /// text on which to search.
  ///
  /// @param maxResults
  /// Maximum number of results to return.
  ///
  /// returns Future<ServerResponse>
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

  /// Retrieves Universal Id information for the partial matches of the specified text.
  ///
  /// Service Name - Friend
  /// Service Operation - FIND_USERS_BY_UNIVERSAL_ID_STARTING_WITH
  ///
  /// @param searchText
  /// text on which to search.
  ///
  /// @param maxResults
  /// Maximum number of results to return.
  ///
  /// returns Future<ServerResponse>
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
