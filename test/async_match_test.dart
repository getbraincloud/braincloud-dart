import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';
import 'utils/test_users.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Async Match", () {
    TestUser userA = TestUser("UserA", generateRandomString(8));
    TestUser userB = TestUser("UserB", generateRandomString(8));

    setUp(() async {
      if (bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.logout();
      }

      ServerResponse userB_response = await bcTest.bcWrapper
          .authenticateUniversal(
              username: userB.name,
              password: userB.password,
              forceCreate: true);

      userB.profileId = userB_response.body?["profileId"];

      ServerResponse userA_response = await bcTest.bcWrapper
          .authenticateUniversal(
              username: userA.name,
              password: userA.password,
              forceCreate: true);

      userA.profileId = userA_response.body?["profileId"];
    });

    var platform = "BC";

    var matchId;

    test("createMatch()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.asyncMatchService.createMatch(
              jsonOpponentIds: jsonEncode([
        {"platform": platform, "id": userB.profileId}
      ]));

      matchId = response.body?["data"]["matchId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateMatchSummaryData()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .updateMatchSummaryData(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 0,
              jsonSummary: jsonEncode({"summary": "sum"}));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateMatchStateCurrentTurn", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .updateMatchStateCurrentTurn(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 1,
              jsonMatchState: {"map": "level1"},
              jsonStatistics: {"summary": "sum"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("submitTurn()", () async {
      ServerResponse response = await bcTest.bcWrapper.asyncMatchService
          .submitTurn(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 2,
              jsonSummary: jsonEncode({"summary": "sum"}),
              nextPlayer: userB.profileId,
              jsonMatchState: jsonEncode({"summary": "sum"}),
              pushNotificationMessage: jsonEncode({"summary": "sum"}));

      matchId = response.body?["data"]["matchId"];
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
      ServerResponse response =
          await bcTest.bcWrapper.asyncMatchService.createMatchWithInitialTurn(
              jsonOpponentIds: jsonEncode([
                {"platform": platform, "id": userB.profileId}
              ]),
              jsonMatchState: jsonEncode({"matchStateData": "test"}),
              jsonSummary: jsonEncode({"summary": "sum"}));

      matchId = response.body?["data"]["matchId"];
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
      ServerResponse response =
          await bcTest.bcWrapper.asyncMatchService.createMatch(
              jsonOpponentIds: jsonEncode(([
        {"platform": platform, "id": userA.profileId},
        {"platform": platform, "id": userB.profileId}
      ])));

      matchId = response.body?["data"]["matchId"];
      expect(response.statusCode, StatusCodes.ok);

      ServerResponse response2 = await bcTest.bcWrapper.asyncMatchService
          .submitTurn(
              ownerId: userA.profileId!,
              matchId: matchId,
              version: 0,
              jsonMatchState: jsonEncode({"summary": "sum"}),
              nextPlayer: userB.profileId,
              jsonSummary: jsonEncode({"summary": "sum"}),
              jsonStatistics: jsonEncode({"summary": "sum"}));

      expect(response2.statusCode, StatusCodes.ok);

      ServerResponse response3 = await bcTest.bcWrapper.asyncMatchService
          .completeMatchWithSummaryData(
              ownerId: userA.profileId!,
              matchId: matchId,
              pushContent: "EHHH",
              summary: jsonEncode({"summary": "sum"}));

      expect(response3.statusCode, StatusCodes.ok);
    });

    test("AbandonMatchWithSummaryData()", retry: 3, () async {
      ServerResponse response =
          await bcTest.bcWrapper.asyncMatchService.createMatch(
              jsonOpponentIds: jsonEncode([
        {"platform": platform, "id": userA.profileId},
        {"platform": platform, "id": userB.profileId}
      ]));

      matchId = response.body?["data"]["matchId"];
      expect(response.statusCode, StatusCodes.ok);

      ServerResponse response2 =
          await bcTest.bcWrapper.asyncMatchService.submitTurn(
        ownerId: userA.profileId!,
        matchId: matchId,
        version: 0,
        jsonMatchState: jsonEncode({"summary": "sum"}),
        nextPlayer: userB.profileId,
        jsonSummary: jsonEncode({"summary": "sum"}),
        jsonStatistics: jsonEncode({"summary": "sum"}),
      );

      expect(response2.statusCode, StatusCodes.ok);

      ServerResponse response3 =
          await bcTest.bcWrapper.asyncMatchService.abandonMatchWithSummaryData(
        ownerId: userA.profileId!,
        matchId: matchId,
        pushContent: "EHHH",
        summary: jsonEncode({"summary": "sum"}),
      );

      expect(response3.statusCode, StatusCodes.ok);
    });
  });
}
