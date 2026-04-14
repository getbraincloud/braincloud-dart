import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Tournament", () {
    var _divSetId = "testDivSet";
    var _tournamentCode = "testTournament";
    var _leaderboardId = "testTournamentLeaderboard";
    var _version = 0;

    test("joinTournament()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .joinTournament(
              leaderboardId: _leaderboardId,
              tournamentCode: _tournamentCode,
              initialScore: 0);

      if (response.reasonCode ==
          ReasonCodes.playerAlreadyTournamentForLeaderboard) {
        print("Already Joined Tournament");
      } else {
        expect(response.statusCode, StatusCodes.ok);
      }
    });

    test("getTournamentStatus()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .getTournamentStatus(leaderboardId: _leaderboardId, versionId: -1);

      _version = response.data?["versionId"];
      print("Verison: $_version");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getDivisionInfo()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .getDivisionInfo(divSetId: _divSetId);

      expect(response.statusCode, StatusCodes.badRequest);
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
              initialScore: 0);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("leaveDivisionInstance()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .leaveDivisionInstance(divisionSetInstance: _divSetId);

      expect(response.statusCode, StatusCodes.internalServerError);
    });

    test("claimTournamentReward()", retry: 2, () async {
      ServerResponse response =
          await bcTest.bcWrapper.tournamentService.claimTournamentReward(
        leaderboardId: _leaderboardId,
        versionId: _version,
      );

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("postTournamentScore()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.tournamentService.postTournamentScoreUTC(
        leaderboardId: _leaderboardId,
        score: 200,
        data: {"test": "test"},
        roundStartTimeUTC: DateTime.now().millisecondsSinceEpoch,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postTournamentScoreWithresponses()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .postTournamentScoreWithResultsUTC(
              leaderboardId: _leaderboardId,
              score: 200,
              data: {"test": "test"},
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
          .viewReward(leaderboardId: _leaderboardId, versionId: _version);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("leaveTournament()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .leaveTournament(leaderboardId: _leaderboardId);

      expect(response.statusCode, StatusCodes.ok);
    });
  });

  group("Test Group Tournament", () {
    var _groupLeaderboardId = "groupTournament";
    var _divSetId = "bronzeGroup";
    var _tournamentCode = "testGroupTournament";
    String? _groupId;
    String? _joinedDivisionLeaderboardId;

    setUpAll(() async {
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "DartTestGroup",
          groupType: "csharpTest",
          isOpenGroup: true,
          data: {"test": "asdf"});
      expect(response.statusCode, StatusCodes.ok,
          reason: "Failed to create test group for group tournament tests");
      _groupId = response.data?["groupId"] as String?;
      expect(_groupId, isNotEmpty,
          reason: "Failed to get groupId from create group response");
    });

    tearDownAll(() async {
      if (_groupId != null && _groupId!.isNotEmpty) {
        await bcTest.bcWrapper.groupService
            .deleteGroup(groupId: _groupId!, version: -1);
      }
    });

    test("getGroupDivisionInfo()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .getGroupDivisionInfo(divSetId: _divSetId, groupId: _groupId!);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupDivisions()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .getGroupDivisions(groupId: _groupId!);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getGroupTournamentStatus()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .getGroupTournamentStatus(
              leaderboardId: _groupLeaderboardId,
              groupId: _groupId!,
              versionId: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("joinGroupDivision()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .joinGroupDivision(
              divSetId: _divSetId,
              tournamentCode: _tournamentCode,
              groupId: _groupId!,
              initialScore: 0);

      expect(response.statusCode, StatusCodes.ok);

      _joinedDivisionLeaderboardId =
          response.data?["leaderboardId"] as String? ?? "";
      expect(_joinedDivisionLeaderboardId, isNotEmpty,
          reason: "Error reading joinGroupDivision response leaderboardId");
    });

    test("leaveGroupDivisionInstance()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .leaveGroupDivisionInstance(
              leaderboardId: _joinedDivisionLeaderboardId!, groupId: _groupId!);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("joinGroupTournament()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .joinGroupTournament(
              leaderboardId: _groupLeaderboardId,
              tournamentCode: _tournamentCode,
              groupId: _groupId!,
              initialScore: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postGroupTournamentScore()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .postGroupTournamentScore(
              leaderboardId: _groupLeaderboardId,
              groupId: _groupId!,
              score: 10,
              data: {},
              roundStartedEpoch: DateTime.now().millisecondsSinceEpoch);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("postGroupTournamentScoreWithResults()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .postGroupTournamentScoreWithResults(
              leaderboardId: _groupLeaderboardId,
              groupId: _groupId!,
              score: 100,
              data: {},
              roundStartTimeUTC: DateTime.now().millisecondsSinceEpoch,
              sort: SortOrder.HIGH_TO_LOW,
              beforeCount: 10,
              afterCount: 10,
              initialScore: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("leaveGroupTournament()", () async {
      ServerResponse response = await bcTest.bcWrapper.tournamentService
          .leaveGroupTournament(
              leaderboardId: _groupLeaderboardId, groupId: _groupId!);

      expect(response.statusCode, StatusCodes.ok);
    });
    
    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
