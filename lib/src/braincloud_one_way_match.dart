import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudOneWayMatch {
  final BrainCloudClient _clientRef;

  BrainCloudOneWayMatch(this._clientRef);

  /// Starts a match

  /// Service Name - OneWayMatch
  /// Service Operation - StartMatch

  /// @param otherPlayerId The player to start a match with
  /// @param rangeDelta The range delta used for the initial match search
  /// @returns Future<ServerResponse>
  Future<ServerResponse> startMatch(
      {required String otherPlayerId, required int rangeDelta}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlayerId.value] = otherPlayerId;
    data[OperationParam.offlineMatchServiceRangeDelta.value] = rangeDelta;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.oneWayMatch, ServiceOperation.startMatch, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Cancels a match

  /// Service Name - OneWayMatch
  /// Service Operation - CancelMatch

  /// @param playbackStreamId
  /// The playback stream id returned in the start match

  /// @returns Future<ServerResponse>
  Future<ServerResponse> cancelMatch({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.oneWayMatch, ServiceOperation.cancelMatch, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Completes a match

  /// Service Name - OneWayMatch
  /// Service Operation - CompleteMatch

  /// @param playbackStreamId
  /// The playback stream id returned in the initial start match

  /// @returns Future<ServerResponse>
  Future<ServerResponse> completeMatch({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.oneWayMatch,
        ServiceOperation.completeMatch, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
