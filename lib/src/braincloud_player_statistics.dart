import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudPlayerStatistics {
  final BrainCloudClient _clientRef;

  BrainCloudPlayerStatistics(this._clientRef);

  /// <summary>
  /// Read all available user statistics.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - Read
  /// </remarks>
  Future<ServerResponse> readAllUserStats() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.playerStatistics, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Reads a subset of user statistics as defined by the input JSON.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - ReadSubset
  /// </remarks>
  /// <param name="playerStats">
  /// A list containing the subset of statistics to read.
  /// </param>
  Future<ServerResponse> readUserStatsSubset(
      {required List<String> playerStats}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = playerStats;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.readSubset, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Method retrieves the user statistics for the given category.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - READ_FOR_CATEGORY
  /// </remarks>
  /// <param name="category">
  /// The user statistics category
  /// </param>
  Future<ServerResponse> readUserStatsForCategory({required String category}) {
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceCategory.value] = category;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.readForCategory, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Reset all of the statistics for this user back to their initial value.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - Reset
  ///
  /// </remarks>
  Future<ServerResponse> resetAllUserStats() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.playerStatistics, ServiceOperation.reset, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Atomically increment (or decrement) user statistics.
  /// Any rewards that are triggered from user statistic increments
  /// will be considered. User statistics are defined through the brainCloud portal.
  /// Note also that the "xpCapped" property is returned (true/false depending on whether
  /// the xp cap is turned on and whether the user has hit it).
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - Update
  /// </remarks>
  /// <param name="stats">
  /// Stats name and their increments:
  /// {
  ///  {"stat1", 10},
  ///  {"stat1", -5}
  /// }
  ///
  /// would increment stat1 by 10 and decrement stat2 by 5.
  /// For the full statistics grammer see the api.braincloudservers.com site.
  /// There are many more complex operations supported such as:
  /// {
  ///   stat1:INC_TO_LIMIT#9#30
  /// }
  /// which increments stat1 by 9 up to a limit of 30.
  /// </param>
  Future<ServerResponse> incrementUserStats(
      {required Map<String, dynamic> stats}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = stats;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.playerStatistics, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Apply statistics grammar to a partial set of statistics.
  /// </summary>
  /// <remarks>
  /// Service Name - playerStatistics
  /// Service Operation - PROCESS_STATISTICS
  /// </remarks>
  /// <param name="statisticsData">
  /// Example data to be passed to method:
  /// {
  ///     "DEAD_CATS": "RESET",
  ///     "LIVES_LEFT": "SET#9",
  ///     "MICE_KILLED": "INC#2",
  ///     "DOG_SCARE_BONUS_POINTS": "INC#10",
  ///     "TREES_CLIMBED": 1
  /// }
  /// </param>
  Future<ServerResponse> processStatistics(
      {required Map<String, dynamic> statisticsData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = statisticsData;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.processStatistics, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Returns JSON representing the next experience level for the user.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - ReadNextXpLevel
  /// </remarks>
  Future<ServerResponse> getNextExperienceLevel() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.readNextXpLevel, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Increments the user's experience. If the user goes up a level,
  /// the new level details will be returned along with a list of rewards.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - Update
  /// </remarks>
  /// <param name="xpValue">
  /// The amount to increase the user's experience by
  /// </param>
  Future<ServerResponse> incrementExperiencePoints({required int xpValue}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsExperiencePoints.value] = xpValue;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.playerStatistics, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Sets the user's experience to an absolute value. Note that this
  /// is simply a set and will not reward the user if their level changes
  /// as a result.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - SetXpPoints
  /// </remarks>
  /// <param name="xpValue">
  /// The amount to set the the player's experience to
  /// </param>
  Future<ServerResponse> setExperiencePoints({required int xpValue}) {
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsExperiencePoints.value] = xpValue;

    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerStatistics,
        ServiceOperation.setXpPoints, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
