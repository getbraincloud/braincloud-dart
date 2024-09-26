import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudPlaybackStream {
  final BrainCloudClient _clientRef;

  BrainCloudPlaybackStream(this._clientRef);

  /// <summary>
  /// Starts a stream
  /// </summary>
  /// <remarks>
  /// Service Name - PlaybackStream
  /// Service Operation - StartStream
  /// </remarks>
  /// <param name="targetPlayerId">
  /// The player to start a stream with
  /// </param>
  /// <param name="includeSharedData">
  /// Whether to include shared data in the stream
  /// </param>
  Future<ServerResponse> startStream(
      {required String targetPlayerId, required bool includeSharedData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceTargetPlayerId.value] =
        targetPlayerId;
    data[OperationParam.playbackStreamServiceIncludeSharedData.value] =
        includeSharedData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.startStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Reads a stream
  /// </summary>
  /// <remarks>
  /// Service Name - PlaybackStream
  /// Service Operation - ReadStream
  /// </remarks>
  /// <param name="playbackStreamId">
  /// Identifies the stream to read
  /// </param>
  Future<ServerResponse> readStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
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
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.readStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Ends a stream
  /// </summary>
  /// <remarks>
  /// Service Name - PlaybackStream
  /// Service Operation - EndStream
  /// </remarks>
  /// <param name="playbackStreamId">
  /// Identifies the stream to read
  /// </param>
  Future<ServerResponse> endStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
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
        ServiceName.playbackStream, ServiceOperation.endStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Deletes a stream
  /// </summary>
  /// <remarks>
  /// Service Name - PlaybackStream
  /// Service Operation - DeleteStream
  /// </remarks>
  /// <param name="playbackStreamId">
  /// Identifies the stream to read
  /// </param>
  Future<ServerResponse> deleteStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
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
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.deleteStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Adds a stream event
  /// </summary>
  /// <remarks>
  /// Service Name - PlaybackStream
  /// Service Operation - AddEvent
  /// </remarks>
  /// <param name="playbackStreamId">
  /// Identifies the stream to read
  /// </param>
  /// <param name="eventData">
  /// Describes the event
  /// </param>
  /// <param name="summary">
  /// Current summary data as of this event
  /// </param>
  Future<ServerResponse> addEvent(
      {required String playbackStreamId,
      required String eventData,
      required String summary}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    if (Util.isOptionalParameterValid(eventData)) {
      Map<String, dynamic> jsonEventData = jsonDecode(eventData);
      data[OperationParam.playbackStreamServiceEventData.value] = jsonEventData;
    }

    if (Util.isOptionalParameterValid(summary)) {
      Map<String, dynamic> jsonSummary = jsonDecode(summary);
      data[OperationParam.playbackStreamServiceSummary.value] = jsonSummary;
    }

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
        ServiceName.playbackStream, ServiceOperation.addEvent, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets recent streams for initiating player
  /// </summary>
  /// <remarks>
  /// Service Name - PlaybackStream
  /// Service Operation - GetRecentSteamsForInitiatingPlayer
  /// </remarks>
  /// <param name="initiatingPlayerId">
  /// The player that started the stream
  /// </param>
  /// <param name="maxNumStreams">
  /// The player that started the stream
  /// </param>
  Future<ServerResponse> getRecentStreamsForInitiatingPlayer(
      {required String initiatingPlayerId, required int maxNumStreams}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceInitiatingPlayerId.value] =
        initiatingPlayerId;
    data[OperationParam.playbackStreamServiceMaxNumberOfStreams.value] =
        maxNumStreams;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.getRecentStreamsForInitiatingPlayer, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets recent streams for target player
  /// </summary>
  /// <remarks>
  /// Service Name - PlaybackStream
  /// Service Operation - GetRecentSteamsForTargetPlayer
  /// </remarks>
  /// <param name="targetPlayerId">
  /// The player that started the stream
  /// </param>
  /// <param name="maxNumStreams">
  /// The player that started the stream
  /// </param>
  Future<ServerResponse> getRecentStreamsForTargetPlayer(
      {required String targetPlayerId, required int maxNumStreams}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceTargetPlayerId.value] =
        targetPlayerId;
    data[OperationParam.playbackStreamServiceMaxNumberOfStreams.value] =
        maxNumStreams;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.getAttributes, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
