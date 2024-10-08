import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Script", () {
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

    test("runPeerScript()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .runPeerScript(
              scriptName: peerScriptName,
              jsonScriptData: jsonEncode(scriptData),
              peer: bcTest.ids.peerName);

      expect(response.statusCode, StatusCodes.ok,
          reason: response.statusMessage);
    });

    test("runPeerScriptAsync()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .runPeerScriptAsync(
              scriptName: peerScriptName,
              jsonScriptData: jsonEncode(scriptData),
              peer: bcTest.ids.peerName);

      expect(response.statusCode, StatusCodes.ok,
          reason: response.statusMessage);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
