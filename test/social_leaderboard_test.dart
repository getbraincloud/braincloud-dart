import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Social Leaderboard", () {
    var leaderboardName = "testLeaderboard";
    var groupLeaderboard = "groupLeaderboardConfig";

    test("getGlobalLeaderboardPage()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPage(
              leaderboardId: leaderboardName,
              sortOrder: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageIfExists(
              leaderboardId: leaderboardName,
              sortOrder: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageIfExistsFalse()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageIfExists(
              leaderboardId: "nonExistentLeaderboard",
              sortOrder: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardView()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardView(
              leaderboardId: leaderboardName,
              sortOrder: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewIfExists(
              leaderboardId: leaderboardName,
              sortOrder: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewIfExistsFalse()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewIfExists(
              leaderboardId: "nonExistentLeaderboard",
              sortOrder: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    var versionId = 0;

    test("getGlobalLeaderboardVersions()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardVersions(leaderboardId: leaderboardName);

      List versions = response.data?["versions"];
      if (versions.length > 0) {
        versionId = versions[0]["versionId"];
      }

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageByVersion()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageByVersion(
              leaderboardId: leaderboardName,
              sortOrder: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageByVersionIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageByVersionIfExists(
              leaderboardId: leaderboardName,
              sortOrder: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardPageByVersionIfExistsFalse()",
        () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardPageByVersionIfExists(
              leaderboardId: "nonExistentLeaderboard",
              sortOrder: SortOrder.HIGH_TO_LOW,
              startIndex: 0,
              endIndex: 10,
              versionId: versionId);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewByVersion()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewByVersion(
              leaderboardId: leaderboardName,
              sortOrder: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewByVersionIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewByVersionIfExists(
              leaderboardId: leaderboardName,
              sortOrder: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardViewByVersionIfExistsFalse()",
        () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardViewByVersionIfExists(
              leaderboardId: "nonExistentLeaderboard",
              sortOrder: SortOrder.HIGH_TO_LOW,
              beforeCount: 4,
              afterCount: 5,
              versionId: versionId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGlobalLeaderboardEntryCount()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGlobalLeaderboardEntryCount(leaderboardId: leaderboardName);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicLeaderboard()", () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicLeaderboardUTC(
              leaderboardId: "testDynamicJs",
              score: 1000,
              data: {"extra": 123},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationType: RotationType.DAILY,
              rotationResetUTC: tomorrow.millisecondsSinceEpoch,
              retainedCount: 3);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicLeaderboardUTC()", () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicLeaderboardUTC(
              leaderboardId: "testDynamicJs",
              score: 1000,
              data: {"extra": 123},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationType: RotationType.DAILY,
              rotationResetUTC: tomorrow.millisecondsSinceEpoch,
              retainedCount: 3);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicLeaderboardUsingConfig", () async {
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

    test("postScoreToDynamicLeaderboardDays()", () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicLeaderboardDaysUTC(
              leaderboardId: "testDynamicJsDays",
              score: 1000,
              data: {"extra": 123},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationReset: tomorrow.millisecondsSinceEpoch,
              numDaysToRotate: 3,
              retainedCount: 3);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToLeaderboard()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToLeaderboard(
              leaderboardId: leaderboardName,
              score: 1000,
              data: {"extra": 123});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboard()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboard(
              leaderboardId: leaderboardName, replaceName: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardIfExists(
              leaderboardId: leaderboardName, replaceName: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardIfExistsFalse()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardIfExists(
              leaderboardId: "nonExistentLeaderboard", replaceName: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardByVersion()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardByVersion(
              leaderboardId: leaderboardName, replaceName: true, versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardByVersionIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardByVersionIfExists(
              leaderboardId: leaderboardName, replaceName: true, versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSocialLeaderboardByVersionIfExistsFalse()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getSocialLeaderboardByVersionIfExists(
              leaderboardId: "nonExistentLeaderboard",
              replaceName: true,
              versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getMultiSocialLeaderboard()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getMultiSocialLeaderboard(
              leaderboardIds: [leaderboardName, "testDynamicJs"],
              leaderboardResultCount: 10,
              replaceName: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("listAllLeaderboards()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.leaderboardService.listAllLeaderboards();
      expect(response.statusCode, StatusCodes.ok);
    });

    var groupId = "";

    test("createGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: false,
          data: {"test": "asdf"});

      groupId = response.data?["groupId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupSocialLeaderboard()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGroupSocialLeaderboard(
              leaderboardId: leaderboardName, groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupSocialLeaderboardByVersion()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGroupSocialLeaderboardByVersion(
              leaderboardId: leaderboardName, groupId: groupId, versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToGroupLeaderboard())", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToGroupLeaderboard(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              score: 0,
              data: {"test": "asdf"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicGroupLeaderboardUtc())", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicGroupLeaderboardUTC(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              score: 0,
              data: {"test": "asdf"},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationType: RotationType.WEEKLY,
              rotationResetUTC: 1570818219096,
              retainedCount: 2);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicGroupLeaderboardUsingConfig", () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      var leaderboardId = groupLeaderboard;
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
          .postScoreToDynamicGroupLeaderboardUsingConfig(
              leaderboardId: leaderboardId,
              groupId: groupId,
              score: score,
              scoreData: scoreData,
              configJson: configJson);

      print("postScoreToDynamicGroupLeaderboardUsingConfig: $response,   ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("removeGroupScore())", () async {
      ServerResponse response =
          await bcTest.bcWrapper.leaderboardService.removeGroupScore(
        leaderboardId: groupLeaderboard,
        groupId: groupId,
        versionId: -1,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupLeaderboardView())", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGroupLeaderboardView(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              sortOrder: SortOrder.HIGH_TO_LOW,
              beforeCount: 5,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupLeaderboardViewByVersion())", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getGroupLeaderboardViewByVersion(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              versionId: 1,
              sortOrder: SortOrder.HIGH_TO_LOW,
              beforeCount: 5,
              afterCount: 5);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postScoreToDynamicGroupLeaderboardDaysUTC()", () async {
      var today = DateTime.now();

      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .postScoreToDynamicGroupLeaderboardDaysUTC(
              leaderboardId: groupLeaderboard,
              groupId: groupId,
              score: 0,
              data: {"extra": 123},
              leaderboardType: SocialLeaderboardType.HIGH_VALUE,
              rotationResetTime: today.millisecondsSinceEpoch,
              retainedCount: 2,
              numDaysToRotate: 5);

      expect(response.statusCode, StatusCodes.ok,
          reason: response.error);
    });

    test("deleteGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .deleteGroup(groupId: groupId, version: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboard()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboard(
              leaderboardId: leaderboardName,
              profileIds: [userA.profileId!, userB.profileId!]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardIfExists(
              leaderboardId: leaderboardName,
              profileIds: [userA.profileId!, userB.profileId!]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardIfExistsFalse()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardIfExists(
              leaderboardId: "nonExistentLeaderboard",
              profileIds: [userA.profileId!, userB.profileId!]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardByVersion()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardByVersion(
              leaderboardId: leaderboardName,
              profileIds: [userA.profileId!, userB.profileId!],
              versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardByVersionIfExistsTrue()",
        () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardByVersionIfExists(
              leaderboardId: leaderboardName,
              profileIds: [userA.profileId!, userB.profileId!],
              versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayersSocialLeaderboardByVersionIfExistsFalse()",
        () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayersSocialLeaderboardByVersionIfExists(
              leaderboardId: "nonExistentLeaderboard",
              profileIds: [userA.profileId!, userB.profileId!],
              versionId: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayerScore()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayerScore(leaderboardId: leaderboardName, versionId: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayerScores()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayerScores(
              leaderboardId: leaderboardName, versionId: -1, maxResults: 3);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPlayerScoresFromLeaderboards()", () async {
      ServerResponse response = await bcTest.bcWrapper.leaderboardService
          .getPlayerScoresFromLeaderboards(
        leaderboardIds: [leaderboardName],
      );
      expect(response.statusCode, StatusCodes.ok);
    });

    test("removePlayerScore()", () async {
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
