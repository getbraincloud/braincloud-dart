import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudOneWayMatch {
  final BrainCloudClient _clientRef;

  BrainCloudOneWayMatch(this._clientRef);

  /// <summary>
  /// Starts a match
  /// </summary>
  /// <remarks>
  /// Service Name - OneWayMatch
  /// Service Operation - StartMatch
  /// </remarks>
  /// <param name="otherPlayerId"> The player to start a match with </param>
  /// <param name="rangeDelta"> The range delta used for the initial match search </param>
  /// <param name="success"> The success callback. </param>
  /// <param name="failure"> The failure callback. </param>
  void startMatch(String otherPlayerId, int rangeDelta,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlayerId.value] = otherPlayerId;
    data[OperationParam.offlineMatchServiceRangeDelta.value] = rangeDelta;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.oneWayMatch, ServiceOperation.startMatch, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Cancels a match
  /// </summary>
  /// <remarks>
  /// Service Name - OneWayMatch
  /// Service Operation - CancelMatch
  /// </remarks>
  /// <param name="playbackStreamId">
  /// The playback stream id returned in the start match
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void cancelMatch(String playbackStreamId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.oneWayMatch, ServiceOperation.cancelMatch, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Completes a match
  /// </summary>
  /// <remarks>
  /// Service Name - OneWayMatch
  /// Service Operation - CompleteMatch
  /// </remarks>
  /// <param name="playbackStreamId">
  /// The playback stream id returned in the initial start match
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void completeMatch(String playbackStreamId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.offlineMatchServicePlaybackStreamId.value] =
        playbackStreamId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.oneWayMatch,
        ServiceOperation.completeMatch, data, callback);
    _clientRef.sendRequest(sc);
  }
}
