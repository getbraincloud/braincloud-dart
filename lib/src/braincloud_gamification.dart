// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudGamification {
  final BrainCloudClient _clientRef;

  BrainCloudGamification(this._clientRef);

  /// Method retrieves all gamification data for the player.
  /// Service Name - gamification
  /// Service Operation - READ
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readAllGamification({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.gamification, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves all milestones defined for the game.
  /// Service Name - gamification
  /// Service Operation - READ_MILESTONES
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readMilestones({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Read all of the achievements defined for the game.
  /// Service Name - gamification
  /// Service Operation - READ_ACHIEVEMENTS
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readAchievements({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readAchievements, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns all defined xp levels and any rewards associated
  /// with those xp levels.
  /// Service Name - gamification
  /// Service Operation - READ_XP_LEVELS
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readXpLevelsMetadata() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readXpLevels, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrives the list of achieved achievements.
  /// Service Name - gamification
  /// Service Operation - READ_ACHIEVED_ACHIEVEMENTS
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readAchievedAchievements(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readAchievedAchievements, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves the list of completed milestones.
  /// Service Name - gamification
  /// Service Operation - READ_COMPLETED_MILESTONES
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readCompletedMilestones(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readCompletedMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves the list of in progress milestones
  /// Service Name - gamification
  /// Service Operation - READ_IN_PROGRESS_MILESTONES
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readInProgressMilestones(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readInProgressMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves milestones of the given category.
  /// Service Name - gamification
  /// Service Operation - READ_MILESTONES_BY_CATEGORY
  ///
  /// @param category The milestone category
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readMilestonesByCategory(
      {required String category, required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceCategory.value] = category;
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readMilestonesByCategory, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method will award the achievements specified.
  /// Service Name - gamification
  /// Service Operation - AWARD_ACHIEVEMENTS
  ///
  /// @param achievementIds Collection of achievement ids to award
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> awardAchievements(
      {required List<String> achievements}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceAchievementsName.value] =
        achievements;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.awardAchievements, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves all of the quests defined for the game.
  /// Service Name - gamification
  /// Service Operation - READ_QUESTS
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readQuests({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.gamification, ServiceOperation.readQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns all completed quests.
  /// Service Name - gamification
  /// Service Operation - READ_COMPLETED_QUESTS
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readCompletedQuests({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readCompletedQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns quests that are in progress.
  /// Service Name - gamification
  /// Service Operation - READ_IN_PROGRESS_QUESTS
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readInProgressQuests({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readInProgressQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns quests that have not been started.
  /// Service Name - gamification
  /// Service Operation - READ_NOT_STARTED_QUESTS
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readNotStartedQuests({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readNotStartedQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns quests with a status.
  /// Service Name - gamification
  /// Service Operation - READ_QUESTS_WITH_STATUS
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readQuestsWithStatus({required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithStatus, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns quests with a basic percentage.
  /// Service Name - gamification
  /// Service Operation - READ_QUESTS_WITH_BASIC_PERCENTAGE
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readQuestsWithBasicPercentage(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithBasicPercentage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns quests with a complex percentage.
  /// Service Name - gamification
  /// Service Operation - READ_QUESTS_WITH_COMPLEX_PERCENTAGE
  ///
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readQuestsWithComplexPercentage(
      {required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithComplexPercentage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns quests for the given category.
  /// Service Name - gamification
  /// Service Operation - READ_QUESTS_BY_CATEGORY
  ///
  /// @param category The quest category
  /// @param includeMetaData Whether to return meta data as well
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> readQuestsByCategory(
      {required String category, required bool includeMetaData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceCategory.value] = category;
    data[OperationParam.gamificationServiceIncludeMetaData.value] =
        includeMetaData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsByCategory, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
