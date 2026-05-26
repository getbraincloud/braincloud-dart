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
/// Service Name - Gamification
/// Service Operation - Read
///
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
/// Service Name - Gamification
/// Service Operation - ReadMilestones
///
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
/// Service Name - Gamification
/// Service Operation - ReadAchievements
///
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
/// Service Name - Gamification
/// Service Operation - ReadXpLevels
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
/// Service Name - Gamification
/// Service Operation - ReadAchievedAchievements
///
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
/// Service Name - Gamification
/// Service Operation - ReadCompleteMilestones
///
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
/// Service Name - Gamification
/// Service Operation - ReadInProgressMilestones
///
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
/// Service Name - Gamification
/// Service Operation - ReadMilestonesByCategory
///
/// @param category The milestone category
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
/// Service Name - Gamification
/// Service Operation - AwardAchievements
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
/// Service Name - Gamification
/// Service Operation - ReadQuests
///
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
/// Service Name - Gamification
/// Service Operation - ReadCompletedQuests
///
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
/// Service Name - Gamification
/// Service Operation - ReadInProgressQuests
///
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
/// Service Name - Gamification
/// Service Operation - ReadNotStartedQuests
///
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
/// Service Name - Gamification
/// Service Operation - ReadQuestsWithStatus
///
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
/// Service Name - Gamification
/// Service Operation - ReadQuestsWithBasicPercentage
///
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
/// Service Name - Gamification
/// Service Operation - ReadQuestsWithComplexPercentage
///
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
/// Service Name - Gamification
/// Service Operation - ReadQuestsByCategory
///
/// @param category The quest category
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
