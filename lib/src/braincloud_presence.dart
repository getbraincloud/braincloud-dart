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

/// Gets the presence data for the given <platform>. Can be one of "all",
/// "brainCloud", or "facebook". Will not include offline profiles
/// unless <includeOffline> is set to true.
///
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

/// Gets the presence data for the given <groupId>. Will not include
/// offline profiles unless <includeOffline> is set to true.
///
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

/// Gets the presence data for the given <profileIds>. Will not include
/// offline profiles unless <includeOffline> is set to true.
///
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

/// Registers the caller for RTT presence updates from friends for the
/// given <platform>. Can be one of "all", "brainCloud", or "facebook".
/// If <bidirectional> is set to true, then also registers the targeted
/// users for presence updates from the caller.
///
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

/// Registers the caller for RTT presence updates from the members of
/// the given <groupId>. Caller must be a member of said group. If
/// <bidirectional> is set to true, then also registers the targeted
/// users for presence updates from the caller.
///
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

/// Registers the caller for RTT presence updates for the given
/// <profileIds>. If <bidirectional> is set to true, then also registers
/// the targeted users for presence updates from the caller.
///
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

/// Update the presence data visible field for the caller.
///
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

/// Stops the caller from receiving RTT presence updates. Does not
/// affect the broadcasting of *their* presence updates to other
/// listeners.
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

/// Update the presence data activity field for the caller.
///
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
