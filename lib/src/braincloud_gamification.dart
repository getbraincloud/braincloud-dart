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

  /// Method retrieves all gamification data for the player.
  ///
  /// Service Name - Gamification
  /// Service Operation - Read
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.gamification, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves all milestones defined for the game.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadMilestones
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Read all of the achievements defined for the game.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadAchievements
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readAchievements, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns all defined xp levels and any rewards associated
  /// with those xp levels.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadXpLevels
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> readXPLevelsMetaData() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
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

  /// Method retrives the list of achieved achievements.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadAchievedAchievements
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readAchievedAchievements, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves the list of completed milestones.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadCompleteMilestones
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readCompletedMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves the list of in progress milestones
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadInProgressMilestones
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readInProgressMilestones, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves milestones of the given category.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadMilestonesByCategory
  ///
  /// @param category
  /// The milestone category
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readMilestonesByCategory, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method will award the achievements specified. On success, this will
  /// call AwardThirdPartyAchievement to hook into the client-side Achievement
  /// service (ie GameCentre, Facebook etc).
  ///
  /// Service Name - Gamification
  /// Service Operation - AwardAchievements
  ///
  /// @param achievementIds
  /// A collection of achievement ids to award
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> awardAchievements(
      {required List<String> achievementIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.gamificationServiceAchievementsName.value] =
        achievementIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
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

  /// Method retrieves all of the quests defined for the game.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadQuests
  ///  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.gamification, ServiceOperation.readQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  ///  Method returns all completed quests.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadCompletedQuests
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readCompletedQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns all in progress quests.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadInProgressQuests
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readInProgressQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns all quests that haven't been started.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadNotStartedQuests
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readNotStartedQuests, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  ///  Method returns all quests with status.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithStatus
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithStatus, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns all quests with a basic percentage.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithBasicPercentage
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithBasicPercentage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  ///  Method returns all quests with a complex percentage.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsWithComplexPercentage
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsWithComplexPercentage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method returns all quests for the given category.
  ///
  /// Service Name - Gamification
  /// Service Operation - ReadQuestsByCategory
  ///
  /// @param category
  /// The quest category
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.gamification,
        ServiceOperation.readQuestsByCategory, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
