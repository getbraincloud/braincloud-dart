import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Async Match", () {
    var platform = "BC";

    var matchId;

    test("createMatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .createMatch(jsonOpponentIds: [
        {"platform": platform, "id": userB.profileId}
      ]);

      matchId = response.data?["matchId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateMatchSummaryData()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .updateMatchSummaryData(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 0,
              jsonSummary: {"summary": "sum"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateMatchStateCurrentTurn", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .updateMatchStateCurrentTurn(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 1,
              matchState: {"map": "level1"},
              statistics: {"summary": "sum"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("submitTurn()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .submitTurn(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 2,
              jsonSummary: {"summary": "sum"},
              nextPlayer: userB.profileId,
              jsonMatchState: {"summary": "sum"},
              jsonStatistics: {"summary": "sum"},
              pushNotificationMessage: "Sample Push Message");

      matchId = response.data?["matchId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("abandonMatch()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.asyncMatchService.abandonMatch(
        ownerId: userA.profileId!,
        matchId: matchId,
      );
      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteMatch()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.asyncMatchService.deleteMatch(
        ownerId: userA.profileId!,
        matchId: matchId,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("createMatchWithInitialTurn()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .createMatchWithInitialTurn(jsonOpponentIds: [
        {"platform": platform, "id": userB.profileId}
      ], jsonMatchState: {
        "matchStateData": "test"
      }, jsonSummary: {
        "summary": "sum"
      });

      matchId = response.data?["matchId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readMatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .readMatch(ownerId: userA.profileId!, matchId: matchId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readMatchHistory()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .readMatchHistory(ownerId: userA.profileId!, matchId: matchId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("completeMatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .completeMatch(ownerId: userA.profileId!, matchId: matchId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("findMatches()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.asyncMatchService.findMatches();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("findCompleteMatches()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.asyncMatchService.findCompleteMatches();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("CompleteMatchWithSummaryData()", retry: 3, () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .createMatch(jsonOpponentIds: [
        {"platform": platform, "id": userA.profileId},
        {"platform": platform, "id": userB.profileId}
      ]);

      matchId = response.data?["matchId"];
      expect(response.statusCode, StatusCodes.ok);

      ServerResponse response2 = await bcTest.bcWrapper.asyncMatchService
          .submitTurn(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 0,
              jsonMatchState: {"summary": "sum"},
              nextPlayer: userB.profileId,
              jsonSummary: {"summary": "sum"},
              jsonStatistics: {"summary": "sum"});

      expect(response2.statusCode, StatusCodes.ok);

      ServerResponse response3 = await bcTest.bcWrapper.asyncMatchService
          .completeMatchWithSummaryData(
              ownerId: userA.profileId!,
              matchId: matchId,
              pushContent: "EHHH",
              summary: {"summary": "sum"});

      expect(response3.statusCode, StatusCodes.ok);
    });

    test("AbandonMatchWithSummaryData()", retry: 3, () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .createMatch(jsonOpponentIds: [
        {"platform": platform, "id": userA.profileId},
        {"platform": platform, "id": userB.profileId}
      ]);

      matchId = response.data?["matchId"];
      expect(response.statusCode, StatusCodes.ok);

      ServerResponse response2 = await bcTest.bcWrapper.asyncMatchService
          .submitTurn(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 0,
              jsonMatchState: {"summary": "sum"},
              nextPlayer: userB.profileId,
              jsonSummary: {"summary": "sum"},
              jsonStatistics: {"summary": "sum"});

      expect(response2.statusCode, StatusCodes.ok);

      ServerResponse response3 =
          await bcTest.bcWrapper.asyncMatchService.abandonMatchWithSummaryData(
        ownerId: userA.profileId!,
        matchId: matchId,
        pushContent: "EHHH",
        summary: {"summary": "sum"},
      );

      expect(response3.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
