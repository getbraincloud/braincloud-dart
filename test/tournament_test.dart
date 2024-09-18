import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Tournament", () {
    setUp(bcTest.auth);

    var _divSetId = "testDivSetId";
    var _tournamentCode = "testTournament";
    var _leaderboardId = "testTournamentLeaderboard";
    var _version = 0;

    test("joinTournament()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .joinTournament(
              leaderboardId: _leaderboardId,
              tournamentCode: _tournamentCode,
              initialScore: 0)
          .onError((error, stackTrace) => error as ServerResponse);

      if (response.reasonCode ==
          ReasonCodes.playerAlreadyTournamentForLeaderboard) {
        debugPrint("Already Joined Tournament");
      } else {
        expect(response.statusCode, StatusCodes.ok);
      }
    });

    test("getTournamentStatus()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .getTournamentStatus(leaderboardId: _leaderboardId, versionId: -1);

      _version = response.body?["data"]["versionId"];
      debugPrint("Verison: $_version");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getDivisionInfo()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .getDivisionInfo(divSetId: _divSetId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getMyDivisions()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.tournamentService.getMyDivisions();

      expect(response.statusCode, StatusCodes.ok);
    });

    test("joinDivision()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .joinDivision(
              divSetId: _divSetId,
              tournamentCode: _tournamentCode,
              initialScore: 0)
          .onError((error, stackTrace) => error as ServerResponse);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("leaveDivisionInstance()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .leaveDivisionInstance(leaderboardId: _divSetId)
          .onError((error, stackTrace) => error as ServerResponse);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("claimTournamentReward()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .claimTournamentReward(
            leaderboardId: _leaderboardId,
            versionId: _version,
          )
          .onError((error, stackTrace) => error as ServerResponse);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("postTournamentScore()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.tournamentService.postTournamentScore(
        leaderboardId: _leaderboardId,
        score: 200,
        jsonData: jsonEncode({"test": "test"}),
        roundStartTimeUTC: DateTime.now().millisecondsSinceEpoch,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postTournamentScoreWithresponses()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .postTournamentScoreWithResults(
              leaderboardId: _leaderboardId,
              score: 200,
              jsonData: jsonEncode({"test": "test"}),
              roundStartTimeUTC: DateTime.now().millisecondsSinceEpoch,
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 10,
              afterCount: 10,
              initialScore: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("viewCurrentReward()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .viewCurrentReward(leaderboardId: _leaderboardId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("viewReward()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .viewReward(leaderboardId: _leaderboardId, versionId: _version)
          .onError((error, stackTrace) => error as ServerResponse);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("leaveTournament()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .leaveTournament(leaderboardId: _leaderboardId);

      expect(response.statusCode, StatusCodes.ok);
    });
  });
}
