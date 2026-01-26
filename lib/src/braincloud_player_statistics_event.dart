// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/braincloud_player_statistics.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudPlayerStatisticsEvent {
  final BrainCloudClient _clientRef;

  BrainCloudPlayerStatisticsEvent(this._clientRef);

  /// Trigger a server-side event that will update the user's statistics.
  /// This may cause one or more awards to be sent back to the user,
  /// such as achievements, experience, or other rewards. Achievements
  /// will be sent by this client library to the appropriate awards service
  /// (e.g., Apple Game Center, Google Play Games, etc.).
  /// This mechanism supersedes the PlayerStatisticsService API methods,
  /// which only update raw statistics without triggering rewards.
  /// Service Name - PlayerStatisticsEvent
  /// Service Operation - Trigger
  ///
  /// @param in_eventName Name of the statistics event to trigger.
  /// @param in_eventMultiplier Optional multiplier to apply to the event.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> triggerStatsEvent(
      {required String eventName, required int eventMultiplier}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticEventServiceEventName.value] = eventName;
    data[OperationParam.playerStatisticEventServiceEventMultiplier.value] =
        eventMultiplier;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatisticsEvent,
        ServiceOperation.trigger, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// See documentation for TriggerStatsEvent for more
  /// documentation.
  ///
  /// Service Name - PlayerStatisticsEvent
  /// Service Operation - TriggerMultiple
  ///
  /// @param jsonData
  /// ```JSON
  /// jsonData
  ///   [
  ///     {
  ///       "eventName": "event1",
  ///       "eventMultiplier": 1
  ///     },
  ///     {
  ///       "eventName": "event2",
  ///       "eventMultiplier": 1
  ///     }
  ///   ]
  /// ```
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> triggerStatsEvents(
      {required List<Map<String, dynamic>> jsonData}) async {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.playerStatisticEventServiceEvents.value] = jsonData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatisticsEvent,
        ServiceOperation.triggerMultiple, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
