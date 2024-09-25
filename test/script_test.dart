import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';
import 'utils/test_users.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Script", () {
    TestUser userA = TestUser("UserA", generateRandomString(8));
    TestUser userB = TestUser("UserB", generateRandomString(8));

    setUp(() async {
      if (bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.logout();
      }

      ServerResponse userA_response = await bcTest.bcWrapper
          .authenticateUniversal(
              username: userA.name,
              password: userA.password,
              forceCreate: true);

      userA.profileId = userA_response.body?["profileId"];

      ServerResponse userB_response = await bcTest.bcWrapper
          .authenticateUniversal(
              username: userB.name,
              password: userB.password,
              forceCreate: true);

      userB.profileId = userB_response.body?["profileId"];
    });

    var scriptName = "testScript";
    var peerScriptName = "TestPeerScriptPublic";
    Map<String, dynamic> scriptData = {"testParam1": 1};

    test("runScript()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService.runScript(
          scriptName: scriptName, jsonScriptData: jsonEncode(scriptData));
      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRunScriptMillisUTC()", retry: 2, () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      ServerResponse response = await bcTest.bcWrapper.scriptService
          .scheduleRunScriptMillisUTC(
              scriptName: scriptName,
              jsonScriptData: jsonEncode(scriptData),
              roundStartTimeUTC: tomorrow.millisecondsSinceEpoch);

      expect(response.statusCode, StatusCodes.ok);
    });

    var jobId = "";

    test("scheduleRunScriptMinutes()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .scheduleRunScriptMinutes(
              scriptName: scriptName,
              jsonScriptData: jsonEncode(scriptData),
              minutesFromNow: 60);

      jobId = response.body?["data"]["jobId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("cancelScheduledScript()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .cancelScheduledScript(jobId: jobId);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("attachPeerProfile()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .attachPeerProfile(
              peer: bcTest.ids.peerName,
              externalId: userA.name,
              authenticationToken: userA.password,
              authenticationType: AuthenticationType.universal,
              forceCreate: true);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("runPeerScript()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .runPeerScript(
              scriptName: peerScriptName,
              jsonScriptData: jsonEncode(scriptData),
              peer: bcTest.ids.peerName);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("runPeerScriptAsync()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .runPeerScriptAsync(
              scriptName: peerScriptName,
              jsonScriptData: jsonEncode(scriptData),
              peer: bcTest.ids.peerName);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("detachPeer()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .detachPeer(peer: bcTest.ids.peerName);
      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDown(() {
      bcTest.dispose();
    });
  });
}
