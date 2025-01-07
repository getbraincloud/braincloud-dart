import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Script", () {
    var scriptName = "emptyScript";
    var peerScriptName = "TestPeerScriptPublic";
    Map<String, dynamic> scriptData = {"testParam1": 1};

    test("runScript()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .runScript(scriptName: scriptName, scriptData: scriptData);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRunScriptMillisUTC()", retry: 2, () async {
      var today = DateTime.now();
      var tomorrow = today.add(Duration(days: 1));

      ServerResponse response = await bcTest.bcWrapper.scriptService
          .scheduleRunScriptMillisUTC(
              scriptName: scriptName,
              scriptData: scriptData,
              startDateUTC: tomorrow.millisecondsSinceEpoch);

      expect(response.statusCode, StatusCodes.ok);
    });

    var jobId = "";

    test("scheduleRunScriptMinutes()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .scheduleRunScriptMinutes(
              scriptName: scriptName,
              scriptData: scriptData,
              minutesFromNow: 60);

      jobId = response.data?["jobId"];
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
              scriptData: scriptData,
              peer: bcTest.ids.peerName);

      expect(response.statusCode, StatusCodes.ok,
          reason: response.error);
    });

    test("runPeerScriptAsync()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .runPeerScriptAsync(
              scriptName: peerScriptName,
              scriptData: scriptData,
              peer: bcTest.ids.peerName);

      expect(response.statusCode, StatusCodes.ok,
          reason: response.error);
    });

    test("getScheduledCloudScripts()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.scriptService
          .getScheduledCloudScripts(
              startDateUTC: DateTime.now().add(Duration(minutes: 30)));
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getRunningOrQueuedCloudScripts()", retry: 2, () async {
      ServerResponse response =
          await bcTest.bcWrapper.scriptService.getRunningOrQueuedCloudScripts();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("runParentScript()", retry: 2, () async {
      ServerResponse response =
          await bcTest.bcWrapper.scriptService.runParentScript(parentLevel: "Invalid",scriptName:"None");
      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.missingGameParent); 

    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
