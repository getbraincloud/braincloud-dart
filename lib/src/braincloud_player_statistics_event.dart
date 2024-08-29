import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudPlayerStatisticsEvent {
  final BrainCloudClient _clientRef;

  BrainCloudPlayerStatisticsEvent(this._clientRef);

  /// <summary>
  /// Trigger an event server side that will increase the user statistics.
  /// This may cause one or more awards to be sent back to the user -
  /// could be achievements, experience, etc. Achievements will be sent by this
  /// client library to the appropriate awards service (Apple Game Center, etc).
  ///
  /// This mechanism supercedes the PlayerStatisticsService API methods, since
  /// PlayerStatisticsService API method only update the raw statistics without
  /// triggering the rewards.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatisticsEvent
  /// Service Operation - Trigger
  ///
  /// @see BrainCloudPlayerStatistics
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void triggerUserStatsEvent(String eventName, int eventMultiplier,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticEventServiceEventName.value] = eventName;
    data[OperationParam.playerStatisticEventServiceEventMultiplier.value] =
        eventMultiplier;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.playerStatisticsEvent,
        ServiceOperation.trigger, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// See documentation for TriggerStatsEvent for more
  /// documentation.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatisticsEvent
  /// Service Operation - TriggerMultiple
  /// </remarks>
  /// <param name="jsonData">
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
  /// </param>
  void triggerUserStatsEvents(
      String jsonData, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    List events = jsonDecode(jsonData);
    data[OperationParam.playerStatisticEventServiceEvents.value] = events;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.playerStatisticsEvent,
        ServiceOperation.triggerMultiple, data, callback);
    _clientRef.sendRequest(sc);
  }
}
