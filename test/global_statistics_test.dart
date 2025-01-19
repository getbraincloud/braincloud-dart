import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Global Statistics", () {
    test("incrementGlobalStats()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .incrementGlobalStats(
              statistics: 
                  {"gamesPlayed": 1, "gamesWon": 1, "gamesLost": 2});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readAllGlobalStats()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.globalStatisticsService.readAllGlobalStats();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGlobalStatsSubset()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .readGlobalStatsSubset(statistics: ["gamesPlayed"]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGlobalStatsForCategory()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .readGlobalStatsForCategory(category: "Test");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("processStatistics()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .processStatistics(statistics: {
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
