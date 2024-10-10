import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudPresence {
  final BrainCloudClient _clientRef;

  BrainCloudPresence(this._clientRef);

  /// Force an RTT presence update to all listeners of the caller.

  /// Service Name - Presence
  /// Service Operation - ForcePush

  /// @returns Future<ServerResponse>
  Future<ServerResponse> forcePush() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.forcePush, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Force an RTT presence update to all listeners of the caller.

  /// Service Name - Presence
  /// Service Operation - GetPresenceOfFriends

  /// @param platform
  /// The store platform. Valid stores are:
  /// - all
  /// - brainCloud
  /// - facebook

  /// @param includeOffline
  /// Will not include offline profiles unless includeOffline is set to true.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getPresenceOfFriends(
      {required String platform, required bool includeOffline}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServicePlatform.value] = platform;
    data[OperationParam.presenceServiceIncludeOffline.value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  ///    Gets the presence data for the given <groupId>. Will not include
  /// offline profiles unless<includeOffline> is set to true.

  /// Service Name - Presence
  /// Service Operation - GetPresenceOfGroup

  /// @param groupId
  /// The id for the group

  /// @param includeOffline
  /// Will not include offline profiles unless includeOffline is set to true.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getPresenceOfGroup(
      {required String groupId, required bool includeOffline}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceGroupId.value] = groupId;
    data[OperationParam.presenceServiceIncludeOffline.value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfGroup, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  ///Gets the presence data for the given<profileIds>.Will not include
  /// offline profiles unless<includeOffline> is set to true.

  /// Service Name - Presence
  /// Service Operation - GetPresenceOfUsers

  /// @param profileIds
  /// List of profile Ids

  /// @param includeOffline
  /// Will not include offline profiles unless includeOffline is set to true.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getPresenceOfUsers(
      {required List<String> profileIds, required bool includeOffline}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceProfileIds.value] = profileIds;
    data[OperationParam.presenceServiceIncludeOffline.value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfUsers, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Registers the caller for RTT presence updates from friends for the
  /// given platform. Can be one of "all", "brainCloud", or "facebook".
  /// If bidirectional is set to true, then also registers the targeted
  /// users for presence updates from the caller.

  /// Service Name - Presence
  /// Service Operation - RegisterListenersForFriends

  /// @param platform
  /// The store platform. Valid stores are:
  /// - all
  /// - brainCloud
  /// - facebook

  /// @param bidirectional
  /// Allows registration of target user for presence update

  /// @returns Future<ServerResponse>
  Future<ServerResponse> registerListenersForFriends(
      {required String platform, required bool bidirectional}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServicePlatform.value] = platform;
    data[OperationParam.presenceServiceBidirectional.value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Registers the caller for RTT presence updates from the members of the given groupId.

  /// Service Name - Presence
  /// Service Operation - RegisterListenersForGroup

  /// @param groupId
  /// The Id of the group

  /// @param bidirectional
  /// Allows registration of target user for presence update

  /// @returns Future<ServerResponse>
  Future<ServerResponse> registerListenersForGroup(
      {required String groupId, required bool bidirectional}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceGroupId.value] = groupId;
    data[OperationParam.presenceServiceBidirectional.value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForGroup, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Registers the caller for RTT presence updates for the given
  /// profileIds. If bidirectional is set to true, then also registers
  /// the targeted users for presence updates from the caller.

  /// Service Name - Presence
  /// Service Operation - RegisterListenersForGroup

  /// @param profileIds
  /// List of profile Ids

  /// @param bidirectional
  /// Allows registration of target user for presence update

  /// @returns Future<ServerResponse>
  Future<ServerResponse> registerListenersForProfiles(
      {required List<String> profileIds, required bool bidirectional}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceProfileIds.value] = profileIds;
    data[OperationParam.presenceServiceBidirectional.value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForProfiles, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Update the presence data visible field for the caller.

  /// Service Name - Presence
  /// Service Operation - SetVisibility

  /// @param visible
  /// Determines if the user is visible

  /// @returns Future<ServerResponse>
  Future<ServerResponse> setVisibility({required bool visible}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceVisibile.value] = visible;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.setVisibility, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Stops the caller from receiving RTT presence updates. Does not
  /// affect the broadcasting of *their* presence updates to other
  /// listeners.

  /// Service Name - Presence
  /// Service Operation - StopListening

  /// @returns Future<ServerResponse>
  Future<ServerResponse> stopListening() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.stopListening, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Update the presence data activity field for the caller.

  /// Service Name - Presence
  /// Service Operation - UpdateActivity

  /// @param jsonActivity
  /// the Json data

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateActivity({required String jsonActivity}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    var jsonActivityString = jsonDecode(jsonActivity);
    data[OperationParam.presenceServiceActivity.value] = jsonActivityString;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.updateActivity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
