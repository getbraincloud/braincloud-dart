import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudGlobalStatistics {
  final BrainCloudClient _clientRef;

  BrainCloudGlobalStatistics(this._clientRef);

  /// <summary>
  /// Method returns all of the global statistics.
  /// </summary>
  /// <remarks>
  /// Service Name - globalGameStatistics
  /// Service Operation - Read
  /// </remarks>
  Future<ServerResponse> readAllGlobalStats() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.globalStatistics, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Reads a subset of global statistics as defined by the input JSON.
  /// </summary>
  /// <remarks>
  /// Service Name - globalGameStatistics
  /// Service Operation - ReadSubset
  /// </remarks>
  /// <param name="globalStats">
  /// A list containing the statistics to read
  /// </param>
  Future<ServerResponse> readGlobalStatsSubset(
      {List<String> globalStats = const []}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = globalStats;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.readSubset, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method retrieves the global statistics for the given category.
  /// </summary>
  /// <remarks>
  /// Service Name - globalGameStatistics
  /// Service Operation - READ_FOR_CATEGORY
  /// </remarks>
  /// <param name="category">
  /// The global statistics category
  /// </param>
  Future<ServerResponse> readGlobalStatsForCategory({String category = ""}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceCategory.value] = category;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.readForCategory, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Atomically increment (or decrement) global statistics.
  /// Global statistics are defined through the brainCloud portal.
  /// </summary>
  /// <remarks>
  /// Service Name - globalGameStatistics
  /// Service Operation - UpdateIncrement
  /// </remarks>
  /// <param name="jsonData">
  /// The JSON encoded data to be sent to the server as follows:
  /// {
  ///   stat1: 10,
  ///   stat2: -5.5,
  /// }
  /// would increment stat1 by 10 and decrement stat2 by 5.5.
  /// For the full statistics grammer see the api.braincloudservers.com site.
  /// There are many more complex operations supported such as:
  /// {
  ///   stat1:INC_TO_LIMIT#9#30
  /// }
  /// which increments stat1 by 9 up to a limit of 30.
  /// </param>
  Future<ServerResponse> incrementGlobalStats({String jsonData = "{}"}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    Map<String, dynamic> stats = jsonDecode(jsonData);
    data[OperationParam.playerStatisticsServiceStats.value] = stats;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.updateIncrement, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Apply statistics grammar to a partial set of statistics.
  /// </summary>
  /// <remarks>
  /// Service Name - globalGameStatistics
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
      {Map<String, dynamic> statisticsData = const {}}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = statisticsData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.processStatistics, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
