// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudPlayerStatistics {
  final BrainCloudClient _clientRef;

  BrainCloudPlayerStatistics(this._clientRef);

  /// Read all available user statistics.
  /// Service Name - PlayerStatistics
  /// Service Operation - Read
  ///
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> readAllUserStats() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.playerStatistics, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Reads a subset of user statistics as defined by the input collection.
  /// Service Name - PlayerStatistics
  /// Service Operation - ReadSubset
  ///
  /// @param in_statistics A collection containing the subset of statistics to read:
  ///        ex. [ "pantaloons", "minions" ]
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> readUserStatsSubset(
      {required List<String> userStats}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = userStats;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.readSubset, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method retrieves the user statistics for the given category.
  /// Service Name - PlayerStatistics
  /// Service Operation - READ_FOR_CATEGORY
  ///
  /// @param in_category The user statistics category
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> readUserStatsForCategory({required String category}) {
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceCategory.value] = category;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.readForCategory, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Reset all of the statistics for this user back to their initial value.
  /// Service Name - PlayerStatistics
  /// Service Operation - Reset
  ///
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> resetAllUserStats() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.playerStatistics, ServiceOperation.reset, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Atomically increment (or decrement) user statistics.
  /// Any rewards that are triggered from user statistic increments
  /// will be considered. User statistics are defined through the brainCloud portal.
  /// Note also that the "xpCapped" property is returned (true/false depending on whether
  /// the xp cap is turned on and whether the user has hit it).
  /// Service Name - PlayerStatistics
  /// Service Operation - Update
  ///
  /// @param in_jsonData The JSON encoded data to be sent to the server as follows:
  ///        {
  ///        stat1: 10,
  ///        stat2: -5.5,
  ///        }
  ///        would increment stat1 by 10 and decrement stat2 by 5.5.
  ///        For the full statistics grammer see the api.braincloudservers.com site.
  ///        There are many more complex operations supported such as:
  ///        {
  ///        stat1:INC_TO_LIMIT#9#30
  ///        }
  ///        which increments stat1 by 9 up to a limit of 30.
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> incrementUserStats(
      {required Map<String, dynamic> statistics}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = statistics;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.playerStatistics, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Apply statistics grammar to a partial set of statistics.
  /// Service Name - PlayerStatistics
  /// Service Operation - PROCESS_STATISTICS
  ///
  /// @param in_jsonData The JSON format is as follows:
  ///        {
  ///        "DEAD_CATS": "RESET",
  ///        "LIVES_LEFT": "SET#9",
  ///        "MICE_KILLED": "INC#2",
  ///        "DOG_SCARE_BONUS_POINTS": "INC#10",
  ///        "TREES_CLIMBED": 1
  ///        }
  /// @param in_callback Method to be invoked when the server response is received.
  ///
  Future<ServerResponse> processStatistics(
      {required Map<String, dynamic> statistics}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = statistics;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.processStatistics, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Returns JSON representing the next experience level for the user.
  /// Service Name - PlayerStatistics
  /// Service Operation - ReadNextXpLevel
  ///
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> getNextExperienceLevel() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.readNextXpLevel, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Increments the user's experience. If the user goes up a level,
  /// the new level details will be returned along with a list of rewards.
  /// Service Name - PlayerStatistics
  /// Service Operation - UpdateIncrement
  ///
  /// @param in_xpValue The amount to increase the user's experience by
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> incrementExperiencePoints({required int xpValue}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsExperiencePoints.value] = xpValue;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.playerStatistics, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Sets the user's experience to an absolute value. Note that this
  /// is simply a set and will not reward the user if their level changes
  /// as a result.
  /// Service Name - PlayerStatistics
  /// Service Operation - SetXpPoints
  ///
  /// @param in_xpValue The amount to set the the user's experience to
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> setExperiencePoints({required int xpValue}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsExperiencePoints.value] = xpValue;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.setXpPoints, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
