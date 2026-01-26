// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudOneWayMatch {
  final BrainCloudClient _clientRef;

  BrainCloudOneWayMatch(this._clientRef);

  /// Starts a match
  /// Service Name - OneWayMatch
  /// Service Operation - StartMatch
  ///
  /// @param in_otherPlayerId The player to start a match with
  /// @param in_rangeDelta The range delta used for the initial match search
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> startMatch(
      {required String playerId, required int rangeDelta}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlayerId.value] = playerId;
    data[OperationParam.offlineMatchServiceRangeDelta.value] = rangeDelta;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.oneWayMatch, ServiceOperation.startMatch, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Cancels a match
  /// Service Name - OneWayMatch
  /// Service Operation - CancelMatch
  ///
  /// @param in_playbackStreamId The playback stream id returned in the start match
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> cancelMatch({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.oneWayMatch, ServiceOperation.cancelMatch, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Completes a match
  /// Service Name - OneWayMatch
  /// Service Operation - CompleteMatch
  ///
  /// @param in_playbackStreamId The playback stream id returned in the initial start match
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> completeMatch({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.oneWayMatch,
        ServiceOperation.completeMatch, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
