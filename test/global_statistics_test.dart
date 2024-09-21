import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Global Statistics", () {
    setUp(bcTest.auth);

    test("incrementGlobalStats()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .incrementGlobalStats(
              jsonData: jsonEncode(
                  {"gamesPlayed": 1, "gamesWon": 1, "gamesLost": 2}));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readAllGlobalStats()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.globalStatisticsService.readAllGlobalStats();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGlobalStatsSubset()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .readGlobalStatsSubset(globalStats: ["gamesPlayed"]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGlobalStatsForCategory()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .readGlobalStatsForCategory(category: "Test");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("processStatistics()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .processStatistics(statisticsData: {
        "gamesPlayed": 1,
        "gamesWon": 1,
        "gamesLost": 2
      });

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    test("Dispose", () {
      bcTest.dispose();
    });
  });
}
