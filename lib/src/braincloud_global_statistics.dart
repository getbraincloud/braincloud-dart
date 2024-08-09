import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void readAllGlobalStats(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.globalStatistics, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void readGlobalStatsSubset(List<String> globalStats, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStatisticsServiceStats.Value] = globalStats;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.readSubset, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readGlobalStatsForCategory(String category, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceCategory.Value] = category;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.readForCategory, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void incrementGlobalStats(String jsonData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    Map<String, dynamic> stats = jsonDecode(jsonData);
    data[OperationParam.PlayerStatisticsServiceStats.Value] = stats;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.updateIncrement, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void processStatistics(Map<String, dynamic> statisticsData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStatisticsServiceStats.Value] = statisticsData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.globalStatistics,
        ServiceOperation.processStatistics, data, callback);
    _clientRef.sendRequest(sc);
  }
}
