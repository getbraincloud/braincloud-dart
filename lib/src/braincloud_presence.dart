// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudPresence {
  final BrainCloudClient _clientRef;

  BrainCloudPresence(this._clientRef);

  /// Force an RTT presence update to all listeners of the caller.
  /// Service Name - Presence
  /// Service Operation - ForcePush
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> forcePush() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.forcePush, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Retrieves the presence data for friends on the specified platform.
  ///
  /// @param in_platform One of "all", "brainCloud", or "facebook".
  /// @param in_includeOffline If true, includes offline profiles.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getPresenceOfFriends(
      {required String platform, required bool includeOffline}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServicePlatform.value] = platform;
    data[OperationParam.presenceServiceIncludeOffline.value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the presence data for members of a given group.
  ///
  /// @param in_groupId Group ID to query.
  /// @param in_includeOffline If true, includes offline profiles.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getPresenceOfGroup(
      {required String groupId, required bool includeOffline}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceGroupId.value] = groupId;
    data[OperationParam.presenceServiceIncludeOffline.value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfGroup, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the presence data for the specified users.
  ///
  /// @param in_profileIds Vector of profile IDs to query.
  /// @param in_includeOffline If true, includes offline profiles.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getPresenceOfUsers(
      {required List<String> profileIds, required bool includeOffline}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceProfileIds.value] = profileIds;
    data[OperationParam.presenceServiceIncludeOffline.value] = includeOffline;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.getPresenceOfUsers, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Registers the caller for RTT presence updates from friends on a given platform.
  ///
  /// @param in_platform One of "all", "brainCloud", or "facebook".
  /// @param in_bidirectional If true, also registers targeted users for updates from the caller.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> registerListenersForFriends(
      {required String platform, required bool bidirectional}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServicePlatform.value] = platform;
    data[OperationParam.presenceServiceBidirectional.value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForFriends, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Registers the caller for RTT presence updates from members of a given group.
  ///
  /// @param in_groupId Group ID to listen to. Caller must be a member.
  /// @param in_bidirectional If true, also registers targeted users for updates from the caller.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> registerListenersForGroup(
      {required String groupId, required bool bidirectional}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceGroupId.value] = groupId;
    data[OperationParam.presenceServiceBidirectional.value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForGroup, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Registers the caller for RTT presence updates from specific profiles.
  ///
  /// @param in_profileIds Vector of profile IDs to listen to.
  /// @param in_bidirectional If true, also registers targeted users for updates from the caller.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> registerListenersForProfiles(
      {required List<String> profileIds, required bool bidirectional}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceProfileIds.value] = profileIds;
    data[OperationParam.presenceServiceBidirectional.value] = bidirectional;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.presence,
        ServiceOperation.registerListenersForProfiles, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Updates the visibility field of the caller's presence data.
  ///
  /// @param in_visible True to make the caller visible, false to hide.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> setVisibility({required bool visible}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.presenceServiceVisibile.value] = visible;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.setVisibility, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Stops the caller from receiving RTT presence updates.
  /// Does not affect broadcasting of the caller's own presence updates.
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> stopListening() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.stopListening, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Updates the activity field of the caller's presence data.
  ///
  /// @param in_jsonActivity JSON string representing activity information.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> updateActivity(
      {required Map<String, dynamic> activity}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    var jsonActivityString = activity;
    data[OperationParam.presenceServiceActivity.value] = jsonActivityString;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.presence, ServiceOperation.updateActivity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
