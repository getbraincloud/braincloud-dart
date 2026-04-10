// Runs first (alphabetically before all other *_test.dart files) to verify that
// all required portal configurations exist. A failure here means the environment
// is missing portal setup — fix those before investigating other test failures.

import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Portal Preflight Check", () {
    test("all required portal items exist", () async {
      final List<String> missing = [];

      // -----------------------------------------------------------------------
      // Leaderboards
      // -----------------------------------------------------------------------
      for (final lbId in ["testLeaderboard", "testSocialLeaderboard", "testTournamentLeaderboard", "groupLeaderboardConfig"]) {
        final r = await bcTest.bcWrapper.leaderboardService
            .getGlobalLeaderboardEntryCount(leaderboardId: lbId);
        if (r.statusCode != StatusCodes.ok) missing.add("leaderboard: $lbId");
      }

      // -----------------------------------------------------------------------
      // Item catalog
      // -----------------------------------------------------------------------
      for (final itemId in ["sword001", "equipmentBundle"]) {
        final r = await bcTest.bcWrapper.itemCatalogService
            .getCatalogItemDefinition(defId: itemId);
        if (r.statusCode != StatusCodes.ok) missing.add("catalog item: $itemId");
      }

      // -----------------------------------------------------------------------
      // Global properties
      // -----------------------------------------------------------------------
      {
        final r = await bcTest.bcWrapper.globalAppService
            .readSelectedProperties(propertyNames: ["prop1", "prop2", "prop3"]);
        if (r.statusCode == StatusCodes.ok) {
          final props = (r.data as Map?) ?? {};
          for (final name in ["prop1", "prop2", "prop3"]) {
            if (!props.containsKey(name)) missing.add("global property: $name");
          }
        } else {
          missing.add("global properties: prop1, prop2, prop3");
        }
      }

      // -----------------------------------------------------------------------
      // Achievements
      // -----------------------------------------------------------------------
      {
        final r = await bcTest.bcWrapper.gamificationService
            .readAchievements(includeMetaData: false);
        if (r.statusCode == StatusCodes.ok) {
          final achs = (r.data?["achievements"] as List?) ?? [];
          final ids = achs.map((a) => (a as Map)["id"] as String? ?? "").toSet();
          for (final id in ["testAchievements01", "testAchievements02"]) {
            if (!ids.contains(id)) missing.add("achievement: $id");
          }
        } else {
          missing.add("achievement: testAchievements01");
          missing.add("achievement: testAchievements02");
        }
      }

      // -----------------------------------------------------------------------
      // Milestone and quest category: Experience
      // -----------------------------------------------------------------------
      {
        final r = await bcTest.bcWrapper.gamificationService
            .readMilestonesByCategory(category: "Experience", includeMetaData: false);
        if (r.statusCode == StatusCodes.ok) {
          final milestones = (r.data?["milestones"] as List?) ?? [];
          if (milestones.isEmpty) missing.add("milestone category: Experience (no milestones defined)");
        } else {
          missing.add("milestone category: Experience");
        }
      }
      {
        final r = await bcTest.bcWrapper.gamificationService
            .readQuestsByCategory(category: "Experience", includeMetaData: false);
        if (r.statusCode == StatusCodes.ok) {
          final quests = (r.data?["quests"] as List?) ?? [];
          if (quests.isEmpty) missing.add("quest category: Experience (no quests defined)");
        } else {
          missing.add("quest category: Experience");
        }
      }

      // -----------------------------------------------------------------------
      // Virtual currency type: test (dart uses "test" currency)
      // -----------------------------------------------------------------------
      {
        final r = await bcTest.bcWrapper.virtualCurrencyService.getCurrency();
        if (r.statusCode == StatusCodes.ok) {
          final currency = (r.data?["currencyMap"] as Map?) ?? {};
          if (!currency.containsKey("test")) missing.add("virtual currency type: test");
        } else {
          missing.add("virtual currency type: test");
        }
      }

      // -----------------------------------------------------------------------
      // Custom entity type: athletes
      // -----------------------------------------------------------------------
      {
        final r = await bcTest.bcWrapper.customEntityService.getEntityPage(
            entityType: "athletes",
            jsonContext: "{\"pagination\":{\"rowsPerPage\":1,\"pageNumber\":1},\"searchCriteria\":{}}");
        if (r.statusCode != StatusCodes.ok) missing.add("custom entity type: athletes");
      }

      // -----------------------------------------------------------------------
      // Tournament division set: testDivSet
      // -----------------------------------------------------------------------
      {
        final r = await bcTest.bcWrapper.tournamentService
            .getDivisionInfo(divSetId: "testDivSet");
        if (r.statusCode != StatusCodes.ok) missing.add("tournament division set: testDivSet");
      }

      // -----------------------------------------------------------------------
      // Lobby type: MATCH_UNRANKED
      // -----------------------------------------------------------------------
      {
        final r = await bcTest.bcWrapper.lobbyService
            .getRegionsForLobbies(lobbyTypes: ["MATCH_UNRANKED"]);
        if (r.statusCode != StatusCodes.ok) missing.add("lobby type: MATCH_UNRANKED");
      }

      // -----------------------------------------------------------------------
      // Report
      // -----------------------------------------------------------------------
      if (missing.isNotEmpty) {
        final message = "\nPORTAL PREFLIGHT CHECK FAILED - the following items are not configured on the portal:\n"
            "${missing.map((item) => '  - $item').join('\n')}\n\n"
            "Set these up in the portal before running the full test suite.";
        fail(message);
      }
    });

    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
