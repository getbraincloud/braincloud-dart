import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

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
  Future<ServerResponse> readAllGamification({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.gamification, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method retrieves all milestones defined for the game.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadMilestones
  /// </remarks>
  Future<ServerResponse> readMilestones({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Read all of the achievements defined for the game.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadAchievements
  /// </remarks>
  Future<ServerResponse> readAchievements({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readAchievements, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Method returns all defined xp levels and any rewards associated
  /// with those xp levels.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadXpLevels
  /// </remarks>
  Future<ServerResponse> readXpLevelsMetaData() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readXpLevels, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method retrives the list of achieved achievements.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadAchievedAchievements
  /// </remarks>
  Future<ServerResponse> readAchievedAchievements(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readAchievedAchievements, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method retrieves the list of completed milestones.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadCompleteMilestones
  /// </remarks>
  Future<ServerResponse> readCompletedMilestones(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readCompletedMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method retrieves the list of in progress milestones
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadInProgressMilestones
  /// </remarks>
  Future<ServerResponse> readInProgressMilestones(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readInProgressMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> readMilestonesByCategory(
      {required String category, required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceCategory.value] = category;
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readMilestonesByCategory, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> awardAchievements(
      {required List<String> achievementIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceAchievementsName.value] =
        achievementIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.awardAchievements, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method retrieves all of the quests defined for the game.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuests
  /// </remarks>
  Future<ServerResponse> readQuests({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.gamification, ServiceOperation.readQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  ///  Method returns all completed quests.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadCompletedQuests
  /// </remarks>
  Future<ServerResponse> readCompletedQuests({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readCompletedQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Method returns all in progress quests.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadInProgressQuests
  /// </remarks>
  Future<ServerResponse> readInProgressQuests({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readInProgressQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Method returns all quests that haven't been started.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadNotStartedQuests
  /// </remarks>
  Future<ServerResponse> readNotStartedQuests({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readNotStartedQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  ///  Method returns all quests with status.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithStatus
  /// </remarks>
  Future<ServerResponse> readQuestsWithStatus({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithStatus, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Method returns all quests with a basic percentage.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithBasicPercentage
  /// </remarks>
  Future<ServerResponse> readQuestsWithBasicPercentage(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithBasicPercentage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  ///  Method returns all quests with a complex percentage.
  /// </summary>
  /// <remarks>
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithComplexPercentage
  /// </remarks>
  Future<ServerResponse> readQuestsWithComplexPercentage(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithComplexPercentage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
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
  Future<ServerResponse> readQuestsByCategory(
      {required String category, required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceCategory.value] = category;
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsByCategory, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
