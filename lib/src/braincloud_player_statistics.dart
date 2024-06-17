import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void readAllUserStats(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerStatistics, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Reads a subset of user statistics as defined by the input JSON.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - ReadSubset
  /// </remarks>
  /// <param name="userStats">
  /// A list containing the subset of statistics to read.
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
  void readUserStatsSubset(List<String> playerStats, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStatisticsServiceStats.Value] = playerStats;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerStatistics,
        ServiceOperation.readSubset, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void ReadUserStatsForCategory(String category, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceCategory.Value] = category;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerStatistics,
        ServiceOperation.readForCategory, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Reset all of the statistics for this user back to their initial value.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - Reset
  ///
  /// </remarks>
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  ///
  /// </param>
  void ResetAllUserStats(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerStatistics, ServiceOperation.reset, null, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="dictData">
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void incrementUserStats(Map<String, dynamic> dictData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStatisticsServiceStats.Value] = dictData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerStatistics, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(sc);
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
    ServerCall sc = ServerCall(ServiceName.PlayerStatistics,
        ServiceOperation.processStatistics, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns JSON representing the next experience level for the user.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerStatistics
  /// Service Operation - ReadNextXpLevel
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
  void getNextExperienceLevel(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerStatistics,
        ServiceOperation.readNextXpLevel, null, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void incrementExperiencePoints(int xpValue, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStatisticsExperiencePoints.Value] = xpValue;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerStatistics, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void setExperiencePoints(int xpValue, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStatisticsExperiencePoints.Value] = xpValue;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerStatistics,
        ServiceOperation.setXpPoints, data, callback);
    _clientRef.sendRequest(sc);
  }
}
