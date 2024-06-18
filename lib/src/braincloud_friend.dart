import 'package:braincloud_dart/src/Common/authentication_type.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void GetProfileInfoForCredential(
      String externalId,
      AuthenticationType authenticationType,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceExternalId.Value] = externalId;
    data[OperationParam.FriendServiceAuthenticationType.Value] =
        authenticationType.toString();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.getProfileInfoForCredential, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void GetProfileInfoForExternalAuthId(
      String externalId,
      String externalAuthType,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceExternalId.Value] = externalId;
    data[OperationParam.ExternalAuthType.Value] = externalAuthType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.getProfileInfoForExternalAuthId, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void GetExternalIdForProfileId(String profileId, String authenticationType,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceProfileId.Value] = profileId;
    data[OperationParam.FriendServiceAuthenticationType.Value] =
        authenticationType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.getExternalIdForProfileId, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void ReadFriendEntity(String entityId, String friendId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceEntityId.Value] = entityId;
    data[OperationParam.FriendServiceFriendId.Value] = friendId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Friend, ServiceOperation.readFriendEntity, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void ReadFriendsEntities(String entityType, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceEntityType.Value] = entityType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.readFriendsEntities, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void ReadFriendUserState(String friendId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceReadPlayerStateFriendId.Value] = friendId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.readFriendPlayerState, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void GetSummaryDataForProfileId(String profileId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceProfileId.Value] = profileId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.getSummaryDataForProfileId, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">The success callback.</param>
  /// <param name="failure">The failure callback.</param>
  /// <param name="cbObject">The user object sent to the callback.</param>
  void FindUsersByExactName(String searchText, int maxResults,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceSearchText.Value] = searchText;
    data[OperationParam.FriendServiceMaxResults.Value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.findUsersByExactName, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">The success callback.</param>
  /// <param name="failure">The failure callback.</param>
  /// <param name="cbObject">The user object sent to the callback.</param>
  void FindUserByExactUniversalId(String searchText, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceSearchText.Value] = searchText;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.findUserByExactUniversalId, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">The success callback.</param>
  /// <param name="failure">The failure callback.</param>
  /// <param name="cbObject">The user object sent to the callback.</param>
  void FindUsersBySubstrName(String searchText, int maxResults,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceSearchText.Value] = searchText;
    data[OperationParam.FriendServiceMaxResults.Value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.findUsersBySubstrName, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  /// <param name="cbObject"> The user object sent to the callback. </param>
  void ListFriends(FriendPlatform friendPlatform, bool includeSummaryData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceFriendPlatform.Value] =
        friendPlatform.toString();
    data[OperationParam.FriendServiceIncludeSummaryData.Value] =
        includeSummaryData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Friend, ServiceOperation.listFriends, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  /// <param name="cbObject"> The user object sent to the callback. </param>
  void GetMySocialInfo(FriendPlatform friendPlatform, bool includeSummaryData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceFriendPlatform.Value] =
        friendPlatform.toString();
    data[OperationParam.FriendServiceIncludeSummaryData.Value] =
        includeSummaryData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Friend, ServiceOperation.listFriends, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Links the current user and the specified users as brainCloud friends.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - ADD_FRIENDS
  /// </remarks>
  /// <param name="profileIds">Collection of profile IDs.</param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  /// <param name="cbObject"> The user object sent to the callback. </param>
  void AddFriends(List<String> profileIds, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceProfileIds.Value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Friend, ServiceOperation.addFriends, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  /// <param name="cbObject"> The user object sent to the callback. </param>
  void AddFriendsFromPlatform(
      FriendPlatform friendPlatform,
      String mode,
      List<String> externalIds,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceFriendPlatform.Value] =
        friendPlatform.toString();
    data[OperationParam.FriendServiceMode.Value] = mode;
    data[OperationParam.FriendServiceExternalIds.Value] = externalIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall serverCall = ServerCall(ServiceName.Friend,
        ServiceOperation.addFriendsFromPlatform, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Unlinks the current user and the specified users as brainCloud friends.
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - REMOVE_FRIENDS
  /// </remarks>
  /// <param name="profileIds">Collection of profile IDs.</param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  /// <param name="cbObject"> The user object sent to the callback. </param>
  void RemoveFriends(List<String> profileIds, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceProfileIds.Value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.Friend, ServiceOperation.removeFriends, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Get users online status
  /// </summary>
  /// <remarks>
  /// Service Name - Friend
  /// Service Operation - GET_USERS_ONLINE_STATUS
  /// </remarks>
  /// <param name="profileIds">Collection of profile IDs.</param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  /// <param name="cbObject"> The user object sent to the callback. </param>
  void GetUsersOnlineStatus(List<String> profileIds, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.FriendServiceProfileIds.Value] = profileIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.getUsersOnlineStatus, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void FindUsersByNameStartingWith(String searchText, int maxResults,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceSearchText.Value] = searchText;
    data[OperationParam.FriendServiceMaxResults.Value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.findUsersByNameStartingWith, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void FindUsersByUniversalIdStartingWith(String searchText, int maxResults,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.FriendServiceSearchText.Value] = searchText;
    data[OperationParam.FriendServiceMaxResults.Value] = maxResults;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.Friend,
        ServiceOperation.findUsersByUniversalIdStartingWith, data, callback);
    _clientRef.sendRequest(sc);
  }
}

enum FriendPlatform { all, brainCloud, facebook }
