import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  String achievementId1 = "testAchievements01";
  String achievementId2 = "testAchievements02";
  String milestoneCategory = "Experience";
  String questsCategory = "Experience";

  group("Test Gamification", () {
    test("awardAchievements()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .awardAchievements(achievements: [achievementId1, achievementId2]);

      expect(response.statusCode, 200);
    });

    test("readAchievedAchievements()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readAchievedAchievements(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readAchievements()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readAchievements(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readCompletedMilestones()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readCompletedMilestones(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readInProgressMilestones()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readInProgressMilestones(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readMilestonesByCategory()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readMilestonesByCategory(
              category: milestoneCategory, includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readCompletedQuests()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readCompletedQuests(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readNotStartedQuests()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readNotStartedQuests(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readInProgressQuests()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readInProgressQuests(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readQuests()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readQuests(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readQuestsByCategory()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readQuestsByCategory(
              category: questsCategory, includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readQuestsWithBasicPercentage()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readQuestsWithBasicPercentage(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readQuestsWithComplexPercentage()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readQuestsWithComplexPercentage(includeMetaData: true);
      expect(response.statusCode, 200);
    });

    test("readQuestsWithStatus()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readQuestsWithStatus(includeMetaData: true);
      expect(response.statusCode, 200);
    });

    test("readXPLevelsMetaData()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.gamificationService.readXpLevelsMetadata();

      expect(response.statusCode, 200);
    });

    test("readAllGamification()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readAllGamification(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    test("readMilestones()", () async {
      ServerResponse response = await bcTest.bcWrapper.gamificationService
          .readMilestones(includeMetaData: true);

      expect(response.statusCode, 200);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
