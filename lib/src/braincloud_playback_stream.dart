import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudPlaybackStream {
  final BrainCloudClient _clientRef;

  BrainCloudPlaybackStream(this._clientRef);

  /// Starts a stream
  ///
  /// Service Name - PlaybackStream
  /// Service Operation - StartStream
  ///
  /// @param targetPlayerId
  /// The player to start a stream with
  ///
  /// @param includeSharedData
  /// Whether to include shared data in the stream
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> startStream(
      {required String targetPlayerId, required bool includeSharedData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceTargetPlayerId.value] =
        targetPlayerId;
    data[OperationParam.playbackStreamServiceIncludeSharedData.value] =
        includeSharedData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.startStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reads a stream
  ///
  /// Service Name - PlaybackStream
  /// Service Operation - ReadStream
  ///
  /// @param playbackStreamId
  /// Identifies the stream to read
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> readStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.readStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Ends a stream
  ///
  /// Service Name - PlaybackStream
  /// Service Operation - EndStream
  ///
  /// @param playbackStreamId
  /// Identifies the stream to read
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> endStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
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
        ServiceName.playbackStream, ServiceOperation.endStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Deletes a stream
  ///
  /// Service Name - PlaybackStream
  /// Service Operation - DeleteStream
  ///
  /// @param playbackStreamId
  /// Identifies the stream to read
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> deleteStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.deleteStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Adds a stream event
  ///
  /// Service Name - PlaybackStream
  /// Service Operation - AddEvent
  ///
  /// @param playbackStreamId
  /// Identifies the stream to read
  ///
  /// @param eventData
  /// Describes the event
  ///
  /// @param summary
  /// Current summary data as of this event
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> addEvent(
      {required String playbackStreamId,
      Map<String, dynamic>? eventData,
      Map<String, dynamic>? summary}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    if (eventData != null) {
      data[OperationParam.playbackStreamServiceEventData.value] = eventData;
    }

    if (summary != null) {
      data[OperationParam.playbackStreamServiceSummary.value] = summary;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.playbackStream, ServiceOperation.addEvent, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets recent streams for initiating player
  ///
  /// Service Name - PlaybackStream
  /// Service Operation - GetRecentSteamsForInitiatingPlayer
  ///
  /// @param initiatingPlayerId
  /// The player that started the stream
  ///
  /// @param maxNumStreams
  /// The player that started the stream
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getRecentStreamsForInitiatingPlayer(
      {String? initiatingPlayerId, required int maxNumStreams}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceInitiatingPlayerId.value] =
        initiatingPlayerId;
    data[OperationParam.playbackStreamServiceMaxNumberOfStreams.value] =
        maxNumStreams;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.getRecentStreamsForInitiatingPlayer, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets recent streams for target player
  ///
  /// Service Name - PlaybackStream
  /// Service Operation - GetRecentSteamsForTargetPlayer
  ///
  /// @param targetPlayerId
  /// The player that started the stream
  ///
  /// @param maxNumStreams
  /// The player that started the stream
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getRecentStreamsForTargetPlayer(
      {String? targetPlayerId, required int maxNumStreams}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceTargetPlayerId.value] =
        targetPlayerId;
    data[OperationParam.playbackStreamServiceMaxNumberOfStreams.value] =
        maxNumStreams;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.getRecentStreamsForTargetPlayer, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Protects a playback stream from being purged (but not deleted) for the 
  /// given number of days (from now). If the number of days given is less 
  /// than the normal purge interval days (from createdAt), the longer protection 
  /// date is applied. Can only be called by users involved in the playback stream.
  ///
  /// Service Name - PlaybackStream
  /// Service Operation - PROTECT_STREAM_UNTIL
  ///
  /// @param playbackStreamId
  /// Identifies the stream to protect
  ///
  /// @param numDays
  /// The number of days the stream is to be protected (from now).
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> protectStreamUntil(
      {required String playbackStreamId, required int numDays}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;
    data[OperationParam.playbackStreamServiceNumDays.value] = numDays;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.ProtectStreamUntil, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }


}
