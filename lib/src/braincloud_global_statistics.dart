import 'dart:async';

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

  /// Method returns all of the global statistics.

  /// Service Name - globalGameStatistics
  /// Service Operation - Read

  /// @returns Future<ServerResponse>
  Future<ServerResponse> readAllGlobalStats() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.globalStatistics, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reads a subset of global statistics as defined by the input JSON.

  /// Service Name - globalGameStatistics
  /// Service Operation - ReadSubset

  /// @param globalStats
  /// A list containing the statistics to read

  /// @returns Future<ServerResponse>
  Future<ServerResponse> readGlobalStatsSubset(
      {required List<String> globalStats}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = globalStats;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.readSubset, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves the global statistics for the given category.

  /// Service Name - globalGameStatistics
  /// Service Operation - READ_FOR_CATEGORY

  /// @param category
  /// The global statistics category

  /// @returns Future<ServerResponse>
  Future<ServerResponse> readGlobalStatsForCategory(
      {required String category}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceCategory.value] = category;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.readForCategory, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Atomically increment (or decrement) global statistics.
  /// Global statistics are defined through the brainCloud portal.

  /// Service Name - globalGameStatistics
  /// Service Operation - UpdateIncrement

  /// @param jsonData
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

  /// @returns Future<ServerResponse>
  Future<ServerResponse> incrementGlobalStats(
      {required Map<String, dynamic> jsonData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    Map<String, dynamic> stats = jsonData;
    data[OperationParam.playerStatisticsServiceStats.value] = stats;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.updateIncrement, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Apply statistics grammar to a partial set of statistics.

  /// Service Name - globalGameStatistics
  /// Service Operation - PROCESS_STATISTICS

  /// @param statisticsData
  /// Example data to be passed to method:
  /// {
  ///     "DEAD_CATS": "RESET",
  ///     "LIVES_LEFT": "SET#9",
  ///     "MICE_KILLED": "INC#2",
  ///     "DOG_SCARE_BONUS_POINTS": "INC#10",
  ///     "TREES_CLIMBED": 1
  /// }

  /// @returns Future<ServerResponse>
  Future<ServerResponse> processStatistics(
      {required Map<String, dynamic> statisticsData}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};
    data[OperationParam.playerStatisticsServiceStats.value] = statisticsData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
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
