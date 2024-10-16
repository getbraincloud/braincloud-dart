import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Player Statistics", () {
    test("getNextExperienceLevel()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStatisticsService
          .getNextExperienceLevel();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("incrementExperiencePoints()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStatisticsService
          .incrementExperiencePoints(xpValue: 100);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("incrementUserStats()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStatisticsService
          .incrementUserStats(stats: {"wins": 10, "losses": 4});
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readAllUserStats()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.playerStatisticsService.readAllUserStats();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readUserStatsSubset()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStatisticsService
          .readUserStatsSubset(playerStats: ["wins"]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readUserStatsForCategory()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStatisticsService
          .readUserStatsForCategory(category: "Test");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("resetAllUserStats()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.playerStatisticsService.resetAllUserStats();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("setExperiencePoints()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStatisticsService
          .setExperiencePoints(xpValue: 50);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("processStatistics()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStatisticsService
          .processStatistics(statisticsData: {
        "gamesPlayed": 1,
        "gamesWon": 1,
        "gamesLost": 2
      });

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
