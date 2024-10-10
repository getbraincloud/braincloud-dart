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

  /// Starts a stream

  /// Service Name - PlaybackStream
  /// Service Operation - StartStream

  /// @param targetPlayerId
  /// The player to start a stream with

  /// @param includeSharedData
  /// Whether to include shared data in the stream

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Reads a stream

  /// Service Name - PlaybackStream
  /// Service Operation - ReadStream

  /// @param playbackStreamId
  /// Identifies the stream to read

  /// @returns Future<ServerResponse>
  Future<ServerResponse> readStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Ends a stream

  /// Service Name - PlaybackStream
  /// Service Operation - EndStream

  /// @param playbackStreamId
  /// Identifies the stream to read

  /// @returns Future<ServerResponse>
  Future<ServerResponse> endStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

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
        ServiceName.playbackStream, ServiceOperation.endStream, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Deletes a stream

  /// Service Name - PlaybackStream
  /// Service Operation - DeleteStream

  /// @param playbackStreamId
  /// Identifies the stream to read

  /// @returns Future<ServerResponse>
  Future<ServerResponse> deleteStream({required String playbackStreamId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Adds a stream event

  /// Service Name - PlaybackStream
  /// Service Operation - AddEvent

  /// @param playbackStreamId
  /// Identifies the stream to read

  /// @param eventData
  /// Describes the event

  /// @param summary
  /// Current summary data as of this event

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Gets recent streams for initiating player

  /// Service Name - PlaybackStream
  /// Service Operation - GetRecentSteamsForInitiatingPlayer

  /// @param initiatingPlayerId
  /// The player that started the stream

  /// @param maxNumStreams
  /// The player that started the stream

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Gets recent streams for target player

  /// Service Name - PlaybackStream
  /// Service Operation - GetRecentSteamsForTargetPlayer

  /// @param targetPlayerId
  /// The player that started the stream

  /// @param maxNumStreams
  /// The player that started the stream

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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
