import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Social Leaderboard", () {
    var leaderboardName = "testLeaderboard";
    var groupLeaderboard = "groupLeaderboardConfig";

    test("getGlobalLeaderboardPage()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPage(
              leaderboardId: leaderboardName,
              sort: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageIfExistsTrue()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageIfExists(
              leaderboardId: leaderboardName,
              sort: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageIfExistsFalse()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageIfExists(
              leaderboardId: "nonExistentLeaderboard",
              sort: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardView()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardView(
              leaderboardId: leaderboardName,
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewIfExistsTrue()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewIfExists(
              leaderboardId: leaderboardName,
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewIfExistsFalse()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewIfExists(
              leaderboardId: "nonExistentLeaderboard",
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    var versionId = 0;

    test("getGlobalLeaderboardVersions()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardVersions(leaderboardId: leaderboardName);

      List versions = response.data?["versions"];
      if (versions.length > 0) {
        versionId = versions[0]["versionId"];
      }

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageByVersion()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageByVersion(
              leaderboardId: leaderboardName,
              sort: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageByVersionIfExistsTrue()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageByVersionIfExists(
              leaderboardId: leaderboardName,
              sort: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageByVersionIfExistsFalse()", retry: 2,
        () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageByVersionIfExists(
              leaderboardId: "nonExistentLeaderboard",
              sort: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10,
              versionId: versionId);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewByVersion()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewByVersion(
              leaderboardId: leaderboardName,
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewByVersionIfExistsTrue()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewByVersionIfExists(
              leaderboardId: leaderboardName,
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewByVersionIfExistsFalse()", retry: 2,
        () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewByVersionIfExists(
              leaderboardId: "nonExistentLeaderboard",
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardEntryCount()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardEntryCount(leaderboardId: leaderboardName);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicLeaderboard()", retry: 2, () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicLeaderboardUTC(
              leaderboardId: "testDynamicJs",
              score: 1000,
              jsonData: {"extra": 123},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationType: RotationType.DAILY,
              rotationResetUTC: tomorrow.millisecondsSinceEpoch,
              retainedCount: 3);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicLeaderboardUTC()", retry: 2, () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicLeaderboardUTC(
              leaderboardId: "testDynamicJs",
              score: 1000,
              jsonData: {"extra": 123},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationType: RotationType.DAILY,
              rotationResetUTC: tomorrow.millisecondsSinceEpoch,
              retainedCount: 3);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicLeaderboardUsingConfig", retry: 2, () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      var leaderboardId = "testDynamicJs";
      var score = 9999;
      var scoreData = {"nickname": "tarnished"};
      var configJson = {
        "leaderboardType": "HIGH_VALUE",
        "rotationType": "DAYS",
        "numDaysToRotate": 4,
        "resetAt": tomorrow.millisecondsSinceEpoch,
        "retainedCount": 2,
        "expireInMins": null
      };
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicLeaderboardUsingConfig(
              leaderboardId: leaderboardId,
              score: score,
              scoreData: scoreData,
              configJson: configJson);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicLeaderboardDays()", retry: 2, () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicLeaderboardDaysUTC(
              leaderboardId: "testDynamicJsDays",
              score: 1000,
              jsonData: {"extra": 123},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationResetUTC: tomorrow.millisecondsSinceEpoch,
              numDaysToRotate: 3,
              retainedCount: 3);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToLeaderboard()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToLeaderboard(
              leaderboardId: leaderboardName,
              score: 1000,
              jsonData: {"extra": 123});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboard()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboard(
              leaderboardId: leaderboardName, replaceName: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardIfExistsTrue()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardIfExists(
              leaderboardId: leaderboardName, replaceName: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardIfExistsFalse()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardIfExists(
              leaderboardId: "nonExistentLeaderboard", replaceName: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardByVersion()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardByVersion(
              leaderboardId: leaderboardName, replaceName: true, versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardByVersionIfExistsTrue()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardByVersionIfExists(
              leaderboardId: leaderboardName, replaceName: true, versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardByVersionIfExistsFalse()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardByVersionIfExists(
              leaderboardId: "nonExistentLeaderboard",
              replaceName: true,
              versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getMultiSocialLeaderboard()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getMultiSocialLeaderboard(
              leaderboardIds: [leaderboardName, "testDynamicJs"],
              leaderboardResultCount: 10,
              replaceName: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("listAllLeaderboards()", retry: 2, () async {
      ServerResponse response =
          await bcTest.bcWrapper.leaderboardService.listAllLeaderboards();
      expect(response.statusCode, StatusCodes.ok);
    });

    var groupId = "";

    test("createGroup()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: false,
          jsonData: {"test": "asdf"});

      groupId = response.data?["groupId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupSocialLeaderboard()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGroupSocialLeaderboard(
              leaderboardId: leaderboardName, groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupSocialLeaderboardByVersion()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGroupSocialLeaderboardByVersion(
              leaderboardId: leaderboardName, groupId: groupId, versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToGroupLeaderboard())", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToGroupLeaderboard(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              score: 0,
              jsonData: {"test": "asdf"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicGroupLeaderboardUtc())", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicGroupLeaderboardUTC(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              score: 0,
              jsonData: {"test": "asdf"},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationType: RotationType.WEEKLY,
              rotationResetUTC: 1570818219096,
              retainedCount: 2);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("removeGroupScore())", retry: 2, () async {
      ServerResponse response =
          await bcTest.bcWrapper.leaderboardService.removeGroupScore(
        leaderboardId: groupLeaderboard,
        groupId: groupId,
        versionId: -1,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupLeaderboardView())", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGroupLeaderboardView(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 5,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupLeaderboardViewByVersion())", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGroupLeaderboardViewByVersion(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              versionId: 1,
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 5,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicGroupLeaderboardDaysUTC()", retry: 2, () async {
      var today = DateTime.now();

      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicGroupLeaderboardDaysUTC(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              score: 0,
              jsonData: {"extra": 123},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationResetUTC: today.millisecondsSinceEpoch,
              retainedCount: 2,
              numDaysToRotate: 5);

      expect(response.statusCode, StatusCodes.ok,
          reason: response.error);
    });

    test("deleteGroup()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .deleteGroup(groupId: groupId, version: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboard()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboard(
              leaderboardId: leaderboardName,
              profileIds: [userA.profileId!, userB.profileId!]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardIfExistsTrue()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardIfExists(
              leaderboardId: leaderboardName,
              profileIds: [userA.profileId!, userB.profileId!]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardIfExistsFalse()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardIfExists(
              leaderboardId: "nonExistentLeaderboard",
              profileIds: [userA.profileId!, userB.profileId!]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardByVersion()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardByVersion(
              leaderboardId: leaderboardName,
              profileIds: [userA.profileId!, userB.profileId!],
              versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardByVersionIfExistsTrue()", retry: 2,
        () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardByVersionIfExists(
              leaderboardId: leaderboardName,
              profileIds: [userA.profileId!, userB.profileId!],
              versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardByVersionIfExistsFalse()", retry: 2,
        () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardByVersionIfExists(
              leaderboardId: "nonExistentLeaderboard",
              profileIds: [userA.profileId!, userB.profileId!],
              versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayerScore()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayerScore(leaderboardId: leaderboardName, versionId: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayerScores()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayerScores(
              leaderboardId: leaderboardName, versionId: -1, maxResults: 3);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayerScoresFromLeaderboards()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayerScoresFromLeaderboards(
        leaderboardIds: [leaderboardName],
      );
      expect(response.statusCode, StatusCodes.ok);
    });

    test("removePlayerScore()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .removePlayerScore(leaderboardId: leaderboardName, versionId: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
