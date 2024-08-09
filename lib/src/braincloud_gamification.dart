import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudGamification {
  final BrainCloudClient _clientRef;

  BrainCloudGamification(this._clientRef);

  /// <summary>
  /// Method retrieves all gamification data for the player.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - Read
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readAllGamification(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.gamification, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method retrieves all milestones defined for the game.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadMilestones
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readMilestones(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readMilestones, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Read all of the achievements defined for the game.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadAchievements
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readAchievements(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readAchievements, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method returns all defined xp levels and any rewards associated
  /// with those xp levels.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadXpLevels
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readXpLevelsMetaData(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readXpLevels, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method retrives the list of achieved achievements.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadAchievedAchievements
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readAchievedAchievements(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readAchievedAchievements, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method retrieves the list of completed milestones.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadCompleteMilestones
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readCompletedMilestones(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readCompletedMilestones, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method retrieves the list of in progress milestones
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadInProgressMilestones
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readInProgressMilestones(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readInProgressMilestones, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method retrieves milestones of the given category.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadMilestonesByCategory
  /// </remarks>
  /// <param name="category">
  /// The milestone category
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
  void readMilestonesByCategory(String category, bool includeMetaData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceCategory.Value] = category;
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readMilestonesByCategory, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method will award the achievements specified. On success, this will
  /// call AwardThirdPartyAchievement to hook into the client-side Achievement
  /// service (ie GameCentre, Facebook etc).
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - AwardAchievements
  /// </remarks>
  /// <param name="achievementIds">
  /// A collection of achievement ids to award
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
  void awardAchievements(List<String> achievementIds, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceAchievementsName.Value] =
        achievementIds;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.awardAchievements, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method retrieves all of the quests defined for the game.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuests
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readQuests(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.gamification, ServiceOperation.readQuests, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///  Method returns all completed quests.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadCompletedQuests
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readCompletedQuests(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readCompletedQuests, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method returns all in progress quests.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadInProgressQuests
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readInProgressQuests(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readInProgressQuests, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method returns all quests that haven't been started.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadNotStartedQuests
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readNotStartedQuests(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readNotStartedQuests, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///  Method returns all quests with status.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithStatus
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readQuestsWithStatus(bool includeMetaData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithStatus, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method returns all quests with a basic percentage.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithBasicPercentage
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readQuestsWithBasicPercentage(bool includeMetaData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithBasicPercentage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///  Method returns all quests with a complex percentage.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithComplexPercentage
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readQuestsWithComplexPercentage(bool includeMetaData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithComplexPercentage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method returns all quests for the given category.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsByCategory
  /// </remarks>
  /// <param name="category">
  /// The quest category
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
  void readQuestsByCategory(String category, bool includeMetaData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GamificationServiceCategory.Value] = category;
    data[OperationParam.GamificationServiceIncludeMetaData.Value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsByCategory, data, callback);
    _clientRef.sendRequest(sc);
  }
}
