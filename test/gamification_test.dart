import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';

import 'stored_ids.dart';

main() {
  SharedPreferences.setMockInitialValues({});
  debugPrint('Braindcloud Dart Client unit tests');
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  String email = "";
  String password = "";

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    email = ids.email.isEmpty
        ? "${const UuidV4().generate()}@DartUnitTester"
        : ids.email;
    password = ids.password.isEmpty ? const UuidV4().generate() : ids.password;

    debugPrint('email: ${ids.email} in appId: ${ids.appId} at ${ids.url}');
    //start test

    bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .then((_) {
      bool hadSession = bcWrapper.getStoredSessionId().isNotEmpty;

      if (hadSession) {
        bcWrapper.restoreSession();
      }

      int packetId = bcWrapper.getStoredPacketId();
      if (packetId > BrainCloudComms.noPacketExpected) {
        bcWrapper.restorePacketId();
      }

      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        bcWrapper.update();
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  });

  String achievementId1 = "testAchievements01";
  String achievementId2 = "testAchievements02";
  String milestoneCategory = "Experience";
  String questsCategory = "Experience";

  group("Test Gamification", () {
    setUp(() async {
      bcWrapper.brainCloudClient.enableLogging(false);
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateUniversal(
            username: email, password: password, forceCreate: true);
      }
    });

    test("awardAchievements()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .awardAchievements(achievementIds: [achievementId1, achievementId2]);

      expect(response.statusCode, 200);
    });

    test("readAchievedAchievements()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readAchievedAchievements(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readAchievements()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readAchievements(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readCompletedMilestones()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readCompletedMilestones(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readInProgressMilestones()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readInProgressMilestones(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readMilestonesByCategory()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readMilestonesByCategory(
              category: milestoneCategory, includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readCompletedQuests()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readCompletedQuests(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readNotStartedQuests()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readNotStartedQuests(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readInProgressQuests()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readInProgressQuests(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readQuests()", () async {
      ServerResponse response =
          await bcWrapper.gamificationService.readQuests(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readQuestsByCategory()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readQuestsByCategory(
              category: questsCategory, includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readQuestsWithBasicPercentage()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readQuestsWithBasicPercentage(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readQuestsWithComplexPercentage()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readQuestsWithComplexPercentage(includeMetaData: true);
      expect(response.statusCode, 200);
    });

    test("readQuestsWithStatus()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readQuestsWithStatus(includeMetaData: true);
      expect(response.statusCode, 200);
    });

    test("readXPLevelsMetaData()", () async {
      ServerResponse response =
          await bcWrapper.gamificationService.readXPLevelsMetaData();

      expect(response.statusCode, 200);
    });

    test("readAllGamification()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readAllGamification(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readMilestones()", () async {
      ServerResponse response = await bcWrapper.gamificationService
          .readMilestones(includeMetaData: true);

      expect(response.statusCode, 200);
    });
  });
}
