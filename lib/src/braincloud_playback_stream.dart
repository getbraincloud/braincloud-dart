import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void startStream(String targetPlayerId, bool includeSharedData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceTargetPlayerId.value] =
        targetPlayerId;
    data[OperationParam.playbackStreamServiceIncludeSharedData.value] =
        includeSharedData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.startStream, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readStream(String playbackStreamId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.readStream, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void endStream(String playbackStreamId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.playbackStream, ServiceOperation.endStream, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void deleteStream(String playbackStreamId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.deleteStream, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void addEvent(String playbackStreamId, String eventData, String summary,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.playbackStream, ServiceOperation.addEvent, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getRecentStreamsForInitiatingPlayer(
      String initiatingPlayerId,
      int maxNumStreams,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceInitiatingPlayerId.value] =
        initiatingPlayerId;
    data[OperationParam.playbackStreamServiceMaxNumberOfStreams.value] =
        maxNumStreams;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.getRecentStreamsForInitiatingPlayer, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getRecentStreamsForTargetPlayer(String targetPlayerId, int maxNumStreams,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.playbackStreamServiceTargetPlayerId.value] =
        targetPlayerId;
    data[OperationParam.playbackStreamServiceMaxNumberOfStreams.value] =
        maxNumStreams;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.playbackStream,
        ServiceOperation.getAttributes, data, callback);
    _clientRef.sendRequest(sc);
  }
}
