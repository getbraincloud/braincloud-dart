import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudPresence {
  final BrainCloudClient _clientRef;

  BrainCloudPresence(this._clientRef);

  /// <summary>
  /// Force an RTT presence update to all listeners of the caller.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - ForcePush
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
  void forcePush(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.forcePush, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Force an RTT presence update to all listeners of the caller.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - GetPresenceOfFriends
  /// </remarks>
  /// <param name="platform">
  /// The store platform. Valid stores are:
  /// - all
  /// - brainCloud
  /// - facebook
  /// </param>
  /// <param name="includeOffline">
  /// Will not include offline profiles unless includeOffline is set to true.
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
  void getPresenceOfFriends(String platform, bool includeOffline,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PresenceServicePlatform.Value] = platform;
    data[OperationParam.PresenceServiceIncludeOffline.Value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfFriends, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///    Gets the presence data for the given <groupId>. Will not include
  /// offline profiles unless<includeOffline> is set to true.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - GetPresenceOfGroup
  /// </remarks>
  /// <param name="groupId">
  /// The id for the group
  /// </param>
  /// <param name="includeOffline">
  /// Will not include offline profiles unless includeOffline is set to true.
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
  void getPresenceOfGroup(String groupId, bool includeOffline,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PresenceServiceGroupId.Value] = groupId;
    data[OperationParam.PresenceServiceIncludeOffline.Value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfGroup, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///Gets the presence data for the given<profileIds>.Will not include
  /// offline profiles unless<includeOffline> is set to true.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - GetPresenceOfUsers
  /// </remarks>
  /// <param name="profileIds">
  /// List of profile Ids
  /// </param>
  /// <param name="includeOffline">
  /// Will not include offline profiles unless includeOffline is set to true.
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
  void getPresenceOfUsers(List<String> profileIds, bool includeOffline,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PresenceServiceProfileIds.Value] = profileIds;
    data[OperationParam.PresenceServiceIncludeOffline.Value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfUsers, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Registers the caller for RTT presence updates from friends for the
  /// given platform. Can be one of "all", "brainCloud", or "facebook".
  /// If bidirectional is set to true, then also registers the targeted
  /// users for presence updates from the caller.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - RegisterListenersForFriends
  /// </remarks>
  /// <param name="platform">
  /// The store platform. Valid stores are:
  /// - all
  /// - brainCloud
  /// - facebook
  /// </param>
  /// <param name="bidirectional">
  /// Allows registration of target user for presence update
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
  void registerListenersForFriends(String platform, bool bidirectional,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PresenceServicePlatform.Value] = platform;
    data[OperationParam.PresenceServiceBidirectional.Value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForFriends, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Registers the caller for RTT presence updates from the members of the given groupId.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - RegisterListenersForGroup
  /// </remarks>
  /// <param name="groupId">
  /// The Id of the group
  /// </param>
  /// <param name="bidirectional">
  /// Allows registration of target user for presence update
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
  void registerListenersForGroup(String groupId, bool bidirectional,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PresenceServiceGroupId.Value] = groupId;
    data[OperationParam.PresenceServiceBidirectional.Value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForGroup, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Registers the caller for RTT presence updates for the given
  /// profileIds. If bidirectional is set to true, then also registers
  /// the targeted users for presence updates from the caller.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - RegisterListenersForGroup
  /// </remarks>
  /// <param name="profileIds">
  /// List of profile Ids
  /// </param>
  /// <param name="bidirectional">
  /// Allows registration of target user for presence update
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
  void registerListenersForProfiles(List<String> profileIds, bool bidirectional,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PresenceServiceProfileIds.Value] = profileIds;
    data[OperationParam.PresenceServiceBidirectional.Value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForProfiles, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Update the presence data visible field for the caller.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - SetVisibility
  /// </remarks>
  /// <param name="visible">
  /// Determines if the user is visible
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
  void setVisibility(bool visible, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PresenceServiceVisibile.Value] = visible;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.setVisibility, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Stops the caller from receiving RTT presence updates. Does not
  /// affect the broadcasting of *their* presence updates to other
  /// listeners.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - StopListening
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
  void stopListening(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.stopListening, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Update the presence data activity field for the caller.
  /// </summary>
  /// <remarks>
  /// Service Name - Presence
  /// Service Operation - UpdateActivity
  /// </remarks>
  /// <param name="jsonActivity">
  /// the Json data
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
  void updateActivity(String jsonActivity, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    var jsonActivityString = jsonDecode(jsonActivity);
    data[OperationParam.PresenceServiceActivity.Value] = jsonActivityString;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.updateActivity, data, callback);
    _clientRef.sendRequest(sc);
  }
}
