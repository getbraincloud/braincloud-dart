import 'dart:async';

import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Lobby", () {

    //attempt at debugging why timeout when running in Jenkins
    setUpAll(() {
      // bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      });

    test("findLobby()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService.findLobby(
          lobbyType: "MATCH_UNRANKED",
          rating: 0,
          maxSteps: 1,
          algo: {
            "strategy": "ranged-absolute",
            "alignment": "center",
            "ranges": [1000]
          },
          extraJson: {},
          isReady: true,
          teamCode: "all");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("createLobby()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService.createLobby(
          lobbyType: "MATCH_UNRANKED",
          rating: 0,
          isReady: true,
          extraJson: {},
          settings: {},
          teamCode: "all");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("findOrCreateLobby()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.lobbyService.findOrCreateLobby(
              lobbyType: "MATCH_UNRANKED",
              rating: 0,
              maxSteps: 1,
              algo: {
                "strategy": "ranged-absolute",
                "alignment": "center",
                "ranges": [1000]
              },
              isReady: true,
              extraJson: {},
              settings: {},
              teamCode: "all");

      expect(response.statusCode, StatusCodes.ok);
    });

    ///*

    test("getLobbyData()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .getLobbyData(lobbyId: "wrongLobbyId");
      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("leaveLobby()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .leaveLobby(lobbyId: "wrongLobbyId");

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("joinLobby()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService.joinLobby(
        lobbyId: "wrongLobbyId",
        isReady: true,
        teamCode: "red",
        extraJson: {},
      );

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("removeMember()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .removeMember(lobbyId: "wrongLobbyId", connectionId: "wrongConId");
      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("sendSignal()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .sendSignal(lobbyId: "wrongLobbyId", signalData: {"msg": "test"});
      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("switchTeam()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .switchTeam(lobbyId: "wrongLobbyId", toTeamCode: "all");
      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("updateReady()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .updateReady(lobbyId: "wrongLobbyId", isReady: true, extraJson: {});
      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("updateSettings()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .updateSettings(lobbyId: "wrongLobbyId", settings: {"test": "me"});
      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("cancelFindRequest()", () async {

      final Completer completer = Completer();
      bcTest.bcWrapper.rttService.enableRTT( successCallback: (RTTCommandResponse response){
      expect(response.data?['operation'], "CONNECT",
          reason: "Expecting \"CONNECT\"");        
          completer.complete();
      }, failureCallback: (response) {
        fail("Enable RTT failed with error $response");
      },);

      await completer.future;

      ServerResponse response = await bcTest.bcWrapper.lobbyService.findLobby(
          lobbyType: "MATCH_UNRANKED",
          rating: 0,
          maxSteps: 1,
          algo: {
            "strategy": "ranged-absolute",
            "alignment": "center",
            "ranges": [1000]
          },
          extraJson: {},
          isReady: true,
          teamCode: "all");

      String entryId = response.data?['entryId'] ?? "";

      ServerResponse lobbyResponse = await bcTest.bcWrapper.lobbyService
          .cancelFindRequest(lobbyType: "MATCH_UNRANKED",entryId: entryId);

      expect(lobbyResponse.statusCode, StatusCodes.ok);
    });

    // This should fail because we didn't get the regions yet
    test("pingRegions()", () async {
      var pingResponse = await bcTest.bcWrapper.lobbyService.pingRegions();
      expect(pingResponse.statusCode, StatusCodes.badRequest);
    });

    // Trying to call a function <>withPingData without having fetched pings
    test("findOrCreateLobbyWithPingData() without pings", () async {
      ServerResponse response =
          await bcTest.bcWrapper.lobbyService.findOrCreateLobbyWithPingData(
              lobbyType: "MATCH_UNRANKED",
              rating: 0,
              maxSteps: 1,
              algo: {
                "strategy": "ranged-absolute",
                "alignment": "center",
                "ranges": [1000]
              },
              isReady: true,
              extraJson: {},
              settings: {},
              teamCode: "all");

      expect(response.statusCode, StatusCodes.badRequest,
          reason: "Expecting StatusCodes.badRequest");
      expect(response.reasonCode, ReasonCodes.missingRequiredParameter,
          reason: "Expecting MISSING_REQUIRED_PARAMETER");
    });

    test("getRegionsForLobbies()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .getRegionsForLobbies(lobbyTypes: ["MATCH_UNRANKED"]);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getLobbyInstances()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .getLobbyInstances(lobbyType: "MATCH_UNRANKED", criteriaJson: {
        "rating": {"min": 1, "max": 1000}
      });
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getLobbyInstancesWithPingData()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .getRegionsForLobbies(lobbyTypes: ["MATCH_UNRANKED"]);

      expect(response.statusCode, StatusCodes.ok);

      var pingResponse = await bcTest.bcWrapper.lobbyService.pingRegions();

      expect(pingResponse.statusCode, StatusCodes.ok);

      ServerResponse lobbyResponse = await bcTest.bcWrapper.lobbyService
          .getLobbyInstancesWithPingData(
              lobbyType: "MATCH_UNRANKED",
              criteriaJson: {
            "rating": {"min": 1, "max": 1000},
            "ping": {"max": 200}
          });
      expect(lobbyResponse.statusCode, StatusCodes.ok);
    });

    test("pingRegions()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .getRegionsForLobbies(lobbyTypes: ["MATCH_UNRANKED"]);

      expect(response.statusCode, StatusCodes.ok);

      var pingResponse = await bcTest.bcWrapper.lobbyService.pingRegions();

      expect(pingResponse.statusCode, StatusCodes.ok, reason: "Expecting 200");
      
      // Do it again to make sure things are not cached and resulted pings not too low.
      // We ping in different regions so it shouldn't be < 10ms
      pingResponse = await bcTest.bcWrapper.lobbyService.pingRegions();

      expect(pingResponse.statusCode, StatusCodes.ok, reason: "Expecting 200");
      
      double avg = pingResponse.data?.entries
          .map((entry) => entry.value)
          .reduce((a, b) => a + b);

      avg /= pingResponse.data?.length ?? 0;

      expect(avg, greaterThan(pingResponse.data?.length ?? 0),
          reason: "Pings too small. Cached HTTP requests?");
    });

    //Call all the <>WithPingData functions and make sure they go through braincloud
    test("WithPingData()", () async {
      ServerResponse response = await bcTest.bcWrapper.lobbyService
          .getRegionsForLobbies(lobbyTypes: ["MATCH_UNRANKED"]);

      expect(response.statusCode, StatusCodes.ok, reason: "Expecting 200");
      response = await bcTest.bcWrapper.lobbyService.pingRegions();

      expect(response.statusCode, StatusCodes.ok, reason: "Expecting 200");

      response =
          await bcTest.bcWrapper.lobbyService.findOrCreateLobbyWithPingData(
              lobbyType: "MATCH_UNRANKED",
              rating: 0,
              maxSteps: 1,
              algo: {
                "strategy": "ranged-absolute",
                "alignment": "center",
                "ranges": [1000]
              },
              settings: {},
              extraJson: {},
              isReady: true,
              filterJson: {},
              teamCode: "all");

      expect(response.statusCode, StatusCodes.ok, reason: "Expecting 200");

      response = await bcTest.bcWrapper.lobbyService.joinLobbyWithPingData(
          lobbyId: "wrongLobbyId",
          isReady: true,
          extraJson: {},
          teamCode: "red");

      expect(response.statusCode, StatusCodes.badRequest,
          reason: "Expecting bc.statusCodes.BAD_REQUEST");

      response = await bcTest.bcWrapper.lobbyService.findLobbyWithPingData(
          lobbyType: "MATCH_UNRANKED",
          rating: 0,
          maxSteps: 1,
          algo: {
            "strategy": "ranged-absolute",
            "alignment": "center",
            "ranges": [1000]
          },
          extraJson: {},
          isReady: true,
          filterJson: {},
          teamCode: "all");

      expect(response.statusCode, StatusCodes.ok, reason: "Expecting 200");

      response = await bcTest.bcWrapper.lobbyService.createLobbyWithPingData(
          lobbyType: "MATCH_UNRANKED",
          rating: 0,
          isReady: true,
          settings: {},
          teamCode: "all",
          extraJson: {});

      expect(response.statusCode, StatusCodes.ok, reason: "Expecting 200");
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
      // bcTest.bcWrapper.brainCloudClient.enableLogging(false);
    });
  });
}
